
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 a0 1c 80 00       	push   $0x801ca0
  80005e:	e8 08 0a 00 00       	call   800a6b <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 5a 0e 00 00       	call   800ed3 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 4d 18 00 00       	call   8018d9 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 bc 1c 80 00       	push   $0x801cbc
  80009e:	e8 c8 09 00 00       	call   800a6b <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 1a 0e 00 00       	call   800ed3 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 d9 1c 80 00       	push   $0x801cd9
  8000d0:	e8 43 02 00 00       	call   800318 <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000e1:	e8 61 15 00 00       	call   801647 <sys_getenvindex>
  8000e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ec:	89 d0                	mov    %edx,%eax
  8000ee:	c1 e0 03             	shl    $0x3,%eax
  8000f1:	01 d0                	add    %edx,%eax
  8000f3:	01 c0                	add    %eax,%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000fe:	01 d0                	add    %edx,%eax
  800100:	c1 e0 04             	shl    $0x4,%eax
  800103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800108:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80010d:	a1 20 30 80 00       	mov    0x803020,%eax
  800112:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800118:	84 c0                	test   %al,%al
  80011a:	74 0f                	je     80012b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80011c:	a1 20 30 80 00       	mov    0x803020,%eax
  800121:	05 5c 05 00 00       	add    $0x55c,%eax
  800126:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012f:	7e 0a                	jle    80013b <libmain+0x60>
		binaryname = argv[0];
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8b 00                	mov    (%eax),%eax
  800136:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80013b:	83 ec 08             	sub    $0x8,%esp
  80013e:	ff 75 0c             	pushl  0xc(%ebp)
  800141:	ff 75 08             	pushl  0x8(%ebp)
  800144:	e8 ef fe ff ff       	call   800038 <_main>
  800149:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80014c:	e8 03 13 00 00       	call   801454 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 0c 1d 80 00       	push   $0x801d0c
  800159:	e8 8d 01 00 00       	call   8002eb <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800161:	a1 20 30 80 00       	mov    0x803020,%eax
  800166:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80016c:	a1 20 30 80 00       	mov    0x803020,%eax
  800171:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	52                   	push   %edx
  80017b:	50                   	push   %eax
  80017c:	68 34 1d 80 00       	push   $0x801d34
  800181:	e8 65 01 00 00       	call   8002eb <cprintf>
  800186:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800189:	a1 20 30 80 00       	mov    0x803020,%eax
  80018e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800194:	a1 20 30 80 00       	mov    0x803020,%eax
  800199:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80019f:	a1 20 30 80 00       	mov    0x803020,%eax
  8001a4:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001aa:	51                   	push   %ecx
  8001ab:	52                   	push   %edx
  8001ac:	50                   	push   %eax
  8001ad:	68 5c 1d 80 00       	push   $0x801d5c
  8001b2:	e8 34 01 00 00       	call   8002eb <cprintf>
  8001b7:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bf:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8001c5:	83 ec 08             	sub    $0x8,%esp
  8001c8:	50                   	push   %eax
  8001c9:	68 b4 1d 80 00       	push   $0x801db4
  8001ce:	e8 18 01 00 00       	call   8002eb <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	68 0c 1d 80 00       	push   $0x801d0c
  8001de:	e8 08 01 00 00       	call   8002eb <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001e6:	e8 83 12 00 00       	call   80146e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001eb:	e8 19 00 00 00       	call   800209 <exit>
}
  8001f0:	90                   	nop
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    

008001f3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001f9:	83 ec 0c             	sub    $0xc,%esp
  8001fc:	6a 00                	push   $0x0
  8001fe:	e8 10 14 00 00       	call   801613 <sys_destroy_env>
  800203:	83 c4 10             	add    $0x10,%esp
}
  800206:	90                   	nop
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <exit>:

void
exit(void)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80020f:	e8 65 14 00 00       	call   801679 <sys_exit_env>
}
  800214:	90                   	nop
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80021d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 48 01             	lea    0x1(%eax),%ecx
  800225:	8b 55 0c             	mov    0xc(%ebp),%edx
  800228:	89 0a                	mov    %ecx,(%edx)
  80022a:	8b 55 08             	mov    0x8(%ebp),%edx
  80022d:	88 d1                	mov    %dl,%cl
  80022f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800232:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800236:	8b 45 0c             	mov    0xc(%ebp),%eax
  800239:	8b 00                	mov    (%eax),%eax
  80023b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800240:	75 2c                	jne    80026e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800242:	a0 24 30 80 00       	mov    0x803024,%al
  800247:	0f b6 c0             	movzbl %al,%eax
  80024a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024d:	8b 12                	mov    (%edx),%edx
  80024f:	89 d1                	mov    %edx,%ecx
  800251:	8b 55 0c             	mov    0xc(%ebp),%edx
  800254:	83 c2 08             	add    $0x8,%edx
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	50                   	push   %eax
  80025b:	51                   	push   %ecx
  80025c:	52                   	push   %edx
  80025d:	e8 44 10 00 00       	call   8012a6 <sys_cputs>
  800262:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800265:	8b 45 0c             	mov    0xc(%ebp),%eax
  800268:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800271:	8b 40 04             	mov    0x4(%eax),%eax
  800274:	8d 50 01             	lea    0x1(%eax),%edx
  800277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80027d:	90                   	nop
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800289:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800290:	00 00 00 
	b.cnt = 0;
  800293:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80029d:	ff 75 0c             	pushl  0xc(%ebp)
  8002a0:	ff 75 08             	pushl  0x8(%ebp)
  8002a3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a9:	50                   	push   %eax
  8002aa:	68 17 02 80 00       	push   $0x800217
  8002af:	e8 11 02 00 00       	call   8004c5 <vprintfmt>
  8002b4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002b7:	a0 24 30 80 00       	mov    0x803024,%al
  8002bc:	0f b6 c0             	movzbl %al,%eax
  8002bf:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	50                   	push   %eax
  8002c9:	52                   	push   %edx
  8002ca:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d0:	83 c0 08             	add    $0x8,%eax
  8002d3:	50                   	push   %eax
  8002d4:	e8 cd 0f 00 00       	call   8012a6 <sys_cputs>
  8002d9:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002dc:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8002e3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002e9:	c9                   	leave  
  8002ea:	c3                   	ret    

008002eb <cprintf>:

int cprintf(const char *fmt, ...) {
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002f1:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8002f8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	83 ec 08             	sub    $0x8,%esp
  800304:	ff 75 f4             	pushl  -0xc(%ebp)
  800307:	50                   	push   %eax
  800308:	e8 73 ff ff ff       	call   800280 <vcprintf>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800313:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80031e:	e8 31 11 00 00       	call   801454 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800323:	8d 45 0c             	lea    0xc(%ebp),%eax
  800326:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	ff 75 f4             	pushl  -0xc(%ebp)
  800332:	50                   	push   %eax
  800333:	e8 48 ff ff ff       	call   800280 <vcprintf>
  800338:	83 c4 10             	add    $0x10,%esp
  80033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80033e:	e8 2b 11 00 00       	call   80146e <sys_enable_interrupt>
	return cnt;
  800343:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	53                   	push   %ebx
  80034c:	83 ec 14             	sub    $0x14,%esp
  80034f:	8b 45 10             	mov    0x10(%ebp),%eax
  800352:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800355:	8b 45 14             	mov    0x14(%ebp),%eax
  800358:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80035b:	8b 45 18             	mov    0x18(%ebp),%eax
  80035e:	ba 00 00 00 00       	mov    $0x0,%edx
  800363:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800366:	77 55                	ja     8003bd <printnum+0x75>
  800368:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80036b:	72 05                	jb     800372 <printnum+0x2a>
  80036d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800370:	77 4b                	ja     8003bd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800372:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800375:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800378:	8b 45 18             	mov    0x18(%ebp),%eax
  80037b:	ba 00 00 00 00       	mov    $0x0,%edx
  800380:	52                   	push   %edx
  800381:	50                   	push   %eax
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	ff 75 f0             	pushl  -0x10(%ebp)
  800388:	e8 a3 16 00 00       	call   801a30 <__udivdi3>
  80038d:	83 c4 10             	add    $0x10,%esp
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 20             	pushl  0x20(%ebp)
  800396:	53                   	push   %ebx
  800397:	ff 75 18             	pushl  0x18(%ebp)
  80039a:	52                   	push   %edx
  80039b:	50                   	push   %eax
  80039c:	ff 75 0c             	pushl  0xc(%ebp)
  80039f:	ff 75 08             	pushl  0x8(%ebp)
  8003a2:	e8 a1 ff ff ff       	call   800348 <printnum>
  8003a7:	83 c4 20             	add    $0x20,%esp
  8003aa:	eb 1a                	jmp    8003c6 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ac:	83 ec 08             	sub    $0x8,%esp
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 20             	pushl  0x20(%ebp)
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	ff d0                	call   *%eax
  8003ba:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003bd:	ff 4d 1c             	decl   0x1c(%ebp)
  8003c0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003c4:	7f e6                	jg     8003ac <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003d4:	53                   	push   %ebx
  8003d5:	51                   	push   %ecx
  8003d6:	52                   	push   %edx
  8003d7:	50                   	push   %eax
  8003d8:	e8 63 17 00 00       	call   801b40 <__umoddi3>
  8003dd:	83 c4 10             	add    $0x10,%esp
  8003e0:	05 f4 1f 80 00       	add    $0x801ff4,%eax
  8003e5:	8a 00                	mov    (%eax),%al
  8003e7:	0f be c0             	movsbl %al,%eax
  8003ea:	83 ec 08             	sub    $0x8,%esp
  8003ed:	ff 75 0c             	pushl  0xc(%ebp)
  8003f0:	50                   	push   %eax
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	ff d0                	call   *%eax
  8003f6:	83 c4 10             	add    $0x10,%esp
}
  8003f9:	90                   	nop
  8003fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003fd:	c9                   	leave  
  8003fe:	c3                   	ret    

