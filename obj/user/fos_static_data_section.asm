
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 c0 18 80 00       	push   $0x8018c0
  800046:	e8 43 02 00 00       	call   80028e <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800057:	e8 5b 13 00 00       	call   8013b7 <sys_getenvindex>
  80005c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80005f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800062:	89 d0                	mov    %edx,%eax
  800064:	c1 e0 03             	shl    $0x3,%eax
  800067:	01 d0                	add    %edx,%eax
  800069:	01 c0                	add    %eax,%eax
  80006b:	01 d0                	add    %edx,%eax
  80006d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800074:	01 d0                	add    %edx,%eax
  800076:	c1 e0 04             	shl    $0x4,%eax
  800079:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007e:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800083:	a1 20 20 80 00       	mov    0x802020,%eax
  800088:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80008e:	84 c0                	test   %al,%al
  800090:	74 0f                	je     8000a1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800092:	a1 20 20 80 00       	mov    0x802020,%eax
  800097:	05 5c 05 00 00       	add    $0x55c,%eax
  80009c:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a5:	7e 0a                	jle    8000b1 <libmain+0x60>
		binaryname = argv[0];
  8000a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000aa:	8b 00                	mov    (%eax),%eax
  8000ac:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000b1:	83 ec 08             	sub    $0x8,%esp
  8000b4:	ff 75 0c             	pushl  0xc(%ebp)
  8000b7:	ff 75 08             	pushl  0x8(%ebp)
  8000ba:	e8 79 ff ff ff       	call   800038 <_main>
  8000bf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000c2:	e8 fd 10 00 00       	call   8011c4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	68 04 19 80 00       	push   $0x801904
  8000cf:	e8 8d 01 00 00       	call   800261 <cprintf>
  8000d4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000d7:	a1 20 20 80 00       	mov    0x802020,%eax
  8000dc:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8000e2:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8000ed:	83 ec 04             	sub    $0x4,%esp
  8000f0:	52                   	push   %edx
  8000f1:	50                   	push   %eax
  8000f2:	68 2c 19 80 00       	push   $0x80192c
  8000f7:	e8 65 01 00 00       	call   800261 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8000ff:	a1 20 20 80 00       	mov    0x802020,%eax
  800104:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80010a:	a1 20 20 80 00       	mov    0x802020,%eax
  80010f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800115:	a1 20 20 80 00       	mov    0x802020,%eax
  80011a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800120:	51                   	push   %ecx
  800121:	52                   	push   %edx
  800122:	50                   	push   %eax
  800123:	68 54 19 80 00       	push   $0x801954
  800128:	e8 34 01 00 00       	call   800261 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800130:	a1 20 20 80 00       	mov    0x802020,%eax
  800135:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80013b:	83 ec 08             	sub    $0x8,%esp
  80013e:	50                   	push   %eax
  80013f:	68 ac 19 80 00       	push   $0x8019ac
  800144:	e8 18 01 00 00       	call   800261 <cprintf>
  800149:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	68 04 19 80 00       	push   $0x801904
  800154:	e8 08 01 00 00       	call   800261 <cprintf>
  800159:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80015c:	e8 7d 10 00 00       	call   8011de <sys_enable_interrupt>

	// exit gracefully
	exit();
  800161:	e8 19 00 00 00       	call   80017f <exit>
}
  800166:	90                   	nop
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80016f:	83 ec 0c             	sub    $0xc,%esp
  800172:	6a 00                	push   $0x0
  800174:	e8 0a 12 00 00       	call   801383 <sys_destroy_env>
  800179:	83 c4 10             	add    $0x10,%esp
}
  80017c:	90                   	nop
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    

0080017f <exit>:

void
exit(void)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800185:	e8 5f 12 00 00       	call   8013e9 <sys_exit_env>
}
  80018a:	90                   	nop
  80018b:	c9                   	leave  
  80018c:	c3                   	ret    

0080018d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800193:	8b 45 0c             	mov    0xc(%ebp),%eax
  800196:	8b 00                	mov    (%eax),%eax
  800198:	8d 48 01             	lea    0x1(%eax),%ecx
  80019b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019e:	89 0a                	mov    %ecx,(%edx)
  8001a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a3:	88 d1                	mov    %dl,%cl
  8001a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001af:	8b 00                	mov    (%eax),%eax
  8001b1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b6:	75 2c                	jne    8001e4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001b8:	a0 24 20 80 00       	mov    0x802024,%al
  8001bd:	0f b6 c0             	movzbl %al,%eax
  8001c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c3:	8b 12                	mov    (%edx),%edx
  8001c5:	89 d1                	mov    %edx,%ecx
  8001c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ca:	83 c2 08             	add    $0x8,%edx
  8001cd:	83 ec 04             	sub    $0x4,%esp
  8001d0:	50                   	push   %eax
  8001d1:	51                   	push   %ecx
  8001d2:	52                   	push   %edx
  8001d3:	e8 3e 0e 00 00       	call   801016 <sys_cputs>
  8001d8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e7:	8b 40 04             	mov    0x4(%eax),%eax
  8001ea:	8d 50 01             	lea    0x1(%eax),%edx
  8001ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001f3:	90                   	nop
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ff:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800206:	00 00 00 
	b.cnt = 0;
  800209:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800210:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800213:	ff 75 0c             	pushl  0xc(%ebp)
  800216:	ff 75 08             	pushl  0x8(%ebp)
  800219:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021f:	50                   	push   %eax
  800220:	68 8d 01 80 00       	push   $0x80018d
  800225:	e8 11 02 00 00       	call   80043b <vprintfmt>
  80022a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80022d:	a0 24 20 80 00       	mov    0x802024,%al
  800232:	0f b6 c0             	movzbl %al,%eax
  800235:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80023b:	83 ec 04             	sub    $0x4,%esp
  80023e:	50                   	push   %eax
  80023f:	52                   	push   %edx
  800240:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800246:	83 c0 08             	add    $0x8,%eax
  800249:	50                   	push   %eax
  80024a:	e8 c7 0d 00 00       	call   801016 <sys_cputs>
  80024f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800252:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  800259:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <cprintf>:

int cprintf(const char *fmt, ...) {
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800267:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  80026e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800271:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800274:	8b 45 08             	mov    0x8(%ebp),%eax
  800277:	83 ec 08             	sub    $0x8,%esp
  80027a:	ff 75 f4             	pushl  -0xc(%ebp)
  80027d:	50                   	push   %eax
  80027e:	e8 73 ff ff ff       	call   8001f6 <vcprintf>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800289:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80028c:	c9                   	leave  
  80028d:	c3                   	ret    

0080028e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80028e:	55                   	push   %ebp
  80028f:	89 e5                	mov    %esp,%ebp
  800291:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800294:	e8 2b 0f 00 00       	call   8011c4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800299:	8d 45 0c             	lea    0xc(%ebp),%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80029f:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a8:	50                   	push   %eax
  8002a9:	e8 48 ff ff ff       	call   8001f6 <vcprintf>
  8002ae:	83 c4 10             	add    $0x10,%esp
  8002b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002b4:	e8 25 0f 00 00       	call   8011de <sys_enable_interrupt>
	return cnt;
  8002b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002bc:	c9                   	leave  
  8002bd:	c3                   	ret    

008002be <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 14             	sub    $0x14,%esp
  8002c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8002d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002dc:	77 55                	ja     800333 <printnum+0x75>
  8002de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e1:	72 05                	jb     8002e8 <printnum+0x2a>
  8002e3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e6:	77 4b                	ja     800333 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002e8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002eb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002ee:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f6:	52                   	push   %edx
  8002f7:	50                   	push   %eax
  8002f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8002fe:	e8 49 13 00 00       	call   80164c <__udivdi3>
  800303:	83 c4 10             	add    $0x10,%esp
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	ff 75 20             	pushl  0x20(%ebp)
  80030c:	53                   	push   %ebx
  80030d:	ff 75 18             	pushl  0x18(%ebp)
  800310:	52                   	push   %edx
  800311:	50                   	push   %eax
  800312:	ff 75 0c             	pushl  0xc(%ebp)
  800315:	ff 75 08             	pushl  0x8(%ebp)
  800318:	e8 a1 ff ff ff       	call   8002be <printnum>
  80031d:	83 c4 20             	add    $0x20,%esp
  800320:	eb 1a                	jmp    80033c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800322:	83 ec 08             	sub    $0x8,%esp
  800325:	ff 75 0c             	pushl  0xc(%ebp)
  800328:	ff 75 20             	pushl  0x20(%ebp)
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	ff d0                	call   *%eax
  800330:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800333:	ff 4d 1c             	decl   0x1c(%ebp)
  800336:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80033a:	7f e6                	jg     800322 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80033f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800347:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80034a:	53                   	push   %ebx
  80034b:	51                   	push   %ecx
  80034c:	52                   	push   %edx
  80034d:	50                   	push   %eax
  80034e:	e8 09 14 00 00       	call   80175c <__umoddi3>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	05 d4 1b 80 00       	add    $0x801bd4,%eax
  80035b:	8a 00                	mov    (%eax),%al
  80035d:	0f be c0             	movsbl %al,%eax
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	ff 75 0c             	pushl  0xc(%ebp)
  800366:	50                   	push   %eax
  800367:	8b 45 08             	mov    0x8(%ebp),%eax
  80036a:	ff d0                	call   *%eax
  80036c:	83 c4 10             	add    $0x10,%esp
}
  80036f:	90                   	nop
  800370:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800378:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80037c:	7e 1c                	jle    80039a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80037e:	8b 45 08             	mov    0x8(%ebp),%eax
  800381:	8b 00                	mov    (%eax),%eax
  800383:	8d 50 08             	lea    0x8(%eax),%edx
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	89 10                	mov    %edx,(%eax)
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	83 e8 08             	sub    $0x8,%eax
  800393:	8b 50 04             	mov    0x4(%eax),%edx
  800396:	8b 00                	mov    (%eax),%eax
  800398:	eb 40                	jmp    8003da <getuint+0x65>
	else if (lflag)
  80039a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80039e:	74 1e                	je     8003be <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a3:	8b 00                	mov    (%eax),%eax
  8003a5:	8d 50 04             	lea    0x4(%eax),%edx
  8003a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ab:	89 10                	mov    %edx,(%eax)
  8003ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b0:	8b 00                	mov    (%eax),%eax
  8003b2:	83 e8 04             	sub    $0x4,%eax
  8003b5:	8b 00                	mov    (%eax),%eax
  8003b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bc:	eb 1c                	jmp    8003da <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	8d 50 04             	lea    0x4(%eax),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	89 10                	mov    %edx,(%eax)
  8003cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ce:	8b 00                	mov    (%eax),%eax
  8003d0:	83 e8 04             	sub    $0x4,%eax
  8003d3:	8b 00                	mov    (%eax),%eax
  8003d5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003da:	5d                   	pop    %ebp
  8003db:	c3                   	ret    

