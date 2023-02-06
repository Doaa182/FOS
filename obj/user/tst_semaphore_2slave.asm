
obj/user/tst_semaphore_2slave:     file format elf32-i386


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
  800031:	e8 8a 00 00 00       	call   8000c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int id = sys_getenvindex();
  80003e:	e8 e3 13 00 00       	call   801426 <sys_getenvindex>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int32 parentenvID = sys_getparentenvid();
  800046:	e8 f4 13 00 00       	call   80143f <sys_getparentenvid>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//cprintf("Cust %d: outside the shop\n", id);

	sys_waitSemaphore(parentenvID, "shopCapacity") ;
  80004e:	83 ec 08             	sub    $0x8,%esp
  800051:	68 e0 19 80 00       	push   $0x8019e0
  800056:	ff 75 f0             	pushl  -0x10(%ebp)
  800059:	e8 82 12 00 00       	call   8012e0 <sys_waitSemaphore>
  80005e:	83 c4 10             	add    $0x10,%esp
		cprintf("Cust %d: inside the shop\n", id) ;
  800061:	83 ec 08             	sub    $0x8,%esp
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	68 ed 19 80 00       	push   $0x8019ed
  80006c:	e8 5f 02 00 00       	call   8002d0 <cprintf>
  800071:	83 c4 10             	add    $0x10,%esp
		env_sleep(1000) ;
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	68 e8 03 00 00       	push   $0x3e8
  80007c:	e8 37 16 00 00       	call   8016b8 <env_sleep>
  800081:	83 c4 10             	add    $0x10,%esp
	sys_signalSemaphore(parentenvID, "shopCapacity") ;
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	68 e0 19 80 00       	push   $0x8019e0
  80008c:	ff 75 f0             	pushl  -0x10(%ebp)
  80008f:	e8 6a 12 00 00       	call   8012fe <sys_signalSemaphore>
  800094:	83 c4 10             	add    $0x10,%esp

	cprintf("Cust %d: exit the shop\n", id);
  800097:	83 ec 08             	sub    $0x8,%esp
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	68 07 1a 80 00       	push   $0x801a07
  8000a2:	e8 29 02 00 00       	call   8002d0 <cprintf>
  8000a7:	83 c4 10             	add    $0x10,%esp
	sys_signalSemaphore(parentenvID, "depend") ;
  8000aa:	83 ec 08             	sub    $0x8,%esp
  8000ad:	68 1f 1a 80 00       	push   $0x801a1f
  8000b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b5:	e8 44 12 00 00       	call   8012fe <sys_signalSemaphore>
  8000ba:	83 c4 10             	add    $0x10,%esp
	return;
  8000bd:	90                   	nop
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8000c6:	e8 5b 13 00 00       	call   801426 <sys_getenvindex>
  8000cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8000ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d1:	89 d0                	mov    %edx,%eax
  8000d3:	c1 e0 03             	shl    $0x3,%eax
  8000d6:	01 d0                	add    %edx,%eax
  8000d8:	01 c0                	add    %eax,%eax
  8000da:	01 d0                	add    %edx,%eax
  8000dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000e3:	01 d0                	add    %edx,%eax
  8000e5:	c1 e0 04             	shl    $0x4,%eax
  8000e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000ed:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f2:	a1 20 20 80 00       	mov    0x802020,%eax
  8000f7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8000fd:	84 c0                	test   %al,%al
  8000ff:	74 0f                	je     800110 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800101:	a1 20 20 80 00       	mov    0x802020,%eax
  800106:	05 5c 05 00 00       	add    $0x55c,%eax
  80010b:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800110:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800114:	7e 0a                	jle    800120 <libmain+0x60>
		binaryname = argv[0];
  800116:	8b 45 0c             	mov    0xc(%ebp),%eax
  800119:	8b 00                	mov    (%eax),%eax
  80011b:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 0c             	pushl  0xc(%ebp)
  800126:	ff 75 08             	pushl  0x8(%ebp)
  800129:	e8 0a ff ff ff       	call   800038 <_main>
  80012e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800131:	e8 fd 10 00 00       	call   801233 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	68 40 1a 80 00       	push   $0x801a40
  80013e:	e8 8d 01 00 00       	call   8002d0 <cprintf>
  800143:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800146:	a1 20 20 80 00       	mov    0x802020,%eax
  80014b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800151:	a1 20 20 80 00       	mov    0x802020,%eax
  800156:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80015c:	83 ec 04             	sub    $0x4,%esp
  80015f:	52                   	push   %edx
  800160:	50                   	push   %eax
  800161:	68 68 1a 80 00       	push   $0x801a68
  800166:	e8 65 01 00 00       	call   8002d0 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80016e:	a1 20 20 80 00       	mov    0x802020,%eax
  800173:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800179:	a1 20 20 80 00       	mov    0x802020,%eax
  80017e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800184:	a1 20 20 80 00       	mov    0x802020,%eax
  800189:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80018f:	51                   	push   %ecx
  800190:	52                   	push   %edx
  800191:	50                   	push   %eax
  800192:	68 90 1a 80 00       	push   $0x801a90
  800197:	e8 34 01 00 00       	call   8002d0 <cprintf>
  80019c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80019f:	a1 20 20 80 00       	mov    0x802020,%eax
  8001a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	50                   	push   %eax
  8001ae:	68 e8 1a 80 00       	push   $0x801ae8
  8001b3:	e8 18 01 00 00       	call   8002d0 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	68 40 1a 80 00       	push   $0x801a40
  8001c3:	e8 08 01 00 00       	call   8002d0 <cprintf>
  8001c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001cb:	e8 7d 10 00 00       	call   80124d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8001d0:	e8 19 00 00 00       	call   8001ee <exit>
}
  8001d5:	90                   	nop
  8001d6:	c9                   	leave  
  8001d7:	c3                   	ret    

008001d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	6a 00                	push   $0x0
  8001e3:	e8 0a 12 00 00       	call   8013f2 <sys_destroy_env>
  8001e8:	83 c4 10             	add    $0x10,%esp
}
  8001eb:	90                   	nop
  8001ec:	c9                   	leave  
  8001ed:	c3                   	ret    

008001ee <exit>:

void
exit(void)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001f4:	e8 5f 12 00 00       	call   801458 <sys_exit_env>
}
  8001f9:	90                   	nop
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800202:	8b 45 0c             	mov    0xc(%ebp),%eax
  800205:	8b 00                	mov    (%eax),%eax
  800207:	8d 48 01             	lea    0x1(%eax),%ecx
  80020a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020d:	89 0a                	mov    %ecx,(%edx)
  80020f:	8b 55 08             	mov    0x8(%ebp),%edx
  800212:	88 d1                	mov    %dl,%cl
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80021b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021e:	8b 00                	mov    (%eax),%eax
  800220:	3d ff 00 00 00       	cmp    $0xff,%eax
  800225:	75 2c                	jne    800253 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800227:	a0 24 20 80 00       	mov    0x802024,%al
  80022c:	0f b6 c0             	movzbl %al,%eax
  80022f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800232:	8b 12                	mov    (%edx),%edx
  800234:	89 d1                	mov    %edx,%ecx
  800236:	8b 55 0c             	mov    0xc(%ebp),%edx
  800239:	83 c2 08             	add    $0x8,%edx
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	50                   	push   %eax
  800240:	51                   	push   %ecx
  800241:	52                   	push   %edx
  800242:	e8 3e 0e 00 00       	call   801085 <sys_cputs>
  800247:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80024a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800253:	8b 45 0c             	mov    0xc(%ebp),%eax
  800256:	8b 40 04             	mov    0x4(%eax),%eax
  800259:	8d 50 01             	lea    0x1(%eax),%edx
  80025c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800262:	90                   	nop
  800263:	c9                   	leave  
  800264:	c3                   	ret    

00800265 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80026e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800275:	00 00 00 
	b.cnt = 0;
  800278:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80027f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800282:	ff 75 0c             	pushl  0xc(%ebp)
  800285:	ff 75 08             	pushl  0x8(%ebp)
  800288:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	68 fc 01 80 00       	push   $0x8001fc
  800294:	e8 11 02 00 00       	call   8004aa <vprintfmt>
  800299:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80029c:	a0 24 20 80 00       	mov    0x802024,%al
  8002a1:	0f b6 c0             	movzbl %al,%eax
  8002a4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	50                   	push   %eax
  8002ae:	52                   	push   %edx
  8002af:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b5:	83 c0 08             	add    $0x8,%eax
  8002b8:	50                   	push   %eax
  8002b9:	e8 c7 0d 00 00       	call   801085 <sys_cputs>
  8002be:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002c1:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8002c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002d6:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8002dd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	83 ec 08             	sub    $0x8,%esp
  8002e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ec:	50                   	push   %eax
  8002ed:	e8 73 ff ff ff       	call   800265 <vcprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002fb:	c9                   	leave  
  8002fc:	c3                   	ret    

008002fd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8002fd:	55                   	push   %ebp
  8002fe:	89 e5                	mov    %esp,%ebp
  800300:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800303:	e8 2b 0f 00 00       	call   801233 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800308:	8d 45 0c             	lea    0xc(%ebp),%eax
  80030b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	83 ec 08             	sub    $0x8,%esp
  800314:	ff 75 f4             	pushl  -0xc(%ebp)
  800317:	50                   	push   %eax
  800318:	e8 48 ff ff ff       	call   800265 <vcprintf>
  80031d:	83 c4 10             	add    $0x10,%esp
  800320:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800323:	e8 25 0f 00 00       	call   80124d <sys_enable_interrupt>
	return cnt;
  800328:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80032b:	c9                   	leave  
  80032c:	c3                   	ret    

