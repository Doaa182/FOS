
obj/user/ef_fos_factorial:     file format elf32-i386


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
  800031:	e8 6c 00 00 00       	call   8000a2 <libmain>
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
	//atomic_readline("Please enter a number:", buff1);
	i1 = 10;
  800048:	c7 45 f4 0a 00 00 00 	movl   $0xa,-0xc(%ebp)

	int res = factorial(i1) ;
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	ff 75 f4             	pushl  -0xc(%ebp)
  800055:	e8 1f 00 00 00       	call   800079 <factorial>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("Factorial %d = %d\n",i1, res);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	ff 75 f0             	pushl  -0x10(%ebp)
  800066:	ff 75 f4             	pushl  -0xc(%ebp)
  800069:	68 00 19 80 00       	push   $0x801900
  80006e:	e8 6c 02 00 00       	call   8002df <atomic_cprintf>
  800073:	83 c4 10             	add    $0x10,%esp

	return;
  800076:	90                   	nop
}
  800077:	c9                   	leave  
  800078:	c3                   	ret    

00800079 <factorial>:


int factorial(int n)
{
  800079:	55                   	push   %ebp
  80007a:	89 e5                	mov    %esp,%ebp
  80007c:	83 ec 08             	sub    $0x8,%esp
	if (n <= 1)
  80007f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800083:	7f 07                	jg     80008c <factorial+0x13>
		return 1 ;
  800085:	b8 01 00 00 00       	mov    $0x1,%eax
  80008a:	eb 14                	jmp    8000a0 <factorial+0x27>
	return n * factorial(n-1) ;
  80008c:	8b 45 08             	mov    0x8(%ebp),%eax
  80008f:	48                   	dec    %eax
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	50                   	push   %eax
  800094:	e8 e0 ff ff ff       	call   800079 <factorial>
  800099:	83 c4 10             	add    $0x10,%esp
  80009c:	0f af 45 08          	imul   0x8(%ebp),%eax
}
  8000a0:	c9                   	leave  
  8000a1:	c3                   	ret    

008000a2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000a8:	e8 5b 13 00 00       	call   801408 <sys_getenvindex>
  8000ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000b3:	89 d0                	mov    %edx,%eax
  8000b5:	c1 e0 03             	shl    $0x3,%eax
  8000b8:	01 d0                	add    %edx,%eax
  8000ba:	01 c0                	add    %eax,%eax
  8000bc:	01 d0                	add    %edx,%eax
  8000be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	c1 e0 04             	shl    $0x4,%eax
  8000ca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000cf:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000d4:	a1 20 20 80 00       	mov    0x802020,%eax
  8000d9:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8000df:	84 c0                	test   %al,%al
  8000e1:	74 0f                	je     8000f2 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8000e3:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e8:	05 5c 05 00 00       	add    $0x55c,%eax
  8000ed:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f6:	7e 0a                	jle    800102 <libmain+0x60>
		binaryname = argv[0];
  8000f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fb:	8b 00                	mov    (%eax),%eax
  8000fd:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800102:	83 ec 08             	sub    $0x8,%esp
  800105:	ff 75 0c             	pushl  0xc(%ebp)
  800108:	ff 75 08             	pushl  0x8(%ebp)
  80010b:	e8 28 ff ff ff       	call   800038 <_main>
  800110:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800113:	e8 fd 10 00 00       	call   801215 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800118:	83 ec 0c             	sub    $0xc,%esp
  80011b:	68 2c 19 80 00       	push   $0x80192c
  800120:	e8 8d 01 00 00       	call   8002b2 <cprintf>
  800125:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800128:	a1 20 20 80 00       	mov    0x802020,%eax
  80012d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800133:	a1 20 20 80 00       	mov    0x802020,%eax
  800138:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	52                   	push   %edx
  800142:	50                   	push   %eax
  800143:	68 54 19 80 00       	push   $0x801954
  800148:	e8 65 01 00 00       	call   8002b2 <cprintf>
  80014d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800150:	a1 20 20 80 00       	mov    0x802020,%eax
  800155:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80015b:	a1 20 20 80 00       	mov    0x802020,%eax
  800160:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800166:	a1 20 20 80 00       	mov    0x802020,%eax
  80016b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800171:	51                   	push   %ecx
  800172:	52                   	push   %edx
  800173:	50                   	push   %eax
  800174:	68 7c 19 80 00       	push   $0x80197c
  800179:	e8 34 01 00 00       	call   8002b2 <cprintf>
  80017e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800181:	a1 20 20 80 00       	mov    0x802020,%eax
  800186:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80018c:	83 ec 08             	sub    $0x8,%esp
  80018f:	50                   	push   %eax
  800190:	68 d4 19 80 00       	push   $0x8019d4
  800195:	e8 18 01 00 00       	call   8002b2 <cprintf>
  80019a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80019d:	83 ec 0c             	sub    $0xc,%esp
  8001a0:	68 2c 19 80 00       	push   $0x80192c
  8001a5:	e8 08 01 00 00       	call   8002b2 <cprintf>
  8001aa:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ad:	e8 7d 10 00 00       	call   80122f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001b2:	e8 19 00 00 00       	call   8001d0 <exit>
}
  8001b7:	90                   	nop
  8001b8:	c9                   	leave  
  8001b9:	c3                   	ret    

008001ba <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001ba:	55                   	push   %ebp
  8001bb:	89 e5                	mov    %esp,%ebp
  8001bd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001c0:	83 ec 0c             	sub    $0xc,%esp
  8001c3:	6a 00                	push   $0x0
  8001c5:	e8 0a 12 00 00       	call   8013d4 <sys_destroy_env>
  8001ca:	83 c4 10             	add    $0x10,%esp
}
  8001cd:	90                   	nop
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <exit>:

void
exit(void)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001d6:	e8 5f 12 00 00       	call   80143a <sys_exit_env>
}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e7:	8b 00                	mov    (%eax),%eax
  8001e9:	8d 48 01             	lea    0x1(%eax),%ecx
  8001ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ef:	89 0a                	mov    %ecx,(%edx)
  8001f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f4:	88 d1                	mov    %dl,%cl
  8001f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800200:	8b 00                	mov    (%eax),%eax
  800202:	3d ff 00 00 00       	cmp    $0xff,%eax
  800207:	75 2c                	jne    800235 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800209:	a0 24 20 80 00       	mov    0x802024,%al
  80020e:	0f b6 c0             	movzbl %al,%eax
  800211:	8b 55 0c             	mov    0xc(%ebp),%edx
  800214:	8b 12                	mov    (%edx),%edx
  800216:	89 d1                	mov    %edx,%ecx
  800218:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021b:	83 c2 08             	add    $0x8,%edx
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	50                   	push   %eax
  800222:	51                   	push   %ecx
  800223:	52                   	push   %edx
  800224:	e8 3e 0e 00 00       	call   801067 <sys_cputs>
  800229:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80022c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800235:	8b 45 0c             	mov    0xc(%ebp),%eax
  800238:	8b 40 04             	mov    0x4(%eax),%eax
  80023b:	8d 50 01             	lea    0x1(%eax),%edx
  80023e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800241:	89 50 04             	mov    %edx,0x4(%eax)
}
  800244:	90                   	nop
  800245:	c9                   	leave  
  800246:	c3                   	ret    

00800247 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800247:	55                   	push   %ebp
  800248:	89 e5                	mov    %esp,%ebp
  80024a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800250:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800257:	00 00 00 
	b.cnt = 0;
  80025a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800261:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800270:	50                   	push   %eax
  800271:	68 de 01 80 00       	push   $0x8001de
  800276:	e8 11 02 00 00       	call   80048c <vprintfmt>
  80027b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80027e:	a0 24 20 80 00       	mov    0x802024,%al
  800283:	0f b6 c0             	movzbl %al,%eax
  800286:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	50                   	push   %eax
  800290:	52                   	push   %edx
  800291:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800297:	83 c0 08             	add    $0x8,%eax
  80029a:	50                   	push   %eax
  80029b:	e8 c7 0d 00 00       	call   801067 <sys_cputs>
  8002a0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002a3:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002aa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002b8:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002bf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c8:	83 ec 08             	sub    $0x8,%esp
  8002cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ce:	50                   	push   %eax
  8002cf:	e8 73 ff ff ff       	call   800247 <vcprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
  8002d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002dd:	c9                   	leave  
  8002de:	c3                   	ret    

008002df <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8002e5:	e8 2b 0f 00 00       	call   801215 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f3:	83 ec 08             	sub    $0x8,%esp
  8002f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f9:	50                   	push   %eax
  8002fa:	e8 48 ff ff ff       	call   800247 <vcprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
  800302:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800305:	e8 25 0f 00 00       	call   80122f <sys_enable_interrupt>
	return cnt;
  80030a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80030d:	c9                   	leave  
  80030e:	c3                   	ret    