008003ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ff:	55                   	push   %ebp
  800400:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800402:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800406:	7e 1c                	jle    800424 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	8d 50 08             	lea    0x8(%eax),%edx
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	89 10                	mov    %edx,(%eax)
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	83 e8 08             	sub    $0x8,%eax
  80041d:	8b 50 04             	mov    0x4(%eax),%edx
  800420:	8b 00                	mov    (%eax),%eax
  800422:	eb 40                	jmp    800464 <getuint+0x65>
	else if (lflag)
  800424:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800428:	74 1e                	je     800448 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	8d 50 04             	lea    0x4(%eax),%edx
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	89 10                	mov    %edx,(%eax)
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	83 e8 04             	sub    $0x4,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	ba 00 00 00 00       	mov    $0x0,%edx
  800446:	eb 1c                	jmp    800464 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	8b 00                	mov    (%eax),%eax
  80044d:	8d 50 04             	lea    0x4(%eax),%edx
  800450:	8b 45 08             	mov    0x8(%ebp),%eax
  800453:	89 10                	mov    %edx,(%eax)
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	83 e8 04             	sub    $0x4,%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800464:	5d                   	pop    %ebp
  800465:	c3                   	ret    

00800466 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800469:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80046d:	7e 1c                	jle    80048b <getint+0x25>
		return va_arg(*ap, long long);
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	8d 50 08             	lea    0x8(%eax),%edx
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	89 10                	mov    %edx,(%eax)
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	83 e8 08             	sub    $0x8,%eax
  800484:	8b 50 04             	mov    0x4(%eax),%edx
  800487:	8b 00                	mov    (%eax),%eax
  800489:	eb 38                	jmp    8004c3 <getint+0x5d>
	else if (lflag)
  80048b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80048f:	74 1a                	je     8004ab <getint+0x45>
		return va_arg(*ap, long);
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	8d 50 04             	lea    0x4(%eax),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	89 10                	mov    %edx,(%eax)
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	83 e8 04             	sub    $0x4,%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	99                   	cltd   
  8004a9:	eb 18                	jmp    8004c3 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	8d 50 04             	lea    0x4(%eax),%edx
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	89 10                	mov    %edx,(%eax)
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	83 e8 04             	sub    $0x4,%eax
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	99                   	cltd   
}
  8004c3:	5d                   	pop    %ebp
  8004c4:	c3                   	ret    

008004c5 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	56                   	push   %esi
  8004c9:	53                   	push   %ebx
  8004ca:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004cd:	eb 17                	jmp    8004e6 <vprintfmt+0x21>
			if (ch == '\0')
  8004cf:	85 db                	test   %ebx,%ebx
  8004d1:	0f 84 af 03 00 00    	je     800886 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004d7:	83 ec 08             	sub    $0x8,%esp
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	53                   	push   %ebx
  8004de:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e1:	ff d0                	call   *%eax
  8004e3:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e9:	8d 50 01             	lea    0x1(%eax),%edx
  8004ec:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ef:	8a 00                	mov    (%eax),%al
  8004f1:	0f b6 d8             	movzbl %al,%ebx
  8004f4:	83 fb 25             	cmp    $0x25,%ebx
  8004f7:	75 d6                	jne    8004cf <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004f9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004fd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800504:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80050b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800512:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800519:	8b 45 10             	mov    0x10(%ebp),%eax
  80051c:	8d 50 01             	lea    0x1(%eax),%edx
  80051f:	89 55 10             	mov    %edx,0x10(%ebp)
  800522:	8a 00                	mov    (%eax),%al
  800524:	0f b6 d8             	movzbl %al,%ebx
  800527:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80052a:	83 f8 55             	cmp    $0x55,%eax
  80052d:	0f 87 2b 03 00 00    	ja     80085e <vprintfmt+0x399>
  800533:	8b 04 85 18 20 80 00 	mov    0x802018(,%eax,4),%eax
  80053a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80053c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800540:	eb d7                	jmp    800519 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800542:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800546:	eb d1                	jmp    800519 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800548:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80054f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800552:	89 d0                	mov    %edx,%eax
  800554:	c1 e0 02             	shl    $0x2,%eax
  800557:	01 d0                	add    %edx,%eax
  800559:	01 c0                	add    %eax,%eax
  80055b:	01 d8                	add    %ebx,%eax
  80055d:	83 e8 30             	sub    $0x30,%eax
  800560:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800563:	8b 45 10             	mov    0x10(%ebp),%eax
  800566:	8a 00                	mov    (%eax),%al
  800568:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80056b:	83 fb 2f             	cmp    $0x2f,%ebx
  80056e:	7e 3e                	jle    8005ae <vprintfmt+0xe9>
  800570:	83 fb 39             	cmp    $0x39,%ebx
  800573:	7f 39                	jg     8005ae <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800575:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800578:	eb d5                	jmp    80054f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	83 c0 04             	add    $0x4,%eax
  800580:	89 45 14             	mov    %eax,0x14(%ebp)
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	83 e8 04             	sub    $0x4,%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80058e:	eb 1f                	jmp    8005af <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800590:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800594:	79 83                	jns    800519 <vprintfmt+0x54>
				width = 0;
  800596:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80059d:	e9 77 ff ff ff       	jmp    800519 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005a2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005a9:	e9 6b ff ff ff       	jmp    800519 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005ae:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b3:	0f 89 60 ff ff ff    	jns    800519 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005c6:	e9 4e ff ff ff       	jmp    800519 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005cb:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005ce:	e9 46 ff ff ff       	jmp    800519 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	83 c0 04             	add    $0x4,%eax
  8005d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	83 e8 04             	sub    $0x4,%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	83 ec 08             	sub    $0x8,%esp
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	50                   	push   %eax
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	ff d0                	call   *%eax
  8005f0:	83 c4 10             	add    $0x10,%esp
			break;
  8005f3:	e9 89 02 00 00       	jmp    800881 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	83 c0 04             	add    $0x4,%eax
  8005fe:	89 45 14             	mov    %eax,0x14(%ebp)
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	83 e8 04             	sub    $0x4,%eax
  800607:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800609:	85 db                	test   %ebx,%ebx
  80060b:	79 02                	jns    80060f <vprintfmt+0x14a>
				err = -err;
  80060d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80060f:	83 fb 64             	cmp    $0x64,%ebx
  800612:	7f 0b                	jg     80061f <vprintfmt+0x15a>
  800614:	8b 34 9d 60 1e 80 00 	mov    0x801e60(,%ebx,4),%esi
  80061b:	85 f6                	test   %esi,%esi
  80061d:	75 19                	jne    800638 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80061f:	53                   	push   %ebx
  800620:	68 05 20 80 00       	push   $0x802005
  800625:	ff 75 0c             	pushl  0xc(%ebp)
  800628:	ff 75 08             	pushl  0x8(%ebp)
  80062b:	e8 5e 02 00 00       	call   80088e <printfmt>
  800630:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800633:	e9 49 02 00 00       	jmp    800881 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800638:	56                   	push   %esi
  800639:	68 0e 20 80 00       	push   $0x80200e
  80063e:	ff 75 0c             	pushl  0xc(%ebp)
  800641:	ff 75 08             	pushl  0x8(%ebp)
  800644:	e8 45 02 00 00       	call   80088e <printfmt>
  800649:	83 c4 10             	add    $0x10,%esp
			break;
  80064c:	e9 30 02 00 00       	jmp    800881 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	83 c0 04             	add    $0x4,%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	83 e8 04             	sub    $0x4,%eax
  800660:	8b 30                	mov    (%eax),%esi
  800662:	85 f6                	test   %esi,%esi
  800664:	75 05                	jne    80066b <vprintfmt+0x1a6>
				p = "(null)";
  800666:	be 11 20 80 00       	mov    $0x802011,%esi
			if (width > 0 && padc != '-')
  80066b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066f:	7e 6d                	jle    8006de <vprintfmt+0x219>
  800671:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800675:	74 67                	je     8006de <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800677:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80067a:	83 ec 08             	sub    $0x8,%esp
  80067d:	50                   	push   %eax
  80067e:	56                   	push   %esi
  80067f:	e8 12 05 00 00       	call   800b96 <strnlen>
  800684:	83 c4 10             	add    $0x10,%esp
  800687:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80068a:	eb 16                	jmp    8006a2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80068c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	ff 75 0c             	pushl  0xc(%ebp)
  800696:	50                   	push   %eax
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	ff d0                	call   *%eax
  80069c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80069f:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a6:	7f e4                	jg     80068c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a8:	eb 34                	jmp    8006de <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006aa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ae:	74 1c                	je     8006cc <vprintfmt+0x207>
  8006b0:	83 fb 1f             	cmp    $0x1f,%ebx
  8006b3:	7e 05                	jle    8006ba <vprintfmt+0x1f5>
  8006b5:	83 fb 7e             	cmp    $0x7e,%ebx
  8006b8:	7e 12                	jle    8006cc <vprintfmt+0x207>
					putch('?', putdat);
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	ff 75 0c             	pushl  0xc(%ebp)
  8006c0:	6a 3f                	push   $0x3f
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	ff d0                	call   *%eax
  8006c7:	83 c4 10             	add    $0x10,%esp
  8006ca:	eb 0f                	jmp    8006db <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	53                   	push   %ebx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	ff d0                	call   *%eax
  8006d8:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006db:	ff 4d e4             	decl   -0x1c(%ebp)
  8006de:	89 f0                	mov    %esi,%eax
  8006e0:	8d 70 01             	lea    0x1(%eax),%esi
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be d8             	movsbl %al,%ebx
  8006e8:	85 db                	test   %ebx,%ebx
  8006ea:	74 24                	je     800710 <vprintfmt+0x24b>
  8006ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f0:	78 b8                	js     8006aa <vprintfmt+0x1e5>
  8006f2:	ff 4d e0             	decl   -0x20(%ebp)
  8006f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f9:	79 af                	jns    8006aa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fb:	eb 13                	jmp    800710 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 0c             	pushl  0xc(%ebp)
  800703:	6a 20                	push   $0x20
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	ff d0                	call   *%eax
  80070a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80070d:	ff 4d e4             	decl   -0x1c(%ebp)
  800710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800714:	7f e7                	jg     8006fd <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800716:	e9 66 01 00 00       	jmp    800881 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	ff 75 e8             	pushl  -0x18(%ebp)
  800721:	8d 45 14             	lea    0x14(%ebp),%eax
  800724:	50                   	push   %eax
  800725:	e8 3c fd ff ff       	call   800466 <getint>
  80072a:	83 c4 10             	add    $0x10,%esp
  80072d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800730:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800739:	85 d2                	test   %edx,%edx
  80073b:	79 23                	jns    800760 <vprintfmt+0x29b>
				putch('-', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	6a 2d                	push   $0x2d
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	ff d0                	call   *%eax
  80074a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80074d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800750:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800753:	f7 d8                	neg    %eax
  800755:	83 d2 00             	adc    $0x0,%edx
  800758:	f7 da                	neg    %edx
  80075a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80075d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800760:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800767:	e9 bc 00 00 00       	jmp    800828 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80076c:	83 ec 08             	sub    $0x8,%esp
  80076f:	ff 75 e8             	pushl  -0x18(%ebp)
  800772:	8d 45 14             	lea    0x14(%ebp),%eax
  800775:	50                   	push   %eax
  800776:	e8 84 fc ff ff       	call   8003ff <getuint>
  80077b:	83 c4 10             	add    $0x10,%esp
  80077e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800781:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800784:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80078b:	e9 98 00 00 00       	jmp    800828 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	6a 58                	push   $0x58
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	ff d0                	call   *%eax
  8007bd:	83 c4 10             	add    $0x10,%esp
			break;
  8007c0:	e9 bc 00 00 00       	jmp    800881 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	ff 75 0c             	pushl  0xc(%ebp)
  8007cb:	6a 30                	push   $0x30
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	6a 78                	push   $0x78
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	ff d0                	call   *%eax
  8007e2:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	83 c0 04             	add    $0x4,%eax
  8007eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	83 e8 04             	sub    $0x4,%eax
  8007f4:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800800:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800807:	eb 1f                	jmp    800828 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800809:	83 ec 08             	sub    $0x8,%esp
  80080c:	ff 75 e8             	pushl  -0x18(%ebp)
  80080f:	8d 45 14             	lea    0x14(%ebp),%eax
  800812:	50                   	push   %eax
  800813:	e8 e7 fb ff ff       	call   8003ff <getuint>
  800818:	83 c4 10             	add    $0x10,%esp
  80081b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800821:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800828:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80082c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	52                   	push   %edx
  800833:	ff 75 e4             	pushl  -0x1c(%ebp)
  800836:	50                   	push   %eax
  800837:	ff 75 f4             	pushl  -0xc(%ebp)
  80083a:	ff 75 f0             	pushl  -0x10(%ebp)
  80083d:	ff 75 0c             	pushl  0xc(%ebp)
  800840:	ff 75 08             	pushl  0x8(%ebp)
  800843:	e8 00 fb ff ff       	call   800348 <printnum>
  800848:	83 c4 20             	add    $0x20,%esp
			break;
  80084b:	eb 34                	jmp    800881 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	53                   	push   %ebx
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
			break;
  80085c:	eb 23                	jmp    800881 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80085e:	83 ec 08             	sub    $0x8,%esp
  800861:	ff 75 0c             	pushl  0xc(%ebp)
  800864:	6a 25                	push   $0x25
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80086e:	ff 4d 10             	decl   0x10(%ebp)
  800871:	eb 03                	jmp    800876 <vprintfmt+0x3b1>
  800873:	ff 4d 10             	decl   0x10(%ebp)
  800876:	8b 45 10             	mov    0x10(%ebp),%eax
  800879:	48                   	dec    %eax
  80087a:	8a 00                	mov    (%eax),%al
  80087c:	3c 25                	cmp    $0x25,%al
  80087e:	75 f3                	jne    800873 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800880:	90                   	nop
		}
	}
  800881:	e9 47 fc ff ff       	jmp    8004cd <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800886:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800887:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80088a:	5b                   	pop    %ebx
  80088b:	5e                   	pop    %esi
  80088c:	5d                   	pop    %ebp
  80088d:	c3                   	ret    