0080032d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80032d:	55                   	push   %ebp
  80032e:	89 e5                	mov    %esp,%ebp
  800330:	53                   	push   %ebx
  800331:	83 ec 14             	sub    $0x14,%esp
  800334:	8b 45 10             	mov    0x10(%ebp),%eax
  800337:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80033a:	8b 45 14             	mov    0x14(%ebp),%eax
  80033d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800340:	8b 45 18             	mov    0x18(%ebp),%eax
  800343:	ba 00 00 00 00       	mov    $0x0,%edx
  800348:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80034b:	77 55                	ja     8003a2 <printnum+0x75>
  80034d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800350:	72 05                	jb     800357 <printnum+0x2a>
  800352:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800355:	77 4b                	ja     8003a2 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800357:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80035a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80035d:	8b 45 18             	mov    0x18(%ebp),%eax
  800360:	ba 00 00 00 00       	mov    $0x0,%edx
  800365:	52                   	push   %edx
  800366:	50                   	push   %eax
  800367:	ff 75 f4             	pushl  -0xc(%ebp)
  80036a:	ff 75 f0             	pushl  -0x10(%ebp)
  80036d:	e8 fa 13 00 00       	call   80176c <__udivdi3>
  800372:	83 c4 10             	add    $0x10,%esp
  800375:	83 ec 04             	sub    $0x4,%esp
  800378:	ff 75 20             	pushl  0x20(%ebp)
  80037b:	53                   	push   %ebx
  80037c:	ff 75 18             	pushl  0x18(%ebp)
  80037f:	52                   	push   %edx
  800380:	50                   	push   %eax
  800381:	ff 75 0c             	pushl  0xc(%ebp)
  800384:	ff 75 08             	pushl  0x8(%ebp)
  800387:	e8 a1 ff ff ff       	call   80032d <printnum>
  80038c:	83 c4 20             	add    $0x20,%esp
  80038f:	eb 1a                	jmp    8003ab <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 0c             	pushl  0xc(%ebp)
  800397:	ff 75 20             	pushl  0x20(%ebp)
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	ff d0                	call   *%eax
  80039f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a2:	ff 4d 1c             	decl   0x1c(%ebp)
  8003a5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003a9:	7f e6                	jg     800391 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ab:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b9:	53                   	push   %ebx
  8003ba:	51                   	push   %ecx
  8003bb:	52                   	push   %edx
  8003bc:	50                   	push   %eax
  8003bd:	e8 ba 14 00 00       	call   80187c <__umoddi3>
  8003c2:	83 c4 10             	add    $0x10,%esp
  8003c5:	05 14 1d 80 00       	add    $0x801d14,%eax
  8003ca:	8a 00                	mov    (%eax),%al
  8003cc:	0f be c0             	movsbl %al,%eax
  8003cf:	83 ec 08             	sub    $0x8,%esp
  8003d2:	ff 75 0c             	pushl  0xc(%ebp)
  8003d5:	50                   	push   %eax
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	ff d0                	call   *%eax
  8003db:	83 c4 10             	add    $0x10,%esp
}
  8003de:	90                   	nop
  8003df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003e2:	c9                   	leave  
  8003e3:	c3                   	ret    

008003e4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003eb:	7e 1c                	jle    800409 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	8d 50 08             	lea    0x8(%eax),%edx
  8003f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f8:	89 10                	mov    %edx,(%eax)
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	83 e8 08             	sub    $0x8,%eax
  800402:	8b 50 04             	mov    0x4(%eax),%edx
  800405:	8b 00                	mov    (%eax),%eax
  800407:	eb 40                	jmp    800449 <getuint+0x65>
	else if (lflag)
  800409:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80040d:	74 1e                	je     80042d <getuint+0x49>
		return va_arg(*ap, unsigned long);
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
  80042b:	eb 1c                	jmp    800449 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	8d 50 04             	lea    0x4(%eax),%edx
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	89 10                	mov    %edx,(%eax)
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	83 e8 04             	sub    $0x4,%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800449:	5d                   	pop    %ebp
  80044a:	c3                   	ret    

0080044b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80044e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800452:	7e 1c                	jle    800470 <getint+0x25>
		return va_arg(*ap, long long);
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	8d 50 08             	lea    0x8(%eax),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	89 10                	mov    %edx,(%eax)
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	8b 00                	mov    (%eax),%eax
  800466:	83 e8 08             	sub    $0x8,%eax
  800469:	8b 50 04             	mov    0x4(%eax),%edx
  80046c:	8b 00                	mov    (%eax),%eax
  80046e:	eb 38                	jmp    8004a8 <getint+0x5d>
	else if (lflag)
  800470:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800474:	74 1a                	je     800490 <getint+0x45>
		return va_arg(*ap, long);
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 50 04             	lea    0x4(%eax),%edx
  80047e:	8b 45 08             	mov    0x8(%ebp),%eax
  800481:	89 10                	mov    %edx,(%eax)
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	8b 00                	mov    (%eax),%eax
  800488:	83 e8 04             	sub    $0x4,%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	99                   	cltd   
  80048e:	eb 18                	jmp    8004a8 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	8d 50 04             	lea    0x4(%eax),%edx
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	89 10                	mov    %edx,(%eax)
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	8b 00                	mov    (%eax),%eax
  8004a2:	83 e8 04             	sub    $0x4,%eax
  8004a5:	8b 00                	mov    (%eax),%eax
  8004a7:	99                   	cltd   
}
  8004a8:	5d                   	pop    %ebp
  8004a9:	c3                   	ret    

