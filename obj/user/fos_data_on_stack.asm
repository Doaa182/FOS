
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 c0 18 80 00       	push   $0x8018c0
  800049:	e8 43 02 00 00       	call   800291 <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80005a:	e8 5b 13 00 00       	call   8013ba <sys_getenvindex>
  80005f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	c1 e0 03             	shl    $0x3,%eax
  80006a:	01 d0                	add    %edx,%eax
  80006c:	01 c0                	add    %eax,%eax
  80006e:	01 d0                	add    %edx,%eax
  800070:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800077:	01 d0                	add    %edx,%eax
  800079:	c1 e0 04             	shl    $0x4,%eax
  80007c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800081:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800086:	a1 20 20 80 00       	mov    0x802020,%eax
  80008b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800091:	84 c0                	test   %al,%al
  800093:	74 0f                	je     8000a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800095:	a1 20 20 80 00       	mov    0x802020,%eax
  80009a:	05 5c 05 00 00       	add    $0x55c,%eax
  80009f:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a8:	7e 0a                	jle    8000b4 <libmain+0x60>
		binaryname = argv[0];
  8000aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ad:	8b 00                	mov    (%eax),%eax
  8000af:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  8000b4:	83 ec 08             	sub    $0x8,%esp
  8000b7:	ff 75 0c             	pushl  0xc(%ebp)
  8000ba:	ff 75 08             	pushl  0x8(%ebp)
  8000bd:	e8 76 ff ff ff       	call   800038 <_main>
  8000c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8000c5:	e8 fd 10 00 00       	call   8011c7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 fc 18 80 00       	push   $0x8018fc
  8000d2:	e8 8d 01 00 00       	call   800264 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000da:	a1 20 20 80 00       	mov    0x802020,%eax
  8000df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8000e5:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8000f0:	83 ec 04             	sub    $0x4,%esp
  8000f3:	52                   	push   %edx
  8000f4:	50                   	push   %eax
  8000f5:	68 24 19 80 00       	push   $0x801924
  8000fa:	e8 65 01 00 00       	call   800264 <cprintf>
  8000ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800102:	a1 20 20 80 00       	mov    0x802020,%eax
  800107:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80010d:	a1 20 20 80 00       	mov    0x802020,%eax
  800112:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800118:	a1 20 20 80 00       	mov    0x802020,%eax
  80011d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800123:	51                   	push   %ecx
  800124:	52                   	push   %edx
  800125:	50                   	push   %eax
  800126:	68 4c 19 80 00       	push   $0x80194c
  80012b:	e8 34 01 00 00       	call   800264 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800133:	a1 20 20 80 00       	mov    0x802020,%eax
  800138:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80013e:	83 ec 08             	sub    $0x8,%esp
  800141:	50                   	push   %eax
  800142:	68 a4 19 80 00       	push   $0x8019a4
  800147:	e8 18 01 00 00       	call   800264 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	68 fc 18 80 00       	push   $0x8018fc
  800157:	e8 08 01 00 00       	call   800264 <cprintf>
  80015c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80015f:	e8 7d 10 00 00       	call   8011e1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800164:	e8 19 00 00 00       	call   800182 <exit>
}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	6a 00                	push   $0x0
  800177:	e8 0a 12 00 00       	call   801386 <sys_destroy_env>
  80017c:	83 c4 10             	add    $0x10,%esp
}
  80017f:	90                   	nop
  800180:	c9                   	leave  
  800181:	c3                   	ret    

00800182 <exit>:

void
exit(void)
{
  800182:	55                   	push   %ebp
  800183:	89 e5                	mov    %esp,%ebp
  800185:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800188:	e8 5f 12 00 00       	call   8013ec <sys_exit_env>
}
  80018d:	90                   	nop
  80018e:	c9                   	leave  
  80018f:	c3                   	ret    

00800190 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800196:	8b 45 0c             	mov    0xc(%ebp),%eax
  800199:	8b 00                	mov    (%eax),%eax
  80019b:	8d 48 01             	lea    0x1(%eax),%ecx
  80019e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a1:	89 0a                	mov    %ecx,(%edx)
  8001a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a6:	88 d1                	mov    %dl,%cl
  8001a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ab:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b9:	75 2c                	jne    8001e7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001bb:	a0 24 20 80 00       	mov    0x802024,%al
  8001c0:	0f b6 c0             	movzbl %al,%eax
  8001c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c6:	8b 12                	mov    (%edx),%edx
  8001c8:	89 d1                	mov    %edx,%ecx
  8001ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cd:	83 c2 08             	add    $0x8,%edx
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	50                   	push   %eax
  8001d4:	51                   	push   %ecx
  8001d5:	52                   	push   %edx
  8001d6:	e8 3e 0e 00 00       	call   801019 <sys_cputs>
  8001db:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ea:	8b 40 04             	mov    0x4(%eax),%eax
  8001ed:	8d 50 01             	lea    0x1(%eax),%edx
  8001f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001f6:	90                   	nop
  8001f7:	c9                   	leave  
  8001f8:	c3                   	ret    

008001f9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800202:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800209:	00 00 00 
	b.cnt = 0;
  80020c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800213:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800216:	ff 75 0c             	pushl  0xc(%ebp)
  800219:	ff 75 08             	pushl  0x8(%ebp)
  80021c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800222:	50                   	push   %eax
  800223:	68 90 01 80 00       	push   $0x800190
  800228:	e8 11 02 00 00       	call   80043e <vprintfmt>
  80022d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800230:	a0 24 20 80 00       	mov    0x802024,%al
  800235:	0f b6 c0             	movzbl %al,%eax
  800238:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80023e:	83 ec 04             	sub    $0x4,%esp
  800241:	50                   	push   %eax
  800242:	52                   	push   %edx
  800243:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800249:	83 c0 08             	add    $0x8,%eax
  80024c:	50                   	push   %eax
  80024d:	e8 c7 0d 00 00       	call   801019 <sys_cputs>
  800252:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800255:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  80025c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <cprintf>:

int cprintf(const char *fmt, ...) {
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80026a:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  800271:	8d 45 0c             	lea    0xc(%ebp),%eax
  800274:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800277:	8b 45 08             	mov    0x8(%ebp),%eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	ff 75 f4             	pushl  -0xc(%ebp)
  800280:	50                   	push   %eax
  800281:	e8 73 ff ff ff       	call   8001f9 <vcprintf>
  800286:	83 c4 10             	add    $0x10,%esp
  800289:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80028f:	c9                   	leave  
  800290:	c3                   	ret    

00800291 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800291:	55                   	push   %ebp
  800292:	89 e5                	mov    %esp,%ebp
  800294:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800297:	e8 2b 0f 00 00       	call   8011c7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80029f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ab:	50                   	push   %eax
  8002ac:	e8 48 ff ff ff       	call   8001f9 <vcprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
  8002b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8002b7:	e8 25 0f 00 00       	call   8011e1 <sys_enable_interrupt>
	return cnt;
  8002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002bf:	c9                   	leave  
  8002c0:	c3                   	ret    

008002c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c1:	55                   	push   %ebp
  8002c2:	89 e5                	mov    %esp,%ebp
  8002c4:	53                   	push   %ebx
  8002c5:	83 ec 14             	sub    $0x14,%esp
  8002c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002d4:	8b 45 18             	mov    0x18(%ebp),%eax
  8002d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8002dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002df:	77 55                	ja     800336 <printnum+0x75>
  8002e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e4:	72 05                	jb     8002eb <printnum+0x2a>
  8002e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e9:	77 4b                	ja     800336 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002eb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002f1:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f9:	52                   	push   %edx
  8002fa:	50                   	push   %eax
  8002fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8002fe:	ff 75 f0             	pushl  -0x10(%ebp)
  800301:	e8 46 13 00 00       	call   80164c <__udivdi3>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	ff 75 20             	pushl  0x20(%ebp)
  80030f:	53                   	push   %ebx
  800310:	ff 75 18             	pushl  0x18(%ebp)
  800313:	52                   	push   %edx
  800314:	50                   	push   %eax
  800315:	ff 75 0c             	pushl  0xc(%ebp)
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	e8 a1 ff ff ff       	call   8002c1 <printnum>
  800320:	83 c4 20             	add    $0x20,%esp
  800323:	eb 1a                	jmp    80033f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800325:	83 ec 08             	sub    $0x8,%esp
  800328:	ff 75 0c             	pushl  0xc(%ebp)
  80032b:	ff 75 20             	pushl  0x20(%ebp)
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	ff d0                	call   *%eax
  800333:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800336:	ff 4d 1c             	decl   0x1c(%ebp)
  800339:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80033d:	7f e6                	jg     800325 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800342:	bb 00 00 00 00       	mov    $0x0,%ebx
  800347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80034d:	53                   	push   %ebx
  80034e:	51                   	push   %ecx
  80034f:	52                   	push   %edx
  800350:	50                   	push   %eax
  800351:	e8 06 14 00 00       	call   80175c <__umoddi3>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	05 d4 1b 80 00       	add    $0x801bd4,%eax
  80035e:	8a 00                	mov    (%eax),%al
  800360:	0f be c0             	movsbl %al,%eax
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	ff 75 0c             	pushl  0xc(%ebp)
  800369:	50                   	push   %eax
  80036a:	8b 45 08             	mov    0x8(%ebp),%eax
  80036d:	ff d0                	call   *%eax
  80036f:	83 c4 10             	add    $0x10,%esp
}
  800372:	90                   	nop
  800373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80037b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80037f:	7e 1c                	jle    80039d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	8b 00                	mov    (%eax),%eax
  800386:	8d 50 08             	lea    0x8(%eax),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	89 10                	mov    %edx,(%eax)
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	8b 00                	mov    (%eax),%eax
  800393:	83 e8 08             	sub    $0x8,%eax
  800396:	8b 50 04             	mov    0x4(%eax),%edx
  800399:	8b 00                	mov    (%eax),%eax
  80039b:	eb 40                	jmp    8003dd <getuint+0x65>
	else if (lflag)
  80039d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003a1:	74 1e                	je     8003c1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	8d 50 04             	lea    0x4(%eax),%edx
  8003ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ae:	89 10                	mov    %edx,(%eax)
  8003b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b3:	8b 00                	mov    (%eax),%eax
  8003b5:	83 e8 04             	sub    $0x4,%eax
  8003b8:	8b 00                	mov    (%eax),%eax
  8003ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8003bf:	eb 1c                	jmp    8003dd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	8d 50 04             	lea    0x4(%eax),%edx
  8003c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cc:	89 10                	mov    %edx,(%eax)
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	83 e8 04             	sub    $0x4,%eax
  8003d6:	8b 00                	mov    (%eax),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e6:	7e 1c                	jle    800404 <getint+0x25>
		return va_arg(*ap, long long);
  8003e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	8d 50 08             	lea    0x8(%eax),%edx
  8003f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f3:	89 10                	mov    %edx,(%eax)
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	8b 00                	mov    (%eax),%eax
  8003fa:	83 e8 08             	sub    $0x8,%eax
  8003fd:	8b 50 04             	mov    0x4(%eax),%edx
  800400:	8b 00                	mov    (%eax),%eax
  800402:	eb 38                	jmp    80043c <getint+0x5d>
	else if (lflag)
  800404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800408:	74 1a                	je     800424 <getint+0x45>
		return va_arg(*ap, long);
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	8d 50 04             	lea    0x4(%eax),%edx
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	89 10                	mov    %edx,(%eax)
  800417:	8b 45 08             	mov    0x8(%ebp),%eax
  80041a:	8b 00                	mov    (%eax),%eax
  80041c:	83 e8 04             	sub    $0x4,%eax
  80041f:	8b 00                	mov    (%eax),%eax
  800421:	99                   	cltd   
  800422:	eb 18                	jmp    80043c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	8d 50 04             	lea    0x4(%eax),%edx
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	89 10                	mov    %edx,(%eax)
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	83 e8 04             	sub    $0x4,%eax
  800439:	8b 00                	mov    (%eax),%eax
  80043b:	99                   	cltd   
}
  80043c:	5d                   	pop    %ebp
  80043d:	c3                   	ret    