008003dc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e3:	7e 1c                	jle    800401 <getint+0x25>
		return va_arg(*ap, long long);
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	8d 50 08             	lea    0x8(%eax),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	89 10                	mov    %edx,(%eax)
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	83 e8 08             	sub    $0x8,%eax
  8003fa:	8b 50 04             	mov    0x4(%eax),%edx
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	eb 38                	jmp    800439 <getint+0x5d>
	else if (lflag)
  800401:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800405:	74 1a                	je     800421 <getint+0x45>
		return va_arg(*ap, long);
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	8d 50 04             	lea    0x4(%eax),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	89 10                	mov    %edx,(%eax)
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	8b 00                	mov    (%eax),%eax
  800419:	83 e8 04             	sub    $0x4,%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	99                   	cltd   
  80041f:	eb 18                	jmp    800439 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800421:	8b 45 08             	mov    0x8(%ebp),%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	8d 50 04             	lea    0x4(%eax),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	89 10                	mov    %edx,(%eax)
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	8b 00                	mov    (%eax),%eax
  800433:	83 e8 04             	sub    $0x4,%eax
  800436:	8b 00                	mov    (%eax),%eax
  800438:	99                   	cltd   
}
  800439:	5d                   	pop    %ebp
  80043a:	c3                   	ret    

0080043b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	56                   	push   %esi
  80043f:	53                   	push   %ebx
  800440:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800443:	eb 17                	jmp    80045c <vprintfmt+0x21>
			if (ch == '\0')
  800445:	85 db                	test   %ebx,%ebx
  800447:	0f 84 af 03 00 00    	je     8007fc <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	ff 75 0c             	pushl  0xc(%ebp)
  800453:	53                   	push   %ebx
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	ff d0                	call   *%eax
  800459:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80045c:	8b 45 10             	mov    0x10(%ebp),%eax
  80045f:	8d 50 01             	lea    0x1(%eax),%edx
  800462:	89 55 10             	mov    %edx,0x10(%ebp)
  800465:	8a 00                	mov    (%eax),%al
  800467:	0f b6 d8             	movzbl %al,%ebx
  80046a:	83 fb 25             	cmp    $0x25,%ebx
  80046d:	75 d6                	jne    800445 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80046f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800473:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80047a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800481:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800488:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048f:	8b 45 10             	mov    0x10(%ebp),%eax
  800492:	8d 50 01             	lea    0x1(%eax),%edx
  800495:	89 55 10             	mov    %edx,0x10(%ebp)
  800498:	8a 00                	mov    (%eax),%al
  80049a:	0f b6 d8             	movzbl %al,%ebx
  80049d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004a0:	83 f8 55             	cmp    $0x55,%eax
  8004a3:	0f 87 2b 03 00 00    	ja     8007d4 <vprintfmt+0x399>
  8004a9:	8b 04 85 f8 1b 80 00 	mov    0x801bf8(,%eax,4),%eax
  8004b0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004b2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004b6:	eb d7                	jmp    80048f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004b8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004bc:	eb d1                	jmp    80048f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c8:	89 d0                	mov    %edx,%eax
  8004ca:	c1 e0 02             	shl    $0x2,%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	01 c0                	add    %eax,%eax
  8004d1:	01 d8                	add    %ebx,%eax
  8004d3:	83 e8 30             	sub    $0x30,%eax
  8004d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8004dc:	8a 00                	mov    (%eax),%al
  8004de:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004e1:	83 fb 2f             	cmp    $0x2f,%ebx
  8004e4:	7e 3e                	jle    800524 <vprintfmt+0xe9>
  8004e6:	83 fb 39             	cmp    $0x39,%ebx
  8004e9:	7f 39                	jg     800524 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004eb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004ee:	eb d5                	jmp    8004c5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f3:	83 c0 04             	add    $0x4,%eax
  8004f6:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	83 e8 04             	sub    $0x4,%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800504:	eb 1f                	jmp    800525 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800506:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80050a:	79 83                	jns    80048f <vprintfmt+0x54>
				width = 0;
  80050c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800513:	e9 77 ff ff ff       	jmp    80048f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800518:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80051f:	e9 6b ff ff ff       	jmp    80048f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800524:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800525:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800529:	0f 89 60 ff ff ff    	jns    80048f <vprintfmt+0x54>
				width = precision, precision = -1;
  80052f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800532:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800535:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80053c:	e9 4e ff ff ff       	jmp    80048f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800541:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800544:	e9 46 ff ff ff       	jmp    80048f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800549:	8b 45 14             	mov    0x14(%ebp),%eax
  80054c:	83 c0 04             	add    $0x4,%eax
  80054f:	89 45 14             	mov    %eax,0x14(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	83 e8 04             	sub    $0x4,%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 0c             	pushl  0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	8b 45 08             	mov    0x8(%ebp),%eax
  800564:	ff d0                	call   *%eax
  800566:	83 c4 10             	add    $0x10,%esp
			break;
  800569:	e9 89 02 00 00       	jmp    8007f7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	83 c0 04             	add    $0x4,%eax
  800574:	89 45 14             	mov    %eax,0x14(%ebp)
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	83 e8 04             	sub    $0x4,%eax
  80057d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80057f:	85 db                	test   %ebx,%ebx
  800581:	79 02                	jns    800585 <vprintfmt+0x14a>
				err = -err;
  800583:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800585:	83 fb 64             	cmp    $0x64,%ebx
  800588:	7f 0b                	jg     800595 <vprintfmt+0x15a>
  80058a:	8b 34 9d 40 1a 80 00 	mov    0x801a40(,%ebx,4),%esi
  800591:	85 f6                	test   %esi,%esi
  800593:	75 19                	jne    8005ae <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800595:	53                   	push   %ebx
  800596:	68 e5 1b 80 00       	push   $0x801be5
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	ff 75 08             	pushl  0x8(%ebp)
  8005a1:	e8 5e 02 00 00       	call   800804 <printfmt>
  8005a6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005a9:	e9 49 02 00 00       	jmp    8007f7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005ae:	56                   	push   %esi
  8005af:	68 ee 1b 80 00       	push   $0x801bee
  8005b4:	ff 75 0c             	pushl  0xc(%ebp)
  8005b7:	ff 75 08             	pushl  0x8(%ebp)
  8005ba:	e8 45 02 00 00       	call   800804 <printfmt>
  8005bf:	83 c4 10             	add    $0x10,%esp
			break;
  8005c2:	e9 30 02 00 00       	jmp    8007f7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	83 c0 04             	add    $0x4,%eax
  8005cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	83 e8 04             	sub    $0x4,%eax
  8005d6:	8b 30                	mov    (%eax),%esi
  8005d8:	85 f6                	test   %esi,%esi
  8005da:	75 05                	jne    8005e1 <vprintfmt+0x1a6>
				p = "(null)";
  8005dc:	be f1 1b 80 00       	mov    $0x801bf1,%esi
			if (width > 0 && padc != '-')
  8005e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e5:	7e 6d                	jle    800654 <vprintfmt+0x219>
  8005e7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005eb:	74 67                	je     800654 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	50                   	push   %eax
  8005f4:	56                   	push   %esi
  8005f5:	e8 0c 03 00 00       	call   800906 <strnlen>
  8005fa:	83 c4 10             	add    $0x10,%esp
  8005fd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800600:	eb 16                	jmp    800618 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800602:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	ff 75 0c             	pushl  0xc(%ebp)
  80060c:	50                   	push   %eax
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	ff d0                	call   *%eax
  800612:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800615:	ff 4d e4             	decl   -0x1c(%ebp)
  800618:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061c:	7f e4                	jg     800602 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061e:	eb 34                	jmp    800654 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800620:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800624:	74 1c                	je     800642 <vprintfmt+0x207>
  800626:	83 fb 1f             	cmp    $0x1f,%ebx
  800629:	7e 05                	jle    800630 <vprintfmt+0x1f5>
  80062b:	83 fb 7e             	cmp    $0x7e,%ebx
  80062e:	7e 12                	jle    800642 <vprintfmt+0x207>
					putch('?', putdat);
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	6a 3f                	push   $0x3f
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	ff d0                	call   *%eax
  80063d:	83 c4 10             	add    $0x10,%esp
  800640:	eb 0f                	jmp    800651 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	53                   	push   %ebx
  800649:	8b 45 08             	mov    0x8(%ebp),%eax
  80064c:	ff d0                	call   *%eax
  80064e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800651:	ff 4d e4             	decl   -0x1c(%ebp)
  800654:	89 f0                	mov    %esi,%eax
  800656:	8d 70 01             	lea    0x1(%eax),%esi
  800659:	8a 00                	mov    (%eax),%al
  80065b:	0f be d8             	movsbl %al,%ebx
  80065e:	85 db                	test   %ebx,%ebx
  800660:	74 24                	je     800686 <vprintfmt+0x24b>
  800662:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800666:	78 b8                	js     800620 <vprintfmt+0x1e5>
  800668:	ff 4d e0             	decl   -0x20(%ebp)
  80066b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066f:	79 af                	jns    800620 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800671:	eb 13                	jmp    800686 <vprintfmt+0x24b>
				putch(' ', putdat);
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 0c             	pushl  0xc(%ebp)
  800679:	6a 20                	push   $0x20
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800683:	ff 4d e4             	decl   -0x1c(%ebp)
  800686:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068a:	7f e7                	jg     800673 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80068c:	e9 66 01 00 00       	jmp    8007f7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800691:	83 ec 08             	sub    $0x8,%esp
  800694:	ff 75 e8             	pushl  -0x18(%ebp)
  800697:	8d 45 14             	lea    0x14(%ebp),%eax
  80069a:	50                   	push   %eax
  80069b:	e8 3c fd ff ff       	call   8003dc <getint>
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006af:	85 d2                	test   %edx,%edx
  8006b1:	79 23                	jns    8006d6 <vprintfmt+0x29b>
				putch('-', putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	6a 2d                	push   $0x2d
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	ff d0                	call   *%eax
  8006c0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c9:	f7 d8                	neg    %eax
  8006cb:	83 d2 00             	adc    $0x0,%edx
  8006ce:	f7 da                	neg    %edx
  8006d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006dd:	e9 bc 00 00 00       	jmp    80079e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8006e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8006eb:	50                   	push   %eax
  8006ec:	e8 84 fc ff ff       	call   800375 <getuint>
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800701:	e9 98 00 00 00       	jmp    80079e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	6a 58                	push   $0x58
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800716:	83 ec 08             	sub    $0x8,%esp
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	6a 58                	push   $0x58
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	ff 75 0c             	pushl  0xc(%ebp)
  80072c:	6a 58                	push   $0x58
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	ff d0                	call   *%eax
  800733:	83 c4 10             	add    $0x10,%esp
			break;
  800736:	e9 bc 00 00 00       	jmp    8007f7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	ff 75 0c             	pushl  0xc(%ebp)
  800741:	6a 30                	push   $0x30
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	ff d0                	call   *%eax
  800748:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	6a 78                	push   $0x78
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
  800758:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	83 c0 04             	add    $0x4,%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	83 e8 04             	sub    $0x4,%eax
  80076a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80076c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800776:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80077d:	eb 1f                	jmp    80079e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 e8             	pushl  -0x18(%ebp)
  800785:	8d 45 14             	lea    0x14(%ebp),%eax
  800788:	50                   	push   %eax
  800789:	e8 e7 fb ff ff       	call   800375 <getuint>
  80078e:	83 c4 10             	add    $0x10,%esp
  800791:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800794:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800797:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80079e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	52                   	push   %edx
  8007a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007ac:	50                   	push   %eax
  8007ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	e8 00 fb ff ff       	call   8002be <printnum>
  8007be:	83 c4 20             	add    $0x20,%esp
			break;
  8007c1:	eb 34                	jmp    8007f7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	53                   	push   %ebx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	ff d0                	call   *%eax
  8007cf:	83 c4 10             	add    $0x10,%esp
			break;
  8007d2:	eb 23                	jmp    8007f7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007d4:	83 ec 08             	sub    $0x8,%esp
  8007d7:	ff 75 0c             	pushl  0xc(%ebp)
  8007da:	6a 25                	push   $0x25
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e4:	ff 4d 10             	decl   0x10(%ebp)
  8007e7:	eb 03                	jmp    8007ec <vprintfmt+0x3b1>
  8007e9:	ff 4d 10             	decl   0x10(%ebp)
  8007ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ef:	48                   	dec    %eax
  8007f0:	8a 00                	mov    (%eax),%al
  8007f2:	3c 25                	cmp    $0x25,%al
  8007f4:	75 f3                	jne    8007e9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007f6:	90                   	nop
		}
	}
  8007f7:	e9 47 fc ff ff       	jmp    800443 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007fc:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8007fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800800:	5b                   	pop    %ebx
  800801:	5e                   	pop    %esi
  800802:	5d                   	pop    %ebp
  800803:	c3                   	ret    

