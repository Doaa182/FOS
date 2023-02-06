
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 ab 00 00 00       	call   8000e1 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 00 1c 80 00       	push   $0x801c00
  800057:	e8 15 0a 00 00       	call   800a71 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 67 0e 00 00       	call   800ed9 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 1f 00 00 00       	call   8000a2 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Fibonacci #%d = %d\n",i1, res);
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	ff 75 f4             	pushl  -0xc(%ebp)
  800092:	68 1e 1c 80 00       	push   $0x801c1e
  800097:	e8 82 02 00 00       	call   80031e <atomic_cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
	return;
  80009f:	90                   	nop
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <fibonacci>:


int fibonacci(int n)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	53                   	push   %ebx
  8000a6:	83 ec 04             	sub    $0x4,%esp
	if (n <= 1)
  8000a9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ad:	7f 07                	jg     8000b6 <fibonacci+0x14>
		return 1 ;
  8000af:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b4:	eb 26                	jmp    8000dc <fibonacci+0x3a>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8000b9:	48                   	dec    %eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 df ff ff ff       	call   8000a2 <fibonacci>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 c3                	mov    %eax,%ebx
  8000c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cb:	83 e8 02             	sub    $0x2,%eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 cb ff ff ff       	call   8000a2 <fibonacci>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	01 d8                	add    %ebx,%eax
}
  8000dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000df:	c9                   	leave  
  8000e0:	c3                   	ret    

008000e1 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000e1:	55                   	push   %ebp
  8000e2:	89 e5                	mov    %esp,%ebp
  8000e4:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e7:	e8 61 15 00 00       	call   80164d <sys_getenvindex>
  8000ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f2:	89 d0                	mov    %edx,%eax
  8000f4:	c1 e0 03             	shl    $0x3,%eax
  8000f7:	01 d0                	add    %edx,%eax
  8000f9:	01 c0                	add    %eax,%eax
  8000fb:	01 d0                	add    %edx,%eax
  8000fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800104:	01 d0                	add    %edx,%eax
  800106:	c1 e0 04             	shl    $0x4,%eax
  800109:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010e:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80011e:	84 c0                	test   %al,%al
  800120:	74 0f                	je     800131 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800122:	a1 20 30 80 00       	mov    0x803020,%eax
  800127:	05 5c 05 00 00       	add    $0x55c,%eax
  80012c:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800135:	7e 0a                	jle    800141 <libmain+0x60>
		binaryname = argv[0];
  800137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013a:	8b 00                	mov    (%eax),%eax
  80013c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800141:	83 ec 08             	sub    $0x8,%esp
  800144:	ff 75 0c             	pushl  0xc(%ebp)
  800147:	ff 75 08             	pushl  0x8(%ebp)
  80014a:	e8 e9 fe ff ff       	call   800038 <_main>
  80014f:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800152:	e8 03 13 00 00       	call   80145a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 4c 1c 80 00       	push   $0x801c4c
  80015f:	e8 8d 01 00 00       	call   8002f1 <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800167:	a1 20 30 80 00       	mov    0x803020,%eax
  80016c:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800172:	a1 20 30 80 00       	mov    0x803020,%eax
  800177:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80017d:	83 ec 04             	sub    $0x4,%esp
  800180:	52                   	push   %edx
  800181:	50                   	push   %eax
  800182:	68 74 1c 80 00       	push   $0x801c74
  800187:	e8 65 01 00 00       	call   8002f1 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80018f:	a1 20 30 80 00       	mov    0x803020,%eax
  800194:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80019a:	a1 20 30 80 00       	mov    0x803020,%eax
  80019f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001aa:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001b0:	51                   	push   %ecx
  8001b1:	52                   	push   %edx
  8001b2:	50                   	push   %eax
  8001b3:	68 9c 1c 80 00       	push   $0x801c9c
  8001b8:	e8 34 01 00 00       	call   8002f1 <cprintf>
  8001bd:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c0:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c5:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	50                   	push   %eax
  8001cf:	68 f4 1c 80 00       	push   $0x801cf4
  8001d4:	e8 18 01 00 00       	call   8002f1 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 4c 1c 80 00       	push   $0x801c4c
  8001e4:	e8 08 01 00 00       	call   8002f1 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ec:	e8 83 12 00 00       	call   801474 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001f1:	e8 19 00 00 00       	call   80020f <exit>
}
  8001f6:	90                   	nop
  8001f7:	c9                   	leave  
  8001f8:	c3                   	ret    

008001f9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	6a 00                	push   $0x0
  800204:	e8 10 14 00 00       	call   801619 <sys_destroy_env>
  800209:	83 c4 10             	add    $0x10,%esp
}
  80020c:	90                   	nop
  80020d:	c9                   	leave  
  80020e:	c3                   	ret    

0080020f <exit>:

void
exit(void)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800215:	e8 65 14 00 00       	call   80167f <sys_exit_env>
}
  80021a:	90                   	nop
  80021b:	c9                   	leave  
  80021c:	c3                   	ret    

0080021d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80021d:	55                   	push   %ebp
  80021e:	89 e5                	mov    %esp,%ebp
  800220:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800223:	8b 45 0c             	mov    0xc(%ebp),%eax
  800226:	8b 00                	mov    (%eax),%eax
  800228:	8d 48 01             	lea    0x1(%eax),%ecx
  80022b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022e:	89 0a                	mov    %ecx,(%edx)
  800230:	8b 55 08             	mov    0x8(%ebp),%edx
  800233:	88 d1                	mov    %dl,%cl
  800235:	8b 55 0c             	mov    0xc(%ebp),%edx
  800238:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80023c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023f:	8b 00                	mov    (%eax),%eax
  800241:	3d ff 00 00 00       	cmp    $0xff,%eax
  800246:	75 2c                	jne    800274 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800248:	a0 24 30 80 00       	mov    0x803024,%al
  80024d:	0f b6 c0             	movzbl %al,%eax
  800250:	8b 55 0c             	mov    0xc(%ebp),%edx
  800253:	8b 12                	mov    (%edx),%edx
  800255:	89 d1                	mov    %edx,%ecx
  800257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025a:	83 c2 08             	add    $0x8,%edx
  80025d:	83 ec 04             	sub    $0x4,%esp
  800260:	50                   	push   %eax
  800261:	51                   	push   %ecx
  800262:	52                   	push   %edx
  800263:	e8 44 10 00 00       	call   8012ac <sys_cputs>
  800268:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80026b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800274:	8b 45 0c             	mov    0xc(%ebp),%eax
  800277:	8b 40 04             	mov    0x4(%eax),%eax
  80027a:	8d 50 01             	lea    0x1(%eax),%edx
  80027d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800280:	89 50 04             	mov    %edx,0x4(%eax)
}
  800283:	90                   	nop
  800284:	c9                   	leave  
  800285:	c3                   	ret    

00800286 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80028f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800296:	00 00 00 
	b.cnt = 0;
  800299:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a3:	ff 75 0c             	pushl  0xc(%ebp)
  8002a6:	ff 75 08             	pushl  0x8(%ebp)
  8002a9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002af:	50                   	push   %eax
  8002b0:	68 1d 02 80 00       	push   $0x80021d
  8002b5:	e8 11 02 00 00       	call   8004cb <vprintfmt>
  8002ba:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002bd:	a0 24 30 80 00       	mov    0x803024,%al
  8002c2:	0f b6 c0             	movzbl %al,%eax
  8002c5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002cb:	83 ec 04             	sub    $0x4,%esp
  8002ce:	50                   	push   %eax
  8002cf:	52                   	push   %edx
  8002d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d6:	83 c0 08             	add    $0x8,%eax
  8002d9:	50                   	push   %eax
  8002da:	e8 cd 0f 00 00       	call   8012ac <sys_cputs>
  8002df:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e2:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002e9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f7:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002fe:	8d 45 0c             	lea    0xc(%ebp),%eax
  800301:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	50                   	push   %eax
  80030e:	e8 73 ff ff ff       	call   800286 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
  800316:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800319:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800324:	e8 31 11 00 00       	call   80145a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800329:	8d 45 0c             	lea    0xc(%ebp),%eax
  80032c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	ff 75 f4             	pushl  -0xc(%ebp)
  800338:	50                   	push   %eax
  800339:	e8 48 ff ff ff       	call   800286 <vcprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
  800341:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800344:	e8 2b 11 00 00       	call   801474 <sys_enable_interrupt>
	return cnt;
  800349:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	53                   	push   %ebx
  800352:	83 ec 14             	sub    $0x14,%esp
  800355:	8b 45 10             	mov    0x10(%ebp),%eax
  800358:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80035b:	8b 45 14             	mov    0x14(%ebp),%eax
  80035e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800361:	8b 45 18             	mov    0x18(%ebp),%eax
  800364:	ba 00 00 00 00       	mov    $0x0,%edx
  800369:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80036c:	77 55                	ja     8003c3 <printnum+0x75>
  80036e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800371:	72 05                	jb     800378 <printnum+0x2a>
  800373:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800376:	77 4b                	ja     8003c3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800378:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80037b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80037e:	8b 45 18             	mov    0x18(%ebp),%eax
  800381:	ba 00 00 00 00       	mov    $0x0,%edx
  800386:	52                   	push   %edx
  800387:	50                   	push   %eax
  800388:	ff 75 f4             	pushl  -0xc(%ebp)
  80038b:	ff 75 f0             	pushl  -0x10(%ebp)
  80038e:	e8 ed 15 00 00       	call   801980 <__udivdi3>
  800393:	83 c4 10             	add    $0x10,%esp
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	ff 75 20             	pushl  0x20(%ebp)
  80039c:	53                   	push   %ebx
  80039d:	ff 75 18             	pushl  0x18(%ebp)
  8003a0:	52                   	push   %edx
  8003a1:	50                   	push   %eax
  8003a2:	ff 75 0c             	pushl  0xc(%ebp)
  8003a5:	ff 75 08             	pushl  0x8(%ebp)
  8003a8:	e8 a1 ff ff ff       	call   80034e <printnum>
  8003ad:	83 c4 20             	add    $0x20,%esp
  8003b0:	eb 1a                	jmp    8003cc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b2:	83 ec 08             	sub    $0x8,%esp
  8003b5:	ff 75 0c             	pushl  0xc(%ebp)
  8003b8:	ff 75 20             	pushl  0x20(%ebp)
  8003bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003be:	ff d0                	call   *%eax
  8003c0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c3:	ff 4d 1c             	decl   0x1c(%ebp)
  8003c6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003ca:	7f e6                	jg     8003b2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003cf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003da:	53                   	push   %ebx
  8003db:	51                   	push   %ecx
  8003dc:	52                   	push   %edx
  8003dd:	50                   	push   %eax
  8003de:	e8 ad 16 00 00       	call   801a90 <__umoddi3>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	05 34 1f 80 00       	add    $0x801f34,%eax
  8003eb:	8a 00                	mov    (%eax),%al
  8003ed:	0f be c0             	movsbl %al,%eax
  8003f0:	83 ec 08             	sub    $0x8,%esp
  8003f3:	ff 75 0c             	pushl  0xc(%ebp)
  8003f6:	50                   	push   %eax
  8003f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fa:	ff d0                	call   *%eax
  8003fc:	83 c4 10             	add    $0x10,%esp
}
  8003ff:	90                   	nop
  800400:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800403:	c9                   	leave  
  800404:	c3                   	ret    

