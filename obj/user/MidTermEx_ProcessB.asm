
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 e9 19 00 00       	call   801a2c <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 00 33 80 00       	push   $0x803300
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 b8 14 00 00       	call   80150e <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 02 33 80 00       	push   $0x803302
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 a2 14 00 00       	call   80150e <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 09 33 80 00       	push   $0x803309
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 8c 14 00 00       	call   80150e <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 17 33 80 00       	push   $0x803317
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 2b 18 00 00       	call   8018cd <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 ae 19 00 00       	call   801a5f <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 11 2d 00 00       	call   802dea <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 6e 19 00 00       	call   801a5f <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 d1 2c 00 00       	call   802dea <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 2f 19 00 00       	call   801a5f <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 92 2c 00 00       	call   802dea <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 9d 18 00 00       	call   801a13 <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	01 c0                	add    %eax,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018e:	01 d0                	add    %edx,%eax
  800190:	c1 e0 04             	shl    $0x4,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019d:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 0f                	je     8001bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001bf:	7e 0a                	jle    8001cb <libmain+0x60>
		binaryname = argv[0];
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	8b 00                	mov    (%eax),%eax
  8001c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	e8 5f fe ff ff       	call   800038 <_main>
  8001d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dc:	e8 3f 16 00 00       	call   801820 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 34 33 80 00       	push   $0x803334
  8001e9:	e8 8d 01 00 00       	call   80037b <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 5c 33 80 00       	push   $0x80335c
  800211:	e8 65 01 00 00       	call   80037b <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800219:	a1 20 40 80 00       	mov    0x804020,%eax
  80021e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023a:	51                   	push   %ecx
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 84 33 80 00       	push   $0x803384
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 dc 33 80 00       	push   $0x8033dc
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 34 33 80 00       	push   $0x803334
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 bf 15 00 00       	call   80183a <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027b:	e8 19 00 00 00       	call   800299 <exit>
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	6a 00                	push   $0x0
  80028e:	e8 4c 17 00 00       	call   8019df <sys_destroy_env>
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <exit>:

void
exit(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029f:	e8 a1 17 00 00       	call   801a45 <sys_exit_env>
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b0:	8b 00                	mov    (%eax),%eax
  8002b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	89 0a                	mov    %ecx,(%edx)
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	88 d1                	mov    %dl,%cl
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 2c                	jne    8002fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d2:	a0 24 40 80 00       	mov    0x804024,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	8b 12                	mov    (%edx),%edx
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	83 c2 08             	add    $0x8,%edx
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	51                   	push   %ecx
  8002ec:	52                   	push   %edx
  8002ed:	e8 80 13 00 00       	call   801672 <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 40 04             	mov    0x4(%eax),%eax
  800304:	8d 50 01             	lea    0x1(%eax),%edx
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800320:	00 00 00 
	b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800339:	50                   	push   %eax
  80033a:	68 a7 02 80 00       	push   $0x8002a7
  80033f:	e8 11 02 00 00       	call   800555 <vprintfmt>
  800344:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800347:	a0 24 40 80 00       	mov    0x804024,%al
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	50                   	push   %eax
  800359:	52                   	push   %edx
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	83 c0 08             	add    $0x8,%eax
  800363:	50                   	push   %eax
  800364:	e8 09 13 00 00       	call   801672 <sys_cputs>
  800369:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800373:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <cprintf>:

int cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800381:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 f4             	pushl  -0xc(%ebp)
  800397:	50                   	push   %eax
  800398:	e8 73 ff ff ff       	call   800310 <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ae:	e8 6d 14 00 00       	call   801820 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	50                   	push   %eax
  8003c3:	e8 48 ff ff ff       	call   800310 <vcprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ce:	e8 67 14 00 00       	call   80183a <sys_enable_interrupt>
	return cnt;
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	53                   	push   %ebx
  8003dc:	83 ec 14             	sub    $0x14,%esp
  8003df:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f6:	77 55                	ja     80044d <printnum+0x75>
  8003f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fb:	72 05                	jb     800402 <printnum+0x2a>
  8003fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800400:	77 4b                	ja     80044d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800402:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800405:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800408:	8b 45 18             	mov    0x18(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	ff 75 f4             	pushl  -0xc(%ebp)
  800415:	ff 75 f0             	pushl  -0x10(%ebp)
  800418:	e8 63 2c 00 00       	call   803080 <__udivdi3>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	ff 75 20             	pushl  0x20(%ebp)
  800426:	53                   	push   %ebx
  800427:	ff 75 18             	pushl  0x18(%ebp)
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	e8 a1 ff ff ff       	call   8003d8 <printnum>
  800437:	83 c4 20             	add    $0x20,%esp
  80043a:	eb 1a                	jmp    800456 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 20             	pushl  0x20(%ebp)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	ff d0                	call   *%eax
  80044a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044d:	ff 4d 1c             	decl   0x1c(%ebp)
  800450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800454:	7f e6                	jg     80043c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800456:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	53                   	push   %ebx
  800465:	51                   	push   %ecx
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	e8 23 2d 00 00       	call   803190 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 14 36 80 00       	add    $0x803614,%eax
  800475:	8a 00                	mov    (%eax),%al
  800477:	0f be c0             	movsbl %al,%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 0c             	pushl  0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	ff d0                	call   *%eax
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	90                   	nop
  80048a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800496:	7e 1c                	jle    8004b4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 08             	lea    0x8(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 08             	sub    $0x8,%eax
  8004ad:	8b 50 04             	mov    0x4(%eax),%edx
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	eb 40                	jmp    8004f4 <getuint+0x65>
	else if (lflag)
  8004b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b8:	74 1e                	je     8004d8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	eb 1c                	jmp    8004f4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    

008004f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fd:	7e 1c                	jle    80051b <getint+0x25>
		return va_arg(*ap, long long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 08             	lea    0x8(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	8b 50 04             	mov    0x4(%eax),%edx
  800517:	8b 00                	mov    (%eax),%eax
  800519:	eb 38                	jmp    800553 <getint+0x5d>
	else if (lflag)
  80051b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051f:	74 1a                	je     80053b <getint+0x45>
		return va_arg(*ap, long);
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 50 04             	lea    0x4(%eax),%edx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	83 e8 04             	sub    $0x4,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	99                   	cltd   
  800539:	eb 18                	jmp    800553 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	99                   	cltd   
}
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
  80055a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	eb 17                	jmp    800576 <vprintfmt+0x21>
			if (ch == '\0')
  80055f:	85 db                	test   %ebx,%ebx
  800561:	0f 84 af 03 00 00    	je     800916 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	83 fb 25             	cmp    $0x25,%ebx
  800587:	75 d6                	jne    80055f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800589:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800594:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	8d 50 01             	lea    0x1(%eax),%edx
  8005af:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b2:	8a 00                	mov    (%eax),%al
  8005b4:	0f b6 d8             	movzbl %al,%ebx
  8005b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ba:	83 f8 55             	cmp    $0x55,%eax
  8005bd:	0f 87 2b 03 00 00    	ja     8008ee <vprintfmt+0x399>
  8005c3:	8b 04 85 38 36 80 00 	mov    0x803638(,%eax,4),%eax
  8005ca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d0:	eb d7                	jmp    8005a9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d6:	eb d1                	jmp    8005a9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	c1 e0 02             	shl    $0x2,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	01 c0                	add    %eax,%eax
  8005eb:	01 d8                	add    %ebx,%eax
  8005ed:	83 e8 30             	sub    $0x30,%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8a 00                	mov    (%eax),%al
  8005f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fe:	7e 3e                	jle    80063e <vprintfmt+0xe9>
  800600:	83 fb 39             	cmp    $0x39,%ebx
  800603:	7f 39                	jg     80063e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800605:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800608:	eb d5                	jmp    8005df <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 e8 04             	sub    $0x4,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061e:	eb 1f                	jmp    80063f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800620:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800624:	79 83                	jns    8005a9 <vprintfmt+0x54>
				width = 0;
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062d:	e9 77 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800632:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800639:	e9 6b ff ff ff       	jmp    8005a9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	0f 89 60 ff ff ff    	jns    8005a9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800656:	e9 4e ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065e:	e9 46 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 c0 04             	add    $0x4,%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
			break;
  800683:	e9 89 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800699:	85 db                	test   %ebx,%ebx
  80069b:	79 02                	jns    80069f <vprintfmt+0x14a>
				err = -err;
  80069d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069f:	83 fb 64             	cmp    $0x64,%ebx
  8006a2:	7f 0b                	jg     8006af <vprintfmt+0x15a>
  8006a4:	8b 34 9d 80 34 80 00 	mov    0x803480(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 25 36 80 00       	push   $0x803625
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 5e 02 00 00       	call   80091e <printfmt>
  8006c0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c3:	e9 49 02 00 00       	jmp    800911 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c8:	56                   	push   %esi
  8006c9:	68 2e 36 80 00       	push   $0x80362e
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	e8 45 02 00 00       	call   80091e <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			break;
  8006dc:	e9 30 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 30                	mov    (%eax),%esi
  8006f2:	85 f6                	test   %esi,%esi
  8006f4:	75 05                	jne    8006fb <vprintfmt+0x1a6>
				p = "(null)";
  8006f6:	be 31 36 80 00       	mov    $0x803631,%esi
			if (width > 0 && padc != '-')
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7e 6d                	jle    80076e <vprintfmt+0x219>
  800701:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800705:	74 67                	je     80076e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	50                   	push   %eax
  80070e:	56                   	push   %esi
  80070f:	e8 0c 03 00 00       	call   800a20 <strnlen>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071a:	eb 16                	jmp    800732 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	ff 4d e4             	decl   -0x1c(%ebp)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	7f e4                	jg     80071c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	eb 34                	jmp    80076e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073e:	74 1c                	je     80075c <vprintfmt+0x207>
  800740:	83 fb 1f             	cmp    $0x1f,%ebx
  800743:	7e 05                	jle    80074a <vprintfmt+0x1f5>
  800745:	83 fb 7e             	cmp    $0x7e,%ebx
  800748:	7e 12                	jle    80075c <vprintfmt+0x207>
					putch('?', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 3f                	push   $0x3f
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	eb 0f                	jmp    80076b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	53                   	push   %ebx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076b:	ff 4d e4             	decl   -0x1c(%ebp)
  80076e:	89 f0                	mov    %esi,%eax
  800770:	8d 70 01             	lea    0x1(%eax),%esi
  800773:	8a 00                	mov    (%eax),%al
  800775:	0f be d8             	movsbl %al,%ebx
  800778:	85 db                	test   %ebx,%ebx
  80077a:	74 24                	je     8007a0 <vprintfmt+0x24b>
  80077c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800780:	78 b8                	js     80073a <vprintfmt+0x1e5>
  800782:	ff 4d e0             	decl   -0x20(%ebp)
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	79 af                	jns    80073a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 20                	push   $0x20
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079d:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a4:	7f e7                	jg     80078d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a6:	e9 66 01 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	e8 3c fd ff ff       	call   8004f6 <getint>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	79 23                	jns    8007f0 <vprintfmt+0x29b>
				putch('-', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 2d                	push   $0x2d
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e3:	f7 d8                	neg    %eax
  8007e5:	83 d2 00             	adc    $0x0,%edx
  8007e8:	f7 da                	neg    %edx
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f7:	e9 bc 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 e8             	pushl  -0x18(%ebp)
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	e8 84 fc ff ff       	call   80048f <getuint>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800814:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081b:	e9 98 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 58                	push   $0x58
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 58                	push   $0x58
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 58                	push   $0x58
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			break;
  800850:	e9 bc 00 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 30                	push   $0x30
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 78                	push   $0x78
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800890:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800897:	eb 1f                	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 e8             	pushl  -0x18(%ebp)
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 e7 fb ff ff       	call   80048f <getuint>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	52                   	push   %edx
  8008c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 00 fb ff ff       	call   8003d8 <printnum>
  8008d8:	83 c4 20             	add    $0x20,%esp
			break;
  8008db:	eb 34                	jmp    800911 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	53                   	push   %ebx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ec:	eb 23                	jmp    800911 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 25                	push   $0x25
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fe:	ff 4d 10             	decl   0x10(%ebp)
  800901:	eb 03                	jmp    800906 <vprintfmt+0x3b1>
  800903:	ff 4d 10             	decl   0x10(%ebp)
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	48                   	dec    %eax
  80090a:	8a 00                	mov    (%eax),%al
  80090c:	3c 25                	cmp    $0x25,%al
  80090e:	75 f3                	jne    800903 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800910:	90                   	nop
		}
	}
  800911:	e9 47 fc ff ff       	jmp    80055d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800916:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 16 fc ff ff       	call   800555 <vprintfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800942:	90                   	nop
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 40 08             	mov    0x8(%eax),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 10                	mov    (%eax),%edx
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	8b 40 04             	mov    0x4(%eax),%eax
  800962:	39 c2                	cmp    %eax,%edx
  800964:	73 12                	jae    800978 <sprintputch+0x33>
		*b->buf++ = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 10                	mov    %dl,(%eax)
}
  800978:	90                   	nop
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a0:	74 06                	je     8009a8 <vsnprintf+0x2d>
  8009a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a6:	7f 07                	jg     8009af <vsnprintf+0x34>
		return -E_INVAL;
  8009a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ad:	eb 20                	jmp    8009cf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009af:	ff 75 14             	pushl  0x14(%ebp)
  8009b2:	ff 75 10             	pushl  0x10(%ebp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	68 45 09 80 00       	push   $0x800945
  8009be:	e8 92 fb ff ff       	call   800555 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 89 ff ff ff       	call   80097b <vsnprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0a:	eb 06                	jmp    800a12 <strlen+0x15>
		n++;
  800a0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	75 f1                	jne    800a0c <strlen+0xf>
		n++;
	return n;
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2d:	eb 09                	jmp    800a38 <strnlen+0x18>
		n++;
  800a2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	ff 45 08             	incl   0x8(%ebp)
  800a35:	ff 4d 0c             	decl   0xc(%ebp)
  800a38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3c:	74 09                	je     800a47 <strnlen+0x27>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	75 e8                	jne    800a2f <strnlen+0xf>
		n++;
	return n;
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a58:	90                   	nop
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8d 50 01             	lea    0x1(%eax),%edx
  800a5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6b:	8a 12                	mov    (%edx),%dl
  800a6d:	88 10                	mov    %dl,(%eax)
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e4                	jne    800a59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8d:	eb 1f                	jmp    800aae <strncpy+0x34>
		*dst++ = *src;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8a 12                	mov    (%edx),%dl
  800a9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 03                	je     800aab <strncpy+0x31>
			src++;
  800aa8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aab:	ff 45 fc             	incl   -0x4(%ebp)
  800aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab4:	72 d9                	jb     800a8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acb:	74 30                	je     800afd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800acd:	eb 16                	jmp    800ae5 <strlcpy+0x2a>
			*dst++ = *src++;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8d 50 01             	lea    0x1(%eax),%edx
  800ad5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ade:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae1:	8a 12                	mov    (%edx),%dl
  800ae3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae5:	ff 4d 10             	decl   0x10(%ebp)
  800ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aec:	74 09                	je     800af7 <strlcpy+0x3c>
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 d8                	jne    800acf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afd:	8b 55 08             	mov    0x8(%ebp),%edx
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0c:	eb 06                	jmp    800b14 <strcmp+0xb>
		p++, q++;
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strcmp+0x22>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 e3                	je     800b0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f b6 d0             	movzbl %al,%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f b6 c0             	movzbl %al,%eax
  800b3b:	29 c2                	sub    %eax,%edx
  800b3d:	89 d0                	mov    %edx,%eax
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b44:	eb 09                	jmp    800b4f <strncmp+0xe>
		n--, p++, q++;
  800b46:	ff 4d 10             	decl   0x10(%ebp)
  800b49:	ff 45 08             	incl   0x8(%ebp)
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b53:	74 17                	je     800b6c <strncmp+0x2b>
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	84 c0                	test   %al,%al
  800b5c:	74 0e                	je     800b6c <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 10                	mov    (%eax),%dl
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	38 c2                	cmp    %al,%dl
  800b6a:	74 da                	je     800b46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b70:	75 07                	jne    800b79 <strncmp+0x38>
		return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	eb 14                	jmp    800b8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d0             	movzbl %al,%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	29 c2                	sub    %eax,%edx
  800b8b:	89 d0                	mov    %edx,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9b:	eb 12                	jmp    800baf <strchr+0x20>
		if (*s == c)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba5:	75 05                	jne    800bac <strchr+0x1d>
			return (char *) s;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	eb 11                	jmp    800bbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bac:	ff 45 08             	incl   0x8(%ebp)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 e5                	jne    800b9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcb:	eb 0d                	jmp    800bda <strfind+0x1b>
		if (*s == c)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd5:	74 0e                	je     800be5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 ea                	jne    800bcd <strfind+0xe>
  800be3:	eb 01                	jmp    800be6 <strfind+0x27>
		if (*s == c)
			break;
  800be5:	90                   	nop
	return (char *) s;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfd:	eb 0e                	jmp    800c0d <memset+0x22>
		*p++ = c;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0d:	ff 4d f8             	decl   -0x8(%ebp)
  800c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c14:	79 e9                	jns    800bff <memset+0x14>
		*p++ = c;

	return v;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2d:	eb 16                	jmp    800c45 <memcpy+0x2a>
		*d++ = *s++;
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	75 dd                	jne    800c2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6f:	73 50                	jae    800cc1 <memmove+0x6a>
  800c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7c:	76 43                	jbe    800cc1 <memmove+0x6a>
		s += n;
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8a:	eb 10                	jmp    800c9c <memmove+0x45>
			*--d = *--s;
  800c8c:	ff 4d f8             	decl   -0x8(%ebp)
  800c8f:	ff 4d fc             	decl   -0x4(%ebp)
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c95:	8a 10                	mov    (%eax),%dl
  800c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 e3                	jne    800c8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca9:	eb 23                	jmp    800cce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	75 dd                	jne    800cab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce5:	eb 2a                	jmp    800d11 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 16                	je     800d0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
  800d09:	eb 18                	jmp    800d23 <memcmp+0x50>
		s1++, s2++;
  800d0b:	ff 45 fc             	incl   -0x4(%ebp)
  800d0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d17:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	75 c9                	jne    800ce7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d36:	eb 15                	jmp    800d4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 d0             	movzbl %al,%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	0f b6 c0             	movzbl %al,%eax
  800d46:	39 c2                	cmp    %eax,%edx
  800d48:	74 0d                	je     800d57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d53:	72 e3                	jb     800d38 <memfind+0x13>
  800d55:	eb 01                	jmp    800d58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d57:	90                   	nop
	return (void *) s;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d71:	eb 03                	jmp    800d76 <strtol+0x19>
		s++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 20                	cmp    $0x20,%al
  800d7d:	74 f4                	je     800d73 <strtol+0x16>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 09                	cmp    $0x9,%al
  800d86:	74 eb                	je     800d73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 2b                	cmp    $0x2b,%al
  800d8f:	75 05                	jne    800d96 <strtol+0x39>
		s++;
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	eb 13                	jmp    800da9 <strtol+0x4c>
	else if (*s == '-')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 2d                	cmp    $0x2d,%al
  800d9d:	75 0a                	jne    800da9 <strtol+0x4c>
		s++, neg = 1;
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	74 06                	je     800db5 <strtol+0x58>
  800daf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db3:	75 20                	jne    800dd5 <strtol+0x78>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 30                	cmp    $0x30,%al
  800dbc:	75 17                	jne    800dd5 <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	40                   	inc    %eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 78                	cmp    $0x78,%al
  800dc6:	75 0d                	jne    800dd5 <strtol+0x78>
		s += 2, base = 16;
  800dc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd3:	eb 28                	jmp    800dfd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 15                	jne    800df0 <strtol+0x93>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	3c 30                	cmp    $0x30,%al
  800de2:	75 0c                	jne    800df0 <strtol+0x93>
		s++, base = 8;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dee:	eb 0d                	jmp    800dfd <strtol+0xa0>
	else if (base == 0)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	75 07                	jne    800dfd <strtol+0xa0>
		base = 10;
  800df6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	3c 2f                	cmp    $0x2f,%al
  800e04:	7e 19                	jle    800e1f <strtol+0xc2>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 39                	cmp    $0x39,%al
  800e0d:	7f 10                	jg     800e1f <strtol+0xc2>
			dig = *s - '0';
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f be c0             	movsbl %al,%eax
  800e17:	83 e8 30             	sub    $0x30,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1d:	eb 42                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 60                	cmp    $0x60,%al
  800e26:	7e 19                	jle    800e41 <strtol+0xe4>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 7a                	cmp    $0x7a,%al
  800e2f:	7f 10                	jg     800e41 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be c0             	movsbl %al,%eax
  800e39:	83 e8 57             	sub    $0x57,%eax
  800e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3f:	eb 20                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 40                	cmp    $0x40,%al
  800e48:	7e 39                	jle    800e83 <strtol+0x126>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 5a                	cmp    $0x5a,%al
  800e51:	7f 30                	jg     800e83 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	0f be c0             	movsbl %al,%eax
  800e5b:	83 e8 37             	sub    $0x37,%eax
  800e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	7d 19                	jge    800e82 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	89 c2                	mov    %eax,%edx
  800e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7d:	e9 7b ff ff ff       	jmp    800dfd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e87:	74 08                	je     800e91 <strtol+0x134>
		*endptr = (char *) s;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e95:	74 07                	je     800e9e <strtol+0x141>
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	f7 d8                	neg    %eax
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x144>
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebb:	79 13                	jns    800ed0 <ltostr+0x2d>
	{
		neg = 1;
  800ebd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ecd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed8:	99                   	cltd   
  800ed9:	f7 f9                	idiv   %ecx
  800edb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef1:	83 c2 30             	add    $0x30,%edx
  800ef4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efe:	f7 e9                	imul   %ecx
  800f00:	c1 fa 02             	sar    $0x2,%edx
  800f03:	89 c8                	mov    %ecx,%eax
  800f05:	c1 f8 1f             	sar    $0x1f,%eax
  800f08:	29 c2                	sub    %eax,%edx
  800f0a:	89 d0                	mov    %edx,%eax
  800f0c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f12:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f17:	f7 e9                	imul   %ecx
  800f19:	c1 fa 02             	sar    $0x2,%edx
  800f1c:	89 c8                	mov    %ecx,%eax
  800f1e:	c1 f8 1f             	sar    $0x1f,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	29 c1                	sub    %eax,%ecx
  800f2e:	89 ca                	mov    %ecx,%edx
  800f30:	85 d2                	test   %edx,%edx
  800f32:	75 9c                	jne    800ed0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	48                   	dec    %eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 3d                	je     800f85 <ltostr+0xe2>
		start = 1 ;
  800f48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4f:	eb 34                	jmp    800f85 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 c2                	add    %eax,%edx
  800f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c8                	add    %ecx,%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 c2                	add    %eax,%edx
  800f7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c c4                	jl     800f51 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 54 fa ff ff       	call   8009fd <strlen>
  800fa9:	83 c4 04             	add    $0x4,%esp
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	e8 46 fa ff ff       	call   8009fd <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcb:	eb 17                	jmp    800fe4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fea:	7c e1                	jl     800fcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffa:	eb 1f                	jmp    80101b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	89 c2                	mov    %eax,%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801018:	ff 45 f8             	incl   -0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801021:	7c d9                	jl     800ffc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
}
  80102e:	90                   	nop
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801054:	eb 0c                	jmp    801062 <strsplit+0x31>
			*string++ = 0;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 08             	mov    %edx,0x8(%ebp)
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	74 18                	je     801083 <strsplit+0x52>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f be c0             	movsbl %al,%eax
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 13 fb ff ff       	call   800b8f <strchr>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 d3                	jne    801056 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 5a                	je     8010e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 f8 0f             	cmp    $0xf,%eax
  801094:	75 07                	jne    80109d <strsplit+0x6c>
		{
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 66                	jmp    801103 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a8:	89 0a                	mov    %ecx,(%edx)
  8010aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bb:	eb 03                	jmp    8010c0 <strsplit+0x8f>
			string++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 8b                	je     801054 <strsplit+0x23>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 b5 fa ff ff       	call   800b8f <strchr>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 dc                	je     8010bd <strsplit+0x8c>
			string++;
	}
  8010e1:	e9 6e ff ff ff       	jmp    801054 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110b:	a1 04 40 80 00       	mov    0x804004,%eax
  801110:	85 c0                	test   %eax,%eax
  801112:	74 1f                	je     801133 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801114:	e8 1d 00 00 00       	call   801136 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 90 37 80 00       	push   $0x803790
  801121:	e8 55 f2 ff ff       	call   80037b <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801129:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801130:	00 00 00 
	}
}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80113c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801143:	00 00 00 
  801146:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80114d:	00 00 00 
  801150:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801157:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80115a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801161:	00 00 00 
  801164:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80116b:	00 00 00 
  80116e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801175:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801178:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80117f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801182:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801187:	2d 00 10 00 00       	sub    $0x1000,%eax
  80118c:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801191:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801198:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80119b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8011a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a5:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8011aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b5:	f7 75 f0             	divl   -0x10(%ebp)
  8011b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011bb:	29 d0                	sub    %edx,%eax
  8011bd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8011c0:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011cf:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011d4:	83 ec 04             	sub    $0x4,%esp
  8011d7:	6a 06                	push   $0x6
  8011d9:	ff 75 e8             	pushl  -0x18(%ebp)
  8011dc:	50                   	push   %eax
  8011dd:	e8 d4 05 00 00       	call   8017b6 <sys_allocate_chunk>
  8011e2:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011e5:	a1 20 41 80 00       	mov    0x804120,%eax
  8011ea:	83 ec 0c             	sub    $0xc,%esp
  8011ed:	50                   	push   %eax
  8011ee:	e8 49 0c 00 00       	call   801e3c <initialize_MemBlocksList>
  8011f3:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8011f6:	a1 48 41 80 00       	mov    0x804148,%eax
  8011fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8011fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801202:	75 14                	jne    801218 <initialize_dyn_block_system+0xe2>
  801204:	83 ec 04             	sub    $0x4,%esp
  801207:	68 b5 37 80 00       	push   $0x8037b5
  80120c:	6a 39                	push   $0x39
  80120e:	68 d3 37 80 00       	push   $0x8037d3
  801213:	e8 86 1c 00 00       	call   802e9e <_panic>
  801218:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121b:	8b 00                	mov    (%eax),%eax
  80121d:	85 c0                	test   %eax,%eax
  80121f:	74 10                	je     801231 <initialize_dyn_block_system+0xfb>
  801221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801224:	8b 00                	mov    (%eax),%eax
  801226:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801229:	8b 52 04             	mov    0x4(%edx),%edx
  80122c:	89 50 04             	mov    %edx,0x4(%eax)
  80122f:	eb 0b                	jmp    80123c <initialize_dyn_block_system+0x106>
  801231:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801234:	8b 40 04             	mov    0x4(%eax),%eax
  801237:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80123c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80123f:	8b 40 04             	mov    0x4(%eax),%eax
  801242:	85 c0                	test   %eax,%eax
  801244:	74 0f                	je     801255 <initialize_dyn_block_system+0x11f>
  801246:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801249:	8b 40 04             	mov    0x4(%eax),%eax
  80124c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80124f:	8b 12                	mov    (%edx),%edx
  801251:	89 10                	mov    %edx,(%eax)
  801253:	eb 0a                	jmp    80125f <initialize_dyn_block_system+0x129>
  801255:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	a3 48 41 80 00       	mov    %eax,0x804148
  80125f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801262:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801268:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801272:	a1 54 41 80 00       	mov    0x804154,%eax
  801277:	48                   	dec    %eax
  801278:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80127d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801280:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801287:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801291:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801295:	75 14                	jne    8012ab <initialize_dyn_block_system+0x175>
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	68 e0 37 80 00       	push   $0x8037e0
  80129f:	6a 3f                	push   $0x3f
  8012a1:	68 d3 37 80 00       	push   $0x8037d3
  8012a6:	e8 f3 1b 00 00       	call   802e9e <_panic>
  8012ab:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8012b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b4:	89 10                	mov    %edx,(%eax)
  8012b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b9:	8b 00                	mov    (%eax),%eax
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	74 0d                	je     8012cc <initialize_dyn_block_system+0x196>
  8012bf:	a1 38 41 80 00       	mov    0x804138,%eax
  8012c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012c7:	89 50 04             	mov    %edx,0x4(%eax)
  8012ca:	eb 08                	jmp    8012d4 <initialize_dyn_block_system+0x19e>
  8012cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012cf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8012dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8012eb:	40                   	inc    %eax
  8012ec:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8012f1:	90                   	nop
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012fa:	e8 06 fe ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801303:	75 07                	jne    80130c <malloc+0x18>
  801305:	b8 00 00 00 00       	mov    $0x0,%eax
  80130a:	eb 7d                	jmp    801389 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80130c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801313:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80131a:	8b 55 08             	mov    0x8(%ebp),%edx
  80131d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801320:	01 d0                	add    %edx,%eax
  801322:	48                   	dec    %eax
  801323:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801329:	ba 00 00 00 00       	mov    $0x0,%edx
  80132e:	f7 75 f0             	divl   -0x10(%ebp)
  801331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801334:	29 d0                	sub    %edx,%eax
  801336:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801339:	e8 46 08 00 00       	call   801b84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80133e:	83 f8 01             	cmp    $0x1,%eax
  801341:	75 07                	jne    80134a <malloc+0x56>
  801343:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  80134a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80134e:	75 34                	jne    801384 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801350:	83 ec 0c             	sub    $0xc,%esp
  801353:	ff 75 e8             	pushl  -0x18(%ebp)
  801356:	e8 73 0e 00 00       	call   8021ce <alloc_block_FF>
  80135b:	83 c4 10             	add    $0x10,%esp
  80135e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801365:	74 16                	je     80137d <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80136d:	e8 ff 0b 00 00       	call   801f71 <insert_sorted_allocList>
  801372:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801375:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801378:	8b 40 08             	mov    0x8(%eax),%eax
  80137b:	eb 0c                	jmp    801389 <malloc+0x95>
	             }
	             else
	             	return NULL;
  80137d:	b8 00 00 00 00       	mov    $0x0,%eax
  801382:	eb 05                	jmp    801389 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8013a8:	83 ec 08             	sub    $0x8,%esp
  8013ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ae:	68 40 40 80 00       	push   $0x804040
  8013b3:	e8 61 0b 00 00       	call   801f19 <find_block>
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8013be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013c2:	0f 84 a5 00 00 00    	je     80146d <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8013c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	50                   	push   %eax
  8013d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d5:	e8 a4 03 00 00       	call   80177e <sys_free_user_mem>
  8013da:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8013dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013e1:	75 17                	jne    8013fa <free+0x6f>
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	68 b5 37 80 00       	push   $0x8037b5
  8013eb:	68 87 00 00 00       	push   $0x87
  8013f0:	68 d3 37 80 00       	push   $0x8037d3
  8013f5:	e8 a4 1a 00 00       	call   802e9e <_panic>
  8013fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013fd:	8b 00                	mov    (%eax),%eax
  8013ff:	85 c0                	test   %eax,%eax
  801401:	74 10                	je     801413 <free+0x88>
  801403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801406:	8b 00                	mov    (%eax),%eax
  801408:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80140b:	8b 52 04             	mov    0x4(%edx),%edx
  80140e:	89 50 04             	mov    %edx,0x4(%eax)
  801411:	eb 0b                	jmp    80141e <free+0x93>
  801413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801416:	8b 40 04             	mov    0x4(%eax),%eax
  801419:	a3 44 40 80 00       	mov    %eax,0x804044
  80141e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801421:	8b 40 04             	mov    0x4(%eax),%eax
  801424:	85 c0                	test   %eax,%eax
  801426:	74 0f                	je     801437 <free+0xac>
  801428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80142b:	8b 40 04             	mov    0x4(%eax),%eax
  80142e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801431:	8b 12                	mov    (%edx),%edx
  801433:	89 10                	mov    %edx,(%eax)
  801435:	eb 0a                	jmp    801441 <free+0xb6>
  801437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143a:	8b 00                	mov    (%eax),%eax
  80143c:	a3 40 40 80 00       	mov    %eax,0x804040
  801441:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801444:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80144a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80144d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801454:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801459:	48                   	dec    %eax
  80145a:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80145f:	83 ec 0c             	sub    $0xc,%esp
  801462:	ff 75 ec             	pushl  -0x14(%ebp)
  801465:	e8 37 12 00 00       	call   8026a1 <insert_sorted_with_merge_freeList>
  80146a:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80146d:	90                   	nop
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 38             	sub    $0x38,%esp
  801476:	8b 45 10             	mov    0x10(%ebp),%eax
  801479:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80147c:	e8 84 fc ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  801481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801485:	75 07                	jne    80148e <smalloc+0x1e>
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
  80148c:	eb 7e                	jmp    80150c <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80148e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801495:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80149c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a2:	01 d0                	add    %edx,%eax
  8014a4:	48                   	dec    %eax
  8014a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b0:	f7 75 f0             	divl   -0x10(%ebp)
  8014b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014b6:	29 d0                	sub    %edx,%eax
  8014b8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8014bb:	e8 c4 06 00 00       	call   801b84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014c0:	83 f8 01             	cmp    $0x1,%eax
  8014c3:	75 42                	jne    801507 <smalloc+0x97>

		  va = malloc(newsize) ;
  8014c5:	83 ec 0c             	sub    $0xc,%esp
  8014c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8014cb:	e8 24 fe ff ff       	call   8012f4 <malloc>
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8014d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014da:	74 24                	je     801500 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8014dc:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014e3:	50                   	push   %eax
  8014e4:	ff 75 e8             	pushl  -0x18(%ebp)
  8014e7:	ff 75 08             	pushl  0x8(%ebp)
  8014ea:	e8 1a 04 00 00       	call   801909 <sys_createSharedObject>
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8014f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014f9:	78 0c                	js     801507 <smalloc+0x97>
					  return va ;
  8014fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014fe:	eb 0c                	jmp    80150c <smalloc+0x9c>
				 }
				 else
					return NULL;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
  801505:	eb 05                	jmp    80150c <smalloc+0x9c>
	  }
		  return NULL ;
  801507:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801514:	e8 ec fb ff ff       	call   801105 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801519:	83 ec 08             	sub    $0x8,%esp
  80151c:	ff 75 0c             	pushl  0xc(%ebp)
  80151f:	ff 75 08             	pushl  0x8(%ebp)
  801522:	e8 0c 04 00 00       	call   801933 <sys_getSizeOfSharedObject>
  801527:	83 c4 10             	add    $0x10,%esp
  80152a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80152d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801531:	75 07                	jne    80153a <sget+0x2c>
  801533:	b8 00 00 00 00       	mov    $0x0,%eax
  801538:	eb 75                	jmp    8015af <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80153a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	48                   	dec    %eax
  80154a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80154d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801550:	ba 00 00 00 00       	mov    $0x0,%edx
  801555:	f7 75 f0             	divl   -0x10(%ebp)
  801558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155b:	29 d0                	sub    %edx,%eax
  80155d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801560:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801567:	e8 18 06 00 00       	call   801b84 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80156c:	83 f8 01             	cmp    $0x1,%eax
  80156f:	75 39                	jne    8015aa <sget+0x9c>

		  va = malloc(newsize) ;
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	ff 75 e8             	pushl  -0x18(%ebp)
  801577:	e8 78 fd ff ff       	call   8012f4 <malloc>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801582:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801586:	74 22                	je     8015aa <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801588:	83 ec 04             	sub    $0x4,%esp
  80158b:	ff 75 e0             	pushl  -0x20(%ebp)
  80158e:	ff 75 0c             	pushl  0xc(%ebp)
  801591:	ff 75 08             	pushl  0x8(%ebp)
  801594:	e8 b7 03 00 00       	call   801950 <sys_getSharedObject>
  801599:	83 c4 10             	add    $0x10,%esp
  80159c:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80159f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015a3:	78 05                	js     8015aa <sget+0x9c>
					  return va;
  8015a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a8:	eb 05                	jmp    8015af <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b7:	e8 49 fb ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	68 04 38 80 00       	push   $0x803804
  8015c4:	68 1e 01 00 00       	push   $0x11e
  8015c9:	68 d3 37 80 00       	push   $0x8037d3
  8015ce:	e8 cb 18 00 00       	call   802e9e <_panic>