0080043e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	56                   	push   %esi
  800442:	53                   	push   %ebx
  800443:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800446:	eb 17                	jmp    80045f <vprintfmt+0x21>
			if (ch == '\0')
  800448:	85 db                	test   %ebx,%ebx
  80044a:	0f 84 af 03 00 00    	je     8007ff <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800450:	83 ec 08             	sub    $0x8,%esp
  800453:	ff 75 0c             	pushl  0xc(%ebp)
  800456:	53                   	push   %ebx
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	ff d0                	call   *%eax
  80045c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	8d 50 01             	lea    0x1(%eax),%edx
  800465:	89 55 10             	mov    %edx,0x10(%ebp)
  800468:	8a 00                	mov    (%eax),%al
  80046a:	0f b6 d8             	movzbl %al,%ebx
  80046d:	83 fb 25             	cmp    $0x25,%ebx
  800470:	75 d6                	jne    800448 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800472:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800476:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80047d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800484:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80048b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800492:	8b 45 10             	mov    0x10(%ebp),%eax
  800495:	8d 50 01             	lea    0x1(%eax),%edx
  800498:	89 55 10             	mov    %edx,0x10(%ebp)
  80049b:	8a 00                	mov    (%eax),%al
  80049d:	0f b6 d8             	movzbl %al,%ebx
  8004a0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004a3:	83 f8 55             	cmp    $0x55,%eax
  8004a6:	0f 87 2b 03 00 00    	ja     8007d7 <vprintfmt+0x399>
  8004ac:	8b 04 85 f8 1b 80 00 	mov    0x801bf8(,%eax,4),%eax
  8004b3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004b5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004b9:	eb d7                	jmp    800492 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004bb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004bf:	eb d1                	jmp    800492 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cb:	89 d0                	mov    %edx,%eax
  8004cd:	c1 e0 02             	shl    $0x2,%eax
  8004d0:	01 d0                	add    %edx,%eax
  8004d2:	01 c0                	add    %eax,%eax
  8004d4:	01 d8                	add    %ebx,%eax
  8004d6:	83 e8 30             	sub    $0x30,%eax
  8004d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004df:	8a 00                	mov    (%eax),%al
  8004e1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004e4:	83 fb 2f             	cmp    $0x2f,%ebx
  8004e7:	7e 3e                	jle    800527 <vprintfmt+0xe9>
  8004e9:	83 fb 39             	cmp    $0x39,%ebx
  8004ec:	7f 39                	jg     800527 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ee:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004f1:	eb d5                	jmp    8004c8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f6:	83 c0 04             	add    $0x4,%eax
  8004f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	83 e8 04             	sub    $0x4,%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800507:	eb 1f                	jmp    800528 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800509:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80050d:	79 83                	jns    800492 <vprintfmt+0x54>
				width = 0;
  80050f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800516:	e9 77 ff ff ff       	jmp    800492 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80051b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800522:	e9 6b ff ff ff       	jmp    800492 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800527:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800528:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80052c:	0f 89 60 ff ff ff    	jns    800492 <vprintfmt+0x54>
				width = precision, precision = -1;
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800538:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80053f:	e9 4e ff ff ff       	jmp    800492 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800544:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800547:	e9 46 ff ff ff       	jmp    800492 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80054c:	8b 45 14             	mov    0x14(%ebp),%eax
  80054f:	83 c0 04             	add    $0x4,%eax
  800552:	89 45 14             	mov    %eax,0x14(%ebp)
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	83 e8 04             	sub    $0x4,%eax
  80055b:	8b 00                	mov    (%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	ff 75 0c             	pushl  0xc(%ebp)
  800563:	50                   	push   %eax
  800564:	8b 45 08             	mov    0x8(%ebp),%eax
  800567:	ff d0                	call   *%eax
  800569:	83 c4 10             	add    $0x10,%esp
			break;
  80056c:	e9 89 02 00 00       	jmp    8007fa <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	83 c0 04             	add    $0x4,%eax
  800577:	89 45 14             	mov    %eax,0x14(%ebp)
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	83 e8 04             	sub    $0x4,%eax
  800580:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800582:	85 db                	test   %ebx,%ebx
  800584:	79 02                	jns    800588 <vprintfmt+0x14a>
				err = -err;
  800586:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800588:	83 fb 64             	cmp    $0x64,%ebx
  80058b:	7f 0b                	jg     800598 <vprintfmt+0x15a>
  80058d:	8b 34 9d 40 1a 80 00 	mov    0x801a40(,%ebx,4),%esi
  800594:	85 f6                	test   %esi,%esi
  800596:	75 19                	jne    8005b1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800598:	53                   	push   %ebx
  800599:	68 e5 1b 80 00       	push   $0x801be5
  80059e:	ff 75 0c             	pushl  0xc(%ebp)
  8005a1:	ff 75 08             	pushl  0x8(%ebp)
  8005a4:	e8 5e 02 00 00       	call   800807 <printfmt>
  8005a9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005ac:	e9 49 02 00 00       	jmp    8007fa <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005b1:	56                   	push   %esi
  8005b2:	68 ee 1b 80 00       	push   $0x801bee
  8005b7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ba:	ff 75 08             	pushl  0x8(%ebp)
  8005bd:	e8 45 02 00 00       	call   800807 <printfmt>
  8005c2:	83 c4 10             	add    $0x10,%esp
			break;
  8005c5:	e9 30 02 00 00       	jmp    8007fa <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	83 c0 04             	add    $0x4,%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	83 e8 04             	sub    $0x4,%eax
  8005d9:	8b 30                	mov    (%eax),%esi
  8005db:	85 f6                	test   %esi,%esi
  8005dd:	75 05                	jne    8005e4 <vprintfmt+0x1a6>
				p = "(null)";
  8005df:	be f1 1b 80 00       	mov    $0x801bf1,%esi
			if (width > 0 && padc != '-')
  8005e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e8:	7e 6d                	jle    800657 <vprintfmt+0x219>
  8005ea:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005ee:	74 67                	je     800657 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	50                   	push   %eax
  8005f7:	56                   	push   %esi
  8005f8:	e8 0c 03 00 00       	call   800909 <strnlen>
  8005fd:	83 c4 10             	add    $0x10,%esp
  800600:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800603:	eb 16                	jmp    80061b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800605:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	ff 75 0c             	pushl  0xc(%ebp)
  80060f:	50                   	push   %eax
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	ff d0                	call   *%eax
  800615:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800618:	ff 4d e4             	decl   -0x1c(%ebp)
  80061b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061f:	7f e4                	jg     800605 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800621:	eb 34                	jmp    800657 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800623:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800627:	74 1c                	je     800645 <vprintfmt+0x207>
  800629:	83 fb 1f             	cmp    $0x1f,%ebx
  80062c:	7e 05                	jle    800633 <vprintfmt+0x1f5>
  80062e:	83 fb 7e             	cmp    $0x7e,%ebx
  800631:	7e 12                	jle    800645 <vprintfmt+0x207>
					putch('?', putdat);
  800633:	83 ec 08             	sub    $0x8,%esp
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	6a 3f                	push   $0x3f
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	eb 0f                	jmp    800654 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	ff 75 0c             	pushl  0xc(%ebp)
  80064b:	53                   	push   %ebx
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800654:	ff 4d e4             	decl   -0x1c(%ebp)
  800657:	89 f0                	mov    %esi,%eax
  800659:	8d 70 01             	lea    0x1(%eax),%esi
  80065c:	8a 00                	mov    (%eax),%al
  80065e:	0f be d8             	movsbl %al,%ebx
  800661:	85 db                	test   %ebx,%ebx
  800663:	74 24                	je     800689 <vprintfmt+0x24b>
  800665:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800669:	78 b8                	js     800623 <vprintfmt+0x1e5>
  80066b:	ff 4d e0             	decl   -0x20(%ebp)
  80066e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800672:	79 af                	jns    800623 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800674:	eb 13                	jmp    800689 <vprintfmt+0x24b>
				putch(' ', putdat);
  800676:	83 ec 08             	sub    $0x8,%esp
  800679:	ff 75 0c             	pushl  0xc(%ebp)
  80067c:	6a 20                	push   $0x20
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	ff d0                	call   *%eax
  800683:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800686:	ff 4d e4             	decl   -0x1c(%ebp)
  800689:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068d:	7f e7                	jg     800676 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80068f:	e9 66 01 00 00       	jmp    8007fa <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	ff 75 e8             	pushl  -0x18(%ebp)
  80069a:	8d 45 14             	lea    0x14(%ebp),%eax
  80069d:	50                   	push   %eax
  80069e:	e8 3c fd ff ff       	call   8003df <getint>
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b2:	85 d2                	test   %edx,%edx
  8006b4:	79 23                	jns    8006d9 <vprintfmt+0x29b>
				putch('-', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	ff 75 0c             	pushl  0xc(%ebp)
  8006bc:	6a 2d                	push   $0x2d
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	ff d0                	call   *%eax
  8006c3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006cc:	f7 d8                	neg    %eax
  8006ce:	83 d2 00             	adc    $0x0,%edx
  8006d1:	f7 da                	neg    %edx
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006d9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006e0:	e9 bc 00 00 00       	jmp    8007a1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8006eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8006ee:	50                   	push   %eax
  8006ef:	e8 84 fc ff ff       	call   800378 <getuint>
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8006fd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800704:	e9 98 00 00 00       	jmp    8007a1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800709:	83 ec 08             	sub    $0x8,%esp
  80070c:	ff 75 0c             	pushl  0xc(%ebp)
  80070f:	6a 58                	push   $0x58
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	ff d0                	call   *%eax
  800716:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 0c             	pushl  0xc(%ebp)
  80071f:	6a 58                	push   $0x58
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	ff d0                	call   *%eax
  800726:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	6a 58                	push   $0x58
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	ff d0                	call   *%eax
  800736:	83 c4 10             	add    $0x10,%esp
			break;
  800739:	e9 bc 00 00 00       	jmp    8007fa <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	6a 30                	push   $0x30
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	ff d0                	call   *%eax
  80074b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80074e:	83 ec 08             	sub    $0x8,%esp
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	6a 78                	push   $0x78
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	ff d0                	call   *%eax
  80075b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	83 c0 04             	add    $0x4,%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80076f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800772:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800779:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800780:	eb 1f                	jmp    8007a1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 e8             	pushl  -0x18(%ebp)
  800788:	8d 45 14             	lea    0x14(%ebp),%eax
  80078b:	50                   	push   %eax
  80078c:	e8 e7 fb ff ff       	call   800378 <getuint>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800797:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80079a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a8:	83 ec 04             	sub    $0x4,%esp
  8007ab:	52                   	push   %edx
  8007ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007af:	50                   	push   %eax
  8007b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8007b6:	ff 75 0c             	pushl  0xc(%ebp)
  8007b9:	ff 75 08             	pushl  0x8(%ebp)
  8007bc:	e8 00 fb ff ff       	call   8002c1 <printnum>
  8007c1:	83 c4 20             	add    $0x20,%esp
			break;
  8007c4:	eb 34                	jmp    8007fa <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
			break;
  8007d5:	eb 23                	jmp    8007fa <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007d7:	83 ec 08             	sub    $0x8,%esp
  8007da:	ff 75 0c             	pushl  0xc(%ebp)
  8007dd:	6a 25                	push   $0x25
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	ff d0                	call   *%eax
  8007e4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e7:	ff 4d 10             	decl   0x10(%ebp)
  8007ea:	eb 03                	jmp    8007ef <vprintfmt+0x3b1>
  8007ec:	ff 4d 10             	decl   0x10(%ebp)
  8007ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f2:	48                   	dec    %eax
  8007f3:	8a 00                	mov    (%eax),%al
  8007f5:	3c 25                	cmp    $0x25,%al
  8007f7:	75 f3                	jne    8007ec <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8007f9:	90                   	nop
		}
	}
  8007fa:	e9 47 fc ff ff       	jmp    800446 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8007ff:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800800:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800803:	5b                   	pop    %ebx
  800804:	5e                   	pop    %esi
  800805:	5d                   	pop    %ebp
  800806:	c3                   	ret    