00800405 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800405:	55                   	push   %ebp
  800406:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800408:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80040c:	7e 1c                	jle    80042a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	8d 50 08             	lea    0x8(%eax),%edx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	89 10                	mov    %edx,(%eax)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	83 e8 08             	sub    $0x8,%eax
  800423:	8b 50 04             	mov    0x4(%eax),%edx
  800426:	8b 00                	mov    (%eax),%eax
  800428:	eb 40                	jmp    80046a <getuint+0x65>
	else if (lflag)
  80042a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80042e:	74 1e                	je     80044e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	8d 50 04             	lea    0x4(%eax),%edx
  800438:	8b 45 08             	mov    0x8(%ebp),%eax
  80043b:	89 10                	mov    %edx,(%eax)
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	83 e8 04             	sub    $0x4,%eax
  800445:	8b 00                	mov    (%eax),%eax
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	eb 1c                	jmp    80046a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	8d 50 04             	lea    0x4(%eax),%edx
  800456:	8b 45 08             	mov    0x8(%ebp),%eax
  800459:	89 10                	mov    %edx,(%eax)
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	83 e8 04             	sub    $0x4,%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80046a:	5d                   	pop    %ebp
  80046b:	c3                   	ret    

0080046c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80046f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800473:	7e 1c                	jle    800491 <getint+0x25>
		return va_arg(*ap, long long);
  800475:	8b 45 08             	mov    0x8(%ebp),%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	8d 50 08             	lea    0x8(%eax),%edx
  80047d:	8b 45 08             	mov    0x8(%ebp),%eax
  800480:	89 10                	mov    %edx,(%eax)
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	83 e8 08             	sub    $0x8,%eax
  80048a:	8b 50 04             	mov    0x4(%eax),%edx
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	eb 38                	jmp    8004c9 <getint+0x5d>
	else if (lflag)
  800491:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800495:	74 1a                	je     8004b1 <getint+0x45>
		return va_arg(*ap, long);
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	8d 50 04             	lea    0x4(%eax),%edx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	89 10                	mov    %edx,(%eax)
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	83 e8 04             	sub    $0x4,%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	99                   	cltd   
  8004af:	eb 18                	jmp    8004c9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	8d 50 04             	lea    0x4(%eax),%edx
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	89 10                	mov    %edx,(%eax)
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	83 e8 04             	sub    $0x4,%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	99                   	cltd   
}
  8004c9:	5d                   	pop    %ebp
  8004ca:	c3                   	ret    

008004cb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	56                   	push   %esi
  8004cf:	53                   	push   %ebx
  8004d0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d3:	eb 17                	jmp    8004ec <vprintfmt+0x21>
			if (ch == '\0')
  8004d5:	85 db                	test   %ebx,%ebx
  8004d7:	0f 84 af 03 00 00    	je     80088c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004dd:	83 ec 08             	sub    $0x8,%esp
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	53                   	push   %ebx
  8004e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e7:	ff d0                	call   *%eax
  8004e9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	8d 50 01             	lea    0x1(%eax),%edx
  8004f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f5:	8a 00                	mov    (%eax),%al
  8004f7:	0f b6 d8             	movzbl %al,%ebx
  8004fa:	83 fb 25             	cmp    $0x25,%ebx
  8004fd:	75 d6                	jne    8004d5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004ff:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800503:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80050a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800511:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800518:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	8d 50 01             	lea    0x1(%eax),%edx
  800525:	89 55 10             	mov    %edx,0x10(%ebp)
  800528:	8a 00                	mov    (%eax),%al
  80052a:	0f b6 d8             	movzbl %al,%ebx
  80052d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800530:	83 f8 55             	cmp    $0x55,%eax
  800533:	0f 87 2b 03 00 00    	ja     800864 <vprintfmt+0x399>
  800539:	8b 04 85 58 1f 80 00 	mov    0x801f58(,%eax,4),%eax
  800540:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800542:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800546:	eb d7                	jmp    80051f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800548:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80054c:	eb d1                	jmp    80051f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800555:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800558:	89 d0                	mov    %edx,%eax
  80055a:	c1 e0 02             	shl    $0x2,%eax
  80055d:	01 d0                	add    %edx,%eax
  80055f:	01 c0                	add    %eax,%eax
  800561:	01 d8                	add    %ebx,%eax
  800563:	83 e8 30             	sub    $0x30,%eax
  800566:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800569:	8b 45 10             	mov    0x10(%ebp),%eax
  80056c:	8a 00                	mov    (%eax),%al
  80056e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800571:	83 fb 2f             	cmp    $0x2f,%ebx
  800574:	7e 3e                	jle    8005b4 <vprintfmt+0xe9>
  800576:	83 fb 39             	cmp    $0x39,%ebx
  800579:	7f 39                	jg     8005b4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80057b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80057e:	eb d5                	jmp    800555 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	83 c0 04             	add    $0x4,%eax
  800586:	89 45 14             	mov    %eax,0x14(%ebp)
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	83 e8 04             	sub    $0x4,%eax
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800594:	eb 1f                	jmp    8005b5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800596:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80059a:	79 83                	jns    80051f <vprintfmt+0x54>
				width = 0;
  80059c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005a3:	e9 77 ff ff ff       	jmp    80051f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005a8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005af:	e9 6b ff ff ff       	jmp    80051f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005b4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b9:	0f 89 60 ff ff ff    	jns    80051f <vprintfmt+0x54>
				width = precision, precision = -1;
  8005bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005cc:	e9 4e ff ff ff       	jmp    80051f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005d4:	e9 46 ff ff ff       	jmp    80051f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	83 c0 04             	add    $0x4,%eax
  8005df:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	83 e8 04             	sub    $0x4,%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	83 ec 08             	sub    $0x8,%esp
  8005ed:	ff 75 0c             	pushl  0xc(%ebp)
  8005f0:	50                   	push   %eax
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	ff d0                	call   *%eax
  8005f6:	83 c4 10             	add    $0x10,%esp
			break;
  8005f9:	e9 89 02 00 00       	jmp    800887 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	83 c0 04             	add    $0x4,%eax
  800604:	89 45 14             	mov    %eax,0x14(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	83 e8 04             	sub    $0x4,%eax
  80060d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80060f:	85 db                	test   %ebx,%ebx
  800611:	79 02                	jns    800615 <vprintfmt+0x14a>
				err = -err;
  800613:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800615:	83 fb 64             	cmp    $0x64,%ebx
  800618:	7f 0b                	jg     800625 <vprintfmt+0x15a>
  80061a:	8b 34 9d a0 1d 80 00 	mov    0x801da0(,%ebx,4),%esi
  800621:	85 f6                	test   %esi,%esi
  800623:	75 19                	jne    80063e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800625:	53                   	push   %ebx
  800626:	68 45 1f 80 00       	push   $0x801f45
  80062b:	ff 75 0c             	pushl  0xc(%ebp)
  80062e:	ff 75 08             	pushl  0x8(%ebp)
  800631:	e8 5e 02 00 00       	call   800894 <printfmt>
  800636:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800639:	e9 49 02 00 00       	jmp    800887 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80063e:	56                   	push   %esi
  80063f:	68 4e 1f 80 00       	push   $0x801f4e
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	ff 75 08             	pushl  0x8(%ebp)
  80064a:	e8 45 02 00 00       	call   800894 <printfmt>
  80064f:	83 c4 10             	add    $0x10,%esp
			break;
  800652:	e9 30 02 00 00       	jmp    800887 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	83 c0 04             	add    $0x4,%eax
  80065d:	89 45 14             	mov    %eax,0x14(%ebp)
  800660:	8b 45 14             	mov    0x14(%ebp),%eax
  800663:	83 e8 04             	sub    $0x4,%eax
  800666:	8b 30                	mov    (%eax),%esi
  800668:	85 f6                	test   %esi,%esi
  80066a:	75 05                	jne    800671 <vprintfmt+0x1a6>
				p = "(null)";
  80066c:	be 51 1f 80 00       	mov    $0x801f51,%esi
			if (width > 0 && padc != '-')
  800671:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800675:	7e 6d                	jle    8006e4 <vprintfmt+0x219>
  800677:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80067b:	74 67                	je     8006e4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80067d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800680:	83 ec 08             	sub    $0x8,%esp
  800683:	50                   	push   %eax
  800684:	56                   	push   %esi
  800685:	e8 12 05 00 00       	call   800b9c <strnlen>
  80068a:	83 c4 10             	add    $0x10,%esp
  80068d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800690:	eb 16                	jmp    8006a8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800692:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800696:	83 ec 08             	sub    $0x8,%esp
  800699:	ff 75 0c             	pushl  0xc(%ebp)
  80069c:	50                   	push   %eax
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	ff d0                	call   *%eax
  8006a2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a5:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ac:	7f e4                	jg     800692 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ae:	eb 34                	jmp    8006e4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b4:	74 1c                	je     8006d2 <vprintfmt+0x207>
  8006b6:	83 fb 1f             	cmp    $0x1f,%ebx
  8006b9:	7e 05                	jle    8006c0 <vprintfmt+0x1f5>
  8006bb:	83 fb 7e             	cmp    $0x7e,%ebx
  8006be:	7e 12                	jle    8006d2 <vprintfmt+0x207>
					putch('?', putdat);
  8006c0:	83 ec 08             	sub    $0x8,%esp
  8006c3:	ff 75 0c             	pushl  0xc(%ebp)
  8006c6:	6a 3f                	push   $0x3f
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	ff d0                	call   *%eax
  8006cd:	83 c4 10             	add    $0x10,%esp
  8006d0:	eb 0f                	jmp    8006e1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	ff 75 0c             	pushl  0xc(%ebp)
  8006d8:	53                   	push   %ebx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	ff d0                	call   *%eax
  8006de:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e1:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e4:	89 f0                	mov    %esi,%eax
  8006e6:	8d 70 01             	lea    0x1(%eax),%esi
  8006e9:	8a 00                	mov    (%eax),%al
  8006eb:	0f be d8             	movsbl %al,%ebx
  8006ee:	85 db                	test   %ebx,%ebx
  8006f0:	74 24                	je     800716 <vprintfmt+0x24b>
  8006f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f6:	78 b8                	js     8006b0 <vprintfmt+0x1e5>
  8006f8:	ff 4d e0             	decl   -0x20(%ebp)
  8006fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ff:	79 af                	jns    8006b0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800701:	eb 13                	jmp    800716 <vprintfmt+0x24b>
				putch(' ', putdat);
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	ff 75 0c             	pushl  0xc(%ebp)
  800709:	6a 20                	push   $0x20
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	ff d0                	call   *%eax
  800710:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800713:	ff 4d e4             	decl   -0x1c(%ebp)
  800716:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071a:	7f e7                	jg     800703 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80071c:	e9 66 01 00 00       	jmp    800887 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 e8             	pushl  -0x18(%ebp)
  800727:	8d 45 14             	lea    0x14(%ebp),%eax
  80072a:	50                   	push   %eax
  80072b:	e8 3c fd ff ff       	call   80046c <getint>
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800736:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073f:	85 d2                	test   %edx,%edx
  800741:	79 23                	jns    800766 <vprintfmt+0x29b>
				putch('-', putdat);
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	6a 2d                	push   $0x2d
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	ff d0                	call   *%eax
  800750:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800759:	f7 d8                	neg    %eax
  80075b:	83 d2 00             	adc    $0x0,%edx
  80075e:	f7 da                	neg    %edx
  800760:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800763:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800766:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80076d:	e9 bc 00 00 00       	jmp    80082e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800772:	83 ec 08             	sub    $0x8,%esp
  800775:	ff 75 e8             	pushl  -0x18(%ebp)
  800778:	8d 45 14             	lea    0x14(%ebp),%eax
  80077b:	50                   	push   %eax
  80077c:	e8 84 fc ff ff       	call   800405 <getuint>
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800787:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80078a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800791:	e9 98 00 00 00       	jmp    80082e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	6a 58                	push   $0x58
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	ff d0                	call   *%eax
  8007a3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ac:	6a 58                	push   $0x58
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	6a 58                	push   $0x58
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	ff d0                	call   *%eax
  8007c3:	83 c4 10             	add    $0x10,%esp
			break;
  8007c6:	e9 bc 00 00 00       	jmp    800887 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	6a 30                	push   $0x30
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	ff d0                	call   *%eax
  8007d8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	6a 78                	push   $0x78
  8007e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e6:	ff d0                	call   *%eax
  8007e8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	83 c0 04             	add    $0x4,%eax
  8007f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	83 e8 04             	sub    $0x4,%eax
  8007fa:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800806:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	ff 75 e8             	pushl  -0x18(%ebp)
  800815:	8d 45 14             	lea    0x14(%ebp),%eax
  800818:	50                   	push   %eax
  800819:	e8 e7 fb ff ff       	call   800405 <getuint>
  80081e:	83 c4 10             	add    $0x10,%esp
  800821:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800824:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800827:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80082e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800832:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800835:	83 ec 04             	sub    $0x4,%esp
  800838:	52                   	push   %edx
  800839:	ff 75 e4             	pushl  -0x1c(%ebp)
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	ff 75 08             	pushl  0x8(%ebp)
  800849:	e8 00 fb ff ff       	call   80034e <printnum>
  80084e:	83 c4 20             	add    $0x20,%esp
			break;
  800851:	eb 34                	jmp    800887 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	53                   	push   %ebx
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	ff d0                	call   *%eax
  80085f:	83 c4 10             	add    $0x10,%esp
			break;
  800862:	eb 23                	jmp    800887 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800864:	83 ec 08             	sub    $0x8,%esp
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	6a 25                	push   $0x25
  80086c:	8b 45 08             	mov    0x8(%ebp),%eax
  80086f:	ff d0                	call   *%eax
  800871:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800874:	ff 4d 10             	decl   0x10(%ebp)
  800877:	eb 03                	jmp    80087c <vprintfmt+0x3b1>
  800879:	ff 4d 10             	decl   0x10(%ebp)
  80087c:	8b 45 10             	mov    0x10(%ebp),%eax
  80087f:	48                   	dec    %eax
  800880:	8a 00                	mov    (%eax),%al
  800882:	3c 25                	cmp    $0x25,%al
  800884:	75 f3                	jne    800879 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800886:	90                   	nop
		}
	}
  800887:	e9 47 fc ff ff       	jmp    8004d3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80088c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80088d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800890:	5b                   	pop    %ebx
  800891:	5e                   	pop    %esi
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80089a:	8d 45 10             	lea    0x10(%ebp),%eax
  80089d:	83 c0 04             	add    $0x4,%eax
  8008a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a9:	50                   	push   %eax
  8008aa:	ff 75 0c             	pushl  0xc(%ebp)
  8008ad:	ff 75 08             	pushl  0x8(%ebp)
  8008b0:	e8 16 fc ff ff       	call   8004cb <vprintfmt>
  8008b5:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008b8:	90                   	nop
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    