008004aa <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
  8004ad:	56                   	push   %esi
  8004ae:	53                   	push   %ebx
  8004af:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b2:	eb 17                	jmp    8004cb <vprintfmt+0x21>
			if (ch == '\0')
  8004b4:	85 db                	test   %ebx,%ebx
  8004b6:	0f 84 af 03 00 00    	je     80086b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	ff 75 0c             	pushl  0xc(%ebp)
  8004c2:	53                   	push   %ebx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	ff d0                	call   *%eax
  8004c8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ce:	8d 50 01             	lea    0x1(%eax),%edx
  8004d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8004d4:	8a 00                	mov    (%eax),%al
  8004d6:	0f b6 d8             	movzbl %al,%ebx
  8004d9:	83 fb 25             	cmp    $0x25,%ebx
  8004dc:	75 d6                	jne    8004b4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004de:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004e2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004e9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004f7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800501:	8d 50 01             	lea    0x1(%eax),%edx
  800504:	89 55 10             	mov    %edx,0x10(%ebp)
  800507:	8a 00                	mov    (%eax),%al
  800509:	0f b6 d8             	movzbl %al,%ebx
  80050c:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80050f:	83 f8 55             	cmp    $0x55,%eax
  800512:	0f 87 2b 03 00 00    	ja     800843 <vprintfmt+0x399>
  800518:	8b 04 85 38 1d 80 00 	mov    0x801d38(,%eax,4),%eax
  80051f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800521:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800525:	eb d7                	jmp    8004fe <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800527:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80052b:	eb d1                	jmp    8004fe <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80052d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	c1 e0 02             	shl    $0x2,%eax
  80053c:	01 d0                	add    %edx,%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	01 d8                	add    %ebx,%eax
  800542:	83 e8 30             	sub    $0x30,%eax
  800545:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800548:	8b 45 10             	mov    0x10(%ebp),%eax
  80054b:	8a 00                	mov    (%eax),%al
  80054d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800550:	83 fb 2f             	cmp    $0x2f,%ebx
  800553:	7e 3e                	jle    800593 <vprintfmt+0xe9>
  800555:	83 fb 39             	cmp    $0x39,%ebx
  800558:	7f 39                	jg     800593 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80055a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80055d:	eb d5                	jmp    800534 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	83 c0 04             	add    $0x4,%eax
  800565:	89 45 14             	mov    %eax,0x14(%ebp)
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	83 e8 04             	sub    $0x4,%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800573:	eb 1f                	jmp    800594 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800575:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800579:	79 83                	jns    8004fe <vprintfmt+0x54>
				width = 0;
  80057b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800582:	e9 77 ff ff ff       	jmp    8004fe <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800587:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80058e:	e9 6b ff ff ff       	jmp    8004fe <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800593:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800594:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800598:	0f 89 60 ff ff ff    	jns    8004fe <vprintfmt+0x54>
				width = precision, precision = -1;
  80059e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005a4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005ab:	e9 4e ff ff ff       	jmp    8004fe <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005b0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005b3:	e9 46 ff ff ff       	jmp    8004fe <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	83 c0 04             	add    $0x4,%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	83 e8 04             	sub    $0x4,%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	ff 75 0c             	pushl  0xc(%ebp)
  8005cf:	50                   	push   %eax
  8005d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d3:	ff d0                	call   *%eax
  8005d5:	83 c4 10             	add    $0x10,%esp
			break;
  8005d8:	e9 89 02 00 00       	jmp    800866 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	83 c0 04             	add    $0x4,%eax
  8005e3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	83 e8 04             	sub    $0x4,%eax
  8005ec:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005ee:	85 db                	test   %ebx,%ebx
  8005f0:	79 02                	jns    8005f4 <vprintfmt+0x14a>
				err = -err;
  8005f2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005f4:	83 fb 64             	cmp    $0x64,%ebx
  8005f7:	7f 0b                	jg     800604 <vprintfmt+0x15a>
  8005f9:	8b 34 9d 80 1b 80 00 	mov    0x801b80(,%ebx,4),%esi
  800600:	85 f6                	test   %esi,%esi
  800602:	75 19                	jne    80061d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800604:	53                   	push   %ebx
  800605:	68 25 1d 80 00       	push   $0x801d25
  80060a:	ff 75 0c             	pushl  0xc(%ebp)
  80060d:	ff 75 08             	pushl  0x8(%ebp)
  800610:	e8 5e 02 00 00       	call   800873 <printfmt>
  800615:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800618:	e9 49 02 00 00       	jmp    800866 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80061d:	56                   	push   %esi
  80061e:	68 2e 1d 80 00       	push   $0x801d2e
  800623:	ff 75 0c             	pushl  0xc(%ebp)
  800626:	ff 75 08             	pushl  0x8(%ebp)
  800629:	e8 45 02 00 00       	call   800873 <printfmt>
  80062e:	83 c4 10             	add    $0x10,%esp
			break;
  800631:	e9 30 02 00 00       	jmp    800866 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800636:	8b 45 14             	mov    0x14(%ebp),%eax
  800639:	83 c0 04             	add    $0x4,%eax
  80063c:	89 45 14             	mov    %eax,0x14(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	83 e8 04             	sub    $0x4,%eax
  800645:	8b 30                	mov    (%eax),%esi
  800647:	85 f6                	test   %esi,%esi
  800649:	75 05                	jne    800650 <vprintfmt+0x1a6>
				p = "(null)";
  80064b:	be 31 1d 80 00       	mov    $0x801d31,%esi
			if (width > 0 && padc != '-')
  800650:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800654:	7e 6d                	jle    8006c3 <vprintfmt+0x219>
  800656:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80065a:	74 67                	je     8006c3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80065c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	50                   	push   %eax
  800663:	56                   	push   %esi
  800664:	e8 0c 03 00 00       	call   800975 <strnlen>
  800669:	83 c4 10             	add    $0x10,%esp
  80066c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80066f:	eb 16                	jmp    800687 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800671:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	50                   	push   %eax
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800684:	ff 4d e4             	decl   -0x1c(%ebp)
  800687:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068b:	7f e4                	jg     800671 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068d:	eb 34                	jmp    8006c3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80068f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800693:	74 1c                	je     8006b1 <vprintfmt+0x207>
  800695:	83 fb 1f             	cmp    $0x1f,%ebx
  800698:	7e 05                	jle    80069f <vprintfmt+0x1f5>
  80069a:	83 fb 7e             	cmp    $0x7e,%ebx
  80069d:	7e 12                	jle    8006b1 <vprintfmt+0x207>
					putch('?', putdat);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	ff 75 0c             	pushl  0xc(%ebp)
  8006a5:	6a 3f                	push   $0x3f
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	ff d0                	call   *%eax
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	eb 0f                	jmp    8006c0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	ff 75 0c             	pushl  0xc(%ebp)
  8006b7:	53                   	push   %ebx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	ff d0                	call   *%eax
  8006bd:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c0:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c3:	89 f0                	mov    %esi,%eax
  8006c5:	8d 70 01             	lea    0x1(%eax),%esi
  8006c8:	8a 00                	mov    (%eax),%al
  8006ca:	0f be d8             	movsbl %al,%ebx
  8006cd:	85 db                	test   %ebx,%ebx
  8006cf:	74 24                	je     8006f5 <vprintfmt+0x24b>
  8006d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d5:	78 b8                	js     80068f <vprintfmt+0x1e5>
  8006d7:	ff 4d e0             	decl   -0x20(%ebp)
  8006da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006de:	79 af                	jns    80068f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e0:	eb 13                	jmp    8006f5 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006e2:	83 ec 08             	sub    $0x8,%esp
  8006e5:	ff 75 0c             	pushl  0xc(%ebp)
  8006e8:	6a 20                	push   $0x20
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	ff d0                	call   *%eax
  8006ef:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f9:	7f e7                	jg     8006e2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006fb:	e9 66 01 00 00       	jmp    800866 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	ff 75 e8             	pushl  -0x18(%ebp)
  800706:	8d 45 14             	lea    0x14(%ebp),%eax
  800709:	50                   	push   %eax
  80070a:	e8 3c fd ff ff       	call   80044b <getint>
  80070f:	83 c4 10             	add    $0x10,%esp
  800712:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800715:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80071b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071e:	85 d2                	test   %edx,%edx
  800720:	79 23                	jns    800745 <vprintfmt+0x29b>
				putch('-', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	6a 2d                	push   $0x2d
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	ff d0                	call   *%eax
  80072f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800735:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800738:	f7 d8                	neg    %eax
  80073a:	83 d2 00             	adc    $0x0,%edx
  80073d:	f7 da                	neg    %edx
  80073f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800742:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800745:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80074c:	e9 bc 00 00 00       	jmp    80080d <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	ff 75 e8             	pushl  -0x18(%ebp)
  800757:	8d 45 14             	lea    0x14(%ebp),%eax
  80075a:	50                   	push   %eax
  80075b:	e8 84 fc ff ff       	call   8003e4 <getuint>
  800760:	83 c4 10             	add    $0x10,%esp
  800763:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800766:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800769:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800770:	e9 98 00 00 00       	jmp    80080d <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 0c             	pushl  0xc(%ebp)
  80077b:	6a 58                	push   $0x58
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	ff d0                	call   *%eax
  800782:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 0c             	pushl  0xc(%ebp)
  80078b:	6a 58                	push   $0x58
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	ff d0                	call   *%eax
  800792:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800795:	83 ec 08             	sub    $0x8,%esp
  800798:	ff 75 0c             	pushl  0xc(%ebp)
  80079b:	6a 58                	push   $0x58
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	ff d0                	call   *%eax
  8007a2:	83 c4 10             	add    $0x10,%esp
			break;
  8007a5:	e9 bc 00 00 00       	jmp    800866 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	6a 30                	push   $0x30
  8007b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b5:	ff d0                	call   *%eax
  8007b7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	ff 75 0c             	pushl  0xc(%ebp)
  8007c0:	6a 78                	push   $0x78
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	ff d0                	call   *%eax
  8007c7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	83 c0 04             	add    $0x4,%eax
  8007d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007e5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007ec:	eb 1f                	jmp    80080d <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8007f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f7:	50                   	push   %eax
  8007f8:	e8 e7 fb ff ff       	call   8003e4 <getuint>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800803:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800806:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80080d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800811:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	52                   	push   %edx
  800818:	ff 75 e4             	pushl  -0x1c(%ebp)
  80081b:	50                   	push   %eax
  80081c:	ff 75 f4             	pushl  -0xc(%ebp)
  80081f:	ff 75 f0             	pushl  -0x10(%ebp)
  800822:	ff 75 0c             	pushl  0xc(%ebp)
  800825:	ff 75 08             	pushl  0x8(%ebp)
  800828:	e8 00 fb ff ff       	call   80032d <printnum>
  80082d:	83 c4 20             	add    $0x20,%esp
			break;
  800830:	eb 34                	jmp    800866 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	53                   	push   %ebx
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			break;
  800841:	eb 23                	jmp    800866 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	6a 25                	push   $0x25
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	ff d0                	call   *%eax
  800850:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800853:	ff 4d 10             	decl   0x10(%ebp)
  800856:	eb 03                	jmp    80085b <vprintfmt+0x3b1>
  800858:	ff 4d 10             	decl   0x10(%ebp)
  80085b:	8b 45 10             	mov    0x10(%ebp),%eax
  80085e:	48                   	dec    %eax
  80085f:	8a 00                	mov    (%eax),%al
  800861:	3c 25                	cmp    $0x25,%al
  800863:	75 f3                	jne    800858 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800865:	90                   	nop
		}
	}
  800866:	e9 47 fc ff ff       	jmp    8004b2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80086b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80086c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80086f:	5b                   	pop    %ebx
  800870:	5e                   	pop    %esi
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800879:	8d 45 10             	lea    0x10(%ebp),%eax
  80087c:	83 c0 04             	add    $0x4,%eax
  80087f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800882:	8b 45 10             	mov    0x10(%ebp),%eax
  800885:	ff 75 f4             	pushl  -0xc(%ebp)
  800888:	50                   	push   %eax
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 16 fc ff ff       	call   8004aa <vprintfmt>
  800894:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800897:	90                   	nop
  800898:	c9                   	leave  
  800899:	c3                   	ret    

0080089a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80089d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a0:	8b 40 08             	mov    0x8(%eax),%eax
  8008a3:	8d 50 01             	lea    0x1(%eax),%edx
  8008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a9:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008af:	8b 10                	mov    (%eax),%edx
  8008b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b4:	8b 40 04             	mov    0x4(%eax),%eax
  8008b7:	39 c2                	cmp    %eax,%edx
  8008b9:	73 12                	jae    8008cd <sprintputch+0x33>
		*b->buf++ = ch;
  8008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	8d 48 01             	lea    0x1(%eax),%ecx
  8008c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c6:	89 0a                	mov    %ecx,(%edx)
  8008c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8008cb:	88 10                	mov    %dl,(%eax)
}
  8008cd:	90                   	nop
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	01 d0                	add    %edx,%eax
  8008e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008f5:	74 06                	je     8008fd <vsnprintf+0x2d>
  8008f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008fb:	7f 07                	jg     800904 <vsnprintf+0x34>
		return -E_INVAL;
  8008fd:	b8 03 00 00 00       	mov    $0x3,%eax
  800902:	eb 20                	jmp    800924 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800904:	ff 75 14             	pushl  0x14(%ebp)
  800907:	ff 75 10             	pushl  0x10(%ebp)
  80090a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80090d:	50                   	push   %eax
  80090e:	68 9a 08 80 00       	push   $0x80089a
  800913:	e8 92 fb ff ff       	call   8004aa <vprintfmt>
  800918:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80091b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800921:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800924:	c9                   	leave  
  800925:	c3                   	ret    

00800926 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80092c:	8d 45 10             	lea    0x10(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800935:	8b 45 10             	mov    0x10(%ebp),%eax
  800938:	ff 75 f4             	pushl  -0xc(%ebp)
  80093b:	50                   	push   %eax
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 89 ff ff ff       	call   8008d0 <vsnprintf>
  800947:	83 c4 10             	add    $0x10,%esp
  80094a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80094d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800950:	c9                   	leave  
  800951:	c3                   	ret    

00800952 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800958:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80095f:	eb 06                	jmp    800967 <strlen+0x15>
		n++;
  800961:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800964:	ff 45 08             	incl   0x8(%ebp)
  800967:	8b 45 08             	mov    0x8(%ebp),%eax
  80096a:	8a 00                	mov    (%eax),%al
  80096c:	84 c0                	test   %al,%al
  80096e:	75 f1                	jne    800961 <strlen+0xf>
		n++;
	return n;
  800970:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800973:	c9                   	leave  
  800974:	c3                   	ret    

00800975 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800982:	eb 09                	jmp    80098d <strnlen+0x18>
		n++;
  800984:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800987:	ff 45 08             	incl   0x8(%ebp)
  80098a:	ff 4d 0c             	decl   0xc(%ebp)
  80098d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800991:	74 09                	je     80099c <strnlen+0x27>
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8a 00                	mov    (%eax),%al
  800998:	84 c0                	test   %al,%al
  80099a:	75 e8                	jne    800984 <strnlen+0xf>
		n++;
	return n;
  80099c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009ad:	90                   	nop
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8d 50 01             	lea    0x1(%eax),%edx
  8009b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009c0:	8a 12                	mov    (%edx),%dl
  8009c2:	88 10                	mov    %dl,(%eax)
  8009c4:	8a 00                	mov    (%eax),%al
  8009c6:	84 c0                	test   %al,%al
  8009c8:	75 e4                	jne    8009ae <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009cd:	c9                   	leave  
  8009ce:	c3                   	ret    

008009cf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e2:	eb 1f                	jmp    800a03 <strncpy+0x34>
		*dst++ = *src;
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	8d 50 01             	lea    0x1(%eax),%edx
  8009ea:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f0:	8a 12                	mov    (%edx),%dl
  8009f2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f7:	8a 00                	mov    (%eax),%al
  8009f9:	84 c0                	test   %al,%al
  8009fb:	74 03                	je     800a00 <strncpy+0x31>
			src++;
  8009fd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a00:	ff 45 fc             	incl   -0x4(%ebp)
  800a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a06:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a09:	72 d9                	jb     8009e4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a0e:	c9                   	leave  
  800a0f:	c3                   	ret    

00800a10 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a20:	74 30                	je     800a52 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a22:	eb 16                	jmp    800a3a <strlcpy+0x2a>
			*dst++ = *src++;
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	8d 50 01             	lea    0x1(%eax),%edx
  800a2a:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a30:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a33:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a36:	8a 12                	mov    (%edx),%dl
  800a38:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a3a:	ff 4d 10             	decl   0x10(%ebp)
  800a3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a41:	74 09                	je     800a4c <strlcpy+0x3c>
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	8a 00                	mov    (%eax),%al
  800a48:	84 c0                	test   %al,%al
  800a4a:	75 d8                	jne    800a24 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a58:	29 c2                	sub    %eax,%edx
  800a5a:	89 d0                	mov    %edx,%eax
}
  800a5c:	c9                   	leave  
  800a5d:	c3                   	ret    