0080030f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	53                   	push   %ebx
  800313:	83 ec 14             	sub    $0x14,%esp
  800316:	8b 45 10             	mov    0x10(%ebp),%eax
  800319:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80031c:	8b 45 14             	mov    0x14(%ebp),%eax
  80031f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800322:	8b 45 18             	mov    0x18(%ebp),%eax
  800325:	ba 00 00 00 00       	mov    $0x0,%edx
  80032a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80032d:	77 55                	ja     800384 <printnum+0x75>
  80032f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800332:	72 05                	jb     800339 <printnum+0x2a>
  800334:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800337:	77 4b                	ja     800384 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800339:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80033c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80033f:	8b 45 18             	mov    0x18(%ebp),%eax
  800342:	ba 00 00 00 00       	mov    $0x0,%edx
  800347:	52                   	push   %edx
  800348:	50                   	push   %eax
  800349:	ff 75 f4             	pushl  -0xc(%ebp)
  80034c:	ff 75 f0             	pushl  -0x10(%ebp)
  80034f:	e8 48 13 00 00       	call   80169c <__udivdi3>
  800354:	83 c4 10             	add    $0x10,%esp
  800357:	83 ec 04             	sub    $0x4,%esp
  80035a:	ff 75 20             	pushl  0x20(%ebp)
  80035d:	53                   	push   %ebx
  80035e:	ff 75 18             	pushl  0x18(%ebp)
  800361:	52                   	push   %edx
  800362:	50                   	push   %eax
  800363:	ff 75 0c             	pushl  0xc(%ebp)
  800366:	ff 75 08             	pushl  0x8(%ebp)
  800369:	e8 a1 ff ff ff       	call   80030f <printnum>
  80036e:	83 c4 20             	add    $0x20,%esp
  800371:	eb 1a                	jmp    80038d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800373:	83 ec 08             	sub    $0x8,%esp
  800376:	ff 75 0c             	pushl  0xc(%ebp)
  800379:	ff 75 20             	pushl  0x20(%ebp)
  80037c:	8b 45 08             	mov    0x8(%ebp),%eax
  80037f:	ff d0                	call   *%eax
  800381:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800384:	ff 4d 1c             	decl   0x1c(%ebp)
  800387:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80038b:	7f e6                	jg     800373 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800390:	bb 00 00 00 00       	mov    $0x0,%ebx
  800395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800398:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80039b:	53                   	push   %ebx
  80039c:	51                   	push   %ecx
  80039d:	52                   	push   %edx
  80039e:	50                   	push   %eax
  80039f:	e8 08 14 00 00       	call   8017ac <__umoddi3>
  8003a4:	83 c4 10             	add    $0x10,%esp
  8003a7:	05 14 1c 80 00       	add    $0x801c14,%eax
  8003ac:	8a 00                	mov    (%eax),%al
  8003ae:	0f be c0             	movsbl %al,%eax
  8003b1:	83 ec 08             	sub    $0x8,%esp
  8003b4:	ff 75 0c             	pushl  0xc(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	ff d0                	call   *%eax
  8003bd:	83 c4 10             	add    $0x10,%esp
}
  8003c0:	90                   	nop
  8003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003c4:	c9                   	leave  
  8003c5:	c3                   	ret    

008003c6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003cd:	7e 1c                	jle    8003eb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	8d 50 08             	lea    0x8(%eax),%edx
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	89 10                	mov    %edx,(%eax)
  8003dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003df:	8b 00                	mov    (%eax),%eax
  8003e1:	83 e8 08             	sub    $0x8,%eax
  8003e4:	8b 50 04             	mov    0x4(%eax),%edx
  8003e7:	8b 00                	mov    (%eax),%eax
  8003e9:	eb 40                	jmp    80042b <getuint+0x65>
	else if (lflag)
  8003eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003ef:	74 1e                	je     80040f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	8d 50 04             	lea    0x4(%eax),%edx
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	89 10                	mov    %edx,(%eax)
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	83 e8 04             	sub    $0x4,%eax
  800406:	8b 00                	mov    (%eax),%eax
  800408:	ba 00 00 00 00       	mov    $0x0,%edx
  80040d:	eb 1c                	jmp    80042b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8b 00                	mov    (%eax),%eax
  800414:	8d 50 04             	lea    0x4(%eax),%edx
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	89 10                	mov    %edx,(%eax)
  80041c:	8b 45 08             	mov    0x8(%ebp),%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	83 e8 04             	sub    $0x4,%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    

0080042d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800430:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800434:	7e 1c                	jle    800452 <getint+0x25>
		return va_arg(*ap, long long);
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8b 00                	mov    (%eax),%eax
  80043b:	8d 50 08             	lea    0x8(%eax),%edx
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	89 10                	mov    %edx,(%eax)
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	8b 00                	mov    (%eax),%eax
  800448:	83 e8 08             	sub    $0x8,%eax
  80044b:	8b 50 04             	mov    0x4(%eax),%edx
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	eb 38                	jmp    80048a <getint+0x5d>
	else if (lflag)
  800452:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800456:	74 1a                	je     800472 <getint+0x45>
		return va_arg(*ap, long);
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	8b 00                	mov    (%eax),%eax
  80045d:	8d 50 04             	lea    0x4(%eax),%edx
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	89 10                	mov    %edx,(%eax)
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	83 e8 04             	sub    $0x4,%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	99                   	cltd   
  800470:	eb 18                	jmp    80048a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	8d 50 04             	lea    0x4(%eax),%edx
  80047a:	8b 45 08             	mov    0x8(%ebp),%eax
  80047d:	89 10                	mov    %edx,(%eax)
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	8b 00                	mov    (%eax),%eax
  800484:	83 e8 04             	sub    $0x4,%eax
  800487:	8b 00                	mov    (%eax),%eax
  800489:	99                   	cltd   
}
  80048a:	5d                   	pop    %ebp
  80048b:	c3                   	ret    