0080088e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800894:	8d 45 10             	lea    0x10(%ebp),%eax
  800897:	83 c0 04             	add    $0x4,%eax
  80089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80089d:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a3:	50                   	push   %eax
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 16 fc ff ff       	call   8004c5 <vprintfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008b2:	90                   	nop
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    

008008b5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bb:	8b 40 08             	mov    0x8(%eax),%eax
  8008be:	8d 50 01             	lea    0x1(%eax),%edx
  8008c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 10                	mov    (%eax),%edx
  8008cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cf:	8b 40 04             	mov    0x4(%eax),%eax
  8008d2:	39 c2                	cmp    %eax,%edx
  8008d4:	73 12                	jae    8008e8 <sprintputch+0x33>
		*b->buf++ = ch;
  8008d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	8d 48 01             	lea    0x1(%eax),%ecx
  8008de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e1:	89 0a                	mov    %ecx,(%edx)
  8008e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e6:	88 10                	mov    %dl,(%eax)
}
  8008e8:	90                   	nop
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fa:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	01 d0                	add    %edx,%eax
  800902:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800905:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80090c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800910:	74 06                	je     800918 <vsnprintf+0x2d>
  800912:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800916:	7f 07                	jg     80091f <vsnprintf+0x34>
		return -E_INVAL;
  800918:	b8 03 00 00 00       	mov    $0x3,%eax
  80091d:	eb 20                	jmp    80093f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80091f:	ff 75 14             	pushl  0x14(%ebp)
  800922:	ff 75 10             	pushl  0x10(%ebp)
  800925:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800928:	50                   	push   %eax
  800929:	68 b5 08 80 00       	push   $0x8008b5
  80092e:	e8 92 fb ff ff       	call   8004c5 <vprintfmt>
  800933:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800939:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80093c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80093f:	c9                   	leave  
  800940:	c3                   	ret    

00800941 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800947:	8d 45 10             	lea    0x10(%ebp),%eax
  80094a:	83 c0 04             	add    $0x4,%eax
  80094d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800950:	8b 45 10             	mov    0x10(%ebp),%eax
  800953:	ff 75 f4             	pushl  -0xc(%ebp)
  800956:	50                   	push   %eax
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	ff 75 08             	pushl  0x8(%ebp)
  80095d:	e8 89 ff ff ff       	call   8008eb <vsnprintf>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800968:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800973:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800977:	74 13                	je     80098c <readline+0x1f>
		cprintf("%s", prompt);
  800979:	83 ec 08             	sub    $0x8,%esp
  80097c:	ff 75 08             	pushl  0x8(%ebp)
  80097f:	68 70 21 80 00       	push   $0x802170
  800984:	e8 62 f9 ff ff       	call   8002eb <cprintf>
  800989:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80098c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800993:	83 ec 0c             	sub    $0xc,%esp
  800996:	6a 00                	push   $0x0
  800998:	e8 86 10 00 00       	call   801a23 <iscons>
  80099d:	83 c4 10             	add    $0x10,%esp
  8009a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009a3:	e8 2d 10 00 00       	call   8019d5 <getchar>
  8009a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009af:	79 22                	jns    8009d3 <readline+0x66>
			if (c != -E_EOF)
  8009b1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009b5:	0f 84 ad 00 00 00    	je     800a68 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 ec             	pushl  -0x14(%ebp)
  8009c1:	68 73 21 80 00       	push   $0x802173
  8009c6:	e8 20 f9 ff ff       	call   8002eb <cprintf>
  8009cb:	83 c4 10             	add    $0x10,%esp
			return;
  8009ce:	e9 95 00 00 00       	jmp    800a68 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009d3:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009d7:	7e 34                	jle    800a0d <readline+0xa0>
  8009d9:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009e0:	7f 2b                	jg     800a0d <readline+0xa0>
			if (echoing)
  8009e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009e6:	74 0e                	je     8009f6 <readline+0x89>
				cputchar(c);
  8009e8:	83 ec 0c             	sub    $0xc,%esp
  8009eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8009ee:	e8 9a 0f 00 00       	call   80198d <cputchar>
  8009f3:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8009f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f9:	8d 50 01             	lea    0x1(%eax),%edx
  8009fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8009ff:	89 c2                	mov    %eax,%edx
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	01 d0                	add    %edx,%eax
  800a06:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a09:	88 10                	mov    %dl,(%eax)
  800a0b:	eb 56                	jmp    800a63 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a0d:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a11:	75 1f                	jne    800a32 <readline+0xc5>
  800a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a17:	7e 19                	jle    800a32 <readline+0xc5>
			if (echoing)
  800a19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a1d:	74 0e                	je     800a2d <readline+0xc0>
				cputchar(c);
  800a1f:	83 ec 0c             	sub    $0xc,%esp
  800a22:	ff 75 ec             	pushl  -0x14(%ebp)
  800a25:	e8 63 0f 00 00       	call   80198d <cputchar>
  800a2a:	83 c4 10             	add    $0x10,%esp

			i--;
  800a2d:	ff 4d f4             	decl   -0xc(%ebp)
  800a30:	eb 31                	jmp    800a63 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a32:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a36:	74 0a                	je     800a42 <readline+0xd5>
  800a38:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a3c:	0f 85 61 ff ff ff    	jne    8009a3 <readline+0x36>
			if (echoing)
  800a42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a46:	74 0e                	je     800a56 <readline+0xe9>
				cputchar(c);
  800a48:	83 ec 0c             	sub    $0xc,%esp
  800a4b:	ff 75 ec             	pushl  -0x14(%ebp)
  800a4e:	e8 3a 0f 00 00       	call   80198d <cputchar>
  800a53:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	01 d0                	add    %edx,%eax
  800a5e:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800a61:	eb 06                	jmp    800a69 <readline+0xfc>
		}
	}
  800a63:	e9 3b ff ff ff       	jmp    8009a3 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800a68:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800a69:	c9                   	leave  
  800a6a:	c3                   	ret    