00800804 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80080a:	8d 45 10             	lea    0x10(%ebp),%eax
  80080d:	83 c0 04             	add    $0x4,%eax
  800810:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800813:	8b 45 10             	mov    0x10(%ebp),%eax
  800816:	ff 75 f4             	pushl  -0xc(%ebp)
  800819:	50                   	push   %eax
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 16 fc ff ff       	call   80043b <vprintfmt>
  800825:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800828:	90                   	nop
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80082e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800831:	8b 40 08             	mov    0x8(%eax),%eax
  800834:	8d 50 01             	lea    0x1(%eax),%edx
  800837:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80083d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800840:	8b 10                	mov    (%eax),%edx
  800842:	8b 45 0c             	mov    0xc(%ebp),%eax
  800845:	8b 40 04             	mov    0x4(%eax),%eax
  800848:	39 c2                	cmp    %eax,%edx
  80084a:	73 12                	jae    80085e <sprintputch+0x33>
		*b->buf++ = ch;
  80084c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084f:	8b 00                	mov    (%eax),%eax
  800851:	8d 48 01             	lea    0x1(%eax),%ecx
  800854:	8b 55 0c             	mov    0xc(%ebp),%edx
  800857:	89 0a                	mov    %ecx,(%edx)
  800859:	8b 55 08             	mov    0x8(%ebp),%edx
  80085c:	88 10                	mov    %dl,(%eax)
}
  80085e:	90                   	nop
  80085f:	5d                   	pop    %ebp
  800860:	c3                   	ret    

00800861 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80086d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800870:	8d 50 ff             	lea    -0x1(%eax),%edx
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	01 d0                	add    %edx,%eax
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800882:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800886:	74 06                	je     80088e <vsnprintf+0x2d>
  800888:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088c:	7f 07                	jg     800895 <vsnprintf+0x34>
		return -E_INVAL;
  80088e:	b8 03 00 00 00       	mov    $0x3,%eax
  800893:	eb 20                	jmp    8008b5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800895:	ff 75 14             	pushl  0x14(%ebp)
  800898:	ff 75 10             	pushl  0x10(%ebp)
  80089b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089e:	50                   	push   %eax
  80089f:	68 2b 08 80 00       	push   $0x80082b
  8008a4:	e8 92 fb ff ff       	call   80043b <vprintfmt>
  8008a9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008af:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008b5:	c9                   	leave  
  8008b6:	c3                   	ret    

008008b7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008bd:	8d 45 10             	lea    0x10(%ebp),%eax
  8008c0:	83 c0 04             	add    $0x4,%eax
  8008c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cc:	50                   	push   %eax
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 89 ff ff ff       	call   800861 <vsnprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
  8008db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    

008008e3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008f0:	eb 06                	jmp    8008f8 <strlen+0x15>
		n++;
  8008f2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f5:	ff 45 08             	incl   0x8(%ebp)
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8a 00                	mov    (%eax),%al
  8008fd:	84 c0                	test   %al,%al
  8008ff:	75 f1                	jne    8008f2 <strlen+0xf>
		n++;
	return n;
  800901:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800913:	eb 09                	jmp    80091e <strnlen+0x18>
		n++;
  800915:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800918:	ff 45 08             	incl   0x8(%ebp)
  80091b:	ff 4d 0c             	decl   0xc(%ebp)
  80091e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800922:	74 09                	je     80092d <strnlen+0x27>
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	8a 00                	mov    (%eax),%al
  800929:	84 c0                	test   %al,%al
  80092b:	75 e8                	jne    800915 <strnlen+0xf>
		n++;
	return n;
  80092d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800930:	c9                   	leave  
  800931:	c3                   	ret    

00800932 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80093e:	90                   	nop
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8d 50 01             	lea    0x1(%eax),%edx
  800945:	89 55 08             	mov    %edx,0x8(%ebp)
  800948:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80094e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800951:	8a 12                	mov    (%edx),%dl
  800953:	88 10                	mov    %dl,(%eax)
  800955:	8a 00                	mov    (%eax),%al
  800957:	84 c0                	test   %al,%al
  800959:	75 e4                	jne    80093f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80095b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80096c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800973:	eb 1f                	jmp    800994 <strncpy+0x34>
		*dst++ = *src;
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	8d 50 01             	lea    0x1(%eax),%edx
  80097b:	89 55 08             	mov    %edx,0x8(%ebp)
  80097e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800981:	8a 12                	mov    (%edx),%dl
  800983:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800985:	8b 45 0c             	mov    0xc(%ebp),%eax
  800988:	8a 00                	mov    (%eax),%al
  80098a:	84 c0                	test   %al,%al
  80098c:	74 03                	je     800991 <strncpy+0x31>
			src++;
  80098e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800991:	ff 45 fc             	incl   -0x4(%ebp)
  800994:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800997:	3b 45 10             	cmp    0x10(%ebp),%eax
  80099a:	72 d9                	jb     800975 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80099c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009b1:	74 30                	je     8009e3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009b3:	eb 16                	jmp    8009cb <strlcpy+0x2a>
			*dst++ = *src++;
  8009b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b8:	8d 50 01             	lea    0x1(%eax),%edx
  8009bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009c4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009c7:	8a 12                	mov    (%edx),%dl
  8009c9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009cb:	ff 4d 10             	decl   0x10(%ebp)
  8009ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009d2:	74 09                	je     8009dd <strlcpy+0x3c>
  8009d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d7:	8a 00                	mov    (%eax),%al
  8009d9:	84 c0                	test   %al,%al
  8009db:	75 d8                	jne    8009b5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009e9:	29 c2                	sub    %eax,%edx
  8009eb:	89 d0                	mov    %edx,%eax
}
  8009ed:	c9                   	leave  
  8009ee:	c3                   	ret    

