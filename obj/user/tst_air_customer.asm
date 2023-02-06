
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 dc 03 00 00       	call   800412 <libmain>
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
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 8a 1c 00 00       	call   801cd3 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb 29 35 80 00       	mov    $0x803529,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb 33 35 80 00       	mov    $0x803533,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb 3f 35 80 00       	mov    $0x80353f,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb 4e 35 80 00       	mov    $0x80354e,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb 5d 35 80 00       	mov    $0x80355d,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 72 35 80 00       	mov    $0x803572,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 87 35 80 00       	mov    $0x803587,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 98 35 80 00       	mov    $0x803598,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb a9 35 80 00       	mov    $0x8035a9,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb ba 35 80 00       	mov    $0x8035ba,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb c3 35 80 00       	mov    $0x8035c3,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb cd 35 80 00       	mov    $0x8035cd,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb d8 35 80 00       	mov    $0x8035d8,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb e4 35 80 00       	mov    $0x8035e4,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb ee 35 80 00       	mov    $0x8035ee,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb f8 35 80 00       	mov    $0x8035f8,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 06 36 80 00       	mov    $0x803606,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 15 36 80 00       	mov    $0x803615,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 1c 36 80 00       	mov    $0x80361c,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 8e 15 00 00       	call   8017b5 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 79 15 00 00       	call   8017b5 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 61 15 00 00       	call   8017b5 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 49 15 00 00       	call   8017b5 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 f0 18 00 00       	call   801b74 <sys_waitSemaphore>
  800284:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  800287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028a:	8b 00                	mov    (%eax),%eax
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	8d 50 01             	lea    0x1(%eax),%edx
  800297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029a:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custCounterCS);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	e8 e4 18 00 00       	call   801b92 <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 b1 18 00 00       	call   801b74 <sys_waitSemaphore>
  8002c3:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  8002c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	sys_waitSemaphore(parentenvID, _custQueueCS);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	e8 88 18 00 00       	call   801b74 <sys_waitSemaphore>
  8002ec:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  8002ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fe:	01 c2                	add    %eax,%edx
  800300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800303:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 50 01             	lea    0x1(%eax),%edx
  80030d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800310:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custQueueCS);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 6e 18 00 00       	call   801b92 <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 59 18 00 00       	call   801b92 <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb 23 36 80 00       	mov    $0x803623,%ebx
  800347:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	89 de                	mov    %ebx,%esi
  800350:	89 d1                	mov    %edx,%ecx
  800352:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800354:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  80035a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 d7                	mov    %edx,%edi
  800366:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	ff 75 d0             	pushl  -0x30(%ebp)
  800375:	e8 d0 0d 00 00       	call   80114a <ltostr>
  80037a:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 a8 0e 00 00       	call   801242 <strcconcat>
  80039a:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(parentenvID, sname);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	e8 c5 17 00 00       	call   801b74 <sys_waitSemaphore>
  8003af:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  8003b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	01 d0                	add    %edx,%eax
  8003c1:	8b 40 04             	mov    0x4(%eax),%eax
  8003c4:	83 f8 01             	cmp    $0x1,%eax
  8003c7:	75 18                	jne    8003e1 <_main+0x3a9>
	{
		cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d2:	68 e0 34 80 00       	push   $0x8034e0
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 08 35 80 00       	push   $0x803508
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 8c 17 00 00       	call   801b92 <sys_signalSemaphore>
  800406:	83 c4 10             	add    $0x10,%esp

	return;
  800409:	90                   	nop
}
  80040a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800418:	e8 9d 18 00 00       	call   801cba <sys_getenvindex>
  80041d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	c1 e0 04             	shl    $0x4,%eax
  80043a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800444:	a1 20 40 80 00       	mov    0x804020,%eax
  800449:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044f:	84 c0                	test   %al,%al
  800451:	74 0f                	je     800462 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	05 5c 05 00 00       	add    $0x55c,%eax
  80045d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800466:	7e 0a                	jle    800472 <libmain+0x60>
		binaryname = argv[0];
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 b8 fb ff ff       	call   800038 <_main>
  800480:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800483:	e8 3f 16 00 00       	call   801ac7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 5c 36 80 00       	push   $0x80365c
  800490:	e8 8d 01 00 00       	call   800622 <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8004a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	68 84 36 80 00       	push   $0x803684
  8004b8:	e8 65 01 00 00       	call   800622 <cprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004db:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	68 ac 36 80 00       	push   $0x8036ac
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 04 37 80 00       	push   $0x803704
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 5c 36 80 00       	push   $0x80365c
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 bf 15 00 00       	call   801ae1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800522:	e8 19 00 00 00       	call   800540 <exit>
}
  800527:	90                   	nop
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	6a 00                	push   $0x0
  800535:	e8 4c 17 00 00       	call   801c86 <sys_destroy_env>
  80053a:	83 c4 10             	add    $0x10,%esp
}
  80053d:	90                   	nop
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <exit>:

void
exit(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800546:	e8 a1 17 00 00       	call   801cec <sys_exit_env>
}
  80054b:	90                   	nop
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	8d 48 01             	lea    0x1(%eax),%ecx
  80055c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055f:	89 0a                	mov    %ecx,(%edx)
  800561:	8b 55 08             	mov    0x8(%ebp),%edx
  800564:	88 d1                	mov    %dl,%cl
  800566:	8b 55 0c             	mov    0xc(%ebp),%edx
  800569:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800579:	a0 24 40 80 00       	mov    0x804024,%al
  80057e:	0f b6 c0             	movzbl %al,%eax
  800581:	8b 55 0c             	mov    0xc(%ebp),%edx
  800584:	8b 12                	mov    (%edx),%edx
  800586:	89 d1                	mov    %edx,%ecx
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	83 c2 08             	add    $0x8,%edx
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	50                   	push   %eax
  800592:	51                   	push   %ecx
  800593:	52                   	push   %edx
  800594:	e8 80 13 00 00       	call   801919 <sys_cputs>
  800599:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	8b 40 04             	mov    0x4(%eax),%eax
  8005ab:	8d 50 01             	lea    0x1(%eax),%edx
  8005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b4:	90                   	nop
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c7:	00 00 00 
	b.cnt = 0;
  8005ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e0:	50                   	push   %eax
  8005e1:	68 4e 05 80 00       	push   $0x80054e
  8005e6:	e8 11 02 00 00       	call   8007fc <vprintfmt>
  8005eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ee:	a0 24 40 80 00       	mov    0x804024,%al
  8005f3:	0f b6 c0             	movzbl %al,%eax
  8005f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005fc:	83 ec 04             	sub    $0x4,%esp
  8005ff:	50                   	push   %eax
  800600:	52                   	push   %edx
  800601:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800607:	83 c0 08             	add    $0x8,%eax
  80060a:	50                   	push   %eax
  80060b:	e8 09 13 00 00       	call   801919 <sys_cputs>
  800610:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800613:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <cprintf>:

int cprintf(const char *fmt, ...) {
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800628:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 f4             	pushl  -0xc(%ebp)
  80063e:	50                   	push   %eax
  80063f:	e8 73 ff ff ff       	call   8005b7 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800655:	e8 6d 14 00 00       	call   801ac7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 48 ff ff ff       	call   8005b7 <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800675:	e8 67 14 00 00       	call   801ae1 <sys_enable_interrupt>
	return cnt;
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 14             	sub    $0x14,%esp
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069d:	77 55                	ja     8006f4 <printnum+0x75>
  80069f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a2:	72 05                	jb     8006a9 <printnum+0x2a>
  8006a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a7:	77 4b                	ja     8006f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bf:	e8 b0 2b 00 00       	call   803274 <__udivdi3>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	ff 75 20             	pushl  0x20(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	ff 75 18             	pushl  0x18(%ebp)
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 a1 ff ff ff       	call   80067f <printnum>
  8006de:	83 c4 20             	add    $0x20,%esp
  8006e1:	eb 1a                	jmp    8006fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 20             	pushl  0x20(%ebp)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fb:	7f e6                	jg     8006e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800700:	bb 00 00 00 00       	mov    $0x0,%ebx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070b:	53                   	push   %ebx
  80070c:	51                   	push   %ecx
  80070d:	52                   	push   %edx
  80070e:	50                   	push   %eax
  80070f:	e8 70 2c 00 00       	call   803384 <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 34 39 80 00       	add    $0x803934,%eax
  80071c:	8a 00                	mov    (%eax),%al
  80071e:	0f be c0             	movsbl %al,%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
}
  800730:	90                   	nop
  800731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800739:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073d:	7e 1c                	jle    80075b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	8d 50 08             	lea    0x8(%eax),%edx
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	89 10                	mov    %edx,(%eax)
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	83 e8 08             	sub    $0x8,%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	eb 40                	jmp    80079b <getuint+0x65>
	else if (lflag)
  80075b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075f:	74 1e                	je     80077f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 04             	lea    0x4(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	eb 1c                	jmp    80079b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 04             	lea    0x4(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 04             	sub    $0x4,%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a4:	7e 1c                	jle    8007c2 <getint+0x25>
		return va_arg(*ap, long long);
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	8d 50 08             	lea    0x8(%eax),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	89 10                	mov    %edx,(%eax)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	83 e8 08             	sub    $0x8,%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	eb 38                	jmp    8007fa <getint+0x5d>
	else if (lflag)
  8007c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c6:	74 1a                	je     8007e2 <getint+0x45>
		return va_arg(*ap, long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 04             	lea    0x4(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	99                   	cltd   
  8007e0:	eb 18                	jmp    8007fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	99                   	cltd   
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	56                   	push   %esi
  800800:	53                   	push   %ebx
  800801:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	eb 17                	jmp    80081d <vprintfmt+0x21>
			if (ch == '\0')
  800806:	85 db                	test   %ebx,%ebx
  800808:	0f 84 af 03 00 00    	je     800bbd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	89 55 10             	mov    %edx,0x10(%ebp)
  800826:	8a 00                	mov    (%eax),%al
  800828:	0f b6 d8             	movzbl %al,%ebx
  80082b:	83 fb 25             	cmp    $0x25,%ebx
  80082e:	75 d6                	jne    800806 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800830:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800834:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800842:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800849:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	89 55 10             	mov    %edx,0x10(%ebp)
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f b6 d8             	movzbl %al,%ebx
  80085e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800861:	83 f8 55             	cmp    $0x55,%eax
  800864:	0f 87 2b 03 00 00    	ja     800b95 <vprintfmt+0x399>
  80086a:	8b 04 85 58 39 80 00 	mov    0x803958(,%eax,4),%eax
  800871:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800873:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800877:	eb d7                	jmp    800850 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800879:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80087d:	eb d1                	jmp    800850 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	c1 e0 02             	shl    $0x2,%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	01 d8                	add    %ebx,%eax
  800894:	83 e8 30             	sub    $0x30,%eax
  800897:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a5:	7e 3e                	jle    8008e5 <vprintfmt+0xe9>
  8008a7:	83 fb 39             	cmp    $0x39,%ebx
  8008aa:	7f 39                	jg     8008e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008af:	eb d5                	jmp    800886 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c5:	eb 1f                	jmp    8008e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cb:	79 83                	jns    800850 <vprintfmt+0x54>
				width = 0;
  8008cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d4:	e9 77 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e0:	e9 6b ff ff ff       	jmp    800850 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	0f 89 60 ff ff ff    	jns    800850 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008fd:	e9 4e ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800902:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800905:	e9 46 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 c0 04             	add    $0x4,%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	83 e8 04             	sub    $0x4,%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	50                   	push   %eax
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 89 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800940:	85 db                	test   %ebx,%ebx
  800942:	79 02                	jns    800946 <vprintfmt+0x14a>
				err = -err;
  800944:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800946:	83 fb 64             	cmp    $0x64,%ebx
  800949:	7f 0b                	jg     800956 <vprintfmt+0x15a>
  80094b:	8b 34 9d a0 37 80 00 	mov    0x8037a0(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 45 39 80 00       	push   $0x803945
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 5e 02 00 00       	call   800bc5 <printfmt>
  800967:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096a:	e9 49 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096f:	56                   	push   %esi
  800970:	68 4e 39 80 00       	push   $0x80394e
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 45 02 00 00       	call   800bc5 <printfmt>
  800980:	83 c4 10             	add    $0x10,%esp
			break;
  800983:	e9 30 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 30                	mov    (%eax),%esi
  800999:	85 f6                	test   %esi,%esi
  80099b:	75 05                	jne    8009a2 <vprintfmt+0x1a6>
				p = "(null)";
  80099d:	be 51 39 80 00       	mov    $0x803951,%esi
			if (width > 0 && padc != '-')
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	7e 6d                	jle    800a15 <vprintfmt+0x219>
  8009a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ac:	74 67                	je     800a15 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b1:	83 ec 08             	sub    $0x8,%esp
  8009b4:	50                   	push   %eax
  8009b5:	56                   	push   %esi
  8009b6:	e8 0c 03 00 00       	call   800cc7 <strnlen>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c1:	eb 16                	jmp    8009d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	50                   	push   %eax
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e4                	jg     8009c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	eb 34                	jmp    800a15 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e5:	74 1c                	je     800a03 <vprintfmt+0x207>
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 05                	jle    8009f1 <vprintfmt+0x1f5>
  8009ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ef:	7e 12                	jle    800a03 <vprintfmt+0x207>
					putch('?', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 3f                	push   $0x3f
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a12:	ff 4d e4             	decl   -0x1c(%ebp)
  800a15:	89 f0                	mov    %esi,%eax
  800a17:	8d 70 01             	lea    0x1(%eax),%esi
  800a1a:	8a 00                	mov    (%eax),%al
  800a1c:	0f be d8             	movsbl %al,%ebx
  800a1f:	85 db                	test   %ebx,%ebx
  800a21:	74 24                	je     800a47 <vprintfmt+0x24b>
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	78 b8                	js     8009e1 <vprintfmt+0x1e5>
  800a29:	ff 4d e0             	decl   -0x20(%ebp)
  800a2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a30:	79 af                	jns    8009e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	eb 13                	jmp    800a47 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 20                	push   $0x20
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	ff 4d e4             	decl   -0x1c(%ebp)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	7f e7                	jg     800a34 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a4d:	e9 66 01 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 3c fd ff ff       	call   80079d <getint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a70:	85 d2                	test   %edx,%edx
  800a72:	79 23                	jns    800a97 <vprintfmt+0x29b>
				putch('-', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 2d                	push   $0x2d
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8a:	f7 d8                	neg    %eax
  800a8c:	83 d2 00             	adc    $0x0,%edx
  800a8f:	f7 da                	neg    %edx
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 84 fc ff ff       	call   800736 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac2:	e9 98 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	6a 58                	push   $0x58
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			break;
  800af7:	e9 bc 00 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 30                	push   $0x30
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 78                	push   $0x78
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3e:	eb 1f                	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 e8             	pushl  -0x18(%ebp)
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 e7 fb ff ff       	call   800736 <getuint>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	52                   	push   %edx
  800b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	ff 75 f0             	pushl  -0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 00 fb ff ff       	call   80067f <printnum>
  800b7f:	83 c4 20             	add    $0x20,%esp
			break;
  800b82:	eb 34                	jmp    800bb8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3b1>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 47 fc ff ff       	jmp    800804 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 16 fc ff ff       	call   8007fc <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 92 fb ff ff       	call   8007fc <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea4:	eb 0e                	jmp    800eb4 <memset+0x22>
		*p++ = c;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb4:	ff 4d f8             	decl   -0x8(%ebp)
  800eb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ebb:	79 e9                	jns    800ea6 <memset+0x14>
		*p++ = c;

	return v;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed4:	eb 16                	jmp    800eec <memcpy+0x2a>
		*d++ = *s++;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 dd                	jne    800ed6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f16:	73 50                	jae    800f68 <memmove+0x6a>
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f23:	76 43                	jbe    800f68 <memmove+0x6a>
		s += n;
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f31:	eb 10                	jmp    800f43 <memmove+0x45>
			*--d = *--s;
  800f33:	ff 4d f8             	decl   -0x8(%ebp)
  800f36:	ff 4d fc             	decl   -0x4(%ebp)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 e3                	jne    800f33 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f50:	eb 23                	jmp    800f75 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 dd                	jne    800f52 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f8c:	eb 2a                	jmp    800fb8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 16                	je     800fb2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	eb 18                	jmp    800fca <memcmp+0x50>
		s1++, s2++;
  800fb2:	ff 45 fc             	incl   -0x4(%ebp)
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	75 c9                	jne    800f8e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fdd:	eb 15                	jmp    800ff4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 d0             	movzbl %al,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	0f b6 c0             	movzbl %al,%eax
  800fed:	39 c2                	cmp    %eax,%edx
  800fef:	74 0d                	je     800ffe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ffa:	72 e3                	jb     800fdf <memfind+0x13>
  800ffc:	eb 01                	jmp    800fff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffe:	90                   	nop
	return (void *) s;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801011:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801018:	eb 03                	jmp    80101d <strtol+0x19>
		s++;
  80101a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 20                	cmp    $0x20,%al
  801024:	74 f4                	je     80101a <strtol+0x16>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 09                	cmp    $0x9,%al
  80102d:	74 eb                	je     80101a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 2b                	cmp    $0x2b,%al
  801036:	75 05                	jne    80103d <strtol+0x39>
		s++;
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	eb 13                	jmp    801050 <strtol+0x4c>
	else if (*s == '-')
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 2d                	cmp    $0x2d,%al
  801044:	75 0a                	jne    801050 <strtol+0x4c>
		s++, neg = 1;
  801046:	ff 45 08             	incl   0x8(%ebp)
  801049:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	74 06                	je     80105c <strtol+0x58>
  801056:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80105a:	75 20                	jne    80107c <strtol+0x78>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 30                	cmp    $0x30,%al
  801063:	75 17                	jne    80107c <strtol+0x78>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	40                   	inc    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 78                	cmp    $0x78,%al
  80106d:	75 0d                	jne    80107c <strtol+0x78>
		s += 2, base = 16;
  80106f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801073:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80107a:	eb 28                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80107c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801080:	75 15                	jne    801097 <strtol+0x93>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 30                	cmp    $0x30,%al
  801089:	75 0c                	jne    801097 <strtol+0x93>
		s++, base = 8;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801095:	eb 0d                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0)
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	75 07                	jne    8010a4 <strtol+0xa0>
		base = 10;
  80109d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 2f                	cmp    $0x2f,%al
  8010ab:	7e 19                	jle    8010c6 <strtol+0xc2>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 39                	cmp    $0x39,%al
  8010b4:	7f 10                	jg     8010c6 <strtol+0xc2>
			dig = *s - '0';
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f be c0             	movsbl %al,%eax
  8010be:	83 e8 30             	sub    $0x30,%eax
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c4:	eb 42                	jmp    801108 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 60                	cmp    $0x60,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xe4>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 7a                	cmp    $0x7a,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 57             	sub    $0x57,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 20                	jmp    801108 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 40                	cmp    $0x40,%al
  8010ef:	7e 39                	jle    80112a <strtol+0x126>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 5a                	cmp    $0x5a,%al
  8010f8:	7f 30                	jg     80112a <strtol+0x126>
			dig = *s - 'A' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 37             	sub    $0x37,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110e:	7d 19                	jge    801129 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801110:	ff 45 08             	incl   0x8(%ebp)
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	0f af 45 10          	imul   0x10(%ebp),%eax
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801124:	e9 7b ff ff ff       	jmp    8010a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801129:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80112a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112e:	74 08                	je     801138 <strtol+0x134>
		*endptr = (char *) s;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 07                	je     801145 <strtol+0x141>
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	f7 d8                	neg    %eax
  801143:	eb 03                	jmp    801148 <strtol+0x144>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <ltostr>:

void
ltostr(long value, char *str)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801162:	79 13                	jns    801177 <ltostr+0x2d>
	{
		neg = 1;
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801171:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801174:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117f:	99                   	cltd   
  801180:	f7 f9                	idiv   %ecx
  801182:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801198:	83 c2 30             	add    $0x30,%edx
  80119b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a5:	f7 e9                	imul   %ecx
  8011a7:	c1 fa 02             	sar    $0x2,%edx
  8011aa:	89 c8                	mov    %ecx,%eax
  8011ac:	c1 f8 1f             	sar    $0x1f,%eax
  8011af:	29 c2                	sub    %eax,%edx
  8011b1:	89 d0                	mov    %edx,%eax
  8011b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011be:	f7 e9                	imul   %ecx
  8011c0:	c1 fa 02             	sar    $0x2,%edx
  8011c3:	89 c8                	mov    %ecx,%eax
  8011c5:	c1 f8 1f             	sar    $0x1f,%eax
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e0 02             	shl    $0x2,%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	01 c0                	add    %eax,%eax
  8011d3:	29 c1                	sub    %eax,%ecx
  8011d5:	89 ca                	mov    %ecx,%edx
  8011d7:	85 d2                	test   %edx,%edx
  8011d9:	75 9c                	jne    801177 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	48                   	dec    %eax
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ed:	74 3d                	je     80122c <ltostr+0xe2>
		start = 1 ;
  8011ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f6:	eb 34                	jmp    80122c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	01 c2                	add    %eax,%edx
  801221:	8a 45 eb             	mov    -0x15(%ebp),%al
  801224:	88 02                	mov    %al,(%edx)
		start++ ;
  801226:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801229:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7c c4                	jl     8011f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801234:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 54 fa ff ff       	call   800ca4 <strlen>
  801250:	83 c4 04             	add    $0x4,%esp
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	e8 46 fa ff ff       	call   800ca4 <strlen>
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 17                	jmp    80128b <strcconcat+0x49>
		final[s] = str1[s] ;
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 c2                	add    %eax,%edx
  80127c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	01 c8                	add    %ecx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801288:	ff 45 fc             	incl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801291:	7c e1                	jl     801274 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801293:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80129a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012a1:	eb 1f                	jmp    8012c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	8d 50 01             	lea    0x1(%eax),%edx
  8012a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ac:	89 c2                	mov    %eax,%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c8                	add    %ecx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bf:	ff 45 f8             	incl   -0x8(%ebp)
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	7c d9                	jl     8012a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d5:	90                   	nop
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fb:	eb 0c                	jmp    801309 <strsplit+0x31>
			*string++ = 0;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8d 50 01             	lea    0x1(%eax),%edx
  801303:	89 55 08             	mov    %edx,0x8(%ebp)
  801306:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	84 c0                	test   %al,%al
  801310:	74 18                	je     80132a <strsplit+0x52>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	50                   	push   %eax
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	e8 13 fb ff ff       	call   800e36 <strchr>
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	75 d3                	jne    8012fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	84 c0                	test   %al,%al
  801331:	74 5a                	je     80138d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801333:	8b 45 14             	mov    0x14(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	83 f8 0f             	cmp    $0xf,%eax
  80133b:	75 07                	jne    801344 <strsplit+0x6c>
		{
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb 66                	jmp    8013aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801344:	8b 45 14             	mov    0x14(%ebp),%eax
  801347:	8b 00                	mov    (%eax),%eax
  801349:	8d 48 01             	lea    0x1(%eax),%ecx
  80134c:	8b 55 14             	mov    0x14(%ebp),%edx
  80134f:	89 0a                	mov    %ecx,(%edx)
  801351:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801362:	eb 03                	jmp    801367 <strsplit+0x8f>
			string++;
  801364:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 8b                	je     8012fb <strsplit+0x23>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	50                   	push   %eax
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 b5 fa ff ff       	call   800e36 <strchr>
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	74 dc                	je     801364 <strsplit+0x8c>
			string++;
	}
  801388:	e9 6e ff ff ff       	jmp    8012fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138e:	8b 45 14             	mov    0x14(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	74 1f                	je     8013da <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013bb:	e8 1d 00 00 00       	call   8013dd <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	68 b0 3a 80 00       	push   $0x803ab0
  8013c8:	e8 55 f2 ff ff       	call   800622 <cprintf>
  8013cd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013d0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d7:	00 00 00 
	}
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8013e3:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013ea:	00 00 00 
  8013ed:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013f4:	00 00 00 
  8013f7:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013fe:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801401:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801408:	00 00 00 
  80140b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801412:	00 00 00 
  801415:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80141c:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80141f:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801429:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80142e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801433:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801438:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80143f:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801442:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144c:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801451:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801454:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801457:	ba 00 00 00 00       	mov    $0x0,%edx
  80145c:	f7 75 f0             	divl   -0x10(%ebp)
  80145f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801462:	29 d0                	sub    %edx,%eax
  801464:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801467:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80146e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801471:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801476:	2d 00 10 00 00       	sub    $0x1000,%eax
  80147b:	83 ec 04             	sub    $0x4,%esp
  80147e:	6a 06                	push   $0x6
  801480:	ff 75 e8             	pushl  -0x18(%ebp)
  801483:	50                   	push   %eax
  801484:	e8 d4 05 00 00       	call   801a5d <sys_allocate_chunk>
  801489:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80148c:	a1 20 41 80 00       	mov    0x804120,%eax
  801491:	83 ec 0c             	sub    $0xc,%esp
  801494:	50                   	push   %eax
  801495:	e8 49 0c 00 00       	call   8020e3 <initialize_MemBlocksList>
  80149a:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  80149d:	a1 48 41 80 00       	mov    0x804148,%eax
  8014a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8014a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014a9:	75 14                	jne    8014bf <initialize_dyn_block_system+0xe2>
  8014ab:	83 ec 04             	sub    $0x4,%esp
  8014ae:	68 d5 3a 80 00       	push   $0x803ad5
  8014b3:	6a 39                	push   $0x39
  8014b5:	68 f3 3a 80 00       	push   $0x803af3
  8014ba:	e8 d2 1b 00 00       	call   803091 <_panic>
  8014bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c2:	8b 00                	mov    (%eax),%eax
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	74 10                	je     8014d8 <initialize_dyn_block_system+0xfb>
  8014c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014d0:	8b 52 04             	mov    0x4(%edx),%edx
  8014d3:	89 50 04             	mov    %edx,0x4(%eax)
  8014d6:	eb 0b                	jmp    8014e3 <initialize_dyn_block_system+0x106>
  8014d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014db:	8b 40 04             	mov    0x4(%eax),%eax
  8014de:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e6:	8b 40 04             	mov    0x4(%eax),%eax
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	74 0f                	je     8014fc <initialize_dyn_block_system+0x11f>
  8014ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f0:	8b 40 04             	mov    0x4(%eax),%eax
  8014f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014f6:	8b 12                	mov    (%edx),%edx
  8014f8:	89 10                	mov    %edx,(%eax)
  8014fa:	eb 0a                	jmp    801506 <initialize_dyn_block_system+0x129>
  8014fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ff:	8b 00                	mov    (%eax),%eax
  801501:	a3 48 41 80 00       	mov    %eax,0x804148
  801506:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80150f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801512:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801519:	a1 54 41 80 00       	mov    0x804154,%eax
  80151e:	48                   	dec    %eax
  80151f:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801527:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80152e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801531:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801538:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80153c:	75 14                	jne    801552 <initialize_dyn_block_system+0x175>
  80153e:	83 ec 04             	sub    $0x4,%esp
  801541:	68 00 3b 80 00       	push   $0x803b00
  801546:	6a 3f                	push   $0x3f
  801548:	68 f3 3a 80 00       	push   $0x803af3
  80154d:	e8 3f 1b 00 00       	call   803091 <_panic>
  801552:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155b:	89 10                	mov    %edx,(%eax)
  80155d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801560:	8b 00                	mov    (%eax),%eax
  801562:	85 c0                	test   %eax,%eax
  801564:	74 0d                	je     801573 <initialize_dyn_block_system+0x196>
  801566:	a1 38 41 80 00       	mov    0x804138,%eax
  80156b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80156e:	89 50 04             	mov    %edx,0x4(%eax)
  801571:	eb 08                	jmp    80157b <initialize_dyn_block_system+0x19e>
  801573:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801576:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80157b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157e:	a3 38 41 80 00       	mov    %eax,0x804138
  801583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801586:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80158d:	a1 44 41 80 00       	mov    0x804144,%eax
  801592:	40                   	inc    %eax
  801593:	a3 44 41 80 00       	mov    %eax,0x804144

}
  801598:	90                   	nop
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a1:	e8 06 fe ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  8015a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015aa:	75 07                	jne    8015b3 <malloc+0x18>
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b1:	eb 7d                	jmp    801630 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8015b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8015ba:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	48                   	dec    %eax
  8015ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d5:	f7 75 f0             	divl   -0x10(%ebp)
  8015d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015db:	29 d0                	sub    %edx,%eax
  8015dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8015e0:	e8 46 08 00 00       	call   801e2b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015e5:	83 f8 01             	cmp    $0x1,%eax
  8015e8:	75 07                	jne    8015f1 <malloc+0x56>
  8015ea:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8015f1:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8015f5:	75 34                	jne    80162b <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8015f7:	83 ec 0c             	sub    $0xc,%esp
  8015fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8015fd:	e8 73 0e 00 00       	call   802475 <alloc_block_FF>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801608:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80160c:	74 16                	je     801624 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80160e:	83 ec 0c             	sub    $0xc,%esp
  801611:	ff 75 e4             	pushl  -0x1c(%ebp)
  801614:	e8 ff 0b 00 00       	call   802218 <insert_sorted_allocList>
  801619:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80161c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80161f:	8b 40 08             	mov    0x8(%eax),%eax
  801622:	eb 0c                	jmp    801630 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801624:	b8 00 00 00 00       	mov    $0x0,%eax
  801629:	eb 05                	jmp    801630 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801630:	c9                   	leave  
  801631:	c3                   	ret    

00801632 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801647:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80164c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80164f:	83 ec 08             	sub    $0x8,%esp
  801652:	ff 75 f4             	pushl  -0xc(%ebp)
  801655:	68 40 40 80 00       	push   $0x804040
  80165a:	e8 61 0b 00 00       	call   8021c0 <find_block>
  80165f:	83 c4 10             	add    $0x10,%esp
  801662:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801665:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801669:	0f 84 a5 00 00 00    	je     801714 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  80166f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801672:	8b 40 0c             	mov    0xc(%eax),%eax
  801675:	83 ec 08             	sub    $0x8,%esp
  801678:	50                   	push   %eax
  801679:	ff 75 f4             	pushl  -0xc(%ebp)
  80167c:	e8 a4 03 00 00       	call   801a25 <sys_free_user_mem>
  801681:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801684:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801688:	75 17                	jne    8016a1 <free+0x6f>
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	68 d5 3a 80 00       	push   $0x803ad5
  801692:	68 87 00 00 00       	push   $0x87
  801697:	68 f3 3a 80 00       	push   $0x803af3
  80169c:	e8 f0 19 00 00       	call   803091 <_panic>
  8016a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a4:	8b 00                	mov    (%eax),%eax
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	74 10                	je     8016ba <free+0x88>
  8016aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016b2:	8b 52 04             	mov    0x4(%edx),%edx
  8016b5:	89 50 04             	mov    %edx,0x4(%eax)
  8016b8:	eb 0b                	jmp    8016c5 <free+0x93>
  8016ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bd:	8b 40 04             	mov    0x4(%eax),%eax
  8016c0:	a3 44 40 80 00       	mov    %eax,0x804044
  8016c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c8:	8b 40 04             	mov    0x4(%eax),%eax
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	74 0f                	je     8016de <free+0xac>
  8016cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d2:	8b 40 04             	mov    0x4(%eax),%eax
  8016d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016d8:	8b 12                	mov    (%edx),%edx
  8016da:	89 10                	mov    %edx,(%eax)
  8016dc:	eb 0a                	jmp    8016e8 <free+0xb6>
  8016de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e1:	8b 00                	mov    (%eax),%eax
  8016e3:	a3 40 40 80 00       	mov    %eax,0x804040
  8016e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016fb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801700:	48                   	dec    %eax
  801701:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801706:	83 ec 0c             	sub    $0xc,%esp
  801709:	ff 75 ec             	pushl  -0x14(%ebp)
  80170c:	e8 37 12 00 00       	call   802948 <insert_sorted_with_merge_freeList>
  801711:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801714:	90                   	nop
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	83 ec 38             	sub    $0x38,%esp
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801723:	e8 84 fc ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  801728:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80172c:	75 07                	jne    801735 <smalloc+0x1e>
  80172e:	b8 00 00 00 00       	mov    $0x0,%eax
  801733:	eb 7e                	jmp    8017b3 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801735:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80173c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801743:	8b 55 0c             	mov    0xc(%ebp),%edx
  801746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	48                   	dec    %eax
  80174c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80174f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	f7 75 f0             	divl   -0x10(%ebp)
  80175a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175d:	29 d0                	sub    %edx,%eax
  80175f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801762:	e8 c4 06 00 00       	call   801e2b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801767:	83 f8 01             	cmp    $0x1,%eax
  80176a:	75 42                	jne    8017ae <smalloc+0x97>

		  va = malloc(newsize) ;
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	ff 75 e8             	pushl  -0x18(%ebp)
  801772:	e8 24 fe ff ff       	call   80159b <malloc>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  80177d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801781:	74 24                	je     8017a7 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801783:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801787:	ff 75 e4             	pushl  -0x1c(%ebp)
  80178a:	50                   	push   %eax
  80178b:	ff 75 e8             	pushl  -0x18(%ebp)
  80178e:	ff 75 08             	pushl  0x8(%ebp)
  801791:	e8 1a 04 00 00       	call   801bb0 <sys_createSharedObject>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  80179c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017a0:	78 0c                	js     8017ae <smalloc+0x97>
					  return va ;
  8017a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a5:	eb 0c                	jmp    8017b3 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8017a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ac:	eb 05                	jmp    8017b3 <smalloc+0x9c>
	  }
		  return NULL ;
  8017ae:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    

008017b5 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017b5:	55                   	push   %ebp
  8017b6:	89 e5                	mov    %esp,%ebp
  8017b8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017bb:	e8 ec fb ff ff       	call   8013ac <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8017c0:	83 ec 08             	sub    $0x8,%esp
  8017c3:	ff 75 0c             	pushl  0xc(%ebp)
  8017c6:	ff 75 08             	pushl  0x8(%ebp)
  8017c9:	e8 0c 04 00 00       	call   801bda <sys_getSizeOfSharedObject>
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8017d4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017d8:	75 07                	jne    8017e1 <sget+0x2c>
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
  8017df:	eb 75                	jmp    801856 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8017e1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ee:	01 d0                	add    %edx,%eax
  8017f0:	48                   	dec    %eax
  8017f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	f7 75 f0             	divl   -0x10(%ebp)
  8017ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801802:	29 d0                	sub    %edx,%eax
  801804:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801807:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80180e:	e8 18 06 00 00       	call   801e2b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801813:	83 f8 01             	cmp    $0x1,%eax
  801816:	75 39                	jne    801851 <sget+0x9c>

		  va = malloc(newsize) ;
  801818:	83 ec 0c             	sub    $0xc,%esp
  80181b:	ff 75 e8             	pushl  -0x18(%ebp)
  80181e:	e8 78 fd ff ff       	call   80159b <malloc>
  801823:	83 c4 10             	add    $0x10,%esp
  801826:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801829:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80182d:	74 22                	je     801851 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80182f:	83 ec 04             	sub    $0x4,%esp
  801832:	ff 75 e0             	pushl  -0x20(%ebp)
  801835:	ff 75 0c             	pushl  0xc(%ebp)
  801838:	ff 75 08             	pushl  0x8(%ebp)
  80183b:	e8 b7 03 00 00       	call   801bf7 <sys_getSharedObject>
  801840:	83 c4 10             	add    $0x10,%esp
  801843:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801846:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80184a:	78 05                	js     801851 <sget+0x9c>
					  return va;
  80184c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184f:	eb 05                	jmp    801856 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801851:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80185e:	e8 49 fb ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	68 24 3b 80 00       	push   $0x803b24
  80186b:	68 1e 01 00 00       	push   $0x11e
  801870:	68 f3 3a 80 00       	push   $0x803af3
  801875:	e8 17 18 00 00       	call   803091 <_panic>

0080187a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	68 4c 3b 80 00       	push   $0x803b4c
  801888:	68 32 01 00 00       	push   $0x132
  80188d:	68 f3 3a 80 00       	push   $0x803af3
  801892:	e8 fa 17 00 00       	call   803091 <_panic>

00801897 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189d:	83 ec 04             	sub    $0x4,%esp
  8018a0:	68 70 3b 80 00       	push   $0x803b70
  8018a5:	68 3d 01 00 00       	push   $0x13d
  8018aa:	68 f3 3a 80 00       	push   $0x803af3
  8018af:	e8 dd 17 00 00       	call   803091 <_panic>

008018b4 <shrink>:

}
void shrink(uint32 newSize)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	68 70 3b 80 00       	push   $0x803b70
  8018c2:	68 42 01 00 00       	push   $0x142
  8018c7:	68 f3 3a 80 00       	push   $0x803af3
  8018cc:	e8 c0 17 00 00       	call   803091 <_panic>

008018d1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	68 70 3b 80 00       	push   $0x803b70
  8018df:	68 47 01 00 00       	push   $0x147
  8018e4:	68 f3 3a 80 00       	push   $0x803af3
  8018e9:	e8 a3 17 00 00       	call   803091 <_panic>

008018ee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	57                   	push   %edi
  8018f2:	56                   	push   %esi
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801900:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801903:	8b 7d 18             	mov    0x18(%ebp),%edi
  801906:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801909:	cd 30                	int    $0x30
  80190b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80190e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	5b                   	pop    %ebx
  801915:	5e                   	pop    %esi
  801916:	5f                   	pop    %edi
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    

00801919 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801925:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	52                   	push   %edx
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	50                   	push   %eax
  801935:	6a 00                	push   $0x0
  801937:	e8 b2 ff ff ff       	call   8018ee <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	90                   	nop
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_cgetc>:

int
sys_cgetc(void)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 01                	push   $0x1
  801951:	e8 98 ff ff ff       	call   8018ee <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	52                   	push   %edx
  80196b:	50                   	push   %eax
  80196c:	6a 05                	push   $0x5
  80196e:	e8 7b ff ff ff       	call   8018ee <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	56                   	push   %esi
  80197c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80197d:	8b 75 18             	mov    0x18(%ebp),%esi
  801980:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801983:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801986:	8b 55 0c             	mov    0xc(%ebp),%edx
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	56                   	push   %esi
  80198d:	53                   	push   %ebx
  80198e:	51                   	push   %ecx
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	6a 06                	push   $0x6
  801993:	e8 56 ff ff ff       	call   8018ee <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    

008019a2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 07                	push   $0x7
  8019b5:	e8 34 ff ff ff       	call   8018ee <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	ff 75 08             	pushl  0x8(%ebp)
  8019ce:	6a 08                	push   $0x8
  8019d0:	e8 19 ff ff ff       	call   8018ee <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 09                	push   $0x9
  8019e9:	e8 00 ff ff ff       	call   8018ee <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 0a                	push   $0xa
  801a02:	e8 e7 fe ff ff       	call   8018ee <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 0b                	push   $0xb
  801a1b:	e8 ce fe ff ff       	call   8018ee <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	ff 75 08             	pushl  0x8(%ebp)
  801a34:	6a 0f                	push   $0xf
  801a36:	e8 b3 fe ff ff       	call   8018ee <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
	return;
  801a3e:	90                   	nop
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	6a 10                	push   $0x10
  801a52:	e8 97 fe ff ff       	call   8018ee <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5a:	90                   	nop
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	ff 75 10             	pushl  0x10(%ebp)
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	ff 75 08             	pushl  0x8(%ebp)
  801a6d:	6a 11                	push   $0x11
  801a6f:	e8 7a fe ff ff       	call   8018ee <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
	return ;
  801a77:	90                   	nop
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 0c                	push   $0xc
  801a89:	e8 60 fe ff ff       	call   8018ee <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	6a 0d                	push   $0xd
  801aa3:	e8 46 fe ff ff       	call   8018ee <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 0e                	push   $0xe
  801abc:	e8 2d fe ff ff       	call   8018ee <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 13                	push   $0x13
  801ad6:	e8 13 fe ff ff       	call   8018ee <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	90                   	nop
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 14                	push   $0x14
  801af0:	e8 f9 fd ff ff       	call   8018ee <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	90                   	nop
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_cputc>:


void
sys_cputc(const char c)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 04             	sub    $0x4,%esp
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b07:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	50                   	push   %eax
  801b14:	6a 15                	push   $0x15
  801b16:	e8 d3 fd ff ff       	call   8018ee <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	90                   	nop
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 16                	push   $0x16
  801b30:	e8 b9 fd ff ff       	call   8018ee <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	90                   	nop
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	50                   	push   %eax
  801b4b:	6a 17                	push   $0x17
  801b4d:	e8 9c fd ff ff       	call   8018ee <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	52                   	push   %edx
  801b67:	50                   	push   %eax
  801b68:	6a 1a                	push   $0x1a
  801b6a:	e8 7f fd ff ff       	call   8018ee <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	52                   	push   %edx
  801b84:	50                   	push   %eax
  801b85:	6a 18                	push   $0x18
  801b87:	e8 62 fd ff ff       	call   8018ee <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	90                   	nop
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 19                	push   $0x19
  801ba5:	e8 44 fd ff ff       	call   8018ee <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	90                   	nop
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 04             	sub    $0x4,%esp
  801bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bbc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bbf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	51                   	push   %ecx
  801bc9:	52                   	push   %edx
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	50                   	push   %eax
  801bce:	6a 1b                	push   $0x1b
  801bd0:	e8 19 fd ff ff       	call   8018ee <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	52                   	push   %edx
  801bea:	50                   	push   %eax
  801beb:	6a 1c                	push   $0x1c
  801bed:	e8 fc fc ff ff       	call   8018ee <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	51                   	push   %ecx
  801c08:	52                   	push   %edx
  801c09:	50                   	push   %eax
  801c0a:	6a 1d                	push   $0x1d
  801c0c:	e8 dd fc ff ff       	call   8018ee <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	52                   	push   %edx
  801c26:	50                   	push   %eax
  801c27:	6a 1e                	push   $0x1e
  801c29:	e8 c0 fc ff ff       	call   8018ee <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 1f                	push   $0x1f
  801c42:	e8 a7 fc ff ff       	call   8018ee <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	6a 00                	push   $0x0
  801c54:	ff 75 14             	pushl  0x14(%ebp)
  801c57:	ff 75 10             	pushl  0x10(%ebp)
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	50                   	push   %eax
  801c5e:	6a 20                	push   $0x20
  801c60:	e8 89 fc ff ff       	call   8018ee <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	50                   	push   %eax
  801c79:	6a 21                	push   $0x21
  801c7b:	e8 6e fc ff ff       	call   8018ee <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	90                   	nop
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	50                   	push   %eax
  801c95:	6a 22                	push   $0x22
  801c97:	e8 52 fc ff ff       	call   8018ee <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 02                	push   $0x2
  801cb0:	e8 39 fc ff ff       	call   8018ee <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 03                	push   $0x3
  801cc9:	e8 20 fc ff ff       	call   8018ee <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 04                	push   $0x4
  801ce2:	e8 07 fc ff ff       	call   8018ee <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_exit_env>:


void sys_exit_env(void)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 23                	push   $0x23
  801cfb:	e8 ee fb ff ff       	call   8018ee <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	90                   	nop
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d0c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d0f:	8d 50 04             	lea    0x4(%eax),%edx
  801d12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	52                   	push   %edx
  801d1c:	50                   	push   %eax
  801d1d:	6a 24                	push   $0x24
  801d1f:	e8 ca fb ff ff       	call   8018ee <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return result;
  801d27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d30:	89 01                	mov    %eax,(%ecx)
  801d32:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	c9                   	leave  
  801d39:	c2 04 00             	ret    $0x4

00801d3c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	ff 75 10             	pushl  0x10(%ebp)
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	ff 75 08             	pushl  0x8(%ebp)
  801d4c:	6a 12                	push   $0x12
  801d4e:	e8 9b fb ff ff       	call   8018ee <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 25                	push   $0x25
  801d68:	e8 81 fb ff ff       	call   8018ee <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d7e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	50                   	push   %eax
  801d8b:	6a 26                	push   $0x26
  801d8d:	e8 5c fb ff ff       	call   8018ee <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
	return ;
  801d95:	90                   	nop
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <rsttst>:
void rsttst()
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 28                	push   $0x28
  801da7:	e8 42 fb ff ff       	call   8018ee <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
	return ;
  801daf:	90                   	nop
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dbe:	8b 55 18             	mov    0x18(%ebp),%edx
  801dc1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dc5:	52                   	push   %edx
  801dc6:	50                   	push   %eax
  801dc7:	ff 75 10             	pushl  0x10(%ebp)
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 27                	push   $0x27
  801dd2:	e8 17 fb ff ff       	call   8018ee <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <chktst>:
void chktst(uint32 n)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	ff 75 08             	pushl  0x8(%ebp)
  801deb:	6a 29                	push   $0x29
  801ded:	e8 fc fa ff ff       	call   8018ee <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
	return ;
  801df5:	90                   	nop
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <inctst>:

void inctst()
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 2a                	push   $0x2a
  801e07:	e8 e2 fa ff ff       	call   8018ee <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0f:	90                   	nop
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <gettst>:
uint32 gettst()
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 2b                	push   $0x2b
  801e21:	e8 c8 fa ff ff       	call   8018ee <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 2c                	push   $0x2c
  801e3d:	e8 ac fa ff ff       	call   8018ee <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
  801e45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e48:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e4c:	75 07                	jne    801e55 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e53:	eb 05                	jmp    801e5a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 2c                	push   $0x2c
  801e6e:	e8 7b fa ff ff       	call   8018ee <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
  801e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e79:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e7d:	75 07                	jne    801e86 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e84:	eb 05                	jmp    801e8b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 2c                	push   $0x2c
  801e9f:	e8 4a fa ff ff       	call   8018ee <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
  801ea7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eaa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eae:	75 07                	jne    801eb7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eb0:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb5:	eb 05                	jmp    801ebc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 2c                	push   $0x2c
  801ed0:	e8 19 fa ff ff       	call   8018ee <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
  801ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801edb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801edf:	75 07                	jne    801ee8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ee1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee6:	eb 05                	jmp    801eed <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	ff 75 08             	pushl  0x8(%ebp)
  801efd:	6a 2d                	push   $0x2d
  801eff:	e8 ea f9 ff ff       	call   8018ee <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
	return ;
  801f07:	90                   	nop
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	6a 00                	push   $0x0
  801f1c:	53                   	push   %ebx
  801f1d:	51                   	push   %ecx
  801f1e:	52                   	push   %edx
  801f1f:	50                   	push   %eax
  801f20:	6a 2e                	push   $0x2e
  801f22:	e8 c7 f9 ff ff       	call   8018ee <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	52                   	push   %edx
  801f3f:	50                   	push   %eax
  801f40:	6a 2f                	push   $0x2f
  801f42:	e8 a7 f9 ff ff       	call   8018ee <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	68 80 3b 80 00       	push   $0x803b80
  801f5a:	e8 c3 e6 ff ff       	call   800622 <cprintf>
  801f5f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	68 ac 3b 80 00       	push   $0x803bac
  801f71:	e8 ac e6 ff ff       	call   800622 <cprintf>
  801f76:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f79:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f7d:	a1 38 41 80 00       	mov    0x804138,%eax
  801f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f85:	eb 56                	jmp    801fdd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8b:	74 1c                	je     801fa9 <print_mem_block_lists+0x5d>
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	8b 50 08             	mov    0x8(%eax),%edx
  801f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f96:	8b 48 08             	mov    0x8(%eax),%ecx
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9f:	01 c8                	add    %ecx,%eax
  801fa1:	39 c2                	cmp    %eax,%edx
  801fa3:	73 04                	jae    801fa9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fa5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 50 08             	mov    0x8(%eax),%edx
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb5:	01 c2                	add    %eax,%edx
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 40 08             	mov    0x8(%eax),%eax
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	52                   	push   %edx
  801fc1:	50                   	push   %eax
  801fc2:	68 c1 3b 80 00       	push   $0x803bc1
  801fc7:	e8 56 e6 ff ff       	call   800622 <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fd5:	a1 40 41 80 00       	mov    0x804140,%eax
  801fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe1:	74 07                	je     801fea <print_mem_block_lists+0x9e>
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	8b 00                	mov    (%eax),%eax
  801fe8:	eb 05                	jmp    801fef <print_mem_block_lists+0xa3>
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	a3 40 41 80 00       	mov    %eax,0x804140
  801ff4:	a1 40 41 80 00       	mov    0x804140,%eax
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 8a                	jne    801f87 <print_mem_block_lists+0x3b>
  801ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802001:	75 84                	jne    801f87 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802003:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802007:	75 10                	jne    802019 <print_mem_block_lists+0xcd>
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	68 d0 3b 80 00       	push   $0x803bd0
  802011:	e8 0c e6 ff ff       	call   800622 <cprintf>
  802016:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802019:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802020:	83 ec 0c             	sub    $0xc,%esp
  802023:	68 f4 3b 80 00       	push   $0x803bf4
  802028:	e8 f5 e5 ff ff       	call   800622 <cprintf>
  80202d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802030:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802034:	a1 40 40 80 00       	mov    0x804040,%eax
  802039:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203c:	eb 56                	jmp    802094 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80203e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802042:	74 1c                	je     802060 <print_mem_block_lists+0x114>
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 50 08             	mov    0x8(%eax),%edx
  80204a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204d:	8b 48 08             	mov    0x8(%eax),%ecx
  802050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802053:	8b 40 0c             	mov    0xc(%eax),%eax
  802056:	01 c8                	add    %ecx,%eax
  802058:	39 c2                	cmp    %eax,%edx
  80205a:	73 04                	jae    802060 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80205c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802063:	8b 50 08             	mov    0x8(%eax),%edx
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 40 0c             	mov    0xc(%eax),%eax
  80206c:	01 c2                	add    %eax,%edx
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	8b 40 08             	mov    0x8(%eax),%eax
  802074:	83 ec 04             	sub    $0x4,%esp
  802077:	52                   	push   %edx
  802078:	50                   	push   %eax
  802079:	68 c1 3b 80 00       	push   $0x803bc1
  80207e:	e8 9f e5 ff ff       	call   800622 <cprintf>
  802083:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80208c:	a1 48 40 80 00       	mov    0x804048,%eax
  802091:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802094:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802098:	74 07                	je     8020a1 <print_mem_block_lists+0x155>
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	8b 00                	mov    (%eax),%eax
  80209f:	eb 05                	jmp    8020a6 <print_mem_block_lists+0x15a>
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a6:	a3 48 40 80 00       	mov    %eax,0x804048
  8020ab:	a1 48 40 80 00       	mov    0x804048,%eax
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	75 8a                	jne    80203e <print_mem_block_lists+0xf2>
  8020b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b8:	75 84                	jne    80203e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020ba:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020be:	75 10                	jne    8020d0 <print_mem_block_lists+0x184>
  8020c0:	83 ec 0c             	sub    $0xc,%esp
  8020c3:	68 0c 3c 80 00       	push   $0x803c0c
  8020c8:	e8 55 e5 ff ff       	call   800622 <cprintf>
  8020cd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020d0:	83 ec 0c             	sub    $0xc,%esp
  8020d3:	68 80 3b 80 00       	push   $0x803b80
  8020d8:	e8 45 e5 ff ff       	call   800622 <cprintf>
  8020dd:	83 c4 10             	add    $0x10,%esp

}
  8020e0:	90                   	nop
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8020e9:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020f0:	00 00 00 
  8020f3:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020fa:	00 00 00 
  8020fd:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802104:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802107:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80210e:	e9 9e 00 00 00       	jmp    8021b1 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802113:	a1 50 40 80 00       	mov    0x804050,%eax
  802118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211b:	c1 e2 04             	shl    $0x4,%edx
  80211e:	01 d0                	add    %edx,%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	75 14                	jne    802138 <initialize_MemBlocksList+0x55>
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	68 34 3c 80 00       	push   $0x803c34
  80212c:	6a 47                	push   $0x47
  80212e:	68 57 3c 80 00       	push   $0x803c57
  802133:	e8 59 0f 00 00       	call   803091 <_panic>
  802138:	a1 50 40 80 00       	mov    0x804050,%eax
  80213d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802140:	c1 e2 04             	shl    $0x4,%edx
  802143:	01 d0                	add    %edx,%eax
  802145:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80214b:	89 10                	mov    %edx,(%eax)
  80214d:	8b 00                	mov    (%eax),%eax
  80214f:	85 c0                	test   %eax,%eax
  802151:	74 18                	je     80216b <initialize_MemBlocksList+0x88>
  802153:	a1 48 41 80 00       	mov    0x804148,%eax
  802158:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80215e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802161:	c1 e1 04             	shl    $0x4,%ecx
  802164:	01 ca                	add    %ecx,%edx
  802166:	89 50 04             	mov    %edx,0x4(%eax)
  802169:	eb 12                	jmp    80217d <initialize_MemBlocksList+0x9a>
  80216b:	a1 50 40 80 00       	mov    0x804050,%eax
  802170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802173:	c1 e2 04             	shl    $0x4,%edx
  802176:	01 d0                	add    %edx,%eax
  802178:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80217d:	a1 50 40 80 00       	mov    0x804050,%eax
  802182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802185:	c1 e2 04             	shl    $0x4,%edx
  802188:	01 d0                	add    %edx,%eax
  80218a:	a3 48 41 80 00       	mov    %eax,0x804148
  80218f:	a1 50 40 80 00       	mov    0x804050,%eax
  802194:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802197:	c1 e2 04             	shl    $0x4,%edx
  80219a:	01 d0                	add    %edx,%eax
  80219c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a3:	a1 54 41 80 00       	mov    0x804154,%eax
  8021a8:	40                   	inc    %eax
  8021a9:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8021ae:	ff 45 f4             	incl   -0xc(%ebp)
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b7:	0f 82 56 ff ff ff    	jb     802113 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8021bd:	90                   	nop
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ce:	eb 19                	jmp    8021e9 <find_block+0x29>
	{
		if(element->sva == va){
  8021d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d3:	8b 40 08             	mov    0x8(%eax),%eax
  8021d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021d9:	75 05                	jne    8021e0 <find_block+0x20>
			 		return element;
  8021db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021de:	eb 36                	jmp    802216 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	8b 40 08             	mov    0x8(%eax),%eax
  8021e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ed:	74 07                	je     8021f6 <find_block+0x36>
  8021ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f2:	8b 00                	mov    (%eax),%eax
  8021f4:	eb 05                	jmp    8021fb <find_block+0x3b>
  8021f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fe:	89 42 08             	mov    %eax,0x8(%edx)
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	8b 40 08             	mov    0x8(%eax),%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	75 c5                	jne    8021d0 <find_block+0x10>
  80220b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80220f:	75 bf                	jne    8021d0 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802211:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80221e:	a1 44 40 80 00       	mov    0x804044,%eax
  802223:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802226:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80222b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80222e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802232:	74 0a                	je     80223e <insert_sorted_allocList+0x26>
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 40 08             	mov    0x8(%eax),%eax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	75 65                	jne    8022a3 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80223e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802242:	75 14                	jne    802258 <insert_sorted_allocList+0x40>
  802244:	83 ec 04             	sub    $0x4,%esp
  802247:	68 34 3c 80 00       	push   $0x803c34
  80224c:	6a 6e                	push   $0x6e
  80224e:	68 57 3c 80 00       	push   $0x803c57
  802253:	e8 39 0e 00 00       	call   803091 <_panic>
  802258:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	89 10                	mov    %edx,(%eax)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	8b 00                	mov    (%eax),%eax
  802268:	85 c0                	test   %eax,%eax
  80226a:	74 0d                	je     802279 <insert_sorted_allocList+0x61>
  80226c:	a1 40 40 80 00       	mov    0x804040,%eax
  802271:	8b 55 08             	mov    0x8(%ebp),%edx
  802274:	89 50 04             	mov    %edx,0x4(%eax)
  802277:	eb 08                	jmp    802281 <insert_sorted_allocList+0x69>
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	a3 44 40 80 00       	mov    %eax,0x804044
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	a3 40 40 80 00       	mov    %eax,0x804040
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802293:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802298:	40                   	inc    %eax
  802299:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80229e:	e9 cf 01 00 00       	jmp    802472 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8022a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a6:	8b 50 08             	mov    0x8(%eax),%edx
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	8b 40 08             	mov    0x8(%eax),%eax
  8022af:	39 c2                	cmp    %eax,%edx
  8022b1:	73 65                	jae    802318 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b7:	75 14                	jne    8022cd <insert_sorted_allocList+0xb5>
  8022b9:	83 ec 04             	sub    $0x4,%esp
  8022bc:	68 70 3c 80 00       	push   $0x803c70
  8022c1:	6a 72                	push   $0x72
  8022c3:	68 57 3c 80 00       	push   $0x803c57
  8022c8:	e8 c4 0d 00 00       	call   803091 <_panic>
  8022cd:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	89 50 04             	mov    %edx,0x4(%eax)
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	8b 40 04             	mov    0x4(%eax),%eax
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	74 0c                	je     8022ef <insert_sorted_allocList+0xd7>
  8022e3:	a1 44 40 80 00       	mov    0x804044,%eax
  8022e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022eb:	89 10                	mov    %edx,(%eax)
  8022ed:	eb 08                	jmp    8022f7 <insert_sorted_allocList+0xdf>
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	a3 44 40 80 00       	mov    %eax,0x804044
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802308:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80230d:	40                   	inc    %eax
  80230e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802313:	e9 5a 01 00 00       	jmp    802472 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231b:	8b 50 08             	mov    0x8(%eax),%edx
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8b 40 08             	mov    0x8(%eax),%eax
  802324:	39 c2                	cmp    %eax,%edx
  802326:	75 70                	jne    802398 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802328:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80232c:	74 06                	je     802334 <insert_sorted_allocList+0x11c>
  80232e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802332:	75 14                	jne    802348 <insert_sorted_allocList+0x130>
  802334:	83 ec 04             	sub    $0x4,%esp
  802337:	68 94 3c 80 00       	push   $0x803c94
  80233c:	6a 75                	push   $0x75
  80233e:	68 57 3c 80 00       	push   $0x803c57
  802343:	e8 49 0d 00 00       	call   803091 <_panic>
  802348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234b:	8b 10                	mov    (%eax),%edx
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	89 10                	mov    %edx,(%eax)
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	8b 00                	mov    (%eax),%eax
  802357:	85 c0                	test   %eax,%eax
  802359:	74 0b                	je     802366 <insert_sorted_allocList+0x14e>
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	8b 00                	mov    (%eax),%eax
  802360:	8b 55 08             	mov    0x8(%ebp),%edx
  802363:	89 50 04             	mov    %edx,0x4(%eax)
  802366:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802369:	8b 55 08             	mov    0x8(%ebp),%edx
  80236c:	89 10                	mov    %edx,(%eax)
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802374:	89 50 04             	mov    %edx,0x4(%eax)
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	75 08                	jne    802388 <insert_sorted_allocList+0x170>
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	a3 44 40 80 00       	mov    %eax,0x804044
  802388:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80238d:	40                   	inc    %eax
  80238e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802393:	e9 da 00 00 00       	jmp    802472 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802398:	a1 40 40 80 00       	mov    0x804040,%eax
  80239d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a0:	e9 9d 00 00 00       	jmp    802442 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 00                	mov    (%eax),%eax
  8023aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	8b 50 08             	mov    0x8(%eax),%edx
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	8b 40 08             	mov    0x8(%eax),%eax
  8023b9:	39 c2                	cmp    %eax,%edx
  8023bb:	76 7d                	jbe    80243a <insert_sorted_allocList+0x222>
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	8b 50 08             	mov    0x8(%eax),%edx
  8023c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c6:	8b 40 08             	mov    0x8(%eax),%eax
  8023c9:	39 c2                	cmp    %eax,%edx
  8023cb:	73 6d                	jae    80243a <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8023cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d1:	74 06                	je     8023d9 <insert_sorted_allocList+0x1c1>
  8023d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d7:	75 14                	jne    8023ed <insert_sorted_allocList+0x1d5>
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	68 94 3c 80 00       	push   $0x803c94
  8023e1:	6a 7c                	push   $0x7c
  8023e3:	68 57 3c 80 00       	push   $0x803c57
  8023e8:	e8 a4 0c 00 00       	call   803091 <_panic>
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 10                	mov    (%eax),%edx
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	89 10                	mov    %edx,(%eax)
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	85 c0                	test   %eax,%eax
  8023fe:	74 0b                	je     80240b <insert_sorted_allocList+0x1f3>
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	8b 00                	mov    (%eax),%eax
  802405:	8b 55 08             	mov    0x8(%ebp),%edx
  802408:	89 50 04             	mov    %edx,0x4(%eax)
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 55 08             	mov    0x8(%ebp),%edx
  802411:	89 10                	mov    %edx,(%eax)
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802419:	89 50 04             	mov    %edx,0x4(%eax)
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	75 08                	jne    80242d <insert_sorted_allocList+0x215>
  802425:	8b 45 08             	mov    0x8(%ebp),%eax
  802428:	a3 44 40 80 00       	mov    %eax,0x804044
  80242d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802432:	40                   	inc    %eax
  802433:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802438:	eb 38                	jmp    802472 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80243a:	a1 48 40 80 00       	mov    0x804048,%eax
  80243f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802446:	74 07                	je     80244f <insert_sorted_allocList+0x237>
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 00                	mov    (%eax),%eax
  80244d:	eb 05                	jmp    802454 <insert_sorted_allocList+0x23c>
  80244f:	b8 00 00 00 00       	mov    $0x0,%eax
  802454:	a3 48 40 80 00       	mov    %eax,0x804048
  802459:	a1 48 40 80 00       	mov    0x804048,%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	0f 85 3f ff ff ff    	jne    8023a5 <insert_sorted_allocList+0x18d>
  802466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246a:	0f 85 35 ff ff ff    	jne    8023a5 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802470:	eb 00                	jmp    802472 <insert_sorted_allocList+0x25a>
  802472:	90                   	nop
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80247b:	a1 38 41 80 00       	mov    0x804138,%eax
  802480:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802483:	e9 6b 02 00 00       	jmp    8026f3 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 0c             	mov    0xc(%eax),%eax
  80248e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802491:	0f 85 90 00 00 00    	jne    802527 <alloc_block_FF+0xb2>
			  temp=element;
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  80249d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a1:	75 17                	jne    8024ba <alloc_block_FF+0x45>
  8024a3:	83 ec 04             	sub    $0x4,%esp
  8024a6:	68 c8 3c 80 00       	push   $0x803cc8
  8024ab:	68 92 00 00 00       	push   $0x92
  8024b0:	68 57 3c 80 00       	push   $0x803c57
  8024b5:	e8 d7 0b 00 00       	call   803091 <_panic>
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	85 c0                	test   %eax,%eax
  8024c1:	74 10                	je     8024d3 <alloc_block_FF+0x5e>
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cb:	8b 52 04             	mov    0x4(%edx),%edx
  8024ce:	89 50 04             	mov    %edx,0x4(%eax)
  8024d1:	eb 0b                	jmp    8024de <alloc_block_FF+0x69>
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 40 04             	mov    0x4(%eax),%eax
  8024d9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 04             	mov    0x4(%eax),%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	74 0f                	je     8024f7 <alloc_block_FF+0x82>
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f1:	8b 12                	mov    (%edx),%edx
  8024f3:	89 10                	mov    %edx,(%eax)
  8024f5:	eb 0a                	jmp    802501 <alloc_block_FF+0x8c>
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 00                	mov    (%eax),%eax
  8024fc:	a3 38 41 80 00       	mov    %eax,0x804138
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802514:	a1 44 41 80 00       	mov    0x804144,%eax
  802519:	48                   	dec    %eax
  80251a:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80251f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802522:	e9 ff 01 00 00       	jmp    802726 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	8b 40 0c             	mov    0xc(%eax),%eax
  80252d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802530:	0f 86 b5 01 00 00    	jbe    8026eb <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 40 0c             	mov    0xc(%eax),%eax
  80253c:	2b 45 08             	sub    0x8(%ebp),%eax
  80253f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802542:	a1 48 41 80 00       	mov    0x804148,%eax
  802547:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80254a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80254e:	75 17                	jne    802567 <alloc_block_FF+0xf2>
  802550:	83 ec 04             	sub    $0x4,%esp
  802553:	68 c8 3c 80 00       	push   $0x803cc8
  802558:	68 99 00 00 00       	push   $0x99
  80255d:	68 57 3c 80 00       	push   $0x803c57
  802562:	e8 2a 0b 00 00       	call   803091 <_panic>
  802567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256a:	8b 00                	mov    (%eax),%eax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	74 10                	je     802580 <alloc_block_FF+0x10b>
  802570:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802573:	8b 00                	mov    (%eax),%eax
  802575:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802578:	8b 52 04             	mov    0x4(%edx),%edx
  80257b:	89 50 04             	mov    %edx,0x4(%eax)
  80257e:	eb 0b                	jmp    80258b <alloc_block_FF+0x116>
  802580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802583:	8b 40 04             	mov    0x4(%eax),%eax
  802586:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80258b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258e:	8b 40 04             	mov    0x4(%eax),%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	74 0f                	je     8025a4 <alloc_block_FF+0x12f>
  802595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259e:	8b 12                	mov    (%edx),%edx
  8025a0:	89 10                	mov    %edx,(%eax)
  8025a2:	eb 0a                	jmp    8025ae <alloc_block_FF+0x139>
  8025a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	a3 48 41 80 00       	mov    %eax,0x804148
  8025ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c1:	a1 54 41 80 00       	mov    0x804154,%eax
  8025c6:	48                   	dec    %eax
  8025c7:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8025cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025d0:	75 17                	jne    8025e9 <alloc_block_FF+0x174>
  8025d2:	83 ec 04             	sub    $0x4,%esp
  8025d5:	68 70 3c 80 00       	push   $0x803c70
  8025da:	68 9a 00 00 00       	push   $0x9a
  8025df:	68 57 3c 80 00       	push   $0x803c57
  8025e4:	e8 a8 0a 00 00       	call   803091 <_panic>
  8025e9:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8025ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f2:	89 50 04             	mov    %edx,0x4(%eax)
  8025f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f8:	8b 40 04             	mov    0x4(%eax),%eax
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	74 0c                	je     80260b <alloc_block_FF+0x196>
  8025ff:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802604:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802607:	89 10                	mov    %edx,(%eax)
  802609:	eb 08                	jmp    802613 <alloc_block_FF+0x19e>
  80260b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260e:	a3 38 41 80 00       	mov    %eax,0x804138
  802613:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802616:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80261b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802624:	a1 44 41 80 00       	mov    0x804144,%eax
  802629:	40                   	inc    %eax
  80262a:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  80262f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802632:	8b 55 08             	mov    0x8(%ebp),%edx
  802635:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 50 08             	mov    0x8(%eax),%edx
  80263e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802641:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80264a:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 50 08             	mov    0x8(%eax),%edx
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	01 c2                	add    %eax,%edx
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  80265e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802661:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802664:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802668:	75 17                	jne    802681 <alloc_block_FF+0x20c>
  80266a:	83 ec 04             	sub    $0x4,%esp
  80266d:	68 c8 3c 80 00       	push   $0x803cc8
  802672:	68 a2 00 00 00       	push   $0xa2
  802677:	68 57 3c 80 00       	push   $0x803c57
  80267c:	e8 10 0a 00 00       	call   803091 <_panic>
  802681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	85 c0                	test   %eax,%eax
  802688:	74 10                	je     80269a <alloc_block_FF+0x225>
  80268a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802692:	8b 52 04             	mov    0x4(%edx),%edx
  802695:	89 50 04             	mov    %edx,0x4(%eax)
  802698:	eb 0b                	jmp    8026a5 <alloc_block_FF+0x230>
  80269a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269d:	8b 40 04             	mov    0x4(%eax),%eax
  8026a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	74 0f                	je     8026be <alloc_block_FF+0x249>
  8026af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b8:	8b 12                	mov    (%edx),%edx
  8026ba:	89 10                	mov    %edx,(%eax)
  8026bc:	eb 0a                	jmp    8026c8 <alloc_block_FF+0x253>
  8026be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8026c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026db:	a1 44 41 80 00       	mov    0x804144,%eax
  8026e0:	48                   	dec    %eax
  8026e1:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  8026e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e9:	eb 3b                	jmp    802726 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8026eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8026f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f7:	74 07                	je     802700 <alloc_block_FF+0x28b>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	eb 05                	jmp    802705 <alloc_block_FF+0x290>
  802700:	b8 00 00 00 00       	mov    $0x0,%eax
  802705:	a3 40 41 80 00       	mov    %eax,0x804140
  80270a:	a1 40 41 80 00       	mov    0x804140,%eax
  80270f:	85 c0                	test   %eax,%eax
  802711:	0f 85 71 fd ff ff    	jne    802488 <alloc_block_FF+0x13>
  802717:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271b:	0f 85 67 fd ff ff    	jne    802488 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80272e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802735:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80273c:	a1 38 41 80 00       	mov    0x804138,%eax
  802741:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802744:	e9 d3 00 00 00       	jmp    80281c <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802749:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274c:	8b 40 0c             	mov    0xc(%eax),%eax
  80274f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802752:	0f 85 90 00 00 00    	jne    8027e8 <alloc_block_BF+0xc0>
	   temp = element;
  802758:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80275e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802762:	75 17                	jne    80277b <alloc_block_BF+0x53>
  802764:	83 ec 04             	sub    $0x4,%esp
  802767:	68 c8 3c 80 00       	push   $0x803cc8
  80276c:	68 bd 00 00 00       	push   $0xbd
  802771:	68 57 3c 80 00       	push   $0x803c57
  802776:	e8 16 09 00 00       	call   803091 <_panic>
  80277b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277e:	8b 00                	mov    (%eax),%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	74 10                	je     802794 <alloc_block_BF+0x6c>
  802784:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802787:	8b 00                	mov    (%eax),%eax
  802789:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80278c:	8b 52 04             	mov    0x4(%edx),%edx
  80278f:	89 50 04             	mov    %edx,0x4(%eax)
  802792:	eb 0b                	jmp    80279f <alloc_block_BF+0x77>
  802794:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802797:	8b 40 04             	mov    0x4(%eax),%eax
  80279a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80279f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a2:	8b 40 04             	mov    0x4(%eax),%eax
  8027a5:	85 c0                	test   %eax,%eax
  8027a7:	74 0f                	je     8027b8 <alloc_block_BF+0x90>
  8027a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ac:	8b 40 04             	mov    0x4(%eax),%eax
  8027af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027b2:	8b 12                	mov    (%edx),%edx
  8027b4:	89 10                	mov    %edx,(%eax)
  8027b6:	eb 0a                	jmp    8027c2 <alloc_block_BF+0x9a>
  8027b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	a3 38 41 80 00       	mov    %eax,0x804138
  8027c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8027da:	48                   	dec    %eax
  8027db:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8027e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027e3:	e9 41 01 00 00       	jmp    802929 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8027e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f1:	76 21                	jbe    802814 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8027f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027fc:	73 16                	jae    802814 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8027fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802801:	8b 40 0c             	mov    0xc(%eax),%eax
  802804:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802807:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80280d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802814:	a1 40 41 80 00       	mov    0x804140,%eax
  802819:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80281c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802820:	74 07                	je     802829 <alloc_block_BF+0x101>
  802822:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802825:	8b 00                	mov    (%eax),%eax
  802827:	eb 05                	jmp    80282e <alloc_block_BF+0x106>
  802829:	b8 00 00 00 00       	mov    $0x0,%eax
  80282e:	a3 40 41 80 00       	mov    %eax,0x804140
  802833:	a1 40 41 80 00       	mov    0x804140,%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	0f 85 09 ff ff ff    	jne    802749 <alloc_block_BF+0x21>
  802840:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802844:	0f 85 ff fe ff ff    	jne    802749 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  80284a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80284e:	0f 85 d0 00 00 00    	jne    802924 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802854:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802857:	8b 40 0c             	mov    0xc(%eax),%eax
  80285a:	2b 45 08             	sub    0x8(%ebp),%eax
  80285d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802860:	a1 48 41 80 00       	mov    0x804148,%eax
  802865:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802868:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80286c:	75 17                	jne    802885 <alloc_block_BF+0x15d>
  80286e:	83 ec 04             	sub    $0x4,%esp
  802871:	68 c8 3c 80 00       	push   $0x803cc8
  802876:	68 d1 00 00 00       	push   $0xd1
  80287b:	68 57 3c 80 00       	push   $0x803c57
  802880:	e8 0c 08 00 00       	call   803091 <_panic>
  802885:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	74 10                	je     80289e <alloc_block_BF+0x176>
  80288e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802896:	8b 52 04             	mov    0x4(%edx),%edx
  802899:	89 50 04             	mov    %edx,0x4(%eax)
  80289c:	eb 0b                	jmp    8028a9 <alloc_block_BF+0x181>
  80289e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a1:	8b 40 04             	mov    0x4(%eax),%eax
  8028a4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ac:	8b 40 04             	mov    0x4(%eax),%eax
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	74 0f                	je     8028c2 <alloc_block_BF+0x19a>
  8028b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b6:	8b 40 04             	mov    0x4(%eax),%eax
  8028b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028bc:	8b 12                	mov    (%edx),%edx
  8028be:	89 10                	mov    %edx,(%eax)
  8028c0:	eb 0a                	jmp    8028cc <alloc_block_BF+0x1a4>
  8028c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	a3 48 41 80 00       	mov    %eax,0x804148
  8028cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028df:	a1 54 41 80 00       	mov    0x804154,%eax
  8028e4:	48                   	dec    %eax
  8028e5:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8028ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f0:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	8b 50 08             	mov    0x8(%eax),%edx
  8028f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028fc:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8028ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802902:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802905:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	8b 50 08             	mov    0x8(%eax),%edx
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	01 c2                	add    %eax,%edx
  802913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802916:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802919:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80291f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802922:	eb 05                	jmp    802929 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802924:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802929:	c9                   	leave  
  80292a:	c3                   	ret    

0080292b <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
  80292e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802931:	83 ec 04             	sub    $0x4,%esp
  802934:	68 e8 3c 80 00       	push   $0x803ce8
  802939:	68 e8 00 00 00       	push   $0xe8
  80293e:	68 57 3c 80 00       	push   $0x803c57
  802943:	e8 49 07 00 00       	call   803091 <_panic>

00802948 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802948:	55                   	push   %ebp
  802949:	89 e5                	mov    %esp,%ebp
  80294b:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  80294e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802953:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802956:	a1 38 41 80 00       	mov    0x804138,%eax
  80295b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  80295e:	a1 44 41 80 00       	mov    0x804144,%eax
  802963:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802966:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80296a:	75 68                	jne    8029d4 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80296c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802970:	75 17                	jne    802989 <insert_sorted_with_merge_freeList+0x41>
  802972:	83 ec 04             	sub    $0x4,%esp
  802975:	68 34 3c 80 00       	push   $0x803c34
  80297a:	68 36 01 00 00       	push   $0x136
  80297f:	68 57 3c 80 00       	push   $0x803c57
  802984:	e8 08 07 00 00       	call   803091 <_panic>
  802989:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	89 10                	mov    %edx,(%eax)
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	74 0d                	je     8029aa <insert_sorted_with_merge_freeList+0x62>
  80299d:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a5:	89 50 04             	mov    %edx,0x4(%eax)
  8029a8:	eb 08                	jmp    8029b2 <insert_sorted_with_merge_freeList+0x6a>
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c4:	a1 44 41 80 00       	mov    0x804144,%eax
  8029c9:	40                   	inc    %eax
  8029ca:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8029cf:	e9 ba 06 00 00       	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	8b 50 08             	mov    0x8(%eax),%edx
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e0:	01 c2                	add    %eax,%edx
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	8b 40 08             	mov    0x8(%eax),%eax
  8029e8:	39 c2                	cmp    %eax,%edx
  8029ea:	73 68                	jae    802a54 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8029ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f0:	75 17                	jne    802a09 <insert_sorted_with_merge_freeList+0xc1>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 70 3c 80 00       	push   $0x803c70
  8029fa:	68 3a 01 00 00       	push   $0x13a
  8029ff:	68 57 3c 80 00       	push   $0x803c57
  802a04:	e8 88 06 00 00       	call   803091 <_panic>
  802a09:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	89 50 04             	mov    %edx,0x4(%eax)
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 0c                	je     802a2b <insert_sorted_with_merge_freeList+0xe3>
  802a1f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a24:	8b 55 08             	mov    0x8(%ebp),%edx
  802a27:	89 10                	mov    %edx,(%eax)
  802a29:	eb 08                	jmp    802a33 <insert_sorted_with_merge_freeList+0xeb>
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a44:	a1 44 41 80 00       	mov    0x804144,%eax
  802a49:	40                   	inc    %eax
  802a4a:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a4f:	e9 3a 06 00 00       	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a57:	8b 50 08             	mov    0x8(%eax),%edx
  802a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a60:	01 c2                	add    %eax,%edx
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	8b 40 08             	mov    0x8(%eax),%eax
  802a68:	39 c2                	cmp    %eax,%edx
  802a6a:	0f 85 90 00 00 00    	jne    802b00 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	8b 50 0c             	mov    0xc(%eax),%edx
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7c:	01 c2                	add    %eax,%edx
  802a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a81:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802a98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9c:	75 17                	jne    802ab5 <insert_sorted_with_merge_freeList+0x16d>
  802a9e:	83 ec 04             	sub    $0x4,%esp
  802aa1:	68 34 3c 80 00       	push   $0x803c34
  802aa6:	68 41 01 00 00       	push   $0x141
  802aab:	68 57 3c 80 00       	push   $0x803c57
  802ab0:	e8 dc 05 00 00       	call   803091 <_panic>
  802ab5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	89 10                	mov    %edx,(%eax)
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 0d                	je     802ad6 <insert_sorted_with_merge_freeList+0x18e>
  802ac9:	a1 48 41 80 00       	mov    0x804148,%eax
  802ace:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad1:	89 50 04             	mov    %edx,0x4(%eax)
  802ad4:	eb 08                	jmp    802ade <insert_sorted_with_merge_freeList+0x196>
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	a3 48 41 80 00       	mov    %eax,0x804148
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af0:	a1 54 41 80 00       	mov    0x804154,%eax
  802af5:	40                   	inc    %eax
  802af6:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802afb:	e9 8e 05 00 00       	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	8b 50 08             	mov    0x8(%eax),%edx
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0c:	01 c2                	add    %eax,%edx
  802b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b11:	8b 40 08             	mov    0x8(%eax),%eax
  802b14:	39 c2                	cmp    %eax,%edx
  802b16:	73 68                	jae    802b80 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1c:	75 17                	jne    802b35 <insert_sorted_with_merge_freeList+0x1ed>
  802b1e:	83 ec 04             	sub    $0x4,%esp
  802b21:	68 34 3c 80 00       	push   $0x803c34
  802b26:	68 45 01 00 00       	push   $0x145
  802b2b:	68 57 3c 80 00       	push   $0x803c57
  802b30:	e8 5c 05 00 00       	call   803091 <_panic>
  802b35:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	89 10                	mov    %edx,(%eax)
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	85 c0                	test   %eax,%eax
  802b47:	74 0d                	je     802b56 <insert_sorted_with_merge_freeList+0x20e>
  802b49:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b51:	89 50 04             	mov    %edx,0x4(%eax)
  802b54:	eb 08                	jmp    802b5e <insert_sorted_with_merge_freeList+0x216>
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	a3 38 41 80 00       	mov    %eax,0x804138
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b70:	a1 44 41 80 00       	mov    0x804144,%eax
  802b75:	40                   	inc    %eax
  802b76:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b7b:	e9 0e 05 00 00       	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	8b 50 08             	mov    0x8(%eax),%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8c:	01 c2                	add    %eax,%edx
  802b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b91:	8b 40 08             	mov    0x8(%eax),%eax
  802b94:	39 c2                	cmp    %eax,%edx
  802b96:	0f 85 9c 00 00 00    	jne    802c38 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba8:	01 c2                	add    %eax,%edx
  802baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bad:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8b 50 08             	mov    0x8(%eax),%edx
  802bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb9:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd4:	75 17                	jne    802bed <insert_sorted_with_merge_freeList+0x2a5>
  802bd6:	83 ec 04             	sub    $0x4,%esp
  802bd9:	68 34 3c 80 00       	push   $0x803c34
  802bde:	68 4d 01 00 00       	push   $0x14d
  802be3:	68 57 3c 80 00       	push   $0x803c57
  802be8:	e8 a4 04 00 00       	call   803091 <_panic>
  802bed:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	89 10                	mov    %edx,(%eax)
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	74 0d                	je     802c0e <insert_sorted_with_merge_freeList+0x2c6>
  802c01:	a1 48 41 80 00       	mov    0x804148,%eax
  802c06:	8b 55 08             	mov    0x8(%ebp),%edx
  802c09:	89 50 04             	mov    %edx,0x4(%eax)
  802c0c:	eb 08                	jmp    802c16 <insert_sorted_with_merge_freeList+0x2ce>
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	a3 48 41 80 00       	mov    %eax,0x804148
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c28:	a1 54 41 80 00       	mov    0x804154,%eax
  802c2d:	40                   	inc    %eax
  802c2e:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c33:	e9 56 04 00 00       	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802c38:	a1 38 41 80 00       	mov    0x804138,%eax
  802c3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c40:	e9 19 04 00 00       	jmp    80305e <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 00                	mov    (%eax),%eax
  802c4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 50 08             	mov    0x8(%eax),%edx
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 0c             	mov    0xc(%eax),%eax
  802c59:	01 c2                	add    %eax,%edx
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	8b 40 08             	mov    0x8(%eax),%eax
  802c61:	39 c2                	cmp    %eax,%edx
  802c63:	0f 85 ad 01 00 00    	jne    802e16 <insert_sorted_with_merge_freeList+0x4ce>
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	8b 50 08             	mov    0x8(%eax),%edx
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 40 0c             	mov    0xc(%eax),%eax
  802c75:	01 c2                	add    %eax,%edx
  802c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7a:	8b 40 08             	mov    0x8(%eax),%eax
  802c7d:	39 c2                	cmp    %eax,%edx
  802c7f:	0f 85 91 01 00 00    	jne    802e16 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 50 0c             	mov    0xc(%eax),%edx
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c94:	8b 40 0c             	mov    0xc(%eax),%eax
  802c97:	01 c8                	add    %ecx,%eax
  802c99:	01 c2                	add    %eax,%edx
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802cb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802cbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802cc9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ccd:	75 17                	jne    802ce6 <insert_sorted_with_merge_freeList+0x39e>
  802ccf:	83 ec 04             	sub    $0x4,%esp
  802cd2:	68 c8 3c 80 00       	push   $0x803cc8
  802cd7:	68 5b 01 00 00       	push   $0x15b
  802cdc:	68 57 3c 80 00       	push   $0x803c57
  802ce1:	e8 ab 03 00 00       	call   803091 <_panic>
  802ce6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	85 c0                	test   %eax,%eax
  802ced:	74 10                	je     802cff <insert_sorted_with_merge_freeList+0x3b7>
  802cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cf7:	8b 52 04             	mov    0x4(%edx),%edx
  802cfa:	89 50 04             	mov    %edx,0x4(%eax)
  802cfd:	eb 0b                	jmp    802d0a <insert_sorted_with_merge_freeList+0x3c2>
  802cff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d02:	8b 40 04             	mov    0x4(%eax),%eax
  802d05:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0d:	8b 40 04             	mov    0x4(%eax),%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 0f                	je     802d23 <insert_sorted_with_merge_freeList+0x3db>
  802d14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d17:	8b 40 04             	mov    0x4(%eax),%eax
  802d1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d1d:	8b 12                	mov    (%edx),%edx
  802d1f:	89 10                	mov    %edx,(%eax)
  802d21:	eb 0a                	jmp    802d2d <insert_sorted_with_merge_freeList+0x3e5>
  802d23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	a3 38 41 80 00       	mov    %eax,0x804138
  802d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d40:	a1 44 41 80 00       	mov    0x804144,%eax
  802d45:	48                   	dec    %eax
  802d46:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4f:	75 17                	jne    802d68 <insert_sorted_with_merge_freeList+0x420>
  802d51:	83 ec 04             	sub    $0x4,%esp
  802d54:	68 34 3c 80 00       	push   $0x803c34
  802d59:	68 5c 01 00 00       	push   $0x15c
  802d5e:	68 57 3c 80 00       	push   $0x803c57
  802d63:	e8 29 03 00 00       	call   803091 <_panic>
  802d68:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	89 10                	mov    %edx,(%eax)
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	8b 00                	mov    (%eax),%eax
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	74 0d                	je     802d89 <insert_sorted_with_merge_freeList+0x441>
  802d7c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d81:	8b 55 08             	mov    0x8(%ebp),%edx
  802d84:	89 50 04             	mov    %edx,0x4(%eax)
  802d87:	eb 08                	jmp    802d91 <insert_sorted_with_merge_freeList+0x449>
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	a3 48 41 80 00       	mov    %eax,0x804148
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da3:	a1 54 41 80 00       	mov    0x804154,%eax
  802da8:	40                   	inc    %eax
  802da9:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802dae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802db2:	75 17                	jne    802dcb <insert_sorted_with_merge_freeList+0x483>
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	68 34 3c 80 00       	push   $0x803c34
  802dbc:	68 5d 01 00 00       	push   $0x15d
  802dc1:	68 57 3c 80 00       	push   $0x803c57
  802dc6:	e8 c6 02 00 00       	call   803091 <_panic>
  802dcb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 0d                	je     802dec <insert_sorted_with_merge_freeList+0x4a4>
  802ddf:	a1 48 41 80 00       	mov    0x804148,%eax
  802de4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	eb 08                	jmp    802df4 <insert_sorted_with_merge_freeList+0x4ac>
  802dec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802def:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df7:	a3 48 41 80 00       	mov    %eax,0x804148
  802dfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e06:	a1 54 41 80 00       	mov    0x804154,%eax
  802e0b:	40                   	inc    %eax
  802e0c:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e11:	e9 78 02 00 00       	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 50 08             	mov    0x8(%eax),%edx
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e22:	01 c2                	add    %eax,%edx
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	8b 40 08             	mov    0x8(%eax),%eax
  802e2a:	39 c2                	cmp    %eax,%edx
  802e2c:	0f 83 b8 00 00 00    	jae    802eea <insert_sorted_with_merge_freeList+0x5a2>
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	8b 50 08             	mov    0x8(%eax),%edx
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3e:	01 c2                	add    %eax,%edx
  802e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e43:	8b 40 08             	mov    0x8(%eax),%eax
  802e46:	39 c2                	cmp    %eax,%edx
  802e48:	0f 85 9c 00 00 00    	jne    802eea <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e51:	8b 50 0c             	mov    0xc(%eax),%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5a:	01 c2                	add    %eax,%edx
  802e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5f:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	8b 50 08             	mov    0x8(%eax),%edx
  802e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6b:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e86:	75 17                	jne    802e9f <insert_sorted_with_merge_freeList+0x557>
  802e88:	83 ec 04             	sub    $0x4,%esp
  802e8b:	68 34 3c 80 00       	push   $0x803c34
  802e90:	68 67 01 00 00       	push   $0x167
  802e95:	68 57 3c 80 00       	push   $0x803c57
  802e9a:	e8 f2 01 00 00       	call   803091 <_panic>
  802e9f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	89 10                	mov    %edx,(%eax)
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	85 c0                	test   %eax,%eax
  802eb1:	74 0d                	je     802ec0 <insert_sorted_with_merge_freeList+0x578>
  802eb3:	a1 48 41 80 00       	mov    0x804148,%eax
  802eb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebb:	89 50 04             	mov    %edx,0x4(%eax)
  802ebe:	eb 08                	jmp    802ec8 <insert_sorted_with_merge_freeList+0x580>
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	a3 48 41 80 00       	mov    %eax,0x804148
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eda:	a1 54 41 80 00       	mov    0x804154,%eax
  802edf:	40                   	inc    %eax
  802ee0:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802ee5:	e9 a4 01 00 00       	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 50 08             	mov    0x8(%eax),%edx
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef6:	01 c2                	add    %eax,%edx
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	8b 40 08             	mov    0x8(%eax),%eax
  802efe:	39 c2                	cmp    %eax,%edx
  802f00:	0f 85 ac 00 00 00    	jne    802fb2 <insert_sorted_with_merge_freeList+0x66a>
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 50 08             	mov    0x8(%eax),%edx
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f12:	01 c2                	add    %eax,%edx
  802f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f17:	8b 40 08             	mov    0x8(%eax),%eax
  802f1a:	39 c2                	cmp    %eax,%edx
  802f1c:	0f 83 90 00 00 00    	jae    802fb2 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 50 0c             	mov    0xc(%eax),%edx
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2e:	01 c2                	add    %eax,%edx
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4e:	75 17                	jne    802f67 <insert_sorted_with_merge_freeList+0x61f>
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	68 34 3c 80 00       	push   $0x803c34
  802f58:	68 70 01 00 00       	push   $0x170
  802f5d:	68 57 3c 80 00       	push   $0x803c57
  802f62:	e8 2a 01 00 00       	call   803091 <_panic>
  802f67:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	89 10                	mov    %edx,(%eax)
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 0d                	je     802f88 <insert_sorted_with_merge_freeList+0x640>
  802f7b:	a1 48 41 80 00       	mov    0x804148,%eax
  802f80:	8b 55 08             	mov    0x8(%ebp),%edx
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	eb 08                	jmp    802f90 <insert_sorted_with_merge_freeList+0x648>
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	a3 48 41 80 00       	mov    %eax,0x804148
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa2:	a1 54 41 80 00       	mov    0x804154,%eax
  802fa7:	40                   	inc    %eax
  802fa8:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802fad:	e9 dc 00 00 00       	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 50 08             	mov    0x8(%eax),%edx
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbe:	01 c2                	add    %eax,%edx
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	8b 40 08             	mov    0x8(%eax),%eax
  802fc6:	39 c2                	cmp    %eax,%edx
  802fc8:	0f 83 88 00 00 00    	jae    803056 <insert_sorted_with_merge_freeList+0x70e>
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	8b 50 08             	mov    0x8(%eax),%edx
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fda:	01 c2                	add    %eax,%edx
  802fdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fdf:	8b 40 08             	mov    0x8(%eax),%eax
  802fe2:	39 c2                	cmp    %eax,%edx
  802fe4:	73 70                	jae    803056 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802fe6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fea:	74 06                	je     802ff2 <insert_sorted_with_merge_freeList+0x6aa>
  802fec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff0:	75 17                	jne    803009 <insert_sorted_with_merge_freeList+0x6c1>
  802ff2:	83 ec 04             	sub    $0x4,%esp
  802ff5:	68 94 3c 80 00       	push   $0x803c94
  802ffa:	68 75 01 00 00       	push   $0x175
  802fff:	68 57 3c 80 00       	push   $0x803c57
  803004:	e8 88 00 00 00       	call   803091 <_panic>
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 10                	mov    (%eax),%edx
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	89 10                	mov    %edx,(%eax)
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	74 0b                	je     803027 <insert_sorted_with_merge_freeList+0x6df>
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	8b 55 08             	mov    0x8(%ebp),%edx
  803024:	89 50 04             	mov    %edx,0x4(%eax)
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 55 08             	mov    0x8(%ebp),%edx
  80302d:	89 10                	mov    %edx,(%eax)
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803035:	89 50 04             	mov    %edx,0x4(%eax)
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	8b 00                	mov    (%eax),%eax
  80303d:	85 c0                	test   %eax,%eax
  80303f:	75 08                	jne    803049 <insert_sorted_with_merge_freeList+0x701>
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803049:	a1 44 41 80 00       	mov    0x804144,%eax
  80304e:	40                   	inc    %eax
  80304f:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  803054:	eb 38                	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803056:	a1 40 41 80 00       	mov    0x804140,%eax
  80305b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80305e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803062:	74 07                	je     80306b <insert_sorted_with_merge_freeList+0x723>
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 00                	mov    (%eax),%eax
  803069:	eb 05                	jmp    803070 <insert_sorted_with_merge_freeList+0x728>
  80306b:	b8 00 00 00 00       	mov    $0x0,%eax
  803070:	a3 40 41 80 00       	mov    %eax,0x804140
  803075:	a1 40 41 80 00       	mov    0x804140,%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	0f 85 c3 fb ff ff    	jne    802c45 <insert_sorted_with_merge_freeList+0x2fd>
  803082:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803086:	0f 85 b9 fb ff ff    	jne    802c45 <insert_sorted_with_merge_freeList+0x2fd>





}
  80308c:	eb 00                	jmp    80308e <insert_sorted_with_merge_freeList+0x746>
  80308e:	90                   	nop
  80308f:	c9                   	leave  
  803090:	c3                   	ret    

00803091 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803091:	55                   	push   %ebp
  803092:	89 e5                	mov    %esp,%ebp
  803094:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803097:	8d 45 10             	lea    0x10(%ebp),%eax
  80309a:	83 c0 04             	add    $0x4,%eax
  80309d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8030a0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8030a5:	85 c0                	test   %eax,%eax
  8030a7:	74 16                	je     8030bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8030a9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8030ae:	83 ec 08             	sub    $0x8,%esp
  8030b1:	50                   	push   %eax
  8030b2:	68 18 3d 80 00       	push   $0x803d18
  8030b7:	e8 66 d5 ff ff       	call   800622 <cprintf>
  8030bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8030bf:	a1 00 40 80 00       	mov    0x804000,%eax
  8030c4:	ff 75 0c             	pushl  0xc(%ebp)
  8030c7:	ff 75 08             	pushl  0x8(%ebp)
  8030ca:	50                   	push   %eax
  8030cb:	68 1d 3d 80 00       	push   $0x803d1d
  8030d0:	e8 4d d5 ff ff       	call   800622 <cprintf>
  8030d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8030d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8030db:	83 ec 08             	sub    $0x8,%esp
  8030de:	ff 75 f4             	pushl  -0xc(%ebp)
  8030e1:	50                   	push   %eax
  8030e2:	e8 d0 d4 ff ff       	call   8005b7 <vcprintf>
  8030e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8030ea:	83 ec 08             	sub    $0x8,%esp
  8030ed:	6a 00                	push   $0x0
  8030ef:	68 39 3d 80 00       	push   $0x803d39
  8030f4:	e8 be d4 ff ff       	call   8005b7 <vcprintf>
  8030f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8030fc:	e8 3f d4 ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  803101:	eb fe                	jmp    803101 <_panic+0x70>

00803103 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803103:	55                   	push   %ebp
  803104:	89 e5                	mov    %esp,%ebp
  803106:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803109:	a1 20 40 80 00       	mov    0x804020,%eax
  80310e:	8b 50 74             	mov    0x74(%eax),%edx
  803111:	8b 45 0c             	mov    0xc(%ebp),%eax
  803114:	39 c2                	cmp    %eax,%edx
  803116:	74 14                	je     80312c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803118:	83 ec 04             	sub    $0x4,%esp
  80311b:	68 3c 3d 80 00       	push   $0x803d3c
  803120:	6a 26                	push   $0x26
  803122:	68 88 3d 80 00       	push   $0x803d88
  803127:	e8 65 ff ff ff       	call   803091 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80312c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803133:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80313a:	e9 c2 00 00 00       	jmp    803201 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80313f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803142:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	01 d0                	add    %edx,%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	75 08                	jne    80315c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803154:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803157:	e9 a2 00 00 00       	jmp    8031fe <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80315c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803163:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80316a:	eb 69                	jmp    8031d5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80316c:	a1 20 40 80 00       	mov    0x804020,%eax
  803171:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803177:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317a:	89 d0                	mov    %edx,%eax
  80317c:	01 c0                	add    %eax,%eax
  80317e:	01 d0                	add    %edx,%eax
  803180:	c1 e0 03             	shl    $0x3,%eax
  803183:	01 c8                	add    %ecx,%eax
  803185:	8a 40 04             	mov    0x4(%eax),%al
  803188:	84 c0                	test   %al,%al
  80318a:	75 46                	jne    8031d2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80318c:	a1 20 40 80 00       	mov    0x804020,%eax
  803191:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803197:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80319a:	89 d0                	mov    %edx,%eax
  80319c:	01 c0                	add    %eax,%eax
  80319e:	01 d0                	add    %edx,%eax
  8031a0:	c1 e0 03             	shl    $0x3,%eax
  8031a3:	01 c8                	add    %ecx,%eax
  8031a5:	8b 00                	mov    (%eax),%eax
  8031a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8031aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8031b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8031b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	01 c8                	add    %ecx,%eax
  8031c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8031c5:	39 c2                	cmp    %eax,%edx
  8031c7:	75 09                	jne    8031d2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8031c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8031d0:	eb 12                	jmp    8031e4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031d2:	ff 45 e8             	incl   -0x18(%ebp)
  8031d5:	a1 20 40 80 00       	mov    0x804020,%eax
  8031da:	8b 50 74             	mov    0x74(%eax),%edx
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	39 c2                	cmp    %eax,%edx
  8031e2:	77 88                	ja     80316c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8031e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031e8:	75 14                	jne    8031fe <CheckWSWithoutLastIndex+0xfb>
			panic(
  8031ea:	83 ec 04             	sub    $0x4,%esp
  8031ed:	68 94 3d 80 00       	push   $0x803d94
  8031f2:	6a 3a                	push   $0x3a
  8031f4:	68 88 3d 80 00       	push   $0x803d88
  8031f9:	e8 93 fe ff ff       	call   803091 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8031fe:	ff 45 f0             	incl   -0x10(%ebp)
  803201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803204:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803207:	0f 8c 32 ff ff ff    	jl     80313f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80320d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803214:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80321b:	eb 26                	jmp    803243 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80321d:	a1 20 40 80 00       	mov    0x804020,%eax
  803222:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803228:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80322b:	89 d0                	mov    %edx,%eax
  80322d:	01 c0                	add    %eax,%eax
  80322f:	01 d0                	add    %edx,%eax
  803231:	c1 e0 03             	shl    $0x3,%eax
  803234:	01 c8                	add    %ecx,%eax
  803236:	8a 40 04             	mov    0x4(%eax),%al
  803239:	3c 01                	cmp    $0x1,%al
  80323b:	75 03                	jne    803240 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80323d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803240:	ff 45 e0             	incl   -0x20(%ebp)
  803243:	a1 20 40 80 00       	mov    0x804020,%eax
  803248:	8b 50 74             	mov    0x74(%eax),%edx
  80324b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80324e:	39 c2                	cmp    %eax,%edx
  803250:	77 cb                	ja     80321d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803258:	74 14                	je     80326e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80325a:	83 ec 04             	sub    $0x4,%esp
  80325d:	68 e8 3d 80 00       	push   $0x803de8
  803262:	6a 44                	push   $0x44
  803264:	68 88 3d 80 00       	push   $0x803d88
  803269:	e8 23 fe ff ff       	call   803091 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80326e:	90                   	nop
  80326f:	c9                   	leave  
  803270:	c3                   	ret    
  803271:	66 90                	xchg   %ax,%ax
  803273:	90                   	nop

00803274 <__udivdi3>:
  803274:	55                   	push   %ebp
  803275:	57                   	push   %edi
  803276:	56                   	push   %esi
  803277:	53                   	push   %ebx
  803278:	83 ec 1c             	sub    $0x1c,%esp
  80327b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80327f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803283:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803287:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80328b:	89 ca                	mov    %ecx,%edx
  80328d:	89 f8                	mov    %edi,%eax
  80328f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803293:	85 f6                	test   %esi,%esi
  803295:	75 2d                	jne    8032c4 <__udivdi3+0x50>
  803297:	39 cf                	cmp    %ecx,%edi
  803299:	77 65                	ja     803300 <__udivdi3+0x8c>
  80329b:	89 fd                	mov    %edi,%ebp
  80329d:	85 ff                	test   %edi,%edi
  80329f:	75 0b                	jne    8032ac <__udivdi3+0x38>
  8032a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8032a6:	31 d2                	xor    %edx,%edx
  8032a8:	f7 f7                	div    %edi
  8032aa:	89 c5                	mov    %eax,%ebp
  8032ac:	31 d2                	xor    %edx,%edx
  8032ae:	89 c8                	mov    %ecx,%eax
  8032b0:	f7 f5                	div    %ebp
  8032b2:	89 c1                	mov    %eax,%ecx
  8032b4:	89 d8                	mov    %ebx,%eax
  8032b6:	f7 f5                	div    %ebp
  8032b8:	89 cf                	mov    %ecx,%edi
  8032ba:	89 fa                	mov    %edi,%edx
  8032bc:	83 c4 1c             	add    $0x1c,%esp
  8032bf:	5b                   	pop    %ebx
  8032c0:	5e                   	pop    %esi
  8032c1:	5f                   	pop    %edi
  8032c2:	5d                   	pop    %ebp
  8032c3:	c3                   	ret    
  8032c4:	39 ce                	cmp    %ecx,%esi
  8032c6:	77 28                	ja     8032f0 <__udivdi3+0x7c>
  8032c8:	0f bd fe             	bsr    %esi,%edi
  8032cb:	83 f7 1f             	xor    $0x1f,%edi
  8032ce:	75 40                	jne    803310 <__udivdi3+0x9c>
  8032d0:	39 ce                	cmp    %ecx,%esi
  8032d2:	72 0a                	jb     8032de <__udivdi3+0x6a>
  8032d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032d8:	0f 87 9e 00 00 00    	ja     80337c <__udivdi3+0x108>
  8032de:	b8 01 00 00 00       	mov    $0x1,%eax
  8032e3:	89 fa                	mov    %edi,%edx
  8032e5:	83 c4 1c             	add    $0x1c,%esp
  8032e8:	5b                   	pop    %ebx
  8032e9:	5e                   	pop    %esi
  8032ea:	5f                   	pop    %edi
  8032eb:	5d                   	pop    %ebp
  8032ec:	c3                   	ret    
  8032ed:	8d 76 00             	lea    0x0(%esi),%esi
  8032f0:	31 ff                	xor    %edi,%edi
  8032f2:	31 c0                	xor    %eax,%eax
  8032f4:	89 fa                	mov    %edi,%edx
  8032f6:	83 c4 1c             	add    $0x1c,%esp
  8032f9:	5b                   	pop    %ebx
  8032fa:	5e                   	pop    %esi
  8032fb:	5f                   	pop    %edi
  8032fc:	5d                   	pop    %ebp
  8032fd:	c3                   	ret    
  8032fe:	66 90                	xchg   %ax,%ax
  803300:	89 d8                	mov    %ebx,%eax
  803302:	f7 f7                	div    %edi
  803304:	31 ff                	xor    %edi,%edi
  803306:	89 fa                	mov    %edi,%edx
  803308:	83 c4 1c             	add    $0x1c,%esp
  80330b:	5b                   	pop    %ebx
  80330c:	5e                   	pop    %esi
  80330d:	5f                   	pop    %edi
  80330e:	5d                   	pop    %ebp
  80330f:	c3                   	ret    
  803310:	bd 20 00 00 00       	mov    $0x20,%ebp
  803315:	89 eb                	mov    %ebp,%ebx
  803317:	29 fb                	sub    %edi,%ebx
  803319:	89 f9                	mov    %edi,%ecx
  80331b:	d3 e6                	shl    %cl,%esi
  80331d:	89 c5                	mov    %eax,%ebp
  80331f:	88 d9                	mov    %bl,%cl
  803321:	d3 ed                	shr    %cl,%ebp
  803323:	89 e9                	mov    %ebp,%ecx
  803325:	09 f1                	or     %esi,%ecx
  803327:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80332b:	89 f9                	mov    %edi,%ecx
  80332d:	d3 e0                	shl    %cl,%eax
  80332f:	89 c5                	mov    %eax,%ebp
  803331:	89 d6                	mov    %edx,%esi
  803333:	88 d9                	mov    %bl,%cl
  803335:	d3 ee                	shr    %cl,%esi
  803337:	89 f9                	mov    %edi,%ecx
  803339:	d3 e2                	shl    %cl,%edx
  80333b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80333f:	88 d9                	mov    %bl,%cl
  803341:	d3 e8                	shr    %cl,%eax
  803343:	09 c2                	or     %eax,%edx
  803345:	89 d0                	mov    %edx,%eax
  803347:	89 f2                	mov    %esi,%edx
  803349:	f7 74 24 0c          	divl   0xc(%esp)
  80334d:	89 d6                	mov    %edx,%esi
  80334f:	89 c3                	mov    %eax,%ebx
  803351:	f7 e5                	mul    %ebp
  803353:	39 d6                	cmp    %edx,%esi
  803355:	72 19                	jb     803370 <__udivdi3+0xfc>
  803357:	74 0b                	je     803364 <__udivdi3+0xf0>
  803359:	89 d8                	mov    %ebx,%eax
  80335b:	31 ff                	xor    %edi,%edi
  80335d:	e9 58 ff ff ff       	jmp    8032ba <__udivdi3+0x46>
  803362:	66 90                	xchg   %ax,%ax
  803364:	8b 54 24 08          	mov    0x8(%esp),%edx
  803368:	89 f9                	mov    %edi,%ecx
  80336a:	d3 e2                	shl    %cl,%edx
  80336c:	39 c2                	cmp    %eax,%edx
  80336e:	73 e9                	jae    803359 <__udivdi3+0xe5>
  803370:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803373:	31 ff                	xor    %edi,%edi
  803375:	e9 40 ff ff ff       	jmp    8032ba <__udivdi3+0x46>
  80337a:	66 90                	xchg   %ax,%ax
  80337c:	31 c0                	xor    %eax,%eax
  80337e:	e9 37 ff ff ff       	jmp    8032ba <__udivdi3+0x46>
  803383:	90                   	nop

00803384 <__umoddi3>:
  803384:	55                   	push   %ebp
  803385:	57                   	push   %edi
  803386:	56                   	push   %esi
  803387:	53                   	push   %ebx
  803388:	83 ec 1c             	sub    $0x1c,%esp
  80338b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80338f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803393:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803397:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80339b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80339f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033a3:	89 f3                	mov    %esi,%ebx
  8033a5:	89 fa                	mov    %edi,%edx
  8033a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033ab:	89 34 24             	mov    %esi,(%esp)
  8033ae:	85 c0                	test   %eax,%eax
  8033b0:	75 1a                	jne    8033cc <__umoddi3+0x48>
  8033b2:	39 f7                	cmp    %esi,%edi
  8033b4:	0f 86 a2 00 00 00    	jbe    80345c <__umoddi3+0xd8>
  8033ba:	89 c8                	mov    %ecx,%eax
  8033bc:	89 f2                	mov    %esi,%edx
  8033be:	f7 f7                	div    %edi
  8033c0:	89 d0                	mov    %edx,%eax
  8033c2:	31 d2                	xor    %edx,%edx
  8033c4:	83 c4 1c             	add    $0x1c,%esp
  8033c7:	5b                   	pop    %ebx
  8033c8:	5e                   	pop    %esi
  8033c9:	5f                   	pop    %edi
  8033ca:	5d                   	pop    %ebp
  8033cb:	c3                   	ret    
  8033cc:	39 f0                	cmp    %esi,%eax
  8033ce:	0f 87 ac 00 00 00    	ja     803480 <__umoddi3+0xfc>
  8033d4:	0f bd e8             	bsr    %eax,%ebp
  8033d7:	83 f5 1f             	xor    $0x1f,%ebp
  8033da:	0f 84 ac 00 00 00    	je     80348c <__umoddi3+0x108>
  8033e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8033e5:	29 ef                	sub    %ebp,%edi
  8033e7:	89 fe                	mov    %edi,%esi
  8033e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033ed:	89 e9                	mov    %ebp,%ecx
  8033ef:	d3 e0                	shl    %cl,%eax
  8033f1:	89 d7                	mov    %edx,%edi
  8033f3:	89 f1                	mov    %esi,%ecx
  8033f5:	d3 ef                	shr    %cl,%edi
  8033f7:	09 c7                	or     %eax,%edi
  8033f9:	89 e9                	mov    %ebp,%ecx
  8033fb:	d3 e2                	shl    %cl,%edx
  8033fd:	89 14 24             	mov    %edx,(%esp)
  803400:	89 d8                	mov    %ebx,%eax
  803402:	d3 e0                	shl    %cl,%eax
  803404:	89 c2                	mov    %eax,%edx
  803406:	8b 44 24 08          	mov    0x8(%esp),%eax
  80340a:	d3 e0                	shl    %cl,%eax
  80340c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803410:	8b 44 24 08          	mov    0x8(%esp),%eax
  803414:	89 f1                	mov    %esi,%ecx
  803416:	d3 e8                	shr    %cl,%eax
  803418:	09 d0                	or     %edx,%eax
  80341a:	d3 eb                	shr    %cl,%ebx
  80341c:	89 da                	mov    %ebx,%edx
  80341e:	f7 f7                	div    %edi
  803420:	89 d3                	mov    %edx,%ebx
  803422:	f7 24 24             	mull   (%esp)
  803425:	89 c6                	mov    %eax,%esi
  803427:	89 d1                	mov    %edx,%ecx
  803429:	39 d3                	cmp    %edx,%ebx
  80342b:	0f 82 87 00 00 00    	jb     8034b8 <__umoddi3+0x134>
  803431:	0f 84 91 00 00 00    	je     8034c8 <__umoddi3+0x144>
  803437:	8b 54 24 04          	mov    0x4(%esp),%edx
  80343b:	29 f2                	sub    %esi,%edx
  80343d:	19 cb                	sbb    %ecx,%ebx
  80343f:	89 d8                	mov    %ebx,%eax
  803441:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803445:	d3 e0                	shl    %cl,%eax
  803447:	89 e9                	mov    %ebp,%ecx
  803449:	d3 ea                	shr    %cl,%edx
  80344b:	09 d0                	or     %edx,%eax
  80344d:	89 e9                	mov    %ebp,%ecx
  80344f:	d3 eb                	shr    %cl,%ebx
  803451:	89 da                	mov    %ebx,%edx
  803453:	83 c4 1c             	add    $0x1c,%esp
  803456:	5b                   	pop    %ebx
  803457:	5e                   	pop    %esi
  803458:	5f                   	pop    %edi
  803459:	5d                   	pop    %ebp
  80345a:	c3                   	ret    
  80345b:	90                   	nop
  80345c:	89 fd                	mov    %edi,%ebp
  80345e:	85 ff                	test   %edi,%edi
  803460:	75 0b                	jne    80346d <__umoddi3+0xe9>
  803462:	b8 01 00 00 00       	mov    $0x1,%eax
  803467:	31 d2                	xor    %edx,%edx
  803469:	f7 f7                	div    %edi
  80346b:	89 c5                	mov    %eax,%ebp
  80346d:	89 f0                	mov    %esi,%eax
  80346f:	31 d2                	xor    %edx,%edx
  803471:	f7 f5                	div    %ebp
  803473:	89 c8                	mov    %ecx,%eax
  803475:	f7 f5                	div    %ebp
  803477:	89 d0                	mov    %edx,%eax
  803479:	e9 44 ff ff ff       	jmp    8033c2 <__umoddi3+0x3e>
  80347e:	66 90                	xchg   %ax,%ax
  803480:	89 c8                	mov    %ecx,%eax
  803482:	89 f2                	mov    %esi,%edx
  803484:	83 c4 1c             	add    $0x1c,%esp
  803487:	5b                   	pop    %ebx
  803488:	5e                   	pop    %esi
  803489:	5f                   	pop    %edi
  80348a:	5d                   	pop    %ebp
  80348b:	c3                   	ret    
  80348c:	3b 04 24             	cmp    (%esp),%eax
  80348f:	72 06                	jb     803497 <__umoddi3+0x113>
  803491:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803495:	77 0f                	ja     8034a6 <__umoddi3+0x122>
  803497:	89 f2                	mov    %esi,%edx
  803499:	29 f9                	sub    %edi,%ecx
  80349b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80349f:	89 14 24             	mov    %edx,(%esp)
  8034a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034aa:	8b 14 24             	mov    (%esp),%edx
  8034ad:	83 c4 1c             	add    $0x1c,%esp
  8034b0:	5b                   	pop    %ebx
  8034b1:	5e                   	pop    %esi
  8034b2:	5f                   	pop    %edi
  8034b3:	5d                   	pop    %ebp
  8034b4:	c3                   	ret    
  8034b5:	8d 76 00             	lea    0x0(%esi),%esi
  8034b8:	2b 04 24             	sub    (%esp),%eax
  8034bb:	19 fa                	sbb    %edi,%edx
  8034bd:	89 d1                	mov    %edx,%ecx
  8034bf:	89 c6                	mov    %eax,%esi
  8034c1:	e9 71 ff ff ff       	jmp    803437 <__umoddi3+0xb3>
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034cc:	72 ea                	jb     8034b8 <__umoddi3+0x134>
  8034ce:	89 d9                	mov    %ebx,%ecx
  8034d0:	e9 62 ff ff ff       	jmp    803437 <__umoddi3+0xb3>