00800a5e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a61:	eb 06                	jmp    800a69 <strcmp+0xb>
		p++, q++;
  800a63:	ff 45 08             	incl   0x8(%ebp)
  800a66:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8a 00                	mov    (%eax),%al
  800a6e:	84 c0                	test   %al,%al
  800a70:	74 0e                	je     800a80 <strcmp+0x22>
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8a 10                	mov    (%eax),%dl
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	8a 00                	mov    (%eax),%al
  800a7c:	38 c2                	cmp    %al,%dl
  800a7e:	74 e3                	je     800a63 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	8a 00                	mov    (%eax),%al
  800a85:	0f b6 d0             	movzbl %al,%edx
  800a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8b:	8a 00                	mov    (%eax),%al
  800a8d:	0f b6 c0             	movzbl %al,%eax
  800a90:	29 c2                	sub    %eax,%edx
  800a92:	89 d0                	mov    %edx,%eax
}
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a99:	eb 09                	jmp    800aa4 <strncmp+0xe>
		n--, p++, q++;
  800a9b:	ff 4d 10             	decl   0x10(%ebp)
  800a9e:	ff 45 08             	incl   0x8(%ebp)
  800aa1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800aa4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa8:	74 17                	je     800ac1 <strncmp+0x2b>
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	8a 00                	mov    (%eax),%al
  800aaf:	84 c0                	test   %al,%al
  800ab1:	74 0e                	je     800ac1 <strncmp+0x2b>
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8a 10                	mov    (%eax),%dl
  800ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abb:	8a 00                	mov    (%eax),%al
  800abd:	38 c2                	cmp    %al,%dl
  800abf:	74 da                	je     800a9b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ac1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac5:	75 07                	jne    800ace <strncmp+0x38>
		return 0;
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  800acc:	eb 14                	jmp    800ae2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8a 00                	mov    (%eax),%al
  800ad3:	0f b6 d0             	movzbl %al,%edx
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	0f b6 c0             	movzbl %al,%eax
  800ade:	29 c2                	sub    %eax,%edx
  800ae0:	89 d0                	mov    %edx,%eax
}
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	83 ec 04             	sub    $0x4,%esp
  800aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aed:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800af0:	eb 12                	jmp    800b04 <strchr+0x20>
		if (*s == c)
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800afa:	75 05                	jne    800b01 <strchr+0x1d>
			return (char *) s;
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	eb 11                	jmp    800b12 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b01:	ff 45 08             	incl   0x8(%ebp)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	84 c0                	test   %al,%al
  800b0b:	75 e5                	jne    800af2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 04             	sub    $0x4,%esp
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b20:	eb 0d                	jmp    800b2f <strfind+0x1b>
		if (*s == c)
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b2a:	74 0e                	je     800b3a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b2c:	ff 45 08             	incl   0x8(%ebp)
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8a 00                	mov    (%eax),%al
  800b34:	84 c0                	test   %al,%al
  800b36:	75 ea                	jne    800b22 <strfind+0xe>
  800b38:	eb 01                	jmp    800b3b <strfind+0x27>
		if (*s == c)
			break;
  800b3a:	90                   	nop
	return (char *) s;
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b3e:	c9                   	leave  
  800b3f:	c3                   	ret    

00800b40 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b52:	eb 0e                	jmp    800b62 <memset+0x22>
		*p++ = c;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b57:	8d 50 01             	lea    0x1(%eax),%edx
  800b5a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b62:	ff 4d f8             	decl   -0x8(%ebp)
  800b65:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b69:	79 e9                	jns    800b54 <memset+0x14>
		*p++ = c;

	return v;
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b6e:	c9                   	leave  
  800b6f:	c3                   	ret    

00800b70 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b82:	eb 16                	jmp    800b9a <memcpy+0x2a>
		*d++ = *s++;
  800b84:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b87:	8d 50 01             	lea    0x1(%eax),%edx
  800b8a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b93:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b96:	8a 12                	mov    (%edx),%dl
  800b98:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba3:	85 c0                	test   %eax,%eax
  800ba5:	75 dd                	jne    800b84 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bc1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc4:	73 50                	jae    800c16 <memmove+0x6a>
  800bc6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcc:	01 d0                	add    %edx,%eax
  800bce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bd1:	76 43                	jbe    800c16 <memmove+0x6a>
		s += n;
  800bd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bdf:	eb 10                	jmp    800bf1 <memmove+0x45>
			*--d = *--s;
  800be1:	ff 4d f8             	decl   -0x8(%ebp)
  800be4:	ff 4d fc             	decl   -0x4(%ebp)
  800be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bea:	8a 10                	mov    (%eax),%dl
  800bec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bef:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bfa:	85 c0                	test   %eax,%eax
  800bfc:	75 e3                	jne    800be1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bfe:	eb 23                	jmp    800c23 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c09:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c12:	8a 12                	mov    (%edx),%dl
  800c14:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c16:	8b 45 10             	mov    0x10(%ebp),%eax
  800c19:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	75 dd                	jne    800c00 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c26:	c9                   	leave  
  800c27:	c3                   	ret    

00800c28 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c37:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c3a:	eb 2a                	jmp    800c66 <memcmp+0x3e>
		if (*s1 != *s2)
  800c3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3f:	8a 10                	mov    (%eax),%dl
  800c41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	38 c2                	cmp    %al,%dl
  800c48:	74 16                	je     800c60 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f b6 d0             	movzbl %al,%edx
  800c52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	0f b6 c0             	movzbl %al,%eax
  800c5a:	29 c2                	sub    %eax,%edx
  800c5c:	89 d0                	mov    %edx,%eax
  800c5e:	eb 18                	jmp    800c78 <memcmp+0x50>
		s1++, s2++;
  800c60:	ff 45 fc             	incl   -0x4(%ebp)
  800c63:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c66:	8b 45 10             	mov    0x10(%ebp),%eax
  800c69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6f:	85 c0                	test   %eax,%eax
  800c71:	75 c9                	jne    800c3c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c80:	8b 55 08             	mov    0x8(%ebp),%edx
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	01 d0                	add    %edx,%eax
  800c88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c8b:	eb 15                	jmp    800ca2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	0f b6 d0             	movzbl %al,%edx
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	0f b6 c0             	movzbl %al,%eax
  800c9b:	39 c2                	cmp    %eax,%edx
  800c9d:	74 0d                	je     800cac <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c9f:	ff 45 08             	incl   0x8(%ebp)
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ca8:	72 e3                	jb     800c8d <memfind+0x13>
  800caa:	eb 01                	jmp    800cad <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cac:	90                   	nop
	return (void *) s;
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cb0:	c9                   	leave  
  800cb1:	c3                   	ret    

00800cb2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cb8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cbf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc6:	eb 03                	jmp    800ccb <strtol+0x19>
		s++;
  800cc8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	3c 20                	cmp    $0x20,%al
  800cd2:	74 f4                	je     800cc8 <strtol+0x16>
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	8a 00                	mov    (%eax),%al
  800cd9:	3c 09                	cmp    $0x9,%al
  800cdb:	74 eb                	je     800cc8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	3c 2b                	cmp    $0x2b,%al
  800ce4:	75 05                	jne    800ceb <strtol+0x39>
		s++;
  800ce6:	ff 45 08             	incl   0x8(%ebp)
  800ce9:	eb 13                	jmp    800cfe <strtol+0x4c>
	else if (*s == '-')
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	3c 2d                	cmp    $0x2d,%al
  800cf2:	75 0a                	jne    800cfe <strtol+0x4c>
		s++, neg = 1;
  800cf4:	ff 45 08             	incl   0x8(%ebp)
  800cf7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d02:	74 06                	je     800d0a <strtol+0x58>
  800d04:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d08:	75 20                	jne    800d2a <strtol+0x78>
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	3c 30                	cmp    $0x30,%al
  800d11:	75 17                	jne    800d2a <strtol+0x78>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	40                   	inc    %eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	3c 78                	cmp    $0x78,%al
  800d1b:	75 0d                	jne    800d2a <strtol+0x78>
		s += 2, base = 16;
  800d1d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d21:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d28:	eb 28                	jmp    800d52 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2e:	75 15                	jne    800d45 <strtol+0x93>
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	3c 30                	cmp    $0x30,%al
  800d37:	75 0c                	jne    800d45 <strtol+0x93>
		s++, base = 8;
  800d39:	ff 45 08             	incl   0x8(%ebp)
  800d3c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d43:	eb 0d                	jmp    800d52 <strtol+0xa0>
	else if (base == 0)
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	75 07                	jne    800d52 <strtol+0xa0>
		base = 10;
  800d4b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	3c 2f                	cmp    $0x2f,%al
  800d59:	7e 19                	jle    800d74 <strtol+0xc2>
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	3c 39                	cmp    $0x39,%al
  800d62:	7f 10                	jg     800d74 <strtol+0xc2>
			dig = *s - '0';
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f be c0             	movsbl %al,%eax
  800d6c:	83 e8 30             	sub    $0x30,%eax
  800d6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d72:	eb 42                	jmp    800db6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	3c 60                	cmp    $0x60,%al
  800d7b:	7e 19                	jle    800d96 <strtol+0xe4>
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3c 7a                	cmp    $0x7a,%al
  800d84:	7f 10                	jg     800d96 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	0f be c0             	movsbl %al,%eax
  800d8e:	83 e8 57             	sub    $0x57,%eax
  800d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d94:	eb 20                	jmp    800db6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 40                	cmp    $0x40,%al
  800d9d:	7e 39                	jle    800dd8 <strtol+0x126>
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	8a 00                	mov    (%eax),%al
  800da4:	3c 5a                	cmp    $0x5a,%al
  800da6:	7f 30                	jg     800dd8 <strtol+0x126>
			dig = *s - 'A' + 10;
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f be c0             	movsbl %al,%eax
  800db0:	83 e8 37             	sub    $0x37,%eax
  800db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbc:	7d 19                	jge    800dd7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dbe:	ff 45 08             	incl   0x8(%ebp)
  800dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc4:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dc8:	89 c2                	mov    %eax,%edx
  800dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dcd:	01 d0                	add    %edx,%eax
  800dcf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dd2:	e9 7b ff ff ff       	jmp    800d52 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dd7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ddc:	74 08                	je     800de6 <strtol+0x134>
		*endptr = (char *) s;
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	8b 55 08             	mov    0x8(%ebp),%edx
  800de4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800de6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dea:	74 07                	je     800df3 <strtol+0x141>
  800dec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800def:	f7 d8                	neg    %eax
  800df1:	eb 03                	jmp    800df6 <strtol+0x144>
  800df3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df6:	c9                   	leave  
  800df7:	c3                   	ret    