00800807 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80080d:	8d 45 10             	lea    0x10(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800816:	8b 45 10             	mov    0x10(%ebp),%eax
  800819:	ff 75 f4             	pushl  -0xc(%ebp)
  80081c:	50                   	push   %eax
  80081d:	ff 75 0c             	pushl  0xc(%ebp)
  800820:	ff 75 08             	pushl  0x8(%ebp)
  800823:	e8 16 fc ff ff       	call   80043e <vprintfmt>
  800828:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80082b:	90                   	nop
  80082c:	c9                   	leave  
  80082d:	c3                   	ret    

0080082e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800831:	8b 45 0c             	mov    0xc(%ebp),%eax
  800834:	8b 40 08             	mov    0x8(%eax),%eax
  800837:	8d 50 01             	lea    0x1(%eax),%edx
  80083a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80083d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800840:	8b 45 0c             	mov    0xc(%ebp),%eax
  800843:	8b 10                	mov    (%eax),%edx
  800845:	8b 45 0c             	mov    0xc(%ebp),%eax
  800848:	8b 40 04             	mov    0x4(%eax),%eax
  80084b:	39 c2                	cmp    %eax,%edx
  80084d:	73 12                	jae    800861 <sprintputch+0x33>
		*b->buf++ = ch;
  80084f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	8d 48 01             	lea    0x1(%eax),%ecx
  800857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085a:	89 0a                	mov    %ecx,(%edx)
  80085c:	8b 55 08             	mov    0x8(%ebp),%edx
  80085f:	88 10                	mov    %dl,(%eax)
}
  800861:	90                   	nop
  800862:	5d                   	pop    %ebp
  800863:	c3                   	ret    

00800864 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800870:	8b 45 0c             	mov    0xc(%ebp),%eax
  800873:	8d 50 ff             	lea    -0x1(%eax),%edx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	01 d0                	add    %edx,%eax
  80087b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800885:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800889:	74 06                	je     800891 <vsnprintf+0x2d>
  80088b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088f:	7f 07                	jg     800898 <vsnprintf+0x34>
		return -E_INVAL;
  800891:	b8 03 00 00 00       	mov    $0x3,%eax
  800896:	eb 20                	jmp    8008b8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800898:	ff 75 14             	pushl  0x14(%ebp)
  80089b:	ff 75 10             	pushl  0x10(%ebp)
  80089e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a1:	50                   	push   %eax
  8008a2:	68 2e 08 80 00       	push   $0x80082e
  8008a7:	e8 92 fb ff ff       	call   80043e <vprintfmt>
  8008ac:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c0:	8d 45 10             	lea    0x10(%ebp),%eax
  8008c3:	83 c0 04             	add    $0x4,%eax
  8008c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cf:	50                   	push   %eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	e8 89 ff ff ff       	call   800864 <vsnprintf>
  8008db:	83 c4 10             	add    $0x10,%esp
  8008de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008e4:	c9                   	leave  
  8008e5:	c3                   	ret    

008008e6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8008ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8008f3:	eb 06                	jmp    8008fb <strlen+0x15>
		n++;
  8008f5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f8:	ff 45 08             	incl   0x8(%ebp)
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	84 c0                	test   %al,%al
  800902:	75 f1                	jne    8008f5 <strlen+0xf>
		n++;
	return n;
  800904:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80090f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800916:	eb 09                	jmp    800921 <strnlen+0x18>
		n++;
  800918:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091b:	ff 45 08             	incl   0x8(%ebp)
  80091e:	ff 4d 0c             	decl   0xc(%ebp)
  800921:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800925:	74 09                	je     800930 <strnlen+0x27>
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8a 00                	mov    (%eax),%al
  80092c:	84 c0                	test   %al,%al
  80092e:	75 e8                	jne    800918 <strnlen+0xf>
		n++;
	return n;
  800930:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800933:	c9                   	leave  
  800934:	c3                   	ret    

00800935 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800941:	90                   	nop
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8d 50 01             	lea    0x1(%eax),%edx
  800948:	89 55 08             	mov    %edx,0x8(%ebp)
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800951:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800954:	8a 12                	mov    (%edx),%dl
  800956:	88 10                	mov    %dl,(%eax)
  800958:	8a 00                	mov    (%eax),%al
  80095a:	84 c0                	test   %al,%al
  80095c:	75 e4                	jne    800942 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80095e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80096f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800976:	eb 1f                	jmp    800997 <strncpy+0x34>
		*dst++ = *src;
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8d 50 01             	lea    0x1(%eax),%edx
  80097e:	89 55 08             	mov    %edx,0x8(%ebp)
  800981:	8b 55 0c             	mov    0xc(%ebp),%edx
  800984:	8a 12                	mov    (%edx),%dl
  800986:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	8a 00                	mov    (%eax),%al
  80098d:	84 c0                	test   %al,%al
  80098f:	74 03                	je     800994 <strncpy+0x31>
			src++;
  800991:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800994:	ff 45 fc             	incl   -0x4(%ebp)
  800997:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80099a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80099d:	72 d9                	jb     800978 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80099f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009a2:	c9                   	leave  
  8009a3:	c3                   	ret    

008009a4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009a4:	55                   	push   %ebp
  8009a5:	89 e5                	mov    %esp,%ebp
  8009a7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009b4:	74 30                	je     8009e6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009b6:	eb 16                	jmp    8009ce <strlcpy+0x2a>
			*dst++ = *src++;
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 08             	mov    %edx,0x8(%ebp)
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009c7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009ca:	8a 12                	mov    (%edx),%dl
  8009cc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009ce:	ff 4d 10             	decl   0x10(%ebp)
  8009d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009d5:	74 09                	je     8009e0 <strlcpy+0x3c>
  8009d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009da:	8a 00                	mov    (%eax),%al
  8009dc:	84 c0                	test   %al,%al
  8009de:	75 d8                	jne    8009b8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009ec:	29 c2                	sub    %eax,%edx
  8009ee:	89 d0                	mov    %edx,%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8009f5:	eb 06                	jmp    8009fd <strcmp+0xb>
		p++, q++;
  8009f7:	ff 45 08             	incl   0x8(%ebp)
  8009fa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	8a 00                	mov    (%eax),%al
  800a02:	84 c0                	test   %al,%al
  800a04:	74 0e                	je     800a14 <strcmp+0x22>
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8a 10                	mov    (%eax),%dl
  800a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	38 c2                	cmp    %al,%dl
  800a12:	74 e3                	je     8009f7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	0f b6 d0             	movzbl %al,%edx
  800a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1f:	8a 00                	mov    (%eax),%al
  800a21:	0f b6 c0             	movzbl %al,%eax
  800a24:	29 c2                	sub    %eax,%edx
  800a26:	89 d0                	mov    %edx,%eax
}
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a2d:	eb 09                	jmp    800a38 <strncmp+0xe>
		n--, p++, q++;
  800a2f:	ff 4d 10             	decl   0x10(%ebp)
  800a32:	ff 45 08             	incl   0x8(%ebp)
  800a35:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a3c:	74 17                	je     800a55 <strncmp+0x2b>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	74 0e                	je     800a55 <strncmp+0x2b>
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	8a 10                	mov    (%eax),%dl
  800a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4f:	8a 00                	mov    (%eax),%al
  800a51:	38 c2                	cmp    %al,%dl
  800a53:	74 da                	je     800a2f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a59:	75 07                	jne    800a62 <strncmp+0x38>
		return 0;
  800a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800a60:	eb 14                	jmp    800a76 <strncmp+0x4c>
	else
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

00800a78 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	83 ec 04             	sub    $0x4,%esp
  800a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a81:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a84:	eb 12                	jmp    800a98 <strchr+0x20>
		if (*s == c)
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8a 00                	mov    (%eax),%al
  800a8b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800a8e:	75 05                	jne    800a95 <strchr+0x1d>
			return (char *) s;
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	eb 11                	jmp    800aa6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a95:	ff 45 08             	incl   0x8(%ebp)
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	8a 00                	mov    (%eax),%al
  800a9d:	84 c0                	test   %al,%al
  800a9f:	75 e5                	jne    800a86 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800aa1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	83 ec 04             	sub    $0x4,%esp
  800aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ab4:	eb 0d                	jmp    800ac3 <strfind+0x1b>
		if (*s == c)
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8a 00                	mov    (%eax),%al
  800abb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800abe:	74 0e                	je     800ace <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ac0:	ff 45 08             	incl   0x8(%ebp)
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	8a 00                	mov    (%eax),%al
  800ac8:	84 c0                	test   %al,%al
  800aca:	75 ea                	jne    800ab6 <strfind+0xe>
  800acc:	eb 01                	jmp    800acf <strfind+0x27>
		if (*s == c)
			break;
  800ace:	90                   	nop
	return (char *) s;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ad2:	c9                   	leave  
  800ad3:	c3                   	ret    

