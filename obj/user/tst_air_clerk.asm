
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 e7 05 00 00       	call   80061d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 75 20 00 00       	call   8020be <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 15 37 80 00       	mov    $0x803715,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 1f 37 80 00       	mov    $0x80371f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb 2b 37 80 00       	mov    $0x80372b,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb 3a 37 80 00       	mov    $0x80373a,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb 49 37 80 00       	mov    $0x803749,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb 5e 37 80 00       	mov    $0x80375e,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 73 37 80 00       	mov    $0x803773,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 84 37 80 00       	mov    $0x803784,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 95 37 80 00       	mov    $0x803795,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb a6 37 80 00       	mov    $0x8037a6,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb af 37 80 00       	mov    $0x8037af,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb b9 37 80 00       	mov    $0x8037b9,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb c4 37 80 00       	mov    $0x8037c4,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb d0 37 80 00       	mov    $0x8037d0,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb da 37 80 00       	mov    $0x8037da,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb e4 37 80 00       	mov    $0x8037e4,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb f2 37 80 00       	mov    $0x8037f2,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 01 38 80 00       	mov    $0x803801,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 08 38 80 00       	mov    $0x803808,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 76 19 00 00       	call   801ba0 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 61 19 00 00       	call   801ba0 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 4c 19 00 00       	call   801ba0 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 34 19 00 00       	call   801ba0 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 1c 19 00 00       	call   801ba0 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 04 19 00 00       	call   801ba0 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 ec 18 00 00       	call   801ba0 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 d4 18 00 00       	call   801ba0 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 bc 18 00 00       	call   801ba0 <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)

	while(1==1)
	{
		int custId;
		//wait for a customer
		sys_waitSemaphore(parentenvID, _cust_ready);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	e8 63 1c 00 00       	call   801f5f <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 4e 1c 00 00       	call   801f5f <sys_waitSemaphore>
  800311:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800314:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800320:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  80032a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80032d:	8b 00                	mov    (%eax),%eax
  80032f:	8d 50 01             	lea    0x1(%eax),%edx
  800332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800335:	89 10                	mov    %edx,(%eax)
		}
		sys_signalSemaphore(parentenvID, _custQueueCS);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	ff 75 e4             	pushl  -0x1c(%ebp)
  800344:	e8 34 1c 00 00       	call   801f7d <sys_signalSemaphore>
  800349:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80034c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  800360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800363:	83 f8 02             	cmp    $0x2,%eax
  800366:	0f 84 90 00 00 00    	je     8003fc <_main+0x3c4>
  80036c:	83 f8 03             	cmp    $0x3,%eax
  80036f:	0f 84 05 01 00 00    	je     80047a <_main+0x442>
  800375:	83 f8 01             	cmp    $0x1,%eax
  800378:	0f 85 f8 01 00 00    	jne    800576 <_main+0x53e>
		{
		case 1:
		{
			//Check and update Flight1
			sys_waitSemaphore(parentenvID, _flight1CS);
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038b:	e8 cf 1b 00 00       	call   801f5f <sys_waitSemaphore>
  800390:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  800393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 46                	jle    8003e2 <_main+0x3aa>
				{
					*flight1Counter = *flight1Counter - 1;
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8003a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a7:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8003a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8003bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8003d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight1CS);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  8003eb:	50                   	push   %eax
  8003ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ef:	e8 89 1b 00 00       	call   801f7d <sys_signalSemaphore>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}

		break;
  8003f7:	e9 91 01 00 00       	jmp    80058d <_main+0x555>
		case 2:
		{
			//Check and update Flight2
			sys_waitSemaphore(parentenvID, _flight2CS);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	ff 75 e4             	pushl  -0x1c(%ebp)
  800409:	e8 51 1b 00 00       	call   801f5f <sys_waitSemaphore>
  80040e:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	85 c0                	test   %eax,%eax
  800418:	7e 46                	jle    800460 <_main+0x428>
				{
					*flight2Counter = *flight2Counter - 1;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800427:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80042a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	01 d0                	add    %edx,%eax
  800436:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80043d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044c:	01 c2                	add    %eax,%edx
  80044e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800451:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  800453:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 01             	lea    0x1(%eax),%edx
  80045b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046d:	e8 0b 1b 00 00       	call   801f7d <sys_signalSemaphore>
  800472:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800475:	e9 13 01 00 00       	jmp    80058d <_main+0x555>
		case 3:
		{
			//Check and update Both Flights
			sys_waitSemaphore(parentenvID, _flight1CS); sys_waitSemaphore(parentenvID, _flight2CS);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800483:	50                   	push   %eax
  800484:	ff 75 e4             	pushl  -0x1c(%ebp)
  800487:	e8 d3 1a 00 00       	call   801f5f <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 be 1a 00 00       	call   801f5f <sys_waitSemaphore>
  8004a1:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	0f 8e 99 00 00 00    	jle    80054a <_main+0x512>
  8004b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	0f 8e 8c 00 00 00    	jle    80054a <_main+0x512>
				{
					*flight1Counter = *flight1Counter - 1;
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f0:	01 c2                	add    %eax,%edx
  8004f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004f5:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 01             	lea    0x1(%eax),%edx
  8004ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80050c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800511:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800514:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800527:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800536:	01 c2                	add    %eax,%edx
  800538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80053b:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80053d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS); sys_signalSemaphore(parentenvID, _flight1CS);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800553:	50                   	push   %eax
  800554:	ff 75 e4             	pushl  -0x1c(%ebp)
  800557:	e8 21 1a 00 00       	call   801f7d <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 0c 1a 00 00       	call   801f7d <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 e0 36 80 00       	push   $0x8036e0
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 00 37 80 00       	push   $0x803700
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb 0f 38 80 00       	mov    $0x80380f,%ebx
  800598:	ba 0e 00 00 00       	mov    $0xe,%edx
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	89 de                	mov    %ebx,%esi
  8005a1:	89 d1                	mov    %edx,%ecx
  8005a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a5:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8005ab:	b9 04 00 00 00       	mov    $0x4,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8005c6:	e8 6a 0f 00 00       	call   801535 <ltostr>
  8005cb:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8005e5:	50                   	push   %eax
  8005e6:	e8 42 10 00 00       	call   80162d <strcconcat>
  8005eb:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore(parentenvID, sname);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005f7:	50                   	push   %eax
  8005f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005fb:	e8 7d 19 00 00       	call   801f7d <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 68 19 00 00       	call   801f7d <sys_signalSemaphore>
  800615:	83 c4 10             	add    $0x10,%esp
	}
  800618:	e9 cd fc ff ff       	jmp    8002ea <_main+0x2b2>

0080061d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800623:	e8 7d 1a 00 00       	call   8020a5 <sys_getenvindex>
  800628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	c1 e0 03             	shl    $0x3,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800640:	01 d0                	add    %edx,%eax
  800642:	c1 e0 04             	shl    $0x4,%eax
  800645:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80064a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80064f:	a1 20 50 80 00       	mov    0x805020,%eax
  800654:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80065a:	84 c0                	test   %al,%al
  80065c:	74 0f                	je     80066d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80065e:	a1 20 50 80 00       	mov    0x805020,%eax
  800663:	05 5c 05 00 00       	add    $0x55c,%eax
  800668:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80066d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800671:	7e 0a                	jle    80067d <libmain+0x60>
		binaryname = argv[0];
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 08             	pushl  0x8(%ebp)
  800686:	e8 ad f9 ff ff       	call   800038 <_main>
  80068b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80068e:	e8 1f 18 00 00       	call   801eb2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 48 38 80 00       	push   $0x803848
  80069b:	e8 6d 03 00 00       	call   800a0d <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	68 70 38 80 00       	push   $0x803870
  8006c3:	e8 45 03 00 00       	call   800a0d <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006e6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006ec:	51                   	push   %ecx
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	68 98 38 80 00       	push   $0x803898
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 f0 38 80 00       	push   $0x8038f0
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 48 38 80 00       	push   $0x803848
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 9f 17 00 00       	call   801ecc <sys_enable_interrupt>

	// exit gracefully
	exit();
  80072d:	e8 19 00 00 00       	call   80074b <exit>
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 00                	push   $0x0
  800740:	e8 2c 19 00 00       	call   802071 <sys_destroy_env>
  800745:	83 c4 10             	add    $0x10,%esp
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <exit>:

void
exit(void)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800751:	e8 81 19 00 00       	call   8020d7 <sys_exit_env>
}
  800756:	90                   	nop
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80075f:	8d 45 10             	lea    0x10(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800768:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80076d:	85 c0                	test   %eax,%eax
  80076f:	74 16                	je     800787 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800771:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 04 39 80 00       	push   $0x803904
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 09 39 80 00       	push   $0x803909
  800798:	e8 70 02 00 00       	call   800a0d <cprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a9:	50                   	push   %eax
  8007aa:	e8 f3 01 00 00       	call   8009a2 <vcprintf>
  8007af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	6a 00                	push   $0x0
  8007b7:	68 25 39 80 00       	push   $0x803925
  8007bc:	e8 e1 01 00 00       	call   8009a2 <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007c4:	e8 82 ff ff ff       	call   80074b <exit>

	// should not return here
	while (1) ;
  8007c9:	eb fe                	jmp    8007c9 <_panic+0x70>

008007cb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007d6:	8b 50 74             	mov    0x74(%eax),%edx
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	74 14                	je     8007f4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e0:	83 ec 04             	sub    $0x4,%esp
  8007e3:	68 28 39 80 00       	push   $0x803928
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 74 39 80 00       	push   $0x803974
  8007ef:	e8 65 ff ff ff       	call   800759 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800802:	e9 c2 00 00 00       	jmp    8008c9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	85 c0                	test   %eax,%eax
  80081a:	75 08                	jne    800824 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80081c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80081f:	e9 a2 00 00 00       	jmp    8008c6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80082b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800832:	eb 69                	jmp    80089d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80083f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800842:	89 d0                	mov    %edx,%eax
  800844:	01 c0                	add    %eax,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	c1 e0 03             	shl    $0x3,%eax
  80084b:	01 c8                	add    %ecx,%eax
  80084d:	8a 40 04             	mov    0x4(%eax),%al
  800850:	84 c0                	test   %al,%al
  800852:	75 46                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800854:	a1 20 50 80 00       	mov    0x805020,%eax
  800859:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	01 c0                	add    %eax,%eax
  800866:	01 d0                	add    %edx,%eax
  800868:	c1 e0 03             	shl    $0x3,%eax
  80086b:	01 c8                	add    %ecx,%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	01 c8                	add    %ecx,%eax
  80088b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088d:	39 c2                	cmp    %eax,%edx
  80088f:	75 09                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800891:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800898:	eb 12                	jmp    8008ac <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089a:	ff 45 e8             	incl   -0x18(%ebp)
  80089d:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a2:	8b 50 74             	mov    0x74(%eax),%edx
  8008a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	77 88                	ja     800834 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b0:	75 14                	jne    8008c6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 80 39 80 00       	push   $0x803980
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 74 39 80 00       	push   $0x803974
  8008c1:	e8 93 fe ff ff       	call   800759 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c6:	ff 45 f0             	incl   -0x10(%ebp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cf:	0f 8c 32 ff ff ff    	jl     800807 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e3:	eb 26                	jmp    80090b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8008ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	01 c0                	add    %eax,%eax
  8008f7:	01 d0                	add    %edx,%eax
  8008f9:	c1 e0 03             	shl    $0x3,%eax
  8008fc:	01 c8                	add    %ecx,%eax
  8008fe:	8a 40 04             	mov    0x4(%eax),%al
  800901:	3c 01                	cmp    $0x1,%al
  800903:	75 03                	jne    800908 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800905:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800908:	ff 45 e0             	incl   -0x20(%ebp)
  80090b:	a1 20 50 80 00       	mov    0x805020,%eax
  800910:	8b 50 74             	mov    0x74(%eax),%edx
  800913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	77 cb                	ja     8008e5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80091a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800920:	74 14                	je     800936 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	68 d4 39 80 00       	push   $0x8039d4
  80092a:	6a 44                	push   $0x44
  80092c:	68 74 39 80 00       	push   $0x803974
  800931:	e8 23 fe ff ff       	call   800759 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800936:	90                   	nop
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 48 01             	lea    0x1(%eax),%ecx
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	89 0a                	mov    %ecx,(%edx)
  80094c:	8b 55 08             	mov    0x8(%ebp),%edx
  80094f:	88 d1                	mov    %dl,%cl
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800962:	75 2c                	jne    800990 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800964:	a0 24 50 80 00       	mov    0x805024,%al
  800969:	0f b6 c0             	movzbl %al,%eax
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096f:	8b 12                	mov    (%edx),%edx
  800971:	89 d1                	mov    %edx,%ecx
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	83 c2 08             	add    $0x8,%edx
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	50                   	push   %eax
  80097d:	51                   	push   %ecx
  80097e:	52                   	push   %edx
  80097f:	e8 80 13 00 00       	call   801d04 <sys_cputs>
  800984:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 40 04             	mov    0x4(%eax),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b2:	00 00 00 
	b.cnt = 0;
  8009b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 39 09 80 00       	push   $0x800939
  8009d1:	e8 11 02 00 00       	call   800be7 <vprintfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d9:	a0 24 50 80 00       	mov    0x805024,%al
  8009de:	0f b6 c0             	movzbl %al,%eax
  8009e1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	50                   	push   %eax
  8009eb:	52                   	push   %edx
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	50                   	push   %eax
  8009f6:	e8 09 13 00 00       	call   801d04 <sys_cputs>
  8009fb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009fe:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a05:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <cprintf>:

int cprintf(const char *fmt, ...) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a13:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	e8 73 ff ff ff       	call   8009a2 <vcprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a40:	e8 6d 14 00 00       	call   801eb2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a45:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	e8 48 ff ff ff       	call   8009a2 <vcprintf>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a60:	e8 67 14 00 00       	call   801ecc <sys_enable_interrupt>
	return cnt;
  800a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	53                   	push   %ebx
  800a6e:	83 ec 14             	sub    $0x14,%esp
  800a71:	8b 45 10             	mov    0x10(%ebp),%eax
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a7d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a88:	77 55                	ja     800adf <printnum+0x75>
  800a8a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a8d:	72 05                	jb     800a94 <printnum+0x2a>
  800a8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a92:	77 4b                	ja     800adf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a94:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a97:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a9a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa2:	52                   	push   %edx
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aaa:	e8 cd 29 00 00       	call   80347c <__udivdi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	83 ec 04             	sub    $0x4,%esp
  800ab5:	ff 75 20             	pushl  0x20(%ebp)
  800ab8:	53                   	push   %ebx
  800ab9:	ff 75 18             	pushl  0x18(%ebp)
  800abc:	52                   	push   %edx
  800abd:	50                   	push   %eax
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 a1 ff ff ff       	call   800a6a <printnum>
  800ac9:	83 c4 20             	add    $0x20,%esp
  800acc:	eb 1a                	jmp    800ae8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 20             	pushl  0x20(%ebp)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800adf:	ff 4d 1c             	decl   0x1c(%ebp)
  800ae2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae6:	7f e6                	jg     800ace <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	53                   	push   %ebx
  800af7:	51                   	push   %ecx
  800af8:	52                   	push   %edx
  800af9:	50                   	push   %eax
  800afa:	e8 8d 2a 00 00       	call   80358c <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 34 3c 80 00       	add    $0x803c34,%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f be c0             	movsbl %al,%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	50                   	push   %eax
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
}
  800b1b:	90                   	nop
  800b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b24:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b28:	7e 1c                	jle    800b46 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 50 08             	lea    0x8(%eax),%edx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 10                	mov    %edx,(%eax)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	83 e8 08             	sub    $0x8,%eax
  800b3f:	8b 50 04             	mov    0x4(%eax),%edx
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	eb 40                	jmp    800b86 <getuint+0x65>
	else if (lflag)
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	74 1e                	je     800b6a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 04             	lea    0x4(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	ba 00 00 00 00       	mov    $0x0,%edx
  800b68:	eb 1c                	jmp    800b86 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	8d 50 04             	lea    0x4(%eax),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 10                	mov    %edx,(%eax)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8f:	7e 1c                	jle    800bad <getint+0x25>
		return va_arg(*ap, long long);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 08             	lea    0x8(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 08             	sub    $0x8,%eax
  800ba6:	8b 50 04             	mov    0x4(%eax),%edx
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	eb 38                	jmp    800be5 <getint+0x5d>
	else if (lflag)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 1a                	je     800bcd <getint+0x45>
		return va_arg(*ap, long);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 04             	lea    0x4(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	99                   	cltd   
  800bcb:	eb 18                	jmp    800be5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	99                   	cltd   
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bef:	eb 17                	jmp    800c08 <vprintfmt+0x21>
			if (ch == '\0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	0f 84 af 03 00 00    	je     800fa8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	53                   	push   %ebx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	83 fb 25             	cmp    $0x25,%ebx
  800c19:	75 d6                	jne    800bf1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c26:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 d8             	movzbl %al,%ebx
  800c49:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c4c:	83 f8 55             	cmp    $0x55,%eax
  800c4f:	0f 87 2b 03 00 00    	ja     800f80 <vprintfmt+0x399>
  800c55:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
  800c5c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c62:	eb d7                	jmp    800c3b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c68:	eb d1                	jmp    800c3b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c74:	89 d0                	mov    %edx,%eax
  800c76:	c1 e0 02             	shl    $0x2,%eax
  800c79:	01 d0                	add    %edx,%eax
  800c7b:	01 c0                	add    %eax,%eax
  800c7d:	01 d8                	add    %ebx,%eax
  800c7f:	83 e8 30             	sub    $0x30,%eax
  800c82:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c8d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c90:	7e 3e                	jle    800cd0 <vprintfmt+0xe9>
  800c92:	83 fb 39             	cmp    $0x39,%ebx
  800c95:	7f 39                	jg     800cd0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c97:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9a:	eb d5                	jmp    800c71 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 c0 04             	add    $0x4,%eax
  800ca2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cb0:	eb 1f                	jmp    800cd1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb6:	79 83                	jns    800c3b <vprintfmt+0x54>
				width = 0;
  800cb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cbf:	e9 77 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ccb:	e9 6b ff ff ff       	jmp    800c3b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cd0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd5:	0f 89 60 ff ff ff    	jns    800c3b <vprintfmt+0x54>
				width = precision, precision = -1;
  800cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce8:	e9 4e ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ced:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cf0:	e9 46 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 c0 04             	add    $0x4,%eax
  800cfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800d01:	83 e8 04             	sub    $0x4,%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	50                   	push   %eax
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	ff d0                	call   *%eax
  800d12:	83 c4 10             	add    $0x10,%esp
			break;
  800d15:	e9 89 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 e8 04             	sub    $0x4,%eax
  800d29:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	79 02                	jns    800d31 <vprintfmt+0x14a>
				err = -err;
  800d2f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d31:	83 fb 64             	cmp    $0x64,%ebx
  800d34:	7f 0b                	jg     800d41 <vprintfmt+0x15a>
  800d36:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 45 3c 80 00       	push   $0x803c45
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	ff 75 08             	pushl  0x8(%ebp)
  800d4d:	e8 5e 02 00 00       	call   800fb0 <printfmt>
  800d52:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d55:	e9 49 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5a:	56                   	push   %esi
  800d5b:	68 4e 3c 80 00       	push   $0x803c4e
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	ff 75 08             	pushl  0x8(%ebp)
  800d66:	e8 45 02 00 00       	call   800fb0 <printfmt>
  800d6b:	83 c4 10             	add    $0x10,%esp
			break;
  800d6e:	e9 30 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	83 c0 04             	add    $0x4,%eax
  800d79:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	83 e8 04             	sub    $0x4,%eax
  800d82:	8b 30                	mov    (%eax),%esi
  800d84:	85 f6                	test   %esi,%esi
  800d86:	75 05                	jne    800d8d <vprintfmt+0x1a6>
				p = "(null)";
  800d88:	be 51 3c 80 00       	mov    $0x803c51,%esi
			if (width > 0 && padc != '-')
  800d8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d91:	7e 6d                	jle    800e00 <vprintfmt+0x219>
  800d93:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d97:	74 67                	je     800e00 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	50                   	push   %eax
  800da0:	56                   	push   %esi
  800da1:	e8 0c 03 00 00       	call   8010b2 <strnlen>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dac:	eb 16                	jmp    800dc4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	ff d0                	call   *%eax
  800dbe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc1:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc8:	7f e4                	jg     800dae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	eb 34                	jmp    800e00 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd0:	74 1c                	je     800dee <vprintfmt+0x207>
  800dd2:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd5:	7e 05                	jle    800ddc <vprintfmt+0x1f5>
  800dd7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dda:	7e 12                	jle    800dee <vprintfmt+0x207>
					putch('?', putdat);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	6a 3f                	push   $0x3f
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	ff d0                	call   *%eax
  800de9:	83 c4 10             	add    $0x10,%esp
  800dec:	eb 0f                	jmp    800dfd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	53                   	push   %ebx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	ff d0                	call   *%eax
  800dfa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfd:	ff 4d e4             	decl   -0x1c(%ebp)
  800e00:	89 f0                	mov    %esi,%eax
  800e02:	8d 70 01             	lea    0x1(%eax),%esi
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f be d8             	movsbl %al,%ebx
  800e0a:	85 db                	test   %ebx,%ebx
  800e0c:	74 24                	je     800e32 <vprintfmt+0x24b>
  800e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e12:	78 b8                	js     800dcc <vprintfmt+0x1e5>
  800e14:	ff 4d e0             	decl   -0x20(%ebp)
  800e17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1b:	79 af                	jns    800dcc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1d:	eb 13                	jmp    800e32 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 20                	push   $0x20
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	7f e7                	jg     800e1f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e38:	e9 66 01 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 e8             	pushl  -0x18(%ebp)
  800e43:	8d 45 14             	lea    0x14(%ebp),%eax
  800e46:	50                   	push   %eax
  800e47:	e8 3c fd ff ff       	call   800b88 <getint>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5b:	85 d2                	test   %edx,%edx
  800e5d:	79 23                	jns    800e82 <vprintfmt+0x29b>
				putch('-', putdat);
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	ff 75 0c             	pushl  0xc(%ebp)
  800e65:	6a 2d                	push   $0x2d
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	ff d0                	call   *%eax
  800e6c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e75:	f7 d8                	neg    %eax
  800e77:	83 d2 00             	adc    $0x0,%edx
  800e7a:	f7 da                	neg    %edx
  800e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e89:	e9 bc 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 e8             	pushl  -0x18(%ebp)
  800e94:	8d 45 14             	lea    0x14(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	e8 84 fc ff ff       	call   800b21 <getuint>
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ead:	e9 98 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 58                	push   $0x58
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 58                	push   $0x58
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	6a 58                	push   $0x58
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	ff d0                	call   *%eax
  800edf:	83 c4 10             	add    $0x10,%esp
			break;
  800ee2:	e9 bc 00 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 30                	push   $0x30
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	6a 78                	push   $0x78
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 c0 04             	add    $0x4,%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 e8 04             	sub    $0x4,%eax
  800f16:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f22:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f29:	eb 1f                	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f31:	8d 45 14             	lea    0x14(%ebp),%eax
  800f34:	50                   	push   %eax
  800f35:	e8 e7 fb ff ff       	call   800b21 <getuint>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	52                   	push   %edx
  800f55:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f58:	50                   	push   %eax
  800f59:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	e8 00 fb ff ff       	call   800a6a <printnum>
  800f6a:	83 c4 20             	add    $0x20,%esp
			break;
  800f6d:	eb 34                	jmp    800fa3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	53                   	push   %ebx
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	ff d0                	call   *%eax
  800f7b:	83 c4 10             	add    $0x10,%esp
			break;
  800f7e:	eb 23                	jmp    800fa3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f80:	83 ec 08             	sub    $0x8,%esp
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	6a 25                	push   $0x25
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	ff d0                	call   *%eax
  800f8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f90:	ff 4d 10             	decl   0x10(%ebp)
  800f93:	eb 03                	jmp    800f98 <vprintfmt+0x3b1>
  800f95:	ff 4d 10             	decl   0x10(%ebp)
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	48                   	dec    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 25                	cmp    $0x25,%al
  800fa0:	75 f3                	jne    800f95 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fa2:	90                   	nop
		}
	}
  800fa3:	e9 47 fc ff ff       	jmp    800bef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb9:	83 c0 04             	add    $0x4,%eax
  800fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 16 fc ff ff       	call   800be7 <vprintfmt>
  800fd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd4:	90                   	nop
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8b 40 08             	mov    0x8(%eax),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	8b 10                	mov    (%eax),%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 40 04             	mov    0x4(%eax),%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	73 12                	jae    80100a <sprintputch+0x33>
		*b->buf++ = ch;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	8b 00                	mov    (%eax),%eax
  800ffd:	8d 48 01             	lea    0x1(%eax),%ecx
  801000:	8b 55 0c             	mov    0xc(%ebp),%edx
  801003:	89 0a                	mov    %ecx,(%edx)
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	88 10                	mov    %dl,(%eax)
}
  80100a:	90                   	nop
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80102e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801032:	74 06                	je     80103a <vsnprintf+0x2d>
  801034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801038:	7f 07                	jg     801041 <vsnprintf+0x34>
		return -E_INVAL;
  80103a:	b8 03 00 00 00       	mov    $0x3,%eax
  80103f:	eb 20                	jmp    801061 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801041:	ff 75 14             	pushl  0x14(%ebp)
  801044:	ff 75 10             	pushl  0x10(%ebp)
  801047:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	68 d7 0f 80 00       	push   $0x800fd7
  801050:	e8 92 fb ff ff       	call   800be7 <vprintfmt>
  801055:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80105b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801069:	8d 45 10             	lea    0x10(%ebp),%eax
  80106c:	83 c0 04             	add    $0x4,%eax
  80106f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	ff 75 f4             	pushl  -0xc(%ebp)
  801078:	50                   	push   %eax
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 89 ff ff ff       	call   80100d <vsnprintf>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 06                	jmp    8010a4 <strlen+0x15>
		n++;
  80109e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 f1                	jne    80109e <strlen+0xf>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010bf:	eb 09                	jmp    8010ca <strnlen+0x18>
		n++;
  8010c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	ff 4d 0c             	decl   0xc(%ebp)
  8010ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ce:	74 09                	je     8010d9 <strnlen+0x27>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e8                	jne    8010c1 <strnlen+0xf>
		n++;
	return n;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ea:	90                   	nop
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8d 50 01             	lea    0x1(%eax),%edx
  8010f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fd:	8a 12                	mov    (%edx),%dl
  8010ff:	88 10                	mov    %dl,(%eax)
  801101:	8a 00                	mov    (%eax),%al
  801103:	84 c0                	test   %al,%al
  801105:	75 e4                	jne    8010eb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80111f:	eb 1f                	jmp    801140 <strncpy+0x34>
		*dst++ = *src;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	89 55 08             	mov    %edx,0x8(%ebp)
  80112a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 03                	je     80113d <strncpy+0x31>
			src++;
  80113a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113d:	ff 45 fc             	incl   -0x4(%ebp)
  801140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801143:	3b 45 10             	cmp    0x10(%ebp),%eax
  801146:	72 d9                	jb     801121 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801159:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115d:	74 30                	je     80118f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80115f:	eb 16                	jmp    801177 <strlcpy+0x2a>
			*dst++ = *src++;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	89 55 08             	mov    %edx,0x8(%ebp)
  80116a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801170:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801173:	8a 12                	mov    (%edx),%dl
  801175:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801177:	ff 4d 10             	decl   0x10(%ebp)
  80117a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117e:	74 09                	je     801189 <strlcpy+0x3c>
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	75 d8                	jne    801161 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80119e:	eb 06                	jmp    8011a6 <strcmp+0xb>
		p++, q++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0e                	je     8011bd <strcmp+0x22>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 10                	mov    (%eax),%dl
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	38 c2                	cmp    %al,%dl
  8011bb:	74 e3                	je     8011a0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 d0             	movzbl %al,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	0f b6 c0             	movzbl %al,%eax
  8011cd:	29 c2                	sub    %eax,%edx
  8011cf:	89 d0                	mov    %edx,%eax
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011d6:	eb 09                	jmp    8011e1 <strncmp+0xe>
		n--, p++, q++;
  8011d8:	ff 4d 10             	decl   0x10(%ebp)
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e5:	74 17                	je     8011fe <strncmp+0x2b>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 0e                	je     8011fe <strncmp+0x2b>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 10                	mov    (%eax),%dl
  8011f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	38 c2                	cmp    %al,%dl
  8011fc:	74 da                	je     8011d8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801202:	75 07                	jne    80120b <strncmp+0x38>
		return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 14                	jmp    80121f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	0f b6 d0             	movzbl %al,%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 c0             	movzbl %al,%eax
  80121b:	29 c2                	sub    %eax,%edx
  80121d:	89 d0                	mov    %edx,%eax
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122d:	eb 12                	jmp    801241 <strchr+0x20>
		if (*s == c)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801237:	75 05                	jne    80123e <strchr+0x1d>
			return (char *) s;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	eb 11                	jmp    80124f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	84 c0                	test   %al,%al
  801248:	75 e5                	jne    80122f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80125d:	eb 0d                	jmp    80126c <strfind+0x1b>
		if (*s == c)
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801267:	74 0e                	je     801277 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	75 ea                	jne    80125f <strfind+0xe>
  801275:	eb 01                	jmp    801278 <strfind+0x27>
		if (*s == c)
			break;
  801277:	90                   	nop
	return (char *) s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80128f:	eb 0e                	jmp    80129f <memset+0x22>
		*p++ = c;
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	8d 50 01             	lea    0x1(%eax),%edx
  801297:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80129f:	ff 4d f8             	decl   -0x8(%ebp)
  8012a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012a6:	79 e9                	jns    801291 <memset+0x14>
		*p++ = c;

	return v;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012bf:	eb 16                	jmp    8012d7 <memcpy+0x2a>
		*d++ = *s++;
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d3:	8a 12                	mov    (%edx),%dl
  8012d5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 dd                	jne    8012c1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801301:	73 50                	jae    801353 <memmove+0x6a>
  801303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80130e:	76 43                	jbe    801353 <memmove+0x6a>
		s += n;
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80131c:	eb 10                	jmp    80132e <memmove+0x45>
			*--d = *--s;
  80131e:	ff 4d f8             	decl   -0x8(%ebp)
  801321:	ff 4d fc             	decl   -0x4(%ebp)
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	8a 10                	mov    (%eax),%dl
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	8d 50 ff             	lea    -0x1(%eax),%edx
  801334:	89 55 10             	mov    %edx,0x10(%ebp)
  801337:	85 c0                	test   %eax,%eax
  801339:	75 e3                	jne    80131e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80133b:	eb 23                	jmp    801360 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80134f:	8a 12                	mov    (%edx),%dl
  801351:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	8d 50 ff             	lea    -0x1(%eax),%edx
  801359:	89 55 10             	mov    %edx,0x10(%ebp)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	75 dd                	jne    80133d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801377:	eb 2a                	jmp    8013a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137c:	8a 10                	mov    (%eax),%dl
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	38 c2                	cmp    %al,%dl
  801385:	74 16                	je     80139d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 c0             	movzbl %al,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	eb 18                	jmp    8013b5 <memcmp+0x50>
		s1++, s2++;
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
  8013a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 c9                	jne    801379 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c8:	eb 15                	jmp    8013df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	0f b6 c0             	movzbl %al,%eax
  8013d8:	39 c2                	cmp    %eax,%edx
  8013da:	74 0d                	je     8013e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013dc:	ff 45 08             	incl   0x8(%ebp)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013e5:	72 e3                	jb     8013ca <memfind+0x13>
  8013e7:	eb 01                	jmp    8013ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e9:	90                   	nop
	return (void *) s;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801403:	eb 03                	jmp    801408 <strtol+0x19>
		s++;
  801405:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 20                	cmp    $0x20,%al
  80140f:	74 f4                	je     801405 <strtol+0x16>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 09                	cmp    $0x9,%al
  801418:	74 eb                	je     801405 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 2b                	cmp    $0x2b,%al
  801421:	75 05                	jne    801428 <strtol+0x39>
		s++;
  801423:	ff 45 08             	incl   0x8(%ebp)
  801426:	eb 13                	jmp    80143b <strtol+0x4c>
	else if (*s == '-')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 2d                	cmp    $0x2d,%al
  80142f:	75 0a                	jne    80143b <strtol+0x4c>
		s++, neg = 1;
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143f:	74 06                	je     801447 <strtol+0x58>
  801441:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801445:	75 20                	jne    801467 <strtol+0x78>
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3c 30                	cmp    $0x30,%al
  80144e:	75 17                	jne    801467 <strtol+0x78>
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	40                   	inc    %eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 78                	cmp    $0x78,%al
  801458:	75 0d                	jne    801467 <strtol+0x78>
		s += 2, base = 16;
  80145a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80145e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801465:	eb 28                	jmp    80148f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146b:	75 15                	jne    801482 <strtol+0x93>
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 30                	cmp    $0x30,%al
  801474:	75 0c                	jne    801482 <strtol+0x93>
		s++, base = 8;
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801480:	eb 0d                	jmp    80148f <strtol+0xa0>
	else if (base == 0)
  801482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801486:	75 07                	jne    80148f <strtol+0xa0>
		base = 10;
  801488:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 2f                	cmp    $0x2f,%al
  801496:	7e 19                	jle    8014b1 <strtol+0xc2>
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 39                	cmp    $0x39,%al
  80149f:	7f 10                	jg     8014b1 <strtol+0xc2>
			dig = *s - '0';
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f be c0             	movsbl %al,%eax
  8014a9:	83 e8 30             	sub    $0x30,%eax
  8014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014af:	eb 42                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 60                	cmp    $0x60,%al
  8014b8:	7e 19                	jle    8014d3 <strtol+0xe4>
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3c 7a                	cmp    $0x7a,%al
  8014c1:	7f 10                	jg     8014d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be c0             	movsbl %al,%eax
  8014cb:	83 e8 57             	sub    $0x57,%eax
  8014ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d1:	eb 20                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 40                	cmp    $0x40,%al
  8014da:	7e 39                	jle    801515 <strtol+0x126>
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	3c 5a                	cmp    $0x5a,%al
  8014e3:	7f 30                	jg     801515 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	0f be c0             	movsbl %al,%eax
  8014ed:	83 e8 37             	sub    $0x37,%eax
  8014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f9:	7d 19                	jge    801514 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014fb:	ff 45 08             	incl   0x8(%ebp)
  8014fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801501:	0f af 45 10          	imul   0x10(%ebp),%eax
  801505:	89 c2                	mov    %eax,%edx
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80150f:	e9 7b ff ff ff       	jmp    80148f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801514:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801515:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801519:	74 08                	je     801523 <strtol+0x134>
		*endptr = (char *) s;
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801523:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801527:	74 07                	je     801530 <strtol+0x141>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	f7 d8                	neg    %eax
  80152e:	eb 03                	jmp    801533 <strtol+0x144>
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <ltostr>:

void
ltostr(long value, char *str)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80153b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801542:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80154d:	79 13                	jns    801562 <ltostr+0x2d>
	{
		neg = 1;
  80154f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80155c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80155f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156a:	99                   	cltd   
  80156b:	f7 f9                	idiv   %ecx
  80156d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801579:	89 c2                	mov    %eax,%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801583:	83 c2 30             	add    $0x30,%edx
  801586:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801588:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801590:	f7 e9                	imul   %ecx
  801592:	c1 fa 02             	sar    $0x2,%edx
  801595:	89 c8                	mov    %ecx,%eax
  801597:	c1 f8 1f             	sar    $0x1f,%eax
  80159a:	29 c2                	sub    %eax,%edx
  80159c:	89 d0                	mov    %edx,%eax
  80159e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a9:	f7 e9                	imul   %ecx
  8015ab:	c1 fa 02             	sar    $0x2,%edx
  8015ae:	89 c8                	mov    %ecx,%eax
  8015b0:	c1 f8 1f             	sar    $0x1f,%eax
  8015b3:	29 c2                	sub    %eax,%edx
  8015b5:	89 d0                	mov    %edx,%eax
  8015b7:	c1 e0 02             	shl    $0x2,%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	01 c0                	add    %eax,%eax
  8015be:	29 c1                	sub    %eax,%ecx
  8015c0:	89 ca                	mov    %ecx,%edx
  8015c2:	85 d2                	test   %edx,%edx
  8015c4:	75 9c                	jne    801562 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	48                   	dec    %eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015d8:	74 3d                	je     801617 <ltostr+0xe2>
		start = 1 ;
  8015da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015e1:	eb 34                	jmp    801617 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801604:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 c2                	add    %eax,%edx
  80160c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80160f:	88 02                	mov    %al,(%edx)
		start++ ;
  801611:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801614:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161d:	7c c4                	jl     8015e3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80161f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801633:	ff 75 08             	pushl  0x8(%ebp)
  801636:	e8 54 fa ff ff       	call   80108f <strlen>
  80163b:	83 c4 04             	add    $0x4,%esp
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	e8 46 fa ff ff       	call   80108f <strlen>
  801649:	83 c4 04             	add    $0x4,%esp
  80164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80164f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165d:	eb 17                	jmp    801676 <strcconcat+0x49>
		final[s] = str1[s] ;
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 c2                	add    %eax,%edx
  801667:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	01 c8                	add    %ecx,%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801673:	ff 45 fc             	incl   -0x4(%ebp)
  801676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167c:	7c e1                	jl     80165f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80167e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801685:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80168c:	eb 1f                	jmp    8016ad <strcconcat+0x80>
		final[s++] = str2[i] ;
  80168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801691:	8d 50 01             	lea    0x1(%eax),%edx
  801694:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801697:	89 c2                	mov    %eax,%edx
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	01 c2                	add    %eax,%edx
  80169e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	01 c8                	add    %ecx,%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016aa:	ff 45 f8             	incl   -0x8(%ebp)
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b3:	7c d9                	jl     80168e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d2:	8b 00                	mov    (%eax),%eax
  8016d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e6:	eb 0c                	jmp    8016f4 <strsplit+0x31>
			*string++ = 0;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	84 c0                	test   %al,%al
  8016fb:	74 18                	je     801715 <strsplit+0x52>
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f be c0             	movsbl %al,%eax
  801705:	50                   	push   %eax
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	e8 13 fb ff ff       	call   801221 <strchr>
  80170e:	83 c4 08             	add    $0x8,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	75 d3                	jne    8016e8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 5a                	je     801778 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	83 f8 0f             	cmp    $0xf,%eax
  801726:	75 07                	jne    80172f <strsplit+0x6c>
		{
			return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 66                	jmp    801795 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	8d 48 01             	lea    0x1(%eax),%ecx
  801737:	8b 55 14             	mov    0x14(%ebp),%edx
  80173a:	89 0a                	mov    %ecx,(%edx)
  80173c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	01 c2                	add    %eax,%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80174d:	eb 03                	jmp    801752 <strsplit+0x8f>
			string++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	74 8b                	je     8016e6 <strsplit+0x23>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	0f be c0             	movsbl %al,%eax
  801763:	50                   	push   %eax
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	e8 b5 fa ff ff       	call   801221 <strchr>
  80176c:	83 c4 08             	add    $0x8,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	74 dc                	je     80174f <strsplit+0x8c>
			string++;
	}
  801773:	e9 6e ff ff ff       	jmp    8016e6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801778:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801779:	8b 45 14             	mov    0x14(%ebp),%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801790:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80179d:	a1 04 50 80 00       	mov    0x805004,%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	74 1f                	je     8017c5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017a6:	e8 1d 00 00 00       	call   8017c8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	68 b0 3d 80 00       	push   $0x803db0
  8017b3:	e8 55 f2 ff ff       	call   800a0d <cprintf>
  8017b8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017bb:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8017c2:	00 00 00 
	}
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8017ce:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8017d5:	00 00 00 
  8017d8:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017df:	00 00 00 
  8017e2:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8017e9:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8017ec:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8017f3:	00 00 00 
  8017f6:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017fd:	00 00 00 
  801800:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801807:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80180a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801814:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801819:	2d 00 10 00 00       	sub    $0x1000,%eax
  80181e:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801823:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80182a:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80182d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801837:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80183c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80183f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801842:	ba 00 00 00 00       	mov    $0x0,%edx
  801847:	f7 75 f0             	divl   -0x10(%ebp)
  80184a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184d:	29 d0                	sub    %edx,%eax
  80184f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801852:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80185c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801861:	2d 00 10 00 00       	sub    $0x1000,%eax
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	6a 06                	push   $0x6
  80186b:	ff 75 e8             	pushl  -0x18(%ebp)
  80186e:	50                   	push   %eax
  80186f:	e8 d4 05 00 00       	call   801e48 <sys_allocate_chunk>
  801874:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801877:	a1 20 51 80 00       	mov    0x805120,%eax
  80187c:	83 ec 0c             	sub    $0xc,%esp
  80187f:	50                   	push   %eax
  801880:	e8 49 0c 00 00       	call   8024ce <initialize_MemBlocksList>
  801885:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801888:	a1 48 51 80 00       	mov    0x805148,%eax
  80188d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801890:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801894:	75 14                	jne    8018aa <initialize_dyn_block_system+0xe2>
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	68 d5 3d 80 00       	push   $0x803dd5
  80189e:	6a 39                	push   $0x39
  8018a0:	68 f3 3d 80 00       	push   $0x803df3
  8018a5:	e8 af ee ff ff       	call   800759 <_panic>
  8018aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	74 10                	je     8018c3 <initialize_dyn_block_system+0xfb>
  8018b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b6:	8b 00                	mov    (%eax),%eax
  8018b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018bb:	8b 52 04             	mov    0x4(%edx),%edx
  8018be:	89 50 04             	mov    %edx,0x4(%eax)
  8018c1:	eb 0b                	jmp    8018ce <initialize_dyn_block_system+0x106>
  8018c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c6:	8b 40 04             	mov    0x4(%eax),%eax
  8018c9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8018ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d1:	8b 40 04             	mov    0x4(%eax),%eax
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	74 0f                	je     8018e7 <initialize_dyn_block_system+0x11f>
  8018d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018db:	8b 40 04             	mov    0x4(%eax),%eax
  8018de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018e1:	8b 12                	mov    (%edx),%edx
  8018e3:	89 10                	mov    %edx,(%eax)
  8018e5:	eb 0a                	jmp    8018f1 <initialize_dyn_block_system+0x129>
  8018e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ea:	8b 00                	mov    (%eax),%eax
  8018ec:	a3 48 51 80 00       	mov    %eax,0x805148
  8018f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801904:	a1 54 51 80 00       	mov    0x805154,%eax
  801909:	48                   	dec    %eax
  80190a:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80190f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801912:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801919:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801923:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801927:	75 14                	jne    80193d <initialize_dyn_block_system+0x175>
  801929:	83 ec 04             	sub    $0x4,%esp
  80192c:	68 00 3e 80 00       	push   $0x803e00
  801931:	6a 3f                	push   $0x3f
  801933:	68 f3 3d 80 00       	push   $0x803df3
  801938:	e8 1c ee ff ff       	call   800759 <_panic>
  80193d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801943:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801946:	89 10                	mov    %edx,(%eax)
  801948:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80194b:	8b 00                	mov    (%eax),%eax
  80194d:	85 c0                	test   %eax,%eax
  80194f:	74 0d                	je     80195e <initialize_dyn_block_system+0x196>
  801951:	a1 38 51 80 00       	mov    0x805138,%eax
  801956:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801959:	89 50 04             	mov    %edx,0x4(%eax)
  80195c:	eb 08                	jmp    801966 <initialize_dyn_block_system+0x19e>
  80195e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801961:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801969:	a3 38 51 80 00       	mov    %eax,0x805138
  80196e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801971:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801978:	a1 44 51 80 00       	mov    0x805144,%eax
  80197d:	40                   	inc    %eax
  80197e:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801983:	90                   	nop
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80198c:	e8 06 fe ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801991:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801995:	75 07                	jne    80199e <malloc+0x18>
  801997:	b8 00 00 00 00       	mov    $0x0,%eax
  80199c:	eb 7d                	jmp    801a1b <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80199e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8019a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8019af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b2:	01 d0                	add    %edx,%eax
  8019b4:	48                   	dec    %eax
  8019b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c0:	f7 75 f0             	divl   -0x10(%ebp)
  8019c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c6:	29 d0                	sub    %edx,%eax
  8019c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8019cb:	e8 46 08 00 00       	call   802216 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019d0:	83 f8 01             	cmp    $0x1,%eax
  8019d3:	75 07                	jne    8019dc <malloc+0x56>
  8019d5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8019dc:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8019e0:	75 34                	jne    801a16 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8019e2:	83 ec 0c             	sub    $0xc,%esp
  8019e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8019e8:	e8 73 0e 00 00       	call   802860 <alloc_block_FF>
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  8019f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019f7:	74 16                	je     801a0f <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  8019f9:	83 ec 0c             	sub    $0xc,%esp
  8019fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019ff:	e8 ff 0b 00 00       	call   802603 <insert_sorted_allocList>
  801a04:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801a07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a0a:	8b 40 08             	mov    0x8(%eax),%eax
  801a0d:	eb 0c                	jmp    801a1b <malloc+0x95>
	             }
	             else
	             	return NULL;
  801a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a14:	eb 05                	jmp    801a1b <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801a16:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a37:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801a3a:	83 ec 08             	sub    $0x8,%esp
  801a3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801a40:	68 40 50 80 00       	push   $0x805040
  801a45:	e8 61 0b 00 00       	call   8025ab <find_block>
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801a50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a54:	0f 84 a5 00 00 00    	je     801aff <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a60:	83 ec 08             	sub    $0x8,%esp
  801a63:	50                   	push   %eax
  801a64:	ff 75 f4             	pushl  -0xc(%ebp)
  801a67:	e8 a4 03 00 00       	call   801e10 <sys_free_user_mem>
  801a6c:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801a6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a73:	75 17                	jne    801a8c <free+0x6f>
  801a75:	83 ec 04             	sub    $0x4,%esp
  801a78:	68 d5 3d 80 00       	push   $0x803dd5
  801a7d:	68 87 00 00 00       	push   $0x87
  801a82:	68 f3 3d 80 00       	push   $0x803df3
  801a87:	e8 cd ec ff ff       	call   800759 <_panic>
  801a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a8f:	8b 00                	mov    (%eax),%eax
  801a91:	85 c0                	test   %eax,%eax
  801a93:	74 10                	je     801aa5 <free+0x88>
  801a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a98:	8b 00                	mov    (%eax),%eax
  801a9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a9d:	8b 52 04             	mov    0x4(%edx),%edx
  801aa0:	89 50 04             	mov    %edx,0x4(%eax)
  801aa3:	eb 0b                	jmp    801ab0 <free+0x93>
  801aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa8:	8b 40 04             	mov    0x4(%eax),%eax
  801aab:	a3 44 50 80 00       	mov    %eax,0x805044
  801ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab3:	8b 40 04             	mov    0x4(%eax),%eax
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	74 0f                	je     801ac9 <free+0xac>
  801aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801abd:	8b 40 04             	mov    0x4(%eax),%eax
  801ac0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ac3:	8b 12                	mov    (%edx),%edx
  801ac5:	89 10                	mov    %edx,(%eax)
  801ac7:	eb 0a                	jmp    801ad3 <free+0xb6>
  801ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801acc:	8b 00                	mov    (%eax),%eax
  801ace:	a3 40 50 80 00       	mov    %eax,0x805040
  801ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801adf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ae6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801aeb:	48                   	dec    %eax
  801aec:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801af1:	83 ec 0c             	sub    $0xc,%esp
  801af4:	ff 75 ec             	pushl  -0x14(%ebp)
  801af7:	e8 37 12 00 00       	call   802d33 <insert_sorted_with_merge_freeList>
  801afc:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801aff:	90                   	nop
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
  801b05:	83 ec 38             	sub    $0x38,%esp
  801b08:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b0e:	e8 84 fc ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b17:	75 07                	jne    801b20 <smalloc+0x1e>
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1e:	eb 7e                	jmp    801b9e <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801b20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b27:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b34:	01 d0                	add    %edx,%eax
  801b36:	48                   	dec    %eax
  801b37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b42:	f7 75 f0             	divl   -0x10(%ebp)
  801b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b48:	29 d0                	sub    %edx,%eax
  801b4a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801b4d:	e8 c4 06 00 00       	call   802216 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b52:	83 f8 01             	cmp    $0x1,%eax
  801b55:	75 42                	jne    801b99 <smalloc+0x97>

		  va = malloc(newsize) ;
  801b57:	83 ec 0c             	sub    $0xc,%esp
  801b5a:	ff 75 e8             	pushl  -0x18(%ebp)
  801b5d:	e8 24 fe ff ff       	call   801986 <malloc>
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801b68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b6c:	74 24                	je     801b92 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801b6e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b72:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b75:	50                   	push   %eax
  801b76:	ff 75 e8             	pushl  -0x18(%ebp)
  801b79:	ff 75 08             	pushl  0x8(%ebp)
  801b7c:	e8 1a 04 00 00       	call   801f9b <sys_createSharedObject>
  801b81:	83 c4 10             	add    $0x10,%esp
  801b84:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801b87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b8b:	78 0c                	js     801b99 <smalloc+0x97>
					  return va ;
  801b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b90:	eb 0c                	jmp    801b9e <smalloc+0x9c>
				 }
				 else
					return NULL;
  801b92:	b8 00 00 00 00       	mov    $0x0,%eax
  801b97:	eb 05                	jmp    801b9e <smalloc+0x9c>
	  }
		  return NULL ;
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ba6:	e8 ec fb ff ff       	call   801797 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801bab:	83 ec 08             	sub    $0x8,%esp
  801bae:	ff 75 0c             	pushl  0xc(%ebp)
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	e8 0c 04 00 00       	call   801fc5 <sys_getSizeOfSharedObject>
  801bb9:	83 c4 10             	add    $0x10,%esp
  801bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801bbf:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801bc3:	75 07                	jne    801bcc <sget+0x2c>
  801bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bca:	eb 75                	jmp    801c41 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801bcc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd9:	01 d0                	add    %edx,%eax
  801bdb:	48                   	dec    %eax
  801bdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be2:	ba 00 00 00 00       	mov    $0x0,%edx
  801be7:	f7 75 f0             	divl   -0x10(%ebp)
  801bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bed:	29 d0                	sub    %edx,%eax
  801bef:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801bf2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801bf9:	e8 18 06 00 00       	call   802216 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bfe:	83 f8 01             	cmp    $0x1,%eax
  801c01:	75 39                	jne    801c3c <sget+0x9c>

		  va = malloc(newsize) ;
  801c03:	83 ec 0c             	sub    $0xc,%esp
  801c06:	ff 75 e8             	pushl  -0x18(%ebp)
  801c09:	e8 78 fd ff ff       	call   801986 <malloc>
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801c14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c18:	74 22                	je     801c3c <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	ff 75 e0             	pushl  -0x20(%ebp)
  801c20:	ff 75 0c             	pushl  0xc(%ebp)
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	e8 b7 03 00 00       	call   801fe2 <sys_getSharedObject>
  801c2b:	83 c4 10             	add    $0x10,%esp
  801c2e:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801c31:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c35:	78 05                	js     801c3c <sget+0x9c>
					  return va;
  801c37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c3a:	eb 05                	jmp    801c41 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c49:	e8 49 fb ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	68 24 3e 80 00       	push   $0x803e24
  801c56:	68 1e 01 00 00       	push   $0x11e
  801c5b:	68 f3 3d 80 00       	push   $0x803df3
  801c60:	e8 f4 ea ff ff       	call   800759 <_panic>

00801c65 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c6b:	83 ec 04             	sub    $0x4,%esp
  801c6e:	68 4c 3e 80 00       	push   $0x803e4c
  801c73:	68 32 01 00 00       	push   $0x132
  801c78:	68 f3 3d 80 00       	push   $0x803df3
  801c7d:	e8 d7 ea ff ff       	call   800759 <_panic>

00801c82 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c88:	83 ec 04             	sub    $0x4,%esp
  801c8b:	68 70 3e 80 00       	push   $0x803e70
  801c90:	68 3d 01 00 00       	push   $0x13d
  801c95:	68 f3 3d 80 00       	push   $0x803df3
  801c9a:	e8 ba ea ff ff       	call   800759 <_panic>

00801c9f <shrink>:

}
void shrink(uint32 newSize)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	68 70 3e 80 00       	push   $0x803e70
  801cad:	68 42 01 00 00       	push   $0x142
  801cb2:	68 f3 3d 80 00       	push   $0x803df3
  801cb7:	e8 9d ea ff ff       	call   800759 <_panic>

00801cbc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cc2:	83 ec 04             	sub    $0x4,%esp
  801cc5:	68 70 3e 80 00       	push   $0x803e70
  801cca:	68 47 01 00 00       	push   $0x147
  801ccf:	68 f3 3d 80 00       	push   $0x803df3
  801cd4:	e8 80 ea ff ff       	call   800759 <_panic>

00801cd9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	57                   	push   %edi
  801cdd:	56                   	push   %esi
  801cde:	53                   	push   %ebx
  801cdf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ceb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cee:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cf1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cf4:	cd 30                	int    $0x30
  801cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cfc:	83 c4 10             	add    $0x10,%esp
  801cff:	5b                   	pop    %ebx
  801d00:	5e                   	pop    %esi
  801d01:	5f                   	pop    %edi
  801d02:	5d                   	pop    %ebp
  801d03:	c3                   	ret    

00801d04 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 04             	sub    $0x4,%esp
  801d0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d10:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	52                   	push   %edx
  801d1c:	ff 75 0c             	pushl  0xc(%ebp)
  801d1f:	50                   	push   %eax
  801d20:	6a 00                	push   $0x0
  801d22:	e8 b2 ff ff ff       	call   801cd9 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	90                   	nop
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_cgetc>:

int
sys_cgetc(void)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 01                	push   $0x1
  801d3c:	e8 98 ff ff ff       	call   801cd9 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	52                   	push   %edx
  801d56:	50                   	push   %eax
  801d57:	6a 05                	push   $0x5
  801d59:	e8 7b ff ff ff       	call   801cd9 <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d68:	8b 75 18             	mov    0x18(%ebp),%esi
  801d6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	56                   	push   %esi
  801d78:	53                   	push   %ebx
  801d79:	51                   	push   %ecx
  801d7a:	52                   	push   %edx
  801d7b:	50                   	push   %eax
  801d7c:	6a 06                	push   $0x6
  801d7e:	e8 56 ff ff ff       	call   801cd9 <syscall>
  801d83:	83 c4 18             	add    $0x18,%esp
}
  801d86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d89:	5b                   	pop    %ebx
  801d8a:	5e                   	pop    %esi
  801d8b:	5d                   	pop    %ebp
  801d8c:	c3                   	ret    