008008bb <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c1:	8b 40 08             	mov    0x8(%eax),%eax
  8008c4:	8d 50 01             	lea    0x1(%eax),%edx
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d0:	8b 10                	mov    (%eax),%edx
  8008d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d5:	8b 40 04             	mov    0x4(%eax),%eax
  8008d8:	39 c2                	cmp    %eax,%edx
  8008da:	73 12                	jae    8008ee <sprintputch+0x33>
		*b->buf++ = ch;
  8008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008df:	8b 00                	mov    (%eax),%eax
  8008e1:	8d 48 01             	lea    0x1(%eax),%ecx
  8008e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e7:	89 0a                	mov    %ecx,(%edx)
  8008e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ec:	88 10                	mov    %dl,(%eax)
}
  8008ee:	90                   	nop
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	8d 50 ff             	lea    -0x1(%eax),%edx
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	01 d0                	add    %edx,%eax
  800908:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800912:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800916:	74 06                	je     80091e <vsnprintf+0x2d>
  800918:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80091c:	7f 07                	jg     800925 <vsnprintf+0x34>
		return -E_INVAL;
  80091e:	b8 03 00 00 00       	mov    $0x3,%eax
  800923:	eb 20                	jmp    800945 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800925:	ff 75 14             	pushl  0x14(%ebp)
  800928:	ff 75 10             	pushl  0x10(%ebp)
  80092b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80092e:	50                   	push   %eax
  80092f:	68 bb 08 80 00       	push   $0x8008bb
  800934:	e8 92 fb ff ff       	call   8004cb <vprintfmt>
  800939:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80093c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800942:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800945:	c9                   	leave  
  800946:	c3                   	ret    

00800947 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80094d:	8d 45 10             	lea    0x10(%ebp),%eax
  800950:	83 c0 04             	add    $0x4,%eax
  800953:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800956:	8b 45 10             	mov    0x10(%ebp),%eax
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	ff 75 0c             	pushl  0xc(%ebp)
  800960:	ff 75 08             	pushl  0x8(%ebp)
  800963:	e8 89 ff ff ff       	call   8008f1 <vsnprintf>
  800968:	83 c4 10             	add    $0x10,%esp
  80096b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800979:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80097d:	74 13                	je     800992 <readline+0x1f>
		cprintf("%s", prompt);
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 08             	pushl  0x8(%ebp)
  800985:	68 b0 20 80 00       	push   $0x8020b0
  80098a:	e8 62 f9 ff ff       	call   8002f1 <cprintf>
  80098f:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800992:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800999:	83 ec 0c             	sub    $0xc,%esp
  80099c:	6a 00                	push   $0x0
  80099e:	e8 d2 0f 00 00       	call   801975 <iscons>
  8009a3:	83 c4 10             	add    $0x10,%esp
  8009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009a9:	e8 79 0f 00 00       	call   801927 <getchar>
  8009ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009b5:	79 22                	jns    8009d9 <readline+0x66>
			if (c != -E_EOF)
  8009b7:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009bb:	0f 84 ad 00 00 00    	je     800a6e <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8009c7:	68 b3 20 80 00       	push   $0x8020b3
  8009cc:	e8 20 f9 ff ff       	call   8002f1 <cprintf>
  8009d1:	83 c4 10             	add    $0x10,%esp
			return;
  8009d4:	e9 95 00 00 00       	jmp    800a6e <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009d9:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009dd:	7e 34                	jle    800a13 <readline+0xa0>
  8009df:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009e6:	7f 2b                	jg     800a13 <readline+0xa0>
			if (echoing)
  8009e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009ec:	74 0e                	je     8009fc <readline+0x89>
				cputchar(c);
  8009ee:	83 ec 0c             	sub    $0xc,%esp
  8009f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8009f4:	e8 e6 0e 00 00       	call   8018df <cputchar>
  8009f9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ff:	8d 50 01             	lea    0x1(%eax),%edx
  800a02:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a05:	89 c2                	mov    %eax,%edx
  800a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0a:	01 d0                	add    %edx,%eax
  800a0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a0f:	88 10                	mov    %dl,(%eax)
  800a11:	eb 56                	jmp    800a69 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a13:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a17:	75 1f                	jne    800a38 <readline+0xc5>
  800a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a1d:	7e 19                	jle    800a38 <readline+0xc5>
			if (echoing)
  800a1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a23:	74 0e                	je     800a33 <readline+0xc0>
				cputchar(c);
  800a25:	83 ec 0c             	sub    $0xc,%esp
  800a28:	ff 75 ec             	pushl  -0x14(%ebp)
  800a2b:	e8 af 0e 00 00       	call   8018df <cputchar>
  800a30:	83 c4 10             	add    $0x10,%esp

			i--;
  800a33:	ff 4d f4             	decl   -0xc(%ebp)
  800a36:	eb 31                	jmp    800a69 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a38:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a3c:	74 0a                	je     800a48 <readline+0xd5>
  800a3e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a42:	0f 85 61 ff ff ff    	jne    8009a9 <readline+0x36>
			if (echoing)
  800a48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a4c:	74 0e                	je     800a5c <readline+0xe9>
				cputchar(c);
  800a4e:	83 ec 0c             	sub    $0xc,%esp
  800a51:	ff 75 ec             	pushl  -0x14(%ebp)
  800a54:	e8 86 0e 00 00       	call   8018df <cputchar>
  800a59:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a62:	01 d0                	add    %edx,%eax
  800a64:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a67:	eb 06                	jmp    800a6f <readline+0xfc>
		}
	}
  800a69:	e9 3b ff ff ff       	jmp    8009a9 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a6e:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a6f:	c9                   	leave  
  800a70:	c3                   	ret    