00800ad4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ae0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ae6:	eb 0e                	jmp    800af6 <memset+0x22>
		*p++ = c;
  800ae8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800aeb:	8d 50 01             	lea    0x1(%eax),%edx
  800aee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800af6:	ff 4d f8             	decl   -0x8(%ebp)
  800af9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800afd:	79 e9                	jns    800ae8 <memset+0x14>
		*p++ = c;

	return v;
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b16:	eb 16                	jmp    800b2e <memcpy+0x2a>
		*d++ = *s++;
  800b18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1b:	8d 50 01             	lea    0x1(%eax),%edx
  800b1e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b27:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b2a:	8a 12                	mov    (%edx),%dl
  800b2c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b34:	89 55 10             	mov    %edx,0x10(%ebp)
  800b37:	85 c0                	test   %eax,%eax
  800b39:	75 dd                	jne    800b18 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b58:	73 50                	jae    800baa <memmove+0x6a>
  800b5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b60:	01 d0                	add    %edx,%eax
  800b62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b65:	76 43                	jbe    800baa <memmove+0x6a>
		s += n;
  800b67:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b70:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b73:	eb 10                	jmp    800b85 <memmove+0x45>
			*--d = *--s;
  800b75:	ff 4d f8             	decl   -0x8(%ebp)
  800b78:	ff 4d fc             	decl   -0x4(%ebp)
  800b7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7e:	8a 10                	mov    (%eax),%dl
  800b80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b83:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b85:	8b 45 10             	mov    0x10(%ebp),%eax
  800b88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b8e:	85 c0                	test   %eax,%eax
  800b90:	75 e3                	jne    800b75 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b92:	eb 23                	jmp    800bb7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800b94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b97:	8d 50 01             	lea    0x1(%eax),%edx
  800b9a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ba0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ba3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ba6:	8a 12                	mov    (%edx),%dl
  800ba8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800baa:	8b 45 10             	mov    0x10(%ebp),%eax
  800bad:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb3:	85 c0                	test   %eax,%eax
  800bb5:	75 dd                	jne    800b94 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bce:	eb 2a                	jmp    800bfa <memcmp+0x3e>
		if (*s1 != *s2)
  800bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bd3:	8a 10                	mov    (%eax),%dl
  800bd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bd8:	8a 00                	mov    (%eax),%al
  800bda:	38 c2                	cmp    %al,%dl
  800bdc:	74 16                	je     800bf4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be1:	8a 00                	mov    (%eax),%al
  800be3:	0f b6 d0             	movzbl %al,%edx
  800be6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800be9:	8a 00                	mov    (%eax),%al
  800beb:	0f b6 c0             	movzbl %al,%eax
  800bee:	29 c2                	sub    %eax,%edx
  800bf0:	89 d0                	mov    %edx,%eax
  800bf2:	eb 18                	jmp    800c0c <memcmp+0x50>
		s1++, s2++;
  800bf4:	ff 45 fc             	incl   -0x4(%ebp)
  800bf7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800bfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c00:	89 55 10             	mov    %edx,0x10(%ebp)
  800c03:	85 c0                	test   %eax,%eax
  800c05:	75 c9                	jne    800bd0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c14:	8b 55 08             	mov    0x8(%ebp),%edx
  800c17:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1a:	01 d0                	add    %edx,%eax
  800c1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c1f:	eb 15                	jmp    800c36 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8a 00                	mov    (%eax),%al
  800c26:	0f b6 d0             	movzbl %al,%edx
  800c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2c:	0f b6 c0             	movzbl %al,%eax
  800c2f:	39 c2                	cmp    %eax,%edx
  800c31:	74 0d                	je     800c40 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c33:	ff 45 08             	incl   0x8(%ebp)
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c3c:	72 e3                	jb     800c21 <memfind+0x13>
  800c3e:	eb 01                	jmp    800c41 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c40:	90                   	nop
	return (void *) s;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5a:	eb 03                	jmp    800c5f <strtol+0x19>
		s++;
  800c5c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	3c 20                	cmp    $0x20,%al
  800c66:	74 f4                	je     800c5c <strtol+0x16>
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	3c 09                	cmp    $0x9,%al
  800c6f:	74 eb                	je     800c5c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	3c 2b                	cmp    $0x2b,%al
  800c78:	75 05                	jne    800c7f <strtol+0x39>
		s++;
  800c7a:	ff 45 08             	incl   0x8(%ebp)
  800c7d:	eb 13                	jmp    800c92 <strtol+0x4c>
	else if (*s == '-')
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8a 00                	mov    (%eax),%al
  800c84:	3c 2d                	cmp    $0x2d,%al
  800c86:	75 0a                	jne    800c92 <strtol+0x4c>
		s++, neg = 1;
  800c88:	ff 45 08             	incl   0x8(%ebp)
  800c8b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c96:	74 06                	je     800c9e <strtol+0x58>
  800c98:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800c9c:	75 20                	jne    800cbe <strtol+0x78>
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	3c 30                	cmp    $0x30,%al
  800ca5:	75 17                	jne    800cbe <strtol+0x78>
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	40                   	inc    %eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	3c 78                	cmp    $0x78,%al
  800caf:	75 0d                	jne    800cbe <strtol+0x78>
		s += 2, base = 16;
  800cb1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cb5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cbc:	eb 28                	jmp    800ce6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc2:	75 15                	jne    800cd9 <strtol+0x93>
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	3c 30                	cmp    $0x30,%al
  800ccb:	75 0c                	jne    800cd9 <strtol+0x93>
		s++, base = 8;
  800ccd:	ff 45 08             	incl   0x8(%ebp)
  800cd0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cd7:	eb 0d                	jmp    800ce6 <strtol+0xa0>
	else if (base == 0)
  800cd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdd:	75 07                	jne    800ce6 <strtol+0xa0>
		base = 10;
  800cdf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	3c 2f                	cmp    $0x2f,%al
  800ced:	7e 19                	jle    800d08 <strtol+0xc2>
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	3c 39                	cmp    $0x39,%al
  800cf6:	7f 10                	jg     800d08 <strtol+0xc2>
			dig = *s - '0';
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	0f be c0             	movsbl %al,%eax
  800d00:	83 e8 30             	sub    $0x30,%eax
  800d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d06:	eb 42                	jmp    800d4a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	3c 60                	cmp    $0x60,%al
  800d0f:	7e 19                	jle    800d2a <strtol+0xe4>
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	3c 7a                	cmp    $0x7a,%al
  800d18:	7f 10                	jg     800d2a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f be c0             	movsbl %al,%eax
  800d22:	83 e8 57             	sub    $0x57,%eax
  800d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d28:	eb 20                	jmp    800d4a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	3c 40                	cmp    $0x40,%al
  800d31:	7e 39                	jle    800d6c <strtol+0x126>
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8a 00                	mov    (%eax),%al
  800d38:	3c 5a                	cmp    $0x5a,%al
  800d3a:	7f 30                	jg     800d6c <strtol+0x126>
			dig = *s - 'A' + 10;
  800d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f be c0             	movsbl %al,%eax
  800d44:	83 e8 37             	sub    $0x37,%eax
  800d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d4d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d50:	7d 19                	jge    800d6b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d52:	ff 45 08             	incl   0x8(%ebp)
  800d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d58:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d5c:	89 c2                	mov    %eax,%edx
  800d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d61:	01 d0                	add    %edx,%eax
  800d63:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d66:	e9 7b ff ff ff       	jmp    800ce6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d6b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d70:	74 08                	je     800d7a <strtol+0x134>
		*endptr = (char *) s;
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8b 55 08             	mov    0x8(%ebp),%edx
  800d78:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d7e:	74 07                	je     800d87 <strtol+0x141>
  800d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d83:	f7 d8                	neg    %eax
  800d85:	eb 03                	jmp    800d8a <strtol+0x144>
  800d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <ltostr>:

void
ltostr(long value, char *str)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800d92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800d99:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800da0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800da4:	79 13                	jns    800db9 <ltostr+0x2d>
	{
		neg = 1;
  800da6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800db3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800db6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dc1:	99                   	cltd   
  800dc2:	f7 f9                	idiv   %ecx
  800dc4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dca:	8d 50 01             	lea    0x1(%eax),%edx
  800dcd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dd0:	89 c2                	mov    %eax,%edx
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	01 d0                	add    %edx,%eax
  800dd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dda:	83 c2 30             	add    $0x30,%edx
  800ddd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ddf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800de7:	f7 e9                	imul   %ecx
  800de9:	c1 fa 02             	sar    $0x2,%edx
  800dec:	89 c8                	mov    %ecx,%eax
  800dee:	c1 f8 1f             	sar    $0x1f,%eax
  800df1:	29 c2                	sub    %eax,%edx
  800df3:	89 d0                	mov    %edx,%eax
  800df5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800df8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e00:	f7 e9                	imul   %ecx
  800e02:	c1 fa 02             	sar    $0x2,%edx
  800e05:	89 c8                	mov    %ecx,%eax
  800e07:	c1 f8 1f             	sar    $0x1f,%eax
  800e0a:	29 c2                	sub    %eax,%edx
  800e0c:	89 d0                	mov    %edx,%eax
  800e0e:	c1 e0 02             	shl    $0x2,%eax
  800e11:	01 d0                	add    %edx,%eax
  800e13:	01 c0                	add    %eax,%eax
  800e15:	29 c1                	sub    %eax,%ecx
  800e17:	89 ca                	mov    %ecx,%edx
  800e19:	85 d2                	test   %edx,%edx
  800e1b:	75 9c                	jne    800db9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e27:	48                   	dec    %eax
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e2b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e2f:	74 3d                	je     800e6e <ltostr+0xe2>
		start = 1 ;
  800e31:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e38:	eb 34                	jmp    800e6e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8a 00                	mov    (%eax),%al
  800e44:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	01 c2                	add    %eax,%edx
  800e4f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e55:	01 c8                	add    %ecx,%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	01 c2                	add    %eax,%edx
  800e63:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e66:	88 02                	mov    %al,(%edx)
		start++ ;
  800e68:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e6b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e71:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e74:	7c c4                	jl     800e3a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e76:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7c:	01 d0                	add    %edx,%eax
  800e7e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e81:	90                   	nop
  800e82:	c9                   	leave  
  800e83:	c3                   	ret    

00800e84 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e84:	55                   	push   %ebp
  800e85:	89 e5                	mov    %esp,%ebp
  800e87:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e8a:	ff 75 08             	pushl  0x8(%ebp)
  800e8d:	e8 54 fa ff ff       	call   8008e6 <strlen>
  800e92:	83 c4 04             	add    $0x4,%esp
  800e95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e98:	ff 75 0c             	pushl  0xc(%ebp)
  800e9b:	e8 46 fa ff ff       	call   8008e6 <strlen>
  800ea0:	83 c4 04             	add    $0x4,%esp
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ea6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ead:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb4:	eb 17                	jmp    800ecd <strcconcat+0x49>
		final[s] = str1[s] ;
  800eb6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebc:	01 c2                	add    %eax,%edx
  800ebe:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	01 c8                	add    %ecx,%eax
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800eca:	ff 45 fc             	incl   -0x4(%ebp)
  800ecd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ed3:	7c e1                	jl     800eb6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ed5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800edc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ee3:	eb 1f                	jmp    800f04 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee8:	8d 50 01             	lea    0x1(%eax),%edx
  800eeb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eee:	89 c2                	mov    %eax,%edx
  800ef0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef3:	01 c2                	add    %eax,%edx
  800ef5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	01 c8                	add    %ecx,%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f01:	ff 45 f8             	incl   -0x8(%ebp)
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f0a:	7c d9                	jl     800ee5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	01 d0                	add    %edx,%eax
  800f14:	c6 00 00             	movb   $0x0,(%eax)
}
  800f17:	90                   	nop
  800f18:	c9                   	leave  
  800f19:	c3                   	ret    

00800f1a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	8b 00                	mov    (%eax),%eax
  800f2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f32:	8b 45 10             	mov    0x10(%ebp),%eax
  800f35:	01 d0                	add    %edx,%eax
  800f37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f3d:	eb 0c                	jmp    800f4b <strsplit+0x31>
			*string++ = 0;
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8d 50 01             	lea    0x1(%eax),%edx
  800f45:	89 55 08             	mov    %edx,0x8(%ebp)
  800f48:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	84 c0                	test   %al,%al
  800f52:	74 18                	je     800f6c <strsplit+0x52>
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f be c0             	movsbl %al,%eax
  800f5c:	50                   	push   %eax
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	e8 13 fb ff ff       	call   800a78 <strchr>
  800f65:	83 c4 08             	add    $0x8,%esp
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 d3                	jne    800f3f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	84 c0                	test   %al,%al
  800f73:	74 5a                	je     800fcf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f75:	8b 45 14             	mov    0x14(%ebp),%eax
  800f78:	8b 00                	mov    (%eax),%eax
  800f7a:	83 f8 0f             	cmp    $0xf,%eax
  800f7d:	75 07                	jne    800f86 <strsplit+0x6c>
		{
			return 0;
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f84:	eb 66                	jmp    800fec <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f86:	8b 45 14             	mov    0x14(%ebp),%eax
  800f89:	8b 00                	mov    (%eax),%eax
  800f8b:	8d 48 01             	lea    0x1(%eax),%ecx
  800f8e:	8b 55 14             	mov    0x14(%ebp),%edx
  800f91:	89 0a                	mov    %ecx,(%edx)
  800f93:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9d:	01 c2                	add    %eax,%edx
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa4:	eb 03                	jmp    800fa9 <strsplit+0x8f>
			string++;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	84 c0                	test   %al,%al
  800fb0:	74 8b                	je     800f3d <strsplit+0x23>
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	0f be c0             	movsbl %al,%eax
  800fba:	50                   	push   %eax
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	e8 b5 fa ff ff       	call   800a78 <strchr>
  800fc3:	83 c4 08             	add    $0x8,%esp
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	74 dc                	je     800fa6 <strsplit+0x8c>
			string++;
	}
  800fca:	e9 6e ff ff ff       	jmp    800f3d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fcf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd3:	8b 00                	mov    (%eax),%eax
  800fd5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdf:	01 d0                	add    %edx,%eax
  800fe1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fe7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ffd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801000:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801003:	8b 7d 18             	mov    0x18(%ebp),%edi
  801006:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801009:	cd 30                	int    $0x30
  80100b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80100e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	5b                   	pop    %ebx
  801015:	5e                   	pop    %esi
  801016:	5f                   	pop    %edi
  801017:	5d                   	pop    %ebp
  801018:	c3                   	ret    

00801019 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 04             	sub    $0x4,%esp
  80101f:	8b 45 10             	mov    0x10(%ebp),%eax
  801022:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801025:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	6a 00                	push   $0x0
  80102e:	6a 00                	push   $0x0
  801030:	52                   	push   %edx
  801031:	ff 75 0c             	pushl  0xc(%ebp)
  801034:	50                   	push   %eax
  801035:	6a 00                	push   $0x0
  801037:	e8 b2 ff ff ff       	call   800fee <syscall>
  80103c:	83 c4 18             	add    $0x18,%esp
}
  80103f:	90                   	nop
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <sys_cgetc>:

int
sys_cgetc(void)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801045:	6a 00                	push   $0x0
  801047:	6a 00                	push   $0x0
  801049:	6a 00                	push   $0x0
  80104b:	6a 00                	push   $0x0
  80104d:	6a 00                	push   $0x0
  80104f:	6a 01                	push   $0x1
  801051:	e8 98 ff ff ff       	call   800fee <syscall>
  801056:	83 c4 18             	add    $0x18,%esp
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80105e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	6a 00                	push   $0x0
  801066:	6a 00                	push   $0x0
  801068:	6a 00                	push   $0x0
  80106a:	52                   	push   %edx
  80106b:	50                   	push   %eax
  80106c:	6a 05                	push   $0x5
  80106e:	e8 7b ff ff ff       	call   800fee <syscall>
  801073:	83 c4 18             	add    $0x18,%esp
}
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	56                   	push   %esi
  80107c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80107d:	8b 75 18             	mov    0x18(%ebp),%esi
  801080:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801083:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801086:	8b 55 0c             	mov    0xc(%ebp),%edx
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	56                   	push   %esi
  80108d:	53                   	push   %ebx
  80108e:	51                   	push   %ecx
  80108f:	52                   	push   %edx
  801090:	50                   	push   %eax
  801091:	6a 06                	push   $0x6
  801093:	e8 56 ff ff ff       	call   800fee <syscall>
  801098:	83 c4 18             	add    $0x18,%esp
}
  80109b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80109e:	5b                   	pop    %ebx
  80109f:	5e                   	pop    %esi
  8010a0:	5d                   	pop    %ebp
  8010a1:	c3                   	ret    