0080048c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80048c:	55                   	push   %ebp
  80048d:	89 e5                	mov    %esp,%ebp
  80048f:	56                   	push   %esi
  800490:	53                   	push   %ebx
  800491:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800494:	eb 17                	jmp    8004ad <vprintfmt+0x21>
			if (ch == '\0')
  800496:	85 db                	test   %ebx,%ebx
  800498:	0f 84 af 03 00 00    	je     80084d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	ff 75 0c             	pushl  0xc(%ebp)
  8004a4:	53                   	push   %ebx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	ff d0                	call   *%eax
  8004aa:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b0:	8d 50 01             	lea    0x1(%eax),%edx
  8004b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8004b6:	8a 00                	mov    (%eax),%al
  8004b8:	0f b6 d8             	movzbl %al,%ebx
  8004bb:	83 fb 25             	cmp    $0x25,%ebx
  8004be:	75 d6                	jne    800496 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004c0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004c4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004cb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004d9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e3:	8d 50 01             	lea    0x1(%eax),%edx
  8004e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8004e9:	8a 00                	mov    (%eax),%al
  8004eb:	0f b6 d8             	movzbl %al,%ebx
  8004ee:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004f1:	83 f8 55             	cmp    $0x55,%eax
  8004f4:	0f 87 2b 03 00 00    	ja     800825 <vprintfmt+0x399>
  8004fa:	8b 04 85 38 1c 80 00 	mov    0x801c38(,%eax,4),%eax
  800501:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800503:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800507:	eb d7                	jmp    8004e0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800509:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80050d:	eb d1                	jmp    8004e0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80050f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800516:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800519:	89 d0                	mov    %edx,%eax
  80051b:	c1 e0 02             	shl    $0x2,%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d8                	add    %ebx,%eax
  800524:	83 e8 30             	sub    $0x30,%eax
  800527:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80052a:	8b 45 10             	mov    0x10(%ebp),%eax
  80052d:	8a 00                	mov    (%eax),%al
  80052f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800532:	83 fb 2f             	cmp    $0x2f,%ebx
  800535:	7e 3e                	jle    800575 <vprintfmt+0xe9>
  800537:	83 fb 39             	cmp    $0x39,%ebx
  80053a:	7f 39                	jg     800575 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80053c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80053f:	eb d5                	jmp    800516 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	83 c0 04             	add    $0x4,%eax
  800547:	89 45 14             	mov    %eax,0x14(%ebp)
  80054a:	8b 45 14             	mov    0x14(%ebp),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800555:	eb 1f                	jmp    800576 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800557:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80055b:	79 83                	jns    8004e0 <vprintfmt+0x54>
				width = 0;
  80055d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800564:	e9 77 ff ff ff       	jmp    8004e0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800569:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800570:	e9 6b ff ff ff       	jmp    8004e0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800575:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800576:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80057a:	0f 89 60 ff ff ff    	jns    8004e0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800580:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800586:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80058d:	e9 4e ff ff ff       	jmp    8004e0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800592:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800595:	e9 46 ff ff ff       	jmp    8004e0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80059a:	8b 45 14             	mov    0x14(%ebp),%eax
  80059d:	83 c0 04             	add    $0x4,%eax
  8005a0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	83 e8 04             	sub    $0x4,%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 0c             	pushl  0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b5:	ff d0                	call   *%eax
  8005b7:	83 c4 10             	add    $0x10,%esp
			break;
  8005ba:	e9 89 02 00 00       	jmp    800848 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	83 c0 04             	add    $0x4,%eax
  8005c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	83 e8 04             	sub    $0x4,%eax
  8005ce:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005d0:	85 db                	test   %ebx,%ebx
  8005d2:	79 02                	jns    8005d6 <vprintfmt+0x14a>
				err = -err;
  8005d4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005d6:	83 fb 64             	cmp    $0x64,%ebx
  8005d9:	7f 0b                	jg     8005e6 <vprintfmt+0x15a>
  8005db:	8b 34 9d 80 1a 80 00 	mov    0x801a80(,%ebx,4),%esi
  8005e2:	85 f6                	test   %esi,%esi
  8005e4:	75 19                	jne    8005ff <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005e6:	53                   	push   %ebx
  8005e7:	68 25 1c 80 00       	push   $0x801c25
  8005ec:	ff 75 0c             	pushl  0xc(%ebp)
  8005ef:	ff 75 08             	pushl  0x8(%ebp)
  8005f2:	e8 5e 02 00 00       	call   800855 <printfmt>
  8005f7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005fa:	e9 49 02 00 00       	jmp    800848 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005ff:	56                   	push   %esi
  800600:	68 2e 1c 80 00       	push   $0x801c2e
  800605:	ff 75 0c             	pushl  0xc(%ebp)
  800608:	ff 75 08             	pushl  0x8(%ebp)
  80060b:	e8 45 02 00 00       	call   800855 <printfmt>
  800610:	83 c4 10             	add    $0x10,%esp
			break;
  800613:	e9 30 02 00 00       	jmp    800848 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800618:	8b 45 14             	mov    0x14(%ebp),%eax
  80061b:	83 c0 04             	add    $0x4,%eax
  80061e:	89 45 14             	mov    %eax,0x14(%ebp)
  800621:	8b 45 14             	mov    0x14(%ebp),%eax
  800624:	83 e8 04             	sub    $0x4,%eax
  800627:	8b 30                	mov    (%eax),%esi
  800629:	85 f6                	test   %esi,%esi
  80062b:	75 05                	jne    800632 <vprintfmt+0x1a6>
				p = "(null)";
  80062d:	be 31 1c 80 00       	mov    $0x801c31,%esi
			if (width > 0 && padc != '-')
  800632:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800636:	7e 6d                	jle    8006a5 <vprintfmt+0x219>
  800638:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80063c:	74 67                	je     8006a5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80063e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	50                   	push   %eax
  800645:	56                   	push   %esi
  800646:	e8 0c 03 00 00       	call   800957 <strnlen>
  80064b:	83 c4 10             	add    $0x10,%esp
  80064e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800651:	eb 16                	jmp    800669 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800653:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	50                   	push   %eax
  80065e:	8b 45 08             	mov    0x8(%ebp),%eax
  800661:	ff d0                	call   *%eax
  800663:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800666:	ff 4d e4             	decl   -0x1c(%ebp)
  800669:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066d:	7f e4                	jg     800653 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066f:	eb 34                	jmp    8006a5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800671:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800675:	74 1c                	je     800693 <vprintfmt+0x207>
  800677:	83 fb 1f             	cmp    $0x1f,%ebx
  80067a:	7e 05                	jle    800681 <vprintfmt+0x1f5>
  80067c:	83 fb 7e             	cmp    $0x7e,%ebx
  80067f:	7e 12                	jle    800693 <vprintfmt+0x207>
					putch('?', putdat);
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	6a 3f                	push   $0x3f
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	ff d0                	call   *%eax
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	eb 0f                	jmp    8006a2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800693:	83 ec 08             	sub    $0x8,%esp
  800696:	ff 75 0c             	pushl  0xc(%ebp)
  800699:	53                   	push   %ebx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	ff d0                	call   *%eax
  80069f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a5:	89 f0                	mov    %esi,%eax
  8006a7:	8d 70 01             	lea    0x1(%eax),%esi
  8006aa:	8a 00                	mov    (%eax),%al
  8006ac:	0f be d8             	movsbl %al,%ebx
  8006af:	85 db                	test   %ebx,%ebx
  8006b1:	74 24                	je     8006d7 <vprintfmt+0x24b>
  8006b3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b7:	78 b8                	js     800671 <vprintfmt+0x1e5>
  8006b9:	ff 4d e0             	decl   -0x20(%ebp)
  8006bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c0:	79 af                	jns    800671 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c2:	eb 13                	jmp    8006d7 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ca:	6a 20                	push   $0x20
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	ff d0                	call   *%eax
  8006d1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006db:	7f e7                	jg     8006c4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006dd:	e9 66 01 00 00       	jmp    800848 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8006e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006eb:	50                   	push   %eax
  8006ec:	e8 3c fd ff ff       	call   80042d <getint>
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800700:	85 d2                	test   %edx,%edx
  800702:	79 23                	jns    800727 <vprintfmt+0x29b>
				putch('-', putdat);
  800704:	83 ec 08             	sub    $0x8,%esp
  800707:	ff 75 0c             	pushl  0xc(%ebp)
  80070a:	6a 2d                	push   $0x2d
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	ff d0                	call   *%eax
  800711:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071a:	f7 d8                	neg    %eax
  80071c:	83 d2 00             	adc    $0x0,%edx
  80071f:	f7 da                	neg    %edx
  800721:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800724:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800727:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80072e:	e9 bc 00 00 00       	jmp    8007ef <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800733:	83 ec 08             	sub    $0x8,%esp
  800736:	ff 75 e8             	pushl  -0x18(%ebp)
  800739:	8d 45 14             	lea    0x14(%ebp),%eax
  80073c:	50                   	push   %eax
  80073d:	e8 84 fc ff ff       	call   8003c6 <getuint>
  800742:	83 c4 10             	add    $0x10,%esp
  800745:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800748:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80074b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800752:	e9 98 00 00 00       	jmp    8007ef <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	6a 58                	push   $0x58
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	ff d0                	call   *%eax
  800764:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	6a 58                	push   $0x58
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	ff d0                	call   *%eax
  800774:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	6a 58                	push   $0x58
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	ff d0                	call   *%eax
  800784:	83 c4 10             	add    $0x10,%esp
			break;
  800787:	e9 bc 00 00 00       	jmp    800848 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80078c:	83 ec 08             	sub    $0x8,%esp
  80078f:	ff 75 0c             	pushl  0xc(%ebp)
  800792:	6a 30                	push   $0x30
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	ff d0                	call   *%eax
  800799:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	6a 78                	push   $0x78
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	ff d0                	call   *%eax
  8007a9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	83 c0 04             	add    $0x4,%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	83 e8 04             	sub    $0x4,%eax
  8007bb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007c7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007ce:	eb 1f                	jmp    8007ef <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007d0:	83 ec 08             	sub    $0x8,%esp
  8007d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8007d6:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d9:	50                   	push   %eax
  8007da:	e8 e7 fb ff ff       	call   8003c6 <getuint>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007e8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007ef:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f6:	83 ec 04             	sub    $0x4,%esp
  8007f9:	52                   	push   %edx
  8007fa:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007fd:	50                   	push   %eax
  8007fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800801:	ff 75 f0             	pushl  -0x10(%ebp)
  800804:	ff 75 0c             	pushl  0xc(%ebp)
  800807:	ff 75 08             	pushl  0x8(%ebp)
  80080a:	e8 00 fb ff ff       	call   80030f <printnum>
  80080f:	83 c4 20             	add    $0x20,%esp
			break;
  800812:	eb 34                	jmp    800848 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	53                   	push   %ebx
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	ff d0                	call   *%eax
  800820:	83 c4 10             	add    $0x10,%esp
			break;
  800823:	eb 23                	jmp    800848 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	6a 25                	push   $0x25
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	ff d0                	call   *%eax
  800832:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800835:	ff 4d 10             	decl   0x10(%ebp)
  800838:	eb 03                	jmp    80083d <vprintfmt+0x3b1>
  80083a:	ff 4d 10             	decl   0x10(%ebp)
  80083d:	8b 45 10             	mov    0x10(%ebp),%eax
  800840:	48                   	dec    %eax
  800841:	8a 00                	mov    (%eax),%al
  800843:	3c 25                	cmp    $0x25,%al
  800845:	75 f3                	jne    80083a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800847:	90                   	nop
		}
	}
  800848:	e9 47 fc ff ff       	jmp    800494 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80084d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80084e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800851:	5b                   	pop    %ebx
  800852:	5e                   	pop    %esi
  800853:	5d                   	pop    %ebp
  800854:	c3                   	ret    

00800855 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80085b:	8d 45 10             	lea    0x10(%ebp),%eax
  80085e:	83 c0 04             	add    $0x4,%eax
  800861:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800864:	8b 45 10             	mov    0x10(%ebp),%eax
  800867:	ff 75 f4             	pushl  -0xc(%ebp)
  80086a:	50                   	push   %eax
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	ff 75 08             	pushl  0x8(%ebp)
  800871:	e8 16 fc ff ff       	call   80048c <vprintfmt>
  800876:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800879:	90                   	nop
  80087a:	c9                   	leave  
  80087b:	c3                   	ret    

0080087c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80087f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800882:	8b 40 08             	mov    0x8(%eax),%eax
  800885:	8d 50 01             	lea    0x1(%eax),%edx
  800888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80088e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800891:	8b 10                	mov    (%eax),%edx
  800893:	8b 45 0c             	mov    0xc(%ebp),%eax
  800896:	8b 40 04             	mov    0x4(%eax),%eax
  800899:	39 c2                	cmp    %eax,%edx
  80089b:	73 12                	jae    8008af <sprintputch+0x33>
		*b->buf++ = ch;
  80089d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a8:	89 0a                	mov    %ecx,(%edx)
  8008aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ad:	88 10                	mov    %dl,(%eax)
}
  8008af:	90                   	nop
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008d7:	74 06                	je     8008df <vsnprintf+0x2d>
  8008d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008dd:	7f 07                	jg     8008e6 <vsnprintf+0x34>
		return -E_INVAL;
  8008df:	b8 03 00 00 00       	mov    $0x3,%eax
  8008e4:	eb 20                	jmp    800906 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e6:	ff 75 14             	pushl  0x14(%ebp)
  8008e9:	ff 75 10             	pushl  0x10(%ebp)
  8008ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ef:	50                   	push   %eax
  8008f0:	68 7c 08 80 00       	push   $0x80087c
  8008f5:	e8 92 fb ff ff       	call   80048c <vprintfmt>
  8008fa:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800900:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800903:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800906:	c9                   	leave  
  800907:	c3                   	ret    

00800908 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80090e:	8d 45 10             	lea    0x10(%ebp),%eax
  800911:	83 c0 04             	add    $0x4,%eax
  800914:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800917:	8b 45 10             	mov    0x10(%ebp),%eax
  80091a:	ff 75 f4             	pushl  -0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	ff 75 08             	pushl  0x8(%ebp)
  800924:	e8 89 ff ff ff       	call   8008b2 <vsnprintf>
  800929:	83 c4 10             	add    $0x10,%esp
  80092c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80092f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800932:	c9                   	leave  
  800933:	c3                   	ret    

00800934 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80093a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800941:	eb 06                	jmp    800949 <strlen+0x15>
		n++;
  800943:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800946:	ff 45 08             	incl   0x8(%ebp)
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	8a 00                	mov    (%eax),%al
  80094e:	84 c0                	test   %al,%al
  800950:	75 f1                	jne    800943 <strlen+0xf>
		n++;
	return n;
  800952:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800955:	c9                   	leave  
  800956:	c3                   	ret    

00800957 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80095d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800964:	eb 09                	jmp    80096f <strnlen+0x18>
		n++;
  800966:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800969:	ff 45 08             	incl   0x8(%ebp)
  80096c:	ff 4d 0c             	decl   0xc(%ebp)
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	74 09                	je     80097e <strnlen+0x27>
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8a 00                	mov    (%eax),%al
  80097a:	84 c0                	test   %al,%al
  80097c:	75 e8                	jne    800966 <strnlen+0xf>
		n++;
	return n;
  80097e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80098f:	90                   	nop
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8d 50 01             	lea    0x1(%eax),%edx
  800996:	89 55 08             	mov    %edx,0x8(%ebp)
  800999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80099f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009a2:	8a 12                	mov    (%edx),%dl
  8009a4:	88 10                	mov    %dl,(%eax)
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	84 c0                	test   %al,%al
  8009aa:	75 e4                	jne    800990 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009af:	c9                   	leave  
  8009b0:	c3                   	ret    

