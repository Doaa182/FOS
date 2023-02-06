
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 95 00 00 00       	call   8000cb <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 e0 1b 80 00       	push   $0x801be0
  800057:	e8 ff 09 00 00       	call   800a5b <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 51 0e 00 00       	call   800ec3 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Factorial %d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 f7 1b 80 00       	push   $0x801bf7
  800097:	e8 6c 02 00 00       	call   800308 <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <factorial>:


int factorial(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	83 ec 08             	sub    $0x8,%esp
	if (n <= 1)
  8000a8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ac:	7f 07                	jg     8000b5 <factorial+0x13>
		return 1 ;
  8000ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b3:	eb 14                	jmp    8000c9 <factorial+0x27>
	return n * factorial(n-1) ;
  8000b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b8:	48                   	dec    %eax
  8000b9:	83 ec 0c             	sub    $0xc,%esp
  8000bc:	50                   	push   %eax
  8000bd:	e8 e0 ff ff ff       	call   8000a2 <factorial>
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	0f af 45 08          	imul   0x8(%ebp),%eax
}
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000d1:	e8 61 15 00 00       	call   801637 <sys_getenvindex>
  8000d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000dc:	89 d0                	mov    %edx,%eax
  8000de:	c1 e0 03             	shl    $0x3,%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	01 c0                	add    %eax,%eax
  8000e5:	01 d0                	add    %edx,%eax
  8000e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ee:	01 d0                	add    %edx,%eax
  8000f0:	c1 e0 04             	shl    $0x4,%eax
  8000f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f8:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800102:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800108:	84 c0                	test   %al,%al
  80010a:	74 0f                	je     80011b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80010c:	a1 20 30 80 00       	mov    0x803020,%eax
  800111:	05 5c 05 00 00       	add    $0x55c,%eax
  800116:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80011b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80011f:	7e 0a                	jle    80012b <libmain+0x60>
		binaryname = argv[0];
  800121:	8b 45 0c             	mov    0xc(%ebp),%eax
  800124:	8b 00                	mov    (%eax),%eax
  800126:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80012b:	83 ec 08             	sub    $0x8,%esp
  80012e:	ff 75 0c             	pushl  0xc(%ebp)
  800131:	ff 75 08             	pushl  0x8(%ebp)
  800134:	e8 ff fe ff ff       	call   800038 <_main>
  800139:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80013c:	e8 03 13 00 00       	call   801444 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800141:	83 ec 0c             	sub    $0xc,%esp
  800144:	68 24 1c 80 00       	push   $0x801c24
  800149:	e8 8d 01 00 00       	call   8002db <cprintf>
  80014e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800151:	a1 20 30 80 00       	mov    0x803020,%eax
  800156:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80015c:	a1 20 30 80 00       	mov    0x803020,%eax
  800161:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	52                   	push   %edx
  80016b:	50                   	push   %eax
  80016c:	68 4c 1c 80 00       	push   $0x801c4c
  800171:	e8 65 01 00 00       	call   8002db <cprintf>
  800176:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800179:	a1 20 30 80 00       	mov    0x803020,%eax
  80017e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800184:	a1 20 30 80 00       	mov    0x803020,%eax
  800189:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80019a:	51                   	push   %ecx
  80019b:	52                   	push   %edx
  80019c:	50                   	push   %eax
  80019d:	68 74 1c 80 00       	push   $0x801c74
  8001a2:	e8 34 01 00 00       	call   8002db <cprintf>
  8001a7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8001af:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8001b5:	83 ec 08             	sub    $0x8,%esp
  8001b8:	50                   	push   %eax
  8001b9:	68 cc 1c 80 00       	push   $0x801ccc
  8001be:	e8 18 01 00 00       	call   8002db <cprintf>
  8001c3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 24 1c 80 00       	push   $0x801c24
  8001ce:	e8 08 01 00 00       	call   8002db <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001d6:	e8 83 12 00 00       	call   80145e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001db:	e8 19 00 00 00       	call   8001f9 <exit>
}
  8001e0:	90                   	nop
  8001e1:	c9                   	leave  
  8001e2:	c3                   	ret    

008001e3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	6a 00                	push   $0x0
  8001ee:	e8 10 14 00 00       	call   801603 <sys_destroy_env>
  8001f3:	83 c4 10             	add    $0x10,%esp
}
  8001f6:	90                   	nop
  8001f7:	c9                   	leave  
  8001f8:	c3                   	ret    

008001f9 <exit>:

void
exit(void)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ff:	e8 65 14 00 00       	call   801669 <sys_exit_env>
}
  800204:	90                   	nop
  800205:	c9                   	leave  
  800206:	c3                   	ret    

00800207 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800207:	55                   	push   %ebp
  800208:	89 e5                	mov    %esp,%ebp
  80020a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80020d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800210:	8b 00                	mov    (%eax),%eax
  800212:	8d 48 01             	lea    0x1(%eax),%ecx
  800215:	8b 55 0c             	mov    0xc(%ebp),%edx
  800218:	89 0a                	mov    %ecx,(%edx)
  80021a:	8b 55 08             	mov    0x8(%ebp),%edx
  80021d:	88 d1                	mov    %dl,%cl
  80021f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800222:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800226:	8b 45 0c             	mov    0xc(%ebp),%eax
  800229:	8b 00                	mov    (%eax),%eax
  80022b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800230:	75 2c                	jne    80025e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800232:	a0 24 30 80 00       	mov    0x803024,%al
  800237:	0f b6 c0             	movzbl %al,%eax
  80023a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023d:	8b 12                	mov    (%edx),%edx
  80023f:	89 d1                	mov    %edx,%ecx
  800241:	8b 55 0c             	mov    0xc(%ebp),%edx
  800244:	83 c2 08             	add    $0x8,%edx
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	50                   	push   %eax
  80024b:	51                   	push   %ecx
  80024c:	52                   	push   %edx
  80024d:	e8 44 10 00 00       	call   801296 <sys_cputs>
  800252:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800255:	8b 45 0c             	mov    0xc(%ebp),%eax
  800258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800261:	8b 40 04             	mov    0x4(%eax),%eax
  800264:	8d 50 01             	lea    0x1(%eax),%edx
  800267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80026d:	90                   	nop
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800279:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800280:	00 00 00 
	b.cnt = 0;
  800283:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80028d:	ff 75 0c             	pushl  0xc(%ebp)
  800290:	ff 75 08             	pushl  0x8(%ebp)
  800293:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800299:	50                   	push   %eax
  80029a:	68 07 02 80 00       	push   $0x800207
  80029f:	e8 11 02 00 00       	call   8004b5 <vprintfmt>
  8002a4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002a7:	a0 24 30 80 00       	mov    0x803024,%al
  8002ac:	0f b6 c0             	movzbl %al,%eax
  8002af:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	50                   	push   %eax
  8002b9:	52                   	push   %edx
  8002ba:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c0:	83 c0 08             	add    $0x8,%eax
  8002c3:	50                   	push   %eax
  8002c4:	e8 cd 0f 00 00       	call   801296 <sys_cputs>
  8002c9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002cc:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002d3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <cprintf>:

int cprintf(const char *fmt, ...) {
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002e1:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	83 ec 08             	sub    $0x8,%esp
  8002f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f7:	50                   	push   %eax
  8002f8:	e8 73 ff ff ff       	call   800270 <vcprintf>
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800303:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80030e:	e8 31 11 00 00       	call   801444 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800313:	8d 45 0c             	lea    0xc(%ebp),%eax
  800316:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	83 ec 08             	sub    $0x8,%esp
  80031f:	ff 75 f4             	pushl  -0xc(%ebp)
  800322:	50                   	push   %eax
  800323:	e8 48 ff ff ff       	call   800270 <vcprintf>
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80032e:	e8 2b 11 00 00       	call   80145e <sys_enable_interrupt>
	return cnt;
  800333:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800336:	c9                   	leave  
  800337:	c3                   	ret    

00800338 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	53                   	push   %ebx
  80033c:	83 ec 14             	sub    $0x14,%esp
  80033f:	8b 45 10             	mov    0x10(%ebp),%eax
  800342:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800345:	8b 45 14             	mov    0x14(%ebp),%eax
  800348:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80034b:	8b 45 18             	mov    0x18(%ebp),%eax
  80034e:	ba 00 00 00 00       	mov    $0x0,%edx
  800353:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800356:	77 55                	ja     8003ad <printnum+0x75>
  800358:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80035b:	72 05                	jb     800362 <printnum+0x2a>
  80035d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800360:	77 4b                	ja     8003ad <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800362:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800365:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800368:	8b 45 18             	mov    0x18(%ebp),%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
  800370:	52                   	push   %edx
  800371:	50                   	push   %eax
  800372:	ff 75 f4             	pushl  -0xc(%ebp)
  800375:	ff 75 f0             	pushl  -0x10(%ebp)
  800378:	e8 ef 15 00 00       	call   80196c <__udivdi3>
  80037d:	83 c4 10             	add    $0x10,%esp
  800380:	83 ec 04             	sub    $0x4,%esp
  800383:	ff 75 20             	pushl  0x20(%ebp)
  800386:	53                   	push   %ebx
  800387:	ff 75 18             	pushl  0x18(%ebp)
  80038a:	52                   	push   %edx
  80038b:	50                   	push   %eax
  80038c:	ff 75 0c             	pushl  0xc(%ebp)
  80038f:	ff 75 08             	pushl  0x8(%ebp)
  800392:	e8 a1 ff ff ff       	call   800338 <printnum>
  800397:	83 c4 20             	add    $0x20,%esp
  80039a:	eb 1a                	jmp    8003b6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039c:	83 ec 08             	sub    $0x8,%esp
  80039f:	ff 75 0c             	pushl  0xc(%ebp)
  8003a2:	ff 75 20             	pushl  0x20(%ebp)
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	ff d0                	call   *%eax
  8003aa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ad:	ff 4d 1c             	decl   0x1c(%ebp)
  8003b0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003b4:	7f e6                	jg     80039c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c4:	53                   	push   %ebx
  8003c5:	51                   	push   %ecx
  8003c6:	52                   	push   %edx
  8003c7:	50                   	push   %eax
  8003c8:	e8 af 16 00 00       	call   801a7c <__umoddi3>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	05 f4 1e 80 00       	add    $0x801ef4,%eax
  8003d5:	8a 00                	mov    (%eax),%al
  8003d7:	0f be c0             	movsbl %al,%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 0c             	pushl  0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	ff d0                	call   *%eax
  8003e6:	83 c4 10             	add    $0x10,%esp
}
  8003e9:	90                   	nop
  8003ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f6:	7e 1c                	jle    800414 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fb:	8b 00                	mov    (%eax),%eax
  8003fd:	8d 50 08             	lea    0x8(%eax),%edx
  800400:	8b 45 08             	mov    0x8(%ebp),%eax
  800403:	89 10                	mov    %edx,(%eax)
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	8b 00                	mov    (%eax),%eax
  80040a:	83 e8 08             	sub    $0x8,%eax
  80040d:	8b 50 04             	mov    0x4(%eax),%edx
  800410:	8b 00                	mov    (%eax),%eax
  800412:	eb 40                	jmp    800454 <getuint+0x65>
	else if (lflag)
  800414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800418:	74 1e                	je     800438 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80041a:	8b 45 08             	mov    0x8(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 04             	lea    0x4(%eax),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	8b 00                	mov    (%eax),%eax
  80042c:	83 e8 04             	sub    $0x4,%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	ba 00 00 00 00       	mov    $0x0,%edx
  800436:	eb 1c                	jmp    800454 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	8d 50 04             	lea    0x4(%eax),%edx
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	89 10                	mov    %edx,(%eax)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	83 e8 04             	sub    $0x4,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    

00800456 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800459:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80045d:	7e 1c                	jle    80047b <getint+0x25>
		return va_arg(*ap, long long);
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 08             	lea    0x8(%eax),%edx
  800467:	8b 45 08             	mov    0x8(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 00                	mov    (%eax),%eax
  800471:	83 e8 08             	sub    $0x8,%eax
  800474:	8b 50 04             	mov    0x4(%eax),%edx
  800477:	8b 00                	mov    (%eax),%eax
  800479:	eb 38                	jmp    8004b3 <getint+0x5d>
	else if (lflag)
  80047b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80047f:	74 1a                	je     80049b <getint+0x45>
		return va_arg(*ap, long);
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	8d 50 04             	lea    0x4(%eax),%edx
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	89 10                	mov    %edx,(%eax)
  80048e:	8b 45 08             	mov    0x8(%ebp),%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	83 e8 04             	sub    $0x4,%eax
  800496:	8b 00                	mov    (%eax),%eax
  800498:	99                   	cltd   
  800499:	eb 18                	jmp    8004b3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	8d 50 04             	lea    0x4(%eax),%edx
  8004a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a6:	89 10                	mov    %edx,(%eax)
  8004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	83 e8 04             	sub    $0x4,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	99                   	cltd   
}
  8004b3:	5d                   	pop    %ebp
  8004b4:	c3                   	ret    

008004b5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004b5:	55                   	push   %ebp
  8004b6:	89 e5                	mov    %esp,%ebp
  8004b8:	56                   	push   %esi
  8004b9:	53                   	push   %ebx
  8004ba:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004bd:	eb 17                	jmp    8004d6 <vprintfmt+0x21>
			if (ch == '\0')
  8004bf:	85 db                	test   %ebx,%ebx
  8004c1:	0f 84 af 03 00 00    	je     800876 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	ff 75 0c             	pushl  0xc(%ebp)
  8004cd:	53                   	push   %ebx
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	ff d0                	call   *%eax
  8004d3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004d9:	8d 50 01             	lea    0x1(%eax),%edx
  8004dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8004df:	8a 00                	mov    (%eax),%al
  8004e1:	0f b6 d8             	movzbl %al,%ebx
  8004e4:	83 fb 25             	cmp    $0x25,%ebx
  8004e7:	75 d6                	jne    8004bf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004e9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004ed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004f4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800502:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800509:	8b 45 10             	mov    0x10(%ebp),%eax
  80050c:	8d 50 01             	lea    0x1(%eax),%edx
  80050f:	89 55 10             	mov    %edx,0x10(%ebp)
  800512:	8a 00                	mov    (%eax),%al
  800514:	0f b6 d8             	movzbl %al,%ebx
  800517:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80051a:	83 f8 55             	cmp    $0x55,%eax
  80051d:	0f 87 2b 03 00 00    	ja     80084e <vprintfmt+0x399>
  800523:	8b 04 85 18 1f 80 00 	mov    0x801f18(,%eax,4),%eax
  80052a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80052c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800530:	eb d7                	jmp    800509 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800532:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800536:	eb d1                	jmp    800509 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800538:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80053f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800542:	89 d0                	mov    %edx,%eax
  800544:	c1 e0 02             	shl    $0x2,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	01 d8                	add    %ebx,%eax
  80054d:	83 e8 30             	sub    $0x30,%eax
  800550:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8a 00                	mov    (%eax),%al
  800558:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80055b:	83 fb 2f             	cmp    $0x2f,%ebx
  80055e:	7e 3e                	jle    80059e <vprintfmt+0xe9>
  800560:	83 fb 39             	cmp    $0x39,%ebx
  800563:	7f 39                	jg     80059e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800565:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800568:	eb d5                	jmp    80053f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	83 c0 04             	add    $0x4,%eax
  800570:	89 45 14             	mov    %eax,0x14(%ebp)
  800573:	8b 45 14             	mov    0x14(%ebp),%eax
  800576:	83 e8 04             	sub    $0x4,%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80057e:	eb 1f                	jmp    80059f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800580:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800584:	79 83                	jns    800509 <vprintfmt+0x54>
				width = 0;
  800586:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80058d:	e9 77 ff ff ff       	jmp    800509 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800592:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800599:	e9 6b ff ff ff       	jmp    800509 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80059e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80059f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a3:	0f 89 60 ff ff ff    	jns    800509 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005af:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005b6:	e9 4e ff ff ff       	jmp    800509 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005bb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005be:	e9 46 ff ff ff       	jmp    800509 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	83 c0 04             	add    $0x4,%eax
  8005c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cf:	83 e8 04             	sub    $0x4,%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	ff 75 0c             	pushl  0xc(%ebp)
  8005da:	50                   	push   %eax
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	ff d0                	call   *%eax
  8005e0:	83 c4 10             	add    $0x10,%esp
			break;
  8005e3:	e9 89 02 00 00       	jmp    800871 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	83 c0 04             	add    $0x4,%eax
  8005ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	83 e8 04             	sub    $0x4,%eax
  8005f7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005f9:	85 db                	test   %ebx,%ebx
  8005fb:	79 02                	jns    8005ff <vprintfmt+0x14a>
				err = -err;
  8005fd:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005ff:	83 fb 64             	cmp    $0x64,%ebx
  800602:	7f 0b                	jg     80060f <vprintfmt+0x15a>
  800604:	8b 34 9d 60 1d 80 00 	mov    0x801d60(,%ebx,4),%esi
  80060b:	85 f6                	test   %esi,%esi
  80060d:	75 19                	jne    800628 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80060f:	53                   	push   %ebx
  800610:	68 05 1f 80 00       	push   $0x801f05
  800615:	ff 75 0c             	pushl  0xc(%ebp)
  800618:	ff 75 08             	pushl  0x8(%ebp)
  80061b:	e8 5e 02 00 00       	call   80087e <printfmt>
  800620:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800623:	e9 49 02 00 00       	jmp    800871 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800628:	56                   	push   %esi
  800629:	68 0e 1f 80 00       	push   $0x801f0e
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 08             	pushl  0x8(%ebp)
  800634:	e8 45 02 00 00       	call   80087e <printfmt>
  800639:	83 c4 10             	add    $0x10,%esp
			break;
  80063c:	e9 30 02 00 00       	jmp    800871 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	83 c0 04             	add    $0x4,%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	83 e8 04             	sub    $0x4,%eax
  800650:	8b 30                	mov    (%eax),%esi
  800652:	85 f6                	test   %esi,%esi
  800654:	75 05                	jne    80065b <vprintfmt+0x1a6>
				p = "(null)";
  800656:	be 11 1f 80 00       	mov    $0x801f11,%esi
			if (width > 0 && padc != '-')
  80065b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80065f:	7e 6d                	jle    8006ce <vprintfmt+0x219>
  800661:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800665:	74 67                	je     8006ce <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066a:	83 ec 08             	sub    $0x8,%esp
  80066d:	50                   	push   %eax
  80066e:	56                   	push   %esi
  80066f:	e8 12 05 00 00       	call   800b86 <strnlen>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80067a:	eb 16                	jmp    800692 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80067c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	ff 75 0c             	pushl  0xc(%ebp)
  800686:	50                   	push   %eax
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	ff d0                	call   *%eax
  80068c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80068f:	ff 4d e4             	decl   -0x1c(%ebp)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800696:	7f e4                	jg     80067c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800698:	eb 34                	jmp    8006ce <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80069a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80069e:	74 1c                	je     8006bc <vprintfmt+0x207>
  8006a0:	83 fb 1f             	cmp    $0x1f,%ebx
  8006a3:	7e 05                	jle    8006aa <vprintfmt+0x1f5>
  8006a5:	83 fb 7e             	cmp    $0x7e,%ebx
  8006a8:	7e 12                	jle    8006bc <vprintfmt+0x207>
					putch('?', putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	6a 3f                	push   $0x3f
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	ff d0                	call   *%eax
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	eb 0f                	jmp    8006cb <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	53                   	push   %ebx
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	ff d0                	call   *%eax
  8006c8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006cb:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ce:	89 f0                	mov    %esi,%eax
  8006d0:	8d 70 01             	lea    0x1(%eax),%esi
  8006d3:	8a 00                	mov    (%eax),%al
  8006d5:	0f be d8             	movsbl %al,%ebx
  8006d8:	85 db                	test   %ebx,%ebx
  8006da:	74 24                	je     800700 <vprintfmt+0x24b>
  8006dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e0:	78 b8                	js     80069a <vprintfmt+0x1e5>
  8006e2:	ff 4d e0             	decl   -0x20(%ebp)
  8006e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e9:	79 af                	jns    80069a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006eb:	eb 13                	jmp    800700 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	6a 20                	push   $0x20
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	ff d0                	call   *%eax
  8006fa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fd:	ff 4d e4             	decl   -0x1c(%ebp)
  800700:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800704:	7f e7                	jg     8006ed <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800706:	e9 66 01 00 00       	jmp    800871 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	ff 75 e8             	pushl  -0x18(%ebp)
  800711:	8d 45 14             	lea    0x14(%ebp),%eax
  800714:	50                   	push   %eax
  800715:	e8 3c fd ff ff       	call   800456 <getint>
  80071a:	83 c4 10             	add    $0x10,%esp
  80071d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800720:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800726:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800729:	85 d2                	test   %edx,%edx
  80072b:	79 23                	jns    800750 <vprintfmt+0x29b>
				putch('-', putdat);
  80072d:	83 ec 08             	sub    $0x8,%esp
  800730:	ff 75 0c             	pushl  0xc(%ebp)
  800733:	6a 2d                	push   $0x2d
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	ff d0                	call   *%eax
  80073a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80073d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800743:	f7 d8                	neg    %eax
  800745:	83 d2 00             	adc    $0x0,%edx
  800748:	f7 da                	neg    %edx
  80074a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800750:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800757:	e9 bc 00 00 00       	jmp    800818 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 e8             	pushl  -0x18(%ebp)
  800762:	8d 45 14             	lea    0x14(%ebp),%eax
  800765:	50                   	push   %eax
  800766:	e8 84 fc ff ff       	call   8003ef <getuint>
  80076b:	83 c4 10             	add    $0x10,%esp
  80076e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800771:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800774:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80077b:	e9 98 00 00 00       	jmp    800818 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800780:	83 ec 08             	sub    $0x8,%esp
  800783:	ff 75 0c             	pushl  0xc(%ebp)
  800786:	6a 58                	push   $0x58
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	ff d0                	call   *%eax
  80078d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800790:	83 ec 08             	sub    $0x8,%esp
  800793:	ff 75 0c             	pushl  0xc(%ebp)
  800796:	6a 58                	push   $0x58
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	ff d0                	call   *%eax
  80079d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 0c             	pushl  0xc(%ebp)
  8007a6:	6a 58                	push   $0x58
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	ff d0                	call   *%eax
  8007ad:	83 c4 10             	add    $0x10,%esp
			break;
  8007b0:	e9 bc 00 00 00       	jmp    800871 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	6a 30                	push   $0x30
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	ff d0                	call   *%eax
  8007c2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	6a 78                	push   $0x78
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	83 c0 04             	add    $0x4,%eax
  8007db:	89 45 14             	mov    %eax,0x14(%ebp)
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	83 e8 04             	sub    $0x4,%eax
  8007e4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007f0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007f7:	eb 1f                	jmp    800818 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800802:	50                   	push   %eax
  800803:	e8 e7 fb ff ff       	call   8003ef <getuint>
  800808:	83 c4 10             	add    $0x10,%esp
  80080b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800811:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800818:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80081c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081f:	83 ec 04             	sub    $0x4,%esp
  800822:	52                   	push   %edx
  800823:	ff 75 e4             	pushl  -0x1c(%ebp)
  800826:	50                   	push   %eax
  800827:	ff 75 f4             	pushl  -0xc(%ebp)
  80082a:	ff 75 f0             	pushl  -0x10(%ebp)
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	ff 75 08             	pushl  0x8(%ebp)
  800833:	e8 00 fb ff ff       	call   800338 <printnum>
  800838:	83 c4 20             	add    $0x20,%esp
			break;
  80083b:	eb 34                	jmp    800871 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	eb 23                	jmp    800871 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	ff 75 0c             	pushl  0xc(%ebp)
  800854:	6a 25                	push   $0x25
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	ff d0                	call   *%eax
  80085b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085e:	ff 4d 10             	decl   0x10(%ebp)
  800861:	eb 03                	jmp    800866 <vprintfmt+0x3b1>
  800863:	ff 4d 10             	decl   0x10(%ebp)
  800866:	8b 45 10             	mov    0x10(%ebp),%eax
  800869:	48                   	dec    %eax
  80086a:	8a 00                	mov    (%eax),%al
  80086c:	3c 25                	cmp    $0x25,%al
  80086e:	75 f3                	jne    800863 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800870:	90                   	nop
		}
	}
  800871:	e9 47 fc ff ff       	jmp    8004bd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800876:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800877:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800884:	8d 45 10             	lea    0x10(%ebp),%eax
  800887:	83 c0 04             	add    $0x4,%eax
  80088a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80088d:	8b 45 10             	mov    0x10(%ebp),%eax
  800890:	ff 75 f4             	pushl  -0xc(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	ff 75 08             	pushl  0x8(%ebp)
  80089a:	e8 16 fc ff ff       	call   8004b5 <vprintfmt>
  80089f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008a2:	90                   	nop
  8008a3:	c9                   	leave  
  8008a4:	c3                   	ret    

008008a5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008a5:	55                   	push   %ebp
  8008a6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ab:	8b 40 08             	mov    0x8(%eax),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ba:	8b 10                	mov    (%eax),%edx
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 40 04             	mov    0x4(%eax),%eax
  8008c2:	39 c2                	cmp    %eax,%edx
  8008c4:	73 12                	jae    8008d8 <sprintputch+0x33>
		*b->buf++ = ch;
  8008c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	8d 48 01             	lea    0x1(%eax),%ecx
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d1:	89 0a                	mov    %ecx,(%edx)
  8008d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d6:	88 10                	mov    %dl,(%eax)
}
  8008d8:	90                   	nop
  8008d9:	5d                   	pop    %ebp
  8008da:	c3                   	ret    