00800a6b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a71:	e8 de 09 00 00       	call   801454 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800a76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7a:	74 13                	je     800a8f <atomic_readline+0x24>
		cprintf("%s", prompt);
  800a7c:	83 ec 08             	sub    $0x8,%esp
  800a7f:	ff 75 08             	pushl  0x8(%ebp)
  800a82:	68 70 21 80 00       	push   $0x802170
  800a87:	e8 5f f8 ff ff       	call   8002eb <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800a8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	6a 00                	push   $0x0
  800a9b:	e8 83 0f 00 00       	call   801a23 <iscons>
  800aa0:	83 c4 10             	add    $0x10,%esp
  800aa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800aa6:	e8 2a 0f 00 00       	call   8019d5 <getchar>
  800aab:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800aae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ab2:	79 23                	jns    800ad7 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800ab4:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ab8:	74 13                	je     800acd <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 ec             	pushl  -0x14(%ebp)
  800ac0:	68 73 21 80 00       	push   $0x802173
  800ac5:	e8 21 f8 ff ff       	call   8002eb <cprintf>
  800aca:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800acd:	e8 9c 09 00 00       	call   80146e <sys_enable_interrupt>
			return;
  800ad2:	e9 9a 00 00 00       	jmp    800b71 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800ad7:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800adb:	7e 34                	jle    800b11 <atomic_readline+0xa6>
  800add:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ae4:	7f 2b                	jg     800b11 <atomic_readline+0xa6>
			if (echoing)
  800ae6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800aea:	74 0e                	je     800afa <atomic_readline+0x8f>
				cputchar(c);
  800aec:	83 ec 0c             	sub    $0xc,%esp
  800aef:	ff 75 ec             	pushl  -0x14(%ebp)
  800af2:	e8 96 0e 00 00       	call   80198d <cputchar>
  800af7:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800afd:	8d 50 01             	lea    0x1(%eax),%edx
  800b00:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b03:	89 c2                	mov    %eax,%edx
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	01 d0                	add    %edx,%eax
  800b0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b0d:	88 10                	mov    %dl,(%eax)
  800b0f:	eb 5b                	jmp    800b6c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800b11:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b15:	75 1f                	jne    800b36 <atomic_readline+0xcb>
  800b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b1b:	7e 19                	jle    800b36 <atomic_readline+0xcb>
			if (echoing)
  800b1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b21:	74 0e                	je     800b31 <atomic_readline+0xc6>
				cputchar(c);
  800b23:	83 ec 0c             	sub    $0xc,%esp
  800b26:	ff 75 ec             	pushl  -0x14(%ebp)
  800b29:	e8 5f 0e 00 00       	call   80198d <cputchar>
  800b2e:	83 c4 10             	add    $0x10,%esp
			i--;
  800b31:	ff 4d f4             	decl   -0xc(%ebp)
  800b34:	eb 36                	jmp    800b6c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800b36:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b3a:	74 0a                	je     800b46 <atomic_readline+0xdb>
  800b3c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b40:	0f 85 60 ff ff ff    	jne    800aa6 <atomic_readline+0x3b>
			if (echoing)
  800b46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b4a:	74 0e                	je     800b5a <atomic_readline+0xef>
				cputchar(c);
  800b4c:	83 ec 0c             	sub    $0xc,%esp
  800b4f:	ff 75 ec             	pushl  -0x14(%ebp)
  800b52:	e8 36 0e 00 00       	call   80198d <cputchar>
  800b57:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800b5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	01 d0                	add    %edx,%eax
  800b62:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800b65:	e8 04 09 00 00       	call   80146e <sys_enable_interrupt>
			return;
  800b6a:	eb 05                	jmp    800b71 <atomic_readline+0x106>
		}
	}
  800b6c:	e9 35 ff ff ff       	jmp    800aa6 <atomic_readline+0x3b>
}
  800b71:	c9                   	leave  
  800b72:	c3                   	ret    

00800b73 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b80:	eb 06                	jmp    800b88 <strlen+0x15>
		n++;
  800b82:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b85:	ff 45 08             	incl   0x8(%ebp)
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	8a 00                	mov    (%eax),%al
  800b8d:	84 c0                	test   %al,%al
  800b8f:	75 f1                	jne    800b82 <strlen+0xf>
		n++;
	return n;
  800b91:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b94:	c9                   	leave  
  800b95:	c3                   	ret    

00800b96 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ba3:	eb 09                	jmp    800bae <strnlen+0x18>
		n++;
  800ba5:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba8:	ff 45 08             	incl   0x8(%ebp)
  800bab:	ff 4d 0c             	decl   0xc(%ebp)
  800bae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb2:	74 09                	je     800bbd <strnlen+0x27>
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	8a 00                	mov    (%eax),%al
  800bb9:	84 c0                	test   %al,%al
  800bbb:	75 e8                	jne    800ba5 <strnlen+0xf>
		n++;
	return n;
  800bbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bce:	90                   	nop
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8d 50 01             	lea    0x1(%eax),%edx
  800bd5:	89 55 08             	mov    %edx,0x8(%ebp)
  800bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bde:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800be1:	8a 12                	mov    (%edx),%dl
  800be3:	88 10                	mov    %dl,(%eax)
  800be5:	8a 00                	mov    (%eax),%al
  800be7:	84 c0                	test   %al,%al
  800be9:	75 e4                	jne    800bcf <strcpy+0xd>
		/* do nothing */;
	return ret;
  800beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bee:	c9                   	leave  
  800bef:	c3                   	ret    

00800bf0 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800bfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c03:	eb 1f                	jmp    800c24 <strncpy+0x34>
		*dst++ = *src;
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8d 50 01             	lea    0x1(%eax),%edx
  800c0b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c11:	8a 12                	mov    (%edx),%dl
  800c13:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c18:	8a 00                	mov    (%eax),%al
  800c1a:	84 c0                	test   %al,%al
  800c1c:	74 03                	je     800c21 <strncpy+0x31>
			src++;
  800c1e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c21:	ff 45 fc             	incl   -0x4(%ebp)
  800c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c27:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c2a:	72 d9                	jb     800c05 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c2f:	c9                   	leave  
  800c30:	c3                   	ret    

00800c31 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c41:	74 30                	je     800c73 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c43:	eb 16                	jmp    800c5b <strlcpy+0x2a>
			*dst++ = *src++;
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8d 50 01             	lea    0x1(%eax),%edx
  800c4b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c54:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c57:	8a 12                	mov    (%edx),%dl
  800c59:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c5b:	ff 4d 10             	decl   0x10(%ebp)
  800c5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c62:	74 09                	je     800c6d <strlcpy+0x3c>
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8a 00                	mov    (%eax),%al
  800c69:	84 c0                	test   %al,%al
  800c6b:	75 d8                	jne    800c45 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c73:	8b 55 08             	mov    0x8(%ebp),%edx
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c79:	29 c2                	sub    %eax,%edx
  800c7b:	89 d0                	mov    %edx,%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c82:	eb 06                	jmp    800c8a <strcmp+0xb>
		p++, q++;
  800c84:	ff 45 08             	incl   0x8(%ebp)
  800c87:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	74 0e                	je     800ca1 <strcmp+0x22>
  800c93:	8b 45 08             	mov    0x8(%ebp),%eax
  800c96:	8a 10                	mov    (%eax),%dl
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	38 c2                	cmp    %al,%dl
  800c9f:	74 e3                	je     800c84 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8a 00                	mov    (%eax),%al
  800ca6:	0f b6 d0             	movzbl %al,%edx
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	0f b6 c0             	movzbl %al,%eax
  800cb1:	29 c2                	sub    %eax,%edx
  800cb3:	89 d0                	mov    %edx,%eax
}
  800cb5:	5d                   	pop    %ebp
  800cb6:	c3                   	ret    

00800cb7 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cb7:	55                   	push   %ebp
  800cb8:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cba:	eb 09                	jmp    800cc5 <strncmp+0xe>
		n--, p++, q++;
  800cbc:	ff 4d 10             	decl   0x10(%ebp)
  800cbf:	ff 45 08             	incl   0x8(%ebp)
  800cc2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc9:	74 17                	je     800ce2 <strncmp+0x2b>
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	74 0e                	je     800ce2 <strncmp+0x2b>
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 10                	mov    (%eax),%dl
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	38 c2                	cmp    %al,%dl
  800ce0:	74 da                	je     800cbc <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ce2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce6:	75 07                	jne    800cef <strncmp+0x38>
		return 0;
  800ce8:	b8 00 00 00 00       	mov    $0x0,%eax
  800ced:	eb 14                	jmp    800d03 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	0f b6 d0             	movzbl %al,%edx
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	0f b6 c0             	movzbl %al,%eax
  800cff:	29 c2                	sub    %eax,%edx
  800d01:	89 d0                	mov    %edx,%eax
}
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 04             	sub    $0x4,%esp
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d11:	eb 12                	jmp    800d25 <strchr+0x20>
		if (*s == c)
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d1b:	75 05                	jne    800d22 <strchr+0x1d>
			return (char *) s;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	eb 11                	jmp    800d33 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d22:	ff 45 08             	incl   0x8(%ebp)
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	84 c0                	test   %al,%al
  800d2c:	75 e5                	jne    800d13 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d33:	c9                   	leave  
  800d34:	c3                   	ret    

00800d35 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	83 ec 04             	sub    $0x4,%esp
  800d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d41:	eb 0d                	jmp    800d50 <strfind+0x1b>
		if (*s == c)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4b:	74 0e                	je     800d5b <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d4d:	ff 45 08             	incl   0x8(%ebp)
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	84 c0                	test   %al,%al
  800d57:	75 ea                	jne    800d43 <strfind+0xe>
  800d59:	eb 01                	jmp    800d5c <strfind+0x27>
		if (*s == c)
			break;
  800d5b:	90                   	nop
	return (char *) s;
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5f:	c9                   	leave  
  800d60:	c3                   	ret    

00800d61 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d73:	eb 0e                	jmp    800d83 <memset+0x22>
		*p++ = c;
  800d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d78:	8d 50 01             	lea    0x1(%eax),%edx
  800d7b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d81:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800d83:	ff 4d f8             	decl   -0x8(%ebp)
  800d86:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800d8a:	79 e9                	jns    800d75 <memset+0x14>
		*p++ = c;

	return v;
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800da3:	eb 16                	jmp    800dbb <memcpy+0x2a>
		*d++ = *s++;
  800da5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	85 c0                	test   %eax,%eax
  800dc6:	75 dd                	jne    800da5 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dc8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dcb:	c9                   	leave  
  800dcc:	c3                   	ret    

00800dcd <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800de5:	73 50                	jae    800e37 <memmove+0x6a>
  800de7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ded:	01 d0                	add    %edx,%eax
  800def:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800df2:	76 43                	jbe    800e37 <memmove+0x6a>
		s += n;
  800df4:	8b 45 10             	mov    0x10(%ebp),%eax
  800df7:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800dfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfd:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e00:	eb 10                	jmp    800e12 <memmove+0x45>
			*--d = *--s;
  800e02:	ff 4d f8             	decl   -0x8(%ebp)
  800e05:	ff 4d fc             	decl   -0x4(%ebp)
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	8a 10                	mov    (%eax),%dl
  800e0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e10:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e18:	89 55 10             	mov    %edx,0x10(%ebp)
  800e1b:	85 c0                	test   %eax,%eax
  800e1d:	75 e3                	jne    800e02 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e1f:	eb 23                	jmp    800e44 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e30:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e33:	8a 12                	mov    (%edx),%dl
  800e35:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e37:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e40:	85 c0                	test   %eax,%eax
  800e42:	75 dd                	jne    800e21 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e47:	c9                   	leave  
  800e48:	c3                   	ret    