008009b1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009c4:	eb 1f                	jmp    8009e5 <strncpy+0x34>
		*dst++ = *src;
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8d 50 01             	lea    0x1(%eax),%edx
  8009cc:	89 55 08             	mov    %edx,0x8(%ebp)
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	8a 12                	mov    (%edx),%dl
  8009d4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d9:	8a 00                	mov    (%eax),%al
  8009db:	84 c0                	test   %al,%al
  8009dd:	74 03                	je     8009e2 <strncpy+0x31>
			src++;
  8009df:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e2:	ff 45 fc             	incl   -0x4(%ebp)
  8009e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009e8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009eb:	72 d9                	jb     8009c6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a02:	74 30                	je     800a34 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a04:	eb 16                	jmp    800a1c <strlcpy+0x2a>
			*dst++ = *src++;
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8d 50 01             	lea    0x1(%eax),%edx
  800a0c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a12:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a15:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a18:	8a 12                	mov    (%edx),%dl
  800a1a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a1c:	ff 4d 10             	decl   0x10(%ebp)
  800a1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a23:	74 09                	je     800a2e <strlcpy+0x3c>
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	8a 00                	mov    (%eax),%al
  800a2a:	84 c0                	test   %al,%al
  800a2c:	75 d8                	jne    800a06 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a34:	8b 55 08             	mov    0x8(%ebp),%edx
  800a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a3a:	29 c2                	sub    %eax,%edx
  800a3c:	89 d0                	mov    %edx,%eax
}
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a43:	eb 06                	jmp    800a4b <strcmp+0xb>
		p++, q++;
  800a45:	ff 45 08             	incl   0x8(%ebp)
  800a48:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8a 00                	mov    (%eax),%al
  800a50:	84 c0                	test   %al,%al
  800a52:	74 0e                	je     800a62 <strcmp+0x22>
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	8a 10                	mov    (%eax),%dl
  800a59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5c:	8a 00                	mov    (%eax),%al
  800a5e:	38 c2                	cmp    %al,%dl
  800a60:	74 e3                	je     800a45 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8a 00                	mov    (%eax),%al
  800a67:	0f b6 d0             	movzbl %al,%edx
  800a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6d:	8a 00                	mov    (%eax),%al
  800a6f:	0f b6 c0             	movzbl %al,%eax
  800a72:	29 c2                	sub    %eax,%edx
  800a74:	89 d0                	mov    %edx,%eax
}
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a7b:	eb 09                	jmp    800a86 <strncmp+0xe>
		n--, p++, q++;
  800a7d:	ff 4d 10             	decl   0x10(%ebp)
  800a80:	ff 45 08             	incl   0x8(%ebp)
  800a83:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a8a:	74 17                	je     800aa3 <strncmp+0x2b>
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	84 c0                	test   %al,%al
  800a93:	74 0e                	je     800aa3 <strncmp+0x2b>
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	8a 10                	mov    (%eax),%dl
  800a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9d:	8a 00                	mov    (%eax),%al
  800a9f:	38 c2                	cmp    %al,%dl
  800aa1:	74 da                	je     800a7d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800aa3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa7:	75 07                	jne    800ab0 <strncmp+0x38>
		return 0;
  800aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aae:	eb 14                	jmp    800ac4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	8a 00                	mov    (%eax),%al
  800ab5:	0f b6 d0             	movzbl %al,%edx
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abb:	8a 00                	mov    (%eax),%al
  800abd:	0f b6 c0             	movzbl %al,%eax
  800ac0:	29 c2                	sub    %eax,%edx
  800ac2:	89 d0                	mov    %edx,%eax
}
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 04             	sub    $0x4,%esp
  800acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ad2:	eb 12                	jmp    800ae6 <strchr+0x20>
		if (*s == c)
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8a 00                	mov    (%eax),%al
  800ad9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800adc:	75 05                	jne    800ae3 <strchr+0x1d>
			return (char *) s;
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	eb 11                	jmp    800af4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ae3:	ff 45 08             	incl   0x8(%ebp)
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	8a 00                	mov    (%eax),%al
  800aeb:	84 c0                	test   %al,%al
  800aed:	75 e5                	jne    800ad4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af4:	c9                   	leave  
  800af5:	c3                   	ret    

00800af6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	83 ec 04             	sub    $0x4,%esp
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b02:	eb 0d                	jmp    800b11 <strfind+0x1b>
		if (*s == c)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b0c:	74 0e                	je     800b1c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	84 c0                	test   %al,%al
  800b18:	75 ea                	jne    800b04 <strfind+0xe>
  800b1a:	eb 01                	jmp    800b1d <strfind+0x27>
		if (*s == c)
			break;
  800b1c:	90                   	nop
	return (char *) s;
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b34:	eb 0e                	jmp    800b44 <memset+0x22>
		*p++ = c;
  800b36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b42:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b44:	ff 4d f8             	decl   -0x8(%ebp)
  800b47:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b4b:	79 e9                	jns    800b36 <memset+0x14>
		*p++ = c;

	return v;
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    

00800b52 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b64:	eb 16                	jmp    800b7c <memcpy+0x2a>
		*d++ = *s++;
  800b66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b69:	8d 50 01             	lea    0x1(%eax),%edx
  800b6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b78:	8a 12                	mov    (%edx),%dl
  800b7a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b82:	89 55 10             	mov    %edx,0x10(%ebp)
  800b85:	85 c0                	test   %eax,%eax
  800b87:	75 dd                	jne    800b66 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    

00800b8e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ba6:	73 50                	jae    800bf8 <memmove+0x6a>
  800ba8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bab:	8b 45 10             	mov    0x10(%ebp),%eax
  800bae:	01 d0                	add    %edx,%eax
  800bb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bb3:	76 43                	jbe    800bf8 <memmove+0x6a>
		s += n;
  800bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbe:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bc1:	eb 10                	jmp    800bd3 <memmove+0x45>
			*--d = *--s;
  800bc3:	ff 4d f8             	decl   -0x8(%ebp)
  800bc6:	ff 4d fc             	decl   -0x4(%ebp)
  800bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcc:	8a 10                	mov    (%eax),%dl
  800bce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bdc:	85 c0                	test   %eax,%eax
  800bde:	75 e3                	jne    800bc3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be0:	eb 23                	jmp    800c05 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800be2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be5:	8d 50 01             	lea    0x1(%eax),%edx
  800be8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800beb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bee:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bf1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bf4:	8a 12                	mov    (%edx),%dl
  800bf6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfe:	89 55 10             	mov    %edx,0x10(%ebp)
  800c01:	85 c0                	test   %eax,%eax
  800c03:	75 dd                	jne    800be2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c08:	c9                   	leave  
  800c09:	c3                   	ret    

00800c0a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c10:	8b 45 08             	mov    0x8(%ebp),%eax
  800c13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c19:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c1c:	eb 2a                	jmp    800c48 <memcmp+0x3e>
		if (*s1 != *s2)
  800c1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c21:	8a 10                	mov    (%eax),%dl
  800c23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c26:	8a 00                	mov    (%eax),%al
  800c28:	38 c2                	cmp    %al,%dl
  800c2a:	74 16                	je     800c42 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2f:	8a 00                	mov    (%eax),%al
  800c31:	0f b6 d0             	movzbl %al,%edx
  800c34:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	0f b6 c0             	movzbl %al,%eax
  800c3c:	29 c2                	sub    %eax,%edx
  800c3e:	89 d0                	mov    %edx,%eax
  800c40:	eb 18                	jmp    800c5a <memcmp+0x50>
		s1++, s2++;
  800c42:	ff 45 fc             	incl   -0x4(%ebp)
  800c45:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c48:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c51:	85 c0                	test   %eax,%eax
  800c53:	75 c9                	jne    800c1e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c62:	8b 55 08             	mov    0x8(%ebp),%edx
  800c65:	8b 45 10             	mov    0x10(%ebp),%eax
  800c68:	01 d0                	add    %edx,%eax
  800c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c6d:	eb 15                	jmp    800c84 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	8a 00                	mov    (%eax),%al
  800c74:	0f b6 d0             	movzbl %al,%edx
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	0f b6 c0             	movzbl %al,%eax
  800c7d:	39 c2                	cmp    %eax,%edx
  800c7f:	74 0d                	je     800c8e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c81:	ff 45 08             	incl   0x8(%ebp)
  800c84:	8b 45 08             	mov    0x8(%ebp),%eax
  800c87:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c8a:	72 e3                	jb     800c6f <memfind+0x13>
  800c8c:	eb 01                	jmp    800c8f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c8e:	90                   	nop
	return (void *) s;
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c92:	c9                   	leave  
  800c93:	c3                   	ret    