00801d8d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	52                   	push   %edx
  801d9d:	50                   	push   %eax
  801d9e:	6a 07                	push   $0x7
  801da0:	e8 34 ff ff ff       	call   801cd9 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	ff 75 0c             	pushl  0xc(%ebp)
  801db6:	ff 75 08             	pushl  0x8(%ebp)
  801db9:	6a 08                	push   $0x8
  801dbb:	e8 19 ff ff ff       	call   801cd9 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 09                	push   $0x9
  801dd4:	e8 00 ff ff ff       	call   801cd9 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 0a                	push   $0xa
  801ded:	e8 e7 fe ff ff       	call   801cd9 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 0b                	push   $0xb
  801e06:	e8 ce fe ff ff       	call   801cd9 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	ff 75 0c             	pushl  0xc(%ebp)
  801e1c:	ff 75 08             	pushl  0x8(%ebp)
  801e1f:	6a 0f                	push   $0xf
  801e21:	e8 b3 fe ff ff       	call   801cd9 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
	return;
  801e29:	90                   	nop
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	6a 10                	push   $0x10
  801e3d:	e8 97 fe ff ff       	call   801cd9 <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
	return ;
  801e45:	90                   	nop
}
  801e46:	c9                   	leave  
  801e47:	c3                   	ret    