008015d3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015d9:	83 ec 04             	sub    $0x4,%esp
  8015dc:	68 2c 38 80 00       	push   $0x80382c
  8015e1:	68 32 01 00 00       	push   $0x132
  8015e6:	68 d3 37 80 00       	push   $0x8037d3
  8015eb:	e8 ae 18 00 00       	call   802e9e <_panic>

008015f0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f6:	83 ec 04             	sub    $0x4,%esp
  8015f9:	68 50 38 80 00       	push   $0x803850
  8015fe:	68 3d 01 00 00       	push   $0x13d
  801603:	68 d3 37 80 00       	push   $0x8037d3
  801608:	e8 91 18 00 00       	call   802e9e <_panic>

0080160d <shrink>:

}
void shrink(uint32 newSize)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801613:	83 ec 04             	sub    $0x4,%esp
  801616:	68 50 38 80 00       	push   $0x803850
  80161b:	68 42 01 00 00       	push   $0x142
  801620:	68 d3 37 80 00       	push   $0x8037d3
  801625:	e8 74 18 00 00       	call   802e9e <_panic>

0080162a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801630:	83 ec 04             	sub    $0x4,%esp
  801633:	68 50 38 80 00       	push   $0x803850
  801638:	68 47 01 00 00       	push   $0x147
  80163d:	68 d3 37 80 00       	push   $0x8037d3
  801642:	e8 57 18 00 00       	call   802e9e <_panic>

00801647 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	57                   	push   %edi
  80164b:	56                   	push   %esi
  80164c:	53                   	push   %ebx
  80164d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	8b 55 0c             	mov    0xc(%ebp),%edx
  801656:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801659:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80165c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80165f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801662:	cd 30                	int    $0x30
  801664:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801667:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80166a:	83 c4 10             	add    $0x10,%esp
  80166d:	5b                   	pop    %ebx
  80166e:	5e                   	pop    %esi
  80166f:	5f                   	pop    %edi
  801670:	5d                   	pop    %ebp
  801671:	c3                   	ret    

00801672 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	83 ec 04             	sub    $0x4,%esp
  801678:	8b 45 10             	mov    0x10(%ebp),%eax
  80167b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80167e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	52                   	push   %edx
  80168a:	ff 75 0c             	pushl  0xc(%ebp)
  80168d:	50                   	push   %eax
  80168e:	6a 00                	push   $0x0
  801690:	e8 b2 ff ff ff       	call   801647 <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	90                   	nop
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_cgetc>:

int
sys_cgetc(void)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 01                	push   $0x1
  8016aa:	e8 98 ff ff ff       	call   801647 <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	52                   	push   %edx
  8016c4:	50                   	push   %eax
  8016c5:	6a 05                	push   $0x5
  8016c7:	e8 7b ff ff ff       	call   801647 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	56                   	push   %esi
  8016d5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8016d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	56                   	push   %esi
  8016e6:	53                   	push   %ebx
  8016e7:	51                   	push   %ecx
  8016e8:	52                   	push   %edx
  8016e9:	50                   	push   %eax
  8016ea:	6a 06                	push   $0x6
  8016ec:	e8 56 ff ff ff       	call   801647 <syscall>
  8016f1:	83 c4 18             	add    $0x18,%esp
}
  8016f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f7:	5b                   	pop    %ebx
  8016f8:	5e                   	pop    %esi
  8016f9:	5d                   	pop    %ebp
  8016fa:	c3                   	ret    

008016fb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	52                   	push   %edx
  80170b:	50                   	push   %eax
  80170c:	6a 07                	push   $0x7
  80170e:	e8 34 ff ff ff       	call   801647 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	ff 75 08             	pushl  0x8(%ebp)
  801727:	6a 08                	push   $0x8
  801729:	e8 19 ff ff ff       	call   801647 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 09                	push   $0x9
  801742:	e8 00 ff ff ff       	call   801647 <syscall>
  801747:	83 c4 18             	add    $0x18,%esp
}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 0a                	push   $0xa
  80175b:	e8 e7 fe ff ff       	call   801647 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 0b                	push   $0xb
  801774:	e8 ce fe ff ff       	call   801647 <syscall>
  801779:	83 c4 18             	add    $0x18,%esp
}
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	ff 75 0c             	pushl  0xc(%ebp)
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	6a 0f                	push   $0xf
  80178f:	e8 b3 fe ff ff       	call   801647 <syscall>
  801794:	83 c4 18             	add    $0x18,%esp
	return;
  801797:	90                   	nop
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	ff 75 0c             	pushl  0xc(%ebp)
  8017a6:	ff 75 08             	pushl  0x8(%ebp)
  8017a9:	6a 10                	push   $0x10
  8017ab:	e8 97 fe ff ff       	call   801647 <syscall>
  8017b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b3:	90                   	nop
}
  8017b4:	c9                   	leave  
  8017b5:	c3                   	ret    

008017b6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	ff 75 10             	pushl  0x10(%ebp)
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	ff 75 08             	pushl  0x8(%ebp)
  8017c6:	6a 11                	push   $0x11
  8017c8:	e8 7a fe ff ff       	call   801647 <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d0:	90                   	nop
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 0c                	push   $0xc
  8017e2:	e8 60 fe ff ff       	call   801647 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	c9                   	leave  
  8017eb:	c3                   	ret    

008017ec <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	ff 75 08             	pushl  0x8(%ebp)
  8017fa:	6a 0d                	push   $0xd
  8017fc:	e8 46 fe ff ff       	call   801647 <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 0e                	push   $0xe
  801815:	e8 2d fe ff ff       	call   801647 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	90                   	nop
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 13                	push   $0x13
  80182f:	e8 13 fe ff ff       	call   801647 <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	90                   	nop
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 14                	push   $0x14
  801849:	e8 f9 fd ff ff       	call   801647 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	90                   	nop
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_cputc>:


void
sys_cputc(const char c)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 04             	sub    $0x4,%esp
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801860:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	50                   	push   %eax
  80186d:	6a 15                	push   $0x15
  80186f:	e8 d3 fd ff ff       	call   801647 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	90                   	nop
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 16                	push   $0x16
  801889:	e8 b9 fd ff ff       	call   801647 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	90                   	nop
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	50                   	push   %eax
  8018a4:	6a 17                	push   $0x17
  8018a6:	e8 9c fd ff ff       	call   801647 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	52                   	push   %edx
  8018c0:	50                   	push   %eax
  8018c1:	6a 1a                	push   $0x1a
  8018c3:	e8 7f fd ff ff       	call   801647 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	6a 18                	push   $0x18
  8018e0:	e8 62 fd ff ff       	call   801647 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	90                   	nop
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	52                   	push   %edx
  8018fb:	50                   	push   %eax
  8018fc:	6a 19                	push   $0x19
  8018fe:	e8 44 fd ff ff       	call   801647 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	90                   	nop
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 04             	sub    $0x4,%esp
  80190f:	8b 45 10             	mov    0x10(%ebp),%eax
  801912:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801915:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801918:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	6a 00                	push   $0x0
  801921:	51                   	push   %ecx
  801922:	52                   	push   %edx
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	50                   	push   %eax
  801927:	6a 1b                	push   $0x1b
  801929:	e8 19 fd ff ff       	call   801647 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801936:	8b 55 0c             	mov    0xc(%ebp),%edx
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	52                   	push   %edx
  801943:	50                   	push   %eax
  801944:	6a 1c                	push   $0x1c
  801946:	e8 fc fc ff ff       	call   801647 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801953:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	51                   	push   %ecx
  801961:	52                   	push   %edx
  801962:	50                   	push   %eax
  801963:	6a 1d                	push   $0x1d
  801965:	e8 dd fc ff ff       	call   801647 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801972:	8b 55 0c             	mov    0xc(%ebp),%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	52                   	push   %edx
  80197f:	50                   	push   %eax
  801980:	6a 1e                	push   $0x1e
  801982:	e8 c0 fc ff ff       	call   801647 <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 1f                	push   $0x1f
  80199b:	e8 a7 fc ff ff       	call   801647 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	ff 75 14             	pushl  0x14(%ebp)
  8019b0:	ff 75 10             	pushl  0x10(%ebp)
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	50                   	push   %eax
  8019b7:	6a 20                	push   $0x20
  8019b9:	e8 89 fc ff ff       	call   801647 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	50                   	push   %eax
  8019d2:	6a 21                	push   $0x21
  8019d4:	e8 6e fc ff ff       	call   801647 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	90                   	nop
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	50                   	push   %eax
  8019ee:	6a 22                	push   $0x22
  8019f0:	e8 52 fc ff ff       	call   801647 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 02                	push   $0x2
  801a09:	e8 39 fc ff ff       	call   801647 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 03                	push   $0x3
  801a22:	e8 20 fc ff ff       	call   801647 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 04                	push   $0x4
  801a3b:	e8 07 fc ff ff       	call   801647 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_exit_env>:


void sys_exit_env(void)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 23                	push   $0x23
  801a54:	e8 ee fb ff ff       	call   801647 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	90                   	nop
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a68:	8d 50 04             	lea    0x4(%eax),%edx
  801a6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	52                   	push   %edx
  801a75:	50                   	push   %eax
  801a76:	6a 24                	push   $0x24
  801a78:	e8 ca fb ff ff       	call   801647 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
	return result;
  801a80:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a89:	89 01                	mov    %eax,(%ecx)
  801a8b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	c9                   	leave  
  801a92:	c2 04 00             	ret    $0x4

00801a95 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	ff 75 10             	pushl  0x10(%ebp)
  801a9f:	ff 75 0c             	pushl  0xc(%ebp)
  801aa2:	ff 75 08             	pushl  0x8(%ebp)
  801aa5:	6a 12                	push   $0x12
  801aa7:	e8 9b fb ff ff       	call   801647 <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
	return ;
  801aaf:	90                   	nop
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 25                	push   $0x25
  801ac1:	e8 81 fb ff ff       	call   801647 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
  801ace:	83 ec 04             	sub    $0x4,%esp
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ad7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	50                   	push   %eax
  801ae4:	6a 26                	push   $0x26
  801ae6:	e8 5c fb ff ff       	call   801647 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
	return ;
  801aee:	90                   	nop
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <rsttst>:
void rsttst()
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 28                	push   $0x28
  801b00:	e8 42 fb ff ff       	call   801647 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
	return ;
  801b08:	90                   	nop
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	8b 45 14             	mov    0x14(%ebp),%eax
  801b14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b17:	8b 55 18             	mov    0x18(%ebp),%edx
  801b1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b1e:	52                   	push   %edx
  801b1f:	50                   	push   %eax
  801b20:	ff 75 10             	pushl  0x10(%ebp)
  801b23:	ff 75 0c             	pushl  0xc(%ebp)
  801b26:	ff 75 08             	pushl  0x8(%ebp)
  801b29:	6a 27                	push   $0x27
  801b2b:	e8 17 fb ff ff       	call   801647 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
	return ;
  801b33:	90                   	nop
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <chktst>:
void chktst(uint32 n)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	ff 75 08             	pushl  0x8(%ebp)
  801b44:	6a 29                	push   $0x29
  801b46:	e8 fc fa ff ff       	call   801647 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4e:	90                   	nop
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <inctst>:

void inctst()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 2a                	push   $0x2a
  801b60:	e8 e2 fa ff ff       	call   801647 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
	return ;
  801b68:	90                   	nop
}
  801b69:	c9                   	leave  
  801b6a:	c3                   	ret    