00800c94 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c9a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800ca1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ca8:	eb 03                	jmp    800cad <strtol+0x19>
		s++;
  800caa:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	3c 20                	cmp    $0x20,%al
  800cb4:	74 f4                	je     800caa <strtol+0x16>
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	3c 09                	cmp    $0x9,%al
  800cbd:	74 eb                	je     800caa <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	3c 2b                	cmp    $0x2b,%al
  800cc6:	75 05                	jne    800ccd <strtol+0x39>
		s++;
  800cc8:	ff 45 08             	incl   0x8(%ebp)
  800ccb:	eb 13                	jmp    800ce0 <strtol+0x4c>
	else if (*s == '-')
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	3c 2d                	cmp    $0x2d,%al
  800cd4:	75 0a                	jne    800ce0 <strtol+0x4c>
		s++, neg = 1;
  800cd6:	ff 45 08             	incl   0x8(%ebp)
  800cd9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce4:	74 06                	je     800cec <strtol+0x58>
  800ce6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cea:	75 20                	jne    800d0c <strtol+0x78>
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	3c 30                	cmp    $0x30,%al
  800cf3:	75 17                	jne    800d0c <strtol+0x78>
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	40                   	inc    %eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	3c 78                	cmp    $0x78,%al
  800cfd:	75 0d                	jne    800d0c <strtol+0x78>
		s += 2, base = 16;
  800cff:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d03:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d0a:	eb 28                	jmp    800d34 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d10:	75 15                	jne    800d27 <strtol+0x93>
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	3c 30                	cmp    $0x30,%al
  800d19:	75 0c                	jne    800d27 <strtol+0x93>
		s++, base = 8;
  800d1b:	ff 45 08             	incl   0x8(%ebp)
  800d1e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d25:	eb 0d                	jmp    800d34 <strtol+0xa0>
	else if (base == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strtol+0xa0>
		base = 10;
  800d2d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	3c 2f                	cmp    $0x2f,%al
  800d3b:	7e 19                	jle    800d56 <strtol+0xc2>
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	3c 39                	cmp    $0x39,%al
  800d44:	7f 10                	jg     800d56 <strtol+0xc2>
			dig = *s - '0';
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	0f be c0             	movsbl %al,%eax
  800d4e:	83 e8 30             	sub    $0x30,%eax
  800d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d54:	eb 42                	jmp    800d98 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	3c 60                	cmp    $0x60,%al
  800d5d:	7e 19                	jle    800d78 <strtol+0xe4>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	3c 7a                	cmp    $0x7a,%al
  800d66:	7f 10                	jg     800d78 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f be c0             	movsbl %al,%eax
  800d70:	83 e8 57             	sub    $0x57,%eax
  800d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d76:	eb 20                	jmp    800d98 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	3c 40                	cmp    $0x40,%al
  800d7f:	7e 39                	jle    800dba <strtol+0x126>
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	3c 5a                	cmp    $0x5a,%al
  800d88:	7f 30                	jg     800dba <strtol+0x126>
			dig = *s - 'A' + 10;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be c0             	movsbl %al,%eax
  800d92:	83 e8 37             	sub    $0x37,%eax
  800d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d9b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d9e:	7d 19                	jge    800db9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800da6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800daa:	89 c2                	mov    %eax,%edx
  800dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800daf:	01 d0                	add    %edx,%eax
  800db1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800db4:	e9 7b ff ff ff       	jmp    800d34 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800db9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dbe:	74 08                	je     800dc8 <strtol+0x134>
		*endptr = (char *) s;
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800dc8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dcc:	74 07                	je     800dd5 <strtol+0x141>
  800dce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd1:	f7 d8                	neg    %eax
  800dd3:	eb 03                	jmp    800dd8 <strtol+0x144>
  800dd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <ltostr>:

void
ltostr(long value, char *str)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800de0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800de7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df2:	79 13                	jns    800e07 <ltostr+0x2d>
	{
		neg = 1;
  800df4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfe:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e01:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e04:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e0f:	99                   	cltd   
  800e10:	f7 f9                	idiv   %ecx
  800e12:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e18:	8d 50 01             	lea    0x1(%eax),%edx
  800e1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e1e:	89 c2                	mov    %eax,%edx
  800e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e23:	01 d0                	add    %edx,%eax
  800e25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e28:	83 c2 30             	add    $0x30,%edx
  800e2b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e30:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e35:	f7 e9                	imul   %ecx
  800e37:	c1 fa 02             	sar    $0x2,%edx
  800e3a:	89 c8                	mov    %ecx,%eax
  800e3c:	c1 f8 1f             	sar    $0x1f,%eax
  800e3f:	29 c2                	sub    %eax,%edx
  800e41:	89 d0                	mov    %edx,%eax
  800e43:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e49:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e4e:	f7 e9                	imul   %ecx
  800e50:	c1 fa 02             	sar    $0x2,%edx
  800e53:	89 c8                	mov    %ecx,%eax
  800e55:	c1 f8 1f             	sar    $0x1f,%eax
  800e58:	29 c2                	sub    %eax,%edx
  800e5a:	89 d0                	mov    %edx,%eax
  800e5c:	c1 e0 02             	shl    $0x2,%eax
  800e5f:	01 d0                	add    %edx,%eax
  800e61:	01 c0                	add    %eax,%eax
  800e63:	29 c1                	sub    %eax,%ecx
  800e65:	89 ca                	mov    %ecx,%edx
  800e67:	85 d2                	test   %edx,%edx
  800e69:	75 9c                	jne    800e07 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e75:	48                   	dec    %eax
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e7d:	74 3d                	je     800ebc <ltostr+0xe2>
		start = 1 ;
  800e7f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e86:	eb 34                	jmp    800ebc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8e:	01 d0                	add    %edx,%eax
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	01 c2                	add    %eax,%edx
  800e9d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea3:	01 c8                	add    %ecx,%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ea9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaf:	01 c2                	add    %eax,%edx
  800eb1:	8a 45 eb             	mov    -0x15(%ebp),%al
  800eb4:	88 02                	mov    %al,(%edx)
		start++ ;
  800eb6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800eb9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ec2:	7c c4                	jl     800e88 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ec4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eca:	01 d0                	add    %edx,%eax
  800ecc:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ecf:	90                   	nop
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ed8:	ff 75 08             	pushl  0x8(%ebp)
  800edb:	e8 54 fa ff ff       	call   800934 <strlen>
  800ee0:	83 c4 04             	add    $0x4,%esp
  800ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ee6:	ff 75 0c             	pushl  0xc(%ebp)
  800ee9:	e8 46 fa ff ff       	call   800934 <strlen>
  800eee:	83 c4 04             	add    $0x4,%esp
  800ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ef4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800efb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f02:	eb 17                	jmp    800f1b <strcconcat+0x49>
		final[s] = str1[s] ;
  800f04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	01 c2                	add    %eax,%edx
  800f0c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	01 c8                	add    %ecx,%eax
  800f14:	8a 00                	mov    (%eax),%al
  800f16:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f18:	ff 45 fc             	incl   -0x4(%ebp)
  800f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f21:	7c e1                	jl     800f04 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f23:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f2a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f31:	eb 1f                	jmp    800f52 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f36:	8d 50 01             	lea    0x1(%eax),%edx
  800f39:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3c:	89 c2                	mov    %eax,%edx
  800f3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f41:	01 c2                	add    %eax,%edx
  800f43:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f49:	01 c8                	add    %ecx,%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f4f:	ff 45 f8             	incl   -0x8(%ebp)
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f58:	7c d9                	jl     800f33 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	c6 00 00             	movb   $0x0,(%eax)
}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f74:	8b 45 14             	mov    0x14(%ebp),%eax
  800f77:	8b 00                	mov    (%eax),%eax
  800f79:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f80:	8b 45 10             	mov    0x10(%ebp),%eax
  800f83:	01 d0                	add    %edx,%eax
  800f85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f8b:	eb 0c                	jmp    800f99 <strsplit+0x31>
			*string++ = 0;
  800f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f90:	8d 50 01             	lea    0x1(%eax),%edx
  800f93:	89 55 08             	mov    %edx,0x8(%ebp)
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	84 c0                	test   %al,%al
  800fa0:	74 18                	je     800fba <strsplit+0x52>
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	0f be c0             	movsbl %al,%eax
  800faa:	50                   	push   %eax
  800fab:	ff 75 0c             	pushl  0xc(%ebp)
  800fae:	e8 13 fb ff ff       	call   800ac6 <strchr>
  800fb3:	83 c4 08             	add    $0x8,%esp
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	75 d3                	jne    800f8d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	74 5a                	je     80101d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	8b 00                	mov    (%eax),%eax
  800fc8:	83 f8 0f             	cmp    $0xf,%eax
  800fcb:	75 07                	jne    800fd4 <strsplit+0x6c>
		{
			return 0;
  800fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd2:	eb 66                	jmp    80103a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd7:	8b 00                	mov    (%eax),%eax
  800fd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800fdc:	8b 55 14             	mov    0x14(%ebp),%edx
  800fdf:	89 0a                	mov    %ecx,(%edx)
  800fe1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	01 c2                	add    %eax,%edx
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff2:	eb 03                	jmp    800ff7 <strsplit+0x8f>
			string++;
  800ff4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	84 c0                	test   %al,%al
  800ffe:	74 8b                	je     800f8b <strsplit+0x23>
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	0f be c0             	movsbl %al,%eax
  801008:	50                   	push   %eax
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	e8 b5 fa ff ff       	call   800ac6 <strchr>
  801011:	83 c4 08             	add    $0x8,%esp
  801014:	85 c0                	test   %eax,%eax
  801016:	74 dc                	je     800ff4 <strsplit+0x8c>
			string++;
	}
  801018:	e9 6e ff ff ff       	jmp    800f8b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80101d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80101e:	8b 45 14             	mov    0x14(%ebp),%eax
  801021:	8b 00                	mov    (%eax),%eax
  801023:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80102a:	8b 45 10             	mov    0x10(%ebp),%eax
  80102d:	01 d0                	add    %edx,%eax
  80102f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801035:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	57                   	push   %edi
  801040:	56                   	push   %esi
  801041:	53                   	push   %ebx
  801042:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80104e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801051:	8b 7d 18             	mov    0x18(%ebp),%edi
  801054:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801057:	cd 30                	int    $0x30
  801059:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80105c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105f:	83 c4 10             	add    $0x10,%esp
  801062:	5b                   	pop    %ebx
  801063:	5e                   	pop    %esi
  801064:	5f                   	pop    %edi
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    

00801067 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 04             	sub    $0x4,%esp
  80106d:	8b 45 10             	mov    0x10(%ebp),%eax
  801070:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801073:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	6a 00                	push   $0x0
  80107c:	6a 00                	push   $0x0
  80107e:	52                   	push   %edx
  80107f:	ff 75 0c             	pushl  0xc(%ebp)
  801082:	50                   	push   %eax
  801083:	6a 00                	push   $0x0
  801085:	e8 b2 ff ff ff       	call   80103c <syscall>
  80108a:	83 c4 18             	add    $0x18,%esp
}
  80108d:	90                   	nop
  80108e:	c9                   	leave  
  80108f:	c3                   	ret    

00801090 <sys_cgetc>:

int
sys_cgetc(void)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801093:	6a 00                	push   $0x0
  801095:	6a 00                	push   $0x0
  801097:	6a 00                	push   $0x0
  801099:	6a 00                	push   $0x0
  80109b:	6a 00                	push   $0x0
  80109d:	6a 01                	push   $0x1
  80109f:	e8 98 ff ff ff       	call   80103c <syscall>
  8010a4:	83 c4 18             	add    $0x18,%esp
}
  8010a7:	c9                   	leave  
  8010a8:	c3                   	ret    

008010a9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010a9:	55                   	push   %ebp
  8010aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	6a 00                	push   $0x0
  8010b4:	6a 00                	push   $0x0
  8010b6:	6a 00                	push   $0x0
  8010b8:	52                   	push   %edx
  8010b9:	50                   	push   %eax
  8010ba:	6a 05                	push   $0x5
  8010bc:	e8 7b ff ff ff       	call   80103c <syscall>
  8010c1:	83 c4 18             	add    $0x18,%esp
}
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	56                   	push   %esi
  8010ca:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010cb:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	56                   	push   %esi
  8010db:	53                   	push   %ebx
  8010dc:	51                   	push   %ecx
  8010dd:	52                   	push   %edx
  8010de:	50                   	push   %eax
  8010df:	6a 06                	push   $0x6
  8010e1:	e8 56 ff ff ff       	call   80103c <syscall>
  8010e6:	83 c4 18             	add    $0x18,%esp
}
  8010e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010ec:	5b                   	pop    %ebx
  8010ed:	5e                   	pop    %esi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	6a 00                	push   $0x0
  8010fb:	6a 00                	push   $0x0
  8010fd:	6a 00                	push   $0x0
  8010ff:	52                   	push   %edx
  801100:	50                   	push   %eax
  801101:	6a 07                	push   $0x7
  801103:	e8 34 ff ff ff       	call   80103c <syscall>
  801108:	83 c4 18             	add    $0x18,%esp
}
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    

0080110d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801110:	6a 00                	push   $0x0
  801112:	6a 00                	push   $0x0
  801114:	6a 00                	push   $0x0
  801116:	ff 75 0c             	pushl  0xc(%ebp)
  801119:	ff 75 08             	pushl  0x8(%ebp)
  80111c:	6a 08                	push   $0x8
  80111e:	e8 19 ff ff ff       	call   80103c <syscall>
  801123:	83 c4 18             	add    $0x18,%esp
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80112b:	6a 00                	push   $0x0
  80112d:	6a 00                	push   $0x0
  80112f:	6a 00                	push   $0x0
  801131:	6a 00                	push   $0x0
  801133:	6a 00                	push   $0x0
  801135:	6a 09                	push   $0x9
  801137:	e8 00 ff ff ff       	call   80103c <syscall>
  80113c:	83 c4 18             	add    $0x18,%esp
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801144:	6a 00                	push   $0x0
  801146:	6a 00                	push   $0x0
  801148:	6a 00                	push   $0x0
  80114a:	6a 00                	push   $0x0
  80114c:	6a 00                	push   $0x0
  80114e:	6a 0a                	push   $0xa
  801150:	e8 e7 fe ff ff       	call   80103c <syscall>
  801155:	83 c4 18             	add    $0x18,%esp
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80115d:	6a 00                	push   $0x0
  80115f:	6a 00                	push   $0x0
  801161:	6a 00                	push   $0x0
  801163:	6a 00                	push   $0x0
  801165:	6a 00                	push   $0x0
  801167:	6a 0b                	push   $0xb
  801169:	e8 ce fe ff ff       	call   80103c <syscall>
  80116e:	83 c4 18             	add    $0x18,%esp
}
  801171:	c9                   	leave  
  801172:	c3                   	ret    

00801173 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801176:	6a 00                	push   $0x0
  801178:	6a 00                	push   $0x0
  80117a:	6a 00                	push   $0x0
  80117c:	ff 75 0c             	pushl  0xc(%ebp)
  80117f:	ff 75 08             	pushl  0x8(%ebp)
  801182:	6a 0f                	push   $0xf
  801184:	e8 b3 fe ff ff       	call   80103c <syscall>
  801189:	83 c4 18             	add    $0x18,%esp
	return;
  80118c:	90                   	nop
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	ff 75 0c             	pushl  0xc(%ebp)
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	6a 10                	push   $0x10
  8011a0:	e8 97 fe ff ff       	call   80103c <syscall>
  8011a5:	83 c4 18             	add    $0x18,%esp
	return ;
  8011a8:	90                   	nop
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8011ae:	6a 00                	push   $0x0
  8011b0:	6a 00                	push   $0x0
  8011b2:	ff 75 10             	pushl  0x10(%ebp)
  8011b5:	ff 75 0c             	pushl  0xc(%ebp)
  8011b8:	ff 75 08             	pushl  0x8(%ebp)
  8011bb:	6a 11                	push   $0x11
  8011bd:	e8 7a fe ff ff       	call   80103c <syscall>
  8011c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8011c5:	90                   	nop
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 00                	push   $0x0
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 0c                	push   $0xc
  8011d7:	e8 60 fe ff ff       	call   80103c <syscall>
  8011dc:	83 c4 18             	add    $0x18,%esp
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	ff 75 08             	pushl  0x8(%ebp)
  8011ef:	6a 0d                	push   $0xd
  8011f1:	e8 46 fe ff ff       	call   80103c <syscall>
  8011f6:	83 c4 18             	add    $0x18,%esp
}
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011fe:	6a 00                	push   $0x0
  801200:	6a 00                	push   $0x0
  801202:	6a 00                	push   $0x0
  801204:	6a 00                	push   $0x0
  801206:	6a 00                	push   $0x0
  801208:	6a 0e                	push   $0xe
  80120a:	e8 2d fe ff ff       	call   80103c <syscall>
  80120f:	83 c4 18             	add    $0x18,%esp
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801218:	6a 00                	push   $0x0
  80121a:	6a 00                	push   $0x0
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 13                	push   $0x13
  801224:	e8 13 fe ff ff       	call   80103c <syscall>
  801229:	83 c4 18             	add    $0x18,%esp
}
  80122c:	90                   	nop
  80122d:	c9                   	leave  
  80122e:	c3                   	ret    

0080122f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80122f:	55                   	push   %ebp
  801230:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	6a 14                	push   $0x14
  80123e:	e8 f9 fd ff ff       	call   80103c <syscall>
  801243:	83 c4 18             	add    $0x18,%esp
}
  801246:	90                   	nop
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <sys_cputc>:


void
sys_cputc(const char c)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 04             	sub    $0x4,%esp
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801255:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	50                   	push   %eax
  801262:	6a 15                	push   $0x15
  801264:	e8 d3 fd ff ff       	call   80103c <syscall>
  801269:	83 c4 18             	add    $0x18,%esp
}
  80126c:	90                   	nop
  80126d:	c9                   	leave  
  80126e:	c3                   	ret    

0080126f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801272:	6a 00                	push   $0x0
  801274:	6a 00                	push   $0x0
  801276:	6a 00                	push   $0x0
  801278:	6a 00                	push   $0x0
  80127a:	6a 00                	push   $0x0
  80127c:	6a 16                	push   $0x16
  80127e:	e8 b9 fd ff ff       	call   80103c <syscall>
  801283:	83 c4 18             	add    $0x18,%esp
}
  801286:	90                   	nop
  801287:	c9                   	leave  
  801288:	c3                   	ret    

00801289 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	6a 00                	push   $0x0
  801295:	ff 75 0c             	pushl  0xc(%ebp)
  801298:	50                   	push   %eax
  801299:	6a 17                	push   $0x17
  80129b:	e8 9c fd ff ff       	call   80103c <syscall>
  8012a0:	83 c4 18             	add    $0x18,%esp
}
  8012a3:	c9                   	leave  
  8012a4:	c3                   	ret    

008012a5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	6a 00                	push   $0x0
  8012b0:	6a 00                	push   $0x0
  8012b2:	6a 00                	push   $0x0
  8012b4:	52                   	push   %edx
  8012b5:	50                   	push   %eax
  8012b6:	6a 1a                	push   $0x1a
  8012b8:	e8 7f fd ff ff       	call   80103c <syscall>
  8012bd:	83 c4 18             	add    $0x18,%esp
}
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    

008012c2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	6a 00                	push   $0x0
  8012d1:	52                   	push   %edx
  8012d2:	50                   	push   %eax
  8012d3:	6a 18                	push   $0x18
  8012d5:	e8 62 fd ff ff       	call   80103c <syscall>
  8012da:	83 c4 18             	add    $0x18,%esp
}
  8012dd:	90                   	nop
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	52                   	push   %edx
  8012f0:	50                   	push   %eax
  8012f1:	6a 19                	push   $0x19
  8012f3:	e8 44 fd ff ff       	call   80103c <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	90                   	nop
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 04             	sub    $0x4,%esp
  801304:	8b 45 10             	mov    0x10(%ebp),%eax
  801307:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80130a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80130d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	6a 00                	push   $0x0
  801316:	51                   	push   %ecx
  801317:	52                   	push   %edx
  801318:	ff 75 0c             	pushl  0xc(%ebp)
  80131b:	50                   	push   %eax
  80131c:	6a 1b                	push   $0x1b
  80131e:	e8 19 fd ff ff       	call   80103c <syscall>
  801323:	83 c4 18             	add    $0x18,%esp
}
  801326:	c9                   	leave  
  801327:	c3                   	ret    

00801328 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801328:	55                   	push   %ebp
  801329:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80132b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	52                   	push   %edx
  801338:	50                   	push   %eax
  801339:	6a 1c                	push   $0x1c
  80133b:	e8 fc fc ff ff       	call   80103c <syscall>
  801340:	83 c4 18             	add    $0x18,%esp
}
  801343:	c9                   	leave  
  801344:	c3                   	ret    