00801e48 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e48:	55                   	push   %ebp
  801e49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	ff 75 10             	pushl  0x10(%ebp)
  801e52:	ff 75 0c             	pushl  0xc(%ebp)
  801e55:	ff 75 08             	pushl  0x8(%ebp)
  801e58:	6a 11                	push   $0x11
  801e5a:	e8 7a fe ff ff       	call   801cd9 <syscall>
  801e5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e62:	90                   	nop
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 0c                	push   $0xc
  801e74:	e8 60 fe ff ff       	call   801cd9 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	ff 75 08             	pushl  0x8(%ebp)
  801e8c:	6a 0d                	push   $0xd
  801e8e:	e8 46 fe ff ff       	call   801cd9 <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 0e                	push   $0xe
  801ea7:	e8 2d fe ff ff       	call   801cd9 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
}
  801eaf:	90                   	nop
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 13                	push   $0x13
  801ec1:	e8 13 fe ff ff       	call   801cd9 <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	90                   	nop
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 14                	push   $0x14
  801edb:	e8 f9 fd ff ff       	call   801cd9 <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	90                   	nop
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 04             	sub    $0x4,%esp
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ef2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	50                   	push   %eax
  801eff:	6a 15                	push   $0x15
  801f01:	e8 d3 fd ff ff       	call   801cd9 <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
}
  801f09:	90                   	nop
  801f0a:	c9                   	leave  
  801f0b:	c3                   	ret    