008009ef <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009f2:	eb 06                	jmp    8009fa <strcmp+0xb>
		p++, q++;
  8009f4:	ff 45 08             	incl   0x8(%ebp)
  8009f7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fd:	8a 00                	mov    (%eax),%al
  8009ff:	84 c0                	test   %al,%al
  800a01:	74 0e                	je     800a11 <strcmp+0x22>
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8a 10                	mov    (%eax),%dl
  800a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0b:	8a 00                	mov    (%eax),%al
  800a0d:	38 c2                	cmp    %al,%dl
  800a0f:	74 e3                	je     8009f4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8a 00                	mov    (%eax),%al
  800a16:	0f b6 d0             	movzbl %al,%edx
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	8a 00                	mov    (%eax),%al
  800a1e:	0f b6 c0             	movzbl %al,%eax
  800a21:	29 c2                	sub    %eax,%edx
  800a23:	89 d0                	mov    %edx,%eax
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a2a:	eb 09                	jmp    800a35 <strncmp+0xe>
		n--, p++, q++;
  800a2c:	ff 4d 10             	decl   0x10(%ebp)
  800a2f:	ff 45 08             	incl   0x8(%ebp)
  800a32:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a39:	74 17                	je     800a52 <strncmp+0x2b>
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	8a 00                	mov    (%eax),%al
  800a40:	84 c0                	test   %al,%al
  800a42:	74 0e                	je     800a52 <strncmp+0x2b>
  800a44:	8b 45 08             	mov    0x8(%ebp),%eax
  800a47:	8a 10                	mov    (%eax),%dl
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	8a 00                	mov    (%eax),%al
  800a4e:	38 c2                	cmp    %al,%dl
  800a50:	74 da                	je     800a2c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a56:	75 07                	jne    800a5f <strncmp+0x38>
		return 0;
  800a58:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5d:	eb 14                	jmp    800a73 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8a 00                	mov    (%eax),%al
  800a64:	0f b6 d0             	movzbl %al,%edx
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	8a 00                	mov    (%eax),%al
  800a6c:	0f b6 c0             	movzbl %al,%eax
  800a6f:	29 c2                	sub    %eax,%edx
  800a71:	89 d0                	mov    %edx,%eax
}
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 04             	sub    $0x4,%esp
  800a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a81:	eb 12                	jmp    800a95 <strchr+0x20>
		if (*s == c)
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8a 00                	mov    (%eax),%al
  800a88:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a8b:	75 05                	jne    800a92 <strchr+0x1d>
			return (char *) s;
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	eb 11                	jmp    800aa3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a92:	ff 45 08             	incl   0x8(%ebp)
  800a95:	8b 45 08             	mov    0x8(%ebp),%eax
  800a98:	8a 00                	mov    (%eax),%al
  800a9a:	84 c0                	test   %al,%al
  800a9c:	75 e5                	jne    800a83 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800a9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa3:	c9                   	leave  
  800aa4:	c3                   	ret    

00800aa5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 04             	sub    $0x4,%esp
  800aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ab1:	eb 0d                	jmp    800ac0 <strfind+0x1b>
		if (*s == c)
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8a 00                	mov    (%eax),%al
  800ab8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800abb:	74 0e                	je     800acb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800abd:	ff 45 08             	incl   0x8(%ebp)
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8a 00                	mov    (%eax),%al
  800ac5:	84 c0                	test   %al,%al
  800ac7:	75 ea                	jne    800ab3 <strfind+0xe>
  800ac9:	eb 01                	jmp    800acc <strfind+0x27>
		if (*s == c)
			break;
  800acb:	90                   	nop
	return (char *) s;
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800acf:	c9                   	leave  
  800ad0:	c3                   	ret    

00800ad1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ad1:	55                   	push   %ebp
  800ad2:	89 e5                	mov    %esp,%ebp
  800ad4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800add:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ae3:	eb 0e                	jmp    800af3 <memset+0x22>
		*p++ = c;
  800ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ae8:	8d 50 01             	lea    0x1(%eax),%edx
  800aeb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800af3:	ff 4d f8             	decl   -0x8(%ebp)
  800af6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800afa:	79 e9                	jns    800ae5 <memset+0x14>
		*p++ = c;

	return v;
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800aff:	c9                   	leave  
  800b00:	c3                   	ret    

00800b01 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b01:	55                   	push   %ebp
  800b02:	89 e5                	mov    %esp,%ebp
  800b04:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b13:	eb 16                	jmp    800b2b <memcpy+0x2a>
		*d++ = *s++;
  800b15:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b18:	8d 50 01             	lea    0x1(%eax),%edx
  800b1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b21:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b24:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b27:	8a 12                	mov    (%edx),%dl
  800b29:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b31:	89 55 10             	mov    %edx,0x10(%ebp)
  800b34:	85 c0                	test   %eax,%eax
  800b36:	75 dd                	jne    800b15 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b3b:	c9                   	leave  
  800b3c:	c3                   	ret    

00800b3d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b52:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b55:	73 50                	jae    800ba7 <memmove+0x6a>
  800b57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5d:	01 d0                	add    %edx,%eax
  800b5f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b62:	76 43                	jbe    800ba7 <memmove+0x6a>
		s += n;
  800b64:	8b 45 10             	mov    0x10(%ebp),%eax
  800b67:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b70:	eb 10                	jmp    800b82 <memmove+0x45>
			*--d = *--s;
  800b72:	ff 4d f8             	decl   -0x8(%ebp)
  800b75:	ff 4d fc             	decl   -0x4(%ebp)
  800b78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7b:	8a 10                	mov    (%eax),%dl
  800b7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b80:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b82:	8b 45 10             	mov    0x10(%ebp),%eax
  800b85:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b88:	89 55 10             	mov    %edx,0x10(%ebp)
  800b8b:	85 c0                	test   %eax,%eax
  800b8d:	75 e3                	jne    800b72 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b8f:	eb 23                	jmp    800bb4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b94:	8d 50 01             	lea    0x1(%eax),%edx
  800b97:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ba0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ba3:	8a 12                	mov    (%edx),%dl
  800ba5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ba7:	8b 45 10             	mov    0x10(%ebp),%eax
  800baa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bad:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb0:	85 c0                	test   %eax,%eax
  800bb2:	75 dd                	jne    800b91 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb7:	c9                   	leave  
  800bb8:	c3                   	ret    

00800bb9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bcb:	eb 2a                	jmp    800bf7 <memcmp+0x3e>
		if (*s1 != *s2)
  800bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd0:	8a 10                	mov    (%eax),%dl
  800bd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	38 c2                	cmp    %al,%dl
  800bd9:	74 16                	je     800bf1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 d0             	movzbl %al,%edx
  800be3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	0f b6 c0             	movzbl %al,%eax
  800beb:	29 c2                	sub    %eax,%edx
  800bed:	89 d0                	mov    %edx,%eax
  800bef:	eb 18                	jmp    800c09 <memcmp+0x50>
		s1++, s2++;
  800bf1:	ff 45 fc             	incl   -0x4(%ebp)
  800bf4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfd:	89 55 10             	mov    %edx,0x10(%ebp)
  800c00:	85 c0                	test   %eax,%eax
  800c02:	75 c9                	jne    800bcd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c11:	8b 55 08             	mov    0x8(%ebp),%edx
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	01 d0                	add    %edx,%eax
  800c19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c1c:	eb 15                	jmp    800c33 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	8a 00                	mov    (%eax),%al
  800c23:	0f b6 d0             	movzbl %al,%edx
  800c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c29:	0f b6 c0             	movzbl %al,%eax
  800c2c:	39 c2                	cmp    %eax,%edx
  800c2e:	74 0d                	je     800c3d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c30:	ff 45 08             	incl   0x8(%ebp)
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c39:	72 e3                	jb     800c1e <memfind+0x13>
  800c3b:	eb 01                	jmp    800c3e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c3d:	90                   	nop
	return (void *) s;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c49:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c50:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c57:	eb 03                	jmp    800c5c <strtol+0x19>
		s++;
  800c59:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	8a 00                	mov    (%eax),%al
  800c61:	3c 20                	cmp    $0x20,%al
  800c63:	74 f4                	je     800c59 <strtol+0x16>
  800c65:	8b 45 08             	mov    0x8(%ebp),%eax
  800c68:	8a 00                	mov    (%eax),%al
  800c6a:	3c 09                	cmp    $0x9,%al
  800c6c:	74 eb                	je     800c59 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8a 00                	mov    (%eax),%al
  800c73:	3c 2b                	cmp    $0x2b,%al
  800c75:	75 05                	jne    800c7c <strtol+0x39>
		s++;
  800c77:	ff 45 08             	incl   0x8(%ebp)
  800c7a:	eb 13                	jmp    800c8f <strtol+0x4c>
	else if (*s == '-')
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	3c 2d                	cmp    $0x2d,%al
  800c83:	75 0a                	jne    800c8f <strtol+0x4c>
		s++, neg = 1;
  800c85:	ff 45 08             	incl   0x8(%ebp)
  800c88:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c93:	74 06                	je     800c9b <strtol+0x58>
  800c95:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c99:	75 20                	jne    800cbb <strtol+0x78>
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	8a 00                	mov    (%eax),%al
  800ca0:	3c 30                	cmp    $0x30,%al
  800ca2:	75 17                	jne    800cbb <strtol+0x78>
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	40                   	inc    %eax
  800ca8:	8a 00                	mov    (%eax),%al
  800caa:	3c 78                	cmp    $0x78,%al
  800cac:	75 0d                	jne    800cbb <strtol+0x78>
		s += 2, base = 16;
  800cae:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cb2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cb9:	eb 28                	jmp    800ce3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbf:	75 15                	jne    800cd6 <strtol+0x93>
  800cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	3c 30                	cmp    $0x30,%al
  800cc8:	75 0c                	jne    800cd6 <strtol+0x93>
		s++, base = 8;
  800cca:	ff 45 08             	incl   0x8(%ebp)
  800ccd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cd4:	eb 0d                	jmp    800ce3 <strtol+0xa0>
	else if (base == 0)
  800cd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cda:	75 07                	jne    800ce3 <strtol+0xa0>
		base = 10;
  800cdc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	3c 2f                	cmp    $0x2f,%al
  800cea:	7e 19                	jle    800d05 <strtol+0xc2>
  800cec:	8b 45 08             	mov    0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	3c 39                	cmp    $0x39,%al
  800cf3:	7f 10                	jg     800d05 <strtol+0xc2>
			dig = *s - '0';
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f be c0             	movsbl %al,%eax
  800cfd:	83 e8 30             	sub    $0x30,%eax
  800d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d03:	eb 42                	jmp    800d47 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	3c 60                	cmp    $0x60,%al
  800d0c:	7e 19                	jle    800d27 <strtol+0xe4>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	3c 7a                	cmp    $0x7a,%al
  800d15:	7f 10                	jg     800d27 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	0f be c0             	movsbl %al,%eax
  800d1f:	83 e8 57             	sub    $0x57,%eax
  800d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d25:	eb 20                	jmp    800d47 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	3c 40                	cmp    $0x40,%al
  800d2e:	7e 39                	jle    800d69 <strtol+0x126>
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	3c 5a                	cmp    $0x5a,%al
  800d37:	7f 30                	jg     800d69 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f be c0             	movsbl %al,%eax
  800d41:	83 e8 37             	sub    $0x37,%eax
  800d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d4a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d4d:	7d 19                	jge    800d68 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d4f:	ff 45 08             	incl   0x8(%ebp)
  800d52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d55:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d59:	89 c2                	mov    %eax,%edx
  800d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d5e:	01 d0                	add    %edx,%eax
  800d60:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d63:	e9 7b ff ff ff       	jmp    800ce3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d68:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d6d:	74 08                	je     800d77 <strtol+0x134>
		*endptr = (char *) s;
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d77:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d7b:	74 07                	je     800d84 <strtol+0x141>
  800d7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d80:	f7 d8                	neg    %eax
  800d82:	eb 03                	jmp    800d87 <strtol+0x144>
  800d84:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <ltostr>:

void
ltostr(long value, char *str)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d96:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800d9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da1:	79 13                	jns    800db6 <ltostr+0x2d>
	{
		neg = 1;
  800da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800db0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800db3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dbe:	99                   	cltd   
  800dbf:	f7 f9                	idiv   %ecx
  800dc1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc7:	8d 50 01             	lea    0x1(%eax),%edx
  800dca:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcd:	89 c2                	mov    %eax,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	01 d0                	add    %edx,%eax
  800dd4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dd7:	83 c2 30             	add    $0x30,%edx
  800dda:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ddc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ddf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800de4:	f7 e9                	imul   %ecx
  800de6:	c1 fa 02             	sar    $0x2,%edx
  800de9:	89 c8                	mov    %ecx,%eax
  800deb:	c1 f8 1f             	sar    $0x1f,%eax
  800dee:	29 c2                	sub    %eax,%edx
  800df0:	89 d0                	mov    %edx,%eax
  800df2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800df5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dfd:	f7 e9                	imul   %ecx
  800dff:	c1 fa 02             	sar    $0x2,%edx
  800e02:	89 c8                	mov    %ecx,%eax
  800e04:	c1 f8 1f             	sar    $0x1f,%eax
  800e07:	29 c2                	sub    %eax,%edx
  800e09:	89 d0                	mov    %edx,%eax
  800e0b:	c1 e0 02             	shl    $0x2,%eax
  800e0e:	01 d0                	add    %edx,%eax
  800e10:	01 c0                	add    %eax,%eax
  800e12:	29 c1                	sub    %eax,%ecx
  800e14:	89 ca                	mov    %ecx,%edx
  800e16:	85 d2                	test   %edx,%edx
  800e18:	75 9c                	jne    800db6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e21:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e24:	48                   	dec    %eax
  800e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e28:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e2c:	74 3d                	je     800e6b <ltostr+0xe2>
		start = 1 ;
  800e2e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e35:	eb 34                	jmp    800e6b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3d:	01 d0                	add    %edx,%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	01 c2                	add    %eax,%edx
  800e4c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	01 c8                	add    %ecx,%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5e:	01 c2                	add    %eax,%edx
  800e60:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e63:	88 02                	mov    %al,(%edx)
		start++ ;
  800e65:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e68:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e71:	7c c4                	jl     800e37 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e73:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e79:	01 d0                	add    %edx,%eax
  800e7b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e7e:	90                   	nop
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e87:	ff 75 08             	pushl  0x8(%ebp)
  800e8a:	e8 54 fa ff ff       	call   8008e3 <strlen>
  800e8f:	83 c4 04             	add    $0x4,%esp
  800e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e95:	ff 75 0c             	pushl  0xc(%ebp)
  800e98:	e8 46 fa ff ff       	call   8008e3 <strlen>
  800e9d:	83 c4 04             	add    $0x4,%esp
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ea3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb1:	eb 17                	jmp    800eca <strcconcat+0x49>
		final[s] = str1[s] ;
  800eb3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb9:	01 c2                	add    %eax,%edx
  800ebb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	01 c8                	add    %ecx,%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ec7:	ff 45 fc             	incl   -0x4(%ebp)
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ed0:	7c e1                	jl     800eb3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ed2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ed9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ee0:	eb 1f                	jmp    800f01 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee5:	8d 50 01             	lea    0x1(%eax),%edx
  800ee8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eeb:	89 c2                	mov    %eax,%edx
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	01 c2                	add    %eax,%edx
  800ef2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	01 c8                	add    %ecx,%eax
  800efa:	8a 00                	mov    (%eax),%al
  800efc:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800efe:	ff 45 f8             	incl   -0x8(%ebp)
  800f01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f07:	7c d9                	jl     800ee2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f09:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0f:	01 d0                	add    %edx,%eax
  800f11:	c6 00 00             	movb   $0x0,(%eax)
}
  800f14:	90                   	nop
  800f15:	c9                   	leave  
  800f16:	c3                   	ret    

00800f17 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f23:	8b 45 14             	mov    0x14(%ebp),%eax
  800f26:	8b 00                	mov    (%eax),%eax
  800f28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	01 d0                	add    %edx,%eax
  800f34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f3a:	eb 0c                	jmp    800f48 <strsplit+0x31>
			*string++ = 0;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	8d 50 01             	lea    0x1(%eax),%edx
  800f42:	89 55 08             	mov    %edx,0x8(%ebp)
  800f45:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	84 c0                	test   %al,%al
  800f4f:	74 18                	je     800f69 <strsplit+0x52>
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	0f be c0             	movsbl %al,%eax
  800f59:	50                   	push   %eax
  800f5a:	ff 75 0c             	pushl  0xc(%ebp)
  800f5d:	e8 13 fb ff ff       	call   800a75 <strchr>
  800f62:	83 c4 08             	add    $0x8,%esp
  800f65:	85 c0                	test   %eax,%eax
  800f67:	75 d3                	jne    800f3c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	84 c0                	test   %al,%al
  800f70:	74 5a                	je     800fcc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f72:	8b 45 14             	mov    0x14(%ebp),%eax
  800f75:	8b 00                	mov    (%eax),%eax
  800f77:	83 f8 0f             	cmp    $0xf,%eax
  800f7a:	75 07                	jne    800f83 <strsplit+0x6c>
		{
			return 0;
  800f7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f81:	eb 66                	jmp    800fe9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f83:	8b 45 14             	mov    0x14(%ebp),%eax
  800f86:	8b 00                	mov    (%eax),%eax
  800f88:	8d 48 01             	lea    0x1(%eax),%ecx
  800f8b:	8b 55 14             	mov    0x14(%ebp),%edx
  800f8e:	89 0a                	mov    %ecx,(%edx)
  800f90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	01 c2                	add    %eax,%edx
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa1:	eb 03                	jmp    800fa6 <strsplit+0x8f>
			string++;
  800fa3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	84 c0                	test   %al,%al
  800fad:	74 8b                	je     800f3a <strsplit+0x23>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8a 00                	mov    (%eax),%al
  800fb4:	0f be c0             	movsbl %al,%eax
  800fb7:	50                   	push   %eax
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	e8 b5 fa ff ff       	call   800a75 <strchr>
  800fc0:	83 c4 08             	add    $0x8,%esp
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	74 dc                	je     800fa3 <strsplit+0x8c>
			string++;
	}
  800fc7:	e9 6e ff ff ff       	jmp    800f3a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fcc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fcd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd0:	8b 00                	mov    (%eax),%eax
  800fd2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdc:	01 d0                	add    %edx,%eax
  800fde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fe4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
  800ff1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ffd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801000:	8b 7d 18             	mov    0x18(%ebp),%edi
  801003:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801006:	cd 30                	int    $0x30
  801008:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80100b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80100e:	83 c4 10             	add    $0x10,%esp
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 04             	sub    $0x4,%esp
  80101c:	8b 45 10             	mov    0x10(%ebp),%eax
  80101f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801022:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	6a 00                	push   $0x0
  80102b:	6a 00                	push   $0x0
  80102d:	52                   	push   %edx
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	50                   	push   %eax
  801032:	6a 00                	push   $0x0
  801034:	e8 b2 ff ff ff       	call   800feb <syscall>
  801039:	83 c4 18             	add    $0x18,%esp
}
  80103c:	90                   	nop
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    

0080103f <sys_cgetc>:

int
sys_cgetc(void)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801042:	6a 00                	push   $0x0
  801044:	6a 00                	push   $0x0
  801046:	6a 00                	push   $0x0
  801048:	6a 00                	push   $0x0
  80104a:	6a 00                	push   $0x0
  80104c:	6a 01                	push   $0x1
  80104e:	e8 98 ff ff ff       	call   800feb <syscall>
  801053:	83 c4 18             	add    $0x18,%esp
}
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80105b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	6a 00                	push   $0x0
  801063:	6a 00                	push   $0x0
  801065:	6a 00                	push   $0x0
  801067:	52                   	push   %edx
  801068:	50                   	push   %eax
  801069:	6a 05                	push   $0x5
  80106b:	e8 7b ff ff ff       	call   800feb <syscall>
  801070:	83 c4 18             	add    $0x18,%esp
}
  801073:	c9                   	leave  
  801074:	c3                   	ret    

00801075 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	56                   	push   %esi
  801079:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80107a:	8b 75 18             	mov    0x18(%ebp),%esi
  80107d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801080:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801083:	8b 55 0c             	mov    0xc(%ebp),%edx
  801086:	8b 45 08             	mov    0x8(%ebp),%eax
  801089:	56                   	push   %esi
  80108a:	53                   	push   %ebx
  80108b:	51                   	push   %ecx
  80108c:	52                   	push   %edx
  80108d:	50                   	push   %eax
  80108e:	6a 06                	push   $0x6
  801090:	e8 56 ff ff ff       	call   800feb <syscall>
  801095:	83 c4 18             	add    $0x18,%esp
}
  801098:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	6a 00                	push   $0x0
  8010aa:	6a 00                	push   $0x0
  8010ac:	6a 00                	push   $0x0
  8010ae:	52                   	push   %edx
  8010af:	50                   	push   %eax
  8010b0:	6a 07                	push   $0x7
  8010b2:	e8 34 ff ff ff       	call   800feb <syscall>
  8010b7:	83 c4 18             	add    $0x18,%esp
}
  8010ba:	c9                   	leave  
  8010bb:	c3                   	ret    