00800e49 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e5b:	eb 2a                	jmp    800e87 <memcmp+0x3e>
		if (*s1 != *s2)
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e60:	8a 10                	mov    (%eax),%dl
  800e62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e65:	8a 00                	mov    (%eax),%al
  800e67:	38 c2                	cmp    %al,%dl
  800e69:	74 16                	je     800e81 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	0f b6 d0             	movzbl %al,%edx
  800e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	0f b6 c0             	movzbl %al,%eax
  800e7b:	29 c2                	sub    %eax,%edx
  800e7d:	89 d0                	mov    %edx,%eax
  800e7f:	eb 18                	jmp    800e99 <memcmp+0x50>
		s1++, s2++;
  800e81:	ff 45 fc             	incl   -0x4(%ebp)
  800e84:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	75 c9                	jne    800e5d <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ea1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	01 d0                	add    %edx,%eax
  800ea9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eac:	eb 15                	jmp    800ec3 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 d0             	movzbl %al,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	0f b6 c0             	movzbl %al,%eax
  800ebc:	39 c2                	cmp    %eax,%edx
  800ebe:	74 0d                	je     800ecd <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ec0:	ff 45 08             	incl   0x8(%ebp)
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ec9:	72 e3                	jb     800eae <memfind+0x13>
  800ecb:	eb 01                	jmp    800ece <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ecd:	90                   	nop
	return (void *) s;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed1:	c9                   	leave  
  800ed2:	c3                   	ret    

00800ed3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ed9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ee0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ee7:	eb 03                	jmp    800eec <strtol+0x19>
		s++;
  800ee9:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	3c 20                	cmp    $0x20,%al
  800ef3:	74 f4                	je     800ee9 <strtol+0x16>
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	3c 09                	cmp    $0x9,%al
  800efc:	74 eb                	je     800ee9 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 2b                	cmp    $0x2b,%al
  800f05:	75 05                	jne    800f0c <strtol+0x39>
		s++;
  800f07:	ff 45 08             	incl   0x8(%ebp)
  800f0a:	eb 13                	jmp    800f1f <strtol+0x4c>
	else if (*s == '-')
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8a 00                	mov    (%eax),%al
  800f11:	3c 2d                	cmp    $0x2d,%al
  800f13:	75 0a                	jne    800f1f <strtol+0x4c>
		s++, neg = 1;
  800f15:	ff 45 08             	incl   0x8(%ebp)
  800f18:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f23:	74 06                	je     800f2b <strtol+0x58>
  800f25:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f29:	75 20                	jne    800f4b <strtol+0x78>
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	3c 30                	cmp    $0x30,%al
  800f32:	75 17                	jne    800f4b <strtol+0x78>
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	40                   	inc    %eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	3c 78                	cmp    $0x78,%al
  800f3c:	75 0d                	jne    800f4b <strtol+0x78>
		s += 2, base = 16;
  800f3e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f42:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f49:	eb 28                	jmp    800f73 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4f:	75 15                	jne    800f66 <strtol+0x93>
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 30                	cmp    $0x30,%al
  800f58:	75 0c                	jne    800f66 <strtol+0x93>
		s++, base = 8;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f64:	eb 0d                	jmp    800f73 <strtol+0xa0>
	else if (base == 0)
  800f66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6a:	75 07                	jne    800f73 <strtol+0xa0>
		base = 10;
  800f6c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 2f                	cmp    $0x2f,%al
  800f7a:	7e 19                	jle    800f95 <strtol+0xc2>
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	3c 39                	cmp    $0x39,%al
  800f83:	7f 10                	jg     800f95 <strtol+0xc2>
			dig = *s - '0';
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	0f be c0             	movsbl %al,%eax
  800f8d:	83 e8 30             	sub    $0x30,%eax
  800f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f93:	eb 42                	jmp    800fd7 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	8a 00                	mov    (%eax),%al
  800f9a:	3c 60                	cmp    $0x60,%al
  800f9c:	7e 19                	jle    800fb7 <strtol+0xe4>
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	3c 7a                	cmp    $0x7a,%al
  800fa5:	7f 10                	jg     800fb7 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	0f be c0             	movsbl %al,%eax
  800faf:	83 e8 57             	sub    $0x57,%eax
  800fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb5:	eb 20                	jmp    800fd7 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 40                	cmp    $0x40,%al
  800fbe:	7e 39                	jle    800ff9 <strtol+0x126>
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 5a                	cmp    $0x5a,%al
  800fc7:	7f 30                	jg     800ff9 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	0f be c0             	movsbl %al,%eax
  800fd1:	83 e8 37             	sub    $0x37,%eax
  800fd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fda:	3b 45 10             	cmp    0x10(%ebp),%eax
  800fdd:	7d 19                	jge    800ff8 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800fe9:	89 c2                	mov    %eax,%edx
  800feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ff3:	e9 7b ff ff ff       	jmp    800f73 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800ff8:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	74 08                	je     801007 <strtol+0x134>
		*endptr = (char *) s;
  800fff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801002:	8b 55 08             	mov    0x8(%ebp),%edx
  801005:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801007:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80100b:	74 07                	je     801014 <strtol+0x141>
  80100d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801010:	f7 d8                	neg    %eax
  801012:	eb 03                	jmp    801017 <strtol+0x144>
  801014:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <ltostr>:

void
ltostr(long value, char *str)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80101f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801026:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80102d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801031:	79 13                	jns    801046 <ltostr+0x2d>
	{
		neg = 1;
  801033:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801040:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801043:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80104e:	99                   	cltd   
  80104f:	f7 f9                	idiv   %ecx
  801051:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801054:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801057:	8d 50 01             	lea    0x1(%eax),%edx
  80105a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80105d:	89 c2                	mov    %eax,%edx
  80105f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801062:	01 d0                	add    %edx,%eax
  801064:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801067:	83 c2 30             	add    $0x30,%edx
  80106a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80106c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801074:	f7 e9                	imul   %ecx
  801076:	c1 fa 02             	sar    $0x2,%edx
  801079:	89 c8                	mov    %ecx,%eax
  80107b:	c1 f8 1f             	sar    $0x1f,%eax
  80107e:	29 c2                	sub    %eax,%edx
  801080:	89 d0                	mov    %edx,%eax
  801082:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801085:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801088:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80108d:	f7 e9                	imul   %ecx
  80108f:	c1 fa 02             	sar    $0x2,%edx
  801092:	89 c8                	mov    %ecx,%eax
  801094:	c1 f8 1f             	sar    $0x1f,%eax
  801097:	29 c2                	sub    %eax,%edx
  801099:	89 d0                	mov    %edx,%eax
  80109b:	c1 e0 02             	shl    $0x2,%eax
  80109e:	01 d0                	add    %edx,%eax
  8010a0:	01 c0                	add    %eax,%eax
  8010a2:	29 c1                	sub    %eax,%ecx
  8010a4:	89 ca                	mov    %ecx,%edx
  8010a6:	85 d2                	test   %edx,%edx
  8010a8:	75 9c                	jne    801046 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b4:	48                   	dec    %eax
  8010b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010bc:	74 3d                	je     8010fb <ltostr+0xe2>
		start = 1 ;
  8010be:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010c5:	eb 34                	jmp    8010fb <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cd:	01 d0                	add    %edx,%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	01 c2                	add    %eax,%edx
  8010dc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 c8                	add    %ecx,%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ee:	01 c2                	add    %eax,%edx
  8010f0:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010f3:	88 02                	mov    %al,(%edx)
		start++ ;
  8010f5:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010f8:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801101:	7c c4                	jl     8010c7 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801103:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	01 d0                	add    %edx,%eax
  80110b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80110e:	90                   	nop
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801117:	ff 75 08             	pushl  0x8(%ebp)
  80111a:	e8 54 fa ff ff       	call   800b73 <strlen>
  80111f:	83 c4 04             	add    $0x4,%esp
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	e8 46 fa ff ff       	call   800b73 <strlen>
  80112d:	83 c4 04             	add    $0x4,%esp
  801130:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80113a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801141:	eb 17                	jmp    80115a <strcconcat+0x49>
		final[s] = str1[s] ;
  801143:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801146:	8b 45 10             	mov    0x10(%ebp),%eax
  801149:	01 c2                	add    %eax,%edx
  80114b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	01 c8                	add    %ecx,%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801157:	ff 45 fc             	incl   -0x4(%ebp)
  80115a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801160:	7c e1                	jl     801143 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801162:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801169:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801170:	eb 1f                	jmp    801191 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801172:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801175:	8d 50 01             	lea    0x1(%eax),%edx
  801178:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 45 10             	mov    0x10(%ebp),%eax
  801180:	01 c2                	add    %eax,%edx
  801182:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801185:	8b 45 0c             	mov    0xc(%ebp),%eax
  801188:	01 c8                	add    %ecx,%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80118e:	ff 45 f8             	incl   -0x8(%ebp)
  801191:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801194:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801197:	7c d9                	jl     801172 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801199:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119c:	8b 45 10             	mov    0x10(%ebp),%eax
  80119f:	01 d0                	add    %edx,%eax
  8011a1:	c6 00 00             	movb   $0x0,(%eax)
}
  8011a4:	90                   	nop
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b6:	8b 00                	mov    (%eax),%eax
  8011b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ca:	eb 0c                	jmp    8011d8 <strsplit+0x31>
			*string++ = 0;
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	8d 50 01             	lea    0x1(%eax),%edx
  8011d2:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	84 c0                	test   %al,%al
  8011df:	74 18                	je     8011f9 <strsplit+0x52>
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f be c0             	movsbl %al,%eax
  8011e9:	50                   	push   %eax
  8011ea:	ff 75 0c             	pushl  0xc(%ebp)
  8011ed:	e8 13 fb ff ff       	call   800d05 <strchr>
  8011f2:	83 c4 08             	add    $0x8,%esp
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	75 d3                	jne    8011cc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	84 c0                	test   %al,%al
  801200:	74 5a                	je     80125c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801202:	8b 45 14             	mov    0x14(%ebp),%eax
  801205:	8b 00                	mov    (%eax),%eax
  801207:	83 f8 0f             	cmp    $0xf,%eax
  80120a:	75 07                	jne    801213 <strsplit+0x6c>
		{
			return 0;
  80120c:	b8 00 00 00 00       	mov    $0x0,%eax
  801211:	eb 66                	jmp    801279 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801213:	8b 45 14             	mov    0x14(%ebp),%eax
  801216:	8b 00                	mov    (%eax),%eax
  801218:	8d 48 01             	lea    0x1(%eax),%ecx
  80121b:	8b 55 14             	mov    0x14(%ebp),%edx
  80121e:	89 0a                	mov    %ecx,(%edx)
  801220:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801227:	8b 45 10             	mov    0x10(%ebp),%eax
  80122a:	01 c2                	add    %eax,%edx
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801231:	eb 03                	jmp    801236 <strsplit+0x8f>
			string++;
  801233:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	84 c0                	test   %al,%al
  80123d:	74 8b                	je     8011ca <strsplit+0x23>
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	0f be c0             	movsbl %al,%eax
  801247:	50                   	push   %eax
  801248:	ff 75 0c             	pushl  0xc(%ebp)
  80124b:	e8 b5 fa ff ff       	call   800d05 <strchr>
  801250:	83 c4 08             	add    $0x8,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	74 dc                	je     801233 <strsplit+0x8c>
			string++;
	}
  801257:	e9 6e ff ff ff       	jmp    8011ca <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80125c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80125d:	8b 45 14             	mov    0x14(%ebp),%eax
  801260:	8b 00                	mov    (%eax),%eax
  801262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801274:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
  80127e:	57                   	push   %edi
  80127f:	56                   	push   %esi
  801280:	53                   	push   %ebx
  801281:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80128d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801290:	8b 7d 18             	mov    0x18(%ebp),%edi
  801293:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801296:	cd 30                	int    $0x30
  801298:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80129b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	5b                   	pop    %ebx
  8012a2:	5e                   	pop    %esi
  8012a3:	5f                   	pop    %edi
  8012a4:	5d                   	pop    %ebp
  8012a5:	c3                   	ret    