00801f0c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	6a 00                	push   $0x0
  801f19:	6a 16                	push   $0x16
  801f1b:	e8 b9 fd ff ff       	call   801cd9 <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	90                   	nop
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	50                   	push   %eax
  801f36:	6a 17                	push   $0x17
  801f38:	e8 9c fd ff ff       	call   801cd9 <syscall>
  801f3d:	83 c4 18             	add    $0x18,%esp
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	6a 1a                	push   $0x1a
  801f55:	e8 7f fd ff ff       	call   801cd9 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	52                   	push   %edx
  801f6f:	50                   	push   %eax
  801f70:	6a 18                	push   $0x18
  801f72:	e8 62 fd ff ff       	call   801cd9 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	90                   	nop
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	52                   	push   %edx
  801f8d:	50                   	push   %eax
  801f8e:	6a 19                	push   $0x19
  801f90:	e8 44 fd ff ff       	call   801cd9 <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	90                   	nop
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fa7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801faa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	6a 00                	push   $0x0
  801fb3:	51                   	push   %ecx
  801fb4:	52                   	push   %edx
  801fb5:	ff 75 0c             	pushl  0xc(%ebp)
  801fb8:	50                   	push   %eax
  801fb9:	6a 1b                	push   $0x1b
  801fbb:	e8 19 fd ff ff       	call   801cd9 <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	52                   	push   %edx
  801fd5:	50                   	push   %eax
  801fd6:	6a 1c                	push   $0x1c
  801fd8:	e8 fc fc ff ff       	call   801cd9 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fe5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	51                   	push   %ecx
  801ff3:	52                   	push   %edx
  801ff4:	50                   	push   %eax
  801ff5:	6a 1d                	push   $0x1d
  801ff7:	e8 dd fc ff ff       	call   801cd9 <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802004:	8b 55 0c             	mov    0xc(%ebp),%edx
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	52                   	push   %edx
  802011:	50                   	push   %eax
  802012:	6a 1e                	push   $0x1e
  802014:	e8 c0 fc ff ff       	call   801cd9 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 00                	push   $0x0
  80202b:	6a 1f                	push   $0x1f
  80202d:	e8 a7 fc ff ff       	call   801cd9 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	6a 00                	push   $0x0
  80203f:	ff 75 14             	pushl  0x14(%ebp)
  802042:	ff 75 10             	pushl  0x10(%ebp)
  802045:	ff 75 0c             	pushl  0xc(%ebp)
  802048:	50                   	push   %eax
  802049:	6a 20                	push   $0x20
  80204b:	e8 89 fc ff ff       	call   801cd9 <syscall>
  802050:	83 c4 18             	add    $0x18,%esp
}
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	50                   	push   %eax
  802064:	6a 21                	push   $0x21
  802066:	e8 6e fc ff ff       	call   801cd9 <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
}
  80206e:	90                   	nop
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	50                   	push   %eax
  802080:	6a 22                	push   $0x22
  802082:	e8 52 fc ff ff       	call   801cd9 <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 02                	push   $0x2
  80209b:	e8 39 fc ff ff       	call   801cd9 <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 03                	push   $0x3
  8020b4:	e8 20 fc ff ff       	call   801cd9 <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 04                	push   $0x4
  8020cd:	e8 07 fc ff ff       	call   801cd9 <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_exit_env>:


void sys_exit_env(void)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 23                	push   $0x23
  8020e6:	e8 ee fb ff ff       	call   801cd9 <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	90                   	nop
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020f7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020fa:	8d 50 04             	lea    0x4(%eax),%edx
  8020fd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	52                   	push   %edx
  802107:	50                   	push   %eax
  802108:	6a 24                	push   $0x24
  80210a:	e8 ca fb ff ff       	call   801cd9 <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
	return result;
  802112:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802115:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802118:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80211b:	89 01                	mov    %eax,(%ecx)
  80211d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	c9                   	leave  
  802124:	c2 04 00             	ret    $0x4

00802127 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802127:	55                   	push   %ebp
  802128:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	ff 75 10             	pushl  0x10(%ebp)
  802131:	ff 75 0c             	pushl  0xc(%ebp)
  802134:	ff 75 08             	pushl  0x8(%ebp)
  802137:	6a 12                	push   $0x12
  802139:	e8 9b fb ff ff       	call   801cd9 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
	return ;
  802141:	90                   	nop
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <sys_rcr2>:
uint32 sys_rcr2()
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 25                	push   $0x25
  802153:	e8 81 fb ff ff       	call   801cd9 <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
}
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802169:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	50                   	push   %eax
  802176:	6a 26                	push   $0x26
  802178:	e8 5c fb ff ff       	call   801cd9 <syscall>
  80217d:	83 c4 18             	add    $0x18,%esp
	return ;
  802180:	90                   	nop
}
  802181:	c9                   	leave  
  802182:	c3                   	ret    

00802183 <rsttst>:
void rsttst()
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 28                	push   $0x28
  802192:	e8 42 fb ff ff       	call   801cd9 <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
	return ;
  80219a:	90                   	nop
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    

0080219d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80219d:	55                   	push   %ebp
  80219e:	89 e5                	mov    %esp,%ebp
  8021a0:	83 ec 04             	sub    $0x4,%esp
  8021a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021a9:	8b 55 18             	mov    0x18(%ebp),%edx
  8021ac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021b0:	52                   	push   %edx
  8021b1:	50                   	push   %eax
  8021b2:	ff 75 10             	pushl  0x10(%ebp)
  8021b5:	ff 75 0c             	pushl  0xc(%ebp)
  8021b8:	ff 75 08             	pushl  0x8(%ebp)
  8021bb:	6a 27                	push   $0x27
  8021bd:	e8 17 fb ff ff       	call   801cd9 <syscall>
  8021c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c5:	90                   	nop
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <chktst>:
void chktst(uint32 n)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	ff 75 08             	pushl  0x8(%ebp)
  8021d6:	6a 29                	push   $0x29
  8021d8:	e8 fc fa ff ff       	call   801cd9 <syscall>
  8021dd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e0:	90                   	nop
}
  8021e1:	c9                   	leave  
  8021e2:	c3                   	ret    

008021e3 <inctst>:

void inctst()
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 2a                	push   $0x2a
  8021f2:	e8 e2 fa ff ff       	call   801cd9 <syscall>
  8021f7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021fa:	90                   	nop
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <gettst>:
uint32 gettst()
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 2b                	push   $0x2b
  80220c:	e8 c8 fa ff ff       	call   801cd9 <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 2c                	push   $0x2c
  802228:	e8 ac fa ff ff       	call   801cd9 <syscall>
  80222d:	83 c4 18             	add    $0x18,%esp
  802230:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802233:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802237:	75 07                	jne    802240 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802239:	b8 01 00 00 00       	mov    $0x1,%eax
  80223e:	eb 05                	jmp    802245 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
  80224a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 2c                	push   $0x2c
  802259:	e8 7b fa ff ff       	call   801cd9 <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
  802261:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802264:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802268:	75 07                	jne    802271 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80226a:	b8 01 00 00 00       	mov    $0x1,%eax
  80226f:	eb 05                	jmp    802276 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802271:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 2c                	push   $0x2c
  80228a:	e8 4a fa ff ff       	call   801cd9 <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
  802292:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802295:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802299:	75 07                	jne    8022a2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80229b:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a0:	eb 05                	jmp    8022a7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 2c                	push   $0x2c
  8022bb:	e8 19 fa ff ff       	call   801cd9 <syscall>
  8022c0:	83 c4 18             	add    $0x18,%esp
  8022c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022c6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022ca:	75 07                	jne    8022d3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8022d1:	eb 05                	jmp    8022d8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	ff 75 08             	pushl  0x8(%ebp)
  8022e8:	6a 2d                	push   $0x2d
  8022ea:	e8 ea f9 ff ff       	call   801cd9 <syscall>
  8022ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f2:	90                   	nop
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
  8022f8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802302:	8b 45 08             	mov    0x8(%ebp),%eax
  802305:	6a 00                	push   $0x0
  802307:	53                   	push   %ebx
  802308:	51                   	push   %ecx
  802309:	52                   	push   %edx
  80230a:	50                   	push   %eax
  80230b:	6a 2e                	push   $0x2e
  80230d:	e8 c7 f9 ff ff       	call   801cd9 <syscall>
  802312:	83 c4 18             	add    $0x18,%esp
}
  802315:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80231d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	52                   	push   %edx
  80232a:	50                   	push   %eax
  80232b:	6a 2f                	push   $0x2f
  80232d:	e8 a7 f9 ff ff       	call   801cd9 <syscall>
  802332:	83 c4 18             	add    $0x18,%esp
}
  802335:	c9                   	leave  
  802336:	c3                   	ret    