008008db <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	01 d0                	add    %edx,%eax
  8008f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800900:	74 06                	je     800908 <vsnprintf+0x2d>
  800902:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800906:	7f 07                	jg     80090f <vsnprintf+0x34>
		return -E_INVAL;
  800908:	b8 03 00 00 00       	mov    $0x3,%eax
  80090d:	eb 20                	jmp    80092f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090f:	ff 75 14             	pushl  0x14(%ebp)
  800912:	ff 75 10             	pushl  0x10(%ebp)
  800915:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800918:	50                   	push   %eax
  800919:	68 a5 08 80 00       	push   $0x8008a5
  80091e:	e8 92 fb ff ff       	call   8004b5 <vprintfmt>
  800923:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800929:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800937:	8d 45 10             	lea    0x10(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800940:	8b 45 10             	mov    0x10(%ebp),%eax
  800943:	ff 75 f4             	pushl  -0xc(%ebp)
  800946:	50                   	push   %eax
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	e8 89 ff ff ff       	call   8008db <vsnprintf>
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800958:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80095b:	c9                   	leave  
  80095c:	c3                   	ret    

0080095d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800963:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800967:	74 13                	je     80097c <readline+0x1f>
		cprintf("%s", prompt);
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	ff 75 08             	pushl  0x8(%ebp)
  80096f:	68 70 20 80 00       	push   $0x802070
  800974:	e8 62 f9 ff ff       	call   8002db <cprintf>
  800979:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80097c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800983:	83 ec 0c             	sub    $0xc,%esp
  800986:	6a 00                	push   $0x0
  800988:	e8 d2 0f 00 00       	call   80195f <iscons>
  80098d:	83 c4 10             	add    $0x10,%esp
  800990:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800993:	e8 79 0f 00 00       	call   801911 <getchar>
  800998:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80099b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80099f:	79 22                	jns    8009c3 <readline+0x66>
			if (c != -E_EOF)
  8009a1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009a5:	0f 84 ad 00 00 00    	je     800a58 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8009b1:	68 73 20 80 00       	push   $0x802073
  8009b6:	e8 20 f9 ff ff       	call   8002db <cprintf>
  8009bb:	83 c4 10             	add    $0x10,%esp
			return;
  8009be:	e9 95 00 00 00       	jmp    800a58 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009c3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009c7:	7e 34                	jle    8009fd <readline+0xa0>
  8009c9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009d0:	7f 2b                	jg     8009fd <readline+0xa0>
			if (echoing)
  8009d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009d6:	74 0e                	je     8009e6 <readline+0x89>
				cputchar(c);
  8009d8:	83 ec 0c             	sub    $0xc,%esp
  8009db:	ff 75 ec             	pushl  -0x14(%ebp)
  8009de:	e8 e6 0e 00 00       	call   8018c9 <cputchar>
  8009e3:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e9:	8d 50 01             	lea    0x1(%eax),%edx
  8009ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8009ef:	89 c2                	mov    %eax,%edx
  8009f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f4:	01 d0                	add    %edx,%eax
  8009f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8009f9:	88 10                	mov    %dl,(%eax)
  8009fb:	eb 56                	jmp    800a53 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8009fd:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a01:	75 1f                	jne    800a22 <readline+0xc5>
  800a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a07:	7e 19                	jle    800a22 <readline+0xc5>
			if (echoing)
  800a09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a0d:	74 0e                	je     800a1d <readline+0xc0>
				cputchar(c);
  800a0f:	83 ec 0c             	sub    $0xc,%esp
  800a12:	ff 75 ec             	pushl  -0x14(%ebp)
  800a15:	e8 af 0e 00 00       	call   8018c9 <cputchar>
  800a1a:	83 c4 10             	add    $0x10,%esp

			i--;
  800a1d:	ff 4d f4             	decl   -0xc(%ebp)
  800a20:	eb 31                	jmp    800a53 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a22:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a26:	74 0a                	je     800a32 <readline+0xd5>
  800a28:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a2c:	0f 85 61 ff ff ff    	jne    800993 <readline+0x36>
			if (echoing)
  800a32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a36:	74 0e                	je     800a46 <readline+0xe9>
				cputchar(c);
  800a38:	83 ec 0c             	sub    $0xc,%esp
  800a3b:	ff 75 ec             	pushl  -0x14(%ebp)
  800a3e:	e8 86 0e 00 00       	call   8018c9 <cputchar>
  800a43:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	01 d0                	add    %edx,%eax
  800a4e:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a51:	eb 06                	jmp    800a59 <readline+0xfc>
		}
	}
  800a53:	e9 3b ff ff ff       	jmp    800993 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a58:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a61:	e8 de 09 00 00       	call   801444 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a6a:	74 13                	je     800a7f <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 08             	pushl  0x8(%ebp)
  800a72:	68 70 20 80 00       	push   $0x802070
  800a77:	e8 5f f8 ff ff       	call   8002db <cprintf>
  800a7c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a86:	83 ec 0c             	sub    $0xc,%esp
  800a89:	6a 00                	push   $0x0
  800a8b:	e8 cf 0e 00 00       	call   80195f <iscons>
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800a96:	e8 76 0e 00 00       	call   801911 <getchar>
  800a9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800a9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aa2:	79 23                	jns    800ac7 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800aa4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aa8:	74 13                	je     800abd <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800aaa:	83 ec 08             	sub    $0x8,%esp
  800aad:	ff 75 ec             	pushl  -0x14(%ebp)
  800ab0:	68 73 20 80 00       	push   $0x802073
  800ab5:	e8 21 f8 ff ff       	call   8002db <cprintf>
  800aba:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800abd:	e8 9c 09 00 00       	call   80145e <sys_enable_interrupt>
			return;
  800ac2:	e9 9a 00 00 00       	jmp    800b61 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ac7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800acb:	7e 34                	jle    800b01 <atomic_readline+0xa6>
  800acd:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ad4:	7f 2b                	jg     800b01 <atomic_readline+0xa6>
			if (echoing)
  800ad6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ada:	74 0e                	je     800aea <atomic_readline+0x8f>
				cputchar(c);
  800adc:	83 ec 0c             	sub    $0xc,%esp
  800adf:	ff 75 ec             	pushl  -0x14(%ebp)
  800ae2:	e8 e2 0d 00 00       	call   8018c9 <cputchar>
  800ae7:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800aed:	8d 50 01             	lea    0x1(%eax),%edx
  800af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800af3:	89 c2                	mov    %eax,%edx
  800af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af8:	01 d0                	add    %edx,%eax
  800afa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800afd:	88 10                	mov    %dl,(%eax)
  800aff:	eb 5b                	jmp    800b5c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b01:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b05:	75 1f                	jne    800b26 <atomic_readline+0xcb>
  800b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b0b:	7e 19                	jle    800b26 <atomic_readline+0xcb>
			if (echoing)
  800b0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b11:	74 0e                	je     800b21 <atomic_readline+0xc6>
				cputchar(c);
  800b13:	83 ec 0c             	sub    $0xc,%esp
  800b16:	ff 75 ec             	pushl  -0x14(%ebp)
  800b19:	e8 ab 0d 00 00       	call   8018c9 <cputchar>
  800b1e:	83 c4 10             	add    $0x10,%esp
			i--;
  800b21:	ff 4d f4             	decl   -0xc(%ebp)
  800b24:	eb 36                	jmp    800b5c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b26:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b2a:	74 0a                	je     800b36 <atomic_readline+0xdb>
  800b2c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b30:	0f 85 60 ff ff ff    	jne    800a96 <atomic_readline+0x3b>
			if (echoing)
  800b36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b3a:	74 0e                	je     800b4a <atomic_readline+0xef>
				cputchar(c);
  800b3c:	83 ec 0c             	sub    $0xc,%esp
  800b3f:	ff 75 ec             	pushl  -0x14(%ebp)
  800b42:	e8 82 0d 00 00       	call   8018c9 <cputchar>
  800b47:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	01 d0                	add    %edx,%eax
  800b52:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b55:	e8 04 09 00 00       	call   80145e <sys_enable_interrupt>
			return;
  800b5a:	eb 05                	jmp    800b61 <atomic_readline+0x106>
		}
	}
  800b5c:	e9 35 ff ff ff       	jmp    800a96 <atomic_readline+0x3b>
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b70:	eb 06                	jmp    800b78 <strlen+0x15>
		n++;
  800b72:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b75:	ff 45 08             	incl   0x8(%ebp)
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8a 00                	mov    (%eax),%al
  800b7d:	84 c0                	test   %al,%al
  800b7f:	75 f1                	jne    800b72 <strlen+0xf>
		n++;
	return n;
  800b81:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b93:	eb 09                	jmp    800b9e <strnlen+0x18>
		n++;
  800b95:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b98:	ff 45 08             	incl   0x8(%ebp)
  800b9b:	ff 4d 0c             	decl   0xc(%ebp)
  800b9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba2:	74 09                	je     800bad <strnlen+0x27>
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	8a 00                	mov    (%eax),%al
  800ba9:	84 c0                	test   %al,%al
  800bab:	75 e8                	jne    800b95 <strnlen+0xf>
		n++;
	return n;
  800bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb0:	c9                   	leave  
  800bb1:	c3                   	ret    