008010a2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ab:	6a 00                	push   $0x0
  8010ad:	6a 00                	push   $0x0
  8010af:	6a 00                	push   $0x0
  8010b1:	52                   	push   %edx
  8010b2:	50                   	push   %eax
  8010b3:	6a 07                	push   $0x7
  8010b5:	e8 34 ff ff ff       	call   800fee <syscall>
  8010ba:	83 c4 18             	add    $0x18,%esp
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8010c2:	6a 00                	push   $0x0
  8010c4:	6a 00                	push   $0x0
  8010c6:	6a 00                	push   $0x0
  8010c8:	ff 75 0c             	pushl  0xc(%ebp)
  8010cb:	ff 75 08             	pushl  0x8(%ebp)
  8010ce:	6a 08                	push   $0x8
  8010d0:	e8 19 ff ff ff       	call   800fee <syscall>
  8010d5:	83 c4 18             	add    $0x18,%esp
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8010dd:	6a 00                	push   $0x0
  8010df:	6a 00                	push   $0x0
  8010e1:	6a 00                	push   $0x0
  8010e3:	6a 00                	push   $0x0
  8010e5:	6a 00                	push   $0x0
  8010e7:	6a 09                	push   $0x9
  8010e9:	e8 00 ff ff ff       	call   800fee <syscall>
  8010ee:	83 c4 18             	add    $0x18,%esp
}
  8010f1:	c9                   	leave  
  8010f2:	c3                   	ret    

008010f3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8010f6:	6a 00                	push   $0x0
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 00                	push   $0x0
  8010fc:	6a 00                	push   $0x0
  8010fe:	6a 00                	push   $0x0
  801100:	6a 0a                	push   $0xa
  801102:	e8 e7 fe ff ff       	call   800fee <syscall>
  801107:	83 c4 18             	add    $0x18,%esp
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80110f:	6a 00                	push   $0x0
  801111:	6a 00                	push   $0x0
  801113:	6a 00                	push   $0x0
  801115:	6a 00                	push   $0x0
  801117:	6a 00                	push   $0x0
  801119:	6a 0b                	push   $0xb
  80111b:	e8 ce fe ff ff       	call   800fee <syscall>
  801120:	83 c4 18             	add    $0x18,%esp
}
  801123:	c9                   	leave  
  801124:	c3                   	ret    

00801125 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801128:	6a 00                	push   $0x0
  80112a:	6a 00                	push   $0x0
  80112c:	6a 00                	push   $0x0
  80112e:	ff 75 0c             	pushl  0xc(%ebp)
  801131:	ff 75 08             	pushl  0x8(%ebp)
  801134:	6a 0f                	push   $0xf
  801136:	e8 b3 fe ff ff       	call   800fee <syscall>
  80113b:	83 c4 18             	add    $0x18,%esp
	return;
  80113e:	90                   	nop
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801144:	6a 00                	push   $0x0
  801146:	6a 00                	push   $0x0
  801148:	6a 00                	push   $0x0
  80114a:	ff 75 0c             	pushl  0xc(%ebp)
  80114d:	ff 75 08             	pushl  0x8(%ebp)
  801150:	6a 10                	push   $0x10
  801152:	e8 97 fe ff ff       	call   800fee <syscall>
  801157:	83 c4 18             	add    $0x18,%esp
	return ;
  80115a:	90                   	nop
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	ff 75 10             	pushl  0x10(%ebp)
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	6a 11                	push   $0x11
  80116f:	e8 7a fe ff ff       	call   800fee <syscall>
  801174:	83 c4 18             	add    $0x18,%esp
	return ;
  801177:	90                   	nop
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	6a 0c                	push   $0xc
  801189:	e8 60 fe ff ff       	call   800fee <syscall>
  80118e:	83 c4 18             	add    $0x18,%esp
}
  801191:	c9                   	leave  
  801192:	c3                   	ret    

00801193 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801193:	55                   	push   %ebp
  801194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	6a 00                	push   $0x0
  80119c:	6a 00                	push   $0x0
  80119e:	ff 75 08             	pushl  0x8(%ebp)
  8011a1:	6a 0d                	push   $0xd
  8011a3:	e8 46 fe ff ff       	call   800fee <syscall>
  8011a8:	83 c4 18             	add    $0x18,%esp
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <sys_scarce_memory>:

void sys_scarce_memory()
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 0e                	push   $0xe
  8011bc:	e8 2d fe ff ff       	call   800fee <syscall>
  8011c1:	83 c4 18             	add    $0x18,%esp
}
  8011c4:	90                   	nop
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8011ca:	6a 00                	push   $0x0
  8011cc:	6a 00                	push   $0x0
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 13                	push   $0x13
  8011d6:	e8 13 fe ff ff       	call   800fee <syscall>
  8011db:	83 c4 18             	add    $0x18,%esp
}
  8011de:	90                   	nop
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 14                	push   $0x14
  8011f0:	e8 f9 fd ff ff       	call   800fee <syscall>
  8011f5:	83 c4 18             	add    $0x18,%esp
}
  8011f8:	90                   	nop
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <sys_cputc>:


void
sys_cputc(const char c)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801207:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80120b:	6a 00                	push   $0x0
  80120d:	6a 00                	push   $0x0
  80120f:	6a 00                	push   $0x0
  801211:	6a 00                	push   $0x0
  801213:	50                   	push   %eax
  801214:	6a 15                	push   $0x15
  801216:	e8 d3 fd ff ff       	call   800fee <syscall>
  80121b:	83 c4 18             	add    $0x18,%esp
}
  80121e:	90                   	nop
  80121f:	c9                   	leave  
  801220:	c3                   	ret    

00801221 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801224:	6a 00                	push   $0x0
  801226:	6a 00                	push   $0x0
  801228:	6a 00                	push   $0x0
  80122a:	6a 00                	push   $0x0
  80122c:	6a 00                	push   $0x0
  80122e:	6a 16                	push   $0x16
  801230:	e8 b9 fd ff ff       	call   800fee <syscall>
  801235:	83 c4 18             	add    $0x18,%esp
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	6a 00                	push   $0x0
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	ff 75 0c             	pushl  0xc(%ebp)
  80124a:	50                   	push   %eax
  80124b:	6a 17                	push   $0x17
  80124d:	e8 9c fd ff ff       	call   800fee <syscall>
  801252:	83 c4 18             	add    $0x18,%esp
}
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80125a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	6a 00                	push   $0x0
  801262:	6a 00                	push   $0x0
  801264:	6a 00                	push   $0x0
  801266:	52                   	push   %edx
  801267:	50                   	push   %eax
  801268:	6a 1a                	push   $0x1a
  80126a:	e8 7f fd ff ff       	call   800fee <syscall>
  80126f:	83 c4 18             	add    $0x18,%esp
}
  801272:	c9                   	leave  
  801273:	c3                   	ret    

00801274 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801274:	55                   	push   %ebp
  801275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127a:	8b 45 08             	mov    0x8(%ebp),%eax
  80127d:	6a 00                	push   $0x0
  80127f:	6a 00                	push   $0x0
  801281:	6a 00                	push   $0x0
  801283:	52                   	push   %edx
  801284:	50                   	push   %eax
  801285:	6a 18                	push   $0x18
  801287:	e8 62 fd ff ff       	call   800fee <syscall>
  80128c:	83 c4 18             	add    $0x18,%esp
}
  80128f:	90                   	nop
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801295:	8b 55 0c             	mov    0xc(%ebp),%edx
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	6a 00                	push   $0x0
  80129d:	6a 00                	push   $0x0
  80129f:	6a 00                	push   $0x0
  8012a1:	52                   	push   %edx
  8012a2:	50                   	push   %eax
  8012a3:	6a 19                	push   $0x19
  8012a5:	e8 44 fd ff ff       	call   800fee <syscall>
  8012aa:	83 c4 18             	add    $0x18,%esp
}
  8012ad:	90                   	nop
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 04             	sub    $0x4,%esp
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8012bc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8012bf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	6a 00                	push   $0x0
  8012c8:	51                   	push   %ecx
  8012c9:	52                   	push   %edx
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	50                   	push   %eax
  8012ce:	6a 1b                	push   $0x1b
  8012d0:	e8 19 fd ff ff       	call   800fee <syscall>
  8012d5:	83 c4 18             	add    $0x18,%esp
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	6a 00                	push   $0x0
  8012e5:	6a 00                	push   $0x0
  8012e7:	6a 00                	push   $0x0
  8012e9:	52                   	push   %edx
  8012ea:	50                   	push   %eax
  8012eb:	6a 1c                	push   $0x1c
  8012ed:	e8 fc fc ff ff       	call   800fee <syscall>
  8012f2:	83 c4 18             	add    $0x18,%esp
}
  8012f5:	c9                   	leave  
  8012f6:	c3                   	ret    