00801345 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801348:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80134b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	51                   	push   %ecx
  801356:	52                   	push   %edx
  801357:	50                   	push   %eax
  801358:	6a 1d                	push   $0x1d
  80135a:	e8 dd fc ff ff       	call   80103c <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	52                   	push   %edx
  801374:	50                   	push   %eax
  801375:	6a 1e                	push   $0x1e
  801377:	e8 c0 fc ff ff       	call   80103c <syscall>
  80137c:	83 c4 18             	add    $0x18,%esp
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 1f                	push   $0x1f
  801390:	e8 a7 fc ff ff       	call   80103c <syscall>
  801395:	83 c4 18             	add    $0x18,%esp
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	6a 00                	push   $0x0
  8013a2:	ff 75 14             	pushl  0x14(%ebp)
  8013a5:	ff 75 10             	pushl  0x10(%ebp)
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	50                   	push   %eax
  8013ac:	6a 20                	push   $0x20
  8013ae:	e8 89 fc ff ff       	call   80103c <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	50                   	push   %eax
  8013c7:	6a 21                	push   $0x21
  8013c9:	e8 6e fc ff ff       	call   80103c <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	90                   	nop
  8013d2:	c9                   	leave  
  8013d3:	c3                   	ret    

008013d4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	50                   	push   %eax
  8013e3:	6a 22                	push   $0x22
  8013e5:	e8 52 fc ff ff       	call   80103c <syscall>
  8013ea:	83 c4 18             	add    $0x18,%esp
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 02                	push   $0x2
  8013fe:	e8 39 fc ff ff       	call   80103c <syscall>
  801403:	83 c4 18             	add    $0x18,%esp
}
  801406:	c9                   	leave  
  801407:	c3                   	ret    

00801408 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801408:	55                   	push   %ebp
  801409:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	6a 03                	push   $0x3
  801417:	e8 20 fc ff ff       	call   80103c <syscall>
  80141c:	83 c4 18             	add    $0x18,%esp
}
  80141f:	c9                   	leave  
  801420:	c3                   	ret    

00801421 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	6a 00                	push   $0x0
  80142e:	6a 04                	push   $0x4
  801430:	e8 07 fc ff ff       	call   80103c <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_exit_env>:


void sys_exit_env(void)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 23                	push   $0x23
  801449:	e8 ee fb ff ff       	call   80103c <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
}
  801451:	90                   	nop
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80145a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80145d:	8d 50 04             	lea    0x4(%eax),%edx
  801460:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801463:	6a 00                	push   $0x0
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	52                   	push   %edx
  80146a:	50                   	push   %eax
  80146b:	6a 24                	push   $0x24
  80146d:	e8 ca fb ff ff       	call   80103c <syscall>
  801472:	83 c4 18             	add    $0x18,%esp
	return result;
  801475:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801478:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147e:	89 01                	mov    %eax,(%ecx)
  801480:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	c9                   	leave  
  801487:	c2 04 00             	ret    $0x4

0080148a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	ff 75 10             	pushl  0x10(%ebp)
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	ff 75 08             	pushl  0x8(%ebp)
  80149a:	6a 12                	push   $0x12
  80149c:	e8 9b fb ff ff       	call   80103c <syscall>
  8014a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8014a4:	90                   	nop
}
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 25                	push   $0x25
  8014b6:	e8 81 fb ff ff       	call   80103c <syscall>
  8014bb:	83 c4 18             	add    $0x18,%esp
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014cc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	50                   	push   %eax
  8014d9:	6a 26                	push   $0x26
  8014db:	e8 5c fb ff ff       	call   80103c <syscall>
  8014e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8014e3:	90                   	nop
}
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    

008014e6 <rsttst>:
void rsttst()
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	6a 28                	push   $0x28
  8014f5:	e8 42 fb ff ff       	call   80103c <syscall>
  8014fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8014fd:	90                   	nop
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	8b 45 14             	mov    0x14(%ebp),%eax
  801509:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80150c:	8b 55 18             	mov    0x18(%ebp),%edx
  80150f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801513:	52                   	push   %edx
  801514:	50                   	push   %eax
  801515:	ff 75 10             	pushl  0x10(%ebp)
  801518:	ff 75 0c             	pushl  0xc(%ebp)
  80151b:	ff 75 08             	pushl  0x8(%ebp)
  80151e:	6a 27                	push   $0x27
  801520:	e8 17 fb ff ff       	call   80103c <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
	return ;
  801528:	90                   	nop
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <chktst>:
void chktst(uint32 n)
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	6a 29                	push   $0x29
  80153b:	e8 fc fa ff ff       	call   80103c <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
	return ;
  801543:	90                   	nop
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <inctst>:

void inctst()
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 2a                	push   $0x2a
  801555:	e8 e2 fa ff ff       	call   80103c <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
	return ;
  80155d:	90                   	nop
}
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <gettst>:
uint32 gettst()
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 2b                	push   $0x2b
  80156f:	e8 c8 fa ff ff       	call   80103c <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 2c                	push   $0x2c
  80158b:	e8 ac fa ff ff       	call   80103c <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
  801593:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801596:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80159a:	75 07                	jne    8015a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80159c:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a1:	eb 05                	jmp    8015a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 2c                	push   $0x2c
  8015bc:	e8 7b fa ff ff       	call   80103c <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
  8015c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015c7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015cb:	75 07                	jne    8015d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8015d2:	eb 05                	jmp    8015d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 2c                	push   $0x2c
  8015ed:	e8 4a fa ff ff       	call   80103c <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
  8015f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015f8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015fc:	75 07                	jne    801605 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801603:	eb 05                	jmp    80160a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 2c                	push   $0x2c
  80161e:	e8 19 fa ff ff       	call   80103c <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
  801626:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801629:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80162d:	75 07                	jne    801636 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80162f:	b8 01 00 00 00       	mov    $0x1,%eax
  801634:	eb 05                	jmp    80163b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	ff 75 08             	pushl  0x8(%ebp)
  80164b:	6a 2d                	push   $0x2d
  80164d:	e8 ea f9 ff ff       	call   80103c <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
	return ;
  801655:	90                   	nop
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80165c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80165f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801662:	8b 55 0c             	mov    0xc(%ebp),%edx
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	6a 00                	push   $0x0
  80166a:	53                   	push   %ebx
  80166b:	51                   	push   %ecx
  80166c:	52                   	push   %edx
  80166d:	50                   	push   %eax
  80166e:	6a 2e                	push   $0x2e
  801670:	e8 c7 f9 ff ff       	call   80103c <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801680:	8b 55 0c             	mov    0xc(%ebp),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	52                   	push   %edx
  80168d:	50                   	push   %eax
  80168e:	6a 2f                	push   $0x2f
  801690:	e8 a7 f9 ff ff       	call   80103c <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    
  80169a:	66 90                	xchg   %ax,%ax

0080169c <__udivdi3>:
  80169c:	55                   	push   %ebp
  80169d:	57                   	push   %edi
  80169e:	56                   	push   %esi
  80169f:	53                   	push   %ebx
  8016a0:	83 ec 1c             	sub    $0x1c,%esp
  8016a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8016a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8016ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8016af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016b3:	89 ca                	mov    %ecx,%edx
  8016b5:	89 f8                	mov    %edi,%eax
  8016b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8016bb:	85 f6                	test   %esi,%esi
  8016bd:	75 2d                	jne    8016ec <__udivdi3+0x50>
  8016bf:	39 cf                	cmp    %ecx,%edi
  8016c1:	77 65                	ja     801728 <__udivdi3+0x8c>
  8016c3:	89 fd                	mov    %edi,%ebp
  8016c5:	85 ff                	test   %edi,%edi
  8016c7:	75 0b                	jne    8016d4 <__udivdi3+0x38>
  8016c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8016ce:	31 d2                	xor    %edx,%edx
  8016d0:	f7 f7                	div    %edi
  8016d2:	89 c5                	mov    %eax,%ebp
  8016d4:	31 d2                	xor    %edx,%edx
  8016d6:	89 c8                	mov    %ecx,%eax
  8016d8:	f7 f5                	div    %ebp
  8016da:	89 c1                	mov    %eax,%ecx
  8016dc:	89 d8                	mov    %ebx,%eax
  8016de:	f7 f5                	div    %ebp
  8016e0:	89 cf                	mov    %ecx,%edi
  8016e2:	89 fa                	mov    %edi,%edx
  8016e4:	83 c4 1c             	add    $0x1c,%esp
  8016e7:	5b                   	pop    %ebx
  8016e8:	5e                   	pop    %esi
  8016e9:	5f                   	pop    %edi
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    
  8016ec:	39 ce                	cmp    %ecx,%esi
  8016ee:	77 28                	ja     801718 <__udivdi3+0x7c>
  8016f0:	0f bd fe             	bsr    %esi,%edi
  8016f3:	83 f7 1f             	xor    $0x1f,%edi
  8016f6:	75 40                	jne    801738 <__udivdi3+0x9c>
  8016f8:	39 ce                	cmp    %ecx,%esi
  8016fa:	72 0a                	jb     801706 <__udivdi3+0x6a>
  8016fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801700:	0f 87 9e 00 00 00    	ja     8017a4 <__udivdi3+0x108>
  801706:	b8 01 00 00 00       	mov    $0x1,%eax
  80170b:	89 fa                	mov    %edi,%edx
  80170d:	83 c4 1c             	add    $0x1c,%esp
  801710:	5b                   	pop    %ebx
  801711:	5e                   	pop    %esi
  801712:	5f                   	pop    %edi
  801713:	5d                   	pop    %ebp
  801714:	c3                   	ret    
  801715:	8d 76 00             	lea    0x0(%esi),%esi
  801718:	31 ff                	xor    %edi,%edi
  80171a:	31 c0                	xor    %eax,%eax
  80171c:	89 fa                	mov    %edi,%edx
  80171e:	83 c4 1c             	add    $0x1c,%esp
  801721:	5b                   	pop    %ebx
  801722:	5e                   	pop    %esi
  801723:	5f                   	pop    %edi
  801724:	5d                   	pop    %ebp
  801725:	c3                   	ret    
  801726:	66 90                	xchg   %ax,%ax
  801728:	89 d8                	mov    %ebx,%eax
  80172a:	f7 f7                	div    %edi
  80172c:	31 ff                	xor    %edi,%edi
  80172e:	89 fa                	mov    %edi,%edx
  801730:	83 c4 1c             	add    $0x1c,%esp
  801733:	5b                   	pop    %ebx
  801734:	5e                   	pop    %esi
  801735:	5f                   	pop    %edi
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    
  801738:	bd 20 00 00 00       	mov    $0x20,%ebp
  80173d:	89 eb                	mov    %ebp,%ebx
  80173f:	29 fb                	sub    %edi,%ebx
  801741:	89 f9                	mov    %edi,%ecx
  801743:	d3 e6                	shl    %cl,%esi
  801745:	89 c5                	mov    %eax,%ebp
  801747:	88 d9                	mov    %bl,%cl
  801749:	d3 ed                	shr    %cl,%ebp
  80174b:	89 e9                	mov    %ebp,%ecx
  80174d:	09 f1                	or     %esi,%ecx
  80174f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801753:	89 f9                	mov    %edi,%ecx
  801755:	d3 e0                	shl    %cl,%eax
  801757:	89 c5                	mov    %eax,%ebp
  801759:	89 d6                	mov    %edx,%esi
  80175b:	88 d9                	mov    %bl,%cl
  80175d:	d3 ee                	shr    %cl,%esi
  80175f:	89 f9                	mov    %edi,%ecx
  801761:	d3 e2                	shl    %cl,%edx
  801763:	8b 44 24 08          	mov    0x8(%esp),%eax
  801767:	88 d9                	mov    %bl,%cl
  801769:	d3 e8                	shr    %cl,%eax
  80176b:	09 c2                	or     %eax,%edx
  80176d:	89 d0                	mov    %edx,%eax
  80176f:	89 f2                	mov    %esi,%edx
  801771:	f7 74 24 0c          	divl   0xc(%esp)
  801775:	89 d6                	mov    %edx,%esi
  801777:	89 c3                	mov    %eax,%ebx
  801779:	f7 e5                	mul    %ebp
  80177b:	39 d6                	cmp    %edx,%esi
  80177d:	72 19                	jb     801798 <__udivdi3+0xfc>
  80177f:	74 0b                	je     80178c <__udivdi3+0xf0>
  801781:	89 d8                	mov    %ebx,%eax
  801783:	31 ff                	xor    %edi,%edi
  801785:	e9 58 ff ff ff       	jmp    8016e2 <__udivdi3+0x46>
  80178a:	66 90                	xchg   %ax,%ax
  80178c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801790:	89 f9                	mov    %edi,%ecx
  801792:	d3 e2                	shl    %cl,%edx
  801794:	39 c2                	cmp    %eax,%edx
  801796:	73 e9                	jae    801781 <__udivdi3+0xe5>
  801798:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80179b:	31 ff                	xor    %edi,%edi
  80179d:	e9 40 ff ff ff       	jmp    8016e2 <__udivdi3+0x46>
  8017a2:	66 90                	xchg   %ax,%ax
  8017a4:	31 c0                	xor    %eax,%eax
  8017a6:	e9 37 ff ff ff       	jmp    8016e2 <__udivdi3+0x46>
  8017ab:	90                   	nop