008012a6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 04             	sub    $0x4,%esp
  8012ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8012af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8012b2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	52                   	push   %edx
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	6a 00                	push   $0x0
  8012c4:	e8 b2 ff ff ff       	call   80127b <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	90                   	nop
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	6a 00                	push   $0x0
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 01                	push   $0x1
  8012de:	e8 98 ff ff ff       	call   80127b <syscall>
  8012e3:	83 c4 18             	add    $0x18,%esp
}
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8012eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	52                   	push   %edx
  8012f8:	50                   	push   %eax
  8012f9:	6a 05                	push   $0x5
  8012fb:	e8 7b ff ff ff       	call   80127b <syscall>
  801300:	83 c4 18             	add    $0x18,%esp
}
  801303:	c9                   	leave  
  801304:	c3                   	ret    

00801305 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801305:	55                   	push   %ebp
  801306:	89 e5                	mov    %esp,%ebp
  801308:	56                   	push   %esi
  801309:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80130a:	8b 75 18             	mov    0x18(%ebp),%esi
  80130d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801313:	8b 55 0c             	mov    0xc(%ebp),%edx
  801316:	8b 45 08             	mov    0x8(%ebp),%eax
  801319:	56                   	push   %esi
  80131a:	53                   	push   %ebx
  80131b:	51                   	push   %ecx
  80131c:	52                   	push   %edx
  80131d:	50                   	push   %eax
  80131e:	6a 06                	push   $0x6
  801320:	e8 56 ff ff ff       	call   80127b <syscall>
  801325:	83 c4 18             	add    $0x18,%esp
}
  801328:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80132b:	5b                   	pop    %ebx
  80132c:	5e                   	pop    %esi
  80132d:	5d                   	pop    %ebp
  80132e:	c3                   	ret    

0080132f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	52                   	push   %edx
  80133f:	50                   	push   %eax
  801340:	6a 07                	push   $0x7
  801342:	e8 34 ff ff ff       	call   80127b <syscall>
  801347:	83 c4 18             	add    $0x18,%esp
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	ff 75 0c             	pushl  0xc(%ebp)
  801358:	ff 75 08             	pushl  0x8(%ebp)
  80135b:	6a 08                	push   $0x8
  80135d:	e8 19 ff ff ff       	call   80127b <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 00                	push   $0x0
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 09                	push   $0x9
  801376:	e8 00 ff ff ff       	call   80127b <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 0a                	push   $0xa
  80138f:	e8 e7 fe ff ff       	call   80127b <syscall>
  801394:	83 c4 18             	add    $0x18,%esp
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 0b                	push   $0xb
  8013a8:	e8 ce fe ff ff       	call   80127b <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	ff 75 0c             	pushl  0xc(%ebp)
  8013be:	ff 75 08             	pushl  0x8(%ebp)
  8013c1:	6a 0f                	push   $0xf
  8013c3:	e8 b3 fe ff ff       	call   80127b <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
	return;
  8013cb:	90                   	nop
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	ff 75 0c             	pushl  0xc(%ebp)
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	6a 10                	push   $0x10
  8013df:	e8 97 fe ff ff       	call   80127b <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8013e7:	90                   	nop
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	ff 75 10             	pushl  0x10(%ebp)
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	ff 75 08             	pushl  0x8(%ebp)
  8013fa:	6a 11                	push   $0x11
  8013fc:	e8 7a fe ff ff       	call   80127b <syscall>
  801401:	83 c4 18             	add    $0x18,%esp
	return ;
  801404:	90                   	nop
}
  801405:	c9                   	leave  
  801406:	c3                   	ret    

00801407 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 0c                	push   $0xc
  801416:	e8 60 fe ff ff       	call   80127b <syscall>
  80141b:	83 c4 18             	add    $0x18,%esp
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	ff 75 08             	pushl  0x8(%ebp)
  80142e:	6a 0d                	push   $0xd
  801430:	e8 46 fe ff ff       	call   80127b <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 0e                	push   $0xe
  801449:	e8 2d fe ff ff       	call   80127b <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	90                   	nop
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 13                	push   $0x13
  801463:	e8 13 fe ff ff       	call   80127b <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	90                   	nop
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 14                	push   $0x14
  80147d:	e8 f9 fd ff ff       	call   80127b <syscall>
  801482:	83 c4 18             	add    $0x18,%esp
}
  801485:	90                   	nop
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <sys_cputc>:


void
sys_cputc(const char c)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801494:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	50                   	push   %eax
  8014a1:	6a 15                	push   $0x15
  8014a3:	e8 d3 fd ff ff       	call   80127b <syscall>
  8014a8:	83 c4 18             	add    $0x18,%esp
}
  8014ab:	90                   	nop
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 00                	push   $0x0
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 16                	push   $0x16
  8014bd:	e8 b9 fd ff ff       	call   80127b <syscall>
  8014c2:	83 c4 18             	add    $0x18,%esp
}
  8014c5:	90                   	nop
  8014c6:	c9                   	leave  
  8014c7:	c3                   	ret    

008014c8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8014cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	50                   	push   %eax
  8014d8:	6a 17                	push   $0x17
  8014da:	e8 9c fd ff ff       	call   80127b <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8014e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	52                   	push   %edx
  8014f4:	50                   	push   %eax
  8014f5:	6a 1a                	push   $0x1a
  8014f7:	e8 7f fd ff ff       	call   80127b <syscall>
  8014fc:	83 c4 18             	add    $0x18,%esp
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	52                   	push   %edx
  801511:	50                   	push   %eax
  801512:	6a 18                	push   $0x18
  801514:	e8 62 fd ff ff       	call   80127b <syscall>
  801519:	83 c4 18             	add    $0x18,%esp
}
  80151c:	90                   	nop
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801522:	8b 55 0c             	mov    0xc(%ebp),%edx
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	52                   	push   %edx
  80152f:	50                   	push   %eax
  801530:	6a 19                	push   $0x19
  801532:	e8 44 fd ff ff       	call   80127b <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
}
  80153a:	90                   	nop
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	83 ec 04             	sub    $0x4,%esp
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801549:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80154c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801550:	8b 45 08             	mov    0x8(%ebp),%eax
  801553:	6a 00                	push   $0x0
  801555:	51                   	push   %ecx
  801556:	52                   	push   %edx
  801557:	ff 75 0c             	pushl  0xc(%ebp)
  80155a:	50                   	push   %eax
  80155b:	6a 1b                	push   $0x1b
  80155d:	e8 19 fd ff ff       	call   80127b <syscall>
  801562:	83 c4 18             	add    $0x18,%esp
}
  801565:	c9                   	leave  
  801566:	c3                   	ret    

00801567 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801567:	55                   	push   %ebp
  801568:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80156a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156d:	8b 45 08             	mov    0x8(%ebp),%eax
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	52                   	push   %edx
  801577:	50                   	push   %eax
  801578:	6a 1c                	push   $0x1c
  80157a:	e8 fc fc ff ff       	call   80127b <syscall>
  80157f:	83 c4 18             	add    $0x18,%esp
}
  801582:	c9                   	leave  
  801583:	c3                   	ret    

00801584 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801587:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80158a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	51                   	push   %ecx
  801595:	52                   	push   %edx
  801596:	50                   	push   %eax
  801597:	6a 1d                	push   $0x1d
  801599:	e8 dd fc ff ff       	call   80127b <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	52                   	push   %edx
  8015b3:	50                   	push   %eax
  8015b4:	6a 1e                	push   $0x1e
  8015b6:	e8 c0 fc ff ff       	call   80127b <syscall>
  8015bb:	83 c4 18             	add    $0x18,%esp
}
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 1f                	push   $0x1f
  8015cf:	e8 a7 fc ff ff       	call   80127b <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	6a 00                	push   $0x0
  8015e1:	ff 75 14             	pushl  0x14(%ebp)
  8015e4:	ff 75 10             	pushl  0x10(%ebp)
  8015e7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ea:	50                   	push   %eax
  8015eb:	6a 20                	push   $0x20
  8015ed:	e8 89 fc ff ff       	call   80127b <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	50                   	push   %eax
  801606:	6a 21                	push   $0x21
  801608:	e8 6e fc ff ff       	call   80127b <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	90                   	nop
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	50                   	push   %eax
  801622:	6a 22                	push   $0x22
  801624:	e8 52 fc ff ff       	call   80127b <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 02                	push   $0x2
  80163d:	e8 39 fc ff ff       	call   80127b <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 03                	push   $0x3
  801656:	e8 20 fc ff ff       	call   80127b <syscall>
  80165b:	83 c4 18             	add    $0x18,%esp
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 04                	push   $0x4
  80166f:	e8 07 fc ff ff       	call   80127b <syscall>
  801674:	83 c4 18             	add    $0x18,%esp
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_exit_env>:


void sys_exit_env(void)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 23                	push   $0x23
  801688:	e8 ee fb ff ff       	call   80127b <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801699:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80169c:	8d 50 04             	lea    0x4(%eax),%edx
  80169f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	52                   	push   %edx
  8016a9:	50                   	push   %eax
  8016aa:	6a 24                	push   $0x24
  8016ac:	e8 ca fb ff ff       	call   80127b <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
	return result;
  8016b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016bd:	89 01                	mov    %eax,(%ecx)
  8016bf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	c9                   	leave  
  8016c6:	c2 04 00             	ret    $0x4

