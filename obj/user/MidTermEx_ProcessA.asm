
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 36 01 00 00       	call   80016c <libmain>
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
  80003e:	e8 ea 19 00 00       	call   801a2d <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 00 33 80 00       	push   $0x803300
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 b9 14 00 00       	call   80150f <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 02 33 80 00       	push   $0x803302
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 a3 14 00 00       	call   80150f <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 09 33 80 00       	push   $0x803309
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 8d 14 00 00       	call   80150f <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 cc 19 00 00       	call   801a60 <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 2f 2d 00 00       	call   802deb <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 8b 19 00 00       	call   801a60 <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 ee 2c 00 00       	call   802deb <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 4c 19 00 00       	call   801a60 <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 af 2c 00 00       	call   802deb <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 13                	jne    80015c <_main+0x124>
	{
		sys_signalSemaphore(parentenvID, "T") ;
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 17 33 80 00       	push   $0x803317
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 93 17 00 00       	call   8018ec <sys_signalSemaphore>
  800159:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	8d 50 01             	lea    0x1(%eax),%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	89 10                	mov    %edx,(%eax)

}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800172:	e8 9d 18 00 00       	call   801a14 <sys_getenvindex>
  800177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017d:	89 d0                	mov    %edx,%eax
  80017f:	c1 e0 03             	shl    $0x3,%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018f:	01 d0                	add    %edx,%eax
  800191:	c1 e0 04             	shl    $0x4,%eax
  800194:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800199:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019e:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a3:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a9:	84 c0                	test   %al,%al
  8001ab:	74 0f                	je     8001bc <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b2:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b7:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c0:	7e 0a                	jle    8001cc <libmain+0x60>
		binaryname = argv[0];
  8001c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c5:	8b 00                	mov    (%eax),%eax
  8001c7:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	ff 75 08             	pushl  0x8(%ebp)
  8001d5:	e8 5e fe ff ff       	call   800038 <_main>
  8001da:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dd:	e8 3f 16 00 00       	call   801821 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 34 33 80 00       	push   $0x803334
  8001ea:	e8 8d 01 00 00       	call   80037c <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800202:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 5c 33 80 00       	push   $0x80335c
  800212:	e8 65 01 00 00       	call   80037c <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800230:	a1 20 40 80 00       	mov    0x804020,%eax
  800235:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023b:	51                   	push   %ecx
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 84 33 80 00       	push   $0x803384
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 dc 33 80 00       	push   $0x8033dc
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 34 33 80 00       	push   $0x803334
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 bf 15 00 00       	call   80183b <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027c:	e8 19 00 00 00       	call   80029a <exit>
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 00                	push   $0x0
  80028f:	e8 4c 17 00 00       	call   8019e0 <sys_destroy_env>
  800294:	83 c4 10             	add    $0x10,%esp
}
  800297:	90                   	nop
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <exit>:

void
exit(void)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a0:	e8 a1 17 00 00       	call   801a46 <sys_exit_env>
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b9:	89 0a                	mov    %ecx,(%edx)
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	88 d1                	mov    %dl,%cl
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d1:	75 2c                	jne    8002ff <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d3:	a0 24 40 80 00       	mov    0x804024,%al
  8002d8:	0f b6 c0             	movzbl %al,%eax
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	8b 12                	mov    (%edx),%edx
  8002e0:	89 d1                	mov    %edx,%ecx
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	83 c2 08             	add    $0x8,%edx
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	50                   	push   %eax
  8002ec:	51                   	push   %ecx
  8002ed:	52                   	push   %edx
  8002ee:	e8 80 13 00 00       	call   801673 <sys_cputs>
  8002f3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	8b 40 04             	mov    0x4(%eax),%eax
  800305:	8d 50 01             	lea    0x1(%eax),%edx
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800321:	00 00 00 
	b.cnt = 0;
  800324:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	68 a8 02 80 00       	push   $0x8002a8
  800340:	e8 11 02 00 00       	call   800556 <vprintfmt>
  800345:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800348:	a0 24 40 80 00       	mov    0x804024,%al
  80034d:	0f b6 c0             	movzbl %al,%eax
  800350:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	50                   	push   %eax
  80035a:	52                   	push   %edx
  80035b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800361:	83 c0 08             	add    $0x8,%eax
  800364:	50                   	push   %eax
  800365:	e8 09 13 00 00       	call   801673 <sys_cputs>
  80036a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036d:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800374:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <cprintf>:

int cprintf(const char *fmt, ...) {
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800382:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 73 ff ff ff       	call   800311 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003af:	e8 6d 14 00 00       	call   801821 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	e8 48 ff ff ff       	call   800311 <vcprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003cf:	e8 67 14 00 00       	call   80183b <sys_enable_interrupt>
	return cnt;
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	53                   	push   %ebx
  8003dd:	83 ec 14             	sub    $0x14,%esp
  8003e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f7:	77 55                	ja     80044e <printnum+0x75>
  8003f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fc:	72 05                	jb     800403 <printnum+0x2a>
  8003fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800401:	77 4b                	ja     80044e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800403:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800406:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800409:	8b 45 18             	mov    0x18(%ebp),%eax
  80040c:	ba 00 00 00 00       	mov    $0x0,%edx
  800411:	52                   	push   %edx
  800412:	50                   	push   %eax
  800413:	ff 75 f4             	pushl  -0xc(%ebp)
  800416:	ff 75 f0             	pushl  -0x10(%ebp)
  800419:	e8 62 2c 00 00       	call   803080 <__udivdi3>
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	ff 75 20             	pushl  0x20(%ebp)
  800427:	53                   	push   %ebx
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	ff 75 0c             	pushl  0xc(%ebp)
  800430:	ff 75 08             	pushl  0x8(%ebp)
  800433:	e8 a1 ff ff ff       	call   8003d9 <printnum>
  800438:	83 c4 20             	add    $0x20,%esp
  80043b:	eb 1a                	jmp    800457 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	ff 75 20             	pushl  0x20(%ebp)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	ff d0                	call   *%eax
  80044b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044e:	ff 4d 1c             	decl   0x1c(%ebp)
  800451:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800455:	7f e6                	jg     80043d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800457:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80045a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800465:	53                   	push   %ebx
  800466:	51                   	push   %ecx
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	e8 22 2d 00 00       	call   803190 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 14 36 80 00       	add    $0x803614,%eax
  800476:	8a 00                	mov    (%eax),%al
  800478:	0f be c0             	movsbl %al,%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	ff d0                	call   *%eax
  800487:	83 c4 10             	add    $0x10,%esp
}
  80048a:	90                   	nop
  80048b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800493:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800497:	7e 1c                	jle    8004b5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 08             	lea    0x8(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 08             	sub    $0x8,%eax
  8004ae:	8b 50 04             	mov    0x4(%eax),%edx
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	eb 40                	jmp    8004f5 <getuint+0x65>
	else if (lflag)
  8004b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b9:	74 1e                	je     8004d9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 50 04             	lea    0x4(%eax),%edx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	89 10                	mov    %edx,(%eax)
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	83 e8 04             	sub    $0x4,%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	eb 1c                	jmp    8004f5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	89 10                	mov    %edx,(%eax)
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	83 e8 04             	sub    $0x4,%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fe:	7e 1c                	jle    80051c <getint+0x25>
		return va_arg(*ap, long long);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	8d 50 08             	lea    0x8(%eax),%edx
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	89 10                	mov    %edx,(%eax)
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	83 e8 08             	sub    $0x8,%eax
  800515:	8b 50 04             	mov    0x4(%eax),%edx
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	eb 38                	jmp    800554 <getint+0x5d>
	else if (lflag)
  80051c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800520:	74 1a                	je     80053c <getint+0x45>
		return va_arg(*ap, long);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 50 04             	lea    0x4(%eax),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 10                	mov    %edx,(%eax)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	83 e8 04             	sub    $0x4,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	eb 18                	jmp    800554 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 04             	lea    0x4(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 04             	sub    $0x4,%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	99                   	cltd   
}
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055e:	eb 17                	jmp    800577 <vprintfmt+0x21>
			if (ch == '\0')
  800560:	85 db                	test   %ebx,%ebx
  800562:	0f 84 af 03 00 00    	je     800917 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	53                   	push   %ebx
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	ff d0                	call   *%eax
  800574:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800577:	8b 45 10             	mov    0x10(%ebp),%eax
  80057a:	8d 50 01             	lea    0x1(%eax),%edx
  80057d:	89 55 10             	mov    %edx,0x10(%ebp)
  800580:	8a 00                	mov    (%eax),%al
  800582:	0f b6 d8             	movzbl %al,%ebx
  800585:	83 fb 25             	cmp    $0x25,%ebx
  800588:	75 d6                	jne    800560 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80058a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800595:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8d 50 01             	lea    0x1(%eax),%edx
  8005b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b3:	8a 00                	mov    (%eax),%al
  8005b5:	0f b6 d8             	movzbl %al,%ebx
  8005b8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005bb:	83 f8 55             	cmp    $0x55,%eax
  8005be:	0f 87 2b 03 00 00    	ja     8008ef <vprintfmt+0x399>
  8005c4:	8b 04 85 38 36 80 00 	mov    0x803638(,%eax,4),%eax
  8005cb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d1:	eb d7                	jmp    8005aa <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d7:	eb d1                	jmp    8005aa <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	01 d8                	add    %ebx,%eax
  8005ee:	83 e8 30             	sub    $0x30,%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f7:	8a 00                	mov    (%eax),%al
  8005f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ff:	7e 3e                	jle    80063f <vprintfmt+0xe9>
  800601:	83 fb 39             	cmp    $0x39,%ebx
  800604:	7f 39                	jg     80063f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800606:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800609:	eb d5                	jmp    8005e0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 c0 04             	add    $0x4,%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 e8 04             	sub    $0x4,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061f:	eb 1f                	jmp    800640 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	79 83                	jns    8005aa <vprintfmt+0x54>
				width = 0;
  800627:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062e:	e9 77 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800633:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80063a:	e9 6b ff ff ff       	jmp    8005aa <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800640:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800644:	0f 89 60 ff ff ff    	jns    8005aa <vprintfmt+0x54>
				width = precision, precision = -1;
  80064a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800650:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800657:	e9 4e ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065f:	e9 46 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 c0 04             	add    $0x4,%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 e8 04             	sub    $0x4,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	50                   	push   %eax
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
			break;
  800684:	e9 89 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	83 c0 04             	add    $0x4,%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80069a:	85 db                	test   %ebx,%ebx
  80069c:	79 02                	jns    8006a0 <vprintfmt+0x14a>
				err = -err;
  80069e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a0:	83 fb 64             	cmp    $0x64,%ebx
  8006a3:	7f 0b                	jg     8006b0 <vprintfmt+0x15a>
  8006a5:	8b 34 9d 80 34 80 00 	mov    0x803480(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 25 36 80 00       	push   $0x803625
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 5e 02 00 00       	call   80091f <printfmt>
  8006c1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c4:	e9 49 02 00 00       	jmp    800912 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c9:	56                   	push   %esi
  8006ca:	68 2e 36 80 00       	push   $0x80362e
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 45 02 00 00       	call   80091f <printfmt>
  8006da:	83 c4 10             	add    $0x10,%esp
			break;
  8006dd:	e9 30 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	83 c0 04             	add    $0x4,%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 30                	mov    (%eax),%esi
  8006f3:	85 f6                	test   %esi,%esi
  8006f5:	75 05                	jne    8006fc <vprintfmt+0x1a6>
				p = "(null)";
  8006f7:	be 31 36 80 00       	mov    $0x803631,%esi
			if (width > 0 && padc != '-')
  8006fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800700:	7e 6d                	jle    80076f <vprintfmt+0x219>
  800702:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800706:	74 67                	je     80076f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	50                   	push   %eax
  80070f:	56                   	push   %esi
  800710:	e8 0c 03 00 00       	call   800a21 <strnlen>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071b:	eb 16                	jmp    800733 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800730:	ff 4d e4             	decl   -0x1c(%ebp)
  800733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800737:	7f e4                	jg     80071d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800739:	eb 34                	jmp    80076f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073f:	74 1c                	je     80075d <vprintfmt+0x207>
  800741:	83 fb 1f             	cmp    $0x1f,%ebx
  800744:	7e 05                	jle    80074b <vprintfmt+0x1f5>
  800746:	83 fb 7e             	cmp    $0x7e,%ebx
  800749:	7e 12                	jle    80075d <vprintfmt+0x207>
					putch('?', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	6a 3f                	push   $0x3f
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb 0f                	jmp    80076c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	89 f0                	mov    %esi,%eax
  800771:	8d 70 01             	lea    0x1(%eax),%esi
  800774:	8a 00                	mov    (%eax),%al
  800776:	0f be d8             	movsbl %al,%ebx
  800779:	85 db                	test   %ebx,%ebx
  80077b:	74 24                	je     8007a1 <vprintfmt+0x24b>
  80077d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800781:	78 b8                	js     80073b <vprintfmt+0x1e5>
  800783:	ff 4d e0             	decl   -0x20(%ebp)
  800786:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078a:	79 af                	jns    80073b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078c:	eb 13                	jmp    8007a1 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	6a 20                	push   $0x20
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a5:	7f e7                	jg     80078e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a7:	e9 66 01 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 3c fd ff ff       	call   8004f7 <getint>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	79 23                	jns    8007f1 <vprintfmt+0x29b>
				putch('-', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 2d                	push   $0x2d
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e4:	f7 d8                	neg    %eax
  8007e6:	83 d2 00             	adc    $0x0,%edx
  8007e9:	f7 da                	neg    %edx
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f8:	e9 bc 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 e8             	pushl  -0x18(%ebp)
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	e8 84 fc ff ff       	call   800490 <getuint>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800815:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081c:	e9 98 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	6a 58                	push   $0x58
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	6a 58                	push   $0x58
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	6a 58                	push   $0x58
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			break;
  800851:	e9 bc 00 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	6a 30                	push   $0x30
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	6a 78                	push   $0x78
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800891:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800898:	eb 1f                	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a3:	50                   	push   %eax
  8008a4:	e8 e7 fb ff ff       	call   800490 <getuint>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	52                   	push   %edx
  8008c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	e8 00 fb ff ff       	call   8003d9 <printnum>
  8008d9:	83 c4 20             	add    $0x20,%esp
			break;
  8008dc:	eb 34                	jmp    800912 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
			break;
  8008ed:	eb 23                	jmp    800912 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	6a 25                	push   $0x25
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ff:	ff 4d 10             	decl   0x10(%ebp)
  800902:	eb 03                	jmp    800907 <vprintfmt+0x3b1>
  800904:	ff 4d 10             	decl   0x10(%ebp)
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	48                   	dec    %eax
  80090b:	8a 00                	mov    (%eax),%al
  80090d:	3c 25                	cmp    $0x25,%al
  80090f:	75 f3                	jne    800904 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800911:	90                   	nop
		}
	}
  800912:	e9 47 fc ff ff       	jmp    80055e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800917:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800925:	8d 45 10             	lea    0x10(%ebp),%eax
  800928:	83 c0 04             	add    $0x4,%eax
  80092b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	ff 75 f4             	pushl  -0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 16 fc ff ff       	call   800556 <vprintfmt>
  800940:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800943:	90                   	nop
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	8b 40 08             	mov    0x8(%eax),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 10                	mov    (%eax),%edx
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	39 c2                	cmp    %eax,%edx
  800965:	73 12                	jae    800979 <sprintputch+0x33>
		*b->buf++ = ch;
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 48 01             	lea    0x1(%eax),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800972:	89 0a                	mov    %ecx,(%edx)
  800974:	8b 55 08             	mov    0x8(%ebp),%edx
  800977:	88 10                	mov    %dl,(%eax)
}
  800979:	90                   	nop
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a1:	74 06                	je     8009a9 <vsnprintf+0x2d>
  8009a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a7:	7f 07                	jg     8009b0 <vsnprintf+0x34>
		return -E_INVAL;
  8009a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ae:	eb 20                	jmp    8009d0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 46 09 80 00       	push   $0x800946
  8009bf:	e8 92 fb ff ff       	call   800556 <vprintfmt>
  8009c4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 89 ff ff ff       	call   80097c <vsnprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0b:	eb 06                	jmp    800a13 <strlen+0x15>
		n++;
  800a0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a10:	ff 45 08             	incl   0x8(%ebp)
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	84 c0                	test   %al,%al
  800a1a:	75 f1                	jne    800a0d <strlen+0xf>
		n++;
	return n;
  800a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2e:	eb 09                	jmp    800a39 <strnlen+0x18>
		n++;
  800a30:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a33:	ff 45 08             	incl   0x8(%ebp)
  800a36:	ff 4d 0c             	decl   0xc(%ebp)
  800a39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3d:	74 09                	je     800a48 <strnlen+0x27>
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e8                	jne    800a30 <strnlen+0xf>
		n++;
	return n;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a59:	90                   	nop
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8d 50 01             	lea    0x1(%eax),%edx
  800a60:	89 55 08             	mov    %edx,0x8(%ebp)
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6c:	8a 12                	mov    (%edx),%dl
  800a6e:	88 10                	mov    %dl,(%eax)
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	84 c0                	test   %al,%al
  800a74:	75 e4                	jne    800a5a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8e:	eb 1f                	jmp    800aaf <strncpy+0x34>
		*dst++ = *src;
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8d 50 01             	lea    0x1(%eax),%edx
  800a96:	89 55 08             	mov    %edx,0x8(%ebp)
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	8a 12                	mov    (%edx),%dl
  800a9e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	84 c0                	test   %al,%al
  800aa7:	74 03                	je     800aac <strncpy+0x31>
			src++;
  800aa9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aac:	ff 45 fc             	incl   -0x4(%ebp)
  800aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab5:	72 d9                	jb     800a90 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acc:	74 30                	je     800afe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ace:	eb 16                	jmp    800ae6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8d 50 01             	lea    0x1(%eax),%edx
  800ad6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800adf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae2:	8a 12                	mov    (%edx),%dl
  800ae4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae6:	ff 4d 10             	decl   0x10(%ebp)
  800ae9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aed:	74 09                	je     800af8 <strlcpy+0x3c>
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	75 d8                	jne    800ad0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b04:	29 c2                	sub    %eax,%edx
  800b06:	89 d0                	mov    %edx,%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0d:	eb 06                	jmp    800b15 <strcmp+0xb>
		p++, q++;
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	74 0e                	je     800b2c <strcmp+0x22>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 10                	mov    (%eax),%dl
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	38 c2                	cmp    %al,%dl
  800b2a:	74 e3                	je     800b0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	0f b6 d0             	movzbl %al,%edx
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f b6 c0             	movzbl %al,%eax
  800b3c:	29 c2                	sub    %eax,%edx
  800b3e:	89 d0                	mov    %edx,%eax
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b45:	eb 09                	jmp    800b50 <strncmp+0xe>
		n--, p++, q++;
  800b47:	ff 4d 10             	decl   0x10(%ebp)
  800b4a:	ff 45 08             	incl   0x8(%ebp)
  800b4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b54:	74 17                	je     800b6d <strncmp+0x2b>
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	84 c0                	test   %al,%al
  800b5d:	74 0e                	je     800b6d <strncmp+0x2b>
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8a 10                	mov    (%eax),%dl
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	38 c2                	cmp    %al,%dl
  800b6b:	74 da                	je     800b47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b71:	75 07                	jne    800b7a <strncmp+0x38>
		return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	eb 14                	jmp    800b8e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	0f b6 d0             	movzbl %al,%edx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 c0             	movzbl %al,%eax
  800b8a:	29 c2                	sub    %eax,%edx
  800b8c:	89 d0                	mov    %edx,%eax
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9c:	eb 12                	jmp    800bb0 <strchr+0x20>
		if (*s == c)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8a 00                	mov    (%eax),%al
  800ba3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba6:	75 05                	jne    800bad <strchr+0x1d>
			return (char *) s;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	eb 11                	jmp    800bbe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 e5                	jne    800b9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 04             	sub    $0x4,%esp
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcc:	eb 0d                	jmp    800bdb <strfind+0x1b>
		if (*s == c)
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd6:	74 0e                	je     800be6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 ea                	jne    800bce <strfind+0xe>
  800be4:	eb 01                	jmp    800be7 <strfind+0x27>
		if (*s == c)
			break;
  800be6:	90                   	nop
	return (char *) s;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfe:	eb 0e                	jmp    800c0e <memset+0x22>
		*p++ = c;
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0e:	ff 4d f8             	decl   -0x8(%ebp)
  800c11:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c15:	79 e9                	jns    800c00 <memset+0x14>
		*p++ = c;

	return v;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2e:	eb 16                	jmp    800c46 <memcpy+0x2a>
		*d++ = *s++;
  800c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c42:	8a 12                	mov    (%edx),%dl
  800c44:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 dd                	jne    800c30 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c70:	73 50                	jae    800cc2 <memmove+0x6a>
  800c72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	01 d0                	add    %edx,%eax
  800c7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7d:	76 43                	jbe    800cc2 <memmove+0x6a>
		s += n;
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8b:	eb 10                	jmp    800c9d <memmove+0x45>
			*--d = *--s;
  800c8d:	ff 4d f8             	decl   -0x8(%ebp)
  800c90:	ff 4d fc             	decl   -0x4(%ebp)
  800c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c96:	8a 10                	mov    (%eax),%dl
  800c98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	75 e3                	jne    800c8d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800caa:	eb 23                	jmp    800ccf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbe:	8a 12                	mov    (%edx),%dl
  800cc0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	75 dd                	jne    800cac <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce6:	eb 2a                	jmp    800d12 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ceb:	8a 10                	mov    (%eax),%dl
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	38 c2                	cmp    %al,%dl
  800cf4:	74 16                	je     800d0c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 d0             	movzbl %al,%edx
  800cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 c0             	movzbl %al,%eax
  800d06:	29 c2                	sub    %eax,%edx
  800d08:	89 d0                	mov    %edx,%eax
  800d0a:	eb 18                	jmp    800d24 <memcmp+0x50>
		s1++, s2++;
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d18:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	75 c9                	jne    800ce8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d37:	eb 15                	jmp    800d4e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 d0             	movzbl %al,%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	0f b6 c0             	movzbl %al,%eax
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	74 0d                	je     800d58 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d54:	72 e3                	jb     800d39 <memfind+0x13>
  800d56:	eb 01                	jmp    800d59 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d58:	90                   	nop
	return (void *) s;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d72:	eb 03                	jmp    800d77 <strtol+0x19>
		s++;
  800d74:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 20                	cmp    $0x20,%al
  800d7e:	74 f4                	je     800d74 <strtol+0x16>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 09                	cmp    $0x9,%al
  800d87:	74 eb                	je     800d74 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 2b                	cmp    $0x2b,%al
  800d90:	75 05                	jne    800d97 <strtol+0x39>
		s++;
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	eb 13                	jmp    800daa <strtol+0x4c>
	else if (*s == '-')
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 2d                	cmp    $0x2d,%al
  800d9e:	75 0a                	jne    800daa <strtol+0x4c>
		s++, neg = 1;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	74 06                	je     800db6 <strtol+0x58>
  800db0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db4:	75 20                	jne    800dd6 <strtol+0x78>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 30                	cmp    $0x30,%al
  800dbd:	75 17                	jne    800dd6 <strtol+0x78>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	40                   	inc    %eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	3c 78                	cmp    $0x78,%al
  800dc7:	75 0d                	jne    800dd6 <strtol+0x78>
		s += 2, base = 16;
  800dc9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd4:	eb 28                	jmp    800dfe <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dda:	75 15                	jne    800df1 <strtol+0x93>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 30                	cmp    $0x30,%al
  800de3:	75 0c                	jne    800df1 <strtol+0x93>
		s++, base = 8;
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800def:	eb 0d                	jmp    800dfe <strtol+0xa0>
	else if (base == 0)
  800df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df5:	75 07                	jne    800dfe <strtol+0xa0>
		base = 10;
  800df7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3c 2f                	cmp    $0x2f,%al
  800e05:	7e 19                	jle    800e20 <strtol+0xc2>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 39                	cmp    $0x39,%al
  800e0e:	7f 10                	jg     800e20 <strtol+0xc2>
			dig = *s - '0';
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f be c0             	movsbl %al,%eax
  800e18:	83 e8 30             	sub    $0x30,%eax
  800e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1e:	eb 42                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3c 60                	cmp    $0x60,%al
  800e27:	7e 19                	jle    800e42 <strtol+0xe4>
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3c 7a                	cmp    $0x7a,%al
  800e30:	7f 10                	jg     800e42 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f be c0             	movsbl %al,%eax
  800e3a:	83 e8 57             	sub    $0x57,%eax
  800e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e40:	eb 20                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	3c 40                	cmp    $0x40,%al
  800e49:	7e 39                	jle    800e84 <strtol+0x126>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3c 5a                	cmp    $0x5a,%al
  800e52:	7f 30                	jg     800e84 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f be c0             	movsbl %al,%eax
  800e5c:	83 e8 37             	sub    $0x37,%eax
  800e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e65:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e68:	7d 19                	jge    800e83 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e79:	01 d0                	add    %edx,%eax
  800e7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7e:	e9 7b ff ff ff       	jmp    800dfe <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e83:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e88:	74 08                	je     800e92 <strtol+0x134>
		*endptr = (char *) s;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e96:	74 07                	je     800e9f <strtol+0x141>
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	f7 d8                	neg    %eax
  800e9d:	eb 03                	jmp    800ea2 <strtol+0x144>
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebc:	79 13                	jns    800ed1 <ltostr+0x2d>
	{
		neg = 1;
  800ebe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ecb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ece:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed9:	99                   	cltd   
  800eda:	f7 f9                	idiv   %ecx
  800edc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	01 d0                	add    %edx,%eax
  800eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef2:	83 c2 30             	add    $0x30,%edx
  800ef5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eff:	f7 e9                	imul   %ecx
  800f01:	c1 fa 02             	sar    $0x2,%edx
  800f04:	89 c8                	mov    %ecx,%eax
  800f06:	c1 f8 1f             	sar    $0x1f,%eax
  800f09:	29 c2                	sub    %eax,%edx
  800f0b:	89 d0                	mov    %edx,%eax
  800f0d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f18:	f7 e9                	imul   %ecx
  800f1a:	c1 fa 02             	sar    $0x2,%edx
  800f1d:	89 c8                	mov    %ecx,%eax
  800f1f:	c1 f8 1f             	sar    $0x1f,%eax
  800f22:	29 c2                	sub    %eax,%edx
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	c1 e0 02             	shl    $0x2,%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	01 c0                	add    %eax,%eax
  800f2d:	29 c1                	sub    %eax,%ecx
  800f2f:	89 ca                	mov    %ecx,%edx
  800f31:	85 d2                	test   %edx,%edx
  800f33:	75 9c                	jne    800ed1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3f:	48                   	dec    %eax
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f47:	74 3d                	je     800f86 <ltostr+0xe2>
		start = 1 ;
  800f49:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f50:	eb 34                	jmp    800f86 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	01 c2                	add    %eax,%edx
  800f67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c8                	add    %ecx,%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	01 c2                	add    %eax,%edx
  800f7b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f80:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f83:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8c:	7c c4                	jl     800f52 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 54 fa ff ff       	call   8009fe <strlen>
  800faa:	83 c4 04             	add    $0x4,%esp
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	e8 46 fa ff ff       	call   8009fe <strlen>
  800fb8:	83 c4 04             	add    $0x4,%esp
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcc:	eb 17                	jmp    800fe5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	01 c8                	add    %ecx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe2:	ff 45 fc             	incl   -0x4(%ebp)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800feb:	7c e1                	jl     800fce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffb:	eb 1f                	jmp    80101c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 c2                	add    %eax,%edx
  80100d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	01 c8                	add    %ecx,%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801019:	ff 45 f8             	incl   -0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801022:	7c d9                	jl     800ffd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	c6 00 00             	movb   $0x0,(%eax)
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8b 00                	mov    (%eax),%eax
  801043:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801055:	eb 0c                	jmp    801063 <strsplit+0x31>
			*string++ = 0;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 08             	mov    %edx,0x8(%ebp)
  801060:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 18                	je     801084 <strsplit+0x52>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	0f be c0             	movsbl %al,%eax
  801074:	50                   	push   %eax
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	e8 13 fb ff ff       	call   800b90 <strchr>
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	75 d3                	jne    801057 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	74 5a                	je     8010e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	83 f8 0f             	cmp    $0xf,%eax
  801095:	75 07                	jne    80109e <strsplit+0x6c>
		{
			return 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	eb 66                	jmp    801104 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a9:	89 0a                	mov    %ecx,(%edx)
  8010ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bc:	eb 03                	jmp    8010c1 <strsplit+0x8f>
			string++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 8b                	je     801055 <strsplit+0x23>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	e8 b5 fa ff ff       	call   800b90 <strchr>
  8010db:	83 c4 08             	add    $0x8,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	74 dc                	je     8010be <strsplit+0x8c>
			string++;
	}
  8010e2:	e9 6e ff ff ff       	jmp    801055 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110c:	a1 04 40 80 00       	mov    0x804004,%eax
  801111:	85 c0                	test   %eax,%eax
  801113:	74 1f                	je     801134 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801115:	e8 1d 00 00 00       	call   801137 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	68 90 37 80 00       	push   $0x803790
  801122:	e8 55 f2 ff ff       	call   80037c <cprintf>
  801127:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80112a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801131:	00 00 00 
	}
}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80113d:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801144:	00 00 00 
  801147:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80114e:	00 00 00 
  801151:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801158:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80115b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801162:	00 00 00 
  801165:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80116c:	00 00 00 
  80116f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801176:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801179:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801183:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801188:	2d 00 10 00 00       	sub    $0x1000,%eax
  80118d:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801192:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801199:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80119c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8011a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a6:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8011ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b6:	f7 75 f0             	divl   -0x10(%ebp)
  8011b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011bc:	29 d0                	sub    %edx,%eax
  8011be:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8011c1:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011d5:	83 ec 04             	sub    $0x4,%esp
  8011d8:	6a 06                	push   $0x6
  8011da:	ff 75 e8             	pushl  -0x18(%ebp)
  8011dd:	50                   	push   %eax
  8011de:	e8 d4 05 00 00       	call   8017b7 <sys_allocate_chunk>
  8011e3:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011e6:	a1 20 41 80 00       	mov    0x804120,%eax
  8011eb:	83 ec 0c             	sub    $0xc,%esp
  8011ee:	50                   	push   %eax
  8011ef:	e8 49 0c 00 00       	call   801e3d <initialize_MemBlocksList>
  8011f4:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8011f7:	a1 48 41 80 00       	mov    0x804148,%eax
  8011fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8011ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801203:	75 14                	jne    801219 <initialize_dyn_block_system+0xe2>
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	68 b5 37 80 00       	push   $0x8037b5
  80120d:	6a 39                	push   $0x39
  80120f:	68 d3 37 80 00       	push   $0x8037d3
  801214:	e8 86 1c 00 00       	call   802e9f <_panic>
  801219:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121c:	8b 00                	mov    (%eax),%eax
  80121e:	85 c0                	test   %eax,%eax
  801220:	74 10                	je     801232 <initialize_dyn_block_system+0xfb>
  801222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801225:	8b 00                	mov    (%eax),%eax
  801227:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80122a:	8b 52 04             	mov    0x4(%edx),%edx
  80122d:	89 50 04             	mov    %edx,0x4(%eax)
  801230:	eb 0b                	jmp    80123d <initialize_dyn_block_system+0x106>
  801232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801235:	8b 40 04             	mov    0x4(%eax),%eax
  801238:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80123d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801240:	8b 40 04             	mov    0x4(%eax),%eax
  801243:	85 c0                	test   %eax,%eax
  801245:	74 0f                	je     801256 <initialize_dyn_block_system+0x11f>
  801247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80124a:	8b 40 04             	mov    0x4(%eax),%eax
  80124d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801250:	8b 12                	mov    (%edx),%edx
  801252:	89 10                	mov    %edx,(%eax)
  801254:	eb 0a                	jmp    801260 <initialize_dyn_block_system+0x129>
  801256:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801259:	8b 00                	mov    (%eax),%eax
  80125b:	a3 48 41 80 00       	mov    %eax,0x804148
  801260:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801269:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801273:	a1 54 41 80 00       	mov    0x804154,%eax
  801278:	48                   	dec    %eax
  801279:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80127e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801281:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801288:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801292:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801296:	75 14                	jne    8012ac <initialize_dyn_block_system+0x175>
  801298:	83 ec 04             	sub    $0x4,%esp
  80129b:	68 e0 37 80 00       	push   $0x8037e0
  8012a0:	6a 3f                	push   $0x3f
  8012a2:	68 d3 37 80 00       	push   $0x8037d3
  8012a7:	e8 f3 1b 00 00       	call   802e9f <_panic>
  8012ac:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8012b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b5:	89 10                	mov    %edx,(%eax)
  8012b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ba:	8b 00                	mov    (%eax),%eax
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	74 0d                	je     8012cd <initialize_dyn_block_system+0x196>
  8012c0:	a1 38 41 80 00       	mov    0x804138,%eax
  8012c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012c8:	89 50 04             	mov    %edx,0x4(%eax)
  8012cb:	eb 08                	jmp    8012d5 <initialize_dyn_block_system+0x19e>
  8012cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012d8:	a3 38 41 80 00       	mov    %eax,0x804138
  8012dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012e7:	a1 44 41 80 00       	mov    0x804144,%eax
  8012ec:	40                   	inc    %eax
  8012ed:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8012f2:	90                   	nop
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012fb:	e8 06 fe ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  801300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801304:	75 07                	jne    80130d <malloc+0x18>
  801306:	b8 00 00 00 00       	mov    $0x0,%eax
  80130b:	eb 7d                	jmp    80138a <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80130d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801314:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80131b:	8b 55 08             	mov    0x8(%ebp),%edx
  80131e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801321:	01 d0                	add    %edx,%eax
  801323:	48                   	dec    %eax
  801324:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801327:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80132a:	ba 00 00 00 00       	mov    $0x0,%edx
  80132f:	f7 75 f0             	divl   -0x10(%ebp)
  801332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801335:	29 d0                	sub    %edx,%eax
  801337:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  80133a:	e8 46 08 00 00       	call   801b85 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80133f:	83 f8 01             	cmp    $0x1,%eax
  801342:	75 07                	jne    80134b <malloc+0x56>
  801344:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  80134b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80134f:	75 34                	jne    801385 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801351:	83 ec 0c             	sub    $0xc,%esp
  801354:	ff 75 e8             	pushl  -0x18(%ebp)
  801357:	e8 73 0e 00 00       	call   8021cf <alloc_block_FF>
  80135c:	83 c4 10             	add    $0x10,%esp
  80135f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801362:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801366:	74 16                	je     80137e <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801368:	83 ec 0c             	sub    $0xc,%esp
  80136b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80136e:	e8 ff 0b 00 00       	call   801f72 <insert_sorted_allocList>
  801373:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801379:	8b 40 08             	mov    0x8(%eax),%eax
  80137c:	eb 0c                	jmp    80138a <malloc+0x95>
	             }
	             else
	             	return NULL;
  80137e:	b8 00 00 00 00       	mov    $0x0,%eax
  801383:	eb 05                	jmp    80138a <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801385:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80139e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a6:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8013a9:	83 ec 08             	sub    $0x8,%esp
  8013ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8013af:	68 40 40 80 00       	push   $0x804040
  8013b4:	e8 61 0b 00 00       	call   801f1a <find_block>
  8013b9:	83 c4 10             	add    $0x10,%esp
  8013bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8013bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013c3:	0f 84 a5 00 00 00    	je     80146e <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8013c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8013cf:	83 ec 08             	sub    $0x8,%esp
  8013d2:	50                   	push   %eax
  8013d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013d6:	e8 a4 03 00 00       	call   80177f <sys_free_user_mem>
  8013db:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8013de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013e2:	75 17                	jne    8013fb <free+0x6f>
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	68 b5 37 80 00       	push   $0x8037b5
  8013ec:	68 87 00 00 00       	push   $0x87
  8013f1:	68 d3 37 80 00       	push   $0x8037d3
  8013f6:	e8 a4 1a 00 00       	call   802e9f <_panic>
  8013fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013fe:	8b 00                	mov    (%eax),%eax
  801400:	85 c0                	test   %eax,%eax
  801402:	74 10                	je     801414 <free+0x88>
  801404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801407:	8b 00                	mov    (%eax),%eax
  801409:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80140c:	8b 52 04             	mov    0x4(%edx),%edx
  80140f:	89 50 04             	mov    %edx,0x4(%eax)
  801412:	eb 0b                	jmp    80141f <free+0x93>
  801414:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801417:	8b 40 04             	mov    0x4(%eax),%eax
  80141a:	a3 44 40 80 00       	mov    %eax,0x804044
  80141f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801422:	8b 40 04             	mov    0x4(%eax),%eax
  801425:	85 c0                	test   %eax,%eax
  801427:	74 0f                	je     801438 <free+0xac>
  801429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80142c:	8b 40 04             	mov    0x4(%eax),%eax
  80142f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801432:	8b 12                	mov    (%edx),%edx
  801434:	89 10                	mov    %edx,(%eax)
  801436:	eb 0a                	jmp    801442 <free+0xb6>
  801438:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143b:	8b 00                	mov    (%eax),%eax
  80143d:	a3 40 40 80 00       	mov    %eax,0x804040
  801442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80144b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80144e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801455:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80145a:	48                   	dec    %eax
  80145b:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801460:	83 ec 0c             	sub    $0xc,%esp
  801463:	ff 75 ec             	pushl  -0x14(%ebp)
  801466:	e8 37 12 00 00       	call   8026a2 <insert_sorted_with_merge_freeList>
  80146b:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80146e:	90                   	nop
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
  801474:	83 ec 38             	sub    $0x38,%esp
  801477:	8b 45 10             	mov    0x10(%ebp),%eax
  80147a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80147d:	e8 84 fc ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  801482:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801486:	75 07                	jne    80148f <smalloc+0x1e>
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
  80148d:	eb 7e                	jmp    80150d <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80148f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801496:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80149d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	48                   	dec    %eax
  8014a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b1:	f7 75 f0             	divl   -0x10(%ebp)
  8014b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014b7:	29 d0                	sub    %edx,%eax
  8014b9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8014bc:	e8 c4 06 00 00       	call   801b85 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014c1:	83 f8 01             	cmp    $0x1,%eax
  8014c4:	75 42                	jne    801508 <smalloc+0x97>

		  va = malloc(newsize) ;
  8014c6:	83 ec 0c             	sub    $0xc,%esp
  8014c9:	ff 75 e8             	pushl  -0x18(%ebp)
  8014cc:	e8 24 fe ff ff       	call   8012f5 <malloc>
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8014d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014db:	74 24                	je     801501 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8014dd:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014e4:	50                   	push   %eax
  8014e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8014e8:	ff 75 08             	pushl  0x8(%ebp)
  8014eb:	e8 1a 04 00 00       	call   80190a <sys_createSharedObject>
  8014f0:	83 c4 10             	add    $0x10,%esp
  8014f3:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8014f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014fa:	78 0c                	js     801508 <smalloc+0x97>
					  return va ;
  8014fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ff:	eb 0c                	jmp    80150d <smalloc+0x9c>
				 }
				 else
					return NULL;
  801501:	b8 00 00 00 00       	mov    $0x0,%eax
  801506:	eb 05                	jmp    80150d <smalloc+0x9c>
	  }
		  return NULL ;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
  801512:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801515:	e8 ec fb ff ff       	call   801106 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	ff 75 0c             	pushl  0xc(%ebp)
  801520:	ff 75 08             	pushl  0x8(%ebp)
  801523:	e8 0c 04 00 00       	call   801934 <sys_getSizeOfSharedObject>
  801528:	83 c4 10             	add    $0x10,%esp
  80152b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80152e:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801532:	75 07                	jne    80153b <sget+0x2c>
  801534:	b8 00 00 00 00       	mov    $0x0,%eax
  801539:	eb 75                	jmp    8015b0 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80153b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801542:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801548:	01 d0                	add    %edx,%eax
  80154a:	48                   	dec    %eax
  80154b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80154e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801551:	ba 00 00 00 00       	mov    $0x0,%edx
  801556:	f7 75 f0             	divl   -0x10(%ebp)
  801559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155c:	29 d0                	sub    %edx,%eax
  80155e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801561:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801568:	e8 18 06 00 00       	call   801b85 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80156d:	83 f8 01             	cmp    $0x1,%eax
  801570:	75 39                	jne    8015ab <sget+0x9c>

		  va = malloc(newsize) ;
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	ff 75 e8             	pushl  -0x18(%ebp)
  801578:	e8 78 fd ff ff       	call   8012f5 <malloc>
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801583:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801587:	74 22                	je     8015ab <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	ff 75 e0             	pushl  -0x20(%ebp)
  80158f:	ff 75 0c             	pushl  0xc(%ebp)
  801592:	ff 75 08             	pushl  0x8(%ebp)
  801595:	e8 b7 03 00 00       	call   801951 <sys_getSharedObject>
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8015a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015a4:	78 05                	js     8015ab <sget+0x9c>
					  return va;
  8015a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a9:	eb 05                	jmp    8015b0 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b8:	e8 49 fb ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015bd:	83 ec 04             	sub    $0x4,%esp
  8015c0:	68 04 38 80 00       	push   $0x803804
  8015c5:	68 1e 01 00 00       	push   $0x11e
  8015ca:	68 d3 37 80 00       	push   $0x8037d3
  8015cf:	e8 cb 18 00 00       	call   802e9f <_panic>