008010bc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8010bf:	6a 00                	push   $0x0
  8010c1:	6a 00                	push   $0x0
  8010c3:	6a 00                	push   $0x0
  8010c5:	ff 75 0c             	pushl  0xc(%ebp)
  8010c8:	ff 75 08             	pushl  0x8(%ebp)
  8010cb:	6a 08                	push   $0x8
  8010cd:	e8 19 ff ff ff       	call   800feb <syscall>
  8010d2:	83 c4 18             	add    $0x18,%esp
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8010da:	6a 00                	push   $0x0
  8010dc:	6a 00                	push   $0x0
  8010de:	6a 00                	push   $0x0
  8010e0:	6a 00                	push   $0x0
  8010e2:	6a 00                	push   $0x0
  8010e4:	6a 09                	push   $0x9
  8010e6:	e8 00 ff ff ff       	call   800feb <syscall>
  8010eb:	83 c4 18             	add    $0x18,%esp
}
  8010ee:	c9                   	leave  
  8010ef:	c3                   	ret    

008010f0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8010f3:	6a 00                	push   $0x0
  8010f5:	6a 00                	push   $0x0
  8010f7:	6a 00                	push   $0x0
  8010f9:	6a 00                	push   $0x0
  8010fb:	6a 00                	push   $0x0
  8010fd:	6a 0a                	push   $0xa
  8010ff:	e8 e7 fe ff ff       	call   800feb <syscall>
  801104:	83 c4 18             	add    $0x18,%esp
}
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	6a 00                	push   $0x0
  801112:	6a 00                	push   $0x0
  801114:	6a 00                	push   $0x0
  801116:	6a 0b                	push   $0xb
  801118:	e8 ce fe ff ff       	call   800feb <syscall>
  80111d:	83 c4 18             	add    $0x18,%esp
}
  801120:	c9                   	leave  
  801121:	c3                   	ret    

00801122 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801125:	6a 00                	push   $0x0
  801127:	6a 00                	push   $0x0
  801129:	6a 00                	push   $0x0
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	ff 75 08             	pushl  0x8(%ebp)
  801131:	6a 0f                	push   $0xf
  801133:	e8 b3 fe ff ff       	call   800feb <syscall>
  801138:	83 c4 18             	add    $0x18,%esp
	return;
  80113b:	90                   	nop
}
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    

0080113e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801141:	6a 00                	push   $0x0
  801143:	6a 00                	push   $0x0
  801145:	6a 00                	push   $0x0
  801147:	ff 75 0c             	pushl  0xc(%ebp)
  80114a:	ff 75 08             	pushl  0x8(%ebp)
  80114d:	6a 10                	push   $0x10
  80114f:	e8 97 fe ff ff       	call   800feb <syscall>
  801154:	83 c4 18             	add    $0x18,%esp
	return ;
  801157:	90                   	nop
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80115d:	6a 00                	push   $0x0
  80115f:	6a 00                	push   $0x0
  801161:	ff 75 10             	pushl  0x10(%ebp)
  801164:	ff 75 0c             	pushl  0xc(%ebp)
  801167:	ff 75 08             	pushl  0x8(%ebp)
  80116a:	6a 11                	push   $0x11
  80116c:	e8 7a fe ff ff       	call   800feb <syscall>
  801171:	83 c4 18             	add    $0x18,%esp
	return ;
  801174:	90                   	nop
}
  801175:	c9                   	leave  
  801176:	c3                   	ret    

00801177 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801177:	55                   	push   %ebp
  801178:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80117a:	6a 00                	push   $0x0
  80117c:	6a 00                	push   $0x0
  80117e:	6a 00                	push   $0x0
  801180:	6a 00                	push   $0x0
  801182:	6a 00                	push   $0x0
  801184:	6a 0c                	push   $0xc
  801186:	e8 60 fe ff ff       	call   800feb <syscall>
  80118b:	83 c4 18             	add    $0x18,%esp
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801193:	6a 00                	push   $0x0
  801195:	6a 00                	push   $0x0
  801197:	6a 00                	push   $0x0
  801199:	6a 00                	push   $0x0
  80119b:	ff 75 08             	pushl  0x8(%ebp)
  80119e:	6a 0d                	push   $0xd
  8011a0:	e8 46 fe ff ff       	call   800feb <syscall>
  8011a5:	83 c4 18             	add    $0x18,%esp
}
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	6a 00                	push   $0x0
  8011b3:	6a 00                	push   $0x0
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 0e                	push   $0xe
  8011b9:	e8 2d fe ff ff       	call   800feb <syscall>
  8011be:	83 c4 18             	add    $0x18,%esp
}
  8011c1:	90                   	nop
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    

008011c4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011c4:	55                   	push   %ebp
  8011c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011c7:	6a 00                	push   $0x0
  8011c9:	6a 00                	push   $0x0
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 13                	push   $0x13
  8011d3:	e8 13 fe ff ff       	call   800feb <syscall>
  8011d8:	83 c4 18             	add    $0x18,%esp
}
  8011db:	90                   	nop
  8011dc:	c9                   	leave  
  8011dd:	c3                   	ret    

008011de <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8011de:	55                   	push   %ebp
  8011df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 00                	push   $0x0
  8011e5:	6a 00                	push   $0x0
  8011e7:	6a 00                	push   $0x0
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 14                	push   $0x14
  8011ed:	e8 f9 fd ff ff       	call   800feb <syscall>
  8011f2:	83 c4 18             	add    $0x18,%esp
}
  8011f5:	90                   	nop
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    

008011f8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
  8011fb:	83 ec 04             	sub    $0x4,%esp
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801204:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801208:	6a 00                	push   $0x0
  80120a:	6a 00                	push   $0x0
  80120c:	6a 00                	push   $0x0
  80120e:	6a 00                	push   $0x0
  801210:	50                   	push   %eax
  801211:	6a 15                	push   $0x15
  801213:	e8 d3 fd ff ff       	call   800feb <syscall>
  801218:	83 c4 18             	add    $0x18,%esp
}
  80121b:	90                   	nop
  80121c:	c9                   	leave  
  80121d:	c3                   	ret    

0080121e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801221:	6a 00                	push   $0x0
  801223:	6a 00                	push   $0x0
  801225:	6a 00                	push   $0x0
  801227:	6a 00                	push   $0x0
  801229:	6a 00                	push   $0x0
  80122b:	6a 16                	push   $0x16
  80122d:	e8 b9 fd ff ff       	call   800feb <syscall>
  801232:	83 c4 18             	add    $0x18,%esp
}
  801235:	90                   	nop
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	ff 75 0c             	pushl  0xc(%ebp)
  801247:	50                   	push   %eax
  801248:	6a 17                	push   $0x17
  80124a:	e8 9c fd ff ff       	call   800feb <syscall>
  80124f:	83 c4 18             	add    $0x18,%esp
}
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 00                	push   $0x0
  801263:	52                   	push   %edx
  801264:	50                   	push   %eax
  801265:	6a 1a                	push   $0x1a
  801267:	e8 7f fd ff ff       	call   800feb <syscall>
  80126c:	83 c4 18             	add    $0x18,%esp
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801274:	8b 55 0c             	mov    0xc(%ebp),%edx
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	52                   	push   %edx
  801281:	50                   	push   %eax
  801282:	6a 18                	push   $0x18
  801284:	e8 62 fd ff ff       	call   800feb <syscall>
  801289:	83 c4 18             	add    $0x18,%esp
}
  80128c:	90                   	nop
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801292:	8b 55 0c             	mov    0xc(%ebp),%edx
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	6a 00                	push   $0x0
  80129a:	6a 00                	push   $0x0
  80129c:	6a 00                	push   $0x0
  80129e:	52                   	push   %edx
  80129f:	50                   	push   %eax
  8012a0:	6a 19                	push   $0x19
  8012a2:	e8 44 fd ff ff       	call   800feb <syscall>
  8012a7:	83 c4 18             	add    $0x18,%esp
}
  8012aa:	90                   	nop
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 04             	sub    $0x4,%esp
  8012b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012bc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	6a 00                	push   $0x0
  8012c5:	51                   	push   %ecx
  8012c6:	52                   	push   %edx
  8012c7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ca:	50                   	push   %eax
  8012cb:	6a 1b                	push   $0x1b
  8012cd:	e8 19 fd ff ff       	call   800feb <syscall>
  8012d2:	83 c4 18             	add    $0x18,%esp
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 00                	push   $0x0
  8012e6:	52                   	push   %edx
  8012e7:	50                   	push   %eax
  8012e8:	6a 1c                	push   $0x1c
  8012ea:	e8 fc fc ff ff       	call   800feb <syscall>
  8012ef:	83 c4 18             	add    $0x18,%esp
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8012f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	6a 00                	push   $0x0
  801302:	6a 00                	push   $0x0
  801304:	51                   	push   %ecx
  801305:	52                   	push   %edx
  801306:	50                   	push   %eax
  801307:	6a 1d                	push   $0x1d
  801309:	e8 dd fc ff ff       	call   800feb <syscall>
  80130e:	83 c4 18             	add    $0x18,%esp
}
  801311:	c9                   	leave  
  801312:	c3                   	ret    

00801313 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801313:	55                   	push   %ebp
  801314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801316:	8b 55 0c             	mov    0xc(%ebp),%edx
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	52                   	push   %edx
  801323:	50                   	push   %eax
  801324:	6a 1e                	push   $0x1e
  801326:	e8 c0 fc ff ff       	call   800feb <syscall>
  80132b:	83 c4 18             	add    $0x18,%esp
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 1f                	push   $0x1f
  80133f:	e8 a7 fc ff ff       	call   800feb <syscall>
  801344:	83 c4 18             	add    $0x18,%esp
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	6a 00                	push   $0x0
  801351:	ff 75 14             	pushl  0x14(%ebp)
  801354:	ff 75 10             	pushl  0x10(%ebp)
  801357:	ff 75 0c             	pushl  0xc(%ebp)
  80135a:	50                   	push   %eax
  80135b:	6a 20                	push   $0x20
  80135d:	e8 89 fc ff ff       	call   800feb <syscall>
  801362:	83 c4 18             	add    $0x18,%esp
}
  801365:	c9                   	leave  
  801366:	c3                   	ret    