00802337 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802337:	55                   	push   %ebp
  802338:	89 e5                	mov    %esp,%ebp
  80233a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80233d:	83 ec 0c             	sub    $0xc,%esp
  802340:	68 80 3e 80 00       	push   $0x803e80
  802345:	e8 c3 e6 ff ff       	call   800a0d <cprintf>
  80234a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80234d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802354:	83 ec 0c             	sub    $0xc,%esp
  802357:	68 ac 3e 80 00       	push   $0x803eac
  80235c:	e8 ac e6 ff ff       	call   800a0d <cprintf>
  802361:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802364:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802368:	a1 38 51 80 00       	mov    0x805138,%eax
  80236d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802370:	eb 56                	jmp    8023c8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802372:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802376:	74 1c                	je     802394 <print_mem_block_lists+0x5d>
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 50 08             	mov    0x8(%eax),%edx
  80237e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802381:	8b 48 08             	mov    0x8(%eax),%ecx
  802384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802387:	8b 40 0c             	mov    0xc(%eax),%eax
  80238a:	01 c8                	add    %ecx,%eax
  80238c:	39 c2                	cmp    %eax,%edx
  80238e:	73 04                	jae    802394 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802390:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 50 08             	mov    0x8(%eax),%edx
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a0:	01 c2                	add    %eax,%edx
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 40 08             	mov    0x8(%eax),%eax
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	52                   	push   %edx
  8023ac:	50                   	push   %eax
  8023ad:	68 c1 3e 80 00       	push   $0x803ec1
  8023b2:	e8 56 e6 ff ff       	call   800a0d <cprintf>
  8023b7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8023c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cc:	74 07                	je     8023d5 <print_mem_block_lists+0x9e>
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	eb 05                	jmp    8023da <print_mem_block_lists+0xa3>
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	a3 40 51 80 00       	mov    %eax,0x805140
  8023df:	a1 40 51 80 00       	mov    0x805140,%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	75 8a                	jne    802372 <print_mem_block_lists+0x3b>
  8023e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ec:	75 84                	jne    802372 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023ee:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023f2:	75 10                	jne    802404 <print_mem_block_lists+0xcd>
  8023f4:	83 ec 0c             	sub    $0xc,%esp
  8023f7:	68 d0 3e 80 00       	push   $0x803ed0
  8023fc:	e8 0c e6 ff ff       	call   800a0d <cprintf>
  802401:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802404:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80240b:	83 ec 0c             	sub    $0xc,%esp
  80240e:	68 f4 3e 80 00       	push   $0x803ef4
  802413:	e8 f5 e5 ff ff       	call   800a0d <cprintf>
  802418:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80241b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80241f:	a1 40 50 80 00       	mov    0x805040,%eax
  802424:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802427:	eb 56                	jmp    80247f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802429:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80242d:	74 1c                	je     80244b <print_mem_block_lists+0x114>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 50 08             	mov    0x8(%eax),%edx
  802435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802438:	8b 48 08             	mov    0x8(%eax),%ecx
  80243b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243e:	8b 40 0c             	mov    0xc(%eax),%eax
  802441:	01 c8                	add    %ecx,%eax
  802443:	39 c2                	cmp    %eax,%edx
  802445:	73 04                	jae    80244b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802447:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 50 08             	mov    0x8(%eax),%edx
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 40 0c             	mov    0xc(%eax),%eax
  802457:	01 c2                	add    %eax,%edx
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 40 08             	mov    0x8(%eax),%eax
  80245f:	83 ec 04             	sub    $0x4,%esp
  802462:	52                   	push   %edx
  802463:	50                   	push   %eax
  802464:	68 c1 3e 80 00       	push   $0x803ec1
  802469:	e8 9f e5 ff ff       	call   800a0d <cprintf>
  80246e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802477:	a1 48 50 80 00       	mov    0x805048,%eax
  80247c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802483:	74 07                	je     80248c <print_mem_block_lists+0x155>
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 00                	mov    (%eax),%eax
  80248a:	eb 05                	jmp    802491 <print_mem_block_lists+0x15a>
  80248c:	b8 00 00 00 00       	mov    $0x0,%eax
  802491:	a3 48 50 80 00       	mov    %eax,0x805048
  802496:	a1 48 50 80 00       	mov    0x805048,%eax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	75 8a                	jne    802429 <print_mem_block_lists+0xf2>
  80249f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a3:	75 84                	jne    802429 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024a5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024a9:	75 10                	jne    8024bb <print_mem_block_lists+0x184>
  8024ab:	83 ec 0c             	sub    $0xc,%esp
  8024ae:	68 0c 3f 80 00       	push   $0x803f0c
  8024b3:	e8 55 e5 ff ff       	call   800a0d <cprintf>
  8024b8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024bb:	83 ec 0c             	sub    $0xc,%esp
  8024be:	68 80 3e 80 00       	push   $0x803e80
  8024c3:	e8 45 e5 ff ff       	call   800a0d <cprintf>
  8024c8:	83 c4 10             	add    $0x10,%esp

}
  8024cb:	90                   	nop
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8024d4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024db:	00 00 00 
  8024de:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024e5:	00 00 00 
  8024e8:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024ef:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8024f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024f9:	e9 9e 00 00 00       	jmp    80259c <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8024fe:	a1 50 50 80 00       	mov    0x805050,%eax
  802503:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802506:	c1 e2 04             	shl    $0x4,%edx
  802509:	01 d0                	add    %edx,%eax
  80250b:	85 c0                	test   %eax,%eax
  80250d:	75 14                	jne    802523 <initialize_MemBlocksList+0x55>
  80250f:	83 ec 04             	sub    $0x4,%esp
  802512:	68 34 3f 80 00       	push   $0x803f34
  802517:	6a 47                	push   $0x47
  802519:	68 57 3f 80 00       	push   $0x803f57
  80251e:	e8 36 e2 ff ff       	call   800759 <_panic>
  802523:	a1 50 50 80 00       	mov    0x805050,%eax
  802528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252b:	c1 e2 04             	shl    $0x4,%edx
  80252e:	01 d0                	add    %edx,%eax
  802530:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802536:	89 10                	mov    %edx,(%eax)
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	74 18                	je     802556 <initialize_MemBlocksList+0x88>
  80253e:	a1 48 51 80 00       	mov    0x805148,%eax
  802543:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802549:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80254c:	c1 e1 04             	shl    $0x4,%ecx
  80254f:	01 ca                	add    %ecx,%edx
  802551:	89 50 04             	mov    %edx,0x4(%eax)
  802554:	eb 12                	jmp    802568 <initialize_MemBlocksList+0x9a>
  802556:	a1 50 50 80 00       	mov    0x805050,%eax
  80255b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255e:	c1 e2 04             	shl    $0x4,%edx
  802561:	01 d0                	add    %edx,%eax
  802563:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802568:	a1 50 50 80 00       	mov    0x805050,%eax
  80256d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802570:	c1 e2 04             	shl    $0x4,%edx
  802573:	01 d0                	add    %edx,%eax
  802575:	a3 48 51 80 00       	mov    %eax,0x805148
  80257a:	a1 50 50 80 00       	mov    0x805050,%eax
  80257f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802582:	c1 e2 04             	shl    $0x4,%edx
  802585:	01 d0                	add    %edx,%eax
  802587:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258e:	a1 54 51 80 00       	mov    0x805154,%eax
  802593:	40                   	inc    %eax
  802594:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802599:	ff 45 f4             	incl   -0xc(%ebp)
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a2:	0f 82 56 ff ff ff    	jb     8024fe <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8025a8:	90                   	nop
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
  8025ae:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025b9:	eb 19                	jmp    8025d4 <find_block+0x29>
	{
		if(element->sva == va){
  8025bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025be:	8b 40 08             	mov    0x8(%eax),%eax
  8025c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025c4:	75 05                	jne    8025cb <find_block+0x20>
			 		return element;
  8025c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c9:	eb 36                	jmp    802601 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8025cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ce:	8b 40 08             	mov    0x8(%eax),%eax
  8025d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025d8:	74 07                	je     8025e1 <find_block+0x36>
  8025da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	eb 05                	jmp    8025e6 <find_block+0x3b>
  8025e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e9:	89 42 08             	mov    %eax,0x8(%edx)
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	8b 40 08             	mov    0x8(%eax),%eax
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	75 c5                	jne    8025bb <find_block+0x10>
  8025f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025fa:	75 bf                	jne    8025bb <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802609:	a1 44 50 80 00       	mov    0x805044,%eax
  80260e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802611:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802616:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802619:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80261d:	74 0a                	je     802629 <insert_sorted_allocList+0x26>
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	8b 40 08             	mov    0x8(%eax),%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	75 65                	jne    80268e <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802629:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80262d:	75 14                	jne    802643 <insert_sorted_allocList+0x40>
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	68 34 3f 80 00       	push   $0x803f34
  802637:	6a 6e                	push   $0x6e
  802639:	68 57 3f 80 00       	push   $0x803f57
  80263e:	e8 16 e1 ff ff       	call   800759 <_panic>
  802643:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	89 10                	mov    %edx,(%eax)
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	74 0d                	je     802664 <insert_sorted_allocList+0x61>
  802657:	a1 40 50 80 00       	mov    0x805040,%eax
  80265c:	8b 55 08             	mov    0x8(%ebp),%edx
  80265f:	89 50 04             	mov    %edx,0x4(%eax)
  802662:	eb 08                	jmp    80266c <insert_sorted_allocList+0x69>
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	a3 44 50 80 00       	mov    %eax,0x805044
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	a3 40 50 80 00       	mov    %eax,0x805040
  802674:	8b 45 08             	mov    0x8(%ebp),%eax
  802677:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802683:	40                   	inc    %eax
  802684:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802689:	e9 cf 01 00 00       	jmp    80285d <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	8b 50 08             	mov    0x8(%eax),%edx
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	8b 40 08             	mov    0x8(%eax),%eax
  80269a:	39 c2                	cmp    %eax,%edx
  80269c:	73 65                	jae    802703 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80269e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026a2:	75 14                	jne    8026b8 <insert_sorted_allocList+0xb5>
  8026a4:	83 ec 04             	sub    $0x4,%esp
  8026a7:	68 70 3f 80 00       	push   $0x803f70
  8026ac:	6a 72                	push   $0x72
  8026ae:	68 57 3f 80 00       	push   $0x803f57
  8026b3:	e8 a1 e0 ff ff       	call   800759 <_panic>
  8026b8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026be:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c1:	89 50 04             	mov    %edx,0x4(%eax)
  8026c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 0c                	je     8026da <insert_sorted_allocList+0xd7>
  8026ce:	a1 44 50 80 00       	mov    0x805044,%eax
  8026d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d6:	89 10                	mov    %edx,(%eax)
  8026d8:	eb 08                	jmp    8026e2 <insert_sorted_allocList+0xdf>
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	a3 40 50 80 00       	mov    %eax,0x805040
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	a3 44 50 80 00       	mov    %eax,0x805044
  8026ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026f8:	40                   	inc    %eax
  8026f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8026fe:	e9 5a 01 00 00       	jmp    80285d <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802706:	8b 50 08             	mov    0x8(%eax),%edx
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	8b 40 08             	mov    0x8(%eax),%eax
  80270f:	39 c2                	cmp    %eax,%edx
  802711:	75 70                	jne    802783 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802713:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802717:	74 06                	je     80271f <insert_sorted_allocList+0x11c>
  802719:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80271d:	75 14                	jne    802733 <insert_sorted_allocList+0x130>
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	68 94 3f 80 00       	push   $0x803f94
  802727:	6a 75                	push   $0x75
  802729:	68 57 3f 80 00       	push   $0x803f57
  80272e:	e8 26 e0 ff ff       	call   800759 <_panic>
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	8b 10                	mov    (%eax),%edx
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	89 10                	mov    %edx,(%eax)
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	85 c0                	test   %eax,%eax
  802744:	74 0b                	je     802751 <insert_sorted_allocList+0x14e>
  802746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	8b 55 08             	mov    0x8(%ebp),%edx
  80274e:	89 50 04             	mov    %edx,0x4(%eax)
  802751:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802754:	8b 55 08             	mov    0x8(%ebp),%edx
  802757:	89 10                	mov    %edx,(%eax)
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80275f:	89 50 04             	mov    %edx,0x4(%eax)
  802762:	8b 45 08             	mov    0x8(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	75 08                	jne    802773 <insert_sorted_allocList+0x170>
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	a3 44 50 80 00       	mov    %eax,0x805044
  802773:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802778:	40                   	inc    %eax
  802779:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  80277e:	e9 da 00 00 00       	jmp    80285d <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802783:	a1 40 50 80 00       	mov    0x805040,%eax
  802788:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278b:	e9 9d 00 00 00       	jmp    80282d <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 00                	mov    (%eax),%eax
  802795:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802798:	8b 45 08             	mov    0x8(%ebp),%eax
  80279b:	8b 50 08             	mov    0x8(%eax),%edx
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 40 08             	mov    0x8(%eax),%eax
  8027a4:	39 c2                	cmp    %eax,%edx
  8027a6:	76 7d                	jbe    802825 <insert_sorted_allocList+0x222>
  8027a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ab:	8b 50 08             	mov    0x8(%eax),%edx
  8027ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b1:	8b 40 08             	mov    0x8(%eax),%eax
  8027b4:	39 c2                	cmp    %eax,%edx
  8027b6:	73 6d                	jae    802825 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8027b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bc:	74 06                	je     8027c4 <insert_sorted_allocList+0x1c1>
  8027be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c2:	75 14                	jne    8027d8 <insert_sorted_allocList+0x1d5>
  8027c4:	83 ec 04             	sub    $0x4,%esp
  8027c7:	68 94 3f 80 00       	push   $0x803f94
  8027cc:	6a 7c                	push   $0x7c
  8027ce:	68 57 3f 80 00       	push   $0x803f57
  8027d3:	e8 81 df ff ff       	call   800759 <_panic>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 10                	mov    (%eax),%edx
  8027dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e0:	89 10                	mov    %edx,(%eax)
  8027e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	74 0b                	je     8027f6 <insert_sorted_allocList+0x1f3>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f3:	89 50 04             	mov    %edx,0x4(%eax)
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fc:	89 10                	mov    %edx,(%eax)
  8027fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802804:	89 50 04             	mov    %edx,0x4(%eax)
  802807:	8b 45 08             	mov    0x8(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	75 08                	jne    802818 <insert_sorted_allocList+0x215>
  802810:	8b 45 08             	mov    0x8(%ebp),%eax
  802813:	a3 44 50 80 00       	mov    %eax,0x805044
  802818:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80281d:	40                   	inc    %eax
  80281e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802823:	eb 38                	jmp    80285d <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802825:	a1 48 50 80 00       	mov    0x805048,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	74 07                	je     80283a <insert_sorted_allocList+0x237>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	eb 05                	jmp    80283f <insert_sorted_allocList+0x23c>
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	a3 48 50 80 00       	mov    %eax,0x805048
  802844:	a1 48 50 80 00       	mov    0x805048,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	0f 85 3f ff ff ff    	jne    802790 <insert_sorted_allocList+0x18d>
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	0f 85 35 ff ff ff    	jne    802790 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80285b:	eb 00                	jmp    80285d <insert_sorted_allocList+0x25a>
  80285d:	90                   	nop
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

00802860 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802866:	a1 38 51 80 00       	mov    0x805138,%eax
  80286b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80286e:	e9 6b 02 00 00       	jmp    802ade <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 40 0c             	mov    0xc(%eax),%eax
  802879:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287c:	0f 85 90 00 00 00    	jne    802912 <alloc_block_FF+0xb2>
			  temp=element;
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802888:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288c:	75 17                	jne    8028a5 <alloc_block_FF+0x45>
  80288e:	83 ec 04             	sub    $0x4,%esp
  802891:	68 c8 3f 80 00       	push   $0x803fc8
  802896:	68 92 00 00 00       	push   $0x92
  80289b:	68 57 3f 80 00       	push   $0x803f57
  8028a0:	e8 b4 de ff ff       	call   800759 <_panic>
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	74 10                	je     8028be <alloc_block_FF+0x5e>
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b6:	8b 52 04             	mov    0x4(%edx),%edx
  8028b9:	89 50 04             	mov    %edx,0x4(%eax)
  8028bc:	eb 0b                	jmp    8028c9 <alloc_block_FF+0x69>
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 04             	mov    0x4(%eax),%eax
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	74 0f                	je     8028e2 <alloc_block_FF+0x82>
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 04             	mov    0x4(%eax),%eax
  8028d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028dc:	8b 12                	mov    (%edx),%edx
  8028de:	89 10                	mov    %edx,(%eax)
  8028e0:	eb 0a                	jmp    8028ec <alloc_block_FF+0x8c>
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ff:	a1 44 51 80 00       	mov    0x805144,%eax
  802904:	48                   	dec    %eax
  802905:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  80290a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290d:	e9 ff 01 00 00       	jmp    802b11 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 0c             	mov    0xc(%eax),%eax
  802918:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291b:	0f 86 b5 01 00 00    	jbe    802ad6 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 0c             	mov    0xc(%eax),%eax
  802927:	2b 45 08             	sub    0x8(%ebp),%eax
  80292a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80292d:	a1 48 51 80 00       	mov    0x805148,%eax
  802932:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802935:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802939:	75 17                	jne    802952 <alloc_block_FF+0xf2>
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	68 c8 3f 80 00       	push   $0x803fc8
  802943:	68 99 00 00 00       	push   $0x99
  802948:	68 57 3f 80 00       	push   $0x803f57
  80294d:	e8 07 de ff ff       	call   800759 <_panic>
  802952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	74 10                	je     80296b <alloc_block_FF+0x10b>
  80295b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802963:	8b 52 04             	mov    0x4(%edx),%edx
  802966:	89 50 04             	mov    %edx,0x4(%eax)
  802969:	eb 0b                	jmp    802976 <alloc_block_FF+0x116>
  80296b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296e:	8b 40 04             	mov    0x4(%eax),%eax
  802971:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802976:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802979:	8b 40 04             	mov    0x4(%eax),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 0f                	je     80298f <alloc_block_FF+0x12f>
  802980:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802989:	8b 12                	mov    (%edx),%edx
  80298b:	89 10                	mov    %edx,(%eax)
  80298d:	eb 0a                	jmp    802999 <alloc_block_FF+0x139>
  80298f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	a3 48 51 80 00       	mov    %eax,0x805148
  802999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8029b1:	48                   	dec    %eax
  8029b2:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8029b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029bb:	75 17                	jne    8029d4 <alloc_block_FF+0x174>
  8029bd:	83 ec 04             	sub    $0x4,%esp
  8029c0:	68 70 3f 80 00       	push   $0x803f70
  8029c5:	68 9a 00 00 00       	push   $0x9a
  8029ca:	68 57 3f 80 00       	push   $0x803f57
  8029cf:	e8 85 dd ff ff       	call   800759 <_panic>
  8029d4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8029da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dd:	89 50 04             	mov    %edx,0x4(%eax)
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	8b 40 04             	mov    0x4(%eax),%eax
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	74 0c                	je     8029f6 <alloc_block_FF+0x196>
  8029ea:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8029ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f2:	89 10                	mov    %edx,(%eax)
  8029f4:	eb 08                	jmp    8029fe <alloc_block_FF+0x19e>
  8029f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f9:	a3 38 51 80 00       	mov    %eax,0x805138
  8029fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0f:	a1 44 51 80 00       	mov    0x805144,%eax
  802a14:	40                   	inc    %eax
  802a15:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a20:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 50 08             	mov    0x8(%eax),%edx
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a35:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 50 08             	mov    0x8(%eax),%edx
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	01 c2                	add    %eax,%edx
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802a4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a53:	75 17                	jne    802a6c <alloc_block_FF+0x20c>
  802a55:	83 ec 04             	sub    $0x4,%esp
  802a58:	68 c8 3f 80 00       	push   $0x803fc8
  802a5d:	68 a2 00 00 00       	push   $0xa2
  802a62:	68 57 3f 80 00       	push   $0x803f57
  802a67:	e8 ed dc ff ff       	call   800759 <_panic>
  802a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	85 c0                	test   %eax,%eax
  802a73:	74 10                	je     802a85 <alloc_block_FF+0x225>
  802a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a78:	8b 00                	mov    (%eax),%eax
  802a7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a7d:	8b 52 04             	mov    0x4(%edx),%edx
  802a80:	89 50 04             	mov    %edx,0x4(%eax)
  802a83:	eb 0b                	jmp    802a90 <alloc_block_FF+0x230>
  802a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a88:	8b 40 04             	mov    0x4(%eax),%eax
  802a8b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a93:	8b 40 04             	mov    0x4(%eax),%eax
  802a96:	85 c0                	test   %eax,%eax
  802a98:	74 0f                	je     802aa9 <alloc_block_FF+0x249>
  802a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9d:	8b 40 04             	mov    0x4(%eax),%eax
  802aa0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa3:	8b 12                	mov    (%edx),%edx
  802aa5:	89 10                	mov    %edx,(%eax)
  802aa7:	eb 0a                	jmp    802ab3 <alloc_block_FF+0x253>
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	a3 38 51 80 00       	mov    %eax,0x805138
  802ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac6:	a1 44 51 80 00       	mov    0x805144,%eax
  802acb:	48                   	dec    %eax
  802acc:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802ad1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad4:	eb 3b                	jmp    802b11 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802ad6:	a1 40 51 80 00       	mov    0x805140,%eax
  802adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ade:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae2:	74 07                	je     802aeb <alloc_block_FF+0x28b>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	eb 05                	jmp    802af0 <alloc_block_FF+0x290>
  802aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  802af0:	a3 40 51 80 00       	mov    %eax,0x805140
  802af5:	a1 40 51 80 00       	mov    0x805140,%eax
  802afa:	85 c0                	test   %eax,%eax
  802afc:	0f 85 71 fd ff ff    	jne    802873 <alloc_block_FF+0x13>
  802b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b06:	0f 85 67 fd ff ff    	jne    802873 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b11:	c9                   	leave  
  802b12:	c3                   	ret    

00802b13 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b13:	55                   	push   %ebp
  802b14:	89 e5                	mov    %esp,%ebp
  802b16:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802b19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802b20:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802b27:	a1 38 51 80 00       	mov    0x805138,%eax
  802b2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b2f:	e9 d3 00 00 00       	jmp    802c07 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b37:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3d:	0f 85 90 00 00 00    	jne    802bd3 <alloc_block_BF+0xc0>
	   temp = element;
  802b43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b46:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802b49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b4d:	75 17                	jne    802b66 <alloc_block_BF+0x53>
  802b4f:	83 ec 04             	sub    $0x4,%esp
  802b52:	68 c8 3f 80 00       	push   $0x803fc8
  802b57:	68 bd 00 00 00       	push   $0xbd
  802b5c:	68 57 3f 80 00       	push   $0x803f57
  802b61:	e8 f3 db ff ff       	call   800759 <_panic>
  802b66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	85 c0                	test   %eax,%eax
  802b6d:	74 10                	je     802b7f <alloc_block_BF+0x6c>
  802b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b72:	8b 00                	mov    (%eax),%eax
  802b74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b77:	8b 52 04             	mov    0x4(%edx),%edx
  802b7a:	89 50 04             	mov    %edx,0x4(%eax)
  802b7d:	eb 0b                	jmp    802b8a <alloc_block_BF+0x77>
  802b7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b82:	8b 40 04             	mov    0x4(%eax),%eax
  802b85:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8d:	8b 40 04             	mov    0x4(%eax),%eax
  802b90:	85 c0                	test   %eax,%eax
  802b92:	74 0f                	je     802ba3 <alloc_block_BF+0x90>
  802b94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b9d:	8b 12                	mov    (%edx),%edx
  802b9f:	89 10                	mov    %edx,(%eax)
  802ba1:	eb 0a                	jmp    802bad <alloc_block_BF+0x9a>
  802ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	a3 38 51 80 00       	mov    %eax,0x805138
  802bad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc0:	a1 44 51 80 00       	mov    0x805144,%eax
  802bc5:	48                   	dec    %eax
  802bc6:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802bcb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802bce:	e9 41 01 00 00       	jmp    802d14 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802bd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bdc:	76 21                	jbe    802bff <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802bde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be1:	8b 40 0c             	mov    0xc(%eax),%eax
  802be4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802be7:	73 16                	jae    802bff <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802be9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bec:	8b 40 0c             	mov    0xc(%eax),%eax
  802bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802bf8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802bff:	a1 40 51 80 00       	mov    0x805140,%eax
  802c04:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802c07:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c0b:	74 07                	je     802c14 <alloc_block_BF+0x101>
  802c0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c10:	8b 00                	mov    (%eax),%eax
  802c12:	eb 05                	jmp    802c19 <alloc_block_BF+0x106>
  802c14:	b8 00 00 00 00       	mov    $0x0,%eax
  802c19:	a3 40 51 80 00       	mov    %eax,0x805140
  802c1e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c23:	85 c0                	test   %eax,%eax
  802c25:	0f 85 09 ff ff ff    	jne    802b34 <alloc_block_BF+0x21>
  802c2b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c2f:	0f 85 ff fe ff ff    	jne    802b34 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802c35:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802c39:	0f 85 d0 00 00 00    	jne    802d0f <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c42:	8b 40 0c             	mov    0xc(%eax),%eax
  802c45:	2b 45 08             	sub    0x8(%ebp),%eax
  802c48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802c4b:	a1 48 51 80 00       	mov    0x805148,%eax
  802c50:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802c53:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c57:	75 17                	jne    802c70 <alloc_block_BF+0x15d>
  802c59:	83 ec 04             	sub    $0x4,%esp
  802c5c:	68 c8 3f 80 00       	push   $0x803fc8
  802c61:	68 d1 00 00 00       	push   $0xd1
  802c66:	68 57 3f 80 00       	push   $0x803f57
  802c6b:	e8 e9 da ff ff       	call   800759 <_panic>
  802c70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c73:	8b 00                	mov    (%eax),%eax
  802c75:	85 c0                	test   %eax,%eax
  802c77:	74 10                	je     802c89 <alloc_block_BF+0x176>
  802c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7c:	8b 00                	mov    (%eax),%eax
  802c7e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c81:	8b 52 04             	mov    0x4(%edx),%edx
  802c84:	89 50 04             	mov    %edx,0x4(%eax)
  802c87:	eb 0b                	jmp    802c94 <alloc_block_BF+0x181>
  802c89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8c:	8b 40 04             	mov    0x4(%eax),%eax
  802c8f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c97:	8b 40 04             	mov    0x4(%eax),%eax
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	74 0f                	je     802cad <alloc_block_BF+0x19a>
  802c9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca1:	8b 40 04             	mov    0x4(%eax),%eax
  802ca4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ca7:	8b 12                	mov    (%edx),%edx
  802ca9:	89 10                	mov    %edx,(%eax)
  802cab:	eb 0a                	jmp    802cb7 <alloc_block_BF+0x1a4>
  802cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	a3 48 51 80 00       	mov    %eax,0x805148
  802cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cca:	a1 54 51 80 00       	mov    0x805154,%eax
  802ccf:	48                   	dec    %eax
  802cd0:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdb:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce1:	8b 50 08             	mov    0x8(%eax),%edx
  802ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce7:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ced:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cf0:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf6:	8b 50 08             	mov    0x8(%eax),%edx
  802cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfc:	01 c2                	add    %eax,%edx
  802cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d01:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802d04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d07:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802d0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d0d:	eb 05                	jmp    802d14 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802d0f:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802d14:	c9                   	leave  
  802d15:	c3                   	ret    

00802d16 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d16:	55                   	push   %ebp
  802d17:	89 e5                	mov    %esp,%ebp
  802d19:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802d1c:	83 ec 04             	sub    $0x4,%esp
  802d1f:	68 e8 3f 80 00       	push   $0x803fe8
  802d24:	68 e8 00 00 00       	push   $0xe8
  802d29:	68 57 3f 80 00       	push   $0x803f57
  802d2e:	e8 26 da ff ff       	call   800759 <_panic>

00802d33 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d33:	55                   	push   %ebp
  802d34:	89 e5                	mov    %esp,%ebp
  802d36:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802d39:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802d41:	a1 38 51 80 00       	mov    0x805138,%eax
  802d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802d49:	a1 44 51 80 00       	mov    0x805144,%eax
  802d4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802d51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d55:	75 68                	jne    802dbf <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5b:	75 17                	jne    802d74 <insert_sorted_with_merge_freeList+0x41>
  802d5d:	83 ec 04             	sub    $0x4,%esp
  802d60:	68 34 3f 80 00       	push   $0x803f34
  802d65:	68 36 01 00 00       	push   $0x136
  802d6a:	68 57 3f 80 00       	push   $0x803f57
  802d6f:	e8 e5 d9 ff ff       	call   800759 <_panic>
  802d74:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	89 10                	mov    %edx,(%eax)
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	85 c0                	test   %eax,%eax
  802d86:	74 0d                	je     802d95 <insert_sorted_with_merge_freeList+0x62>
  802d88:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d90:	89 50 04             	mov    %edx,0x4(%eax)
  802d93:	eb 08                	jmp    802d9d <insert_sorted_with_merge_freeList+0x6a>
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	a3 38 51 80 00       	mov    %eax,0x805138
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802daf:	a1 44 51 80 00       	mov    0x805144,%eax
  802db4:	40                   	inc    %eax
  802db5:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802dba:	e9 ba 06 00 00       	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	8b 50 08             	mov    0x8(%eax),%edx
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcb:	01 c2                	add    %eax,%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	8b 40 08             	mov    0x8(%eax),%eax
  802dd3:	39 c2                	cmp    %eax,%edx
  802dd5:	73 68                	jae    802e3f <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802dd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ddb:	75 17                	jne    802df4 <insert_sorted_with_merge_freeList+0xc1>
  802ddd:	83 ec 04             	sub    $0x4,%esp
  802de0:	68 70 3f 80 00       	push   $0x803f70
  802de5:	68 3a 01 00 00       	push   $0x13a
  802dea:	68 57 3f 80 00       	push   $0x803f57
  802def:	e8 65 d9 ff ff       	call   800759 <_panic>
  802df4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	89 50 04             	mov    %edx,0x4(%eax)
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 40 04             	mov    0x4(%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	74 0c                	je     802e16 <insert_sorted_with_merge_freeList+0xe3>
  802e0a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e12:	89 10                	mov    %edx,(%eax)
  802e14:	eb 08                	jmp    802e1e <insert_sorted_with_merge_freeList+0xeb>
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	a3 38 51 80 00       	mov    %eax,0x805138
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e34:	40                   	inc    %eax
  802e35:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802e3a:	e9 3a 06 00 00       	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	8b 50 08             	mov    0x8(%eax),%edx
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4b:	01 c2                	add    %eax,%edx
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	8b 40 08             	mov    0x8(%eax),%eax
  802e53:	39 c2                	cmp    %eax,%edx
  802e55:	0f 85 90 00 00 00    	jne    802eeb <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	8b 40 0c             	mov    0xc(%eax),%eax
  802e67:	01 c2                	add    %eax,%edx
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e87:	75 17                	jne    802ea0 <insert_sorted_with_merge_freeList+0x16d>
  802e89:	83 ec 04             	sub    $0x4,%esp
  802e8c:	68 34 3f 80 00       	push   $0x803f34
  802e91:	68 41 01 00 00       	push   $0x141
  802e96:	68 57 3f 80 00       	push   $0x803f57
  802e9b:	e8 b9 d8 ff ff       	call   800759 <_panic>
  802ea0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	89 10                	mov    %edx,(%eax)
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 00                	mov    (%eax),%eax
  802eb0:	85 c0                	test   %eax,%eax
  802eb2:	74 0d                	je     802ec1 <insert_sorted_with_merge_freeList+0x18e>
  802eb4:	a1 48 51 80 00       	mov    0x805148,%eax
  802eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebc:	89 50 04             	mov    %edx,0x4(%eax)
  802ebf:	eb 08                	jmp    802ec9 <insert_sorted_with_merge_freeList+0x196>
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	a3 48 51 80 00       	mov    %eax,0x805148
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edb:	a1 54 51 80 00       	mov    0x805154,%eax
  802ee0:	40                   	inc    %eax
  802ee1:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802ee6:	e9 8e 05 00 00       	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	8b 50 08             	mov    0x8(%eax),%edx
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef7:	01 c2                	add    %eax,%edx
  802ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efc:	8b 40 08             	mov    0x8(%eax),%eax
  802eff:	39 c2                	cmp    %eax,%edx
  802f01:	73 68                	jae    802f6b <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f07:	75 17                	jne    802f20 <insert_sorted_with_merge_freeList+0x1ed>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 34 3f 80 00       	push   $0x803f34
  802f11:	68 45 01 00 00       	push   $0x145
  802f16:	68 57 3f 80 00       	push   $0x803f57
  802f1b:	e8 39 d8 ff ff       	call   800759 <_panic>
  802f20:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 0d                	je     802f41 <insert_sorted_with_merge_freeList+0x20e>
  802f34:	a1 38 51 80 00       	mov    0x805138,%eax
  802f39:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
  802f3f:	eb 08                	jmp    802f49 <insert_sorted_with_merge_freeList+0x216>
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f60:	40                   	inc    %eax
  802f61:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802f66:	e9 0e 05 00 00       	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	01 c2                	add    %eax,%edx
  802f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7c:	8b 40 08             	mov    0x8(%eax),%eax
  802f7f:	39 c2                	cmp    %eax,%edx
  802f81:	0f 85 9c 00 00 00    	jne    803023 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802f87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 40 0c             	mov    0xc(%eax),%eax
  802f93:	01 c2                	add    %eax,%edx
  802f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f98:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 50 08             	mov    0x8(%eax),%edx
  802fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa4:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fbf:	75 17                	jne    802fd8 <insert_sorted_with_merge_freeList+0x2a5>
  802fc1:	83 ec 04             	sub    $0x4,%esp
  802fc4:	68 34 3f 80 00       	push   $0x803f34
  802fc9:	68 4d 01 00 00       	push   $0x14d
  802fce:	68 57 3f 80 00       	push   $0x803f57
  802fd3:	e8 81 d7 ff ff       	call   800759 <_panic>
  802fd8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	89 10                	mov    %edx,(%eax)
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	74 0d                	je     802ff9 <insert_sorted_with_merge_freeList+0x2c6>
  802fec:	a1 48 51 80 00       	mov    0x805148,%eax
  802ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff4:	89 50 04             	mov    %edx,0x4(%eax)
  802ff7:	eb 08                	jmp    803001 <insert_sorted_with_merge_freeList+0x2ce>
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	a3 48 51 80 00       	mov    %eax,0x805148
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803013:	a1 54 51 80 00       	mov    0x805154,%eax
  803018:	40                   	inc    %eax
  803019:	a3 54 51 80 00       	mov    %eax,0x805154





}
  80301e:	e9 56 04 00 00       	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803023:	a1 38 51 80 00       	mov    0x805138,%eax
  803028:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80302b:	e9 19 04 00 00       	jmp    803449 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  803030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 50 08             	mov    0x8(%eax),%edx
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 40 0c             	mov    0xc(%eax),%eax
  803044:	01 c2                	add    %eax,%edx
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	8b 40 08             	mov    0x8(%eax),%eax
  80304c:	39 c2                	cmp    %eax,%edx
  80304e:	0f 85 ad 01 00 00    	jne    803201 <insert_sorted_with_merge_freeList+0x4ce>
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 50 08             	mov    0x8(%eax),%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	8b 40 0c             	mov    0xc(%eax),%eax
  803060:	01 c2                	add    %eax,%edx
  803062:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803065:	8b 40 08             	mov    0x8(%eax),%eax
  803068:	39 c2                	cmp    %eax,%edx
  80306a:	0f 85 91 01 00 00    	jne    803201 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 50 0c             	mov    0xc(%eax),%edx
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 48 0c             	mov    0xc(%eax),%ecx
  80307c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307f:	8b 40 0c             	mov    0xc(%eax),%eax
  803082:	01 c8                	add    %ecx,%eax
  803084:	01 c2                	add    %eax,%edx
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8030a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8030aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  8030b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030b8:	75 17                	jne    8030d1 <insert_sorted_with_merge_freeList+0x39e>
  8030ba:	83 ec 04             	sub    $0x4,%esp
  8030bd:	68 c8 3f 80 00       	push   $0x803fc8
  8030c2:	68 5b 01 00 00       	push   $0x15b
  8030c7:	68 57 3f 80 00       	push   $0x803f57
  8030cc:	e8 88 d6 ff ff       	call   800759 <_panic>
  8030d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d4:	8b 00                	mov    (%eax),%eax
  8030d6:	85 c0                	test   %eax,%eax
  8030d8:	74 10                	je     8030ea <insert_sorted_with_merge_freeList+0x3b7>
  8030da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030dd:	8b 00                	mov    (%eax),%eax
  8030df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030e2:	8b 52 04             	mov    0x4(%edx),%edx
  8030e5:	89 50 04             	mov    %edx,0x4(%eax)
  8030e8:	eb 0b                	jmp    8030f5 <insert_sorted_with_merge_freeList+0x3c2>
  8030ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f8:	8b 40 04             	mov    0x4(%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 0f                	je     80310e <insert_sorted_with_merge_freeList+0x3db>
  8030ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803102:	8b 40 04             	mov    0x4(%eax),%eax
  803105:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803108:	8b 12                	mov    (%edx),%edx
  80310a:	89 10                	mov    %edx,(%eax)
  80310c:	eb 0a                	jmp    803118 <insert_sorted_with_merge_freeList+0x3e5>
  80310e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	a3 38 51 80 00       	mov    %eax,0x805138
  803118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803124:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312b:	a1 44 51 80 00       	mov    0x805144,%eax
  803130:	48                   	dec    %eax
  803131:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803136:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313a:	75 17                	jne    803153 <insert_sorted_with_merge_freeList+0x420>
  80313c:	83 ec 04             	sub    $0x4,%esp
  80313f:	68 34 3f 80 00       	push   $0x803f34
  803144:	68 5c 01 00 00       	push   $0x15c
  803149:	68 57 3f 80 00       	push   $0x803f57
  80314e:	e8 06 d6 ff ff       	call   800759 <_panic>
  803153:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	89 10                	mov    %edx,(%eax)
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	8b 00                	mov    (%eax),%eax
  803163:	85 c0                	test   %eax,%eax
  803165:	74 0d                	je     803174 <insert_sorted_with_merge_freeList+0x441>
  803167:	a1 48 51 80 00       	mov    0x805148,%eax
  80316c:	8b 55 08             	mov    0x8(%ebp),%edx
  80316f:	89 50 04             	mov    %edx,0x4(%eax)
  803172:	eb 08                	jmp    80317c <insert_sorted_with_merge_freeList+0x449>
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	a3 48 51 80 00       	mov    %eax,0x805148
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318e:	a1 54 51 80 00       	mov    0x805154,%eax
  803193:	40                   	inc    %eax
  803194:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  803199:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80319d:	75 17                	jne    8031b6 <insert_sorted_with_merge_freeList+0x483>
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	68 34 3f 80 00       	push   $0x803f34
  8031a7:	68 5d 01 00 00       	push   $0x15d
  8031ac:	68 57 3f 80 00       	push   $0x803f57
  8031b1:	e8 a3 d5 ff ff       	call   800759 <_panic>
  8031b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bf:	89 10                	mov    %edx,(%eax)
  8031c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c4:	8b 00                	mov    (%eax),%eax
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	74 0d                	je     8031d7 <insert_sorted_with_merge_freeList+0x4a4>
  8031ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8031cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031d2:	89 50 04             	mov    %edx,0x4(%eax)
  8031d5:	eb 08                	jmp    8031df <insert_sorted_with_merge_freeList+0x4ac>
  8031d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8031e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f6:	40                   	inc    %eax
  8031f7:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8031fc:	e9 78 02 00 00       	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803204:	8b 50 08             	mov    0x8(%eax),%edx
  803207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320a:	8b 40 0c             	mov    0xc(%eax),%eax
  80320d:	01 c2                	add    %eax,%edx
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	8b 40 08             	mov    0x8(%eax),%eax
  803215:	39 c2                	cmp    %eax,%edx
  803217:	0f 83 b8 00 00 00    	jae    8032d5 <insert_sorted_with_merge_freeList+0x5a2>
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	8b 50 08             	mov    0x8(%eax),%edx
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	8b 40 0c             	mov    0xc(%eax),%eax
  803229:	01 c2                	add    %eax,%edx
  80322b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322e:	8b 40 08             	mov    0x8(%eax),%eax
  803231:	39 c2                	cmp    %eax,%edx
  803233:	0f 85 9c 00 00 00    	jne    8032d5 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803239:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323c:	8b 50 0c             	mov    0xc(%eax),%edx
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	8b 40 0c             	mov    0xc(%eax),%eax
  803245:	01 c2                	add    %eax,%edx
  803247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324a:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	8b 50 08             	mov    0x8(%eax),%edx
  803253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803256:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80326d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803271:	75 17                	jne    80328a <insert_sorted_with_merge_freeList+0x557>
  803273:	83 ec 04             	sub    $0x4,%esp
  803276:	68 34 3f 80 00       	push   $0x803f34
  80327b:	68 67 01 00 00       	push   $0x167
  803280:	68 57 3f 80 00       	push   $0x803f57
  803285:	e8 cf d4 ff ff       	call   800759 <_panic>
  80328a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	89 10                	mov    %edx,(%eax)
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	85 c0                	test   %eax,%eax
  80329c:	74 0d                	je     8032ab <insert_sorted_with_merge_freeList+0x578>
  80329e:	a1 48 51 80 00       	mov    0x805148,%eax
  8032a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a6:	89 50 04             	mov    %edx,0x4(%eax)
  8032a9:	eb 08                	jmp    8032b3 <insert_sorted_with_merge_freeList+0x580>
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ca:	40                   	inc    %eax
  8032cb:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8032d0:	e9 a4 01 00 00       	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 50 08             	mov    0x8(%eax),%edx
  8032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032de:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e1:	01 c2                	add    %eax,%edx
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	8b 40 08             	mov    0x8(%eax),%eax
  8032e9:	39 c2                	cmp    %eax,%edx
  8032eb:	0f 85 ac 00 00 00    	jne    80339d <insert_sorted_with_merge_freeList+0x66a>
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	8b 50 08             	mov    0x8(%eax),%edx
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fd:	01 c2                	add    %eax,%edx
  8032ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803302:	8b 40 08             	mov    0x8(%eax),%eax
  803305:	39 c2                	cmp    %eax,%edx
  803307:	0f 83 90 00 00 00    	jae    80339d <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	8b 50 0c             	mov    0xc(%eax),%edx
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	8b 40 0c             	mov    0xc(%eax),%eax
  803319:	01 c2                	add    %eax,%edx
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803335:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803339:	75 17                	jne    803352 <insert_sorted_with_merge_freeList+0x61f>
  80333b:	83 ec 04             	sub    $0x4,%esp
  80333e:	68 34 3f 80 00       	push   $0x803f34
  803343:	68 70 01 00 00       	push   $0x170
  803348:	68 57 3f 80 00       	push   $0x803f57
  80334d:	e8 07 d4 ff ff       	call   800759 <_panic>
  803352:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	89 10                	mov    %edx,(%eax)
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	8b 00                	mov    (%eax),%eax
  803362:	85 c0                	test   %eax,%eax
  803364:	74 0d                	je     803373 <insert_sorted_with_merge_freeList+0x640>
  803366:	a1 48 51 80 00       	mov    0x805148,%eax
  80336b:	8b 55 08             	mov    0x8(%ebp),%edx
  80336e:	89 50 04             	mov    %edx,0x4(%eax)
  803371:	eb 08                	jmp    80337b <insert_sorted_with_merge_freeList+0x648>
  803373:	8b 45 08             	mov    0x8(%ebp),%eax
  803376:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	a3 48 51 80 00       	mov    %eax,0x805148
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338d:	a1 54 51 80 00       	mov    0x805154,%eax
  803392:	40                   	inc    %eax
  803393:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803398:	e9 dc 00 00 00       	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a0:	8b 50 08             	mov    0x8(%eax),%edx
  8033a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a9:	01 c2                	add    %eax,%edx
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	8b 40 08             	mov    0x8(%eax),%eax
  8033b1:	39 c2                	cmp    %eax,%edx
  8033b3:	0f 83 88 00 00 00    	jae    803441 <insert_sorted_with_merge_freeList+0x70e>
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	8b 50 08             	mov    0x8(%eax),%edx
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c5:	01 c2                	add    %eax,%edx
  8033c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ca:	8b 40 08             	mov    0x8(%eax),%eax
  8033cd:	39 c2                	cmp    %eax,%edx
  8033cf:	73 70                	jae    803441 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  8033d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d5:	74 06                	je     8033dd <insert_sorted_with_merge_freeList+0x6aa>
  8033d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033db:	75 17                	jne    8033f4 <insert_sorted_with_merge_freeList+0x6c1>
  8033dd:	83 ec 04             	sub    $0x4,%esp
  8033e0:	68 94 3f 80 00       	push   $0x803f94
  8033e5:	68 75 01 00 00       	push   $0x175
  8033ea:	68 57 3f 80 00       	push   $0x803f57
  8033ef:	e8 65 d3 ff ff       	call   800759 <_panic>
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	8b 10                	mov    (%eax),%edx
  8033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fc:	89 10                	mov    %edx,(%eax)
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	8b 00                	mov    (%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 0b                	je     803412 <insert_sorted_with_merge_freeList+0x6df>
  803407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340a:	8b 00                	mov    (%eax),%eax
  80340c:	8b 55 08             	mov    0x8(%ebp),%edx
  80340f:	89 50 04             	mov    %edx,0x4(%eax)
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	8b 55 08             	mov    0x8(%ebp),%edx
  803418:	89 10                	mov    %edx,(%eax)
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803420:	89 50 04             	mov    %edx,0x4(%eax)
  803423:	8b 45 08             	mov    0x8(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	85 c0                	test   %eax,%eax
  80342a:	75 08                	jne    803434 <insert_sorted_with_merge_freeList+0x701>
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803434:	a1 44 51 80 00       	mov    0x805144,%eax
  803439:	40                   	inc    %eax
  80343a:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  80343f:	eb 38                	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803441:	a1 40 51 80 00       	mov    0x805140,%eax
  803446:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344d:	74 07                	je     803456 <insert_sorted_with_merge_freeList+0x723>
  80344f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	eb 05                	jmp    80345b <insert_sorted_with_merge_freeList+0x728>
  803456:	b8 00 00 00 00       	mov    $0x0,%eax
  80345b:	a3 40 51 80 00       	mov    %eax,0x805140
  803460:	a1 40 51 80 00       	mov    0x805140,%eax
  803465:	85 c0                	test   %eax,%eax
  803467:	0f 85 c3 fb ff ff    	jne    803030 <insert_sorted_with_merge_freeList+0x2fd>
  80346d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803471:	0f 85 b9 fb ff ff    	jne    803030 <insert_sorted_with_merge_freeList+0x2fd>





}
  803477:	eb 00                	jmp    803479 <insert_sorted_with_merge_freeList+0x746>
  803479:	90                   	nop
  80347a:	c9                   	leave  
  80347b:	c3                   	ret    

0080347c <__udivdi3>:
  80347c:	55                   	push   %ebp
  80347d:	57                   	push   %edi
  80347e:	56                   	push   %esi
  80347f:	53                   	push   %ebx
  803480:	83 ec 1c             	sub    $0x1c,%esp
  803483:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803487:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80348b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80348f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803493:	89 ca                	mov    %ecx,%edx
  803495:	89 f8                	mov    %edi,%eax
  803497:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80349b:	85 f6                	test   %esi,%esi
  80349d:	75 2d                	jne    8034cc <__udivdi3+0x50>
  80349f:	39 cf                	cmp    %ecx,%edi
  8034a1:	77 65                	ja     803508 <__udivdi3+0x8c>
  8034a3:	89 fd                	mov    %edi,%ebp
  8034a5:	85 ff                	test   %edi,%edi
  8034a7:	75 0b                	jne    8034b4 <__udivdi3+0x38>
  8034a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ae:	31 d2                	xor    %edx,%edx
  8034b0:	f7 f7                	div    %edi
  8034b2:	89 c5                	mov    %eax,%ebp
  8034b4:	31 d2                	xor    %edx,%edx
  8034b6:	89 c8                	mov    %ecx,%eax
  8034b8:	f7 f5                	div    %ebp
  8034ba:	89 c1                	mov    %eax,%ecx
  8034bc:	89 d8                	mov    %ebx,%eax
  8034be:	f7 f5                	div    %ebp
  8034c0:	89 cf                	mov    %ecx,%edi
  8034c2:	89 fa                	mov    %edi,%edx
  8034c4:	83 c4 1c             	add    $0x1c,%esp
  8034c7:	5b                   	pop    %ebx
  8034c8:	5e                   	pop    %esi
  8034c9:	5f                   	pop    %edi
  8034ca:	5d                   	pop    %ebp
  8034cb:	c3                   	ret    
  8034cc:	39 ce                	cmp    %ecx,%esi
  8034ce:	77 28                	ja     8034f8 <__udivdi3+0x7c>
  8034d0:	0f bd fe             	bsr    %esi,%edi
  8034d3:	83 f7 1f             	xor    $0x1f,%edi
  8034d6:	75 40                	jne    803518 <__udivdi3+0x9c>
  8034d8:	39 ce                	cmp    %ecx,%esi
  8034da:	72 0a                	jb     8034e6 <__udivdi3+0x6a>
  8034dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034e0:	0f 87 9e 00 00 00    	ja     803584 <__udivdi3+0x108>
  8034e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034eb:	89 fa                	mov    %edi,%edx
  8034ed:	83 c4 1c             	add    $0x1c,%esp
  8034f0:	5b                   	pop    %ebx
  8034f1:	5e                   	pop    %esi
  8034f2:	5f                   	pop    %edi
  8034f3:	5d                   	pop    %ebp
  8034f4:	c3                   	ret    
  8034f5:	8d 76 00             	lea    0x0(%esi),%esi
  8034f8:	31 ff                	xor    %edi,%edi
  8034fa:	31 c0                	xor    %eax,%eax
  8034fc:	89 fa                	mov    %edi,%edx
  8034fe:	83 c4 1c             	add    $0x1c,%esp
  803501:	5b                   	pop    %ebx
  803502:	5e                   	pop    %esi
  803503:	5f                   	pop    %edi
  803504:	5d                   	pop    %ebp
  803505:	c3                   	ret    
  803506:	66 90                	xchg   %ax,%ax
  803508:	89 d8                	mov    %ebx,%eax
  80350a:	f7 f7                	div    %edi
  80350c:	31 ff                	xor    %edi,%edi
  80350e:	89 fa                	mov    %edi,%edx
  803510:	83 c4 1c             	add    $0x1c,%esp
  803513:	5b                   	pop    %ebx
  803514:	5e                   	pop    %esi
  803515:	5f                   	pop    %edi
  803516:	5d                   	pop    %ebp
  803517:	c3                   	ret    
  803518:	bd 20 00 00 00       	mov    $0x20,%ebp
  80351d:	89 eb                	mov    %ebp,%ebx
  80351f:	29 fb                	sub    %edi,%ebx
  803521:	89 f9                	mov    %edi,%ecx
  803523:	d3 e6                	shl    %cl,%esi
  803525:	89 c5                	mov    %eax,%ebp
  803527:	88 d9                	mov    %bl,%cl
  803529:	d3 ed                	shr    %cl,%ebp
  80352b:	89 e9                	mov    %ebp,%ecx
  80352d:	09 f1                	or     %esi,%ecx
  80352f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803533:	89 f9                	mov    %edi,%ecx
  803535:	d3 e0                	shl    %cl,%eax
  803537:	89 c5                	mov    %eax,%ebp
  803539:	89 d6                	mov    %edx,%esi
  80353b:	88 d9                	mov    %bl,%cl
  80353d:	d3 ee                	shr    %cl,%esi
  80353f:	89 f9                	mov    %edi,%ecx
  803541:	d3 e2                	shl    %cl,%edx
  803543:	8b 44 24 08          	mov    0x8(%esp),%eax
  803547:	88 d9                	mov    %bl,%cl
  803549:	d3 e8                	shr    %cl,%eax
  80354b:	09 c2                	or     %eax,%edx
  80354d:	89 d0                	mov    %edx,%eax
  80354f:	89 f2                	mov    %esi,%edx
  803551:	f7 74 24 0c          	divl   0xc(%esp)
  803555:	89 d6                	mov    %edx,%esi
  803557:	89 c3                	mov    %eax,%ebx
  803559:	f7 e5                	mul    %ebp
  80355b:	39 d6                	cmp    %edx,%esi
  80355d:	72 19                	jb     803578 <__udivdi3+0xfc>
  80355f:	74 0b                	je     80356c <__udivdi3+0xf0>
  803561:	89 d8                	mov    %ebx,%eax
  803563:	31 ff                	xor    %edi,%edi
  803565:	e9 58 ff ff ff       	jmp    8034c2 <__udivdi3+0x46>
  80356a:	66 90                	xchg   %ax,%ax
  80356c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803570:	89 f9                	mov    %edi,%ecx
  803572:	d3 e2                	shl    %cl,%edx
  803574:	39 c2                	cmp    %eax,%edx
  803576:	73 e9                	jae    803561 <__udivdi3+0xe5>
  803578:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80357b:	31 ff                	xor    %edi,%edi
  80357d:	e9 40 ff ff ff       	jmp    8034c2 <__udivdi3+0x46>
  803582:	66 90                	xchg   %ax,%ax
  803584:	31 c0                	xor    %eax,%eax
  803586:	e9 37 ff ff ff       	jmp    8034c2 <__udivdi3+0x46>
  80358b:	90                   	nop

0080358c <__umoddi3>:
  80358c:	55                   	push   %ebp
  80358d:	57                   	push   %edi
  80358e:	56                   	push   %esi
  80358f:	53                   	push   %ebx
  803590:	83 ec 1c             	sub    $0x1c,%esp
  803593:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803597:	8b 74 24 34          	mov    0x34(%esp),%esi
  80359b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80359f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035ab:	89 f3                	mov    %esi,%ebx
  8035ad:	89 fa                	mov    %edi,%edx
  8035af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035b3:	89 34 24             	mov    %esi,(%esp)
  8035b6:	85 c0                	test   %eax,%eax
  8035b8:	75 1a                	jne    8035d4 <__umoddi3+0x48>
  8035ba:	39 f7                	cmp    %esi,%edi
  8035bc:	0f 86 a2 00 00 00    	jbe    803664 <__umoddi3+0xd8>
  8035c2:	89 c8                	mov    %ecx,%eax
  8035c4:	89 f2                	mov    %esi,%edx
  8035c6:	f7 f7                	div    %edi
  8035c8:	89 d0                	mov    %edx,%eax
  8035ca:	31 d2                	xor    %edx,%edx
  8035cc:	83 c4 1c             	add    $0x1c,%esp
  8035cf:	5b                   	pop    %ebx
  8035d0:	5e                   	pop    %esi
  8035d1:	5f                   	pop    %edi
  8035d2:	5d                   	pop    %ebp
  8035d3:	c3                   	ret    
  8035d4:	39 f0                	cmp    %esi,%eax
  8035d6:	0f 87 ac 00 00 00    	ja     803688 <__umoddi3+0xfc>
  8035dc:	0f bd e8             	bsr    %eax,%ebp
  8035df:	83 f5 1f             	xor    $0x1f,%ebp
  8035e2:	0f 84 ac 00 00 00    	je     803694 <__umoddi3+0x108>
  8035e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8035ed:	29 ef                	sub    %ebp,%edi
  8035ef:	89 fe                	mov    %edi,%esi
  8035f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035f5:	89 e9                	mov    %ebp,%ecx
  8035f7:	d3 e0                	shl    %cl,%eax
  8035f9:	89 d7                	mov    %edx,%edi
  8035fb:	89 f1                	mov    %esi,%ecx
  8035fd:	d3 ef                	shr    %cl,%edi
  8035ff:	09 c7                	or     %eax,%edi
  803601:	89 e9                	mov    %ebp,%ecx
  803603:	d3 e2                	shl    %cl,%edx
  803605:	89 14 24             	mov    %edx,(%esp)
  803608:	89 d8                	mov    %ebx,%eax
  80360a:	d3 e0                	shl    %cl,%eax
  80360c:	89 c2                	mov    %eax,%edx
  80360e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803612:	d3 e0                	shl    %cl,%eax
  803614:	89 44 24 04          	mov    %eax,0x4(%esp)
  803618:	8b 44 24 08          	mov    0x8(%esp),%eax
  80361c:	89 f1                	mov    %esi,%ecx
  80361e:	d3 e8                	shr    %cl,%eax
  803620:	09 d0                	or     %edx,%eax
  803622:	d3 eb                	shr    %cl,%ebx
  803624:	89 da                	mov    %ebx,%edx
  803626:	f7 f7                	div    %edi
  803628:	89 d3                	mov    %edx,%ebx
  80362a:	f7 24 24             	mull   (%esp)
  80362d:	89 c6                	mov    %eax,%esi
  80362f:	89 d1                	mov    %edx,%ecx
  803631:	39 d3                	cmp    %edx,%ebx
  803633:	0f 82 87 00 00 00    	jb     8036c0 <__umoddi3+0x134>
  803639:	0f 84 91 00 00 00    	je     8036d0 <__umoddi3+0x144>
  80363f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803643:	29 f2                	sub    %esi,%edx
  803645:	19 cb                	sbb    %ecx,%ebx
  803647:	89 d8                	mov    %ebx,%eax
  803649:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80364d:	d3 e0                	shl    %cl,%eax
  80364f:	89 e9                	mov    %ebp,%ecx
  803651:	d3 ea                	shr    %cl,%edx
  803653:	09 d0                	or     %edx,%eax
  803655:	89 e9                	mov    %ebp,%ecx
  803657:	d3 eb                	shr    %cl,%ebx
  803659:	89 da                	mov    %ebx,%edx
  80365b:	83 c4 1c             	add    $0x1c,%esp
  80365e:	5b                   	pop    %ebx
  80365f:	5e                   	pop    %esi
  803660:	5f                   	pop    %edi
  803661:	5d                   	pop    %ebp
  803662:	c3                   	ret    
  803663:	90                   	nop
  803664:	89 fd                	mov    %edi,%ebp
  803666:	85 ff                	test   %edi,%edi
  803668:	75 0b                	jne    803675 <__umoddi3+0xe9>
  80366a:	b8 01 00 00 00       	mov    $0x1,%eax
  80366f:	31 d2                	xor    %edx,%edx
  803671:	f7 f7                	div    %edi
  803673:	89 c5                	mov    %eax,%ebp
  803675:	89 f0                	mov    %esi,%eax
  803677:	31 d2                	xor    %edx,%edx
  803679:	f7 f5                	div    %ebp
  80367b:	89 c8                	mov    %ecx,%eax
  80367d:	f7 f5                	div    %ebp
  80367f:	89 d0                	mov    %edx,%eax
  803681:	e9 44 ff ff ff       	jmp    8035ca <__umoddi3+0x3e>
  803686:	66 90                	xchg   %ax,%ax
  803688:	89 c8                	mov    %ecx,%eax
  80368a:	89 f2                	mov    %esi,%edx
  80368c:	83 c4 1c             	add    $0x1c,%esp
  80368f:	5b                   	pop    %ebx
  803690:	5e                   	pop    %esi
  803691:	5f                   	pop    %edi
  803692:	5d                   	pop    %ebp
  803693:	c3                   	ret    
  803694:	3b 04 24             	cmp    (%esp),%eax
  803697:	72 06                	jb     80369f <__umoddi3+0x113>
  803699:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80369d:	77 0f                	ja     8036ae <__umoddi3+0x122>
  80369f:	89 f2                	mov    %esi,%edx
  8036a1:	29 f9                	sub    %edi,%ecx
  8036a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036a7:	89 14 24             	mov    %edx,(%esp)
  8036aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036b2:	8b 14 24             	mov    (%esp),%edx
  8036b5:	83 c4 1c             	add    $0x1c,%esp
  8036b8:	5b                   	pop    %ebx
  8036b9:	5e                   	pop    %esi
  8036ba:	5f                   	pop    %edi
  8036bb:	5d                   	pop    %ebp
  8036bc:	c3                   	ret    
  8036bd:	8d 76 00             	lea    0x0(%esi),%esi
  8036c0:	2b 04 24             	sub    (%esp),%eax
  8036c3:	19 fa                	sbb    %edi,%edx
  8036c5:	89 d1                	mov    %edx,%ecx
  8036c7:	89 c6                	mov    %eax,%esi
  8036c9:	e9 71 ff ff ff       	jmp    80363f <__umoddi3+0xb3>
  8036ce:	66 90                	xchg   %ax,%ax
  8036d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036d4:	72 ea                	jb     8036c0 <__umoddi3+0x134>
  8036d6:	89 d9                	mov    %ebx,%ecx
  8036d8:	e9 62 ff ff ff       	jmp    80363f <__umoddi3+0xb3>