00800df8 <ltostr>:

void
ltostr(long value, char *str)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dfe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e05:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e10:	79 13                	jns    800e25 <ltostr+0x2d>
	{
		neg = 1;
  800e12:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e1f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e22:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e2d:	99                   	cltd   
  800e2e:	f7 f9                	idiv   %ecx
  800e30:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3c:	89 c2                	mov    %eax,%edx
  800e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e41:	01 d0                	add    %edx,%eax
  800e43:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e46:	83 c2 30             	add    $0x30,%edx
  800e49:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e53:	f7 e9                	imul   %ecx
  800e55:	c1 fa 02             	sar    $0x2,%edx
  800e58:	89 c8                	mov    %ecx,%eax
  800e5a:	c1 f8 1f             	sar    $0x1f,%eax
  800e5d:	29 c2                	sub    %eax,%edx
  800e5f:	89 d0                	mov    %edx,%eax
  800e61:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800e64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e67:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e6c:	f7 e9                	imul   %ecx
  800e6e:	c1 fa 02             	sar    $0x2,%edx
  800e71:	89 c8                	mov    %ecx,%eax
  800e73:	c1 f8 1f             	sar    $0x1f,%eax
  800e76:	29 c2                	sub    %eax,%edx
  800e78:	89 d0                	mov    %edx,%eax
  800e7a:	c1 e0 02             	shl    $0x2,%eax
  800e7d:	01 d0                	add    %edx,%eax
  800e7f:	01 c0                	add    %eax,%eax
  800e81:	29 c1                	sub    %eax,%ecx
  800e83:	89 ca                	mov    %ecx,%edx
  800e85:	85 d2                	test   %edx,%edx
  800e87:	75 9c                	jne    800e25 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e93:	48                   	dec    %eax
  800e94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e97:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e9b:	74 3d                	je     800eda <ltostr+0xe2>
		start = 1 ;
  800e9d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ea4:	eb 34                	jmp    800eda <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	01 d0                	add    %edx,%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 c2                	add    %eax,%edx
  800ebb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	01 c8                	add    %ecx,%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ec7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	01 c2                	add    %eax,%edx
  800ecf:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ed2:	88 02                	mov    %al,(%edx)
		start++ ;
  800ed4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ed7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800edd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ee0:	7c c4                	jl     800ea6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ee2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	01 d0                	add    %edx,%eax
  800eea:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800eed:	90                   	nop
  800eee:	c9                   	leave  
  800eef:	c3                   	ret    

00800ef0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ef6:	ff 75 08             	pushl  0x8(%ebp)
  800ef9:	e8 54 fa ff ff       	call   800952 <strlen>
  800efe:	83 c4 04             	add    $0x4,%esp
  800f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f04:	ff 75 0c             	pushl  0xc(%ebp)
  800f07:	e8 46 fa ff ff       	call   800952 <strlen>
  800f0c:	83 c4 04             	add    $0x4,%esp
  800f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f20:	eb 17                	jmp    800f39 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 c2                	add    %eax,%edx
  800f2a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	01 c8                	add    %ecx,%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f36:	ff 45 fc             	incl   -0x4(%ebp)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f3f:	7c e1                	jl     800f22 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f41:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f48:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f4f:	eb 1f                	jmp    800f70 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f54:	8d 50 01             	lea    0x1(%eax),%edx
  800f57:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f5a:	89 c2                	mov    %eax,%edx
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	01 c2                	add    %eax,%edx
  800f61:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	01 c8                	add    %ecx,%eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
  800f70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f73:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f76:	7c d9                	jl     800f51 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7e:	01 d0                	add    %edx,%eax
  800f80:	c6 00 00             	movb   $0x0,(%eax)
}
  800f83:	90                   	nop
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f89:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f92:	8b 45 14             	mov    0x14(%ebp),%eax
  800f95:	8b 00                	mov    (%eax),%eax
  800f97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa1:	01 d0                	add    %edx,%eax
  800fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa9:	eb 0c                	jmp    800fb7 <strsplit+0x31>
			*string++ = 0;
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8d 50 01             	lea    0x1(%eax),%edx
  800fb1:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	84 c0                	test   %al,%al
  800fbe:	74 18                	je     800fd8 <strsplit+0x52>
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	0f be c0             	movsbl %al,%eax
  800fc8:	50                   	push   %eax
  800fc9:	ff 75 0c             	pushl  0xc(%ebp)
  800fcc:	e8 13 fb ff ff       	call   800ae4 <strchr>
  800fd1:	83 c4 08             	add    $0x8,%esp
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	75 d3                	jne    800fab <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	84 c0                	test   %al,%al
  800fdf:	74 5a                	je     80103b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fe1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe4:	8b 00                	mov    (%eax),%eax
  800fe6:	83 f8 0f             	cmp    $0xf,%eax
  800fe9:	75 07                	jne    800ff2 <strsplit+0x6c>
		{
			return 0;
  800feb:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff0:	eb 66                	jmp    801058 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800ff2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff5:	8b 00                	mov    (%eax),%eax
  800ff7:	8d 48 01             	lea    0x1(%eax),%ecx
  800ffa:	8b 55 14             	mov    0x14(%ebp),%edx
  800ffd:	89 0a                	mov    %ecx,(%edx)
  800fff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	01 c2                	add    %eax,%edx
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801010:	eb 03                	jmp    801015 <strsplit+0x8f>
			string++;
  801012:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	84 c0                	test   %al,%al
  80101c:	74 8b                	je     800fa9 <strsplit+0x23>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	0f be c0             	movsbl %al,%eax
  801026:	50                   	push   %eax
  801027:	ff 75 0c             	pushl  0xc(%ebp)
  80102a:	e8 b5 fa ff ff       	call   800ae4 <strchr>
  80102f:	83 c4 08             	add    $0x8,%esp
  801032:	85 c0                	test   %eax,%eax
  801034:	74 dc                	je     801012 <strsplit+0x8c>
			string++;
	}
  801036:	e9 6e ff ff ff       	jmp    800fa9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80103b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80103c:	8b 45 14             	mov    0x14(%ebp),%eax
  80103f:	8b 00                	mov    (%eax),%eax
  801041:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801048:	8b 45 10             	mov    0x10(%ebp),%eax
  80104b:	01 d0                	add    %edx,%eax
  80104d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801053:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8b 55 0c             	mov    0xc(%ebp),%edx
  801069:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80106c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80106f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801072:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801075:	cd 30                	int    $0x30
  801077:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80107a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80107d:	83 c4 10             	add    $0x10,%esp
  801080:	5b                   	pop    %ebx
  801081:	5e                   	pop    %esi
  801082:	5f                   	pop    %edi
  801083:	5d                   	pop    %ebp
  801084:	c3                   	ret    

00801085 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801085:	55                   	push   %ebp
  801086:	89 e5                	mov    %esp,%ebp
  801088:	83 ec 04             	sub    $0x4,%esp
  80108b:	8b 45 10             	mov    0x10(%ebp),%eax
  80108e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801091:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	6a 00                	push   $0x0
  80109a:	6a 00                	push   $0x0
  80109c:	52                   	push   %edx
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	50                   	push   %eax
  8010a1:	6a 00                	push   $0x0
  8010a3:	e8 b2 ff ff ff       	call   80105a <syscall>
  8010a8:	83 c4 18             	add    $0x18,%esp
}
  8010ab:	90                   	nop
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    

008010ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010b1:	6a 00                	push   $0x0
  8010b3:	6a 00                	push   $0x0
  8010b5:	6a 00                	push   $0x0
  8010b7:	6a 00                	push   $0x0
  8010b9:	6a 00                	push   $0x0
  8010bb:	6a 01                	push   $0x1
  8010bd:	e8 98 ff ff ff       	call   80105a <syscall>
  8010c2:	83 c4 18             	add    $0x18,%esp
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8010ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	6a 00                	push   $0x0
  8010d2:	6a 00                	push   $0x0
  8010d4:	6a 00                	push   $0x0
  8010d6:	52                   	push   %edx
  8010d7:	50                   	push   %eax
  8010d8:	6a 05                	push   $0x5
  8010da:	e8 7b ff ff ff       	call   80105a <syscall>
  8010df:	83 c4 18             	add    $0x18,%esp
}
  8010e2:	c9                   	leave  
  8010e3:	c3                   	ret    

008010e4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8010e9:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	56                   	push   %esi
  8010f9:	53                   	push   %ebx
  8010fa:	51                   	push   %ecx
  8010fb:	52                   	push   %edx
  8010fc:	50                   	push   %eax
  8010fd:	6a 06                	push   $0x6
  8010ff:	e8 56 ff ff ff       	call   80105a <syscall>
  801104:	83 c4 18             	add    $0x18,%esp
}
  801107:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80110a:	5b                   	pop    %ebx
  80110b:	5e                   	pop    %esi
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801111:	8b 55 0c             	mov    0xc(%ebp),%edx
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	6a 00                	push   $0x0
  801119:	6a 00                	push   $0x0
  80111b:	6a 00                	push   $0x0
  80111d:	52                   	push   %edx
  80111e:	50                   	push   %eax
  80111f:	6a 07                	push   $0x7
  801121:	e8 34 ff ff ff       	call   80105a <syscall>
  801126:	83 c4 18             	add    $0x18,%esp
}
  801129:	c9                   	leave  
  80112a:	c3                   	ret    