00801367 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	6a 00                	push   $0x0
  801375:	50                   	push   %eax
  801376:	6a 21                	push   $0x21
  801378:	e8 6e fc ff ff       	call   800feb <syscall>
  80137d:	83 c4 18             	add    $0x18,%esp
}
  801380:	90                   	nop
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	50                   	push   %eax
  801392:	6a 22                	push   $0x22
  801394:	e8 52 fc ff ff       	call   800feb <syscall>
  801399:	83 c4 18             	add    $0x18,%esp
}
  80139c:	c9                   	leave  
  80139d:	c3                   	ret    

0080139e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 02                	push   $0x2
  8013ad:	e8 39 fc ff ff       	call   800feb <syscall>
  8013b2:	83 c4 18             	add    $0x18,%esp
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 03                	push   $0x3
  8013c6:	e8 20 fc ff ff       	call   800feb <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	6a 04                	push   $0x4
  8013df:	e8 07 fc ff ff       	call   800feb <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
}
  8013e7:	c9                   	leave  
  8013e8:	c3                   	ret    

008013e9 <sys_exit_env>:


void sys_exit_env(void)
{
  8013e9:	55                   	push   %ebp
  8013ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 23                	push   $0x23
  8013f8:	e8 ee fb ff ff       	call   800feb <syscall>
  8013fd:	83 c4 18             	add    $0x18,%esp
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801409:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80140c:	8d 50 04             	lea    0x4(%eax),%edx
  80140f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	52                   	push   %edx
  801419:	50                   	push   %eax
  80141a:	6a 24                	push   $0x24
  80141c:	e8 ca fb ff ff       	call   800feb <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
	return result;
  801424:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801427:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80142d:	89 01                	mov    %eax,(%ecx)
  80142f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	c9                   	leave  
  801436:	c2 04 00             	ret    $0x4

00801439 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	ff 75 10             	pushl  0x10(%ebp)
  801443:	ff 75 0c             	pushl  0xc(%ebp)
  801446:	ff 75 08             	pushl  0x8(%ebp)
  801449:	6a 12                	push   $0x12
  80144b:	e8 9b fb ff ff       	call   800feb <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
	return ;
  801453:	90                   	nop
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <sys_rcr2>:
uint32 sys_rcr2()
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 25                	push   $0x25
  801465:	e8 81 fb ff ff       	call   800feb <syscall>
  80146a:	83 c4 18             	add    $0x18,%esp
}
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80147b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	50                   	push   %eax
  801488:	6a 26                	push   $0x26
  80148a:	e8 5c fb ff ff       	call   800feb <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
	return ;
  801492:	90                   	nop
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <rsttst>:
void rsttst()
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 28                	push   $0x28
  8014a4:	e8 42 fb ff ff       	call   800feb <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8014ac:	90                   	nop
}
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 04             	sub    $0x4,%esp
  8014b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014bb:	8b 55 18             	mov    0x18(%ebp),%edx
  8014be:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014c2:	52                   	push   %edx
  8014c3:	50                   	push   %eax
  8014c4:	ff 75 10             	pushl  0x10(%ebp)
  8014c7:	ff 75 0c             	pushl  0xc(%ebp)
  8014ca:	ff 75 08             	pushl  0x8(%ebp)
  8014cd:	6a 27                	push   $0x27
  8014cf:	e8 17 fb ff ff       	call   800feb <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d7:	90                   	nop
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <chktst>:
void chktst(uint32 n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	ff 75 08             	pushl  0x8(%ebp)
  8014e8:	6a 29                	push   $0x29
  8014ea:	e8 fc fa ff ff       	call   800feb <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f2:	90                   	nop
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <inctst>:

void inctst()
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 2a                	push   $0x2a
  801504:	e8 e2 fa ff ff       	call   800feb <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
	return ;
  80150c:	90                   	nop
}
  80150d:	c9                   	leave  
  80150e:	c3                   	ret    

0080150f <gettst>:
uint32 gettst()
{
  80150f:	55                   	push   %ebp
  801510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 2b                	push   $0x2b
  80151e:	e8 c8 fa ff ff       	call   800feb <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 2c                	push   $0x2c
  80153a:	e8 ac fa ff ff       	call   800feb <syscall>
  80153f:	83 c4 18             	add    $0x18,%esp
  801542:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801545:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801549:	75 07                	jne    801552 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80154b:	b8 01 00 00 00       	mov    $0x1,%eax
  801550:	eb 05                	jmp    801557 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801552:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
  80155c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 2c                	push   $0x2c
  80156b:	e8 7b fa ff ff       	call   800feb <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
  801573:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801576:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80157a:	75 07                	jne    801583 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80157c:	b8 01 00 00 00       	mov    $0x1,%eax
  801581:	eb 05                	jmp    801588 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 2c                	push   $0x2c
  80159c:	e8 4a fa ff ff       	call   800feb <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
  8015a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015a7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015ab:	75 07                	jne    8015b4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b2:	eb 05                	jmp    8015b9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 2c                	push   $0x2c
  8015cd:	e8 19 fa ff ff       	call   800feb <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
  8015d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015d8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015dc:	75 07                	jne    8015e5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015de:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e3:	eb 05                	jmp    8015ea <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	ff 75 08             	pushl  0x8(%ebp)
  8015fa:	6a 2d                	push   $0x2d
  8015fc:	e8 ea f9 ff ff       	call   800feb <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
	return ;
  801604:	90                   	nop
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80160b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80160e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801611:	8b 55 0c             	mov    0xc(%ebp),%edx
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	6a 00                	push   $0x0
  801619:	53                   	push   %ebx
  80161a:	51                   	push   %ecx
  80161b:	52                   	push   %edx
  80161c:	50                   	push   %eax
  80161d:	6a 2e                	push   $0x2e
  80161f:	e8 c7 f9 ff ff       	call   800feb <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
}
  801627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80162f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	52                   	push   %edx
  80163c:	50                   	push   %eax
  80163d:	6a 2f                	push   $0x2f
  80163f:	e8 a7 f9 ff ff       	call   800feb <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    
  801649:	66 90                	xchg   %ax,%ax
  80164b:	90                   	nop

0080164c <__udivdi3>:
  80164c:	55                   	push   %ebp
  80164d:	57                   	push   %edi
  80164e:	56                   	push   %esi
  80164f:	53                   	push   %ebx
  801650:	83 ec 1c             	sub    $0x1c,%esp
  801653:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801657:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80165b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80165f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801663:	89 ca                	mov    %ecx,%edx
  801665:	89 f8                	mov    %edi,%eax
  801667:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80166b:	85 f6                	test   %esi,%esi
  80166d:	75 2d                	jne    80169c <__udivdi3+0x50>
  80166f:	39 cf                	cmp    %ecx,%edi
  801671:	77 65                	ja     8016d8 <__udivdi3+0x8c>
  801673:	89 fd                	mov    %edi,%ebp
  801675:	85 ff                	test   %edi,%edi
  801677:	75 0b                	jne    801684 <__udivdi3+0x38>
  801679:	b8 01 00 00 00       	mov    $0x1,%eax
  80167e:	31 d2                	xor    %edx,%edx
  801680:	f7 f7                	div    %edi
  801682:	89 c5                	mov    %eax,%ebp
  801684:	31 d2                	xor    %edx,%edx
  801686:	89 c8                	mov    %ecx,%eax
  801688:	f7 f5                	div    %ebp
  80168a:	89 c1                	mov    %eax,%ecx
  80168c:	89 d8                	mov    %ebx,%eax
  80168e:	f7 f5                	div    %ebp
  801690:	89 cf                	mov    %ecx,%edi
  801692:	89 fa                	mov    %edi,%edx
  801694:	83 c4 1c             	add    $0x1c,%esp
  801697:	5b                   	pop    %ebx
  801698:	5e                   	pop    %esi
  801699:	5f                   	pop    %edi
  80169a:	5d                   	pop    %ebp
  80169b:	c3                   	ret    
  80169c:	39 ce                	cmp    %ecx,%esi
  80169e:	77 28                	ja     8016c8 <__udivdi3+0x7c>
  8016a0:	0f bd fe             	bsr    %esi,%edi
  8016a3:	83 f7 1f             	xor    $0x1f,%edi
  8016a6:	75 40                	jne    8016e8 <__udivdi3+0x9c>
  8016a8:	39 ce                	cmp    %ecx,%esi
  8016aa:	72 0a                	jb     8016b6 <__udivdi3+0x6a>
  8016ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8016b0:	0f 87 9e 00 00 00    	ja     801754 <__udivdi3+0x108>
  8016b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8016bb:	89 fa                	mov    %edi,%edx
  8016bd:	83 c4 1c             	add    $0x1c,%esp
  8016c0:	5b                   	pop    %ebx
  8016c1:	5e                   	pop    %esi
  8016c2:	5f                   	pop    %edi
  8016c3:	5d                   	pop    %ebp
  8016c4:	c3                   	ret    
  8016c5:	8d 76 00             	lea    0x0(%esi),%esi
  8016c8:	31 ff                	xor    %edi,%edi
  8016ca:	31 c0                	xor    %eax,%eax
  8016cc:	89 fa                	mov    %edi,%edx
  8016ce:	83 c4 1c             	add    $0x1c,%esp
  8016d1:	5b                   	pop    %ebx
  8016d2:	5e                   	pop    %esi
  8016d3:	5f                   	pop    %edi
  8016d4:	5d                   	pop    %ebp
  8016d5:	c3                   	ret    
  8016d6:	66 90                	xchg   %ax,%ax
  8016d8:	89 d8                	mov    %ebx,%eax
  8016da:	f7 f7                	div    %edi
  8016dc:	31 ff                	xor    %edi,%edi
  8016de:	89 fa                	mov    %edi,%edx
  8016e0:	83 c4 1c             	add    $0x1c,%esp
  8016e3:	5b                   	pop    %ebx
  8016e4:	5e                   	pop    %esi
  8016e5:	5f                   	pop    %edi
  8016e6:	5d                   	pop    %ebp
  8016e7:	c3                   	ret    
  8016e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8016ed:	89 eb                	mov    %ebp,%ebx
  8016ef:	29 fb                	sub    %edi,%ebx
  8016f1:	89 f9                	mov    %edi,%ecx
  8016f3:	d3 e6                	shl    %cl,%esi
  8016f5:	89 c5                	mov    %eax,%ebp
  8016f7:	88 d9                	mov    %bl,%cl
  8016f9:	d3 ed                	shr    %cl,%ebp
  8016fb:	89 e9                	mov    %ebp,%ecx
  8016fd:	09 f1                	or     %esi,%ecx
  8016ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801703:	89 f9                	mov    %edi,%ecx
  801705:	d3 e0                	shl    %cl,%eax
  801707:	89 c5                	mov    %eax,%ebp
  801709:	89 d6                	mov    %edx,%esi
  80170b:	88 d9                	mov    %bl,%cl
  80170d:	d3 ee                	shr    %cl,%esi
  80170f:	89 f9                	mov    %edi,%ecx
  801711:	d3 e2                	shl    %cl,%edx
  801713:	8b 44 24 08          	mov    0x8(%esp),%eax
  801717:	88 d9                	mov    %bl,%cl
  801719:	d3 e8                	shr    %cl,%eax
  80171b:	09 c2                	or     %eax,%edx
  80171d:	89 d0                	mov    %edx,%eax
  80171f:	89 f2                	mov    %esi,%edx
  801721:	f7 74 24 0c          	divl   0xc(%esp)
  801725:	89 d6                	mov    %edx,%esi
  801727:	89 c3                	mov    %eax,%ebx
  801729:	f7 e5                	mul    %ebp
  80172b:	39 d6                	cmp    %edx,%esi
  80172d:	72 19                	jb     801748 <__udivdi3+0xfc>
  80172f:	74 0b                	je     80173c <__udivdi3+0xf0>
  801731:	89 d8                	mov    %ebx,%eax
  801733:	31 ff                	xor    %edi,%edi
  801735:	e9 58 ff ff ff       	jmp    801692 <__udivdi3+0x46>
  80173a:	66 90                	xchg   %ax,%ax
  80173c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801740:	89 f9                	mov    %edi,%ecx
  801742:	d3 e2                	shl    %cl,%edx
  801744:	39 c2                	cmp    %eax,%edx
  801746:	73 e9                	jae    801731 <__udivdi3+0xe5>
  801748:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80174b:	31 ff                	xor    %edi,%edi
  80174d:	e9 40 ff ff ff       	jmp    801692 <__udivdi3+0x46>
  801752:	66 90                	xchg   %ax,%ax
  801754:	31 c0                	xor    %eax,%eax
  801756:	e9 37 ff ff ff       	jmp    801692 <__udivdi3+0x46>
  80175b:	90                   	nop