008016c9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	ff 75 10             	pushl  0x10(%ebp)
  8016d3:	ff 75 0c             	pushl  0xc(%ebp)
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	6a 12                	push   $0x12
  8016db:	e8 9b fb ff ff       	call   80127b <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e3:	90                   	nop
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 25                	push   $0x25
  8016f5:	e8 81 fb ff ff       	call   80127b <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80170b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	50                   	push   %eax
  801718:	6a 26                	push   $0x26
  80171a:	e8 5c fb ff ff       	call   80127b <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
	return ;
  801722:	90                   	nop
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <rsttst>:
void rsttst()
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 28                	push   $0x28
  801734:	e8 42 fb ff ff       	call   80127b <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
	return ;
  80173c:	90                   	nop
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	8b 45 14             	mov    0x14(%ebp),%eax
  801748:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80174b:	8b 55 18             	mov    0x18(%ebp),%edx
  80174e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801752:	52                   	push   %edx
  801753:	50                   	push   %eax
  801754:	ff 75 10             	pushl  0x10(%ebp)
  801757:	ff 75 0c             	pushl  0xc(%ebp)
  80175a:	ff 75 08             	pushl  0x8(%ebp)
  80175d:	6a 27                	push   $0x27
  80175f:	e8 17 fb ff ff       	call   80127b <syscall>
  801764:	83 c4 18             	add    $0x18,%esp
	return ;
  801767:	90                   	nop
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <chktst>:
void chktst(uint32 n)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	ff 75 08             	pushl  0x8(%ebp)
  801778:	6a 29                	push   $0x29
  80177a:	e8 fc fa ff ff       	call   80127b <syscall>
  80177f:	83 c4 18             	add    $0x18,%esp
	return ;
  801782:	90                   	nop
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <inctst>:

void inctst()
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 2a                	push   $0x2a
  801794:	e8 e2 fa ff ff       	call   80127b <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
	return ;
  80179c:	90                   	nop
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <gettst>:
uint32 gettst()
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 2b                	push   $0x2b
  8017ae:	e8 c8 fa ff ff       	call   80127b <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 2c                	push   $0x2c
  8017ca:	e8 ac fa ff ff       	call   80127b <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
  8017d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017d5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017d9:	75 07                	jne    8017e2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017db:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e0:	eb 05                	jmp    8017e7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 2c                	push   $0x2c
  8017fb:	e8 7b fa ff ff       	call   80127b <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
  801803:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801806:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80180a:	75 07                	jne    801813 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80180c:	b8 01 00 00 00       	mov    $0x1,%eax
  801811:	eb 05                	jmp    801818 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 2c                	push   $0x2c
  80182c:	e8 4a fa ff ff       	call   80127b <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
  801834:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801837:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80183b:	75 07                	jne    801844 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80183d:	b8 01 00 00 00       	mov    $0x1,%eax
  801842:	eb 05                	jmp    801849 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 2c                	push   $0x2c
  80185d:	e8 19 fa ff ff       	call   80127b <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
  801865:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801868:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80186c:	75 07                	jne    801875 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80186e:	b8 01 00 00 00       	mov    $0x1,%eax
  801873:	eb 05                	jmp    80187a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	6a 2d                	push   $0x2d
  80188c:	e8 ea f9 ff ff       	call   80127b <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
	return ;
  801894:	90                   	nop
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80189b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80189e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	53                   	push   %ebx
  8018aa:	51                   	push   %ecx
  8018ab:	52                   	push   %edx
  8018ac:	50                   	push   %eax
  8018ad:	6a 2e                	push   $0x2e
  8018af:	e8 c7 f9 ff ff       	call   80127b <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8018bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	52                   	push   %edx
  8018cc:	50                   	push   %eax
  8018cd:	6a 2f                	push   $0x2f
  8018cf:	e8 a7 f9 ff ff       	call   80127b <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018df:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e2:	89 d0                	mov    %edx,%eax
  8018e4:	c1 e0 02             	shl    $0x2,%eax
  8018e7:	01 d0                	add    %edx,%eax
  8018e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f0:	01 d0                	add    %edx,%eax
  8018f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801902:	01 d0                	add    %edx,%eax
  801904:	c1 e0 04             	shl    $0x4,%eax
  801907:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80190a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801911:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801914:	83 ec 0c             	sub    $0xc,%esp
  801917:	50                   	push   %eax
  801918:	e8 76 fd ff ff       	call   801693 <sys_get_virtual_time>
  80191d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801920:	eb 41                	jmp    801963 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801922:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801925:	83 ec 0c             	sub    $0xc,%esp
  801928:	50                   	push   %eax
  801929:	e8 65 fd ff ff       	call   801693 <sys_get_virtual_time>
  80192e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801931:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801934:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80193e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801944:	89 d1                	mov    %edx,%ecx
  801946:	29 c1                	sub    %eax,%ecx
  801948:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80194b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80194e:	39 c2                	cmp    %eax,%edx
  801950:	0f 97 c0             	seta   %al
  801953:	0f b6 c0             	movzbl %al,%eax
  801956:	29 c1                	sub    %eax,%ecx
  801958:	89 c8                	mov    %ecx,%eax
  80195a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80195d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801960:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801966:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801969:	72 b7                	jb     801922 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80197b:	eb 03                	jmp    801980 <busy_wait+0x12>
  80197d:	ff 45 fc             	incl   -0x4(%ebp)
  801980:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801983:	3b 45 08             	cmp    0x8(%ebp),%eax
  801986:	72 f5                	jb     80197d <busy_wait+0xf>
	return i;
  801988:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801999:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80199d:	83 ec 0c             	sub    $0xc,%esp
  8019a0:	50                   	push   %eax
  8019a1:	e8 e2 fa ff ff       	call   801488 <sys_cputc>
  8019a6:	83 c4 10             	add    $0x10,%esp
}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019b2:	e8 9d fa ff ff       	call   801454 <sys_disable_interrupt>
	char c = ch;
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019bd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019c1:	83 ec 0c             	sub    $0xc,%esp
  8019c4:	50                   	push   %eax
  8019c5:	e8 be fa ff ff       	call   801488 <sys_cputc>
  8019ca:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8019cd:	e8 9c fa ff ff       	call   80146e <sys_enable_interrupt>
}
  8019d2:	90                   	nop
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <getchar>:

int
getchar(void)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8019db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8019e2:	eb 08                	jmp    8019ec <getchar+0x17>
	{
		c = sys_cgetc();
  8019e4:	e8 e6 f8 ff ff       	call   8012cf <sys_cgetc>
  8019e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8019ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019f0:	74 f2                	je     8019e4 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <atomic_getchar>:

int
atomic_getchar(void)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8019fd:	e8 52 fa ff ff       	call   801454 <sys_disable_interrupt>
	int c=0;
  801a02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801a09:	eb 08                	jmp    801a13 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801a0b:	e8 bf f8 ff ff       	call   8012cf <sys_cgetc>
  801a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a17:	74 f2                	je     801a0b <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801a19:	e8 50 fa ff ff       	call   80146e <sys_enable_interrupt>
	return c;
  801a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <iscons>:

int iscons(int fdnum)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a26:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    
  801a2d:	66 90                	xchg   %ax,%ax
  801a2f:	90                   	nop

00801a30 <__udivdi3>:
  801a30:	55                   	push   %ebp
  801a31:	57                   	push   %edi
  801a32:	56                   	push   %esi
  801a33:	53                   	push   %ebx
  801a34:	83 ec 1c             	sub    $0x1c,%esp
  801a37:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801a3b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801a3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a43:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a47:	89 ca                	mov    %ecx,%edx
  801a49:	89 f8                	mov    %edi,%eax
  801a4b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801a4f:	85 f6                	test   %esi,%esi
  801a51:	75 2d                	jne    801a80 <__udivdi3+0x50>
  801a53:	39 cf                	cmp    %ecx,%edi
  801a55:	77 65                	ja     801abc <__udivdi3+0x8c>
  801a57:	89 fd                	mov    %edi,%ebp
  801a59:	85 ff                	test   %edi,%edi
  801a5b:	75 0b                	jne    801a68 <__udivdi3+0x38>
  801a5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a62:	31 d2                	xor    %edx,%edx
  801a64:	f7 f7                	div    %edi
  801a66:	89 c5                	mov    %eax,%ebp
  801a68:	31 d2                	xor    %edx,%edx
  801a6a:	89 c8                	mov    %ecx,%eax
  801a6c:	f7 f5                	div    %ebp
  801a6e:	89 c1                	mov    %eax,%ecx
  801a70:	89 d8                	mov    %ebx,%eax
  801a72:	f7 f5                	div    %ebp
  801a74:	89 cf                	mov    %ecx,%edi
  801a76:	89 fa                	mov    %edi,%edx
  801a78:	83 c4 1c             	add    $0x1c,%esp
  801a7b:	5b                   	pop    %ebx
  801a7c:	5e                   	pop    %esi
  801a7d:	5f                   	pop    %edi
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    
  801a80:	39 ce                	cmp    %ecx,%esi
  801a82:	77 28                	ja     801aac <__udivdi3+0x7c>
  801a84:	0f bd fe             	bsr    %esi,%edi
  801a87:	83 f7 1f             	xor    $0x1f,%edi
  801a8a:	75 40                	jne    801acc <__udivdi3+0x9c>
  801a8c:	39 ce                	cmp    %ecx,%esi
  801a8e:	72 0a                	jb     801a9a <__udivdi3+0x6a>
  801a90:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a94:	0f 87 9e 00 00 00    	ja     801b38 <__udivdi3+0x108>
  801a9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9f:	89 fa                	mov    %edi,%edx
  801aa1:	83 c4 1c             	add    $0x1c,%esp
  801aa4:	5b                   	pop    %ebx
  801aa5:	5e                   	pop    %esi
  801aa6:	5f                   	pop    %edi
  801aa7:	5d                   	pop    %ebp
  801aa8:	c3                   	ret    
  801aa9:	8d 76 00             	lea    0x0(%esi),%esi
  801aac:	31 ff                	xor    %edi,%edi
  801aae:	31 c0                	xor    %eax,%eax
  801ab0:	89 fa                	mov    %edi,%edx
  801ab2:	83 c4 1c             	add    $0x1c,%esp
  801ab5:	5b                   	pop    %ebx
  801ab6:	5e                   	pop    %esi
  801ab7:	5f                   	pop    %edi
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	89 d8                	mov    %ebx,%eax
  801abe:	f7 f7                	div    %edi
  801ac0:	31 ff                	xor    %edi,%edi
  801ac2:	89 fa                	mov    %edi,%edx
  801ac4:	83 c4 1c             	add    $0x1c,%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5f                   	pop    %edi
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    
  801acc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ad1:	89 eb                	mov    %ebp,%ebx
  801ad3:	29 fb                	sub    %edi,%ebx
  801ad5:	89 f9                	mov    %edi,%ecx
  801ad7:	d3 e6                	shl    %cl,%esi
  801ad9:	89 c5                	mov    %eax,%ebp
  801adb:	88 d9                	mov    %bl,%cl
  801add:	d3 ed                	shr    %cl,%ebp
  801adf:	89 e9                	mov    %ebp,%ecx
  801ae1:	09 f1                	or     %esi,%ecx
  801ae3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801ae7:	89 f9                	mov    %edi,%ecx
  801ae9:	d3 e0                	shl    %cl,%eax
  801aeb:	89 c5                	mov    %eax,%ebp
  801aed:	89 d6                	mov    %edx,%esi
  801aef:	88 d9                	mov    %bl,%cl
  801af1:	d3 ee                	shr    %cl,%esi
  801af3:	89 f9                	mov    %edi,%ecx
  801af5:	d3 e2                	shl    %cl,%edx
  801af7:	8b 44 24 08          	mov    0x8(%esp),%eax
  801afb:	88 d9                	mov    %bl,%cl
  801afd:	d3 e8                	shr    %cl,%eax
  801aff:	09 c2                	or     %eax,%edx
  801b01:	89 d0                	mov    %edx,%eax
  801b03:	89 f2                	mov    %esi,%edx
  801b05:	f7 74 24 0c          	divl   0xc(%esp)
  801b09:	89 d6                	mov    %edx,%esi
  801b0b:	89 c3                	mov    %eax,%ebx
  801b0d:	f7 e5                	mul    %ebp
  801b0f:	39 d6                	cmp    %edx,%esi
  801b11:	72 19                	jb     801b2c <__udivdi3+0xfc>
  801b13:	74 0b                	je     801b20 <__udivdi3+0xf0>
  801b15:	89 d8                	mov    %ebx,%eax
  801b17:	31 ff                	xor    %edi,%edi
  801b19:	e9 58 ff ff ff       	jmp    801a76 <__udivdi3+0x46>
  801b1e:	66 90                	xchg   %ax,%ax
  801b20:	8b 54 24 08          	mov    0x8(%esp),%edx
  801b24:	89 f9                	mov    %edi,%ecx
  801b26:	d3 e2                	shl    %cl,%edx
  801b28:	39 c2                	cmp    %eax,%edx
  801b2a:	73 e9                	jae    801b15 <__udivdi3+0xe5>
  801b2c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801b2f:	31 ff                	xor    %edi,%edi
  801b31:	e9 40 ff ff ff       	jmp    801a76 <__udivdi3+0x46>
  801b36:	66 90                	xchg   %ax,%ax
  801b38:	31 c0                	xor    %eax,%eax
  801b3a:	e9 37 ff ff ff       	jmp    801a76 <__udivdi3+0x46>
  801b3f:	90                   	nop

00801b40 <__umoddi3>:
  801b40:	55                   	push   %ebp
  801b41:	57                   	push   %edi
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	83 ec 1c             	sub    $0x1c,%esp
  801b47:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801b4b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801b4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b53:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801b57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b5f:	89 f3                	mov    %esi,%ebx
  801b61:	89 fa                	mov    %edi,%edx
  801b63:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b67:	89 34 24             	mov    %esi,(%esp)
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	75 1a                	jne    801b88 <__umoddi3+0x48>
  801b6e:	39 f7                	cmp    %esi,%edi
  801b70:	0f 86 a2 00 00 00    	jbe    801c18 <__umoddi3+0xd8>
  801b76:	89 c8                	mov    %ecx,%eax
  801b78:	89 f2                	mov    %esi,%edx
  801b7a:	f7 f7                	div    %edi
  801b7c:	89 d0                	mov    %edx,%eax
  801b7e:	31 d2                	xor    %edx,%edx
  801b80:	83 c4 1c             	add    $0x1c,%esp
  801b83:	5b                   	pop    %ebx
  801b84:	5e                   	pop    %esi
  801b85:	5f                   	pop    %edi
  801b86:	5d                   	pop    %ebp
  801b87:	c3                   	ret    
  801b88:	39 f0                	cmp    %esi,%eax
  801b8a:	0f 87 ac 00 00 00    	ja     801c3c <__umoddi3+0xfc>
  801b90:	0f bd e8             	bsr    %eax,%ebp
  801b93:	83 f5 1f             	xor    $0x1f,%ebp
  801b96:	0f 84 ac 00 00 00    	je     801c48 <__umoddi3+0x108>
  801b9c:	bf 20 00 00 00       	mov    $0x20,%edi
  801ba1:	29 ef                	sub    %ebp,%edi
  801ba3:	89 fe                	mov    %edi,%esi
  801ba5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ba9:	89 e9                	mov    %ebp,%ecx
  801bab:	d3 e0                	shl    %cl,%eax
  801bad:	89 d7                	mov    %edx,%edi
  801baf:	89 f1                	mov    %esi,%ecx
  801bb1:	d3 ef                	shr    %cl,%edi
  801bb3:	09 c7                	or     %eax,%edi
  801bb5:	89 e9                	mov    %ebp,%ecx
  801bb7:	d3 e2                	shl    %cl,%edx
  801bb9:	89 14 24             	mov    %edx,(%esp)
  801bbc:	89 d8                	mov    %ebx,%eax
  801bbe:	d3 e0                	shl    %cl,%eax
  801bc0:	89 c2                	mov    %eax,%edx
  801bc2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bc6:	d3 e0                	shl    %cl,%eax
  801bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bd0:	89 f1                	mov    %esi,%ecx
  801bd2:	d3 e8                	shr    %cl,%eax
  801bd4:	09 d0                	or     %edx,%eax
  801bd6:	d3 eb                	shr    %cl,%ebx
  801bd8:	89 da                	mov    %ebx,%edx
  801bda:	f7 f7                	div    %edi
  801bdc:	89 d3                	mov    %edx,%ebx
  801bde:	f7 24 24             	mull   (%esp)
  801be1:	89 c6                	mov    %eax,%esi
  801be3:	89 d1                	mov    %edx,%ecx
  801be5:	39 d3                	cmp    %edx,%ebx
  801be7:	0f 82 87 00 00 00    	jb     801c74 <__umoddi3+0x134>
  801bed:	0f 84 91 00 00 00    	je     801c84 <__umoddi3+0x144>
  801bf3:	8b 54 24 04          	mov    0x4(%esp),%edx
  801bf7:	29 f2                	sub    %esi,%edx
  801bf9:	19 cb                	sbb    %ecx,%ebx
  801bfb:	89 d8                	mov    %ebx,%eax
  801bfd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801c01:	d3 e0                	shl    %cl,%eax
  801c03:	89 e9                	mov    %ebp,%ecx
  801c05:	d3 ea                	shr    %cl,%edx
  801c07:	09 d0                	or     %edx,%eax
  801c09:	89 e9                	mov    %ebp,%ecx
  801c0b:	d3 eb                	shr    %cl,%ebx
  801c0d:	89 da                	mov    %ebx,%edx
  801c0f:	83 c4 1c             	add    $0x1c,%esp
  801c12:	5b                   	pop    %ebx
  801c13:	5e                   	pop    %esi
  801c14:	5f                   	pop    %edi
  801c15:	5d                   	pop    %ebp
  801c16:	c3                   	ret    
  801c17:	90                   	nop
  801c18:	89 fd                	mov    %edi,%ebp
  801c1a:	85 ff                	test   %edi,%edi
  801c1c:	75 0b                	jne    801c29 <__umoddi3+0xe9>
  801c1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c23:	31 d2                	xor    %edx,%edx
  801c25:	f7 f7                	div    %edi
  801c27:	89 c5                	mov    %eax,%ebp
  801c29:	89 f0                	mov    %esi,%eax
  801c2b:	31 d2                	xor    %edx,%edx
  801c2d:	f7 f5                	div    %ebp
  801c2f:	89 c8                	mov    %ecx,%eax
  801c31:	f7 f5                	div    %ebp
  801c33:	89 d0                	mov    %edx,%eax
  801c35:	e9 44 ff ff ff       	jmp    801b7e <__umoddi3+0x3e>
  801c3a:	66 90                	xchg   %ax,%ax
  801c3c:	89 c8                	mov    %ecx,%eax
  801c3e:	89 f2                	mov    %esi,%edx
  801c40:	83 c4 1c             	add    $0x1c,%esp
  801c43:	5b                   	pop    %ebx
  801c44:	5e                   	pop    %esi
  801c45:	5f                   	pop    %edi
  801c46:	5d                   	pop    %ebp
  801c47:	c3                   	ret    
  801c48:	3b 04 24             	cmp    (%esp),%eax
  801c4b:	72 06                	jb     801c53 <__umoddi3+0x113>
  801c4d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801c51:	77 0f                	ja     801c62 <__umoddi3+0x122>
  801c53:	89 f2                	mov    %esi,%edx
  801c55:	29 f9                	sub    %edi,%ecx
  801c57:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801c5b:	89 14 24             	mov    %edx,(%esp)
  801c5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c62:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c66:	8b 14 24             	mov    (%esp),%edx
  801c69:	83 c4 1c             	add    $0x1c,%esp
  801c6c:	5b                   	pop    %ebx
  801c6d:	5e                   	pop    %esi
  801c6e:	5f                   	pop    %edi
  801c6f:	5d                   	pop    %ebp
  801c70:	c3                   	ret    
  801c71:	8d 76 00             	lea    0x0(%esi),%esi
  801c74:	2b 04 24             	sub    (%esp),%eax
  801c77:	19 fa                	sbb    %edi,%edx
  801c79:	89 d1                	mov    %edx,%ecx
  801c7b:	89 c6                	mov    %eax,%esi
  801c7d:	e9 71 ff ff ff       	jmp    801bf3 <__umoddi3+0xb3>
  801c82:	66 90                	xchg   %ax,%ax
  801c84:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c88:	72 ea                	jb     801c74 <__umoddi3+0x134>
  801c8a:	89 d9                	mov    %ebx,%ecx
  801c8c:	e9 62 ff ff ff       	jmp    801bf3 <__umoddi3+0xb3>