0080112b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80112e:	6a 00                	push   $0x0
  801130:	6a 00                	push   $0x0
  801132:	6a 00                	push   $0x0
  801134:	ff 75 0c             	pushl  0xc(%ebp)
  801137:	ff 75 08             	pushl  0x8(%ebp)
  80113a:	6a 08                	push   $0x8
  80113c:	e8 19 ff ff ff       	call   80105a <syscall>
  801141:	83 c4 18             	add    $0x18,%esp
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801149:	6a 00                	push   $0x0
  80114b:	6a 00                	push   $0x0
  80114d:	6a 00                	push   $0x0
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	6a 09                	push   $0x9
  801155:	e8 00 ff ff ff       	call   80105a <syscall>
  80115a:	83 c4 18             	add    $0x18,%esp
}
  80115d:	c9                   	leave  
  80115e:	c3                   	ret    

0080115f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80115f:	55                   	push   %ebp
  801160:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801162:	6a 00                	push   $0x0
  801164:	6a 00                	push   $0x0
  801166:	6a 00                	push   $0x0
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 0a                	push   $0xa
  80116e:	e8 e7 fe ff ff       	call   80105a <syscall>
  801173:	83 c4 18             	add    $0x18,%esp
}
  801176:	c9                   	leave  
  801177:	c3                   	ret    

00801178 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801178:	55                   	push   %ebp
  801179:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80117b:	6a 00                	push   $0x0
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	6a 0b                	push   $0xb
  801187:	e8 ce fe ff ff       	call   80105a <syscall>
  80118c:	83 c4 18             	add    $0x18,%esp
}
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	ff 75 08             	pushl  0x8(%ebp)
  8011a0:	6a 0f                	push   $0xf
  8011a2:	e8 b3 fe ff ff       	call   80105a <syscall>
  8011a7:	83 c4 18             	add    $0x18,%esp
	return;
  8011aa:	90                   	nop
}
  8011ab:	c9                   	leave  
  8011ac:	c3                   	ret    

008011ad <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	ff 75 08             	pushl  0x8(%ebp)
  8011bc:	6a 10                	push   $0x10
  8011be:	e8 97 fe ff ff       	call   80105a <syscall>
  8011c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8011c6:	90                   	nop
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    

008011c9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8011cc:	6a 00                	push   $0x0
  8011ce:	6a 00                	push   $0x0
  8011d0:	ff 75 10             	pushl  0x10(%ebp)
  8011d3:	ff 75 0c             	pushl  0xc(%ebp)
  8011d6:	ff 75 08             	pushl  0x8(%ebp)
  8011d9:	6a 11                	push   $0x11
  8011db:	e8 7a fe ff ff       	call   80105a <syscall>
  8011e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8011e3:	90                   	nop
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 00                	push   $0x0
  8011f3:	6a 0c                	push   $0xc
  8011f5:	e8 60 fe ff ff       	call   80105a <syscall>
  8011fa:	83 c4 18             	add    $0x18,%esp
}
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801202:	6a 00                	push   $0x0
  801204:	6a 00                	push   $0x0
  801206:	6a 00                	push   $0x0
  801208:	6a 00                	push   $0x0
  80120a:	ff 75 08             	pushl  0x8(%ebp)
  80120d:	6a 0d                	push   $0xd
  80120f:	e8 46 fe ff ff       	call   80105a <syscall>
  801214:	83 c4 18             	add    $0x18,%esp
}
  801217:	c9                   	leave  
  801218:	c3                   	ret    

00801219 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	6a 0e                	push   $0xe
  801228:	e8 2d fe ff ff       	call   80105a <syscall>
  80122d:	83 c4 18             	add    $0x18,%esp
}
  801230:	90                   	nop
  801231:	c9                   	leave  
  801232:	c3                   	ret    

00801233 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801236:	6a 00                	push   $0x0
  801238:	6a 00                	push   $0x0
  80123a:	6a 00                	push   $0x0
  80123c:	6a 00                	push   $0x0
  80123e:	6a 00                	push   $0x0
  801240:	6a 13                	push   $0x13
  801242:	e8 13 fe ff ff       	call   80105a <syscall>
  801247:	83 c4 18             	add    $0x18,%esp
}
  80124a:	90                   	nop
  80124b:	c9                   	leave  
  80124c:	c3                   	ret    

0080124d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 00                	push   $0x0
  801258:	6a 00                	push   $0x0
  80125a:	6a 14                	push   $0x14
  80125c:	e8 f9 fd ff ff       	call   80105a <syscall>
  801261:	83 c4 18             	add    $0x18,%esp
}
  801264:	90                   	nop
  801265:	c9                   	leave  
  801266:	c3                   	ret    

00801267 <sys_cputc>:


void
sys_cputc(const char c)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	83 ec 04             	sub    $0x4,%esp
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801273:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 00                	push   $0x0
  80127f:	50                   	push   %eax
  801280:	6a 15                	push   $0x15
  801282:	e8 d3 fd ff ff       	call   80105a <syscall>
  801287:	83 c4 18             	add    $0x18,%esp
}
  80128a:	90                   	nop
  80128b:	c9                   	leave  
  80128c:	c3                   	ret    

0080128d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801290:	6a 00                	push   $0x0
  801292:	6a 00                	push   $0x0
  801294:	6a 00                	push   $0x0
  801296:	6a 00                	push   $0x0
  801298:	6a 00                	push   $0x0
  80129a:	6a 16                	push   $0x16
  80129c:	e8 b9 fd ff ff       	call   80105a <syscall>
  8012a1:	83 c4 18             	add    $0x18,%esp
}
  8012a4:	90                   	nop
  8012a5:	c9                   	leave  
  8012a6:	c3                   	ret    

008012a7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	6a 00                	push   $0x0
  8012b3:	ff 75 0c             	pushl  0xc(%ebp)
  8012b6:	50                   	push   %eax
  8012b7:	6a 17                	push   $0x17
  8012b9:	e8 9c fd ff ff       	call   80105a <syscall>
  8012be:	83 c4 18             	add    $0x18,%esp
}
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cc:	6a 00                	push   $0x0
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	52                   	push   %edx
  8012d3:	50                   	push   %eax
  8012d4:	6a 1a                	push   $0x1a
  8012d6:	e8 7f fd ff ff       	call   80105a <syscall>
  8012db:	83 c4 18             	add    $0x18,%esp
}
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8012e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e9:	6a 00                	push   $0x0
  8012eb:	6a 00                	push   $0x0
  8012ed:	6a 00                	push   $0x0
  8012ef:	52                   	push   %edx
  8012f0:	50                   	push   %eax
  8012f1:	6a 18                	push   $0x18
  8012f3:	e8 62 fd ff ff       	call   80105a <syscall>
  8012f8:	83 c4 18             	add    $0x18,%esp
}
  8012fb:	90                   	nop
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801301:	8b 55 0c             	mov    0xc(%ebp),%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	52                   	push   %edx
  80130e:	50                   	push   %eax
  80130f:	6a 19                	push   $0x19
  801311:	e8 44 fd ff ff       	call   80105a <syscall>
  801316:	83 c4 18             	add    $0x18,%esp
}
  801319:	90                   	nop
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 04             	sub    $0x4,%esp
  801322:	8b 45 10             	mov    0x10(%ebp),%eax
  801325:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801328:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80132b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	6a 00                	push   $0x0
  801334:	51                   	push   %ecx
  801335:	52                   	push   %edx
  801336:	ff 75 0c             	pushl  0xc(%ebp)
  801339:	50                   	push   %eax
  80133a:	6a 1b                	push   $0x1b
  80133c:	e8 19 fd ff ff       	call   80105a <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	52                   	push   %edx
  801356:	50                   	push   %eax
  801357:	6a 1c                	push   $0x1c
  801359:	e8 fc fc ff ff       	call   80105a <syscall>
  80135e:	83 c4 18             	add    $0x18,%esp
}
  801361:	c9                   	leave  
  801362:	c3                   	ret    

00801363 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801366:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	6a 00                	push   $0x0
  801371:	6a 00                	push   $0x0
  801373:	51                   	push   %ecx
  801374:	52                   	push   %edx
  801375:	50                   	push   %eax
  801376:	6a 1d                	push   $0x1d
  801378:	e8 dd fc ff ff       	call   80105a <syscall>
  80137d:	83 c4 18             	add    $0x18,%esp
}
  801380:	c9                   	leave  
  801381:	c3                   	ret    

00801382 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801385:	8b 55 0c             	mov    0xc(%ebp),%edx
  801388:	8b 45 08             	mov    0x8(%ebp),%eax
  80138b:	6a 00                	push   $0x0
  80138d:	6a 00                	push   $0x0
  80138f:	6a 00                	push   $0x0
  801391:	52                   	push   %edx
  801392:	50                   	push   %eax
  801393:	6a 1e                	push   $0x1e
  801395:	e8 c0 fc ff ff       	call   80105a <syscall>
  80139a:	83 c4 18             	add    $0x18,%esp
}
  80139d:	c9                   	leave  
  80139e:	c3                   	ret    

0080139f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	6a 1f                	push   $0x1f
  8013ae:	e8 a7 fc ff ff       	call   80105a <syscall>
  8013b3:	83 c4 18             	add    $0x18,%esp
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	6a 00                	push   $0x0
  8013c0:	ff 75 14             	pushl  0x14(%ebp)
  8013c3:	ff 75 10             	pushl  0x10(%ebp)
  8013c6:	ff 75 0c             	pushl  0xc(%ebp)
  8013c9:	50                   	push   %eax
  8013ca:	6a 20                	push   $0x20
  8013cc:	e8 89 fc ff ff       	call   80105a <syscall>
  8013d1:	83 c4 18             	add    $0x18,%esp
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 00                	push   $0x0
  8013e0:	6a 00                	push   $0x0
  8013e2:	6a 00                	push   $0x0
  8013e4:	50                   	push   %eax
  8013e5:	6a 21                	push   $0x21
  8013e7:	e8 6e fc ff ff       	call   80105a <syscall>
  8013ec:	83 c4 18             	add    $0x18,%esp
}
  8013ef:	90                   	nop
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	6a 00                	push   $0x0
  8013fa:	6a 00                	push   $0x0
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	50                   	push   %eax
  801401:	6a 22                	push   $0x22
  801403:	e8 52 fc ff ff       	call   80105a <syscall>
  801408:	83 c4 18             	add    $0x18,%esp
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	6a 00                	push   $0x0
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 02                	push   $0x2
  80141c:	e8 39 fc ff ff       	call   80105a <syscall>
  801421:	83 c4 18             	add    $0x18,%esp
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 03                	push   $0x3
  801435:	e8 20 fc ff ff       	call   80105a <syscall>
  80143a:	83 c4 18             	add    $0x18,%esp
}
  80143d:	c9                   	leave  
  80143e:	c3                   	ret    