0080175c <__umoddi3>:
  80175c:	55                   	push   %ebp
  80175d:	57                   	push   %edi
  80175e:	56                   	push   %esi
  80175f:	53                   	push   %ebx
  801760:	83 ec 1c             	sub    $0x1c,%esp
  801763:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801767:	8b 74 24 34          	mov    0x34(%esp),%esi
  80176b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80176f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801773:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801777:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80177b:	89 f3                	mov    %esi,%ebx
  80177d:	89 fa                	mov    %edi,%edx
  80177f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801783:	89 34 24             	mov    %esi,(%esp)
  801786:	85 c0                	test   %eax,%eax
  801788:	75 1a                	jne    8017a4 <__umoddi3+0x48>
  80178a:	39 f7                	cmp    %esi,%edi
  80178c:	0f 86 a2 00 00 00    	jbe    801834 <__umoddi3+0xd8>
  801792:	89 c8                	mov    %ecx,%eax
  801794:	89 f2                	mov    %esi,%edx
  801796:	f7 f7                	div    %edi
  801798:	89 d0                	mov    %edx,%eax
  80179a:	31 d2                	xor    %edx,%edx
  80179c:	83 c4 1c             	add    $0x1c,%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5f                   	pop    %edi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    
  8017a4:	39 f0                	cmp    %esi,%eax
  8017a6:	0f 87 ac 00 00 00    	ja     801858 <__umoddi3+0xfc>
  8017ac:	0f bd e8             	bsr    %eax,%ebp
  8017af:	83 f5 1f             	xor    $0x1f,%ebp
  8017b2:	0f 84 ac 00 00 00    	je     801864 <__umoddi3+0x108>
  8017b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8017bd:	29 ef                	sub    %ebp,%edi
  8017bf:	89 fe                	mov    %edi,%esi
  8017c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017c5:	89 e9                	mov    %ebp,%ecx
  8017c7:	d3 e0                	shl    %cl,%eax
  8017c9:	89 d7                	mov    %edx,%edi
  8017cb:	89 f1                	mov    %esi,%ecx
  8017cd:	d3 ef                	shr    %cl,%edi
  8017cf:	09 c7                	or     %eax,%edi
  8017d1:	89 e9                	mov    %ebp,%ecx
  8017d3:	d3 e2                	shl    %cl,%edx
  8017d5:	89 14 24             	mov    %edx,(%esp)
  8017d8:	89 d8                	mov    %ebx,%eax
  8017da:	d3 e0                	shl    %cl,%eax
  8017dc:	89 c2                	mov    %eax,%edx
  8017de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017e2:	d3 e0                	shl    %cl,%eax
  8017e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8017ec:	89 f1                	mov    %esi,%ecx
  8017ee:	d3 e8                	shr    %cl,%eax
  8017f0:	09 d0                	or     %edx,%eax
  8017f2:	d3 eb                	shr    %cl,%ebx
  8017f4:	89 da                	mov    %ebx,%edx
  8017f6:	f7 f7                	div    %edi
  8017f8:	89 d3                	mov    %edx,%ebx
  8017fa:	f7 24 24             	mull   (%esp)
  8017fd:	89 c6                	mov    %eax,%esi
  8017ff:	89 d1                	mov    %edx,%ecx
  801801:	39 d3                	cmp    %edx,%ebx
  801803:	0f 82 87 00 00 00    	jb     801890 <__umoddi3+0x134>
  801809:	0f 84 91 00 00 00    	je     8018a0 <__umoddi3+0x144>
  80180f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801813:	29 f2                	sub    %esi,%edx
  801815:	19 cb                	sbb    %ecx,%ebx
  801817:	89 d8                	mov    %ebx,%eax
  801819:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80181d:	d3 e0                	shl    %cl,%eax
  80181f:	89 e9                	mov    %ebp,%ecx
  801821:	d3 ea                	shr    %cl,%edx
  801823:	09 d0                	or     %edx,%eax
  801825:	89 e9                	mov    %ebp,%ecx
  801827:	d3 eb                	shr    %cl,%ebx
  801829:	89 da                	mov    %ebx,%edx
  80182b:	83 c4 1c             	add    $0x1c,%esp
  80182e:	5b                   	pop    %ebx
  80182f:	5e                   	pop    %esi
  801830:	5f                   	pop    %edi
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    
  801833:	90                   	nop
  801834:	89 fd                	mov    %edi,%ebp
  801836:	85 ff                	test   %edi,%edi
  801838:	75 0b                	jne    801845 <__umoddi3+0xe9>
  80183a:	b8 01 00 00 00       	mov    $0x1,%eax
  80183f:	31 d2                	xor    %edx,%edx
  801841:	f7 f7                	div    %edi
  801843:	89 c5                	mov    %eax,%ebp
  801845:	89 f0                	mov    %esi,%eax
  801847:	31 d2                	xor    %edx,%edx
  801849:	f7 f5                	div    %ebp
  80184b:	89 c8                	mov    %ecx,%eax
  80184d:	f7 f5                	div    %ebp
  80184f:	89 d0                	mov    %edx,%eax
  801851:	e9 44 ff ff ff       	jmp    80179a <__umoddi3+0x3e>
  801856:	66 90                	xchg   %ax,%ax
  801858:	89 c8                	mov    %ecx,%eax
  80185a:	89 f2                	mov    %esi,%edx
  80185c:	83 c4 1c             	add    $0x1c,%esp
  80185f:	5b                   	pop    %ebx
  801860:	5e                   	pop    %esi
  801861:	5f                   	pop    %edi
  801862:	5d                   	pop    %ebp
  801863:	c3                   	ret    
  801864:	3b 04 24             	cmp    (%esp),%eax
  801867:	72 06                	jb     80186f <__umoddi3+0x113>
  801869:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80186d:	77 0f                	ja     80187e <__umoddi3+0x122>
  80186f:	89 f2                	mov    %esi,%edx
  801871:	29 f9                	sub    %edi,%ecx
  801873:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801877:	89 14 24             	mov    %edx,(%esp)
  80187a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80187e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801882:	8b 14 24             	mov    (%esp),%edx
  801885:	83 c4 1c             	add    $0x1c,%esp
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5f                   	pop    %edi
  80188b:	5d                   	pop    %ebp
  80188c:	c3                   	ret    
  80188d:	8d 76 00             	lea    0x0(%esi),%esi
  801890:	2b 04 24             	sub    (%esp),%eax
  801893:	19 fa                	sbb    %edi,%edx
  801895:	89 d1                	mov    %edx,%ecx
  801897:	89 c6                	mov    %eax,%esi
  801899:	e9 71 ff ff ff       	jmp    80180f <__umoddi3+0xb3>
  80189e:	66 90                	xchg   %ax,%ax
  8018a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8018a4:	72 ea                	jb     801890 <__umoddi3+0x134>
  8018a6:	89 d9                	mov    %ebx,%ecx
  8018a8:	e9 62 ff ff ff       	jmp    80180f <__umoddi3+0xb3>