00800a71 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a77:	e8 de 09 00 00       	call   80145a <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a80:	74 13                	je     800a95 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 08             	pushl  0x8(%ebp)
  800a88:	68 b0 20 80 00       	push   $0x8020b0
  800a8d:	e8 5f f8 ff ff       	call   8002f1 <cprintf>
  800a92:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a9c:	83 ec 0c             	sub    $0xc,%esp
  800a9f:	6a 00                	push   $0x0
  800aa1:	e8 cf 0e 00 00       	call   801975 <iscons>
  800aa6:	83 c4 10             	add    $0x10,%esp
  800aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aac:	e8 76 0e 00 00       	call   801927 <getchar>
  800ab1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800ab4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ab8:	79 23                	jns    800add <atomic_readline+0x6c>
			if (c != -E_EOF)
  800aba:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800abe:	74 13                	je     800ad3 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800ac0:	83 ec 08             	sub    $0x8,%esp
  800ac3:	ff 75 ec             	pushl  -0x14(%ebp)
  800ac6:	68 b3 20 80 00       	push   $0x8020b3
  800acb:	e8 21 f8 ff ff       	call   8002f1 <cprintf>
  800ad0:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800ad3:	e8 9c 09 00 00       	call   801474 <sys_enable_interrupt>
			return;
  800ad8:	e9 9a 00 00 00       	jmp    800b77 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800add:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ae1:	7e 34                	jle    800b17 <atomic_readline+0xa6>
  800ae3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800aea:	7f 2b                	jg     800b17 <atomic_readline+0xa6>
			if (echoing)
  800aec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800af0:	74 0e                	je     800b00 <atomic_readline+0x8f>
				cputchar(c);
  800af2:	83 ec 0c             	sub    $0xc,%esp
  800af5:	ff 75 ec             	pushl  -0x14(%ebp)
  800af8:	e8 e2 0d 00 00       	call   8018df <cputchar>
  800afd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b03:	8d 50 01             	lea    0x1(%eax),%edx
  800b06:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b09:	89 c2                	mov    %eax,%edx
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	01 d0                	add    %edx,%eax
  800b10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b13:	88 10                	mov    %dl,(%eax)
  800b15:	eb 5b                	jmp    800b72 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b17:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b1b:	75 1f                	jne    800b3c <atomic_readline+0xcb>
  800b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b21:	7e 19                	jle    800b3c <atomic_readline+0xcb>
			if (echoing)
  800b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b27:	74 0e                	je     800b37 <atomic_readline+0xc6>
				cputchar(c);
  800b29:	83 ec 0c             	sub    $0xc,%esp
  800b2c:	ff 75 ec             	pushl  -0x14(%ebp)
  800b2f:	e8 ab 0d 00 00       	call   8018df <cputchar>
  800b34:	83 c4 10             	add    $0x10,%esp
			i--;
  800b37:	ff 4d f4             	decl   -0xc(%ebp)
  800b3a:	eb 36                	jmp    800b72 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b3c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b40:	74 0a                	je     800b4c <atomic_readline+0xdb>
  800b42:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b46:	0f 85 60 ff ff ff    	jne    800aac <atomic_readline+0x3b>
			if (echoing)
  800b4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b50:	74 0e                	je     800b60 <atomic_readline+0xef>
				cputchar(c);
  800b52:	83 ec 0c             	sub    $0xc,%esp
  800b55:	ff 75 ec             	pushl  -0x14(%ebp)
  800b58:	e8 82 0d 00 00       	call   8018df <cputchar>
  800b5d:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	01 d0                	add    %edx,%eax
  800b68:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b6b:	e8 04 09 00 00       	call   801474 <sys_enable_interrupt>
			return;
  800b70:	eb 05                	jmp    800b77 <atomic_readline+0x106>
		}
	}
  800b72:	e9 35 ff ff ff       	jmp    800aac <atomic_readline+0x3b>
}
  800b77:	c9                   	leave  
  800b78:	c3                   	ret    

00800b79 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b79:	55                   	push   %ebp
  800b7a:	89 e5                	mov    %esp,%ebp
  800b7c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b86:	eb 06                	jmp    800b8e <strlen+0x15>
		n++;
  800b88:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b8b:	ff 45 08             	incl   0x8(%ebp)
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8a 00                	mov    (%eax),%al
  800b93:	84 c0                	test   %al,%al
  800b95:	75 f1                	jne    800b88 <strlen+0xf>
		n++;
	return n;
  800b97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba9:	eb 09                	jmp    800bb4 <strnlen+0x18>
		n++;
  800bab:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bae:	ff 45 08             	incl   0x8(%ebp)
  800bb1:	ff 4d 0c             	decl   0xc(%ebp)
  800bb4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb8:	74 09                	je     800bc3 <strnlen+0x27>
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	8a 00                	mov    (%eax),%al
  800bbf:	84 c0                	test   %al,%al
  800bc1:	75 e8                	jne    800bab <strnlen+0xf>
		n++;
	return n;
  800bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc6:	c9                   	leave  
  800bc7:	c3                   	ret    

00800bc8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bd4:	90                   	nop
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 08             	mov    %edx,0x8(%ebp)
  800bde:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800be4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be7:	8a 12                	mov    (%edx),%dl
  800be9:	88 10                	mov    %dl,(%eax)
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 e4                	jne    800bd5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c09:	eb 1f                	jmp    800c2a <strncpy+0x34>
		*dst++ = *src;
  800c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0e:	8d 50 01             	lea    0x1(%eax),%edx
  800c11:	89 55 08             	mov    %edx,0x8(%ebp)
  800c14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c17:	8a 12                	mov    (%edx),%dl
  800c19:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1e:	8a 00                	mov    (%eax),%al
  800c20:	84 c0                	test   %al,%al
  800c22:	74 03                	je     800c27 <strncpy+0x31>
			src++;
  800c24:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c27:	ff 45 fc             	incl   -0x4(%ebp)
  800c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c30:	72 d9                	jb     800c0b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c32:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c47:	74 30                	je     800c79 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c49:	eb 16                	jmp    800c61 <strlcpy+0x2a>
			*dst++ = *src++;
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	8d 50 01             	lea    0x1(%eax),%edx
  800c51:	89 55 08             	mov    %edx,0x8(%ebp)
  800c54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c57:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5d:	8a 12                	mov    (%edx),%dl
  800c5f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c61:	ff 4d 10             	decl   0x10(%ebp)
  800c64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c68:	74 09                	je     800c73 <strlcpy+0x3c>
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	8a 00                	mov    (%eax),%al
  800c6f:	84 c0                	test   %al,%al
  800c71:	75 d8                	jne    800c4b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c79:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7f:	29 c2                	sub    %eax,%edx
  800c81:	89 d0                	mov    %edx,%eax
}
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c88:	eb 06                	jmp    800c90 <strcmp+0xb>
		p++, q++;
  800c8a:	ff 45 08             	incl   0x8(%ebp)
  800c8d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	84 c0                	test   %al,%al
  800c97:	74 0e                	je     800ca7 <strcmp+0x22>
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8a 10                	mov    (%eax),%dl
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	38 c2                	cmp    %al,%dl
  800ca5:	74 e3                	je     800c8a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	0f b6 d0             	movzbl %al,%edx
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	8a 00                	mov    (%eax),%al
  800cb4:	0f b6 c0             	movzbl %al,%eax
  800cb7:	29 c2                	sub    %eax,%edx
  800cb9:	89 d0                	mov    %edx,%eax
}
  800cbb:	5d                   	pop    %ebp
  800cbc:	c3                   	ret    

00800cbd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cc0:	eb 09                	jmp    800ccb <strncmp+0xe>
		n--, p++, q++;
  800cc2:	ff 4d 10             	decl   0x10(%ebp)
  800cc5:	ff 45 08             	incl   0x8(%ebp)
  800cc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ccb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccf:	74 17                	je     800ce8 <strncmp+0x2b>
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8a 00                	mov    (%eax),%al
  800cd6:	84 c0                	test   %al,%al
  800cd8:	74 0e                	je     800ce8 <strncmp+0x2b>
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	8a 10                	mov    (%eax),%dl
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	38 c2                	cmp    %al,%dl
  800ce6:	74 da                	je     800cc2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ce8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cec:	75 07                	jne    800cf5 <strncmp+0x38>
		return 0;
  800cee:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf3:	eb 14                	jmp    800d09 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
}
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d17:	eb 12                	jmp    800d2b <strchr+0x20>
		if (*s == c)
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d21:	75 05                	jne    800d28 <strchr+0x1d>
			return (char *) s;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	eb 11                	jmp    800d39 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d28:	ff 45 08             	incl   0x8(%ebp)
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	84 c0                	test   %al,%al
  800d32:	75 e5                	jne    800d19 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d39:	c9                   	leave  
  800d3a:	c3                   	ret    

00800d3b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 04             	sub    $0x4,%esp
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d47:	eb 0d                	jmp    800d56 <strfind+0x1b>
		if (*s == c)
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d51:	74 0e                	je     800d61 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	75 ea                	jne    800d49 <strfind+0xe>
  800d5f:	eb 01                	jmp    800d62 <strfind+0x27>
		if (*s == c)
			break;
  800d61:	90                   	nop
	return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d65:	c9                   	leave  
  800d66:	c3                   	ret    