00800bb2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bbe:	90                   	nop
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8d 50 01             	lea    0x1(%eax),%edx
  800bc5:	89 55 08             	mov    %edx,0x8(%ebp)
  800bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bce:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bd1:	8a 12                	mov    (%edx),%dl
  800bd3:	88 10                	mov    %dl,(%eax)
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	84 c0                	test   %al,%al
  800bd9:	75 e4                	jne    800bbf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf3:	eb 1f                	jmp    800c14 <strncpy+0x34>
		*dst++ = *src;
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8d 50 01             	lea    0x1(%eax),%edx
  800bfb:	89 55 08             	mov    %edx,0x8(%ebp)
  800bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c01:	8a 12                	mov    (%edx),%dl
  800c03:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	8a 00                	mov    (%eax),%al
  800c0a:	84 c0                	test   %al,%al
  800c0c:	74 03                	je     800c11 <strncpy+0x31>
			src++;
  800c0e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c11:	ff 45 fc             	incl   -0x4(%ebp)
  800c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c17:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c1a:	72 d9                	jb     800bf5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c1f:	c9                   	leave  
  800c20:	c3                   	ret    

00800c21 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c31:	74 30                	je     800c63 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c33:	eb 16                	jmp    800c4b <strlcpy+0x2a>
			*dst++ = *src++;
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8d 50 01             	lea    0x1(%eax),%edx
  800c3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c41:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c44:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c47:	8a 12                	mov    (%edx),%dl
  800c49:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c4b:	ff 4d 10             	decl   0x10(%ebp)
  800c4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c52:	74 09                	je     800c5d <strlcpy+0x3c>
  800c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	84 c0                	test   %al,%al
  800c5b:	75 d8                	jne    800c35 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c63:	8b 55 08             	mov    0x8(%ebp),%edx
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c69:	29 c2                	sub    %eax,%edx
  800c6b:	89 d0                	mov    %edx,%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c72:	eb 06                	jmp    800c7a <strcmp+0xb>
		p++, q++;
  800c74:	ff 45 08             	incl   0x8(%ebp)
  800c77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	84 c0                	test   %al,%al
  800c81:	74 0e                	je     800c91 <strcmp+0x22>
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8a 10                	mov    (%eax),%dl
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	8a 00                	mov    (%eax),%al
  800c8d:	38 c2                	cmp    %al,%dl
  800c8f:	74 e3                	je     800c74 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	8a 00                	mov    (%eax),%al
  800c96:	0f b6 d0             	movzbl %al,%edx
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	0f b6 c0             	movzbl %al,%eax
  800ca1:	29 c2                	sub    %eax,%edx
  800ca3:	89 d0                	mov    %edx,%eax
}
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800caa:	eb 09                	jmp    800cb5 <strncmp+0xe>
		n--, p++, q++;
  800cac:	ff 4d 10             	decl   0x10(%ebp)
  800caf:	ff 45 08             	incl   0x8(%ebp)
  800cb2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb9:	74 17                	je     800cd2 <strncmp+0x2b>
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8a 00                	mov    (%eax),%al
  800cc0:	84 c0                	test   %al,%al
  800cc2:	74 0e                	je     800cd2 <strncmp+0x2b>
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 10                	mov    (%eax),%dl
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	38 c2                	cmp    %al,%dl
  800cd0:	74 da                	je     800cac <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd6:	75 07                	jne    800cdf <strncmp+0x38>
		return 0;
  800cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdd:	eb 14                	jmp    800cf3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	0f b6 d0             	movzbl %al,%edx
  800ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	0f b6 c0             	movzbl %al,%eax
  800cef:	29 c2                	sub    %eax,%edx
  800cf1:	89 d0                	mov    %edx,%eax
}
  800cf3:	5d                   	pop    %ebp
  800cf4:	c3                   	ret    

00800cf5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cf5:	55                   	push   %ebp
  800cf6:	89 e5                	mov    %esp,%ebp
  800cf8:	83 ec 04             	sub    $0x4,%esp
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d01:	eb 12                	jmp    800d15 <strchr+0x20>
		if (*s == c)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d0b:	75 05                	jne    800d12 <strchr+0x1d>
			return (char *) s;
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	eb 11                	jmp    800d23 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	84 c0                	test   %al,%al
  800d1c:	75 e5                	jne    800d03 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 04             	sub    $0x4,%esp
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d31:	eb 0d                	jmp    800d40 <strfind+0x1b>
		if (*s == c)
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d3b:	74 0e                	je     800d4b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d3d:	ff 45 08             	incl   0x8(%ebp)
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	75 ea                	jne    800d33 <strfind+0xe>
  800d49:	eb 01                	jmp    800d4c <strfind+0x27>
		if (*s == c)
			break;
  800d4b:	90                   	nop
	return (char *) s;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d63:	eb 0e                	jmp    800d73 <memset+0x22>
		*p++ = c;
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	8d 50 01             	lea    0x1(%eax),%edx
  800d6b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d73:	ff 4d f8             	decl   -0x8(%ebp)
  800d76:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d7a:	79 e9                	jns    800d65 <memset+0x14>
		*p++ = c;

	return v;
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d93:	eb 16                	jmp    800dab <memcpy+0x2a>
		*d++ = *s++;
  800d95:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d98:	8d 50 01             	lea    0x1(%eax),%edx
  800d9b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800da1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800da7:	8a 12                	mov    (%edx),%dl
  800da9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dab:	8b 45 10             	mov    0x10(%ebp),%eax
  800dae:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db1:	89 55 10             	mov    %edx,0x10(%ebp)
  800db4:	85 c0                	test   %eax,%eax
  800db6:	75 dd                	jne    800d95 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbb:	c9                   	leave  
  800dbc:	c3                   	ret    