008015d4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	68 2c 38 80 00       	push   $0x80382c
  8015e2:	68 32 01 00 00       	push   $0x132
  8015e7:	68 d3 37 80 00       	push   $0x8037d3
  8015ec:	e8 ae 18 00 00       	call   802e9f <_panic>

008015f1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f7:	83 ec 04             	sub    $0x4,%esp
  8015fa:	68 50 38 80 00       	push   $0x803850
  8015ff:	68 3d 01 00 00       	push   $0x13d
  801604:	68 d3 37 80 00       	push   $0x8037d3
  801609:	e8 91 18 00 00       	call   802e9f <_panic>

0080160e <shrink>:

}
void shrink(uint32 newSize)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	68 50 38 80 00       	push   $0x803850
  80161c:	68 42 01 00 00       	push   $0x142
  801621:	68 d3 37 80 00       	push   $0x8037d3
  801626:	e8 74 18 00 00       	call   802e9f <_panic>

0080162b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	68 50 38 80 00       	push   $0x803850
  801639:	68 47 01 00 00       	push   $0x147
  80163e:	68 d3 37 80 00       	push   $0x8037d3
  801643:	e8 57 18 00 00       	call   802e9f <_panic>

00801648 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
  80164b:	57                   	push   %edi
  80164c:	56                   	push   %esi
  80164d:	53                   	push   %ebx
  80164e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	8b 55 0c             	mov    0xc(%ebp),%edx
  801657:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80165d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801660:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801663:	cd 30                	int    $0x30
  801665:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801668:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	5b                   	pop    %ebx
  80166f:	5e                   	pop    %esi
  801670:	5f                   	pop    %edi
  801671:	5d                   	pop    %ebp
  801672:	c3                   	ret    