008012f7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8012fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	51                   	push   %ecx
  801308:	52                   	push   %edx
  801309:	50                   	push   %eax
  80130a:	6a 1d                	push   $0x1d
  80130c:	e8 dd fc ff ff       	call   800fee <syscall>
  801311:	83 c4 18             	add    $0x18,%esp
}
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801319:	8b 55 0c             	mov    0xc(%ebp),%edx
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	52                   	push   %edx
  801326:	50                   	push   %eax
  801327:	6a 1e                	push   $0x1e
  801329:	e8 c0 fc ff ff       	call   800fee <syscall>
  80132e:	83 c4 18             	add    $0x18,%esp
}
  801331:	c9                   	leave  
  801332:	c3                   	ret    

00801333 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 1f                	push   $0x1f
  801342:	e8 a7 fc ff ff       	call   800fee <syscall>
  801347:	83 c4 18             	add    $0x18,%esp
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	6a 00                	push   $0x0
  801354:	ff 75 14             	pushl  0x14(%ebp)
  801357:	ff 75 10             	pushl  0x10(%ebp)
  80135a:	ff 75 0c             	pushl  0xc(%ebp)
  80135d:	50                   	push   %eax
  80135e:	6a 20                	push   $0x20
  801360:	e8 89 fc ff ff       	call   800fee <syscall>
  801365:	83 c4 18             	add    $0x18,%esp
}
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	6a 00                	push   $0x0
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	50                   	push   %eax
  801379:	6a 21                	push   $0x21
  80137b:	e8 6e fc ff ff       	call   800fee <syscall>
  801380:	83 c4 18             	add    $0x18,%esp
}
  801383:	90                   	nop
  801384:	c9                   	leave  
  801385:	c3                   	ret    

00801386 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	6a 00                	push   $0x0
  80138e:	6a 00                	push   $0x0
  801390:	6a 00                	push   $0x0
  801392:	6a 00                	push   $0x0
  801394:	50                   	push   %eax
  801395:	6a 22                	push   $0x22
  801397:	e8 52 fc ff ff       	call   800fee <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
}
  80139f:	c9                   	leave  
  8013a0:	c3                   	ret    

008013a1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 00                	push   $0x0
  8013ae:	6a 02                	push   $0x2
  8013b0:	e8 39 fc ff ff       	call   800fee <syscall>
  8013b5:	83 c4 18             	add    $0x18,%esp
}
  8013b8:	c9                   	leave  
  8013b9:	c3                   	ret    

008013ba <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 00                	push   $0x0
  8013c7:	6a 03                	push   $0x3
  8013c9:	e8 20 fc ff ff       	call   800fee <syscall>
  8013ce:	83 c4 18             	add    $0x18,%esp
}
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 04                	push   $0x4
  8013e2:	e8 07 fc ff ff       	call   800fee <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <sys_exit_env>:


void sys_exit_env(void)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 23                	push   $0x23
  8013fb:	e8 ee fb ff ff       	call   800fee <syscall>
  801400:	83 c4 18             	add    $0x18,%esp
}
  801403:	90                   	nop
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80140c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80140f:	8d 50 04             	lea    0x4(%eax),%edx
  801412:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	52                   	push   %edx
  80141c:	50                   	push   %eax
  80141d:	6a 24                	push   $0x24
  80141f:	e8 ca fb ff ff       	call   800fee <syscall>
  801424:	83 c4 18             	add    $0x18,%esp
	return result;
  801427:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801430:	89 01                	mov    %eax,(%ecx)
  801432:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	c9                   	leave  
  801439:	c2 04 00             	ret    $0x4

0080143c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	ff 75 10             	pushl  0x10(%ebp)
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	ff 75 08             	pushl  0x8(%ebp)
  80144c:	6a 12                	push   $0x12
  80144e:	e8 9b fb ff ff       	call   800fee <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
	return ;
  801456:	90                   	nop
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <sys_rcr2>:
uint32 sys_rcr2()
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 25                	push   $0x25
  801468:	e8 81 fb ff ff       	call   800fee <syscall>
  80146d:	83 c4 18             	add    $0x18,%esp
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80147e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	50                   	push   %eax
  80148b:	6a 26                	push   $0x26
  80148d:	e8 5c fb ff ff       	call   800fee <syscall>
  801492:	83 c4 18             	add    $0x18,%esp
	return ;
  801495:	90                   	nop
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <rsttst>:
void rsttst()
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 28                	push   $0x28
  8014a7:	e8 42 fb ff ff       	call   800fee <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8014af:	90                   	nop
}
  8014b0:	c9                   	leave  
  8014b1:	c3                   	ret    

008014b2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8014be:	8b 55 18             	mov    0x18(%ebp),%edx
  8014c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014c5:	52                   	push   %edx
  8014c6:	50                   	push   %eax
  8014c7:	ff 75 10             	pushl  0x10(%ebp)
  8014ca:	ff 75 0c             	pushl  0xc(%ebp)
  8014cd:	ff 75 08             	pushl  0x8(%ebp)
  8014d0:	6a 27                	push   $0x27
  8014d2:	e8 17 fb ff ff       	call   800fee <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8014da:	90                   	nop
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <chktst>:
void chktst(uint32 n)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	ff 75 08             	pushl  0x8(%ebp)
  8014eb:	6a 29                	push   $0x29
  8014ed:	e8 fc fa ff ff       	call   800fee <syscall>
  8014f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f5:	90                   	nop
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <inctst>:

void inctst()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	6a 2a                	push   $0x2a
  801507:	e8 e2 fa ff ff       	call   800fee <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
	return ;
  80150f:	90                   	nop
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <gettst>:
uint32 gettst()
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	6a 2b                	push   $0x2b
  801521:	e8 c8 fa ff ff       	call   800fee <syscall>
  801526:	83 c4 18             	add    $0x18,%esp
}
  801529:	c9                   	leave  
  80152a:	c3                   	ret    

0080152b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80152b:	55                   	push   %ebp
  80152c:	89 e5                	mov    %esp,%ebp
  80152e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 2c                	push   $0x2c
  80153d:	e8 ac fa ff ff       	call   800fee <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
  801545:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801548:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80154c:	75 07                	jne    801555 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80154e:	b8 01 00 00 00       	mov    $0x1,%eax
  801553:	eb 05                	jmp    80155a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801555:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 00                	push   $0x0
  80156a:	6a 00                	push   $0x0
  80156c:	6a 2c                	push   $0x2c
  80156e:	e8 7b fa ff ff       	call   800fee <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
  801576:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801579:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80157d:	75 07                	jne    801586 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80157f:	b8 01 00 00 00       	mov    $0x1,%eax
  801584:	eb 05                	jmp    80158b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801586:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 2c                	push   $0x2c
  80159f:	e8 4a fa ff ff       	call   800fee <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
  8015a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8015aa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8015ae:	75 07                	jne    8015b7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8015b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8015b5:	eb 05                	jmp    8015bc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 2c                	push   $0x2c
  8015d0:	e8 19 fa ff ff       	call   800fee <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
  8015d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8015db:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015df:	75 07                	jne    8015e8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e6:	eb 05                	jmp    8015ed <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	ff 75 08             	pushl  0x8(%ebp)
  8015fd:	6a 2d                	push   $0x2d
  8015ff:	e8 ea f9 ff ff       	call   800fee <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
	return ;
  801607:	90                   	nop
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80160e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801611:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801614:	8b 55 0c             	mov    0xc(%ebp),%edx
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	6a 00                	push   $0x0
  80161c:	53                   	push   %ebx
  80161d:	51                   	push   %ecx
  80161e:	52                   	push   %edx
  80161f:	50                   	push   %eax
  801620:	6a 2e                	push   $0x2e
  801622:	e8 c7 f9 ff ff       	call   800fee <syscall>
  801627:	83 c4 18             	add    $0x18,%esp
}
  80162a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801632:	8b 55 0c             	mov    0xc(%ebp),%edx
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	52                   	push   %edx
  80163f:	50                   	push   %eax
  801640:	6a 2f                	push   $0x2f
  801642:	e8 a7 f9 ff ff       	call   800fee <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

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