00800d67 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d73:	8b 45 10             	mov    0x10(%ebp),%eax
  800d76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d79:	eb 0e                	jmp    800d89 <memset+0x22>
		*p++ = c;
  800d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7e:	8d 50 01             	lea    0x1(%eax),%edx
  800d81:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d87:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d89:	ff 4d f8             	decl   -0x8(%ebp)
  800d8c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d90:	79 e9                	jns    800d7b <memset+0x14>
		*p++ = c;

	return v;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800da9:	eb 16                	jmp    800dc1 <memcpy+0x2a>
		*d++ = *s++;
  800dab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dae:	8d 50 01             	lea    0x1(%eax),%edx
  800db1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800db4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dbd:	8a 12                	mov    (%edx),%dl
  800dbf:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800dca:	85 c0                	test   %eax,%eax
  800dcc:	75 dd                	jne    800dab <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800deb:	73 50                	jae    800e3d <memmove+0x6a>
  800ded:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	01 d0                	add    %edx,%eax
  800df5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df8:	76 43                	jbe    800e3d <memmove+0x6a>
		s += n;
  800dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e06:	eb 10                	jmp    800e18 <memmove+0x45>
			*--d = *--s;
  800e08:	ff 4d f8             	decl   -0x8(%ebp)
  800e0b:	ff 4d fc             	decl   -0x4(%ebp)
  800e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e11:	8a 10                	mov    (%eax),%dl
  800e13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e16:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e21:	85 c0                	test   %eax,%eax
  800e23:	75 e3                	jne    800e08 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e25:	eb 23                	jmp    800e4a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2a:	8d 50 01             	lea    0x1(%eax),%edx
  800e2d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e30:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e33:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e36:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e39:	8a 12                	mov    (%edx),%dl
  800e3b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e43:	89 55 10             	mov    %edx,0x10(%ebp)
  800e46:	85 c0                	test   %eax,%eax
  800e48:	75 dd                	jne    800e27 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e61:	eb 2a                	jmp    800e8d <memcmp+0x3e>
		if (*s1 != *s2)
  800e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e66:	8a 10                	mov    (%eax),%dl
  800e68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	38 c2                	cmp    %al,%dl
  800e6f:	74 16                	je     800e87 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	0f b6 d0             	movzbl %al,%edx
  800e79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7c:	8a 00                	mov    (%eax),%al
  800e7e:	0f b6 c0             	movzbl %al,%eax
  800e81:	29 c2                	sub    %eax,%edx
  800e83:	89 d0                	mov    %edx,%eax
  800e85:	eb 18                	jmp    800e9f <memcmp+0x50>
		s1++, s2++;
  800e87:	ff 45 fc             	incl   -0x4(%ebp)
  800e8a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e90:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e93:	89 55 10             	mov    %edx,0x10(%ebp)
  800e96:	85 c0                	test   %eax,%eax
  800e98:	75 c9                	jne    800e63 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eb2:	eb 15                	jmp    800ec9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	0f b6 d0             	movzbl %al,%edx
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	0f b6 c0             	movzbl %al,%eax
  800ec2:	39 c2                	cmp    %eax,%edx
  800ec4:	74 0d                	je     800ed3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ec6:	ff 45 08             	incl   0x8(%ebp)
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ecf:	72 e3                	jb     800eb4 <memfind+0x13>
  800ed1:	eb 01                	jmp    800ed4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ed3:	90                   	nop
	return (void *) s;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed7:	c9                   	leave  
  800ed8:	c3                   	ret    

00800ed9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800edf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ee6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eed:	eb 03                	jmp    800ef2 <strtol+0x19>
		s++;
  800eef:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8a 00                	mov    (%eax),%al
  800ef7:	3c 20                	cmp    $0x20,%al
  800ef9:	74 f4                	je     800eef <strtol+0x16>
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	8a 00                	mov    (%eax),%al
  800f00:	3c 09                	cmp    $0x9,%al
  800f02:	74 eb                	je     800eef <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	3c 2b                	cmp    $0x2b,%al
  800f0b:	75 05                	jne    800f12 <strtol+0x39>
		s++;
  800f0d:	ff 45 08             	incl   0x8(%ebp)
  800f10:	eb 13                	jmp    800f25 <strtol+0x4c>
	else if (*s == '-')
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3c 2d                	cmp    $0x2d,%al
  800f19:	75 0a                	jne    800f25 <strtol+0x4c>
		s++, neg = 1;
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f29:	74 06                	je     800f31 <strtol+0x58>
  800f2b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f2f:	75 20                	jne    800f51 <strtol+0x78>
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 30                	cmp    $0x30,%al
  800f38:	75 17                	jne    800f51 <strtol+0x78>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	40                   	inc    %eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	3c 78                	cmp    $0x78,%al
  800f42:	75 0d                	jne    800f51 <strtol+0x78>
		s += 2, base = 16;
  800f44:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f48:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f4f:	eb 28                	jmp    800f79 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f55:	75 15                	jne    800f6c <strtol+0x93>
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	3c 30                	cmp    $0x30,%al
  800f5e:	75 0c                	jne    800f6c <strtol+0x93>
		s++, base = 8;
  800f60:	ff 45 08             	incl   0x8(%ebp)
  800f63:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f6a:	eb 0d                	jmp    800f79 <strtol+0xa0>
	else if (base == 0)
  800f6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f70:	75 07                	jne    800f79 <strtol+0xa0>
		base = 10;
  800f72:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	3c 2f                	cmp    $0x2f,%al
  800f80:	7e 19                	jle    800f9b <strtol+0xc2>
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	3c 39                	cmp    $0x39,%al
  800f89:	7f 10                	jg     800f9b <strtol+0xc2>
			dig = *s - '0';
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	0f be c0             	movsbl %al,%eax
  800f93:	83 e8 30             	sub    $0x30,%eax
  800f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f99:	eb 42                	jmp    800fdd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	3c 60                	cmp    $0x60,%al
  800fa2:	7e 19                	jle    800fbd <strtol+0xe4>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 7a                	cmp    $0x7a,%al
  800fab:	7f 10                	jg     800fbd <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	0f be c0             	movsbl %al,%eax
  800fb5:	83 e8 57             	sub    $0x57,%eax
  800fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fbb:	eb 20                	jmp    800fdd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	8a 00                	mov    (%eax),%al
  800fc2:	3c 40                	cmp    $0x40,%al
  800fc4:	7e 39                	jle    800fff <strtol+0x126>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 5a                	cmp    $0x5a,%al
  800fcd:	7f 30                	jg     800fff <strtol+0x126>
			dig = *s - 'A' + 10;
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	0f be c0             	movsbl %al,%eax
  800fd7:	83 e8 37             	sub    $0x37,%eax
  800fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fe3:	7d 19                	jge    800ffe <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fe5:	ff 45 08             	incl   0x8(%ebp)
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fef:	89 c2                	mov    %eax,%edx
  800ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff4:	01 d0                	add    %edx,%eax
  800ff6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ff9:	e9 7b ff ff ff       	jmp    800f79 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ffe:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800fff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801003:	74 08                	je     80100d <strtol+0x134>
		*endptr = (char *) s;
  801005:	8b 45 0c             	mov    0xc(%ebp),%eax
  801008:	8b 55 08             	mov    0x8(%ebp),%edx
  80100b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80100d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801011:	74 07                	je     80101a <strtol+0x141>
  801013:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801016:	f7 d8                	neg    %eax
  801018:	eb 03                	jmp    80101d <strtol+0x144>
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    

0080101f <ltostr>:

void
ltostr(long value, char *str)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801025:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80102c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801033:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801037:	79 13                	jns    80104c <ltostr+0x2d>
	{
		neg = 1;
  801039:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801046:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801049:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801054:	99                   	cltd   
  801055:	f7 f9                	idiv   %ecx
  801057:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	89 c2                	mov    %eax,%edx
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	01 d0                	add    %edx,%eax
  80106a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80106d:	83 c2 30             	add    $0x30,%edx
  801070:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801072:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801075:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80107a:	f7 e9                	imul   %ecx
  80107c:	c1 fa 02             	sar    $0x2,%edx
  80107f:	89 c8                	mov    %ecx,%eax
  801081:	c1 f8 1f             	sar    $0x1f,%eax
  801084:	29 c2                	sub    %eax,%edx
  801086:	89 d0                	mov    %edx,%eax
  801088:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80108b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801093:	f7 e9                	imul   %ecx
  801095:	c1 fa 02             	sar    $0x2,%edx
  801098:	89 c8                	mov    %ecx,%eax
  80109a:	c1 f8 1f             	sar    $0x1f,%eax
  80109d:	29 c2                	sub    %eax,%edx
  80109f:	89 d0                	mov    %edx,%eax
  8010a1:	c1 e0 02             	shl    $0x2,%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	01 c0                	add    %eax,%eax
  8010a8:	29 c1                	sub    %eax,%ecx
  8010aa:	89 ca                	mov    %ecx,%edx
  8010ac:	85 d2                	test   %edx,%edx
  8010ae:	75 9c                	jne    80104c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ba:	48                   	dec    %eax
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010c2:	74 3d                	je     801101 <ltostr+0xe2>
		start = 1 ;
  8010c4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010cb:	eb 34                	jmp    801101 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d3:	01 d0                	add    %edx,%eax
  8010d5:	8a 00                	mov    (%eax),%al
  8010d7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	01 c2                	add    %eax,%edx
  8010e2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e8:	01 c8                	add    %ecx,%eax
  8010ea:	8a 00                	mov    (%eax),%al
  8010ec:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f4:	01 c2                	add    %eax,%edx
  8010f6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010f9:	88 02                	mov    %al,(%edx)
		start++ ;
  8010fb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010fe:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801104:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801107:	7c c4                	jl     8010cd <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801109:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801114:	90                   	nop
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80111d:	ff 75 08             	pushl  0x8(%ebp)
  801120:	e8 54 fa ff ff       	call   800b79 <strlen>
  801125:	83 c4 04             	add    $0x4,%esp
  801128:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	e8 46 fa ff ff       	call   800b79 <strlen>
  801133:	83 c4 04             	add    $0x4,%esp
  801136:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801139:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801140:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801147:	eb 17                	jmp    801160 <strcconcat+0x49>
		final[s] = str1[s] ;
  801149:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80114c:	8b 45 10             	mov    0x10(%ebp),%eax
  80114f:	01 c2                	add    %eax,%edx
  801151:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	01 c8                	add    %ecx,%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80115d:	ff 45 fc             	incl   -0x4(%ebp)
  801160:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801163:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801166:	7c e1                	jl     801149 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801168:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80116f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801176:	eb 1f                	jmp    801197 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8d 50 01             	lea    0x1(%eax),%edx
  80117e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801181:	89 c2                	mov    %eax,%edx
  801183:	8b 45 10             	mov    0x10(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801194:	ff 45 f8             	incl   -0x8(%ebp)
  801197:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80119d:	7c d9                	jl     801178 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80119f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
}
  8011aa:	90                   	nop
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bc:	8b 00                	mov    (%eax),%eax
  8011be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c8:	01 d0                	add    %edx,%eax
  8011ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d0:	eb 0c                	jmp    8011de <strsplit+0x31>
			*string++ = 0;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	8d 50 01             	lea    0x1(%eax),%edx
  8011d8:	89 55 08             	mov    %edx,0x8(%ebp)
  8011db:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011de:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e1:	8a 00                	mov    (%eax),%al
  8011e3:	84 c0                	test   %al,%al
  8011e5:	74 18                	je     8011ff <strsplit+0x52>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	0f be c0             	movsbl %al,%eax
  8011ef:	50                   	push   %eax
  8011f0:	ff 75 0c             	pushl  0xc(%ebp)
  8011f3:	e8 13 fb ff ff       	call   800d0b <strchr>
  8011f8:	83 c4 08             	add    $0x8,%esp
  8011fb:	85 c0                	test   %eax,%eax
  8011fd:	75 d3                	jne    8011d2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	84 c0                	test   %al,%al
  801206:	74 5a                	je     801262 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801208:	8b 45 14             	mov    0x14(%ebp),%eax
  80120b:	8b 00                	mov    (%eax),%eax
  80120d:	83 f8 0f             	cmp    $0xf,%eax
  801210:	75 07                	jne    801219 <strsplit+0x6c>
		{
			return 0;
  801212:	b8 00 00 00 00       	mov    $0x0,%eax
  801217:	eb 66                	jmp    80127f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801219:	8b 45 14             	mov    0x14(%ebp),%eax
  80121c:	8b 00                	mov    (%eax),%eax
  80121e:	8d 48 01             	lea    0x1(%eax),%ecx
  801221:	8b 55 14             	mov    0x14(%ebp),%edx
  801224:	89 0a                	mov    %ecx,(%edx)
  801226:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 c2                	add    %eax,%edx
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801237:	eb 03                	jmp    80123c <strsplit+0x8f>
			string++;
  801239:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	84 c0                	test   %al,%al
  801243:	74 8b                	je     8011d0 <strsplit+0x23>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	0f be c0             	movsbl %al,%eax
  80124d:	50                   	push   %eax
  80124e:	ff 75 0c             	pushl  0xc(%ebp)
  801251:	e8 b5 fa ff ff       	call   800d0b <strchr>
  801256:	83 c4 08             	add    $0x8,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	74 dc                	je     801239 <strsplit+0x8c>
			string++;
	}
  80125d:	e9 6e ff ff ff       	jmp    8011d0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801262:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801263:	8b 45 14             	mov    0x14(%ebp),%eax
  801266:	8b 00                	mov    (%eax),%eax
  801268:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126f:	8b 45 10             	mov    0x10(%ebp),%eax
  801272:	01 d0                	add    %edx,%eax
  801274:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80127a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	57                   	push   %edi
  801285:	56                   	push   %esi
  801286:	53                   	push   %ebx
  801287:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801290:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801293:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801296:	8b 7d 18             	mov    0x18(%ebp),%edi
  801299:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80129c:	cd 30                	int    $0x30
  80129e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8012a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012a4:	83 c4 10             	add    $0x10,%esp
  8012a7:	5b                   	pop    %ebx
  8012a8:	5e                   	pop    %esi
  8012a9:	5f                   	pop    %edi
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 04             	sub    $0x4,%esp
  8012b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012b8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	52                   	push   %edx
  8012c4:	ff 75 0c             	pushl  0xc(%ebp)
  8012c7:	50                   	push   %eax
  8012c8:	6a 00                	push   $0x0
  8012ca:	e8 b2 ff ff ff       	call   801281 <syscall>
  8012cf:	83 c4 18             	add    $0x18,%esp
}
  8012d2:	90                   	nop
  8012d3:	c9                   	leave  
  8012d4:	c3                   	ret    

008012d5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 01                	push   $0x1
  8012e4:	e8 98 ff ff ff       	call   801281 <syscall>
  8012e9:	83 c4 18             	add    $0x18,%esp
}
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	52                   	push   %edx
  8012fe:	50                   	push   %eax
  8012ff:	6a 05                	push   $0x5
  801301:	e8 7b ff ff ff       	call   801281 <syscall>
  801306:	83 c4 18             	add    $0x18,%esp
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	56                   	push   %esi
  80130f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801310:	8b 75 18             	mov    0x18(%ebp),%esi
  801313:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801316:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	56                   	push   %esi
  801320:	53                   	push   %ebx
  801321:	51                   	push   %ecx
  801322:	52                   	push   %edx
  801323:	50                   	push   %eax
  801324:	6a 06                	push   $0x6
  801326:	e8 56 ff ff ff       	call   801281 <syscall>
  80132b:	83 c4 18             	add    $0x18,%esp
}
  80132e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801331:	5b                   	pop    %ebx
  801332:	5e                   	pop    %esi
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	52                   	push   %edx
  801345:	50                   	push   %eax
  801346:	6a 07                	push   $0x7
  801348:	e8 34 ff ff ff       	call   801281 <syscall>
  80134d:	83 c4 18             	add    $0x18,%esp
}
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	ff 75 0c             	pushl  0xc(%ebp)
  80135e:	ff 75 08             	pushl  0x8(%ebp)
  801361:	6a 08                	push   $0x8
  801363:	e8 19 ff ff ff       	call   801281 <syscall>
  801368:	83 c4 18             	add    $0x18,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 09                	push   $0x9
  80137c:	e8 00 ff ff ff       	call   801281 <syscall>
  801381:	83 c4 18             	add    $0x18,%esp
}
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 0a                	push   $0xa
  801395:	e8 e7 fe ff ff       	call   801281 <syscall>
  80139a:	83 c4 18             	add    $0x18,%esp
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 0b                	push   $0xb
  8013ae:	e8 ce fe ff ff       	call   801281 <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	ff 75 0c             	pushl  0xc(%ebp)
  8013c4:	ff 75 08             	pushl  0x8(%ebp)
  8013c7:	6a 0f                	push   $0xf
  8013c9:	e8 b3 fe ff ff       	call   801281 <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
	return;
  8013d1:	90                   	nop
}
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	ff 75 0c             	pushl  0xc(%ebp)
  8013e0:	ff 75 08             	pushl  0x8(%ebp)
  8013e3:	6a 10                	push   $0x10
  8013e5:	e8 97 fe ff ff       	call   801281 <syscall>
  8013ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8013ed:	90                   	nop
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	ff 75 10             	pushl  0x10(%ebp)
  8013fa:	ff 75 0c             	pushl  0xc(%ebp)
  8013fd:	ff 75 08             	pushl  0x8(%ebp)
  801400:	6a 11                	push   $0x11
  801402:	e8 7a fe ff ff       	call   801281 <syscall>
  801407:	83 c4 18             	add    $0x18,%esp
	return ;
  80140a:	90                   	nop
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 0c                	push   $0xc
  80141c:	e8 60 fe ff ff       	call   801281 <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	ff 75 08             	pushl  0x8(%ebp)
  801434:	6a 0d                	push   $0xd
  801436:	e8 46 fe ff ff       	call   801281 <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
}
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 0e                	push   $0xe
  80144f:	e8 2d fe ff ff       	call   801281 <syscall>
  801454:	83 c4 18             	add    $0x18,%esp
}
  801457:	90                   	nop
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 13                	push   $0x13
  801469:	e8 13 fe ff ff       	call   801281 <syscall>
  80146e:	83 c4 18             	add    $0x18,%esp
}
  801471:	90                   	nop
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 14                	push   $0x14
  801483:	e8 f9 fd ff ff       	call   801281 <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	90                   	nop
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <sys_cputc>:


void
sys_cputc(const char c)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80149a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	50                   	push   %eax
  8014a7:	6a 15                	push   $0x15
  8014a9:	e8 d3 fd ff ff       	call   801281 <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 16                	push   $0x16
  8014c3:	e8 b9 fd ff ff       	call   801281 <syscall>
  8014c8:	83 c4 18             	add    $0x18,%esp
}
  8014cb:	90                   	nop
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	ff 75 0c             	pushl  0xc(%ebp)
  8014dd:	50                   	push   %eax
  8014de:	6a 17                	push   $0x17
  8014e0:	e8 9c fd ff ff       	call   801281 <syscall>
  8014e5:	83 c4 18             	add    $0x18,%esp
}
  8014e8:	c9                   	leave  
  8014e9:	c3                   	ret    

008014ea <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014ea:	55                   	push   %ebp
  8014eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	52                   	push   %edx
  8014fa:	50                   	push   %eax
  8014fb:	6a 1a                	push   $0x1a
  8014fd:	e8 7f fd ff ff       	call   801281 <syscall>
  801502:	83 c4 18             	add    $0x18,%esp
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80150a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	52                   	push   %edx
  801517:	50                   	push   %eax
  801518:	6a 18                	push   $0x18
  80151a:	e8 62 fd ff ff       	call   801281 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	90                   	nop
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	52                   	push   %edx
  801535:	50                   	push   %eax
  801536:	6a 19                	push   $0x19
  801538:	e8 44 fd ff ff       	call   801281 <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	90                   	nop
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 04             	sub    $0x4,%esp
  801549:	8b 45 10             	mov    0x10(%ebp),%eax
  80154c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80154f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801552:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	6a 00                	push   $0x0
  80155b:	51                   	push   %ecx
  80155c:	52                   	push   %edx
  80155d:	ff 75 0c             	pushl  0xc(%ebp)
  801560:	50                   	push   %eax
  801561:	6a 1b                	push   $0x1b
  801563:	e8 19 fd ff ff       	call   801281 <syscall>
  801568:	83 c4 18             	add    $0x18,%esp
}
  80156b:	c9                   	leave  
  80156c:	c3                   	ret    