008017ac <__umoddi3>:
  8017ac:	55                   	push   %ebp
  8017ad:	57                   	push   %edi
  8017ae:	56                   	push   %esi
  8017af:	53                   	push   %ebx
  8017b0:	83 ec 1c             	sub    $0x1c,%esp
  8017b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8017b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8017bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8017c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017cb:	89 f3                	mov    %esi,%ebx
  8017cd:	89 fa                	mov    %edi,%edx
  8017cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017d3:	89 34 24             	mov    %esi,(%esp)
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	75 1a                	jne    8017f4 <__umoddi3+0x48>
  8017da:	39 f7                	cmp    %esi,%edi
  8017dc:	0f 86 a2 00 00 00    	jbe    801884 <__umoddi3+0xd8>
  8017e2:	89 c8                	mov    %ecx,%eax
  8017e4:	89 f2                	mov    %esi,%edx
  8017e6:	f7 f7                	div    %edi
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	31 d2                	xor    %edx,%edx
  8017ec:	83 c4 1c             	add    $0x1c,%esp
  8017ef:	5b                   	pop    %ebx
  8017f0:	5e                   	pop    %esi
  8017f1:	5f                   	pop    %edi
  8017f2:	5d                   	pop    %ebp
  8017f3:	c3                   	ret    
  8017f4:	39 f0                	cmp    %esi,%eax
  8017f6:	0f 87 ac 00 00 00    	ja     8018a8 <__umoddi3+0xfc>
  8017fc:	0f bd e8             	bsr    %eax,%ebp
  8017ff:	83 f5 1f             	xor    $0x1f,%ebp
  801802:	0f 84 ac 00 00 00    	je     8018b4 <__umoddi3+0x108>
  801808:	bf 20 00 00 00       	mov    $0x20,%edi
  80180d:	29 ef                	sub    %ebp,%edi
  80180f:	89 fe                	mov    %edi,%esi
  801811:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801815:	89 e9                	mov    %ebp,%ecx
  801817:	d3 e0                	shl    %cl,%eax
  801819:	89 d7                	mov    %edx,%edi
  80181b:	89 f1                	mov    %esi,%ecx
  80181d:	d3 ef                	shr    %cl,%edi
  80181f:	09 c7                	or     %eax,%edi
  801821:	89 e9                	mov    %ebp,%ecx
  801823:	d3 e2                	shl    %cl,%edx
  801825:	89 14 24             	mov    %edx,(%esp)
  801828:	89 d8                	mov    %ebx,%eax
  80182a:	d3 e0                	shl    %cl,%eax
  80182c:	89 c2                	mov    %eax,%edx
  80182e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801832:	d3 e0                	shl    %cl,%eax
  801834:	89 44 24 04          	mov    %eax,0x4(%esp)
  801838:	8b 44 24 08          	mov    0x8(%esp),%eax
  80183c:	89 f1                	mov    %esi,%ecx
  80183e:	d3 e8                	shr    %cl,%eax
  801840:	09 d0                	or     %edx,%eax
  801842:	d3 eb                	shr    %cl,%ebx
  801844:	89 da                	mov    %ebx,%edx
  801846:	f7 f7                	div    %edi
  801848:	89 d3                	mov    %edx,%ebx
  80184a:	f7 24 24             	mull   (%esp)
  80184d:	89 c6                	mov    %eax,%esi
  80184f:	89 d1                	mov    %edx,%ecx
  801851:	39 d3                	cmp    %edx,%ebx
  801853:	0f 82 87 00 00 00    	jb     8018e0 <__umoddi3+0x134>
  801859:	0f 84 91 00 00 00    	je     8018f0 <__umoddi3+0x144>
  80185f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801863:	29 f2                	sub    %esi,%edx
  801865:	19 cb                	sbb    %ecx,%ebx
  801867:	89 d8                	mov    %ebx,%eax
  801869:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80186d:	d3 e0                	shl    %cl,%eax
  80186f:	89 e9                	mov    %ebp,%ecx
  801871:	d3 ea                	shr    %cl,%edx
  801873:	09 d0                	or     %edx,%eax
  801875:	89 e9                	mov    %ebp,%ecx
  801877:	d3 eb                	shr    %cl,%ebx
  801879:	89 da                	mov    %ebx,%edx
  80187b:	83 c4 1c             	add    $0x1c,%esp
  80187e:	5b                   	pop    %ebx
  80187f:	5e                   	pop    %esi
  801880:	5f                   	pop    %edi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    
  801883:	90                   	nop
  801884:	89 fd                	mov    %edi,%ebp
  801886:	85 ff                	test   %edi,%edi
  801888:	75 0b                	jne    801895 <__umoddi3+0xe9>
  80188a:	b8 01 00 00 00       	mov    $0x1,%eax
  80188f:	31 d2                	xor    %edx,%edx
  801891:	f7 f7                	div    %edi
  801893:	89 c5                	mov    %eax,%ebp
  801895:	89 f0                	mov    %esi,%eax
  801897:	31 d2                	xor    %edx,%edx
  801899:	f7 f5                	div    %ebp
  80189b:	89 c8                	mov    %ecx,%eax
  80189d:	f7 f5                	div    %ebp
  80189f:	89 d0                	mov    %edx,%eax
  8018a1:	e9 44 ff ff ff       	jmp    8017ea <__umoddi3+0x3e>
  8018a6:	66 90                	xchg   %ax,%ax
  8018a8:	89 c8                	mov    %ecx,%eax
  8018aa:	89 f2                	mov    %esi,%edx
  8018ac:	83 c4 1c             	add    $0x1c,%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5f                   	pop    %edi
  8018b2:	5d                   	pop    %ebp
  8018b3:	c3                   	ret    
  8018b4:	3b 04 24             	cmp    (%esp),%eax
  8018b7:	72 06                	jb     8018bf <__umoddi3+0x113>
  8018b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8018bd:	77 0f                	ja     8018ce <__umoddi3+0x122>
  8018bf:	89 f2                	mov    %esi,%edx
  8018c1:	29 f9                	sub    %edi,%ecx
  8018c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8018c7:	89 14 24             	mov    %edx,(%esp)
  8018ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8018d2:	8b 14 24             	mov    (%esp),%edx
  8018d5:	83 c4 1c             	add    $0x1c,%esp
  8018d8:	5b                   	pop    %ebx
  8018d9:	5e                   	pop    %esi
  8018da:	5f                   	pop    %edi
  8018db:	5d                   	pop    %ebp
  8018dc:	c3                   	ret    
  8018dd:	8d 76 00             	lea    0x0(%esi),%esi
  8018e0:	2b 04 24             	sub    (%esp),%eax
  8018e3:	19 fa                	sbb    %edi,%edx
  8018e5:	89 d1                	mov    %edx,%ecx
  8018e7:	89 c6                	mov    %eax,%esi
  8018e9:	e9 71 ff ff ff       	jmp    80185f <__umoddi3+0xb3>
  8018ee:	66 90                	xchg   %ax,%ax
  8018f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8018f4:	72 ea                	jb     8018e0 <__umoddi3+0x134>
  8018f6:	89 d9                	mov    %ebx,%ecx
  8018f8:	e9 62 ff ff ff       	jmp    80185f <__umoddi3+0xb3>