00801b6b <gettst>:
uint32 gettst()
{
  801b6b:	55                   	push   %ebp
  801b6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 2b                	push   $0x2b
  801b7a:	e8 c8 fa ff ff       	call   801647 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 2c                	push   $0x2c
  801b96:	e8 ac fa ff ff       	call   801647 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
  801b9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ba1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ba5:	75 07                	jne    801bae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ba7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bac:	eb 05                	jmp    801bb3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 2c                	push   $0x2c
  801bc7:	e8 7b fa ff ff       	call   801647 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
  801bcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bd2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bd6:	75 07                	jne    801bdf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdd:	eb 05                	jmp    801be4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 2c                	push   $0x2c
  801bf8:	e8 4a fa ff ff       	call   801647 <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
  801c00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c03:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c07:	75 07                	jne    801c10 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c09:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0e:	eb 05                	jmp    801c15 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 2c                	push   $0x2c
  801c29:	e8 19 fa ff ff       	call   801647 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
  801c31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c34:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c38:	75 07                	jne    801c41 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3f:	eb 05                	jmp    801c46 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	ff 75 08             	pushl  0x8(%ebp)
  801c56:	6a 2d                	push   $0x2d
  801c58:	e8 ea f9 ff ff       	call   801647 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c60:	90                   	nop
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c67:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	53                   	push   %ebx
  801c76:	51                   	push   %ecx
  801c77:	52                   	push   %edx
  801c78:	50                   	push   %eax
  801c79:	6a 2e                	push   $0x2e
  801c7b:	e8 c7 f9 ff ff       	call   801647 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	52                   	push   %edx
  801c98:	50                   	push   %eax
  801c99:	6a 2f                	push   $0x2f
  801c9b:	e8 a7 f9 ff ff       	call   801647 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cab:	83 ec 0c             	sub    $0xc,%esp
  801cae:	68 60 38 80 00       	push   $0x803860
  801cb3:	e8 c3 e6 ff ff       	call   80037b <cprintf>
  801cb8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cbb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cc2:	83 ec 0c             	sub    $0xc,%esp
  801cc5:	68 8c 38 80 00       	push   $0x80388c
  801cca:	e8 ac e6 ff ff       	call   80037b <cprintf>
  801ccf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cd2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd6:	a1 38 41 80 00       	mov    0x804138,%eax
  801cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cde:	eb 56                	jmp    801d36 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ce0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ce4:	74 1c                	je     801d02 <print_mem_block_lists+0x5d>
  801ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce9:	8b 50 08             	mov    0x8(%eax),%edx
  801cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cef:	8b 48 08             	mov    0x8(%eax),%ecx
  801cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf8:	01 c8                	add    %ecx,%eax
  801cfa:	39 c2                	cmp    %eax,%edx
  801cfc:	73 04                	jae    801d02 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cfe:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d05:	8b 50 08             	mov    0x8(%eax),%edx
  801d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0e:	01 c2                	add    %eax,%edx
  801d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d13:	8b 40 08             	mov    0x8(%eax),%eax
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	52                   	push   %edx
  801d1a:	50                   	push   %eax
  801d1b:	68 a1 38 80 00       	push   $0x8038a1
  801d20:	e8 56 e6 ff ff       	call   80037b <cprintf>
  801d25:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d2e:	a1 40 41 80 00       	mov    0x804140,%eax
  801d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d3a:	74 07                	je     801d43 <print_mem_block_lists+0x9e>
  801d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3f:	8b 00                	mov    (%eax),%eax
  801d41:	eb 05                	jmp    801d48 <print_mem_block_lists+0xa3>
  801d43:	b8 00 00 00 00       	mov    $0x0,%eax
  801d48:	a3 40 41 80 00       	mov    %eax,0x804140
  801d4d:	a1 40 41 80 00       	mov    0x804140,%eax
  801d52:	85 c0                	test   %eax,%eax
  801d54:	75 8a                	jne    801ce0 <print_mem_block_lists+0x3b>
  801d56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5a:	75 84                	jne    801ce0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d5c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d60:	75 10                	jne    801d72 <print_mem_block_lists+0xcd>
  801d62:	83 ec 0c             	sub    $0xc,%esp
  801d65:	68 b0 38 80 00       	push   $0x8038b0
  801d6a:	e8 0c e6 ff ff       	call   80037b <cprintf>
  801d6f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d79:	83 ec 0c             	sub    $0xc,%esp
  801d7c:	68 d4 38 80 00       	push   $0x8038d4
  801d81:	e8 f5 e5 ff ff       	call   80037b <cprintf>
  801d86:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d89:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d8d:	a1 40 40 80 00       	mov    0x804040,%eax
  801d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d95:	eb 56                	jmp    801ded <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d9b:	74 1c                	je     801db9 <print_mem_block_lists+0x114>
  801d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da0:	8b 50 08             	mov    0x8(%eax),%edx
  801da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da6:	8b 48 08             	mov    0x8(%eax),%ecx
  801da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dac:	8b 40 0c             	mov    0xc(%eax),%eax
  801daf:	01 c8                	add    %ecx,%eax
  801db1:	39 c2                	cmp    %eax,%edx
  801db3:	73 04                	jae    801db9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801db5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	8b 50 08             	mov    0x8(%eax),%edx
  801dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc5:	01 c2                	add    %eax,%edx
  801dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dca:	8b 40 08             	mov    0x8(%eax),%eax
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	52                   	push   %edx
  801dd1:	50                   	push   %eax
  801dd2:	68 a1 38 80 00       	push   $0x8038a1
  801dd7:	e8 9f e5 ff ff       	call   80037b <cprintf>
  801ddc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801de5:	a1 48 40 80 00       	mov    0x804048,%eax
  801dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df1:	74 07                	je     801dfa <print_mem_block_lists+0x155>
  801df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df6:	8b 00                	mov    (%eax),%eax
  801df8:	eb 05                	jmp    801dff <print_mem_block_lists+0x15a>
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801dff:	a3 48 40 80 00       	mov    %eax,0x804048
  801e04:	a1 48 40 80 00       	mov    0x804048,%eax
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	75 8a                	jne    801d97 <print_mem_block_lists+0xf2>
  801e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e11:	75 84                	jne    801d97 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e13:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e17:	75 10                	jne    801e29 <print_mem_block_lists+0x184>
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	68 ec 38 80 00       	push   $0x8038ec
  801e21:	e8 55 e5 ff ff       	call   80037b <cprintf>
  801e26:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e29:	83 ec 0c             	sub    $0xc,%esp
  801e2c:	68 60 38 80 00       	push   $0x803860
  801e31:	e8 45 e5 ff ff       	call   80037b <cprintf>
  801e36:	83 c4 10             	add    $0x10,%esp

}
  801e39:	90                   	nop
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  801e42:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e49:	00 00 00 
  801e4c:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e53:	00 00 00 
  801e56:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e5d:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  801e60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e67:	e9 9e 00 00 00       	jmp    801f0a <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  801e6c:	a1 50 40 80 00       	mov    0x804050,%eax
  801e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e74:	c1 e2 04             	shl    $0x4,%edx
  801e77:	01 d0                	add    %edx,%eax
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	75 14                	jne    801e91 <initialize_MemBlocksList+0x55>
  801e7d:	83 ec 04             	sub    $0x4,%esp
  801e80:	68 14 39 80 00       	push   $0x803914
  801e85:	6a 47                	push   $0x47
  801e87:	68 37 39 80 00       	push   $0x803937
  801e8c:	e8 0d 10 00 00       	call   802e9e <_panic>
  801e91:	a1 50 40 80 00       	mov    0x804050,%eax
  801e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e99:	c1 e2 04             	shl    $0x4,%edx
  801e9c:	01 d0                	add    %edx,%eax
  801e9e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ea4:	89 10                	mov    %edx,(%eax)
  801ea6:	8b 00                	mov    (%eax),%eax
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	74 18                	je     801ec4 <initialize_MemBlocksList+0x88>
  801eac:	a1 48 41 80 00       	mov    0x804148,%eax
  801eb1:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801eb7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801eba:	c1 e1 04             	shl    $0x4,%ecx
  801ebd:	01 ca                	add    %ecx,%edx
  801ebf:	89 50 04             	mov    %edx,0x4(%eax)
  801ec2:	eb 12                	jmp    801ed6 <initialize_MemBlocksList+0x9a>
  801ec4:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecc:	c1 e2 04             	shl    $0x4,%edx
  801ecf:	01 d0                	add    %edx,%eax
  801ed1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ed6:	a1 50 40 80 00       	mov    0x804050,%eax
  801edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ede:	c1 e2 04             	shl    $0x4,%edx
  801ee1:	01 d0                	add    %edx,%eax
  801ee3:	a3 48 41 80 00       	mov    %eax,0x804148
  801ee8:	a1 50 40 80 00       	mov    0x804050,%eax
  801eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef0:	c1 e2 04             	shl    $0x4,%edx
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801efc:	a1 54 41 80 00       	mov    0x804154,%eax
  801f01:	40                   	inc    %eax
  801f02:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  801f07:	ff 45 f4             	incl   -0xc(%ebp)
  801f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f10:	0f 82 56 ff ff ff    	jb     801e6c <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  801f16:	90                   	nop
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	8b 00                	mov    (%eax),%eax
  801f24:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f27:	eb 19                	jmp    801f42 <find_block+0x29>
	{
		if(element->sva == va){
  801f29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2c:	8b 40 08             	mov    0x8(%eax),%eax
  801f2f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f32:	75 05                	jne    801f39 <find_block+0x20>
			 		return element;
  801f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f37:	eb 36                	jmp    801f6f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	8b 40 08             	mov    0x8(%eax),%eax
  801f3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f46:	74 07                	je     801f4f <find_block+0x36>
  801f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4b:	8b 00                	mov    (%eax),%eax
  801f4d:	eb 05                	jmp    801f54 <find_block+0x3b>
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f54:	8b 55 08             	mov    0x8(%ebp),%edx
  801f57:	89 42 08             	mov    %eax,0x8(%edx)
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	8b 40 08             	mov    0x8(%eax),%eax
  801f60:	85 c0                	test   %eax,%eax
  801f62:	75 c5                	jne    801f29 <find_block+0x10>
  801f64:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f68:	75 bf                	jne    801f29 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  801f77:	a1 44 40 80 00       	mov    0x804044,%eax
  801f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  801f7f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f84:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  801f87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f8b:	74 0a                	je     801f97 <insert_sorted_allocList+0x26>
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	8b 40 08             	mov    0x8(%eax),%eax
  801f93:	85 c0                	test   %eax,%eax
  801f95:	75 65                	jne    801ffc <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  801f97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f9b:	75 14                	jne    801fb1 <insert_sorted_allocList+0x40>
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	68 14 39 80 00       	push   $0x803914
  801fa5:	6a 6e                	push   $0x6e
  801fa7:	68 37 39 80 00       	push   $0x803937
  801fac:	e8 ed 0e 00 00       	call   802e9e <_panic>
  801fb1:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	89 10                	mov    %edx,(%eax)
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	8b 00                	mov    (%eax),%eax
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	74 0d                	je     801fd2 <insert_sorted_allocList+0x61>
  801fc5:	a1 40 40 80 00       	mov    0x804040,%eax
  801fca:	8b 55 08             	mov    0x8(%ebp),%edx
  801fcd:	89 50 04             	mov    %edx,0x4(%eax)
  801fd0:	eb 08                	jmp    801fda <insert_sorted_allocList+0x69>
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	a3 44 40 80 00       	mov    %eax,0x804044
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	a3 40 40 80 00       	mov    %eax,0x804040
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ff1:	40                   	inc    %eax
  801ff2:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801ff7:	e9 cf 01 00 00       	jmp    8021cb <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  801ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fff:	8b 50 08             	mov    0x8(%eax),%edx
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	8b 40 08             	mov    0x8(%eax),%eax
  802008:	39 c2                	cmp    %eax,%edx
  80200a:	73 65                	jae    802071 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80200c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802010:	75 14                	jne    802026 <insert_sorted_allocList+0xb5>
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	68 50 39 80 00       	push   $0x803950
  80201a:	6a 72                	push   $0x72
  80201c:	68 37 39 80 00       	push   $0x803937
  802021:	e8 78 0e 00 00       	call   802e9e <_panic>
  802026:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	89 50 04             	mov    %edx,0x4(%eax)
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	8b 40 04             	mov    0x4(%eax),%eax
  802038:	85 c0                	test   %eax,%eax
  80203a:	74 0c                	je     802048 <insert_sorted_allocList+0xd7>
  80203c:	a1 44 40 80 00       	mov    0x804044,%eax
  802041:	8b 55 08             	mov    0x8(%ebp),%edx
  802044:	89 10                	mov    %edx,(%eax)
  802046:	eb 08                	jmp    802050 <insert_sorted_allocList+0xdf>
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	a3 40 40 80 00       	mov    %eax,0x804040
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	a3 44 40 80 00       	mov    %eax,0x804044
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802061:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802066:	40                   	inc    %eax
  802067:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80206c:	e9 5a 01 00 00       	jmp    8021cb <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802071:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802074:	8b 50 08             	mov    0x8(%eax),%edx
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	8b 40 08             	mov    0x8(%eax),%eax
  80207d:	39 c2                	cmp    %eax,%edx
  80207f:	75 70                	jne    8020f1 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802081:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802085:	74 06                	je     80208d <insert_sorted_allocList+0x11c>
  802087:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80208b:	75 14                	jne    8020a1 <insert_sorted_allocList+0x130>
  80208d:	83 ec 04             	sub    $0x4,%esp
  802090:	68 74 39 80 00       	push   $0x803974
  802095:	6a 75                	push   $0x75
  802097:	68 37 39 80 00       	push   $0x803937
  80209c:	e8 fd 0d 00 00       	call   802e9e <_panic>
  8020a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a4:	8b 10                	mov    (%eax),%edx
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	89 10                	mov    %edx,(%eax)
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	8b 00                	mov    (%eax),%eax
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	74 0b                	je     8020bf <insert_sorted_allocList+0x14e>
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	8b 00                	mov    (%eax),%eax
  8020b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bc:	89 50 04             	mov    %edx,0x4(%eax)
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c5:	89 10                	mov    %edx,(%eax)
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020cd:	89 50 04             	mov    %edx,0x4(%eax)
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	8b 00                	mov    (%eax),%eax
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	75 08                	jne    8020e1 <insert_sorted_allocList+0x170>
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	a3 44 40 80 00       	mov    %eax,0x804044
  8020e1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020e6:	40                   	inc    %eax
  8020e7:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8020ec:	e9 da 00 00 00       	jmp    8021cb <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8020f1:	a1 40 40 80 00       	mov    0x804040,%eax
  8020f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f9:	e9 9d 00 00 00       	jmp    80219b <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8020fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802101:	8b 00                	mov    (%eax),%eax
  802103:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	8b 50 08             	mov    0x8(%eax),%edx
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	8b 40 08             	mov    0x8(%eax),%eax
  802112:	39 c2                	cmp    %eax,%edx
  802114:	76 7d                	jbe    802193 <insert_sorted_allocList+0x222>
  802116:	8b 45 08             	mov    0x8(%ebp),%eax
  802119:	8b 50 08             	mov    0x8(%eax),%edx
  80211c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80211f:	8b 40 08             	mov    0x8(%eax),%eax
  802122:	39 c2                	cmp    %eax,%edx
  802124:	73 6d                	jae    802193 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212a:	74 06                	je     802132 <insert_sorted_allocList+0x1c1>
  80212c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802130:	75 14                	jne    802146 <insert_sorted_allocList+0x1d5>
  802132:	83 ec 04             	sub    $0x4,%esp
  802135:	68 74 39 80 00       	push   $0x803974
  80213a:	6a 7c                	push   $0x7c
  80213c:	68 37 39 80 00       	push   $0x803937
  802141:	e8 58 0d 00 00       	call   802e9e <_panic>
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	8b 10                	mov    (%eax),%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	89 10                	mov    %edx,(%eax)
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	8b 00                	mov    (%eax),%eax
  802155:	85 c0                	test   %eax,%eax
  802157:	74 0b                	je     802164 <insert_sorted_allocList+0x1f3>
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	8b 00                	mov    (%eax),%eax
  80215e:	8b 55 08             	mov    0x8(%ebp),%edx
  802161:	89 50 04             	mov    %edx,0x4(%eax)
  802164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802167:	8b 55 08             	mov    0x8(%ebp),%edx
  80216a:	89 10                	mov    %edx,(%eax)
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802172:	89 50 04             	mov    %edx,0x4(%eax)
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	8b 00                	mov    (%eax),%eax
  80217a:	85 c0                	test   %eax,%eax
  80217c:	75 08                	jne    802186 <insert_sorted_allocList+0x215>
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	a3 44 40 80 00       	mov    %eax,0x804044
  802186:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80218b:	40                   	inc    %eax
  80218c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802191:	eb 38                	jmp    8021cb <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802193:	a1 48 40 80 00       	mov    0x804048,%eax
  802198:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219f:	74 07                	je     8021a8 <insert_sorted_allocList+0x237>
  8021a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a4:	8b 00                	mov    (%eax),%eax
  8021a6:	eb 05                	jmp    8021ad <insert_sorted_allocList+0x23c>
  8021a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ad:	a3 48 40 80 00       	mov    %eax,0x804048
  8021b2:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	0f 85 3f ff ff ff    	jne    8020fe <insert_sorted_allocList+0x18d>
  8021bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c3:	0f 85 35 ff ff ff    	jne    8020fe <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8021c9:	eb 00                	jmp    8021cb <insert_sorted_allocList+0x25a>
  8021cb:	90                   	nop
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8021d4:	a1 38 41 80 00       	mov    0x804138,%eax
  8021d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dc:	e9 6b 02 00 00       	jmp    80244c <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ea:	0f 85 90 00 00 00    	jne    802280 <alloc_block_FF+0xb2>
			  temp=element;
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8021f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fa:	75 17                	jne    802213 <alloc_block_FF+0x45>
  8021fc:	83 ec 04             	sub    $0x4,%esp
  8021ff:	68 a8 39 80 00       	push   $0x8039a8
  802204:	68 92 00 00 00       	push   $0x92
  802209:	68 37 39 80 00       	push   $0x803937
  80220e:	e8 8b 0c 00 00       	call   802e9e <_panic>
  802213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802216:	8b 00                	mov    (%eax),%eax
  802218:	85 c0                	test   %eax,%eax
  80221a:	74 10                	je     80222c <alloc_block_FF+0x5e>
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	8b 00                	mov    (%eax),%eax
  802221:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802224:	8b 52 04             	mov    0x4(%edx),%edx
  802227:	89 50 04             	mov    %edx,0x4(%eax)
  80222a:	eb 0b                	jmp    802237 <alloc_block_FF+0x69>
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	8b 40 04             	mov    0x4(%eax),%eax
  802232:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	8b 40 04             	mov    0x4(%eax),%eax
  80223d:	85 c0                	test   %eax,%eax
  80223f:	74 0f                	je     802250 <alloc_block_FF+0x82>
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 40 04             	mov    0x4(%eax),%eax
  802247:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224a:	8b 12                	mov    (%edx),%edx
  80224c:	89 10                	mov    %edx,(%eax)
  80224e:	eb 0a                	jmp    80225a <alloc_block_FF+0x8c>
  802250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802253:	8b 00                	mov    (%eax),%eax
  802255:	a3 38 41 80 00       	mov    %eax,0x804138
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80226d:	a1 44 41 80 00       	mov    0x804144,%eax
  802272:	48                   	dec    %eax
  802273:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227b:	e9 ff 01 00 00       	jmp    80247f <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 40 0c             	mov    0xc(%eax),%eax
  802286:	3b 45 08             	cmp    0x8(%ebp),%eax
  802289:	0f 86 b5 01 00 00    	jbe    802444 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	8b 40 0c             	mov    0xc(%eax),%eax
  802295:	2b 45 08             	sub    0x8(%ebp),%eax
  802298:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80229b:	a1 48 41 80 00       	mov    0x804148,%eax
  8022a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8022a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022a7:	75 17                	jne    8022c0 <alloc_block_FF+0xf2>
  8022a9:	83 ec 04             	sub    $0x4,%esp
  8022ac:	68 a8 39 80 00       	push   $0x8039a8
  8022b1:	68 99 00 00 00       	push   $0x99
  8022b6:	68 37 39 80 00       	push   $0x803937
  8022bb:	e8 de 0b 00 00       	call   802e9e <_panic>
  8022c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c3:	8b 00                	mov    (%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 10                	je     8022d9 <alloc_block_FF+0x10b>
  8022c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cc:	8b 00                	mov    (%eax),%eax
  8022ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022d1:	8b 52 04             	mov    0x4(%edx),%edx
  8022d4:	89 50 04             	mov    %edx,0x4(%eax)
  8022d7:	eb 0b                	jmp    8022e4 <alloc_block_FF+0x116>
  8022d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022dc:	8b 40 04             	mov    0x4(%eax),%eax
  8022df:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	74 0f                	je     8022fd <alloc_block_FF+0x12f>
  8022ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f1:	8b 40 04             	mov    0x4(%eax),%eax
  8022f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022f7:	8b 12                	mov    (%edx),%edx
  8022f9:	89 10                	mov    %edx,(%eax)
  8022fb:	eb 0a                	jmp    802307 <alloc_block_FF+0x139>
  8022fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802300:	8b 00                	mov    (%eax),%eax
  802302:	a3 48 41 80 00       	mov    %eax,0x804148
  802307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802310:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802313:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80231a:	a1 54 41 80 00       	mov    0x804154,%eax
  80231f:	48                   	dec    %eax
  802320:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802325:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802329:	75 17                	jne    802342 <alloc_block_FF+0x174>
  80232b:	83 ec 04             	sub    $0x4,%esp
  80232e:	68 50 39 80 00       	push   $0x803950
  802333:	68 9a 00 00 00       	push   $0x9a
  802338:	68 37 39 80 00       	push   $0x803937
  80233d:	e8 5c 0b 00 00       	call   802e9e <_panic>
  802342:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802348:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234b:	89 50 04             	mov    %edx,0x4(%eax)
  80234e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802351:	8b 40 04             	mov    0x4(%eax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	74 0c                	je     802364 <alloc_block_FF+0x196>
  802358:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80235d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802360:	89 10                	mov    %edx,(%eax)
  802362:	eb 08                	jmp    80236c <alloc_block_FF+0x19e>
  802364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802367:	a3 38 41 80 00       	mov    %eax,0x804138
  80236c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802374:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802377:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237d:	a1 44 41 80 00       	mov    0x804144,%eax
  802382:	40                   	inc    %eax
  802383:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238b:	8b 55 08             	mov    0x8(%ebp),%edx
  80238e:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 50 08             	mov    0x8(%eax),%edx
  802397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239a:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a3:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 50 08             	mov    0x8(%eax),%edx
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	01 c2                	add    %eax,%edx
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8023b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8023bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023c1:	75 17                	jne    8023da <alloc_block_FF+0x20c>
  8023c3:	83 ec 04             	sub    $0x4,%esp
  8023c6:	68 a8 39 80 00       	push   $0x8039a8
  8023cb:	68 a2 00 00 00       	push   $0xa2
  8023d0:	68 37 39 80 00       	push   $0x803937
  8023d5:	e8 c4 0a 00 00       	call   802e9e <_panic>
  8023da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 10                	je     8023f3 <alloc_block_FF+0x225>
  8023e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023eb:	8b 52 04             	mov    0x4(%edx),%edx
  8023ee:	89 50 04             	mov    %edx,0x4(%eax)
  8023f1:	eb 0b                	jmp    8023fe <alloc_block_FF+0x230>
  8023f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f6:	8b 40 04             	mov    0x4(%eax),%eax
  8023f9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802401:	8b 40 04             	mov    0x4(%eax),%eax
  802404:	85 c0                	test   %eax,%eax
  802406:	74 0f                	je     802417 <alloc_block_FF+0x249>
  802408:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240b:	8b 40 04             	mov    0x4(%eax),%eax
  80240e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802411:	8b 12                	mov    (%edx),%edx
  802413:	89 10                	mov    %edx,(%eax)
  802415:	eb 0a                	jmp    802421 <alloc_block_FF+0x253>
  802417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	a3 38 41 80 00       	mov    %eax,0x804138
  802421:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802424:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802434:	a1 44 41 80 00       	mov    0x804144,%eax
  802439:	48                   	dec    %eax
  80243a:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80243f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802442:	eb 3b                	jmp    80247f <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802444:	a1 40 41 80 00       	mov    0x804140,%eax
  802449:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802450:	74 07                	je     802459 <alloc_block_FF+0x28b>
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	eb 05                	jmp    80245e <alloc_block_FF+0x290>
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
  80245e:	a3 40 41 80 00       	mov    %eax,0x804140
  802463:	a1 40 41 80 00       	mov    0x804140,%eax
  802468:	85 c0                	test   %eax,%eax
  80246a:	0f 85 71 fd ff ff    	jne    8021e1 <alloc_block_FF+0x13>
  802470:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802474:	0f 85 67 fd ff ff    	jne    8021e1 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80247a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802487:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80248e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802495:	a1 38 41 80 00       	mov    0x804138,%eax
  80249a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80249d:	e9 d3 00 00 00       	jmp    802575 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8024a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ab:	0f 85 90 00 00 00    	jne    802541 <alloc_block_BF+0xc0>
	   temp = element;
  8024b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8024b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024bb:	75 17                	jne    8024d4 <alloc_block_BF+0x53>
  8024bd:	83 ec 04             	sub    $0x4,%esp
  8024c0:	68 a8 39 80 00       	push   $0x8039a8
  8024c5:	68 bd 00 00 00       	push   $0xbd
  8024ca:	68 37 39 80 00       	push   $0x803937
  8024cf:	e8 ca 09 00 00       	call   802e9e <_panic>
  8024d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d7:	8b 00                	mov    (%eax),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	74 10                	je     8024ed <alloc_block_BF+0x6c>
  8024dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024e5:	8b 52 04             	mov    0x4(%edx),%edx
  8024e8:	89 50 04             	mov    %edx,0x4(%eax)
  8024eb:	eb 0b                	jmp    8024f8 <alloc_block_BF+0x77>
  8024ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f0:	8b 40 04             	mov    0x4(%eax),%eax
  8024f3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	74 0f                	je     802511 <alloc_block_BF+0x90>
  802502:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802505:	8b 40 04             	mov    0x4(%eax),%eax
  802508:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80250b:	8b 12                	mov    (%edx),%edx
  80250d:	89 10                	mov    %edx,(%eax)
  80250f:	eb 0a                	jmp    80251b <alloc_block_BF+0x9a>
  802511:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	a3 38 41 80 00       	mov    %eax,0x804138
  80251b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802524:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802527:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252e:	a1 44 41 80 00       	mov    0x804144,%eax
  802533:	48                   	dec    %eax
  802534:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802539:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80253c:	e9 41 01 00 00       	jmp    802682 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802541:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802544:	8b 40 0c             	mov    0xc(%eax),%eax
  802547:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254a:	76 21                	jbe    80256d <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80254c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80254f:	8b 40 0c             	mov    0xc(%eax),%eax
  802552:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802555:	73 16                	jae    80256d <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802557:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80255a:	8b 40 0c             	mov    0xc(%eax),%eax
  80255d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802560:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802563:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802566:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80256d:	a1 40 41 80 00       	mov    0x804140,%eax
  802572:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802575:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802579:	74 07                	je     802582 <alloc_block_BF+0x101>
  80257b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	eb 05                	jmp    802587 <alloc_block_BF+0x106>
  802582:	b8 00 00 00 00       	mov    $0x0,%eax
  802587:	a3 40 41 80 00       	mov    %eax,0x804140
  80258c:	a1 40 41 80 00       	mov    0x804140,%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	0f 85 09 ff ff ff    	jne    8024a2 <alloc_block_BF+0x21>
  802599:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80259d:	0f 85 ff fe ff ff    	jne    8024a2 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8025a3:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8025a7:	0f 85 d0 00 00 00    	jne    80267d <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8025ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8025b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8025b9:	a1 48 41 80 00       	mov    0x804148,%eax
  8025be:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8025c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025c5:	75 17                	jne    8025de <alloc_block_BF+0x15d>
  8025c7:	83 ec 04             	sub    $0x4,%esp
  8025ca:	68 a8 39 80 00       	push   $0x8039a8
  8025cf:	68 d1 00 00 00       	push   $0xd1
  8025d4:	68 37 39 80 00       	push   $0x803937
  8025d9:	e8 c0 08 00 00       	call   802e9e <_panic>
  8025de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	74 10                	je     8025f7 <alloc_block_BF+0x176>
  8025e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ea:	8b 00                	mov    (%eax),%eax
  8025ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025ef:	8b 52 04             	mov    0x4(%edx),%edx
  8025f2:	89 50 04             	mov    %edx,0x4(%eax)
  8025f5:	eb 0b                	jmp    802602 <alloc_block_BF+0x181>
  8025f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025fa:	8b 40 04             	mov    0x4(%eax),%eax
  8025fd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802602:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802605:	8b 40 04             	mov    0x4(%eax),%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	74 0f                	je     80261b <alloc_block_BF+0x19a>
  80260c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260f:	8b 40 04             	mov    0x4(%eax),%eax
  802612:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802615:	8b 12                	mov    (%edx),%edx
  802617:	89 10                	mov    %edx,(%eax)
  802619:	eb 0a                	jmp    802625 <alloc_block_BF+0x1a4>
  80261b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	a3 48 41 80 00       	mov    %eax,0x804148
  802625:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802628:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802631:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802638:	a1 54 41 80 00       	mov    0x804154,%eax
  80263d:	48                   	dec    %eax
  80263e:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802643:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802646:	8b 55 08             	mov    0x8(%ebp),%edx
  802649:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80264c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264f:	8b 50 08             	mov    0x8(%eax),%edx
  802652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802655:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802658:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80265e:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802664:	8b 50 08             	mov    0x8(%eax),%edx
  802667:	8b 45 08             	mov    0x8(%ebp),%eax
  80266a:	01 c2                	add    %eax,%edx
  80266c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266f:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802672:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802675:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802678:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80267b:	eb 05                	jmp    802682 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802682:	c9                   	leave  
  802683:	c3                   	ret    

00802684 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802684:	55                   	push   %ebp
  802685:	89 e5                	mov    %esp,%ebp
  802687:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80268a:	83 ec 04             	sub    $0x4,%esp
  80268d:	68 c8 39 80 00       	push   $0x8039c8
  802692:	68 e8 00 00 00       	push   $0xe8
  802697:	68 37 39 80 00       	push   $0x803937
  80269c:	e8 fd 07 00 00       	call   802e9e <_panic>

008026a1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8026a1:	55                   	push   %ebp
  8026a2:	89 e5                	mov    %esp,%ebp
  8026a4:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8026a7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8026ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8026af:	a1 38 41 80 00       	mov    0x804138,%eax
  8026b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8026b7:	a1 44 41 80 00       	mov    0x804144,%eax
  8026bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8026bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c3:	75 68                	jne    80272d <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8026c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026c9:	75 17                	jne    8026e2 <insert_sorted_with_merge_freeList+0x41>
  8026cb:	83 ec 04             	sub    $0x4,%esp
  8026ce:	68 14 39 80 00       	push   $0x803914
  8026d3:	68 36 01 00 00       	push   $0x136
  8026d8:	68 37 39 80 00       	push   $0x803937
  8026dd:	e8 bc 07 00 00       	call   802e9e <_panic>
  8026e2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	89 10                	mov    %edx,(%eax)
  8026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f0:	8b 00                	mov    (%eax),%eax
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	74 0d                	je     802703 <insert_sorted_with_merge_freeList+0x62>
  8026f6:	a1 38 41 80 00       	mov    0x804138,%eax
  8026fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8026fe:	89 50 04             	mov    %edx,0x4(%eax)
  802701:	eb 08                	jmp    80270b <insert_sorted_with_merge_freeList+0x6a>
  802703:	8b 45 08             	mov    0x8(%ebp),%eax
  802706:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	a3 38 41 80 00       	mov    %eax,0x804138
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271d:	a1 44 41 80 00       	mov    0x804144,%eax
  802722:	40                   	inc    %eax
  802723:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802728:	e9 ba 06 00 00       	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	8b 50 08             	mov    0x8(%eax),%edx
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	8b 40 0c             	mov    0xc(%eax),%eax
  802739:	01 c2                	add    %eax,%edx
  80273b:	8b 45 08             	mov    0x8(%ebp),%eax
  80273e:	8b 40 08             	mov    0x8(%eax),%eax
  802741:	39 c2                	cmp    %eax,%edx
  802743:	73 68                	jae    8027ad <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802745:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802749:	75 17                	jne    802762 <insert_sorted_with_merge_freeList+0xc1>
  80274b:	83 ec 04             	sub    $0x4,%esp
  80274e:	68 50 39 80 00       	push   $0x803950
  802753:	68 3a 01 00 00       	push   $0x13a
  802758:	68 37 39 80 00       	push   $0x803937
  80275d:	e8 3c 07 00 00       	call   802e9e <_panic>
  802762:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802768:	8b 45 08             	mov    0x8(%ebp),%eax
  80276b:	89 50 04             	mov    %edx,0x4(%eax)
  80276e:	8b 45 08             	mov    0x8(%ebp),%eax
  802771:	8b 40 04             	mov    0x4(%eax),%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	74 0c                	je     802784 <insert_sorted_with_merge_freeList+0xe3>
  802778:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80277d:	8b 55 08             	mov    0x8(%ebp),%edx
  802780:	89 10                	mov    %edx,(%eax)
  802782:	eb 08                	jmp    80278c <insert_sorted_with_merge_freeList+0xeb>
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	a3 38 41 80 00       	mov    %eax,0x804138
  80278c:	8b 45 08             	mov    0x8(%ebp),%eax
  80278f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802794:	8b 45 08             	mov    0x8(%ebp),%eax
  802797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279d:	a1 44 41 80 00       	mov    0x804144,%eax
  8027a2:	40                   	inc    %eax
  8027a3:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8027a8:	e9 3a 06 00 00       	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	8b 50 08             	mov    0x8(%eax),%edx
  8027b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	01 c2                	add    %eax,%edx
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	8b 40 08             	mov    0x8(%eax),%eax
  8027c1:	39 c2                	cmp    %eax,%edx
  8027c3:	0f 85 90 00 00 00    	jne    802859 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d5:	01 c2                	add    %eax,%edx
  8027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027da:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8027dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8027e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8027f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f5:	75 17                	jne    80280e <insert_sorted_with_merge_freeList+0x16d>
  8027f7:	83 ec 04             	sub    $0x4,%esp
  8027fa:	68 14 39 80 00       	push   $0x803914
  8027ff:	68 41 01 00 00       	push   $0x141
  802804:	68 37 39 80 00       	push   $0x803937
  802809:	e8 90 06 00 00       	call   802e9e <_panic>
  80280e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	89 10                	mov    %edx,(%eax)
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	85 c0                	test   %eax,%eax
  802820:	74 0d                	je     80282f <insert_sorted_with_merge_freeList+0x18e>
  802822:	a1 48 41 80 00       	mov    0x804148,%eax
  802827:	8b 55 08             	mov    0x8(%ebp),%edx
  80282a:	89 50 04             	mov    %edx,0x4(%eax)
  80282d:	eb 08                	jmp    802837 <insert_sorted_with_merge_freeList+0x196>
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	a3 48 41 80 00       	mov    %eax,0x804148
  80283f:	8b 45 08             	mov    0x8(%ebp),%eax
  802842:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802849:	a1 54 41 80 00       	mov    0x804154,%eax
  80284e:	40                   	inc    %eax
  80284f:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802854:	e9 8e 05 00 00       	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802859:	8b 45 08             	mov    0x8(%ebp),%eax
  80285c:	8b 50 08             	mov    0x8(%eax),%edx
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	8b 40 0c             	mov    0xc(%eax),%eax
  802865:	01 c2                	add    %eax,%edx
  802867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286a:	8b 40 08             	mov    0x8(%eax),%eax
  80286d:	39 c2                	cmp    %eax,%edx
  80286f:	73 68                	jae    8028d9 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802871:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802875:	75 17                	jne    80288e <insert_sorted_with_merge_freeList+0x1ed>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 14 39 80 00       	push   $0x803914
  80287f:	68 45 01 00 00       	push   $0x145
  802884:	68 37 39 80 00       	push   $0x803937
  802889:	e8 10 06 00 00       	call   802e9e <_panic>
  80288e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	89 10                	mov    %edx,(%eax)
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	8b 00                	mov    (%eax),%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	74 0d                	je     8028af <insert_sorted_with_merge_freeList+0x20e>
  8028a2:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028aa:	89 50 04             	mov    %edx,0x4(%eax)
  8028ad:	eb 08                	jmp    8028b7 <insert_sorted_with_merge_freeList+0x216>
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	a3 38 41 80 00       	mov    %eax,0x804138
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c9:	a1 44 41 80 00       	mov    0x804144,%eax
  8028ce:	40                   	inc    %eax
  8028cf:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8028d4:	e9 0e 05 00 00       	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	8b 50 08             	mov    0x8(%eax),%edx
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e5:	01 c2                	add    %eax,%edx
  8028e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ea:	8b 40 08             	mov    0x8(%eax),%eax
  8028ed:	39 c2                	cmp    %eax,%edx
  8028ef:	0f 85 9c 00 00 00    	jne    802991 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8028f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f8:	8b 50 0c             	mov    0xc(%eax),%edx
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802901:	01 c2                	add    %eax,%edx
  802903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802906:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	8b 50 08             	mov    0x8(%eax),%edx
  80290f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802912:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  80291f:	8b 45 08             	mov    0x8(%ebp),%eax
  802922:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802929:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292d:	75 17                	jne    802946 <insert_sorted_with_merge_freeList+0x2a5>
  80292f:	83 ec 04             	sub    $0x4,%esp
  802932:	68 14 39 80 00       	push   $0x803914
  802937:	68 4d 01 00 00       	push   $0x14d
  80293c:	68 37 39 80 00       	push   $0x803937
  802941:	e8 58 05 00 00       	call   802e9e <_panic>
  802946:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	89 10                	mov    %edx,(%eax)
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 0d                	je     802967 <insert_sorted_with_merge_freeList+0x2c6>
  80295a:	a1 48 41 80 00       	mov    0x804148,%eax
  80295f:	8b 55 08             	mov    0x8(%ebp),%edx
  802962:	89 50 04             	mov    %edx,0x4(%eax)
  802965:	eb 08                	jmp    80296f <insert_sorted_with_merge_freeList+0x2ce>
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	a3 48 41 80 00       	mov    %eax,0x804148
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802981:	a1 54 41 80 00       	mov    0x804154,%eax
  802986:	40                   	inc    %eax
  802987:	a3 54 41 80 00       	mov    %eax,0x804154





}
  80298c:	e9 56 04 00 00       	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802991:	a1 38 41 80 00       	mov    0x804138,%eax
  802996:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802999:	e9 19 04 00 00       	jmp    802db7 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 00                	mov    (%eax),%eax
  8029a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 50 08             	mov    0x8(%eax),%edx
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b2:	01 c2                	add    %eax,%edx
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ba:	39 c2                	cmp    %eax,%edx
  8029bc:	0f 85 ad 01 00 00    	jne    802b6f <insert_sorted_with_merge_freeList+0x4ce>
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	8b 50 08             	mov    0x8(%eax),%edx
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ce:	01 c2                	add    %eax,%edx
  8029d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d3:	8b 40 08             	mov    0x8(%eax),%eax
  8029d6:	39 c2                	cmp    %eax,%edx
  8029d8:	0f 85 91 01 00 00    	jne    802b6f <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	8b 50 0c             	mov    0xc(%eax),%edx
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	01 c8                	add    %ecx,%eax
  8029f2:	01 c2                	add    %eax,%edx
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802a0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802a22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a26:	75 17                	jne    802a3f <insert_sorted_with_merge_freeList+0x39e>
  802a28:	83 ec 04             	sub    $0x4,%esp
  802a2b:	68 a8 39 80 00       	push   $0x8039a8
  802a30:	68 5b 01 00 00       	push   $0x15b
  802a35:	68 37 39 80 00       	push   $0x803937
  802a3a:	e8 5f 04 00 00       	call   802e9e <_panic>
  802a3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a42:	8b 00                	mov    (%eax),%eax
  802a44:	85 c0                	test   %eax,%eax
  802a46:	74 10                	je     802a58 <insert_sorted_with_merge_freeList+0x3b7>
  802a48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a50:	8b 52 04             	mov    0x4(%edx),%edx
  802a53:	89 50 04             	mov    %edx,0x4(%eax)
  802a56:	eb 0b                	jmp    802a63 <insert_sorted_with_merge_freeList+0x3c2>
  802a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5b:	8b 40 04             	mov    0x4(%eax),%eax
  802a5e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a66:	8b 40 04             	mov    0x4(%eax),%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	74 0f                	je     802a7c <insert_sorted_with_merge_freeList+0x3db>
  802a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a70:	8b 40 04             	mov    0x4(%eax),%eax
  802a73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a76:	8b 12                	mov    (%edx),%edx
  802a78:	89 10                	mov    %edx,(%eax)
  802a7a:	eb 0a                	jmp    802a86 <insert_sorted_with_merge_freeList+0x3e5>
  802a7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	a3 38 41 80 00       	mov    %eax,0x804138
  802a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a99:	a1 44 41 80 00       	mov    0x804144,%eax
  802a9e:	48                   	dec    %eax
  802a9f:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802aa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa8:	75 17                	jne    802ac1 <insert_sorted_with_merge_freeList+0x420>
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 14 39 80 00       	push   $0x803914
  802ab2:	68 5c 01 00 00       	push   $0x15c
  802ab7:	68 37 39 80 00       	push   $0x803937
  802abc:	e8 dd 03 00 00       	call   802e9e <_panic>
  802ac1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	89 10                	mov    %edx,(%eax)
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 0d                	je     802ae2 <insert_sorted_with_merge_freeList+0x441>
  802ad5:	a1 48 41 80 00       	mov    0x804148,%eax
  802ada:	8b 55 08             	mov    0x8(%ebp),%edx
  802add:	89 50 04             	mov    %edx,0x4(%eax)
  802ae0:	eb 08                	jmp    802aea <insert_sorted_with_merge_freeList+0x449>
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	a3 48 41 80 00       	mov    %eax,0x804148
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afc:	a1 54 41 80 00       	mov    0x804154,%eax
  802b01:	40                   	inc    %eax
  802b02:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802b07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b0b:	75 17                	jne    802b24 <insert_sorted_with_merge_freeList+0x483>
  802b0d:	83 ec 04             	sub    $0x4,%esp
  802b10:	68 14 39 80 00       	push   $0x803914
  802b15:	68 5d 01 00 00       	push   $0x15d
  802b1a:	68 37 39 80 00       	push   $0x803937
  802b1f:	e8 7a 03 00 00       	call   802e9e <_panic>
  802b24:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2d:	89 10                	mov    %edx,(%eax)
  802b2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b32:	8b 00                	mov    (%eax),%eax
  802b34:	85 c0                	test   %eax,%eax
  802b36:	74 0d                	je     802b45 <insert_sorted_with_merge_freeList+0x4a4>
  802b38:	a1 48 41 80 00       	mov    0x804148,%eax
  802b3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b40:	89 50 04             	mov    %edx,0x4(%eax)
  802b43:	eb 08                	jmp    802b4d <insert_sorted_with_merge_freeList+0x4ac>
  802b45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b48:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b50:	a3 48 41 80 00       	mov    %eax,0x804148
  802b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5f:	a1 54 41 80 00       	mov    0x804154,%eax
  802b64:	40                   	inc    %eax
  802b65:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802b6a:	e9 78 02 00 00       	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 50 08             	mov    0x8(%eax),%edx
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7b:	01 c2                	add    %eax,%edx
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8b 40 08             	mov    0x8(%eax),%eax
  802b83:	39 c2                	cmp    %eax,%edx
  802b85:	0f 83 b8 00 00 00    	jae    802c43 <insert_sorted_with_merge_freeList+0x5a2>
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	8b 50 08             	mov    0x8(%eax),%edx
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	01 c2                	add    %eax,%edx
  802b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9c:	8b 40 08             	mov    0x8(%eax),%eax
  802b9f:	39 c2                	cmp    %eax,%edx
  802ba1:	0f 85 9c 00 00 00    	jne    802c43 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802ba7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802baa:	8b 50 0c             	mov    0xc(%eax),%edx
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb3:	01 c2                	add    %eax,%edx
  802bb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb8:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	8b 50 08             	mov    0x8(%eax),%edx
  802bc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc4:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bdf:	75 17                	jne    802bf8 <insert_sorted_with_merge_freeList+0x557>
  802be1:	83 ec 04             	sub    $0x4,%esp
  802be4:	68 14 39 80 00       	push   $0x803914
  802be9:	68 67 01 00 00       	push   $0x167
  802bee:	68 37 39 80 00       	push   $0x803937
  802bf3:	e8 a6 02 00 00       	call   802e9e <_panic>
  802bf8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	89 10                	mov    %edx,(%eax)
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 0d                	je     802c19 <insert_sorted_with_merge_freeList+0x578>
  802c0c:	a1 48 41 80 00       	mov    0x804148,%eax
  802c11:	8b 55 08             	mov    0x8(%ebp),%edx
  802c14:	89 50 04             	mov    %edx,0x4(%eax)
  802c17:	eb 08                	jmp    802c21 <insert_sorted_with_merge_freeList+0x580>
  802c19:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	a3 48 41 80 00       	mov    %eax,0x804148
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c33:	a1 54 41 80 00       	mov    0x804154,%eax
  802c38:	40                   	inc    %eax
  802c39:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802c3e:	e9 a4 01 00 00       	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 50 08             	mov    0x8(%eax),%edx
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4f:	01 c2                	add    %eax,%edx
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	8b 40 08             	mov    0x8(%eax),%eax
  802c57:	39 c2                	cmp    %eax,%edx
  802c59:	0f 85 ac 00 00 00    	jne    802d0b <insert_sorted_with_merge_freeList+0x66a>
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 50 08             	mov    0x8(%eax),%edx
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6b:	01 c2                	add    %eax,%edx
  802c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c70:	8b 40 08             	mov    0x8(%eax),%eax
  802c73:	39 c2                	cmp    %eax,%edx
  802c75:	0f 83 90 00 00 00    	jae    802d0b <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 50 0c             	mov    0xc(%eax),%edx
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	01 c2                	add    %eax,%edx
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ca3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca7:	75 17                	jne    802cc0 <insert_sorted_with_merge_freeList+0x61f>
  802ca9:	83 ec 04             	sub    $0x4,%esp
  802cac:	68 14 39 80 00       	push   $0x803914
  802cb1:	68 70 01 00 00       	push   $0x170
  802cb6:	68 37 39 80 00       	push   $0x803937
  802cbb:	e8 de 01 00 00       	call   802e9e <_panic>
  802cc0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	89 10                	mov    %edx,(%eax)
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	74 0d                	je     802ce1 <insert_sorted_with_merge_freeList+0x640>
  802cd4:	a1 48 41 80 00       	mov    0x804148,%eax
  802cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdc:	89 50 04             	mov    %edx,0x4(%eax)
  802cdf:	eb 08                	jmp    802ce9 <insert_sorted_with_merge_freeList+0x648>
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	a3 48 41 80 00       	mov    %eax,0x804148
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfb:	a1 54 41 80 00       	mov    0x804154,%eax
  802d00:	40                   	inc    %eax
  802d01:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802d06:	e9 dc 00 00 00       	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 50 08             	mov    0x8(%eax),%edx
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 40 0c             	mov    0xc(%eax),%eax
  802d17:	01 c2                	add    %eax,%edx
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	8b 40 08             	mov    0x8(%eax),%eax
  802d1f:	39 c2                	cmp    %eax,%edx
  802d21:	0f 83 88 00 00 00    	jae    802daf <insert_sorted_with_merge_freeList+0x70e>
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	8b 50 08             	mov    0x8(%eax),%edx
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	8b 40 0c             	mov    0xc(%eax),%eax
  802d33:	01 c2                	add    %eax,%edx
  802d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d38:	8b 40 08             	mov    0x8(%eax),%eax
  802d3b:	39 c2                	cmp    %eax,%edx
  802d3d:	73 70                	jae    802daf <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802d3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d43:	74 06                	je     802d4b <insert_sorted_with_merge_freeList+0x6aa>
  802d45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d49:	75 17                	jne    802d62 <insert_sorted_with_merge_freeList+0x6c1>
  802d4b:	83 ec 04             	sub    $0x4,%esp
  802d4e:	68 74 39 80 00       	push   $0x803974
  802d53:	68 75 01 00 00       	push   $0x175
  802d58:	68 37 39 80 00       	push   $0x803937
  802d5d:	e8 3c 01 00 00       	call   802e9e <_panic>
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 10                	mov    (%eax),%edx
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	89 10                	mov    %edx,(%eax)
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 0b                	je     802d80 <insert_sorted_with_merge_freeList+0x6df>
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7d:	89 50 04             	mov    %edx,0x4(%eax)
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 55 08             	mov    0x8(%ebp),%edx
  802d86:	89 10                	mov    %edx,(%eax)
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	75 08                	jne    802da2 <insert_sorted_with_merge_freeList+0x701>
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802da2:	a1 44 41 80 00       	mov    0x804144,%eax
  802da7:	40                   	inc    %eax
  802da8:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802dad:	eb 38                	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802daf:	a1 40 41 80 00       	mov    0x804140,%eax
  802db4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbb:	74 07                	je     802dc4 <insert_sorted_with_merge_freeList+0x723>
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 00                	mov    (%eax),%eax
  802dc2:	eb 05                	jmp    802dc9 <insert_sorted_with_merge_freeList+0x728>
  802dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc9:	a3 40 41 80 00       	mov    %eax,0x804140
  802dce:	a1 40 41 80 00       	mov    0x804140,%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	0f 85 c3 fb ff ff    	jne    80299e <insert_sorted_with_merge_freeList+0x2fd>
  802ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddf:	0f 85 b9 fb ff ff    	jne    80299e <insert_sorted_with_merge_freeList+0x2fd>





}
  802de5:	eb 00                	jmp    802de7 <insert_sorted_with_merge_freeList+0x746>
  802de7:	90                   	nop
  802de8:	c9                   	leave  
  802de9:	c3                   	ret    

00802dea <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802dea:	55                   	push   %ebp
  802deb:	89 e5                	mov    %esp,%ebp
  802ded:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802df0:	8b 55 08             	mov    0x8(%ebp),%edx
  802df3:	89 d0                	mov    %edx,%eax
  802df5:	c1 e0 02             	shl    $0x2,%eax
  802df8:	01 d0                	add    %edx,%eax
  802dfa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e01:	01 d0                	add    %edx,%eax
  802e03:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e0a:	01 d0                	add    %edx,%eax
  802e0c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e13:	01 d0                	add    %edx,%eax
  802e15:	c1 e0 04             	shl    $0x4,%eax
  802e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802e1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802e22:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802e25:	83 ec 0c             	sub    $0xc,%esp
  802e28:	50                   	push   %eax
  802e29:	e8 31 ec ff ff       	call   801a5f <sys_get_virtual_time>
  802e2e:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802e31:	eb 41                	jmp    802e74 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802e33:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802e36:	83 ec 0c             	sub    $0xc,%esp
  802e39:	50                   	push   %eax
  802e3a:	e8 20 ec ff ff       	call   801a5f <sys_get_virtual_time>
  802e3f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802e42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e48:	29 c2                	sub    %eax,%edx
  802e4a:	89 d0                	mov    %edx,%eax
  802e4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802e4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e55:	89 d1                	mov    %edx,%ecx
  802e57:	29 c1                	sub    %eax,%ecx
  802e59:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e5f:	39 c2                	cmp    %eax,%edx
  802e61:	0f 97 c0             	seta   %al
  802e64:	0f b6 c0             	movzbl %al,%eax
  802e67:	29 c1                	sub    %eax,%ecx
  802e69:	89 c8                	mov    %ecx,%eax
  802e6b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802e6e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e7a:	72 b7                	jb     802e33 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802e7c:	90                   	nop
  802e7d:	c9                   	leave  
  802e7e:	c3                   	ret    

00802e7f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802e7f:	55                   	push   %ebp
  802e80:	89 e5                	mov    %esp,%ebp
  802e82:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802e85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802e8c:	eb 03                	jmp    802e91 <busy_wait+0x12>
  802e8e:	ff 45 fc             	incl   -0x4(%ebp)
  802e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e97:	72 f5                	jb     802e8e <busy_wait+0xf>
	return i;
  802e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802e9c:	c9                   	leave  
  802e9d:	c3                   	ret    

00802e9e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802e9e:	55                   	push   %ebp
  802e9f:	89 e5                	mov    %esp,%ebp
  802ea1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802ea4:	8d 45 10             	lea    0x10(%ebp),%eax
  802ea7:	83 c0 04             	add    $0x4,%eax
  802eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802ead:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	74 16                	je     802ecc <_panic+0x2e>
		cprintf("%s: ", argv0);
  802eb6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802ebb:	83 ec 08             	sub    $0x8,%esp
  802ebe:	50                   	push   %eax
  802ebf:	68 f8 39 80 00       	push   $0x8039f8
  802ec4:	e8 b2 d4 ff ff       	call   80037b <cprintf>
  802ec9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802ecc:	a1 00 40 80 00       	mov    0x804000,%eax
  802ed1:	ff 75 0c             	pushl  0xc(%ebp)
  802ed4:	ff 75 08             	pushl  0x8(%ebp)
  802ed7:	50                   	push   %eax
  802ed8:	68 fd 39 80 00       	push   $0x8039fd
  802edd:	e8 99 d4 ff ff       	call   80037b <cprintf>
  802ee2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ee8:	83 ec 08             	sub    $0x8,%esp
  802eeb:	ff 75 f4             	pushl  -0xc(%ebp)
  802eee:	50                   	push   %eax
  802eef:	e8 1c d4 ff ff       	call   800310 <vcprintf>
  802ef4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802ef7:	83 ec 08             	sub    $0x8,%esp
  802efa:	6a 00                	push   $0x0
  802efc:	68 19 3a 80 00       	push   $0x803a19
  802f01:	e8 0a d4 ff ff       	call   800310 <vcprintf>
  802f06:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802f09:	e8 8b d3 ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  802f0e:	eb fe                	jmp    802f0e <_panic+0x70>

00802f10 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802f10:	55                   	push   %ebp
  802f11:	89 e5                	mov    %esp,%ebp
  802f13:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802f16:	a1 20 40 80 00       	mov    0x804020,%eax
  802f1b:	8b 50 74             	mov    0x74(%eax),%edx
  802f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f21:	39 c2                	cmp    %eax,%edx
  802f23:	74 14                	je     802f39 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802f25:	83 ec 04             	sub    $0x4,%esp
  802f28:	68 1c 3a 80 00       	push   $0x803a1c
  802f2d:	6a 26                	push   $0x26
  802f2f:	68 68 3a 80 00       	push   $0x803a68
  802f34:	e8 65 ff ff ff       	call   802e9e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802f39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802f40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f47:	e9 c2 00 00 00       	jmp    80300e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	01 d0                	add    %edx,%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	75 08                	jne    802f69 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802f61:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802f64:	e9 a2 00 00 00       	jmp    80300b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802f69:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f70:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f77:	eb 69                	jmp    802fe2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802f79:	a1 20 40 80 00       	mov    0x804020,%eax
  802f7e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f87:	89 d0                	mov    %edx,%eax
  802f89:	01 c0                	add    %eax,%eax
  802f8b:	01 d0                	add    %edx,%eax
  802f8d:	c1 e0 03             	shl    $0x3,%eax
  802f90:	01 c8                	add    %ecx,%eax
  802f92:	8a 40 04             	mov    0x4(%eax),%al
  802f95:	84 c0                	test   %al,%al
  802f97:	75 46                	jne    802fdf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f99:	a1 20 40 80 00       	mov    0x804020,%eax
  802f9e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802fa4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa7:	89 d0                	mov    %edx,%eax
  802fa9:	01 c0                	add    %eax,%eax
  802fab:	01 d0                	add    %edx,%eax
  802fad:	c1 e0 03             	shl    $0x3,%eax
  802fb0:	01 c8                	add    %ecx,%eax
  802fb2:	8b 00                	mov    (%eax),%eax
  802fb4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802fbf:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	01 c8                	add    %ecx,%eax
  802fd0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802fd2:	39 c2                	cmp    %eax,%edx
  802fd4:	75 09                	jne    802fdf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802fd6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802fdd:	eb 12                	jmp    802ff1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fdf:	ff 45 e8             	incl   -0x18(%ebp)
  802fe2:	a1 20 40 80 00       	mov    0x804020,%eax
  802fe7:	8b 50 74             	mov    0x74(%eax),%edx
  802fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fed:	39 c2                	cmp    %eax,%edx
  802fef:	77 88                	ja     802f79 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802ff1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ff5:	75 14                	jne    80300b <CheckWSWithoutLastIndex+0xfb>
			panic(
  802ff7:	83 ec 04             	sub    $0x4,%esp
  802ffa:	68 74 3a 80 00       	push   $0x803a74
  802fff:	6a 3a                	push   $0x3a
  803001:	68 68 3a 80 00       	push   $0x803a68
  803006:	e8 93 fe ff ff       	call   802e9e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80300b:	ff 45 f0             	incl   -0x10(%ebp)
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803014:	0f 8c 32 ff ff ff    	jl     802f4c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80301a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803021:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803028:	eb 26                	jmp    803050 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80302a:	a1 20 40 80 00       	mov    0x804020,%eax
  80302f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803035:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803038:	89 d0                	mov    %edx,%eax
  80303a:	01 c0                	add    %eax,%eax
  80303c:	01 d0                	add    %edx,%eax
  80303e:	c1 e0 03             	shl    $0x3,%eax
  803041:	01 c8                	add    %ecx,%eax
  803043:	8a 40 04             	mov    0x4(%eax),%al
  803046:	3c 01                	cmp    $0x1,%al
  803048:	75 03                	jne    80304d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80304a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80304d:	ff 45 e0             	incl   -0x20(%ebp)
  803050:	a1 20 40 80 00       	mov    0x804020,%eax
  803055:	8b 50 74             	mov    0x74(%eax),%edx
  803058:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80305b:	39 c2                	cmp    %eax,%edx
  80305d:	77 cb                	ja     80302a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803065:	74 14                	je     80307b <CheckWSWithoutLastIndex+0x16b>
		panic(
  803067:	83 ec 04             	sub    $0x4,%esp
  80306a:	68 c8 3a 80 00       	push   $0x803ac8
  80306f:	6a 44                	push   $0x44
  803071:	68 68 3a 80 00       	push   $0x803a68
  803076:	e8 23 fe ff ff       	call   802e9e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80307b:	90                   	nop
  80307c:	c9                   	leave  
  80307d:	c3                   	ret    
  80307e:	66 90                	xchg   %ax,%ax

00803080 <__udivdi3>:
  803080:	55                   	push   %ebp
  803081:	57                   	push   %edi
  803082:	56                   	push   %esi
  803083:	53                   	push   %ebx
  803084:	83 ec 1c             	sub    $0x1c,%esp
  803087:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80308b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80308f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803093:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803097:	89 ca                	mov    %ecx,%edx
  803099:	89 f8                	mov    %edi,%eax
  80309b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80309f:	85 f6                	test   %esi,%esi
  8030a1:	75 2d                	jne    8030d0 <__udivdi3+0x50>
  8030a3:	39 cf                	cmp    %ecx,%edi
  8030a5:	77 65                	ja     80310c <__udivdi3+0x8c>
  8030a7:	89 fd                	mov    %edi,%ebp
  8030a9:	85 ff                	test   %edi,%edi
  8030ab:	75 0b                	jne    8030b8 <__udivdi3+0x38>
  8030ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8030b2:	31 d2                	xor    %edx,%edx
  8030b4:	f7 f7                	div    %edi
  8030b6:	89 c5                	mov    %eax,%ebp
  8030b8:	31 d2                	xor    %edx,%edx
  8030ba:	89 c8                	mov    %ecx,%eax
  8030bc:	f7 f5                	div    %ebp
  8030be:	89 c1                	mov    %eax,%ecx
  8030c0:	89 d8                	mov    %ebx,%eax
  8030c2:	f7 f5                	div    %ebp
  8030c4:	89 cf                	mov    %ecx,%edi
  8030c6:	89 fa                	mov    %edi,%edx
  8030c8:	83 c4 1c             	add    $0x1c,%esp
  8030cb:	5b                   	pop    %ebx
  8030cc:	5e                   	pop    %esi
  8030cd:	5f                   	pop    %edi
  8030ce:	5d                   	pop    %ebp
  8030cf:	c3                   	ret    
  8030d0:	39 ce                	cmp    %ecx,%esi
  8030d2:	77 28                	ja     8030fc <__udivdi3+0x7c>
  8030d4:	0f bd fe             	bsr    %esi,%edi
  8030d7:	83 f7 1f             	xor    $0x1f,%edi
  8030da:	75 40                	jne    80311c <__udivdi3+0x9c>
  8030dc:	39 ce                	cmp    %ecx,%esi
  8030de:	72 0a                	jb     8030ea <__udivdi3+0x6a>
  8030e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030e4:	0f 87 9e 00 00 00    	ja     803188 <__udivdi3+0x108>
  8030ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ef:	89 fa                	mov    %edi,%edx
  8030f1:	83 c4 1c             	add    $0x1c,%esp
  8030f4:	5b                   	pop    %ebx
  8030f5:	5e                   	pop    %esi
  8030f6:	5f                   	pop    %edi
  8030f7:	5d                   	pop    %ebp
  8030f8:	c3                   	ret    
  8030f9:	8d 76 00             	lea    0x0(%esi),%esi
  8030fc:	31 ff                	xor    %edi,%edi
  8030fe:	31 c0                	xor    %eax,%eax
  803100:	89 fa                	mov    %edi,%edx
  803102:	83 c4 1c             	add    $0x1c,%esp
  803105:	5b                   	pop    %ebx
  803106:	5e                   	pop    %esi
  803107:	5f                   	pop    %edi
  803108:	5d                   	pop    %ebp
  803109:	c3                   	ret    
  80310a:	66 90                	xchg   %ax,%ax
  80310c:	89 d8                	mov    %ebx,%eax
  80310e:	f7 f7                	div    %edi
  803110:	31 ff                	xor    %edi,%edi
  803112:	89 fa                	mov    %edi,%edx
  803114:	83 c4 1c             	add    $0x1c,%esp
  803117:	5b                   	pop    %ebx
  803118:	5e                   	pop    %esi
  803119:	5f                   	pop    %edi
  80311a:	5d                   	pop    %ebp
  80311b:	c3                   	ret    
  80311c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803121:	89 eb                	mov    %ebp,%ebx
  803123:	29 fb                	sub    %edi,%ebx
  803125:	89 f9                	mov    %edi,%ecx
  803127:	d3 e6                	shl    %cl,%esi
  803129:	89 c5                	mov    %eax,%ebp
  80312b:	88 d9                	mov    %bl,%cl
  80312d:	d3 ed                	shr    %cl,%ebp
  80312f:	89 e9                	mov    %ebp,%ecx
  803131:	09 f1                	or     %esi,%ecx
  803133:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803137:	89 f9                	mov    %edi,%ecx
  803139:	d3 e0                	shl    %cl,%eax
  80313b:	89 c5                	mov    %eax,%ebp
  80313d:	89 d6                	mov    %edx,%esi
  80313f:	88 d9                	mov    %bl,%cl
  803141:	d3 ee                	shr    %cl,%esi
  803143:	89 f9                	mov    %edi,%ecx
  803145:	d3 e2                	shl    %cl,%edx
  803147:	8b 44 24 08          	mov    0x8(%esp),%eax
  80314b:	88 d9                	mov    %bl,%cl
  80314d:	d3 e8                	shr    %cl,%eax
  80314f:	09 c2                	or     %eax,%edx
  803151:	89 d0                	mov    %edx,%eax
  803153:	89 f2                	mov    %esi,%edx
  803155:	f7 74 24 0c          	divl   0xc(%esp)
  803159:	89 d6                	mov    %edx,%esi
  80315b:	89 c3                	mov    %eax,%ebx
  80315d:	f7 e5                	mul    %ebp
  80315f:	39 d6                	cmp    %edx,%esi
  803161:	72 19                	jb     80317c <__udivdi3+0xfc>
  803163:	74 0b                	je     803170 <__udivdi3+0xf0>
  803165:	89 d8                	mov    %ebx,%eax
  803167:	31 ff                	xor    %edi,%edi
  803169:	e9 58 ff ff ff       	jmp    8030c6 <__udivdi3+0x46>
  80316e:	66 90                	xchg   %ax,%ax
  803170:	8b 54 24 08          	mov    0x8(%esp),%edx
  803174:	89 f9                	mov    %edi,%ecx
  803176:	d3 e2                	shl    %cl,%edx
  803178:	39 c2                	cmp    %eax,%edx
  80317a:	73 e9                	jae    803165 <__udivdi3+0xe5>
  80317c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80317f:	31 ff                	xor    %edi,%edi
  803181:	e9 40 ff ff ff       	jmp    8030c6 <__udivdi3+0x46>
  803186:	66 90                	xchg   %ax,%ax
  803188:	31 c0                	xor    %eax,%eax
  80318a:	e9 37 ff ff ff       	jmp    8030c6 <__udivdi3+0x46>
  80318f:	90                   	nop

00803190 <__umoddi3>:
  803190:	55                   	push   %ebp
  803191:	57                   	push   %edi
  803192:	56                   	push   %esi
  803193:	53                   	push   %ebx
  803194:	83 ec 1c             	sub    $0x1c,%esp
  803197:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80319b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80319f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031af:	89 f3                	mov    %esi,%ebx
  8031b1:	89 fa                	mov    %edi,%edx
  8031b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031b7:	89 34 24             	mov    %esi,(%esp)
  8031ba:	85 c0                	test   %eax,%eax
  8031bc:	75 1a                	jne    8031d8 <__umoddi3+0x48>
  8031be:	39 f7                	cmp    %esi,%edi
  8031c0:	0f 86 a2 00 00 00    	jbe    803268 <__umoddi3+0xd8>
  8031c6:	89 c8                	mov    %ecx,%eax
  8031c8:	89 f2                	mov    %esi,%edx
  8031ca:	f7 f7                	div    %edi
  8031cc:	89 d0                	mov    %edx,%eax
  8031ce:	31 d2                	xor    %edx,%edx
  8031d0:	83 c4 1c             	add    $0x1c,%esp
  8031d3:	5b                   	pop    %ebx
  8031d4:	5e                   	pop    %esi
  8031d5:	5f                   	pop    %edi
  8031d6:	5d                   	pop    %ebp
  8031d7:	c3                   	ret    
  8031d8:	39 f0                	cmp    %esi,%eax
  8031da:	0f 87 ac 00 00 00    	ja     80328c <__umoddi3+0xfc>
  8031e0:	0f bd e8             	bsr    %eax,%ebp
  8031e3:	83 f5 1f             	xor    $0x1f,%ebp
  8031e6:	0f 84 ac 00 00 00    	je     803298 <__umoddi3+0x108>
  8031ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8031f1:	29 ef                	sub    %ebp,%edi
  8031f3:	89 fe                	mov    %edi,%esi
  8031f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031f9:	89 e9                	mov    %ebp,%ecx
  8031fb:	d3 e0                	shl    %cl,%eax
  8031fd:	89 d7                	mov    %edx,%edi
  8031ff:	89 f1                	mov    %esi,%ecx
  803201:	d3 ef                	shr    %cl,%edi
  803203:	09 c7                	or     %eax,%edi
  803205:	89 e9                	mov    %ebp,%ecx
  803207:	d3 e2                	shl    %cl,%edx
  803209:	89 14 24             	mov    %edx,(%esp)
  80320c:	89 d8                	mov    %ebx,%eax
  80320e:	d3 e0                	shl    %cl,%eax
  803210:	89 c2                	mov    %eax,%edx
  803212:	8b 44 24 08          	mov    0x8(%esp),%eax
  803216:	d3 e0                	shl    %cl,%eax
  803218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80321c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803220:	89 f1                	mov    %esi,%ecx
  803222:	d3 e8                	shr    %cl,%eax
  803224:	09 d0                	or     %edx,%eax
  803226:	d3 eb                	shr    %cl,%ebx
  803228:	89 da                	mov    %ebx,%edx
  80322a:	f7 f7                	div    %edi
  80322c:	89 d3                	mov    %edx,%ebx
  80322e:	f7 24 24             	mull   (%esp)
  803231:	89 c6                	mov    %eax,%esi
  803233:	89 d1                	mov    %edx,%ecx
  803235:	39 d3                	cmp    %edx,%ebx
  803237:	0f 82 87 00 00 00    	jb     8032c4 <__umoddi3+0x134>
  80323d:	0f 84 91 00 00 00    	je     8032d4 <__umoddi3+0x144>
  803243:	8b 54 24 04          	mov    0x4(%esp),%edx
  803247:	29 f2                	sub    %esi,%edx
  803249:	19 cb                	sbb    %ecx,%ebx
  80324b:	89 d8                	mov    %ebx,%eax
  80324d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803251:	d3 e0                	shl    %cl,%eax
  803253:	89 e9                	mov    %ebp,%ecx
  803255:	d3 ea                	shr    %cl,%edx
  803257:	09 d0                	or     %edx,%eax
  803259:	89 e9                	mov    %ebp,%ecx
  80325b:	d3 eb                	shr    %cl,%ebx
  80325d:	89 da                	mov    %ebx,%edx
  80325f:	83 c4 1c             	add    $0x1c,%esp
  803262:	5b                   	pop    %ebx
  803263:	5e                   	pop    %esi
  803264:	5f                   	pop    %edi
  803265:	5d                   	pop    %ebp
  803266:	c3                   	ret    
  803267:	90                   	nop
  803268:	89 fd                	mov    %edi,%ebp
  80326a:	85 ff                	test   %edi,%edi
  80326c:	75 0b                	jne    803279 <__umoddi3+0xe9>
  80326e:	b8 01 00 00 00       	mov    $0x1,%eax
  803273:	31 d2                	xor    %edx,%edx
  803275:	f7 f7                	div    %edi
  803277:	89 c5                	mov    %eax,%ebp
  803279:	89 f0                	mov    %esi,%eax
  80327b:	31 d2                	xor    %edx,%edx
  80327d:	f7 f5                	div    %ebp
  80327f:	89 c8                	mov    %ecx,%eax
  803281:	f7 f5                	div    %ebp
  803283:	89 d0                	mov    %edx,%eax
  803285:	e9 44 ff ff ff       	jmp    8031ce <__umoddi3+0x3e>
  80328a:	66 90                	xchg   %ax,%ax
  80328c:	89 c8                	mov    %ecx,%eax
  80328e:	89 f2                	mov    %esi,%edx
  803290:	83 c4 1c             	add    $0x1c,%esp
  803293:	5b                   	pop    %ebx
  803294:	5e                   	pop    %esi
  803295:	5f                   	pop    %edi
  803296:	5d                   	pop    %ebp
  803297:	c3                   	ret    
  803298:	3b 04 24             	cmp    (%esp),%eax
  80329b:	72 06                	jb     8032a3 <__umoddi3+0x113>
  80329d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032a1:	77 0f                	ja     8032b2 <__umoddi3+0x122>
  8032a3:	89 f2                	mov    %esi,%edx
  8032a5:	29 f9                	sub    %edi,%ecx
  8032a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032ab:	89 14 24             	mov    %edx,(%esp)
  8032ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032b6:	8b 14 24             	mov    (%esp),%edx
  8032b9:	83 c4 1c             	add    $0x1c,%esp
  8032bc:	5b                   	pop    %ebx
  8032bd:	5e                   	pop    %esi
  8032be:	5f                   	pop    %edi
  8032bf:	5d                   	pop    %ebp
  8032c0:	c3                   	ret    
  8032c1:	8d 76 00             	lea    0x0(%esi),%esi
  8032c4:	2b 04 24             	sub    (%esp),%eax
  8032c7:	19 fa                	sbb    %edi,%edx
  8032c9:	89 d1                	mov    %edx,%ecx
  8032cb:	89 c6                	mov    %eax,%esi
  8032cd:	e9 71 ff ff ff       	jmp    803243 <__umoddi3+0xb3>
  8032d2:	66 90                	xchg   %ax,%ax
  8032d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032d8:	72 ea                	jb     8032c4 <__umoddi3+0x134>
  8032da:	89 d9                	mov    %ebx,%ecx
  8032dc:	e9 62 ff ff ff       	jmp    803243 <__umoddi3+0xb3>