00801673 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	8b 45 10             	mov    0x10(%ebp),%eax
  80167c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80167f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	52                   	push   %edx
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	50                   	push   %eax
  80168f:	6a 00                	push   $0x0
  801691:	e8 b2 ff ff ff       	call   801648 <syscall>
  801696:	83 c4 18             	add    $0x18,%esp
}
  801699:	90                   	nop
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_cgetc>:

int
sys_cgetc(void)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 01                	push   $0x1
  8016ab:	e8 98 ff ff ff       	call   801648 <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	52                   	push   %edx
  8016c5:	50                   	push   %eax
  8016c6:	6a 05                	push   $0x5
  8016c8:	e8 7b ff ff ff       	call   801648 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	56                   	push   %esi
  8016d6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8016da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	51                   	push   %ecx
  8016e9:	52                   	push   %edx
  8016ea:	50                   	push   %eax
  8016eb:	6a 06                	push   $0x6
  8016ed:	e8 56 ff ff ff       	call   801648 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f8:	5b                   	pop    %ebx
  8016f9:	5e                   	pop    %esi
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    

008016fc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	52                   	push   %edx
  80170c:	50                   	push   %eax
  80170d:	6a 07                	push   $0x7
  80170f:	e8 34 ff ff ff       	call   801648 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	ff 75 0c             	pushl  0xc(%ebp)
  801725:	ff 75 08             	pushl  0x8(%ebp)
  801728:	6a 08                	push   $0x8
  80172a:	e8 19 ff ff ff       	call   801648 <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 09                	push   $0x9
  801743:	e8 00 ff ff ff       	call   801648 <syscall>
  801748:	83 c4 18             	add    $0x18,%esp
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 0a                	push   $0xa
  80175c:	e8 e7 fe ff ff       	call   801648 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 0b                	push   $0xb
  801775:	e8 ce fe ff ff       	call   801648 <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	ff 75 0c             	pushl  0xc(%ebp)
  80178b:	ff 75 08             	pushl  0x8(%ebp)
  80178e:	6a 0f                	push   $0xf
  801790:	e8 b3 fe ff ff       	call   801648 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
	return;
  801798:	90                   	nop
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	ff 75 08             	pushl  0x8(%ebp)
  8017aa:	6a 10                	push   $0x10
  8017ac:	e8 97 fe ff ff       	call   801648 <syscall>
  8017b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b4:	90                   	nop
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	ff 75 10             	pushl  0x10(%ebp)
  8017c1:	ff 75 0c             	pushl  0xc(%ebp)
  8017c4:	ff 75 08             	pushl  0x8(%ebp)
  8017c7:	6a 11                	push   $0x11
  8017c9:	e8 7a fe ff ff       	call   801648 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d1:	90                   	nop
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 0c                	push   $0xc
  8017e3:	e8 60 fe ff ff       	call   801648 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	ff 75 08             	pushl  0x8(%ebp)
  8017fb:	6a 0d                	push   $0xd
  8017fd:	e8 46 fe ff ff       	call   801648 <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 0e                	push   $0xe
  801816:	e8 2d fe ff ff       	call   801648 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	90                   	nop
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 13                	push   $0x13
  801830:	e8 13 fe ff ff       	call   801648 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	90                   	nop
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 14                	push   $0x14
  80184a:	e8 f9 fd ff ff       	call   801648 <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	90                   	nop
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_cputc>:


void
sys_cputc(const char c)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 04             	sub    $0x4,%esp
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801861:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	50                   	push   %eax
  80186e:	6a 15                	push   $0x15
  801870:	e8 d3 fd ff ff       	call   801648 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	90                   	nop
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 16                	push   $0x16
  80188a:	e8 b9 fd ff ff       	call   801648 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	90                   	nop
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	ff 75 0c             	pushl  0xc(%ebp)
  8018a4:	50                   	push   %eax
  8018a5:	6a 17                	push   $0x17
  8018a7:	e8 9c fd ff ff       	call   801648 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	52                   	push   %edx
  8018c1:	50                   	push   %eax
  8018c2:	6a 1a                	push   $0x1a
  8018c4:	e8 7f fd ff ff       	call   801648 <syscall>
  8018c9:	83 c4 18             	add    $0x18,%esp
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	52                   	push   %edx
  8018de:	50                   	push   %eax
  8018df:	6a 18                	push   $0x18
  8018e1:	e8 62 fd ff ff       	call   801648 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	90                   	nop
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	52                   	push   %edx
  8018fc:	50                   	push   %eax
  8018fd:	6a 19                	push   $0x19
  8018ff:	e8 44 fd ff ff       	call   801648 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	90                   	nop
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	8b 45 10             	mov    0x10(%ebp),%eax
  801913:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801916:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801919:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	51                   	push   %ecx
  801923:	52                   	push   %edx
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	50                   	push   %eax
  801928:	6a 1b                	push   $0x1b
  80192a:	e8 19 fd ff ff       	call   801648 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 45 08             	mov    0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 1c                	push   $0x1c
  801947:	e8 fc fc ff ff       	call   801648 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801954:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	51                   	push   %ecx
  801962:	52                   	push   %edx
  801963:	50                   	push   %eax
  801964:	6a 1d                	push   $0x1d
  801966:	e8 dd fc ff ff       	call   801648 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	52                   	push   %edx
  801980:	50                   	push   %eax
  801981:	6a 1e                	push   $0x1e
  801983:	e8 c0 fc ff ff       	call   801648 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 1f                	push   $0x1f
  80199c:	e8 a7 fc ff ff       	call   801648 <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	ff 75 14             	pushl  0x14(%ebp)
  8019b1:	ff 75 10             	pushl  0x10(%ebp)
  8019b4:	ff 75 0c             	pushl  0xc(%ebp)
  8019b7:	50                   	push   %eax
  8019b8:	6a 20                	push   $0x20
  8019ba:	e8 89 fc ff ff       	call   801648 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	50                   	push   %eax
  8019d3:	6a 21                	push   $0x21
  8019d5:	e8 6e fc ff ff       	call   801648 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	90                   	nop
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	50                   	push   %eax
  8019ef:	6a 22                	push   $0x22
  8019f1:	e8 52 fc ff ff       	call   801648 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 02                	push   $0x2
  801a0a:	e8 39 fc ff ff       	call   801648 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 03                	push   $0x3
  801a23:	e8 20 fc ff ff       	call   801648 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 04                	push   $0x4
  801a3c:	e8 07 fc ff ff       	call   801648 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_exit_env>:


void sys_exit_env(void)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 23                	push   $0x23
  801a55:	e8 ee fb ff ff       	call   801648 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	90                   	nop
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a66:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a69:	8d 50 04             	lea    0x4(%eax),%edx
  801a6c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	52                   	push   %edx
  801a76:	50                   	push   %eax
  801a77:	6a 24                	push   $0x24
  801a79:	e8 ca fb ff ff       	call   801648 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
	return result;
  801a81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a87:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8a:	89 01                	mov    %eax,(%ecx)
  801a8c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	c9                   	leave  
  801a93:	c2 04 00             	ret    $0x4

00801a96 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	ff 75 10             	pushl  0x10(%ebp)
  801aa0:	ff 75 0c             	pushl  0xc(%ebp)
  801aa3:	ff 75 08             	pushl  0x8(%ebp)
  801aa6:	6a 12                	push   $0x12
  801aa8:	e8 9b fb ff ff       	call   801648 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab0:	90                   	nop
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 25                	push   $0x25
  801ac2:	e8 81 fb ff ff       	call   801648 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	83 ec 04             	sub    $0x4,%esp
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ad8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	50                   	push   %eax
  801ae5:	6a 26                	push   $0x26
  801ae7:	e8 5c fb ff ff       	call   801648 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
	return ;
  801aef:	90                   	nop
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <rsttst>:
void rsttst()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 28                	push   $0x28
  801b01:	e8 42 fb ff ff       	call   801648 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
	return ;
  801b09:	90                   	nop
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 04             	sub    $0x4,%esp
  801b12:	8b 45 14             	mov    0x14(%ebp),%eax
  801b15:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b18:	8b 55 18             	mov    0x18(%ebp),%edx
  801b1b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b1f:	52                   	push   %edx
  801b20:	50                   	push   %eax
  801b21:	ff 75 10             	pushl  0x10(%ebp)
  801b24:	ff 75 0c             	pushl  0xc(%ebp)
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	6a 27                	push   $0x27
  801b2c:	e8 17 fb ff ff       	call   801648 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
	return ;
  801b34:	90                   	nop
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <chktst>:
void chktst(uint32 n)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	6a 29                	push   $0x29
  801b47:	e8 fc fa ff ff       	call   801648 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4f:	90                   	nop
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <inctst>:

void inctst()
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 2a                	push   $0x2a
  801b61:	e8 e2 fa ff ff       	call   801648 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
	return ;
  801b69:	90                   	nop
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <gettst>:
uint32 gettst()
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 2b                	push   $0x2b
  801b7b:	e8 c8 fa ff ff       	call   801648 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 2c                	push   $0x2c
  801b97:	e8 ac fa ff ff       	call   801648 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
  801b9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ba2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ba6:	75 07                	jne    801baf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ba8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bad:	eb 05                	jmp    801bb4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801baf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 2c                	push   $0x2c
  801bc8:	e8 7b fa ff ff       	call   801648 <syscall>
  801bcd:	83 c4 18             	add    $0x18,%esp
  801bd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bd3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bd7:	75 07                	jne    801be0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bde:	eb 05                	jmp    801be5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801be0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 2c                	push   $0x2c
  801bf9:	e8 4a fa ff ff       	call   801648 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
  801c01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c04:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c08:	75 07                	jne    801c11 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0f:	eb 05                	jmp    801c16 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 2c                	push   $0x2c
  801c2a:	e8 19 fa ff ff       	call   801648 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
  801c32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c35:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c39:	75 07                	jne    801c42 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c40:	eb 05                	jmp    801c47 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	ff 75 08             	pushl  0x8(%ebp)
  801c57:	6a 2d                	push   $0x2d
  801c59:	e8 ea f9 ff ff       	call   801648 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c61:	90                   	nop
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	6a 00                	push   $0x0
  801c76:	53                   	push   %ebx
  801c77:	51                   	push   %ecx
  801c78:	52                   	push   %edx
  801c79:	50                   	push   %eax
  801c7a:	6a 2e                	push   $0x2e
  801c7c:	e8 c7 f9 ff ff       	call   801648 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	52                   	push   %edx
  801c99:	50                   	push   %eax
  801c9a:	6a 2f                	push   $0x2f
  801c9c:	e8 a7 f9 ff ff       	call   801648 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cac:	83 ec 0c             	sub    $0xc,%esp
  801caf:	68 60 38 80 00       	push   $0x803860
  801cb4:	e8 c3 e6 ff ff       	call   80037c <cprintf>
  801cb9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cbc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cc3:	83 ec 0c             	sub    $0xc,%esp
  801cc6:	68 8c 38 80 00       	push   $0x80388c
  801ccb:	e8 ac e6 ff ff       	call   80037c <cprintf>
  801cd0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cd3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd7:	a1 38 41 80 00       	mov    0x804138,%eax
  801cdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cdf:	eb 56                	jmp    801d37 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ce1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ce5:	74 1c                	je     801d03 <print_mem_block_lists+0x5d>
  801ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cea:	8b 50 08             	mov    0x8(%eax),%edx
  801ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf0:	8b 48 08             	mov    0x8(%eax),%ecx
  801cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf9:	01 c8                	add    %ecx,%eax
  801cfb:	39 c2                	cmp    %eax,%edx
  801cfd:	73 04                	jae    801d03 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cff:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d06:	8b 50 08             	mov    0x8(%eax),%edx
  801d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0f:	01 c2                	add    %eax,%edx
  801d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d14:	8b 40 08             	mov    0x8(%eax),%eax
  801d17:	83 ec 04             	sub    $0x4,%esp
  801d1a:	52                   	push   %edx
  801d1b:	50                   	push   %eax
  801d1c:	68 a1 38 80 00       	push   $0x8038a1
  801d21:	e8 56 e6 ff ff       	call   80037c <cprintf>
  801d26:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d2f:	a1 40 41 80 00       	mov    0x804140,%eax
  801d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d3b:	74 07                	je     801d44 <print_mem_block_lists+0x9e>
  801d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d40:	8b 00                	mov    (%eax),%eax
  801d42:	eb 05                	jmp    801d49 <print_mem_block_lists+0xa3>
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
  801d49:	a3 40 41 80 00       	mov    %eax,0x804140
  801d4e:	a1 40 41 80 00       	mov    0x804140,%eax
  801d53:	85 c0                	test   %eax,%eax
  801d55:	75 8a                	jne    801ce1 <print_mem_block_lists+0x3b>
  801d57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5b:	75 84                	jne    801ce1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d5d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d61:	75 10                	jne    801d73 <print_mem_block_lists+0xcd>
  801d63:	83 ec 0c             	sub    $0xc,%esp
  801d66:	68 b0 38 80 00       	push   $0x8038b0
  801d6b:	e8 0c e6 ff ff       	call   80037c <cprintf>
  801d70:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	68 d4 38 80 00       	push   $0x8038d4
  801d82:	e8 f5 e5 ff ff       	call   80037c <cprintf>
  801d87:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d8a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d8e:	a1 40 40 80 00       	mov    0x804040,%eax
  801d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d96:	eb 56                	jmp    801dee <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d9c:	74 1c                	je     801dba <print_mem_block_lists+0x114>
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	8b 50 08             	mov    0x8(%eax),%edx
  801da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da7:	8b 48 08             	mov    0x8(%eax),%ecx
  801daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dad:	8b 40 0c             	mov    0xc(%eax),%eax
  801db0:	01 c8                	add    %ecx,%eax
  801db2:	39 c2                	cmp    %eax,%edx
  801db4:	73 04                	jae    801dba <print_mem_block_lists+0x114>
			sorted = 0 ;
  801db6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbd:	8b 50 08             	mov    0x8(%eax),%edx
  801dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc6:	01 c2                	add    %eax,%edx
  801dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcb:	8b 40 08             	mov    0x8(%eax),%eax
  801dce:	83 ec 04             	sub    $0x4,%esp
  801dd1:	52                   	push   %edx
  801dd2:	50                   	push   %eax
  801dd3:	68 a1 38 80 00       	push   $0x8038a1
  801dd8:	e8 9f e5 ff ff       	call   80037c <cprintf>
  801ddd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801de6:	a1 48 40 80 00       	mov    0x804048,%eax
  801deb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df2:	74 07                	je     801dfb <print_mem_block_lists+0x155>
  801df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df7:	8b 00                	mov    (%eax),%eax
  801df9:	eb 05                	jmp    801e00 <print_mem_block_lists+0x15a>
  801dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801e00:	a3 48 40 80 00       	mov    %eax,0x804048
  801e05:	a1 48 40 80 00       	mov    0x804048,%eax
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	75 8a                	jne    801d98 <print_mem_block_lists+0xf2>
  801e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e12:	75 84                	jne    801d98 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e14:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e18:	75 10                	jne    801e2a <print_mem_block_lists+0x184>
  801e1a:	83 ec 0c             	sub    $0xc,%esp
  801e1d:	68 ec 38 80 00       	push   $0x8038ec
  801e22:	e8 55 e5 ff ff       	call   80037c <cprintf>
  801e27:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e2a:	83 ec 0c             	sub    $0xc,%esp
  801e2d:	68 60 38 80 00       	push   $0x803860
  801e32:	e8 45 e5 ff ff       	call   80037c <cprintf>
  801e37:	83 c4 10             	add    $0x10,%esp

}
  801e3a:	90                   	nop
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  801e43:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e4a:	00 00 00 
  801e4d:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e54:	00 00 00 
  801e57:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e5e:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  801e61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e68:	e9 9e 00 00 00       	jmp    801f0b <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  801e6d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e75:	c1 e2 04             	shl    $0x4,%edx
  801e78:	01 d0                	add    %edx,%eax
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	75 14                	jne    801e92 <initialize_MemBlocksList+0x55>
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	68 14 39 80 00       	push   $0x803914
  801e86:	6a 47                	push   $0x47
  801e88:	68 37 39 80 00       	push   $0x803937
  801e8d:	e8 0d 10 00 00       	call   802e9f <_panic>
  801e92:	a1 50 40 80 00       	mov    0x804050,%eax
  801e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9a:	c1 e2 04             	shl    $0x4,%edx
  801e9d:	01 d0                	add    %edx,%eax
  801e9f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ea5:	89 10                	mov    %edx,(%eax)
  801ea7:	8b 00                	mov    (%eax),%eax
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	74 18                	je     801ec5 <initialize_MemBlocksList+0x88>
  801ead:	a1 48 41 80 00       	mov    0x804148,%eax
  801eb2:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801eb8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ebb:	c1 e1 04             	shl    $0x4,%ecx
  801ebe:	01 ca                	add    %ecx,%edx
  801ec0:	89 50 04             	mov    %edx,0x4(%eax)
  801ec3:	eb 12                	jmp    801ed7 <initialize_MemBlocksList+0x9a>
  801ec5:	a1 50 40 80 00       	mov    0x804050,%eax
  801eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecd:	c1 e2 04             	shl    $0x4,%edx
  801ed0:	01 d0                	add    %edx,%eax
  801ed2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ed7:	a1 50 40 80 00       	mov    0x804050,%eax
  801edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edf:	c1 e2 04             	shl    $0x4,%edx
  801ee2:	01 d0                	add    %edx,%eax
  801ee4:	a3 48 41 80 00       	mov    %eax,0x804148
  801ee9:	a1 50 40 80 00       	mov    0x804050,%eax
  801eee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef1:	c1 e2 04             	shl    $0x4,%edx
  801ef4:	01 d0                	add    %edx,%eax
  801ef6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801efd:	a1 54 41 80 00       	mov    0x804154,%eax
  801f02:	40                   	inc    %eax
  801f03:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  801f08:	ff 45 f4             	incl   -0xc(%ebp)
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f11:	0f 82 56 ff ff ff    	jb     801e6d <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  801f17:	90                   	nop
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	8b 00                	mov    (%eax),%eax
  801f25:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f28:	eb 19                	jmp    801f43 <find_block+0x29>
	{
		if(element->sva == va){
  801f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2d:	8b 40 08             	mov    0x8(%eax),%eax
  801f30:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f33:	75 05                	jne    801f3a <find_block+0x20>
			 		return element;
  801f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f38:	eb 36                	jmp    801f70 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	8b 40 08             	mov    0x8(%eax),%eax
  801f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f47:	74 07                	je     801f50 <find_block+0x36>
  801f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4c:	8b 00                	mov    (%eax),%eax
  801f4e:	eb 05                	jmp    801f55 <find_block+0x3b>
  801f50:	b8 00 00 00 00       	mov    $0x0,%eax
  801f55:	8b 55 08             	mov    0x8(%ebp),%edx
  801f58:	89 42 08             	mov    %eax,0x8(%edx)
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	8b 40 08             	mov    0x8(%eax),%eax
  801f61:	85 c0                	test   %eax,%eax
  801f63:	75 c5                	jne    801f2a <find_block+0x10>
  801f65:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f69:	75 bf                	jne    801f2a <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  801f6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  801f78:	a1 44 40 80 00       	mov    0x804044,%eax
  801f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  801f80:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f85:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  801f88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f8c:	74 0a                	je     801f98 <insert_sorted_allocList+0x26>
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	8b 40 08             	mov    0x8(%eax),%eax
  801f94:	85 c0                	test   %eax,%eax
  801f96:	75 65                	jne    801ffd <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  801f98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f9c:	75 14                	jne    801fb2 <insert_sorted_allocList+0x40>
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	68 14 39 80 00       	push   $0x803914
  801fa6:	6a 6e                	push   $0x6e
  801fa8:	68 37 39 80 00       	push   $0x803937
  801fad:	e8 ed 0e 00 00       	call   802e9f <_panic>
  801fb2:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	89 10                	mov    %edx,(%eax)
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	8b 00                	mov    (%eax),%eax
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	74 0d                	je     801fd3 <insert_sorted_allocList+0x61>
  801fc6:	a1 40 40 80 00       	mov    0x804040,%eax
  801fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fce:	89 50 04             	mov    %edx,0x4(%eax)
  801fd1:	eb 08                	jmp    801fdb <insert_sorted_allocList+0x69>
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	a3 44 40 80 00       	mov    %eax,0x804044
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	a3 40 40 80 00       	mov    %eax,0x804040
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fed:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ff2:	40                   	inc    %eax
  801ff3:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801ff8:	e9 cf 01 00 00       	jmp    8021cc <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  801ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802000:	8b 50 08             	mov    0x8(%eax),%edx
  802003:	8b 45 08             	mov    0x8(%ebp),%eax
  802006:	8b 40 08             	mov    0x8(%eax),%eax
  802009:	39 c2                	cmp    %eax,%edx
  80200b:	73 65                	jae    802072 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80200d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802011:	75 14                	jne    802027 <insert_sorted_allocList+0xb5>
  802013:	83 ec 04             	sub    $0x4,%esp
  802016:	68 50 39 80 00       	push   $0x803950
  80201b:	6a 72                	push   $0x72
  80201d:	68 37 39 80 00       	push   $0x803937
  802022:	e8 78 0e 00 00       	call   802e9f <_panic>
  802027:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	89 50 04             	mov    %edx,0x4(%eax)
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	8b 40 04             	mov    0x4(%eax),%eax
  802039:	85 c0                	test   %eax,%eax
  80203b:	74 0c                	je     802049 <insert_sorted_allocList+0xd7>
  80203d:	a1 44 40 80 00       	mov    0x804044,%eax
  802042:	8b 55 08             	mov    0x8(%ebp),%edx
  802045:	89 10                	mov    %edx,(%eax)
  802047:	eb 08                	jmp    802051 <insert_sorted_allocList+0xdf>
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	a3 40 40 80 00       	mov    %eax,0x804040
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	a3 44 40 80 00       	mov    %eax,0x804044
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802062:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802067:	40                   	inc    %eax
  802068:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80206d:	e9 5a 01 00 00       	jmp    8021cc <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802075:	8b 50 08             	mov    0x8(%eax),%edx
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	8b 40 08             	mov    0x8(%eax),%eax
  80207e:	39 c2                	cmp    %eax,%edx
  802080:	75 70                	jne    8020f2 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802082:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802086:	74 06                	je     80208e <insert_sorted_allocList+0x11c>
  802088:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80208c:	75 14                	jne    8020a2 <insert_sorted_allocList+0x130>
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	68 74 39 80 00       	push   $0x803974
  802096:	6a 75                	push   $0x75
  802098:	68 37 39 80 00       	push   $0x803937
  80209d:	e8 fd 0d 00 00       	call   802e9f <_panic>
  8020a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a5:	8b 10                	mov    (%eax),%edx
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	89 10                	mov    %edx,(%eax)
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	8b 00                	mov    (%eax),%eax
  8020b1:	85 c0                	test   %eax,%eax
  8020b3:	74 0b                	je     8020c0 <insert_sorted_allocList+0x14e>
  8020b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b8:	8b 00                	mov    (%eax),%eax
  8020ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bd:	89 50 04             	mov    %edx,0x4(%eax)
  8020c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c6:	89 10                	mov    %edx,(%eax)
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020ce:	89 50 04             	mov    %edx,0x4(%eax)
  8020d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d4:	8b 00                	mov    (%eax),%eax
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	75 08                	jne    8020e2 <insert_sorted_allocList+0x170>
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	a3 44 40 80 00       	mov    %eax,0x804044
  8020e2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020e7:	40                   	inc    %eax
  8020e8:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8020ed:	e9 da 00 00 00       	jmp    8021cc <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8020f2:	a1 40 40 80 00       	mov    0x804040,%eax
  8020f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fa:	e9 9d 00 00 00       	jmp    80219c <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	8b 00                	mov    (%eax),%eax
  802104:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	8b 50 08             	mov    0x8(%eax),%edx
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 40 08             	mov    0x8(%eax),%eax
  802113:	39 c2                	cmp    %eax,%edx
  802115:	76 7d                	jbe    802194 <insert_sorted_allocList+0x222>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8b 50 08             	mov    0x8(%eax),%edx
  80211d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802120:	8b 40 08             	mov    0x8(%eax),%eax
  802123:	39 c2                	cmp    %eax,%edx
  802125:	73 6d                	jae    802194 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212b:	74 06                	je     802133 <insert_sorted_allocList+0x1c1>
  80212d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802131:	75 14                	jne    802147 <insert_sorted_allocList+0x1d5>
  802133:	83 ec 04             	sub    $0x4,%esp
  802136:	68 74 39 80 00       	push   $0x803974
  80213b:	6a 7c                	push   $0x7c
  80213d:	68 37 39 80 00       	push   $0x803937
  802142:	e8 58 0d 00 00       	call   802e9f <_panic>
  802147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214a:	8b 10                	mov    (%eax),%edx
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	89 10                	mov    %edx,(%eax)
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8b 00                	mov    (%eax),%eax
  802156:	85 c0                	test   %eax,%eax
  802158:	74 0b                	je     802165 <insert_sorted_allocList+0x1f3>
  80215a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	8b 55 08             	mov    0x8(%ebp),%edx
  802162:	89 50 04             	mov    %edx,0x4(%eax)
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 55 08             	mov    0x8(%ebp),%edx
  80216b:	89 10                	mov    %edx,(%eax)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802173:	89 50 04             	mov    %edx,0x4(%eax)
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	75 08                	jne    802187 <insert_sorted_allocList+0x215>
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	a3 44 40 80 00       	mov    %eax,0x804044
  802187:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80218c:	40                   	inc    %eax
  80218d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802192:	eb 38                	jmp    8021cc <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802194:	a1 48 40 80 00       	mov    0x804048,%eax
  802199:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a0:	74 07                	je     8021a9 <insert_sorted_allocList+0x237>
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	eb 05                	jmp    8021ae <insert_sorted_allocList+0x23c>
  8021a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ae:	a3 48 40 80 00       	mov    %eax,0x804048
  8021b3:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	0f 85 3f ff ff ff    	jne    8020ff <insert_sorted_allocList+0x18d>
  8021c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c4:	0f 85 35 ff ff ff    	jne    8020ff <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8021ca:	eb 00                	jmp    8021cc <insert_sorted_allocList+0x25a>
  8021cc:	90                   	nop
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8021d5:	a1 38 41 80 00       	mov    0x804138,%eax
  8021da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dd:	e9 6b 02 00 00       	jmp    80244d <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021eb:	0f 85 90 00 00 00    	jne    802281 <alloc_block_FF+0xb2>
			  temp=element;
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8021f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021fb:	75 17                	jne    802214 <alloc_block_FF+0x45>
  8021fd:	83 ec 04             	sub    $0x4,%esp
  802200:	68 a8 39 80 00       	push   $0x8039a8
  802205:	68 92 00 00 00       	push   $0x92
  80220a:	68 37 39 80 00       	push   $0x803937
  80220f:	e8 8b 0c 00 00       	call   802e9f <_panic>
  802214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802217:	8b 00                	mov    (%eax),%eax
  802219:	85 c0                	test   %eax,%eax
  80221b:	74 10                	je     80222d <alloc_block_FF+0x5e>
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802225:	8b 52 04             	mov    0x4(%edx),%edx
  802228:	89 50 04             	mov    %edx,0x4(%eax)
  80222b:	eb 0b                	jmp    802238 <alloc_block_FF+0x69>
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	8b 40 04             	mov    0x4(%eax),%eax
  802233:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 40 04             	mov    0x4(%eax),%eax
  80223e:	85 c0                	test   %eax,%eax
  802240:	74 0f                	je     802251 <alloc_block_FF+0x82>
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 40 04             	mov    0x4(%eax),%eax
  802248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224b:	8b 12                	mov    (%edx),%edx
  80224d:	89 10                	mov    %edx,(%eax)
  80224f:	eb 0a                	jmp    80225b <alloc_block_FF+0x8c>
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	8b 00                	mov    (%eax),%eax
  802256:	a3 38 41 80 00       	mov    %eax,0x804138
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80226e:	a1 44 41 80 00       	mov    0x804144,%eax
  802273:	48                   	dec    %eax
  802274:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802279:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227c:	e9 ff 01 00 00       	jmp    802480 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 40 0c             	mov    0xc(%eax),%eax
  802287:	3b 45 08             	cmp    0x8(%ebp),%eax
  80228a:	0f 86 b5 01 00 00    	jbe    802445 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 40 0c             	mov    0xc(%eax),%eax
  802296:	2b 45 08             	sub    0x8(%ebp),%eax
  802299:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80229c:	a1 48 41 80 00       	mov    0x804148,%eax
  8022a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8022a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022a8:	75 17                	jne    8022c1 <alloc_block_FF+0xf2>
  8022aa:	83 ec 04             	sub    $0x4,%esp
  8022ad:	68 a8 39 80 00       	push   $0x8039a8
  8022b2:	68 99 00 00 00       	push   $0x99
  8022b7:	68 37 39 80 00       	push   $0x803937
  8022bc:	e8 de 0b 00 00       	call   802e9f <_panic>
  8022c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022c4:	8b 00                	mov    (%eax),%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	74 10                	je     8022da <alloc_block_FF+0x10b>
  8022ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022d2:	8b 52 04             	mov    0x4(%edx),%edx
  8022d5:	89 50 04             	mov    %edx,0x4(%eax)
  8022d8:	eb 0b                	jmp    8022e5 <alloc_block_FF+0x116>
  8022da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022dd:	8b 40 04             	mov    0x4(%eax),%eax
  8022e0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e8:	8b 40 04             	mov    0x4(%eax),%eax
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	74 0f                	je     8022fe <alloc_block_FF+0x12f>
  8022ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f2:	8b 40 04             	mov    0x4(%eax),%eax
  8022f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022f8:	8b 12                	mov    (%edx),%edx
  8022fa:	89 10                	mov    %edx,(%eax)
  8022fc:	eb 0a                	jmp    802308 <alloc_block_FF+0x139>
  8022fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802301:	8b 00                	mov    (%eax),%eax
  802303:	a3 48 41 80 00       	mov    %eax,0x804148
  802308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802311:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802314:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80231b:	a1 54 41 80 00       	mov    0x804154,%eax
  802320:	48                   	dec    %eax
  802321:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802326:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80232a:	75 17                	jne    802343 <alloc_block_FF+0x174>
  80232c:	83 ec 04             	sub    $0x4,%esp
  80232f:	68 50 39 80 00       	push   $0x803950
  802334:	68 9a 00 00 00       	push   $0x9a
  802339:	68 37 39 80 00       	push   $0x803937
  80233e:	e8 5c 0b 00 00       	call   802e9f <_panic>
  802343:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234c:	89 50 04             	mov    %edx,0x4(%eax)
  80234f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802352:	8b 40 04             	mov    0x4(%eax),%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	74 0c                	je     802365 <alloc_block_FF+0x196>
  802359:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80235e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802361:	89 10                	mov    %edx,(%eax)
  802363:	eb 08                	jmp    80236d <alloc_block_FF+0x19e>
  802365:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802368:	a3 38 41 80 00       	mov    %eax,0x804138
  80236d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802370:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802375:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802378:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237e:	a1 44 41 80 00       	mov    0x804144,%eax
  802383:	40                   	inc    %eax
  802384:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802389:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238c:	8b 55 08             	mov    0x8(%ebp),%edx
  80238f:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 50 08             	mov    0x8(%eax),%edx
  802398:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239b:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a4:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 50 08             	mov    0x8(%eax),%edx
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	01 c2                	add    %eax,%edx
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8023b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8023be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023c2:	75 17                	jne    8023db <alloc_block_FF+0x20c>
  8023c4:	83 ec 04             	sub    $0x4,%esp
  8023c7:	68 a8 39 80 00       	push   $0x8039a8
  8023cc:	68 a2 00 00 00       	push   $0xa2
  8023d1:	68 37 39 80 00       	push   $0x803937
  8023d6:	e8 c4 0a 00 00       	call   802e9f <_panic>
  8023db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	74 10                	je     8023f4 <alloc_block_FF+0x225>
  8023e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ec:	8b 52 04             	mov    0x4(%edx),%edx
  8023ef:	89 50 04             	mov    %edx,0x4(%eax)
  8023f2:	eb 0b                	jmp    8023ff <alloc_block_FF+0x230>
  8023f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f7:	8b 40 04             	mov    0x4(%eax),%eax
  8023fa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802402:	8b 40 04             	mov    0x4(%eax),%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	74 0f                	je     802418 <alloc_block_FF+0x249>
  802409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240c:	8b 40 04             	mov    0x4(%eax),%eax
  80240f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802412:	8b 12                	mov    (%edx),%edx
  802414:	89 10                	mov    %edx,(%eax)
  802416:	eb 0a                	jmp    802422 <alloc_block_FF+0x253>
  802418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	a3 38 41 80 00       	mov    %eax,0x804138
  802422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802435:	a1 44 41 80 00       	mov    0x804144,%eax
  80243a:	48                   	dec    %eax
  80243b:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802440:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802443:	eb 3b                	jmp    802480 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802445:	a1 40 41 80 00       	mov    0x804140,%eax
  80244a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802451:	74 07                	je     80245a <alloc_block_FF+0x28b>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	eb 05                	jmp    80245f <alloc_block_FF+0x290>
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	a3 40 41 80 00       	mov    %eax,0x804140
  802464:	a1 40 41 80 00       	mov    0x804140,%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	0f 85 71 fd ff ff    	jne    8021e2 <alloc_block_FF+0x13>
  802471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802475:	0f 85 67 fd ff ff    	jne    8021e2 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80248f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802496:	a1 38 41 80 00       	mov    0x804138,%eax
  80249b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80249e:	e9 d3 00 00 00       	jmp    802576 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8024a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ac:	0f 85 90 00 00 00    	jne    802542 <alloc_block_BF+0xc0>
	   temp = element;
  8024b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8024b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024bc:	75 17                	jne    8024d5 <alloc_block_BF+0x53>
  8024be:	83 ec 04             	sub    $0x4,%esp
  8024c1:	68 a8 39 80 00       	push   $0x8039a8
  8024c6:	68 bd 00 00 00       	push   $0xbd
  8024cb:	68 37 39 80 00       	push   $0x803937
  8024d0:	e8 ca 09 00 00       	call   802e9f <_panic>
  8024d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	74 10                	je     8024ee <alloc_block_BF+0x6c>
  8024de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024e6:	8b 52 04             	mov    0x4(%edx),%edx
  8024e9:	89 50 04             	mov    %edx,0x4(%eax)
  8024ec:	eb 0b                	jmp    8024f9 <alloc_block_BF+0x77>
  8024ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f1:	8b 40 04             	mov    0x4(%eax),%eax
  8024f4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024fc:	8b 40 04             	mov    0x4(%eax),%eax
  8024ff:	85 c0                	test   %eax,%eax
  802501:	74 0f                	je     802512 <alloc_block_BF+0x90>
  802503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802506:	8b 40 04             	mov    0x4(%eax),%eax
  802509:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80250c:	8b 12                	mov    (%edx),%edx
  80250e:	89 10                	mov    %edx,(%eax)
  802510:	eb 0a                	jmp    80251c <alloc_block_BF+0x9a>
  802512:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	a3 38 41 80 00       	mov    %eax,0x804138
  80251c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802525:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802528:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252f:	a1 44 41 80 00       	mov    0x804144,%eax
  802534:	48                   	dec    %eax
  802535:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  80253a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80253d:	e9 41 01 00 00       	jmp    802683 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802545:	8b 40 0c             	mov    0xc(%eax),%eax
  802548:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254b:	76 21                	jbe    80256e <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80254d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802550:	8b 40 0c             	mov    0xc(%eax),%eax
  802553:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802556:	73 16                	jae    80256e <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802558:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80255b:	8b 40 0c             	mov    0xc(%eax),%eax
  80255e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802561:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802564:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802567:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80256e:	a1 40 41 80 00       	mov    0x804140,%eax
  802573:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802576:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80257a:	74 07                	je     802583 <alloc_block_BF+0x101>
  80257c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	eb 05                	jmp    802588 <alloc_block_BF+0x106>
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
  802588:	a3 40 41 80 00       	mov    %eax,0x804140
  80258d:	a1 40 41 80 00       	mov    0x804140,%eax
  802592:	85 c0                	test   %eax,%eax
  802594:	0f 85 09 ff ff ff    	jne    8024a3 <alloc_block_BF+0x21>
  80259a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80259e:	0f 85 ff fe ff ff    	jne    8024a3 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8025a4:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8025a8:	0f 85 d0 00 00 00    	jne    80267e <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8025ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b4:	2b 45 08             	sub    0x8(%ebp),%eax
  8025b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8025ba:	a1 48 41 80 00       	mov    0x804148,%eax
  8025bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8025c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025c6:	75 17                	jne    8025df <alloc_block_BF+0x15d>
  8025c8:	83 ec 04             	sub    $0x4,%esp
  8025cb:	68 a8 39 80 00       	push   $0x8039a8
  8025d0:	68 d1 00 00 00       	push   $0xd1
  8025d5:	68 37 39 80 00       	push   $0x803937
  8025da:	e8 c0 08 00 00       	call   802e9f <_panic>
  8025df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 10                	je     8025f8 <alloc_block_BF+0x176>
  8025e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025f0:	8b 52 04             	mov    0x4(%edx),%edx
  8025f3:	89 50 04             	mov    %edx,0x4(%eax)
  8025f6:	eb 0b                	jmp    802603 <alloc_block_BF+0x181>
  8025f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025fb:	8b 40 04             	mov    0x4(%eax),%eax
  8025fe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802606:	8b 40 04             	mov    0x4(%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	74 0f                	je     80261c <alloc_block_BF+0x19a>
  80260d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802610:	8b 40 04             	mov    0x4(%eax),%eax
  802613:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802616:	8b 12                	mov    (%edx),%edx
  802618:	89 10                	mov    %edx,(%eax)
  80261a:	eb 0a                	jmp    802626 <alloc_block_BF+0x1a4>
  80261c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	a3 48 41 80 00       	mov    %eax,0x804148
  802626:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802639:	a1 54 41 80 00       	mov    0x804154,%eax
  80263e:	48                   	dec    %eax
  80263f:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802644:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802647:	8b 55 08             	mov    0x8(%ebp),%edx
  80264a:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80264d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802650:	8b 50 08             	mov    0x8(%eax),%edx
  802653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802656:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80265f:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802665:	8b 50 08             	mov    0x8(%eax),%edx
  802668:	8b 45 08             	mov    0x8(%ebp),%eax
  80266b:	01 c2                	add    %eax,%edx
  80266d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802670:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802673:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802676:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802679:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80267c:	eb 05                	jmp    802683 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
  802688:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80268b:	83 ec 04             	sub    $0x4,%esp
  80268e:	68 c8 39 80 00       	push   $0x8039c8
  802693:	68 e8 00 00 00       	push   $0xe8
  802698:	68 37 39 80 00       	push   $0x803937
  80269d:	e8 fd 07 00 00       	call   802e9f <_panic>

008026a2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
  8026a5:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8026a8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8026ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8026b0:	a1 38 41 80 00       	mov    0x804138,%eax
  8026b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8026b8:	a1 44 41 80 00       	mov    0x804144,%eax
  8026bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8026c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c4:	75 68                	jne    80272e <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8026c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026ca:	75 17                	jne    8026e3 <insert_sorted_with_merge_freeList+0x41>
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 14 39 80 00       	push   $0x803914
  8026d4:	68 36 01 00 00       	push   $0x136
  8026d9:	68 37 39 80 00       	push   $0x803937
  8026de:	e8 bc 07 00 00       	call   802e9f <_panic>
  8026e3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ec:	89 10                	mov    %edx,(%eax)
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	74 0d                	je     802704 <insert_sorted_with_merge_freeList+0x62>
  8026f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8026fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ff:	89 50 04             	mov    %edx,0x4(%eax)
  802702:	eb 08                	jmp    80270c <insert_sorted_with_merge_freeList+0x6a>
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	a3 38 41 80 00       	mov    %eax,0x804138
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271e:	a1 44 41 80 00       	mov    0x804144,%eax
  802723:	40                   	inc    %eax
  802724:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802729:	e9 ba 06 00 00       	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80272e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802731:	8b 50 08             	mov    0x8(%eax),%edx
  802734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802737:	8b 40 0c             	mov    0xc(%eax),%eax
  80273a:	01 c2                	add    %eax,%edx
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	8b 40 08             	mov    0x8(%eax),%eax
  802742:	39 c2                	cmp    %eax,%edx
  802744:	73 68                	jae    8027ae <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802746:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80274a:	75 17                	jne    802763 <insert_sorted_with_merge_freeList+0xc1>
  80274c:	83 ec 04             	sub    $0x4,%esp
  80274f:	68 50 39 80 00       	push   $0x803950
  802754:	68 3a 01 00 00       	push   $0x13a
  802759:	68 37 39 80 00       	push   $0x803937
  80275e:	e8 3c 07 00 00       	call   802e9f <_panic>
  802763:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	89 50 04             	mov    %edx,0x4(%eax)
  80276f:	8b 45 08             	mov    0x8(%ebp),%eax
  802772:	8b 40 04             	mov    0x4(%eax),%eax
  802775:	85 c0                	test   %eax,%eax
  802777:	74 0c                	je     802785 <insert_sorted_with_merge_freeList+0xe3>
  802779:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80277e:	8b 55 08             	mov    0x8(%ebp),%edx
  802781:	89 10                	mov    %edx,(%eax)
  802783:	eb 08                	jmp    80278d <insert_sorted_with_merge_freeList+0xeb>
  802785:	8b 45 08             	mov    0x8(%ebp),%eax
  802788:	a3 38 41 80 00       	mov    %eax,0x804138
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279e:	a1 44 41 80 00       	mov    0x804144,%eax
  8027a3:	40                   	inc    %eax
  8027a4:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8027a9:	e9 3a 06 00 00       	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  8027ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b1:	8b 50 08             	mov    0x8(%eax),%edx
  8027b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ba:	01 c2                	add    %eax,%edx
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	8b 40 08             	mov    0x8(%eax),%eax
  8027c2:	39 c2                	cmp    %eax,%edx
  8027c4:	0f 85 90 00 00 00    	jne    80285a <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8027ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d6:	01 c2                	add    %eax,%edx
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027db:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8027de:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8027f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f6:	75 17                	jne    80280f <insert_sorted_with_merge_freeList+0x16d>
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	68 14 39 80 00       	push   $0x803914
  802800:	68 41 01 00 00       	push   $0x141
  802805:	68 37 39 80 00       	push   $0x803937
  80280a:	e8 90 06 00 00       	call   802e9f <_panic>
  80280f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	89 10                	mov    %edx,(%eax)
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	74 0d                	je     802830 <insert_sorted_with_merge_freeList+0x18e>
  802823:	a1 48 41 80 00       	mov    0x804148,%eax
  802828:	8b 55 08             	mov    0x8(%ebp),%edx
  80282b:	89 50 04             	mov    %edx,0x4(%eax)
  80282e:	eb 08                	jmp    802838 <insert_sorted_with_merge_freeList+0x196>
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	a3 48 41 80 00       	mov    %eax,0x804148
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284a:	a1 54 41 80 00       	mov    0x804154,%eax
  80284f:	40                   	inc    %eax
  802850:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802855:	e9 8e 05 00 00       	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	8b 50 08             	mov    0x8(%eax),%edx
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	8b 40 0c             	mov    0xc(%eax),%eax
  802866:	01 c2                	add    %eax,%edx
  802868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286b:	8b 40 08             	mov    0x8(%eax),%eax
  80286e:	39 c2                	cmp    %eax,%edx
  802870:	73 68                	jae    8028da <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802872:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802876:	75 17                	jne    80288f <insert_sorted_with_merge_freeList+0x1ed>
  802878:	83 ec 04             	sub    $0x4,%esp
  80287b:	68 14 39 80 00       	push   $0x803914
  802880:	68 45 01 00 00       	push   $0x145
  802885:	68 37 39 80 00       	push   $0x803937
  80288a:	e8 10 06 00 00       	call   802e9f <_panic>
  80288f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	89 10                	mov    %edx,(%eax)
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	8b 00                	mov    (%eax),%eax
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	74 0d                	je     8028b0 <insert_sorted_with_merge_freeList+0x20e>
  8028a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ab:	89 50 04             	mov    %edx,0x4(%eax)
  8028ae:	eb 08                	jmp    8028b8 <insert_sorted_with_merge_freeList+0x216>
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	a3 38 41 80 00       	mov    %eax,0x804138
  8028c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8028cf:	40                   	inc    %eax
  8028d0:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8028d5:	e9 0e 05 00 00       	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	8b 50 08             	mov    0x8(%eax),%edx
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e6:	01 c2                	add    %eax,%edx
  8028e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028eb:	8b 40 08             	mov    0x8(%eax),%eax
  8028ee:	39 c2                	cmp    %eax,%edx
  8028f0:	0f 85 9c 00 00 00    	jne    802992 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8028f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802902:	01 c2                	add    %eax,%edx
  802904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802907:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	8b 50 08             	mov    0x8(%eax),%edx
  802910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802913:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802916:	8b 45 08             	mov    0x8(%ebp),%eax
  802919:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80292a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292e:	75 17                	jne    802947 <insert_sorted_with_merge_freeList+0x2a5>
  802930:	83 ec 04             	sub    $0x4,%esp
  802933:	68 14 39 80 00       	push   $0x803914
  802938:	68 4d 01 00 00       	push   $0x14d
  80293d:	68 37 39 80 00       	push   $0x803937
  802942:	e8 58 05 00 00       	call   802e9f <_panic>
  802947:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	89 10                	mov    %edx,(%eax)
  802952:	8b 45 08             	mov    0x8(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	74 0d                	je     802968 <insert_sorted_with_merge_freeList+0x2c6>
  80295b:	a1 48 41 80 00       	mov    0x804148,%eax
  802960:	8b 55 08             	mov    0x8(%ebp),%edx
  802963:	89 50 04             	mov    %edx,0x4(%eax)
  802966:	eb 08                	jmp    802970 <insert_sorted_with_merge_freeList+0x2ce>
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	a3 48 41 80 00       	mov    %eax,0x804148
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802982:	a1 54 41 80 00       	mov    0x804154,%eax
  802987:	40                   	inc    %eax
  802988:	a3 54 41 80 00       	mov    %eax,0x804154





}
  80298d:	e9 56 04 00 00       	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802992:	a1 38 41 80 00       	mov    0x804138,%eax
  802997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299a:	e9 19 04 00 00       	jmp    802db8 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 50 08             	mov    0x8(%eax),%edx
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b3:	01 c2                	add    %eax,%edx
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	8b 40 08             	mov    0x8(%eax),%eax
  8029bb:	39 c2                	cmp    %eax,%edx
  8029bd:	0f 85 ad 01 00 00    	jne    802b70 <insert_sorted_with_merge_freeList+0x4ce>
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	8b 50 08             	mov    0x8(%eax),%edx
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cf:	01 c2                	add    %eax,%edx
  8029d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d4:	8b 40 08             	mov    0x8(%eax),%eax
  8029d7:	39 c2                	cmp    %eax,%edx
  8029d9:	0f 85 91 01 00 00    	jne    802b70 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f1:	01 c8                	add    %ecx,%eax
  8029f3:	01 c2                	add    %eax,%edx
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802a0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a12:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802a23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a27:	75 17                	jne    802a40 <insert_sorted_with_merge_freeList+0x39e>
  802a29:	83 ec 04             	sub    $0x4,%esp
  802a2c:	68 a8 39 80 00       	push   $0x8039a8
  802a31:	68 5b 01 00 00       	push   $0x15b
  802a36:	68 37 39 80 00       	push   $0x803937
  802a3b:	e8 5f 04 00 00       	call   802e9f <_panic>
  802a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a43:	8b 00                	mov    (%eax),%eax
  802a45:	85 c0                	test   %eax,%eax
  802a47:	74 10                	je     802a59 <insert_sorted_with_merge_freeList+0x3b7>
  802a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a51:	8b 52 04             	mov    0x4(%edx),%edx
  802a54:	89 50 04             	mov    %edx,0x4(%eax)
  802a57:	eb 0b                	jmp    802a64 <insert_sorted_with_merge_freeList+0x3c2>
  802a59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5c:	8b 40 04             	mov    0x4(%eax),%eax
  802a5f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a67:	8b 40 04             	mov    0x4(%eax),%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	74 0f                	je     802a7d <insert_sorted_with_merge_freeList+0x3db>
  802a6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a71:	8b 40 04             	mov    0x4(%eax),%eax
  802a74:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a77:	8b 12                	mov    (%edx),%edx
  802a79:	89 10                	mov    %edx,(%eax)
  802a7b:	eb 0a                	jmp    802a87 <insert_sorted_with_merge_freeList+0x3e5>
  802a7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a80:	8b 00                	mov    (%eax),%eax
  802a82:	a3 38 41 80 00       	mov    %eax,0x804138
  802a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a9f:	48                   	dec    %eax
  802aa0:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802aa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa9:	75 17                	jne    802ac2 <insert_sorted_with_merge_freeList+0x420>
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	68 14 39 80 00       	push   $0x803914
  802ab3:	68 5c 01 00 00       	push   $0x15c
  802ab8:	68 37 39 80 00       	push   $0x803937
  802abd:	e8 dd 03 00 00       	call   802e9f <_panic>
  802ac2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	89 10                	mov    %edx,(%eax)
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 0d                	je     802ae3 <insert_sorted_with_merge_freeList+0x441>
  802ad6:	a1 48 41 80 00       	mov    0x804148,%eax
  802adb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ade:	89 50 04             	mov    %edx,0x4(%eax)
  802ae1:	eb 08                	jmp    802aeb <insert_sorted_with_merge_freeList+0x449>
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	a3 48 41 80 00       	mov    %eax,0x804148
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afd:	a1 54 41 80 00       	mov    0x804154,%eax
  802b02:	40                   	inc    %eax
  802b03:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b0c:	75 17                	jne    802b25 <insert_sorted_with_merge_freeList+0x483>
  802b0e:	83 ec 04             	sub    $0x4,%esp
  802b11:	68 14 39 80 00       	push   $0x803914
  802b16:	68 5d 01 00 00       	push   $0x15d
  802b1b:	68 37 39 80 00       	push   $0x803937
  802b20:	e8 7a 03 00 00       	call   802e9f <_panic>
  802b25:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	74 0d                	je     802b46 <insert_sorted_with_merge_freeList+0x4a4>
  802b39:	a1 48 41 80 00       	mov    0x804148,%eax
  802b3e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b41:	89 50 04             	mov    %edx,0x4(%eax)
  802b44:	eb 08                	jmp    802b4e <insert_sorted_with_merge_freeList+0x4ac>
  802b46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b49:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b51:	a3 48 41 80 00       	mov    %eax,0x804148
  802b56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b60:	a1 54 41 80 00       	mov    0x804154,%eax
  802b65:	40                   	inc    %eax
  802b66:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802b6b:	e9 78 02 00 00       	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 50 08             	mov    0x8(%eax),%edx
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7c:	01 c2                	add    %eax,%edx
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	8b 40 08             	mov    0x8(%eax),%eax
  802b84:	39 c2                	cmp    %eax,%edx
  802b86:	0f 83 b8 00 00 00    	jae    802c44 <insert_sorted_with_merge_freeList+0x5a2>
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	8b 50 08             	mov    0x8(%eax),%edx
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	8b 40 0c             	mov    0xc(%eax),%eax
  802b98:	01 c2                	add    %eax,%edx
  802b9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ba0:	39 c2                	cmp    %eax,%edx
  802ba2:	0f 85 9c 00 00 00    	jne    802c44 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802ba8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bab:	8b 50 0c             	mov    0xc(%eax),%edx
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb4:	01 c2                	add    %eax,%edx
  802bb6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb9:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 50 08             	mov    0x8(%eax),%edx
  802bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc5:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be0:	75 17                	jne    802bf9 <insert_sorted_with_merge_freeList+0x557>
  802be2:	83 ec 04             	sub    $0x4,%esp
  802be5:	68 14 39 80 00       	push   $0x803914
  802bea:	68 67 01 00 00       	push   $0x167
  802bef:	68 37 39 80 00       	push   $0x803937
  802bf4:	e8 a6 02 00 00       	call   802e9f <_panic>
  802bf9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	89 10                	mov    %edx,(%eax)
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	8b 00                	mov    (%eax),%eax
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	74 0d                	je     802c1a <insert_sorted_with_merge_freeList+0x578>
  802c0d:	a1 48 41 80 00       	mov    0x804148,%eax
  802c12:	8b 55 08             	mov    0x8(%ebp),%edx
  802c15:	89 50 04             	mov    %edx,0x4(%eax)
  802c18:	eb 08                	jmp    802c22 <insert_sorted_with_merge_freeList+0x580>
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	a3 48 41 80 00       	mov    %eax,0x804148
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c34:	a1 54 41 80 00       	mov    0x804154,%eax
  802c39:	40                   	inc    %eax
  802c3a:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802c3f:	e9 a4 01 00 00       	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 50 08             	mov    0x8(%eax),%edx
  802c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c50:	01 c2                	add    %eax,%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 40 08             	mov    0x8(%eax),%eax
  802c58:	39 c2                	cmp    %eax,%edx
  802c5a:	0f 85 ac 00 00 00    	jne    802d0c <insert_sorted_with_merge_freeList+0x66a>
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	8b 50 08             	mov    0x8(%eax),%edx
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6c:	01 c2                	add    %eax,%edx
  802c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c71:	8b 40 08             	mov    0x8(%eax),%eax
  802c74:	39 c2                	cmp    %eax,%edx
  802c76:	0f 83 90 00 00 00    	jae    802d0c <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	8b 40 0c             	mov    0xc(%eax),%eax
  802c88:	01 c2                	add    %eax,%edx
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca8:	75 17                	jne    802cc1 <insert_sorted_with_merge_freeList+0x61f>
  802caa:	83 ec 04             	sub    $0x4,%esp
  802cad:	68 14 39 80 00       	push   $0x803914
  802cb2:	68 70 01 00 00       	push   $0x170
  802cb7:	68 37 39 80 00       	push   $0x803937
  802cbc:	e8 de 01 00 00       	call   802e9f <_panic>
  802cc1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	89 10                	mov    %edx,(%eax)
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	74 0d                	je     802ce2 <insert_sorted_with_merge_freeList+0x640>
  802cd5:	a1 48 41 80 00       	mov    0x804148,%eax
  802cda:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdd:	89 50 04             	mov    %edx,0x4(%eax)
  802ce0:	eb 08                	jmp    802cea <insert_sorted_with_merge_freeList+0x648>
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	a3 48 41 80 00       	mov    %eax,0x804148
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfc:	a1 54 41 80 00       	mov    0x804154,%eax
  802d01:	40                   	inc    %eax
  802d02:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802d07:	e9 dc 00 00 00       	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 50 08             	mov    0x8(%eax),%edx
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 40 0c             	mov    0xc(%eax),%eax
  802d18:	01 c2                	add    %eax,%edx
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	8b 40 08             	mov    0x8(%eax),%eax
  802d20:	39 c2                	cmp    %eax,%edx
  802d22:	0f 83 88 00 00 00    	jae    802db0 <insert_sorted_with_merge_freeList+0x70e>
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 50 08             	mov    0x8(%eax),%edx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	01 c2                	add    %eax,%edx
  802d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d39:	8b 40 08             	mov    0x8(%eax),%eax
  802d3c:	39 c2                	cmp    %eax,%edx
  802d3e:	73 70                	jae    802db0 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d44:	74 06                	je     802d4c <insert_sorted_with_merge_freeList+0x6aa>
  802d46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4a:	75 17                	jne    802d63 <insert_sorted_with_merge_freeList+0x6c1>
  802d4c:	83 ec 04             	sub    $0x4,%esp
  802d4f:	68 74 39 80 00       	push   $0x803974
  802d54:	68 75 01 00 00       	push   $0x175
  802d59:	68 37 39 80 00       	push   $0x803937
  802d5e:	e8 3c 01 00 00       	call   802e9f <_panic>
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	8b 10                	mov    (%eax),%edx
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	89 10                	mov    %edx,(%eax)
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	85 c0                	test   %eax,%eax
  802d74:	74 0b                	je     802d81 <insert_sorted_with_merge_freeList+0x6df>
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 00                	mov    (%eax),%eax
  802d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7e:	89 50 04             	mov    %edx,0x4(%eax)
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 55 08             	mov    0x8(%ebp),%edx
  802d87:	89 10                	mov    %edx,(%eax)
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8f:	89 50 04             	mov    %edx,0x4(%eax)
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	8b 00                	mov    (%eax),%eax
  802d97:	85 c0                	test   %eax,%eax
  802d99:	75 08                	jne    802da3 <insert_sorted_with_merge_freeList+0x701>
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802da3:	a1 44 41 80 00       	mov    0x804144,%eax
  802da8:	40                   	inc    %eax
  802da9:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802dae:	eb 38                	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802db0:	a1 40 41 80 00       	mov    0x804140,%eax
  802db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802db8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dbc:	74 07                	je     802dc5 <insert_sorted_with_merge_freeList+0x723>
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	eb 05                	jmp    802dca <insert_sorted_with_merge_freeList+0x728>
  802dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  802dca:	a3 40 41 80 00       	mov    %eax,0x804140
  802dcf:	a1 40 41 80 00       	mov    0x804140,%eax
  802dd4:	85 c0                	test   %eax,%eax
  802dd6:	0f 85 c3 fb ff ff    	jne    80299f <insert_sorted_with_merge_freeList+0x2fd>
  802ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de0:	0f 85 b9 fb ff ff    	jne    80299f <insert_sorted_with_merge_freeList+0x2fd>





}
  802de6:	eb 00                	jmp    802de8 <insert_sorted_with_merge_freeList+0x746>
  802de8:	90                   	nop
  802de9:	c9                   	leave  
  802dea:	c3                   	ret    

00802deb <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802deb:	55                   	push   %ebp
  802dec:	89 e5                	mov    %esp,%ebp
  802dee:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802df1:	8b 55 08             	mov    0x8(%ebp),%edx
  802df4:	89 d0                	mov    %edx,%eax
  802df6:	c1 e0 02             	shl    $0x2,%eax
  802df9:	01 d0                	add    %edx,%eax
  802dfb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e02:	01 d0                	add    %edx,%eax
  802e04:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e0b:	01 d0                	add    %edx,%eax
  802e0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e14:	01 d0                	add    %edx,%eax
  802e16:	c1 e0 04             	shl    $0x4,%eax
  802e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802e1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802e23:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802e26:	83 ec 0c             	sub    $0xc,%esp
  802e29:	50                   	push   %eax
  802e2a:	e8 31 ec ff ff       	call   801a60 <sys_get_virtual_time>
  802e2f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802e32:	eb 41                	jmp    802e75 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802e34:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802e37:	83 ec 0c             	sub    $0xc,%esp
  802e3a:	50                   	push   %eax
  802e3b:	e8 20 ec ff ff       	call   801a60 <sys_get_virtual_time>
  802e40:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802e43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e49:	29 c2                	sub    %eax,%edx
  802e4b:	89 d0                	mov    %edx,%eax
  802e4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802e50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e56:	89 d1                	mov    %edx,%ecx
  802e58:	29 c1                	sub    %eax,%ecx
  802e5a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e60:	39 c2                	cmp    %eax,%edx
  802e62:	0f 97 c0             	seta   %al
  802e65:	0f b6 c0             	movzbl %al,%eax
  802e68:	29 c1                	sub    %eax,%ecx
  802e6a:	89 c8                	mov    %ecx,%eax
  802e6c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802e6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e7b:	72 b7                	jb     802e34 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802e7d:	90                   	nop
  802e7e:	c9                   	leave  
  802e7f:	c3                   	ret    

00802e80 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
  802e83:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802e8d:	eb 03                	jmp    802e92 <busy_wait+0x12>
  802e8f:	ff 45 fc             	incl   -0x4(%ebp)
  802e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e98:	72 f5                	jb     802e8f <busy_wait+0xf>
	return i;
  802e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802e9d:	c9                   	leave  
  802e9e:	c3                   	ret    

00802e9f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802e9f:	55                   	push   %ebp
  802ea0:	89 e5                	mov    %esp,%ebp
  802ea2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802ea5:	8d 45 10             	lea    0x10(%ebp),%eax
  802ea8:	83 c0 04             	add    $0x4,%eax
  802eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802eae:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	74 16                	je     802ecd <_panic+0x2e>
		cprintf("%s: ", argv0);
  802eb7:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802ebc:	83 ec 08             	sub    $0x8,%esp
  802ebf:	50                   	push   %eax
  802ec0:	68 f8 39 80 00       	push   $0x8039f8
  802ec5:	e8 b2 d4 ff ff       	call   80037c <cprintf>
  802eca:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802ecd:	a1 00 40 80 00       	mov    0x804000,%eax
  802ed2:	ff 75 0c             	pushl  0xc(%ebp)
  802ed5:	ff 75 08             	pushl  0x8(%ebp)
  802ed8:	50                   	push   %eax
  802ed9:	68 fd 39 80 00       	push   $0x8039fd
  802ede:	e8 99 d4 ff ff       	call   80037c <cprintf>
  802ee3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  802ee9:	83 ec 08             	sub    $0x8,%esp
  802eec:	ff 75 f4             	pushl  -0xc(%ebp)
  802eef:	50                   	push   %eax
  802ef0:	e8 1c d4 ff ff       	call   800311 <vcprintf>
  802ef5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802ef8:	83 ec 08             	sub    $0x8,%esp
  802efb:	6a 00                	push   $0x0
  802efd:	68 19 3a 80 00       	push   $0x803a19
  802f02:	e8 0a d4 ff ff       	call   800311 <vcprintf>
  802f07:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802f0a:	e8 8b d3 ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  802f0f:	eb fe                	jmp    802f0f <_panic+0x70>

00802f11 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802f11:	55                   	push   %ebp
  802f12:	89 e5                	mov    %esp,%ebp
  802f14:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802f17:	a1 20 40 80 00       	mov    0x804020,%eax
  802f1c:	8b 50 74             	mov    0x74(%eax),%edx
  802f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f22:	39 c2                	cmp    %eax,%edx
  802f24:	74 14                	je     802f3a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802f26:	83 ec 04             	sub    $0x4,%esp
  802f29:	68 1c 3a 80 00       	push   $0x803a1c
  802f2e:	6a 26                	push   $0x26
  802f30:	68 68 3a 80 00       	push   $0x803a68
  802f35:	e8 65 ff ff ff       	call   802e9f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802f3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802f41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f48:	e9 c2 00 00 00       	jmp    80300f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	01 d0                	add    %edx,%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	75 08                	jne    802f6a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802f62:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802f65:	e9 a2 00 00 00       	jmp    80300c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802f6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802f78:	eb 69                	jmp    802fe3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802f7a:	a1 20 40 80 00       	mov    0x804020,%eax
  802f7f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f88:	89 d0                	mov    %edx,%eax
  802f8a:	01 c0                	add    %eax,%eax
  802f8c:	01 d0                	add    %edx,%eax
  802f8e:	c1 e0 03             	shl    $0x3,%eax
  802f91:	01 c8                	add    %ecx,%eax
  802f93:	8a 40 04             	mov    0x4(%eax),%al
  802f96:	84 c0                	test   %al,%al
  802f98:	75 46                	jne    802fe0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802f9a:	a1 20 40 80 00       	mov    0x804020,%eax
  802f9f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802fa5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa8:	89 d0                	mov    %edx,%eax
  802faa:	01 c0                	add    %eax,%eax
  802fac:	01 d0                	add    %edx,%eax
  802fae:	c1 e0 03             	shl    $0x3,%eax
  802fb1:	01 c8                	add    %ecx,%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802fc0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	01 c8                	add    %ecx,%eax
  802fd1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802fd3:	39 c2                	cmp    %eax,%edx
  802fd5:	75 09                	jne    802fe0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802fd7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802fde:	eb 12                	jmp    802ff2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802fe0:	ff 45 e8             	incl   -0x18(%ebp)
  802fe3:	a1 20 40 80 00       	mov    0x804020,%eax
  802fe8:	8b 50 74             	mov    0x74(%eax),%edx
  802feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fee:	39 c2                	cmp    %eax,%edx
  802ff0:	77 88                	ja     802f7a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802ff2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ff6:	75 14                	jne    80300c <CheckWSWithoutLastIndex+0xfb>
			panic(
  802ff8:	83 ec 04             	sub    $0x4,%esp
  802ffb:	68 74 3a 80 00       	push   $0x803a74
  803000:	6a 3a                	push   $0x3a
  803002:	68 68 3a 80 00       	push   $0x803a68
  803007:	e8 93 fe ff ff       	call   802e9f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80300c:	ff 45 f0             	incl   -0x10(%ebp)
  80300f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803012:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803015:	0f 8c 32 ff ff ff    	jl     802f4d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80301b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803022:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803029:	eb 26                	jmp    803051 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80302b:	a1 20 40 80 00       	mov    0x804020,%eax
  803030:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803036:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803039:	89 d0                	mov    %edx,%eax
  80303b:	01 c0                	add    %eax,%eax
  80303d:	01 d0                	add    %edx,%eax
  80303f:	c1 e0 03             	shl    $0x3,%eax
  803042:	01 c8                	add    %ecx,%eax
  803044:	8a 40 04             	mov    0x4(%eax),%al
  803047:	3c 01                	cmp    $0x1,%al
  803049:	75 03                	jne    80304e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80304b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80304e:	ff 45 e0             	incl   -0x20(%ebp)
  803051:	a1 20 40 80 00       	mov    0x804020,%eax
  803056:	8b 50 74             	mov    0x74(%eax),%edx
  803059:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80305c:	39 c2                	cmp    %eax,%edx
  80305e:	77 cb                	ja     80302b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803066:	74 14                	je     80307c <CheckWSWithoutLastIndex+0x16b>
		panic(
  803068:	83 ec 04             	sub    $0x4,%esp
  80306b:	68 c8 3a 80 00       	push   $0x803ac8
  803070:	6a 44                	push   $0x44
  803072:	68 68 3a 80 00       	push   $0x803a68
  803077:	e8 23 fe ff ff       	call   802e9f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80307c:	90                   	nop
  80307d:	c9                   	leave  
  80307e:	c3                   	ret    
  80307f:	90                   	nop

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