0080143f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 04                	push   $0x4
  80144e:	e8 07 fc ff ff       	call   80105a <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
}
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_exit_env>:


void sys_exit_env(void)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 23                	push   $0x23
  801467:	e8 ee fb ff ff       	call   80105a <syscall>
  80146c:	83 c4 18             	add    $0x18,%esp
}
  80146f:	90                   	nop
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801478:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80147b:	8d 50 04             	lea    0x4(%eax),%edx
  80147e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801481:	6a 00                	push   $0x0
  801483:	6a 00                	push   $0x0
  801485:	6a 00                	push   $0x0
  801487:	52                   	push   %edx
  801488:	50                   	push   %eax
  801489:	6a 24                	push   $0x24
  80148b:	e8 ca fb ff ff       	call   80105a <syscall>
  801490:	83 c4 18             	add    $0x18,%esp
	return result;
  801493:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801496:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801499:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80149c:	89 01                	mov    %eax,(%ecx)
  80149e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	c9                   	leave  
  8014a5:	c2 04 00             	ret    $0x4

008014a8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	ff 75 10             	pushl  0x10(%ebp)
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	ff 75 08             	pushl  0x8(%ebp)
  8014b8:	6a 12                	push   $0x12
  8014ba:	e8 9b fb ff ff       	call   80105a <syscall>
  8014bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8014c2:	90                   	nop
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <sys_rcr2>:
uint32 sys_rcr2()
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 25                	push   $0x25
  8014d4:	e8 81 fb ff ff       	call   80105a <syscall>
  8014d9:	83 c4 18             	add    $0x18,%esp
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8014ea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	50                   	push   %eax
  8014f7:	6a 26                	push   $0x26
  8014f9:	e8 5c fb ff ff       	call   80105a <syscall>
  8014fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801501:	90                   	nop
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <rsttst>:
void rsttst()
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 28                	push   $0x28
  801513:	e8 42 fb ff ff       	call   80105a <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
	return ;
  80151b:	90                   	nop
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	8b 45 14             	mov    0x14(%ebp),%eax
  801527:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80152a:	8b 55 18             	mov    0x18(%ebp),%edx
  80152d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801531:	52                   	push   %edx
  801532:	50                   	push   %eax
  801533:	ff 75 10             	pushl  0x10(%ebp)
  801536:	ff 75 0c             	pushl  0xc(%ebp)
  801539:	ff 75 08             	pushl  0x8(%ebp)
  80153c:	6a 27                	push   $0x27
  80153e:	e8 17 fb ff ff       	call   80105a <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
	return ;
  801546:	90                   	nop
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <chktst>:
void chktst(uint32 n)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	ff 75 08             	pushl  0x8(%ebp)
  801557:	6a 29                	push   $0x29
  801559:	e8 fc fa ff ff       	call   80105a <syscall>
  80155e:	83 c4 18             	add    $0x18,%esp
	return ;
  801561:	90                   	nop
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <inctst>:

void inctst()
{
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 2a                	push   $0x2a
  801573:	e8 e2 fa ff ff       	call   80105a <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
	return ;
  80157b:	90                   	nop
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <gettst>:
uint32 gettst()
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 2b                	push   $0x2b
  80158d:	e8 c8 fa ff ff       	call   80105a <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 2c                	push   $0x2c
  8015a9:	e8 ac fa ff ff       	call   80105a <syscall>
  8015ae:	83 c4 18             	add    $0x18,%esp
  8015b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8015b4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8015b8:	75 07                	jne    8015c1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8015ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8015bf:	eb 05                	jmp    8015c6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 2c                	push   $0x2c
  8015da:	e8 7b fa ff ff       	call   80105a <syscall>
  8015df:	83 c4 18             	add    $0x18,%esp
  8015e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8015e5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8015e9:	75 07                	jne    8015f2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8015eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8015f0:	eb 05                	jmp    8015f7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8015f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 2c                	push   $0x2c
  80160b:	e8 4a fa ff ff       	call   80105a <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
  801613:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801616:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80161a:	75 07                	jne    801623 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80161c:	b8 01 00 00 00       	mov    $0x1,%eax
  801621:	eb 05                	jmp    801628 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 2c                	push   $0x2c
  80163c:	e8 19 fa ff ff       	call   80105a <syscall>
  801641:	83 c4 18             	add    $0x18,%esp
  801644:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801647:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80164b:	75 07                	jne    801654 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80164d:	b8 01 00 00 00       	mov    $0x1,%eax
  801652:	eb 05                	jmp    801659 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801654:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	ff 75 08             	pushl  0x8(%ebp)
  801669:	6a 2d                	push   $0x2d
  80166b:	e8 ea f9 ff ff       	call   80105a <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
	return ;
  801673:	90                   	nop
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80167a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80167d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801680:	8b 55 0c             	mov    0xc(%ebp),%edx
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	6a 00                	push   $0x0
  801688:	53                   	push   %ebx
  801689:	51                   	push   %ecx
  80168a:	52                   	push   %edx
  80168b:	50                   	push   %eax
  80168c:	6a 2e                	push   $0x2e
  80168e:	e8 c7 f9 ff ff       	call   80105a <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80169e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	52                   	push   %edx
  8016ab:	50                   	push   %eax
  8016ac:	6a 2f                	push   $0x2f
  8016ae:	e8 a7 f9 ff ff       	call   80105a <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8016be:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c1:	89 d0                	mov    %edx,%eax
  8016c3:	c1 e0 02             	shl    $0x2,%eax
  8016c6:	01 d0                	add    %edx,%eax
  8016c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cf:	01 d0                	add    %edx,%eax
  8016d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016d8:	01 d0                	add    %edx,%eax
  8016da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016e1:	01 d0                	add    %edx,%eax
  8016e3:	c1 e0 04             	shl    $0x4,%eax
  8016e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8016e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8016f0:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8016f3:	83 ec 0c             	sub    $0xc,%esp
  8016f6:	50                   	push   %eax
  8016f7:	e8 76 fd ff ff       	call   801472 <sys_get_virtual_time>
  8016fc:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8016ff:	eb 41                	jmp    801742 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801701:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801704:	83 ec 0c             	sub    $0xc,%esp
  801707:	50                   	push   %eax
  801708:	e8 65 fd ff ff       	call   801472 <sys_get_virtual_time>
  80170d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801710:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801713:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801716:	29 c2                	sub    %eax,%edx
  801718:	89 d0                	mov    %edx,%eax
  80171a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80171d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801723:	89 d1                	mov    %edx,%ecx
  801725:	29 c1                	sub    %eax,%ecx
  801727:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80172a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172d:	39 c2                	cmp    %eax,%edx
  80172f:	0f 97 c0             	seta   %al
  801732:	0f b6 c0             	movzbl %al,%eax
  801735:	29 c1                	sub    %eax,%ecx
  801737:	89 c8                	mov    %ecx,%eax
  801739:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80173c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80173f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801748:	72 b7                	jb     801701 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80174a:	90                   	nop
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801753:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80175a:	eb 03                	jmp    80175f <busy_wait+0x12>
  80175c:	ff 45 fc             	incl   -0x4(%ebp)
  80175f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801762:	3b 45 08             	cmp    0x8(%ebp),%eax
  801765:	72 f5                	jb     80175c <busy_wait+0xf>
	return i;
  801767:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <__udivdi3>:
  80176c:	55                   	push   %ebp
  80176d:	57                   	push   %edi
  80176e:	56                   	push   %esi
  80176f:	53                   	push   %ebx
  801770:	83 ec 1c             	sub    $0x1c,%esp
  801773:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801777:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80177b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80177f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801783:	89 ca                	mov    %ecx,%edx
  801785:	89 f8                	mov    %edi,%eax
  801787:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80178b:	85 f6                	test   %esi,%esi
  80178d:	75 2d                	jne    8017bc <__udivdi3+0x50>
  80178f:	39 cf                	cmp    %ecx,%edi
  801791:	77 65                	ja     8017f8 <__udivdi3+0x8c>
  801793:	89 fd                	mov    %edi,%ebp
  801795:	85 ff                	test   %edi,%edi
  801797:	75 0b                	jne    8017a4 <__udivdi3+0x38>
  801799:	b8 01 00 00 00       	mov    $0x1,%eax
  80179e:	31 d2                	xor    %edx,%edx
  8017a0:	f7 f7                	div    %edi
  8017a2:	89 c5                	mov    %eax,%ebp
  8017a4:	31 d2                	xor    %edx,%edx
  8017a6:	89 c8                	mov    %ecx,%eax
  8017a8:	f7 f5                	div    %ebp
  8017aa:	89 c1                	mov    %eax,%ecx
  8017ac:	89 d8                	mov    %ebx,%eax
  8017ae:	f7 f5                	div    %ebp
  8017b0:	89 cf                	mov    %ecx,%edi
  8017b2:	89 fa                	mov    %edi,%edx
  8017b4:	83 c4 1c             	add    $0x1c,%esp
  8017b7:	5b                   	pop    %ebx
  8017b8:	5e                   	pop    %esi
  8017b9:	5f                   	pop    %edi
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    
  8017bc:	39 ce                	cmp    %ecx,%esi
  8017be:	77 28                	ja     8017e8 <__udivdi3+0x7c>
  8017c0:	0f bd fe             	bsr    %esi,%edi
  8017c3:	83 f7 1f             	xor    $0x1f,%edi
  8017c6:	75 40                	jne    801808 <__udivdi3+0x9c>
  8017c8:	39 ce                	cmp    %ecx,%esi
  8017ca:	72 0a                	jb     8017d6 <__udivdi3+0x6a>
  8017cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8017d0:	0f 87 9e 00 00 00    	ja     801874 <__udivdi3+0x108>
  8017d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017db:	89 fa                	mov    %edi,%edx
  8017dd:	83 c4 1c             	add    $0x1c,%esp
  8017e0:	5b                   	pop    %ebx
  8017e1:	5e                   	pop    %esi
  8017e2:	5f                   	pop    %edi
  8017e3:	5d                   	pop    %ebp
  8017e4:	c3                   	ret    
  8017e5:	8d 76 00             	lea    0x0(%esi),%esi
  8017e8:	31 ff                	xor    %edi,%edi
  8017ea:	31 c0                	xor    %eax,%eax
  8017ec:	89 fa                	mov    %edi,%edx
  8017ee:	83 c4 1c             	add    $0x1c,%esp
  8017f1:	5b                   	pop    %ebx
  8017f2:	5e                   	pop    %esi
  8017f3:	5f                   	pop    %edi
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    
  8017f6:	66 90                	xchg   %ax,%ax
  8017f8:	89 d8                	mov    %ebx,%eax
  8017fa:	f7 f7                	div    %edi
  8017fc:	31 ff                	xor    %edi,%edi
  8017fe:	89 fa                	mov    %edi,%edx
  801800:	83 c4 1c             	add    $0x1c,%esp
  801803:	5b                   	pop    %ebx
  801804:	5e                   	pop    %esi
  801805:	5f                   	pop    %edi
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    
  801808:	bd 20 00 00 00       	mov    $0x20,%ebp
  80180d:	89 eb                	mov    %ebp,%ebx
  80180f:	29 fb                	sub    %edi,%ebx
  801811:	89 f9                	mov    %edi,%ecx
  801813:	d3 e6                	shl    %cl,%esi
  801815:	89 c5                	mov    %eax,%ebp
  801817:	88 d9                	mov    %bl,%cl
  801819:	d3 ed                	shr    %cl,%ebp
  80181b:	89 e9                	mov    %ebp,%ecx
  80181d:	09 f1                	or     %esi,%ecx
  80181f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801823:	89 f9                	mov    %edi,%ecx
  801825:	d3 e0                	shl    %cl,%eax
  801827:	89 c5                	mov    %eax,%ebp
  801829:	89 d6                	mov    %edx,%esi
  80182b:	88 d9                	mov    %bl,%cl
  80182d:	d3 ee                	shr    %cl,%esi
  80182f:	89 f9                	mov    %edi,%ecx
  801831:	d3 e2                	shl    %cl,%edx
  801833:	8b 44 24 08          	mov    0x8(%esp),%eax
  801837:	88 d9                	mov    %bl,%cl
  801839:	d3 e8                	shr    %cl,%eax
  80183b:	09 c2                	or     %eax,%edx
  80183d:	89 d0                	mov    %edx,%eax
  80183f:	89 f2                	mov    %esi,%edx
  801841:	f7 74 24 0c          	divl   0xc(%esp)
  801845:	89 d6                	mov    %edx,%esi
  801847:	89 c3                	mov    %eax,%ebx
  801849:	f7 e5                	mul    %ebp
  80184b:	39 d6                	cmp    %edx,%esi
  80184d:	72 19                	jb     801868 <__udivdi3+0xfc>
  80184f:	74 0b                	je     80185c <__udivdi3+0xf0>
  801851:	89 d8                	mov    %ebx,%eax
  801853:	31 ff                	xor    %edi,%edi
  801855:	e9 58 ff ff ff       	jmp    8017b2 <__udivdi3+0x46>
  80185a:	66 90                	xchg   %ax,%ax
  80185c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801860:	89 f9                	mov    %edi,%ecx
  801862:	d3 e2                	shl    %cl,%edx
  801864:	39 c2                	cmp    %eax,%edx
  801866:	73 e9                	jae    801851 <__udivdi3+0xe5>
  801868:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80186b:	31 ff                	xor    %edi,%edi
  80186d:	e9 40 ff ff ff       	jmp    8017b2 <__udivdi3+0x46>
  801872:	66 90                	xchg   %ax,%ax
  801874:	31 c0                	xor    %eax,%eax
  801876:	e9 37 ff ff ff       	jmp    8017b2 <__udivdi3+0x46>
  80187b:	90                   	nop

0080187c <__umoddi3>:
  80187c:	55                   	push   %ebp
  80187d:	57                   	push   %edi
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
  801880:	83 ec 1c             	sub    $0x1c,%esp
  801883:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801887:	8b 74 24 34          	mov    0x34(%esp),%esi
  80188b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80188f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801893:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801897:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80189b:	89 f3                	mov    %esi,%ebx
  80189d:	89 fa                	mov    %edi,%edx
  80189f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018a3:	89 34 24             	mov    %esi,(%esp)
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	75 1a                	jne    8018c4 <__umoddi3+0x48>
  8018aa:	39 f7                	cmp    %esi,%edi
  8018ac:	0f 86 a2 00 00 00    	jbe    801954 <__umoddi3+0xd8>
  8018b2:	89 c8                	mov    %ecx,%eax
  8018b4:	89 f2                	mov    %esi,%edx
  8018b6:	f7 f7                	div    %edi
  8018b8:	89 d0                	mov    %edx,%eax
  8018ba:	31 d2                	xor    %edx,%edx
  8018bc:	83 c4 1c             	add    $0x1c,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    
  8018c4:	39 f0                	cmp    %esi,%eax
  8018c6:	0f 87 ac 00 00 00    	ja     801978 <__umoddi3+0xfc>
  8018cc:	0f bd e8             	bsr    %eax,%ebp
  8018cf:	83 f5 1f             	xor    $0x1f,%ebp
  8018d2:	0f 84 ac 00 00 00    	je     801984 <__umoddi3+0x108>
  8018d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8018dd:	29 ef                	sub    %ebp,%edi
  8018df:	89 fe                	mov    %edi,%esi
  8018e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018e5:	89 e9                	mov    %ebp,%ecx
  8018e7:	d3 e0                	shl    %cl,%eax
  8018e9:	89 d7                	mov    %edx,%edi
  8018eb:	89 f1                	mov    %esi,%ecx
  8018ed:	d3 ef                	shr    %cl,%edi
  8018ef:	09 c7                	or     %eax,%edi
  8018f1:	89 e9                	mov    %ebp,%ecx
  8018f3:	d3 e2                	shl    %cl,%edx
  8018f5:	89 14 24             	mov    %edx,(%esp)
  8018f8:	89 d8                	mov    %ebx,%eax
  8018fa:	d3 e0                	shl    %cl,%eax
  8018fc:	89 c2                	mov    %eax,%edx
  8018fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801902:	d3 e0                	shl    %cl,%eax
  801904:	89 44 24 04          	mov    %eax,0x4(%esp)
  801908:	8b 44 24 08          	mov    0x8(%esp),%eax
  80190c:	89 f1                	mov    %esi,%ecx
  80190e:	d3 e8                	shr    %cl,%eax
  801910:	09 d0                	or     %edx,%eax
  801912:	d3 eb                	shr    %cl,%ebx
  801914:	89 da                	mov    %ebx,%edx
  801916:	f7 f7                	div    %edi
  801918:	89 d3                	mov    %edx,%ebx
  80191a:	f7 24 24             	mull   (%esp)
  80191d:	89 c6                	mov    %eax,%esi
  80191f:	89 d1                	mov    %edx,%ecx
  801921:	39 d3                	cmp    %edx,%ebx
  801923:	0f 82 87 00 00 00    	jb     8019b0 <__umoddi3+0x134>
  801929:	0f 84 91 00 00 00    	je     8019c0 <__umoddi3+0x144>
  80192f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801933:	29 f2                	sub    %esi,%edx
  801935:	19 cb                	sbb    %ecx,%ebx
  801937:	89 d8                	mov    %ebx,%eax
  801939:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80193d:	d3 e0                	shl    %cl,%eax
  80193f:	89 e9                	mov    %ebp,%ecx
  801941:	d3 ea                	shr    %cl,%edx
  801943:	09 d0                	or     %edx,%eax
  801945:	89 e9                	mov    %ebp,%ecx
  801947:	d3 eb                	shr    %cl,%ebx
  801949:	89 da                	mov    %ebx,%edx
  80194b:	83 c4 1c             	add    $0x1c,%esp
  80194e:	5b                   	pop    %ebx
  80194f:	5e                   	pop    %esi
  801950:	5f                   	pop    %edi
  801951:	5d                   	pop    %ebp
  801952:	c3                   	ret    
  801953:	90                   	nop
  801954:	89 fd                	mov    %edi,%ebp
  801956:	85 ff                	test   %edi,%edi
  801958:	75 0b                	jne    801965 <__umoddi3+0xe9>
  80195a:	b8 01 00 00 00       	mov    $0x1,%eax
  80195f:	31 d2                	xor    %edx,%edx
  801961:	f7 f7                	div    %edi
  801963:	89 c5                	mov    %eax,%ebp
  801965:	89 f0                	mov    %esi,%eax
  801967:	31 d2                	xor    %edx,%edx
  801969:	f7 f5                	div    %ebp
  80196b:	89 c8                	mov    %ecx,%eax
  80196d:	f7 f5                	div    %ebp
  80196f:	89 d0                	mov    %edx,%eax
  801971:	e9 44 ff ff ff       	jmp    8018ba <__umoddi3+0x3e>
  801976:	66 90                	xchg   %ax,%ax
  801978:	89 c8                	mov    %ecx,%eax
  80197a:	89 f2                	mov    %esi,%edx
  80197c:	83 c4 1c             	add    $0x1c,%esp
  80197f:	5b                   	pop    %ebx
  801980:	5e                   	pop    %esi
  801981:	5f                   	pop    %edi
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    
  801984:	3b 04 24             	cmp    (%esp),%eax
  801987:	72 06                	jb     80198f <__umoddi3+0x113>
  801989:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80198d:	77 0f                	ja     80199e <__umoddi3+0x122>
  80198f:	89 f2                	mov    %esi,%edx
  801991:	29 f9                	sub    %edi,%ecx
  801993:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801997:	89 14 24             	mov    %edx,(%esp)
  80199a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80199e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8019a2:	8b 14 24             	mov    (%esp),%edx
  8019a5:	83 c4 1c             	add    $0x1c,%esp
  8019a8:	5b                   	pop    %ebx
  8019a9:	5e                   	pop    %esi
  8019aa:	5f                   	pop    %edi
  8019ab:	5d                   	pop    %ebp
  8019ac:	c3                   	ret    
  8019ad:	8d 76 00             	lea    0x0(%esi),%esi
  8019b0:	2b 04 24             	sub    (%esp),%eax
  8019b3:	19 fa                	sbb    %edi,%edx
  8019b5:	89 d1                	mov    %edx,%ecx
  8019b7:	89 c6                	mov    %eax,%esi
  8019b9:	e9 71 ff ff ff       	jmp    80192f <__umoddi3+0xb3>
  8019be:	66 90                	xchg   %ax,%ax
  8019c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8019c4:	72 ea                	jb     8019b0 <__umoddi3+0x134>
  8019c6:	89 d9                	mov    %ebx,%ecx
  8019c8:	e9 62 ff ff ff       	jmp    80192f <__umoddi3+0xb3>