0080156d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801570:	8b 55 0c             	mov    0xc(%ebp),%edx
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	52                   	push   %edx
  80157d:	50                   	push   %eax
  80157e:	6a 1c                	push   $0x1c
  801580:	e8 fc fc ff ff       	call   801281 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80158d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801590:	8b 55 0c             	mov    0xc(%ebp),%edx
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	51                   	push   %ecx
  80159b:	52                   	push   %edx
  80159c:	50                   	push   %eax
  80159d:	6a 1d                	push   $0x1d
  80159f:	e8 dd fc ff ff       	call   801281 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	52                   	push   %edx
  8015b9:	50                   	push   %eax
  8015ba:	6a 1e                	push   $0x1e
  8015bc:	e8 c0 fc ff ff       	call   801281 <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 1f                	push   $0x1f
  8015d5:	e8 a7 fc ff ff       	call   801281 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	6a 00                	push   $0x0
  8015e7:	ff 75 14             	pushl  0x14(%ebp)
  8015ea:	ff 75 10             	pushl  0x10(%ebp)
  8015ed:	ff 75 0c             	pushl  0xc(%ebp)
  8015f0:	50                   	push   %eax
  8015f1:	6a 20                	push   $0x20
  8015f3:	e8 89 fc ff ff       	call   801281 <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	50                   	push   %eax
  80160c:	6a 21                	push   $0x21
  80160e:	e8 6e fc ff ff       	call   801281 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	90                   	nop
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	50                   	push   %eax
  801628:	6a 22                	push   $0x22
  80162a:	e8 52 fc ff ff       	call   801281 <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 02                	push   $0x2
  801643:	e8 39 fc ff ff       	call   801281 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 03                	push   $0x3
  80165c:	e8 20 fc ff ff       	call   801281 <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 04                	push   $0x4
  801675:	e8 07 fc ff ff       	call   801281 <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_exit_env>:


void sys_exit_env(void)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 23                	push   $0x23
  80168e:	e8 ee fb ff ff       	call   801281 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	90                   	nop
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80169f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a2:	8d 50 04             	lea    0x4(%eax),%edx
  8016a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	52                   	push   %edx
  8016af:	50                   	push   %eax
  8016b0:	6a 24                	push   $0x24
  8016b2:	e8 ca fb ff ff       	call   801281 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
	return result;
  8016ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c3:	89 01                	mov    %eax,(%ecx)
  8016c5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	c9                   	leave  
  8016cc:	c2 04 00             	ret    $0x4

008016cf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	ff 75 10             	pushl  0x10(%ebp)
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	6a 12                	push   $0x12
  8016e1:	e8 9b fb ff ff       	call   801281 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e9:	90                   	nop
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_rcr2>:
uint32 sys_rcr2()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 25                	push   $0x25
  8016fb:	e8 81 fb ff ff       	call   801281 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801711:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	50                   	push   %eax
  80171e:	6a 26                	push   $0x26
  801720:	e8 5c fb ff ff       	call   801281 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
	return ;
  801728:	90                   	nop
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <rsttst>:
void rsttst()
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 28                	push   $0x28
  80173a:	e8 42 fb ff ff       	call   801281 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
	return ;
  801742:	90                   	nop
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	8b 45 14             	mov    0x14(%ebp),%eax
  80174e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801751:	8b 55 18             	mov    0x18(%ebp),%edx
  801754:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801758:	52                   	push   %edx
  801759:	50                   	push   %eax
  80175a:	ff 75 10             	pushl  0x10(%ebp)
  80175d:	ff 75 0c             	pushl  0xc(%ebp)
  801760:	ff 75 08             	pushl  0x8(%ebp)
  801763:	6a 27                	push   $0x27
  801765:	e8 17 fb ff ff       	call   801281 <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
	return ;
  80176d:	90                   	nop
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <chktst>:
void chktst(uint32 n)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	6a 29                	push   $0x29
  801780:	e8 fc fa ff ff       	call   801281 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
	return ;
  801788:	90                   	nop
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <inctst>:

void inctst()
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 2a                	push   $0x2a
  80179a:	e8 e2 fa ff ff       	call   801281 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a2:	90                   	nop
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <gettst>:
uint32 gettst()
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 2b                	push   $0x2b
  8017b4:	e8 c8 fa ff ff       	call   801281 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 2c                	push   $0x2c
  8017d0:	e8 ac fa ff ff       	call   801281 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
  8017d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017db:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017df:	75 07                	jne    8017e8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e6:	eb 05                	jmp    8017ed <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 2c                	push   $0x2c
  801801:	e8 7b fa ff ff       	call   801281 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
  801809:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80180c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801810:	75 07                	jne    801819 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801812:	b8 01 00 00 00       	mov    $0x1,%eax
  801817:	eb 05                	jmp    80181e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 2c                	push   $0x2c
  801832:	e8 4a fa ff ff       	call   801281 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
  80183a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80183d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801841:	75 07                	jne    80184a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801843:	b8 01 00 00 00       	mov    $0x1,%eax
  801848:	eb 05                	jmp    80184f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 2c                	push   $0x2c
  801863:	e8 19 fa ff ff       	call   801281 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
  80186b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80186e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801872:	75 07                	jne    80187b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801874:	b8 01 00 00 00       	mov    $0x1,%eax
  801879:	eb 05                	jmp    801880 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	ff 75 08             	pushl  0x8(%ebp)
  801890:	6a 2d                	push   $0x2d
  801892:	e8 ea f9 ff ff       	call   801281 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
	return ;
  80189a:	90                   	nop
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8018a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	53                   	push   %ebx
  8018b0:	51                   	push   %ecx
  8018b1:	52                   	push   %edx
  8018b2:	50                   	push   %eax
  8018b3:	6a 2e                	push   $0x2e
  8018b5:	e8 c7 f9 ff ff       	call   801281 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	52                   	push   %edx
  8018d2:	50                   	push   %eax
  8018d3:	6a 2f                	push   $0x2f
  8018d5:	e8 a7 f9 ff ff       	call   801281 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8018eb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8018ef:	83 ec 0c             	sub    $0xc,%esp
  8018f2:	50                   	push   %eax
  8018f3:	e8 96 fb ff ff       	call   80148e <sys_cputc>
  8018f8:	83 c4 10             	add    $0x10,%esp
}
  8018fb:	90                   	nop
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801904:	e8 51 fb ff ff       	call   80145a <sys_disable_interrupt>
	char c = ch;
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80190f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	50                   	push   %eax
  801917:	e8 72 fb ff ff       	call   80148e <sys_cputc>
  80191c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80191f:	e8 50 fb ff ff       	call   801474 <sys_enable_interrupt>
}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <getchar>:

int
getchar(void)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80192d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801934:	eb 08                	jmp    80193e <getchar+0x17>
	{
		c = sys_cgetc();
  801936:	e8 9a f9 ff ff       	call   8012d5 <sys_cgetc>
  80193b:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80193e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801942:	74 f2                	je     801936 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801944:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <atomic_getchar>:

int
atomic_getchar(void)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80194f:	e8 06 fb ff ff       	call   80145a <sys_disable_interrupt>
	int c=0;
  801954:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80195b:	eb 08                	jmp    801965 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80195d:	e8 73 f9 ff ff       	call   8012d5 <sys_cgetc>
  801962:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801969:	74 f2                	je     80195d <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80196b:	e8 04 fb ff ff       	call   801474 <sys_enable_interrupt>
	return c;
  801970:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <iscons>:

int iscons(int fdnum)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801978:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80197d:	5d                   	pop    %ebp
  80197e:	c3                   	ret    
  80197f:	90                   	nop

00801980 <__udivdi3>:
  801980:	55                   	push   %ebp
  801981:	57                   	push   %edi
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	83 ec 1c             	sub    $0x1c,%esp
  801987:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80198b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80198f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801993:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801997:	89 ca                	mov    %ecx,%edx
  801999:	89 f8                	mov    %edi,%eax
  80199b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80199f:	85 f6                	test   %esi,%esi
  8019a1:	75 2d                	jne    8019d0 <__udivdi3+0x50>
  8019a3:	39 cf                	cmp    %ecx,%edi
  8019a5:	77 65                	ja     801a0c <__udivdi3+0x8c>
  8019a7:	89 fd                	mov    %edi,%ebp
  8019a9:	85 ff                	test   %edi,%edi
  8019ab:	75 0b                	jne    8019b8 <__udivdi3+0x38>
  8019ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8019b2:	31 d2                	xor    %edx,%edx
  8019b4:	f7 f7                	div    %edi
  8019b6:	89 c5                	mov    %eax,%ebp
  8019b8:	31 d2                	xor    %edx,%edx
  8019ba:	89 c8                	mov    %ecx,%eax
  8019bc:	f7 f5                	div    %ebp
  8019be:	89 c1                	mov    %eax,%ecx
  8019c0:	89 d8                	mov    %ebx,%eax
  8019c2:	f7 f5                	div    %ebp
  8019c4:	89 cf                	mov    %ecx,%edi
  8019c6:	89 fa                	mov    %edi,%edx
  8019c8:	83 c4 1c             	add    $0x1c,%esp
  8019cb:	5b                   	pop    %ebx
  8019cc:	5e                   	pop    %esi
  8019cd:	5f                   	pop    %edi
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    
  8019d0:	39 ce                	cmp    %ecx,%esi
  8019d2:	77 28                	ja     8019fc <__udivdi3+0x7c>
  8019d4:	0f bd fe             	bsr    %esi,%edi
  8019d7:	83 f7 1f             	xor    $0x1f,%edi
  8019da:	75 40                	jne    801a1c <__udivdi3+0x9c>
  8019dc:	39 ce                	cmp    %ecx,%esi
  8019de:	72 0a                	jb     8019ea <__udivdi3+0x6a>
  8019e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019e4:	0f 87 9e 00 00 00    	ja     801a88 <__udivdi3+0x108>
  8019ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ef:	89 fa                	mov    %edi,%edx
  8019f1:	83 c4 1c             	add    $0x1c,%esp
  8019f4:	5b                   	pop    %ebx
  8019f5:	5e                   	pop    %esi
  8019f6:	5f                   	pop    %edi
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    
  8019f9:	8d 76 00             	lea    0x0(%esi),%esi
  8019fc:	31 ff                	xor    %edi,%edi
  8019fe:	31 c0                	xor    %eax,%eax
  801a00:	89 fa                	mov    %edi,%edx
  801a02:	83 c4 1c             	add    $0x1c,%esp
  801a05:	5b                   	pop    %ebx
  801a06:	5e                   	pop    %esi
  801a07:	5f                   	pop    %edi
  801a08:	5d                   	pop    %ebp
  801a09:	c3                   	ret    
  801a0a:	66 90                	xchg   %ax,%ax
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	f7 f7                	div    %edi
  801a10:	31 ff                	xor    %edi,%edi
  801a12:	89 fa                	mov    %edi,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a21:	89 eb                	mov    %ebp,%ebx
  801a23:	29 fb                	sub    %edi,%ebx
  801a25:	89 f9                	mov    %edi,%ecx
  801a27:	d3 e6                	shl    %cl,%esi
  801a29:	89 c5                	mov    %eax,%ebp
  801a2b:	88 d9                	mov    %bl,%cl
  801a2d:	d3 ed                	shr    %cl,%ebp
  801a2f:	89 e9                	mov    %ebp,%ecx
  801a31:	09 f1                	or     %esi,%ecx
  801a33:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a37:	89 f9                	mov    %edi,%ecx
  801a39:	d3 e0                	shl    %cl,%eax
  801a3b:	89 c5                	mov    %eax,%ebp
  801a3d:	89 d6                	mov    %edx,%esi
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 ee                	shr    %cl,%esi
  801a43:	89 f9                	mov    %edi,%ecx
  801a45:	d3 e2                	shl    %cl,%edx
  801a47:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a4b:	88 d9                	mov    %bl,%cl
  801a4d:	d3 e8                	shr    %cl,%eax
  801a4f:	09 c2                	or     %eax,%edx
  801a51:	89 d0                	mov    %edx,%eax
  801a53:	89 f2                	mov    %esi,%edx
  801a55:	f7 74 24 0c          	divl   0xc(%esp)
  801a59:	89 d6                	mov    %edx,%esi
  801a5b:	89 c3                	mov    %eax,%ebx
  801a5d:	f7 e5                	mul    %ebp
  801a5f:	39 d6                	cmp    %edx,%esi
  801a61:	72 19                	jb     801a7c <__udivdi3+0xfc>
  801a63:	74 0b                	je     801a70 <__udivdi3+0xf0>
  801a65:	89 d8                	mov    %ebx,%eax
  801a67:	31 ff                	xor    %edi,%edi
  801a69:	e9 58 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a6e:	66 90                	xchg   %ax,%ax
  801a70:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a74:	89 f9                	mov    %edi,%ecx
  801a76:	d3 e2                	shl    %cl,%edx
  801a78:	39 c2                	cmp    %eax,%edx
  801a7a:	73 e9                	jae    801a65 <__udivdi3+0xe5>
  801a7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a7f:	31 ff                	xor    %edi,%edi
  801a81:	e9 40 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a86:	66 90                	xchg   %ax,%ax
  801a88:	31 c0                	xor    %eax,%eax
  801a8a:	e9 37 ff ff ff       	jmp    8019c6 <__udivdi3+0x46>
  801a8f:	90                   	nop

00801a90 <__umoddi3>:
  801a90:	55                   	push   %ebp
  801a91:	57                   	push   %edi
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 1c             	sub    $0x1c,%esp
  801a97:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a9b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a9f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aa3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801aa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aaf:	89 f3                	mov    %esi,%ebx
  801ab1:	89 fa                	mov    %edi,%edx
  801ab3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab7:	89 34 24             	mov    %esi,(%esp)
  801aba:	85 c0                	test   %eax,%eax
  801abc:	75 1a                	jne    801ad8 <__umoddi3+0x48>
  801abe:	39 f7                	cmp    %esi,%edi
  801ac0:	0f 86 a2 00 00 00    	jbe    801b68 <__umoddi3+0xd8>
  801ac6:	89 c8                	mov    %ecx,%eax
  801ac8:	89 f2                	mov    %esi,%edx
  801aca:	f7 f7                	div    %edi
  801acc:	89 d0                	mov    %edx,%eax
  801ace:	31 d2                	xor    %edx,%edx
  801ad0:	83 c4 1c             	add    $0x1c,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5f                   	pop    %edi
  801ad6:	5d                   	pop    %ebp
  801ad7:	c3                   	ret    
  801ad8:	39 f0                	cmp    %esi,%eax
  801ada:	0f 87 ac 00 00 00    	ja     801b8c <__umoddi3+0xfc>
  801ae0:	0f bd e8             	bsr    %eax,%ebp
  801ae3:	83 f5 1f             	xor    $0x1f,%ebp
  801ae6:	0f 84 ac 00 00 00    	je     801b98 <__umoddi3+0x108>
  801aec:	bf 20 00 00 00       	mov    $0x20,%edi
  801af1:	29 ef                	sub    %ebp,%edi
  801af3:	89 fe                	mov    %edi,%esi
  801af5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801af9:	89 e9                	mov    %ebp,%ecx
  801afb:	d3 e0                	shl    %cl,%eax
  801afd:	89 d7                	mov    %edx,%edi
  801aff:	89 f1                	mov    %esi,%ecx
  801b01:	d3 ef                	shr    %cl,%edi
  801b03:	09 c7                	or     %eax,%edi
  801b05:	89 e9                	mov    %ebp,%ecx
  801b07:	d3 e2                	shl    %cl,%edx
  801b09:	89 14 24             	mov    %edx,(%esp)
  801b0c:	89 d8                	mov    %ebx,%eax
  801b0e:	d3 e0                	shl    %cl,%eax
  801b10:	89 c2                	mov    %eax,%edx
  801b12:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b16:	d3 e0                	shl    %cl,%eax
  801b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b20:	89 f1                	mov    %esi,%ecx
  801b22:	d3 e8                	shr    %cl,%eax
  801b24:	09 d0                	or     %edx,%eax
  801b26:	d3 eb                	shr    %cl,%ebx
  801b28:	89 da                	mov    %ebx,%edx
  801b2a:	f7 f7                	div    %edi
  801b2c:	89 d3                	mov    %edx,%ebx
  801b2e:	f7 24 24             	mull   (%esp)
  801b31:	89 c6                	mov    %eax,%esi
  801b33:	89 d1                	mov    %edx,%ecx
  801b35:	39 d3                	cmp    %edx,%ebx
  801b37:	0f 82 87 00 00 00    	jb     801bc4 <__umoddi3+0x134>
  801b3d:	0f 84 91 00 00 00    	je     801bd4 <__umoddi3+0x144>
  801b43:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b47:	29 f2                	sub    %esi,%edx
  801b49:	19 cb                	sbb    %ecx,%ebx
  801b4b:	89 d8                	mov    %ebx,%eax
  801b4d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b51:	d3 e0                	shl    %cl,%eax
  801b53:	89 e9                	mov    %ebp,%ecx
  801b55:	d3 ea                	shr    %cl,%edx
  801b57:	09 d0                	or     %edx,%eax
  801b59:	89 e9                	mov    %ebp,%ecx
  801b5b:	d3 eb                	shr    %cl,%ebx
  801b5d:	89 da                	mov    %ebx,%edx
  801b5f:	83 c4 1c             	add    $0x1c,%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5e                   	pop    %esi
  801b64:	5f                   	pop    %edi
  801b65:	5d                   	pop    %ebp
  801b66:	c3                   	ret    
  801b67:	90                   	nop
  801b68:	89 fd                	mov    %edi,%ebp
  801b6a:	85 ff                	test   %edi,%edi
  801b6c:	75 0b                	jne    801b79 <__umoddi3+0xe9>
  801b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b73:	31 d2                	xor    %edx,%edx
  801b75:	f7 f7                	div    %edi
  801b77:	89 c5                	mov    %eax,%ebp
  801b79:	89 f0                	mov    %esi,%eax
  801b7b:	31 d2                	xor    %edx,%edx
  801b7d:	f7 f5                	div    %ebp
  801b7f:	89 c8                	mov    %ecx,%eax
  801b81:	f7 f5                	div    %ebp
  801b83:	89 d0                	mov    %edx,%eax
  801b85:	e9 44 ff ff ff       	jmp    801ace <__umoddi3+0x3e>
  801b8a:	66 90                	xchg   %ax,%ax
  801b8c:	89 c8                	mov    %ecx,%eax
  801b8e:	89 f2                	mov    %esi,%edx
  801b90:	83 c4 1c             	add    $0x1c,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
  801b98:	3b 04 24             	cmp    (%esp),%eax
  801b9b:	72 06                	jb     801ba3 <__umoddi3+0x113>
  801b9d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ba1:	77 0f                	ja     801bb2 <__umoddi3+0x122>
  801ba3:	89 f2                	mov    %esi,%edx
  801ba5:	29 f9                	sub    %edi,%ecx
  801ba7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bab:	89 14 24             	mov    %edx,(%esp)
  801bae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bb2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bb6:	8b 14 24             	mov    (%esp),%edx
  801bb9:	83 c4 1c             	add    $0x1c,%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5f                   	pop    %edi
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    
  801bc1:	8d 76 00             	lea    0x0(%esi),%esi
  801bc4:	2b 04 24             	sub    (%esp),%eax
  801bc7:	19 fa                	sbb    %edi,%edx
  801bc9:	89 d1                	mov    %edx,%ecx
  801bcb:	89 c6                	mov    %eax,%esi
  801bcd:	e9 71 ff ff ff       	jmp    801b43 <__umoddi3+0xb3>
  801bd2:	66 90                	xchg   %ax,%ax
  801bd4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bd8:	72 ea                	jb     801bc4 <__umoddi3+0x134>
  801bda:	89 d9                	mov    %ebx,%ecx
  801bdc:	e9 62 ff ff ff       	jmp    801b43 <__umoddi3+0xb3>