00800dbd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800dd5:	73 50                	jae    800e27 <memmove+0x6a>
  800dd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dda:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddd:	01 d0                	add    %edx,%eax
  800ddf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800de2:	76 43                	jbe    800e27 <memmove+0x6a>
		s += n;
  800de4:	8b 45 10             	mov    0x10(%ebp),%eax
  800de7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ded:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800df0:	eb 10                	jmp    800e02 <memmove+0x45>
			*--d = *--s;
  800df2:	ff 4d f8             	decl   -0x8(%ebp)
  800df5:	ff 4d fc             	decl   -0x4(%ebp)
  800df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dfb:	8a 10                	mov    (%eax),%dl
  800dfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e00:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e02:	8b 45 10             	mov    0x10(%ebp),%eax
  800e05:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e08:	89 55 10             	mov    %edx,0x10(%ebp)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	75 e3                	jne    800df2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e0f:	eb 23                	jmp    800e34 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e14:	8d 50 01             	lea    0x1(%eax),%edx
  800e17:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e20:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e23:	8a 12                	mov    (%edx),%dl
  800e25:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e2d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e30:	85 c0                	test   %eax,%eax
  800e32:	75 dd                	jne    800e11 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e4b:	eb 2a                	jmp    800e77 <memcmp+0x3e>
		if (*s1 != *s2)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	38 c2                	cmp    %al,%dl
  800e59:	74 16                	je     800e71 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	8a 00                	mov    (%eax),%al
  800e60:	0f b6 d0             	movzbl %al,%edx
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	0f b6 c0             	movzbl %al,%eax
  800e6b:	29 c2                	sub    %eax,%edx
  800e6d:	89 d0                	mov    %edx,%eax
  800e6f:	eb 18                	jmp    800e89 <memcmp+0x50>
		s1++, s2++;
  800e71:	ff 45 fc             	incl   -0x4(%ebp)
  800e74:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e77:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e80:	85 c0                	test   %eax,%eax
  800e82:	75 c9                	jne    800e4d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e91:	8b 55 08             	mov    0x8(%ebp),%edx
  800e94:	8b 45 10             	mov    0x10(%ebp),%eax
  800e97:	01 d0                	add    %edx,%eax
  800e99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e9c:	eb 15                	jmp    800eb3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	0f b6 d0             	movzbl %al,%edx
  800ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea9:	0f b6 c0             	movzbl %al,%eax
  800eac:	39 c2                	cmp    %eax,%edx
  800eae:	74 0d                	je     800ebd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eb0:	ff 45 08             	incl   0x8(%ebp)
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eb9:	72 e3                	jb     800e9e <memfind+0x13>
  800ebb:	eb 01                	jmp    800ebe <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ebd:	90                   	nop
	return (void *) s;
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec1:	c9                   	leave  
  800ec2:	c3                   	ret    

00800ec3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ec9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ed0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed7:	eb 03                	jmp    800edc <strtol+0x19>
		s++;
  800ed9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 20                	cmp    $0x20,%al
  800ee3:	74 f4                	je     800ed9 <strtol+0x16>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 09                	cmp    $0x9,%al
  800eec:	74 eb                	je     800ed9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	3c 2b                	cmp    $0x2b,%al
  800ef5:	75 05                	jne    800efc <strtol+0x39>
		s++;
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	eb 13                	jmp    800f0f <strtol+0x4c>
	else if (*s == '-')
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	3c 2d                	cmp    $0x2d,%al
  800f03:	75 0a                	jne    800f0f <strtol+0x4c>
		s++, neg = 1;
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f13:	74 06                	je     800f1b <strtol+0x58>
  800f15:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f19:	75 20                	jne    800f3b <strtol+0x78>
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 30                	cmp    $0x30,%al
  800f22:	75 17                	jne    800f3b <strtol+0x78>
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	40                   	inc    %eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	3c 78                	cmp    $0x78,%al
  800f2c:	75 0d                	jne    800f3b <strtol+0x78>
		s += 2, base = 16;
  800f2e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f32:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f39:	eb 28                	jmp    800f63 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3f:	75 15                	jne    800f56 <strtol+0x93>
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	3c 30                	cmp    $0x30,%al
  800f48:	75 0c                	jne    800f56 <strtol+0x93>
		s++, base = 8;
  800f4a:	ff 45 08             	incl   0x8(%ebp)
  800f4d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f54:	eb 0d                	jmp    800f63 <strtol+0xa0>
	else if (base == 0)
  800f56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5a:	75 07                	jne    800f63 <strtol+0xa0>
		base = 10;
  800f5c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	3c 2f                	cmp    $0x2f,%al
  800f6a:	7e 19                	jle    800f85 <strtol+0xc2>
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 39                	cmp    $0x39,%al
  800f73:	7f 10                	jg     800f85 <strtol+0xc2>
			dig = *s - '0';
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f be c0             	movsbl %al,%eax
  800f7d:	83 e8 30             	sub    $0x30,%eax
  800f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f83:	eb 42                	jmp    800fc7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 60                	cmp    $0x60,%al
  800f8c:	7e 19                	jle    800fa7 <strtol+0xe4>
  800f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	3c 7a                	cmp    $0x7a,%al
  800f95:	7f 10                	jg     800fa7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f be c0             	movsbl %al,%eax
  800f9f:	83 e8 57             	sub    $0x57,%eax
  800fa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fa5:	eb 20                	jmp    800fc7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 40                	cmp    $0x40,%al
  800fae:	7e 39                	jle    800fe9 <strtol+0x126>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 5a                	cmp    $0x5a,%al
  800fb7:	7f 30                	jg     800fe9 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	83 e8 37             	sub    $0x37,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fca:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fcd:	7d 19                	jge    800fe8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fd9:	89 c2                	mov    %eax,%edx
  800fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fde:	01 d0                	add    %edx,%eax
  800fe0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800fe3:	e9 7b ff ff ff       	jmp    800f63 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800fe8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fe9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fed:	74 08                	je     800ff7 <strtol+0x134>
		*endptr = (char *) s;
  800fef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ff7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ffb:	74 07                	je     801004 <strtol+0x141>
  800ffd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801000:	f7 d8                	neg    %eax
  801002:	eb 03                	jmp    801007 <strtol+0x144>
  801004:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801007:	c9                   	leave  
  801008:	c3                   	ret    

00801009 <ltostr>:

void
ltostr(long value, char *str)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80100f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801016:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80101d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801021:	79 13                	jns    801036 <ltostr+0x2d>
	{
		neg = 1;
  801023:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80102a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801030:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801033:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80103e:	99                   	cltd   
  80103f:	f7 f9                	idiv   %ecx
  801041:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801044:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801047:	8d 50 01             	lea    0x1(%eax),%edx
  80104a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80104d:	89 c2                	mov    %eax,%edx
  80104f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801052:	01 d0                	add    %edx,%eax
  801054:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801057:	83 c2 30             	add    $0x30,%edx
  80105a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80105c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80105f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801064:	f7 e9                	imul   %ecx
  801066:	c1 fa 02             	sar    $0x2,%edx
  801069:	89 c8                	mov    %ecx,%eax
  80106b:	c1 f8 1f             	sar    $0x1f,%eax
  80106e:	29 c2                	sub    %eax,%edx
  801070:	89 d0                	mov    %edx,%eax
  801072:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801075:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801078:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80107d:	f7 e9                	imul   %ecx
  80107f:	c1 fa 02             	sar    $0x2,%edx
  801082:	89 c8                	mov    %ecx,%eax
  801084:	c1 f8 1f             	sar    $0x1f,%eax
  801087:	29 c2                	sub    %eax,%edx
  801089:	89 d0                	mov    %edx,%eax
  80108b:	c1 e0 02             	shl    $0x2,%eax
  80108e:	01 d0                	add    %edx,%eax
  801090:	01 c0                	add    %eax,%eax
  801092:	29 c1                	sub    %eax,%ecx
  801094:	89 ca                	mov    %ecx,%edx
  801096:	85 d2                	test   %edx,%edx
  801098:	75 9c                	jne    801036 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80109a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	48                   	dec    %eax
  8010a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010a8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ac:	74 3d                	je     8010eb <ltostr+0xe2>
		start = 1 ;
  8010ae:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010b5:	eb 34                	jmp    8010eb <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	01 d0                	add    %edx,%eax
  8010bf:	8a 00                	mov    (%eax),%al
  8010c1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ca:	01 c2                	add    %eax,%edx
  8010cc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d2:	01 c8                	add    %ecx,%eax
  8010d4:	8a 00                	mov    (%eax),%al
  8010d6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	01 c2                	add    %eax,%edx
  8010e0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010e3:	88 02                	mov    %al,(%edx)
		start++ ;
  8010e5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010e8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010f1:	7c c4                	jl     8010b7 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8010f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	01 d0                	add    %edx,%eax
  8010fb:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8010fe:	90                   	nop
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801107:	ff 75 08             	pushl  0x8(%ebp)
  80110a:	e8 54 fa ff ff       	call   800b63 <strlen>
  80110f:	83 c4 04             	add    $0x4,%esp
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801115:	ff 75 0c             	pushl  0xc(%ebp)
  801118:	e8 46 fa ff ff       	call   800b63 <strlen>
  80111d:	83 c4 04             	add    $0x4,%esp
  801120:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80112a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801131:	eb 17                	jmp    80114a <strcconcat+0x49>
		final[s] = str1[s] ;
  801133:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	01 c2                	add    %eax,%edx
  80113b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	01 c8                	add    %ecx,%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801147:	ff 45 fc             	incl   -0x4(%ebp)
  80114a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801150:	7c e1                	jl     801133 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801152:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801159:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801160:	eb 1f                	jmp    801181 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801162:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801165:	8d 50 01             	lea    0x1(%eax),%edx
  801168:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80116b:	89 c2                	mov    %eax,%edx
  80116d:	8b 45 10             	mov    0x10(%ebp),%eax
  801170:	01 c2                	add    %eax,%edx
  801172:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801175:	8b 45 0c             	mov    0xc(%ebp),%eax
  801178:	01 c8                	add    %ecx,%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80117e:	ff 45 f8             	incl   -0x8(%ebp)
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801187:	7c d9                	jl     801162 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801189:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	c6 00 00             	movb   $0x0,(%eax)
}
  801194:	90                   	nop
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80119a:	8b 45 14             	mov    0x14(%ebp),%eax
  80119d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a6:	8b 00                	mov    (%eax),%eax
  8011a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	01 d0                	add    %edx,%eax
  8011b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ba:	eb 0c                	jmp    8011c8 <strsplit+0x31>
			*string++ = 0;
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	8d 50 01             	lea    0x1(%eax),%edx
  8011c2:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	84 c0                	test   %al,%al
  8011cf:	74 18                	je     8011e9 <strsplit+0x52>
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	0f be c0             	movsbl %al,%eax
  8011d9:	50                   	push   %eax
  8011da:	ff 75 0c             	pushl  0xc(%ebp)
  8011dd:	e8 13 fb ff ff       	call   800cf5 <strchr>
  8011e2:	83 c4 08             	add    $0x8,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	75 d3                	jne    8011bc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	84 c0                	test   %al,%al
  8011f0:	74 5a                	je     80124c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8011f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f5:	8b 00                	mov    (%eax),%eax
  8011f7:	83 f8 0f             	cmp    $0xf,%eax
  8011fa:	75 07                	jne    801203 <strsplit+0x6c>
		{
			return 0;
  8011fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801201:	eb 66                	jmp    801269 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801203:	8b 45 14             	mov    0x14(%ebp),%eax
  801206:	8b 00                	mov    (%eax),%eax
  801208:	8d 48 01             	lea    0x1(%eax),%ecx
  80120b:	8b 55 14             	mov    0x14(%ebp),%edx
  80120e:	89 0a                	mov    %ecx,(%edx)
  801210:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801217:	8b 45 10             	mov    0x10(%ebp),%eax
  80121a:	01 c2                	add    %eax,%edx
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801221:	eb 03                	jmp    801226 <strsplit+0x8f>
			string++;
  801223:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	84 c0                	test   %al,%al
  80122d:	74 8b                	je     8011ba <strsplit+0x23>
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	0f be c0             	movsbl %al,%eax
  801237:	50                   	push   %eax
  801238:	ff 75 0c             	pushl  0xc(%ebp)
  80123b:	e8 b5 fa ff ff       	call   800cf5 <strchr>
  801240:	83 c4 08             	add    $0x8,%esp
  801243:	85 c0                	test   %eax,%eax
  801245:	74 dc                	je     801223 <strsplit+0x8c>
			string++;
	}
  801247:	e9 6e ff ff ff       	jmp    8011ba <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80124c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801259:	8b 45 10             	mov    0x10(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801264:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801269:	c9                   	leave  
  80126a:	c3                   	ret    

0080126b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	57                   	push   %edi
  80126f:	56                   	push   %esi
  801270:	53                   	push   %ebx
  801271:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80127d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801280:	8b 7d 18             	mov    0x18(%ebp),%edi
  801283:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801286:	cd 30                	int    $0x30
  801288:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80128e:	83 c4 10             	add    $0x10,%esp
  801291:	5b                   	pop    %ebx
  801292:	5e                   	pop    %esi
  801293:	5f                   	pop    %edi
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	83 ec 04             	sub    $0x4,%esp
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	6a 00                	push   $0x0
  8012ab:	6a 00                	push   $0x0
  8012ad:	52                   	push   %edx
  8012ae:	ff 75 0c             	pushl  0xc(%ebp)
  8012b1:	50                   	push   %eax
  8012b2:	6a 00                	push   $0x0
  8012b4:	e8 b2 ff ff ff       	call   80126b <syscall>
  8012b9:	83 c4 18             	add    $0x18,%esp
}
  8012bc:	90                   	nop
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <sys_cgetc>:

int
sys_cgetc(void)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	6a 00                	push   $0x0
  8012cc:	6a 01                	push   $0x1
  8012ce:	e8 98 ff ff ff       	call   80126b <syscall>
  8012d3:	83 c4 18             	add    $0x18,%esp
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	6a 00                	push   $0x0
  8012e3:	6a 00                	push   $0x0
  8012e5:	6a 00                	push   $0x0
  8012e7:	52                   	push   %edx
  8012e8:	50                   	push   %eax
  8012e9:	6a 05                	push   $0x5
  8012eb:	e8 7b ff ff ff       	call   80126b <syscall>
  8012f0:	83 c4 18             	add    $0x18,%esp
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8012fa:	8b 75 18             	mov    0x18(%ebp),%esi
  8012fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801300:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	56                   	push   %esi
  80130a:	53                   	push   %ebx
  80130b:	51                   	push   %ecx
  80130c:	52                   	push   %edx
  80130d:	50                   	push   %eax
  80130e:	6a 06                	push   $0x6
  801310:	e8 56 ff ff ff       	call   80126b <syscall>
  801315:	83 c4 18             	add    $0x18,%esp
}
  801318:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80131b:	5b                   	pop    %ebx
  80131c:	5e                   	pop    %esi
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    

0080131f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801322:	8b 55 0c             	mov    0xc(%ebp),%edx
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 00                	push   $0x0
  80132e:	52                   	push   %edx
  80132f:	50                   	push   %eax
  801330:	6a 07                	push   $0x7
  801332:	e8 34 ff ff ff       	call   80126b <syscall>
  801337:	83 c4 18             	add    $0x18,%esp
}
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	ff 75 0c             	pushl  0xc(%ebp)
  801348:	ff 75 08             	pushl  0x8(%ebp)
  80134b:	6a 08                	push   $0x8
  80134d:	e8 19 ff ff ff       	call   80126b <syscall>
  801352:	83 c4 18             	add    $0x18,%esp
}
  801355:	c9                   	leave  
  801356:	c3                   	ret    

00801357 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	6a 09                	push   $0x9
  801366:	e8 00 ff ff ff       	call   80126b <syscall>
  80136b:	83 c4 18             	add    $0x18,%esp
}
  80136e:	c9                   	leave  
  80136f:	c3                   	ret    

00801370 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801373:	6a 00                	push   $0x0
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	6a 00                	push   $0x0
  80137d:	6a 0a                	push   $0xa
  80137f:	e8 e7 fe ff ff       	call   80126b <syscall>
  801384:	83 c4 18             	add    $0x18,%esp
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 0b                	push   $0xb
  801398:	e8 ce fe ff ff       	call   80126b <syscall>
  80139d:	83 c4 18             	add    $0x18,%esp
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	ff 75 0c             	pushl  0xc(%ebp)
  8013ae:	ff 75 08             	pushl  0x8(%ebp)
  8013b1:	6a 0f                	push   $0xf
  8013b3:	e8 b3 fe ff ff       	call   80126b <syscall>
  8013b8:	83 c4 18             	add    $0x18,%esp
	return;
  8013bb:	90                   	nop
}
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	ff 75 0c             	pushl  0xc(%ebp)
  8013ca:	ff 75 08             	pushl  0x8(%ebp)
  8013cd:	6a 10                	push   $0x10
  8013cf:	e8 97 fe ff ff       	call   80126b <syscall>
  8013d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8013d7:	90                   	nop
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	ff 75 10             	pushl  0x10(%ebp)
  8013e4:	ff 75 0c             	pushl  0xc(%ebp)
  8013e7:	ff 75 08             	pushl  0x8(%ebp)
  8013ea:	6a 11                	push   $0x11
  8013ec:	e8 7a fe ff ff       	call   80126b <syscall>
  8013f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8013f4:	90                   	nop
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	6a 0c                	push   $0xc
  801406:	e8 60 fe ff ff       	call   80126b <syscall>
  80140b:	83 c4 18             	add    $0x18,%esp
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	ff 75 08             	pushl  0x8(%ebp)
  80141e:	6a 0d                	push   $0xd
  801420:	e8 46 fe ff ff       	call   80126b <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
}
  801428:	c9                   	leave  
  801429:	c3                   	ret    

0080142a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 0e                	push   $0xe
  801439:	e8 2d fe ff ff       	call   80126b <syscall>
  80143e:	83 c4 18             	add    $0x18,%esp
}
  801441:	90                   	nop
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 13                	push   $0x13
  801453:	e8 13 fe ff ff       	call   80126b <syscall>
  801458:	83 c4 18             	add    $0x18,%esp
}
  80145b:	90                   	nop
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 14                	push   $0x14
  80146d:	e8 f9 fd ff ff       	call   80126b <syscall>
  801472:	83 c4 18             	add    $0x18,%esp
}
  801475:	90                   	nop
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <sys_cputc>:


void
sys_cputc(const char c)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	83 ec 04             	sub    $0x4,%esp
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801484:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	50                   	push   %eax
  801491:	6a 15                	push   $0x15
  801493:	e8 d3 fd ff ff       	call   80126b <syscall>
  801498:	83 c4 18             	add    $0x18,%esp
}
  80149b:	90                   	nop
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 16                	push   $0x16
  8014ad:	e8 b9 fd ff ff       	call   80126b <syscall>
  8014b2:	83 c4 18             	add    $0x18,%esp
}
  8014b5:	90                   	nop
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	ff 75 0c             	pushl  0xc(%ebp)
  8014c7:	50                   	push   %eax
  8014c8:	6a 17                	push   $0x17
  8014ca:	e8 9c fd ff ff       	call   80126b <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	52                   	push   %edx
  8014e4:	50                   	push   %eax
  8014e5:	6a 1a                	push   $0x1a
  8014e7:	e8 7f fd ff ff       	call   80126b <syscall>
  8014ec:	83 c4 18             	add    $0x18,%esp
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	52                   	push   %edx
  801501:	50                   	push   %eax
  801502:	6a 18                	push   $0x18
  801504:	e8 62 fd ff ff       	call   80126b <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	90                   	nop
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801512:	8b 55 0c             	mov    0xc(%ebp),%edx
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	52                   	push   %edx
  80151f:	50                   	push   %eax
  801520:	6a 19                	push   $0x19
  801522:	e8 44 fd ff ff       	call   80126b <syscall>
  801527:	83 c4 18             	add    $0x18,%esp
}
  80152a:	90                   	nop
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 04             	sub    $0x4,%esp
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801539:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80153c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	6a 00                	push   $0x0
  801545:	51                   	push   %ecx
  801546:	52                   	push   %edx
  801547:	ff 75 0c             	pushl  0xc(%ebp)
  80154a:	50                   	push   %eax
  80154b:	6a 1b                	push   $0x1b
  80154d:	e8 19 fd ff ff       	call   80126b <syscall>
  801552:	83 c4 18             	add    $0x18,%esp
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80155a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	52                   	push   %edx
  801567:	50                   	push   %eax
  801568:	6a 1c                	push   $0x1c
  80156a:	e8 fc fc ff ff       	call   80126b <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801577:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80157a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	51                   	push   %ecx
  801585:	52                   	push   %edx
  801586:	50                   	push   %eax
  801587:	6a 1d                	push   $0x1d
  801589:	e8 dd fc ff ff       	call   80126b <syscall>
  80158e:	83 c4 18             	add    $0x18,%esp
}
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801596:	8b 55 0c             	mov    0xc(%ebp),%edx
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	52                   	push   %edx
  8015a3:	50                   	push   %eax
  8015a4:	6a 1e                	push   $0x1e
  8015a6:	e8 c0 fc ff ff       	call   80126b <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 1f                	push   $0x1f
  8015bf:	e8 a7 fc ff ff       	call   80126b <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	6a 00                	push   $0x0
  8015d1:	ff 75 14             	pushl  0x14(%ebp)
  8015d4:	ff 75 10             	pushl  0x10(%ebp)
  8015d7:	ff 75 0c             	pushl  0xc(%ebp)
  8015da:	50                   	push   %eax
  8015db:	6a 20                	push   $0x20
  8015dd:	e8 89 fc ff ff       	call   80126b <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	50                   	push   %eax
  8015f6:	6a 21                	push   $0x21
  8015f8:	e8 6e fc ff ff       	call   80126b <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	90                   	nop
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	50                   	push   %eax
  801612:	6a 22                	push   $0x22
  801614:	e8 52 fc ff ff       	call   80126b <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 02                	push   $0x2
  80162d:	e8 39 fc ff ff       	call   80126b <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 03                	push   $0x3
  801646:	e8 20 fc ff ff       	call   80126b <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 04                	push   $0x4
  80165f:	e8 07 fc ff ff       	call   80126b <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sys_exit_env>:


void sys_exit_env(void)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 23                	push   $0x23
  801678:	e8 ee fb ff ff       	call   80126b <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	90                   	nop
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801689:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80168c:	8d 50 04             	lea    0x4(%eax),%edx
  80168f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	52                   	push   %edx
  801699:	50                   	push   %eax
  80169a:	6a 24                	push   $0x24
  80169c:	e8 ca fb ff ff       	call   80126b <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
	return result;
  8016a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016ad:	89 01                	mov    %eax,(%ecx)
  8016af:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	c9                   	leave  
  8016b6:	c2 04 00             	ret    $0x4

008016b9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	ff 75 10             	pushl  0x10(%ebp)
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	ff 75 08             	pushl  0x8(%ebp)
  8016c9:	6a 12                	push   $0x12
  8016cb:	e8 9b fb ff ff       	call   80126b <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d3:	90                   	nop
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 25                	push   $0x25
  8016e5:	e8 81 fb ff ff       	call   80126b <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 04             	sub    $0x4,%esp
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016fb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	50                   	push   %eax
  801708:	6a 26                	push   $0x26
  80170a:	e8 5c fb ff ff       	call   80126b <syscall>
  80170f:	83 c4 18             	add    $0x18,%esp
	return ;
  801712:	90                   	nop
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <rsttst>:
void rsttst()
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 28                	push   $0x28
  801724:	e8 42 fb ff ff       	call   80126b <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
	return ;
  80172c:	90                   	nop
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 04             	sub    $0x4,%esp
  801735:	8b 45 14             	mov    0x14(%ebp),%eax
  801738:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80173b:	8b 55 18             	mov    0x18(%ebp),%edx
  80173e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	ff 75 10             	pushl  0x10(%ebp)
  801747:	ff 75 0c             	pushl  0xc(%ebp)
  80174a:	ff 75 08             	pushl  0x8(%ebp)
  80174d:	6a 27                	push   $0x27
  80174f:	e8 17 fb ff ff       	call   80126b <syscall>
  801754:	83 c4 18             	add    $0x18,%esp
	return ;
  801757:	90                   	nop
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <chktst>:
void chktst(uint32 n)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	ff 75 08             	pushl  0x8(%ebp)
  801768:	6a 29                	push   $0x29
  80176a:	e8 fc fa ff ff       	call   80126b <syscall>
  80176f:	83 c4 18             	add    $0x18,%esp
	return ;
  801772:	90                   	nop
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <inctst>:

void inctst()
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 2a                	push   $0x2a
  801784:	e8 e2 fa ff ff       	call   80126b <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
	return ;
  80178c:	90                   	nop
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <gettst>:
uint32 gettst()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 2b                	push   $0x2b
  80179e:	e8 c8 fa ff ff       	call   80126b <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
  8017ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 2c                	push   $0x2c
  8017ba:	e8 ac fa ff ff       	call   80126b <syscall>
  8017bf:	83 c4 18             	add    $0x18,%esp
  8017c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017c5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017c9:	75 07                	jne    8017d2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d0:	eb 05                	jmp    8017d7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 2c                	push   $0x2c
  8017eb:	e8 7b fa ff ff       	call   80126b <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
  8017f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017f6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017fa:	75 07                	jne    801803 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017fc:	b8 01 00 00 00       	mov    $0x1,%eax
  801801:	eb 05                	jmp    801808 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801803:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 2c                	push   $0x2c
  80181c:	e8 4a fa ff ff       	call   80126b <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
  801824:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801827:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80182b:	75 07                	jne    801834 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80182d:	b8 01 00 00 00       	mov    $0x1,%eax
  801832:	eb 05                	jmp    801839 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801834:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 2c                	push   $0x2c
  80184d:	e8 19 fa ff ff       	call   80126b <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
  801855:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801858:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80185c:	75 07                	jne    801865 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80185e:	b8 01 00 00 00       	mov    $0x1,%eax
  801863:	eb 05                	jmp    80186a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	ff 75 08             	pushl  0x8(%ebp)
  80187a:	6a 2d                	push   $0x2d
  80187c:	e8 ea f9 ff ff       	call   80126b <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
	return ;
  801884:	90                   	nop
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80188b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	53                   	push   %ebx
  80189a:	51                   	push   %ecx
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	6a 2e                	push   $0x2e
  80189f:	e8 c7 f9 ff ff       	call   80126b <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	52                   	push   %edx
  8018bc:	50                   	push   %eax
  8018bd:	6a 2f                	push   $0x2f
  8018bf:	e8 a7 f9 ff ff       	call   80126b <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018d5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018d9:	83 ec 0c             	sub    $0xc,%esp
  8018dc:	50                   	push   %eax
  8018dd:	e8 96 fb ff ff       	call   801478 <sys_cputc>
  8018e2:	83 c4 10             	add    $0x10,%esp
}
  8018e5:	90                   	nop
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8018ee:	e8 51 fb ff ff       	call   801444 <sys_disable_interrupt>
	char c = ch;
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018f9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018fd:	83 ec 0c             	sub    $0xc,%esp
  801900:	50                   	push   %eax
  801901:	e8 72 fb ff ff       	call   801478 <sys_cputc>
  801906:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801909:	e8 50 fb ff ff       	call   80145e <sys_enable_interrupt>
}
  80190e:	90                   	nop
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <getchar>:

int
getchar(void)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801917:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80191e:	eb 08                	jmp    801928 <getchar+0x17>
	{
		c = sys_cgetc();
  801920:	e8 9a f9 ff ff       	call   8012bf <sys_cgetc>
  801925:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801928:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80192c:	74 f2                	je     801920 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80192e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <atomic_getchar>:

int
atomic_getchar(void)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801939:	e8 06 fb ff ff       	call   801444 <sys_disable_interrupt>
	int c=0;
  80193e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801945:	eb 08                	jmp    80194f <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801947:	e8 73 f9 ff ff       	call   8012bf <sys_cgetc>
  80194c:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80194f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801953:	74 f2                	je     801947 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801955:	e8 04 fb ff ff       	call   80145e <sys_enable_interrupt>
	return c;
  80195a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <iscons>:

int iscons(int fdnum)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801962:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    
  801969:	66 90                	xchg   %ax,%ax
  80196b:	90                   	nop

0080196c <__udivdi3>:
  80196c:	55                   	push   %ebp
  80196d:	57                   	push   %edi
  80196e:	56                   	push   %esi
  80196f:	53                   	push   %ebx
  801970:	83 ec 1c             	sub    $0x1c,%esp
  801973:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801977:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80197b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80197f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801983:	89 ca                	mov    %ecx,%edx
  801985:	89 f8                	mov    %edi,%eax
  801987:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80198b:	85 f6                	test   %esi,%esi
  80198d:	75 2d                	jne    8019bc <__udivdi3+0x50>
  80198f:	39 cf                	cmp    %ecx,%edi
  801991:	77 65                	ja     8019f8 <__udivdi3+0x8c>
  801993:	89 fd                	mov    %edi,%ebp
  801995:	85 ff                	test   %edi,%edi
  801997:	75 0b                	jne    8019a4 <__udivdi3+0x38>
  801999:	b8 01 00 00 00       	mov    $0x1,%eax
  80199e:	31 d2                	xor    %edx,%edx
  8019a0:	f7 f7                	div    %edi
  8019a2:	89 c5                	mov    %eax,%ebp
  8019a4:	31 d2                	xor    %edx,%edx
  8019a6:	89 c8                	mov    %ecx,%eax
  8019a8:	f7 f5                	div    %ebp
  8019aa:	89 c1                	mov    %eax,%ecx
  8019ac:	89 d8                	mov    %ebx,%eax
  8019ae:	f7 f5                	div    %ebp
  8019b0:	89 cf                	mov    %ecx,%edi
  8019b2:	89 fa                	mov    %edi,%edx
  8019b4:	83 c4 1c             	add    $0x1c,%esp
  8019b7:	5b                   	pop    %ebx
  8019b8:	5e                   	pop    %esi
  8019b9:	5f                   	pop    %edi
  8019ba:	5d                   	pop    %ebp
  8019bb:	c3                   	ret    
  8019bc:	39 ce                	cmp    %ecx,%esi
  8019be:	77 28                	ja     8019e8 <__udivdi3+0x7c>
  8019c0:	0f bd fe             	bsr    %esi,%edi
  8019c3:	83 f7 1f             	xor    $0x1f,%edi
  8019c6:	75 40                	jne    801a08 <__udivdi3+0x9c>
  8019c8:	39 ce                	cmp    %ecx,%esi
  8019ca:	72 0a                	jb     8019d6 <__udivdi3+0x6a>
  8019cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019d0:	0f 87 9e 00 00 00    	ja     801a74 <__udivdi3+0x108>
  8019d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019db:	89 fa                	mov    %edi,%edx
  8019dd:	83 c4 1c             	add    $0x1c,%esp
  8019e0:	5b                   	pop    %ebx
  8019e1:	5e                   	pop    %esi
  8019e2:	5f                   	pop    %edi
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    
  8019e5:	8d 76 00             	lea    0x0(%esi),%esi
  8019e8:	31 ff                	xor    %edi,%edi
  8019ea:	31 c0                	xor    %eax,%eax
  8019ec:	89 fa                	mov    %edi,%edx
  8019ee:	83 c4 1c             	add    $0x1c,%esp
  8019f1:	5b                   	pop    %ebx
  8019f2:	5e                   	pop    %esi
  8019f3:	5f                   	pop    %edi
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    
  8019f6:	66 90                	xchg   %ax,%ax
  8019f8:	89 d8                	mov    %ebx,%eax
  8019fa:	f7 f7                	div    %edi
  8019fc:	31 ff                	xor    %edi,%edi
  8019fe:	89 fa                	mov    %edi,%edx
  801a00:	83 c4 1c             	add    $0x1c,%esp
  801a03:	5b                   	pop    %ebx
  801a04:	5e                   	pop    %esi
  801a05:	5f                   	pop    %edi
  801a06:	5d                   	pop    %ebp
  801a07:	c3                   	ret    
  801a08:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a0d:	89 eb                	mov    %ebp,%ebx
  801a0f:	29 fb                	sub    %edi,%ebx
  801a11:	89 f9                	mov    %edi,%ecx
  801a13:	d3 e6                	shl    %cl,%esi
  801a15:	89 c5                	mov    %eax,%ebp
  801a17:	88 d9                	mov    %bl,%cl
  801a19:	d3 ed                	shr    %cl,%ebp
  801a1b:	89 e9                	mov    %ebp,%ecx
  801a1d:	09 f1                	or     %esi,%ecx
  801a1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a23:	89 f9                	mov    %edi,%ecx
  801a25:	d3 e0                	shl    %cl,%eax
  801a27:	89 c5                	mov    %eax,%ebp
  801a29:	89 d6                	mov    %edx,%esi
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 ee                	shr    %cl,%esi
  801a2f:	89 f9                	mov    %edi,%ecx
  801a31:	d3 e2                	shl    %cl,%edx
  801a33:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a37:	88 d9                	mov    %bl,%cl
  801a39:	d3 e8                	shr    %cl,%eax
  801a3b:	09 c2                	or     %eax,%edx
  801a3d:	89 d0                	mov    %edx,%eax
  801a3f:	89 f2                	mov    %esi,%edx
  801a41:	f7 74 24 0c          	divl   0xc(%esp)
  801a45:	89 d6                	mov    %edx,%esi
  801a47:	89 c3                	mov    %eax,%ebx
  801a49:	f7 e5                	mul    %ebp
  801a4b:	39 d6                	cmp    %edx,%esi
  801a4d:	72 19                	jb     801a68 <__udivdi3+0xfc>
  801a4f:	74 0b                	je     801a5c <__udivdi3+0xf0>
  801a51:	89 d8                	mov    %ebx,%eax
  801a53:	31 ff                	xor    %edi,%edi
  801a55:	e9 58 ff ff ff       	jmp    8019b2 <__udivdi3+0x46>
  801a5a:	66 90                	xchg   %ax,%ax
  801a5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a60:	89 f9                	mov    %edi,%ecx
  801a62:	d3 e2                	shl    %cl,%edx
  801a64:	39 c2                	cmp    %eax,%edx
  801a66:	73 e9                	jae    801a51 <__udivdi3+0xe5>
  801a68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a6b:	31 ff                	xor    %edi,%edi
  801a6d:	e9 40 ff ff ff       	jmp    8019b2 <__udivdi3+0x46>
  801a72:	66 90                	xchg   %ax,%ax
  801a74:	31 c0                	xor    %eax,%eax
  801a76:	e9 37 ff ff ff       	jmp    8019b2 <__udivdi3+0x46>
  801a7b:	90                   	nop

00801a7c <__umoddi3>:
  801a7c:	55                   	push   %ebp
  801a7d:	57                   	push   %edi
  801a7e:	56                   	push   %esi
  801a7f:	53                   	push   %ebx
  801a80:	83 ec 1c             	sub    $0x1c,%esp
  801a83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a87:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a9b:	89 f3                	mov    %esi,%ebx
  801a9d:	89 fa                	mov    %edi,%edx
  801a9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aa3:	89 34 24             	mov    %esi,(%esp)
  801aa6:	85 c0                	test   %eax,%eax
  801aa8:	75 1a                	jne    801ac4 <__umoddi3+0x48>
  801aaa:	39 f7                	cmp    %esi,%edi
  801aac:	0f 86 a2 00 00 00    	jbe    801b54 <__umoddi3+0xd8>
  801ab2:	89 c8                	mov    %ecx,%eax
  801ab4:	89 f2                	mov    %esi,%edx
  801ab6:	f7 f7                	div    %edi
  801ab8:	89 d0                	mov    %edx,%eax
  801aba:	31 d2                	xor    %edx,%edx
  801abc:	83 c4 1c             	add    $0x1c,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5e                   	pop    %esi
  801ac1:	5f                   	pop    %edi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    
  801ac4:	39 f0                	cmp    %esi,%eax
  801ac6:	0f 87 ac 00 00 00    	ja     801b78 <__umoddi3+0xfc>
  801acc:	0f bd e8             	bsr    %eax,%ebp
  801acf:	83 f5 1f             	xor    $0x1f,%ebp
  801ad2:	0f 84 ac 00 00 00    	je     801b84 <__umoddi3+0x108>
  801ad8:	bf 20 00 00 00       	mov    $0x20,%edi
  801add:	29 ef                	sub    %ebp,%edi
  801adf:	89 fe                	mov    %edi,%esi
  801ae1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ae5:	89 e9                	mov    %ebp,%ecx
  801ae7:	d3 e0                	shl    %cl,%eax
  801ae9:	89 d7                	mov    %edx,%edi
  801aeb:	89 f1                	mov    %esi,%ecx
  801aed:	d3 ef                	shr    %cl,%edi
  801aef:	09 c7                	or     %eax,%edi
  801af1:	89 e9                	mov    %ebp,%ecx
  801af3:	d3 e2                	shl    %cl,%edx
  801af5:	89 14 24             	mov    %edx,(%esp)
  801af8:	89 d8                	mov    %ebx,%eax
  801afa:	d3 e0                	shl    %cl,%eax
  801afc:	89 c2                	mov    %eax,%edx
  801afe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b02:	d3 e0                	shl    %cl,%eax
  801b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b08:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b0c:	89 f1                	mov    %esi,%ecx
  801b0e:	d3 e8                	shr    %cl,%eax
  801b10:	09 d0                	or     %edx,%eax
  801b12:	d3 eb                	shr    %cl,%ebx
  801b14:	89 da                	mov    %ebx,%edx
  801b16:	f7 f7                	div    %edi
  801b18:	89 d3                	mov    %edx,%ebx
  801b1a:	f7 24 24             	mull   (%esp)
  801b1d:	89 c6                	mov    %eax,%esi
  801b1f:	89 d1                	mov    %edx,%ecx
  801b21:	39 d3                	cmp    %edx,%ebx
  801b23:	0f 82 87 00 00 00    	jb     801bb0 <__umoddi3+0x134>
  801b29:	0f 84 91 00 00 00    	je     801bc0 <__umoddi3+0x144>
  801b2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b33:	29 f2                	sub    %esi,%edx
  801b35:	19 cb                	sbb    %ecx,%ebx
  801b37:	89 d8                	mov    %ebx,%eax
  801b39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b3d:	d3 e0                	shl    %cl,%eax
  801b3f:	89 e9                	mov    %ebp,%ecx
  801b41:	d3 ea                	shr    %cl,%edx
  801b43:	09 d0                	or     %edx,%eax
  801b45:	89 e9                	mov    %ebp,%ecx
  801b47:	d3 eb                	shr    %cl,%ebx
  801b49:	89 da                	mov    %ebx,%edx
  801b4b:	83 c4 1c             	add    $0x1c,%esp
  801b4e:	5b                   	pop    %ebx
  801b4f:	5e                   	pop    %esi
  801b50:	5f                   	pop    %edi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    
  801b53:	90                   	nop
  801b54:	89 fd                	mov    %edi,%ebp
  801b56:	85 ff                	test   %edi,%edi
  801b58:	75 0b                	jne    801b65 <__umoddi3+0xe9>
  801b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b5f:	31 d2                	xor    %edx,%edx
  801b61:	f7 f7                	div    %edi
  801b63:	89 c5                	mov    %eax,%ebp
  801b65:	89 f0                	mov    %esi,%eax
  801b67:	31 d2                	xor    %edx,%edx
  801b69:	f7 f5                	div    %ebp
  801b6b:	89 c8                	mov    %ecx,%eax
  801b6d:	f7 f5                	div    %ebp
  801b6f:	89 d0                	mov    %edx,%eax
  801b71:	e9 44 ff ff ff       	jmp    801aba <__umoddi3+0x3e>
  801b76:	66 90                	xchg   %ax,%ax
  801b78:	89 c8                	mov    %ecx,%eax
  801b7a:	89 f2                	mov    %esi,%edx
  801b7c:	83 c4 1c             	add    $0x1c,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5f                   	pop    %edi
  801b82:	5d                   	pop    %ebp
  801b83:	c3                   	ret    
  801b84:	3b 04 24             	cmp    (%esp),%eax
  801b87:	72 06                	jb     801b8f <__umoddi3+0x113>
  801b89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b8d:	77 0f                	ja     801b9e <__umoddi3+0x122>
  801b8f:	89 f2                	mov    %esi,%edx
  801b91:	29 f9                	sub    %edi,%ecx
  801b93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b97:	89 14 24             	mov    %edx,(%esp)
  801b9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ba2:	8b 14 24             	mov    (%esp),%edx
  801ba5:	83 c4 1c             	add    $0x1c,%esp
  801ba8:	5b                   	pop    %ebx
  801ba9:	5e                   	pop    %esi
  801baa:	5f                   	pop    %edi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    
  801bad:	8d 76 00             	lea    0x0(%esi),%esi
  801bb0:	2b 04 24             	sub    (%esp),%eax
  801bb3:	19 fa                	sbb    %edi,%edx
  801bb5:	89 d1                	mov    %edx,%ecx
  801bb7:	89 c6                	mov    %eax,%esi
  801bb9:	e9 71 ff ff ff       	jmp    801b2f <__umoddi3+0xb3>
  801bbe:	66 90                	xchg   %ax,%ax
  801bc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bc4:	72 ea                	jb     801bb0 <__umoddi3+0x134>
  801bc6:	89 d9                	mov    %ebx,%ecx
  801bc8:	e9 62 ff ff ff       	jmp    801b2f <__umoddi3+0xb3>
