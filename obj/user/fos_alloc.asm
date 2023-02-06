
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 71 12 00 00       	call   8012c1 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 00 32 80 00       	push   $0x803200
  800061:	e8 0f 03 00 00       	call   800375 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 13 32 80 00       	push   $0x803213
  8000be:	e8 b2 02 00 00       	call   800375 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 7c 12 00 00       	call   801358 <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 d7 11 00 00       	call   8012c1 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 13 32 80 00       	push   $0x803213
  800114:	e8 5c 02 00 00       	call   800375 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 26 12 00 00       	call   801358 <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 9d 18 00 00       	call   8019e0 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 04             	shl    $0x4,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 20 40 80 00       	mov    0x804020,%eax
  80016f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800175:	84 c0                	test   %al,%al
  800177:	74 0f                	je     800188 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800179:	a1 20 40 80 00       	mov    0x804020,%eax
  80017e:	05 5c 05 00 00       	add    $0x55c,%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018c:	7e 0a                	jle    800198 <libmain+0x60>
		binaryname = argv[0];
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	ff 75 0c             	pushl  0xc(%ebp)
  80019e:	ff 75 08             	pushl  0x8(%ebp)
  8001a1:	e8 92 fe ff ff       	call   800038 <_main>
  8001a6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a9:	e8 3f 16 00 00       	call   8017ed <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 38 32 80 00       	push   $0x803238
  8001b6:	e8 8d 01 00 00       	call   800348 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001be:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c3:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	68 60 32 80 00       	push   $0x803260
  8001de:	e8 65 01 00 00       	call   800348 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001eb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800207:	51                   	push   %ecx
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	68 88 32 80 00       	push   $0x803288
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 e0 32 80 00       	push   $0x8032e0
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 38 32 80 00       	push   $0x803238
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 bf 15 00 00       	call   801807 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800248:	e8 19 00 00 00       	call   800266 <exit>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 00                	push   $0x0
  80025b:	e8 4c 17 00 00       	call   8019ac <sys_destroy_env>
  800260:	83 c4 10             	add    $0x10,%esp
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <exit>:

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026c:	e8 a1 17 00 00       	call   801a12 <sys_exit_env>
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	8d 48 01             	lea    0x1(%eax),%ecx
  800282:	8b 55 0c             	mov    0xc(%ebp),%edx
  800285:	89 0a                	mov    %ecx,(%edx)
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	88 d1                	mov    %dl,%cl
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
  800296:	8b 00                	mov    (%eax),%eax
  800298:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029d:	75 2c                	jne    8002cb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029f:	a0 24 40 80 00       	mov    0x804024,%al
  8002a4:	0f b6 c0             	movzbl %al,%eax
  8002a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002aa:	8b 12                	mov    (%edx),%edx
  8002ac:	89 d1                	mov    %edx,%ecx
  8002ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b1:	83 c2 08             	add    $0x8,%edx
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	50                   	push   %eax
  8002b8:	51                   	push   %ecx
  8002b9:	52                   	push   %edx
  8002ba:	e8 80 13 00 00       	call   80163f <sys_cputs>
  8002bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	8b 40 04             	mov    0x4(%eax),%eax
  8002d1:	8d 50 01             	lea    0x1(%eax),%edx
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002da:	90                   	nop
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ed:	00 00 00 
	b.cnt = 0;
  8002f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fa:	ff 75 0c             	pushl  0xc(%ebp)
  8002fd:	ff 75 08             	pushl  0x8(%ebp)
  800300:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800306:	50                   	push   %eax
  800307:	68 74 02 80 00       	push   $0x800274
  80030c:	e8 11 02 00 00       	call   800522 <vprintfmt>
  800311:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800314:	a0 24 40 80 00       	mov    0x804024,%al
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	50                   	push   %eax
  800326:	52                   	push   %edx
  800327:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032d:	83 c0 08             	add    $0x8,%eax
  800330:	50                   	push   %eax
  800331:	e8 09 13 00 00       	call   80163f <sys_cputs>
  800336:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800339:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800340:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <cprintf>:

int cprintf(const char *fmt, ...) {
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80034e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800355:	8d 45 0c             	lea    0xc(%ebp),%eax
  800358:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 f4             	pushl  -0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	e8 73 ff ff ff       	call   8002dd <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800370:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80037b:	e8 6d 14 00 00       	call   8017ed <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800380:	8d 45 0c             	lea    0xc(%ebp),%eax
  800383:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	50                   	push   %eax
  800390:	e8 48 ff ff ff       	call   8002dd <vcprintf>
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80039b:	e8 67 14 00 00       	call   801807 <sys_enable_interrupt>
	return cnt;
  8003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	53                   	push   %ebx
  8003a9:	83 ec 14             	sub    $0x14,%esp
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c3:	77 55                	ja     80041a <printnum+0x75>
  8003c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c8:	72 05                	jb     8003cf <printnum+0x2a>
  8003ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003cd:	77 4b                	ja     80041a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e5:	e8 ae 2b 00 00       	call   802f98 <__udivdi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	ff 75 20             	pushl  0x20(%ebp)
  8003f3:	53                   	push   %ebx
  8003f4:	ff 75 18             	pushl  0x18(%ebp)
  8003f7:	52                   	push   %edx
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	e8 a1 ff ff ff       	call   8003a5 <printnum>
  800404:	83 c4 20             	add    $0x20,%esp
  800407:	eb 1a                	jmp    800423 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 20             	pushl  0x20(%ebp)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	ff d0                	call   *%eax
  800417:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	ff 4d 1c             	decl   0x1c(%ebp)
  80041d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800421:	7f e6                	jg     800409 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800423:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800431:	53                   	push   %ebx
  800432:	51                   	push   %ecx
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	e8 6e 2c 00 00       	call   8030a8 <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 14 35 80 00       	add    $0x803514,%eax
  800442:	8a 00                	mov    (%eax),%al
  800444:	0f be c0             	movsbl %al,%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	ff d0                	call   *%eax
  800453:	83 c4 10             	add    $0x10,%esp
}
  800456:	90                   	nop
  800457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    

0080045c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800463:	7e 1c                	jle    800481 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 08             	lea    0x8(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 08             	sub    $0x8,%eax
  80047a:	8b 50 04             	mov    0x4(%eax),%edx
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	eb 40                	jmp    8004c1 <getuint+0x65>
	else if (lflag)
  800481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800485:	74 1e                	je     8004a5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 50 04             	lea    0x4(%eax),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	89 10                	mov    %edx,(%eax)
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 e8 04             	sub    $0x4,%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	eb 1c                	jmp    8004c1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 04             	sub    $0x4,%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c1:	5d                   	pop    %ebp
  8004c2:	c3                   	ret    

008004c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ca:	7e 1c                	jle    8004e8 <getint+0x25>
		return va_arg(*ap, long long);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	8d 50 08             	lea    0x8(%eax),%edx
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 10                	mov    %edx,(%eax)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	83 e8 08             	sub    $0x8,%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	eb 38                	jmp    800520 <getint+0x5d>
	else if (lflag)
  8004e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ec:	74 1a                	je     800508 <getint+0x45>
		return va_arg(*ap, long);
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 50 04             	lea    0x4(%eax),%edx
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	89 10                	mov    %edx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	83 e8 04             	sub    $0x4,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	99                   	cltd   
  800506:	eb 18                	jmp    800520 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 04             	lea    0x4(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 04             	sub    $0x4,%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	99                   	cltd   
}
  800520:	5d                   	pop    %ebp
  800521:	c3                   	ret    

00800522 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	56                   	push   %esi
  800526:	53                   	push   %ebx
  800527:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052a:	eb 17                	jmp    800543 <vprintfmt+0x21>
			if (ch == '\0')
  80052c:	85 db                	test   %ebx,%ebx
  80052e:	0f 84 af 03 00 00    	je     8008e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	53                   	push   %ebx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	ff d0                	call   *%eax
  800540:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 50 01             	lea    0x1(%eax),%edx
  800549:	89 55 10             	mov    %edx,0x10(%ebp)
  80054c:	8a 00                	mov    (%eax),%al
  80054e:	0f b6 d8             	movzbl %al,%ebx
  800551:	83 fb 25             	cmp    $0x25,%ebx
  800554:	75 d6                	jne    80052c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800556:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80055a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800561:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800587:	83 f8 55             	cmp    $0x55,%eax
  80058a:	0f 87 2b 03 00 00    	ja     8008bb <vprintfmt+0x399>
  800590:	8b 04 85 38 35 80 00 	mov    0x803538(,%eax,4),%eax
  800597:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800599:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059d:	eb d7                	jmp    800576 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a3:	eb d1                	jmp    800576 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	c1 e0 02             	shl    $0x2,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d8                	add    %ebx,%eax
  8005ba:	83 e8 30             	sub    $0x30,%eax
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c3:	8a 00                	mov    (%eax),%al
  8005c5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005cb:	7e 3e                	jle    80060b <vprintfmt+0xe9>
  8005cd:	83 fb 39             	cmp    $0x39,%ebx
  8005d0:	7f 39                	jg     80060b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d5:	eb d5                	jmp    8005ac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	83 c0 04             	add    $0x4,%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 e8 04             	sub    $0x4,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005eb:	eb 1f                	jmp    80060c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	79 83                	jns    800576 <vprintfmt+0x54>
				width = 0;
  8005f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fa:	e9 77 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800606:	e9 6b ff ff ff       	jmp    800576 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800610:	0f 89 60 ff ff ff    	jns    800576 <vprintfmt+0x54>
				width = precision, precision = -1;
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800623:	e9 4e ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800628:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80062b:	e9 46 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	83 c0 04             	add    $0x4,%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 e8 04             	sub    $0x4,%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	50                   	push   %eax
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
			break;
  800650:	e9 89 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	83 c0 04             	add    $0x4,%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 e8 04             	sub    $0x4,%eax
  800664:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800666:	85 db                	test   %ebx,%ebx
  800668:	79 02                	jns    80066c <vprintfmt+0x14a>
				err = -err;
  80066a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066c:	83 fb 64             	cmp    $0x64,%ebx
  80066f:	7f 0b                	jg     80067c <vprintfmt+0x15a>
  800671:	8b 34 9d 80 33 80 00 	mov    0x803380(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 25 35 80 00       	push   $0x803525
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 5e 02 00 00       	call   8008eb <printfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800690:	e9 49 02 00 00       	jmp    8008de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800695:	56                   	push   %esi
  800696:	68 2e 35 80 00       	push   $0x80352e
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	e8 45 02 00 00       	call   8008eb <printfmt>
  8006a6:	83 c4 10             	add    $0x10,%esp
			break;
  8006a9:	e9 30 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	83 c0 04             	add    $0x4,%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 30                	mov    (%eax),%esi
  8006bf:	85 f6                	test   %esi,%esi
  8006c1:	75 05                	jne    8006c8 <vprintfmt+0x1a6>
				p = "(null)";
  8006c3:	be 31 35 80 00       	mov    $0x803531,%esi
			if (width > 0 && padc != '-')
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	7e 6d                	jle    80073b <vprintfmt+0x219>
  8006ce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d2:	74 67                	je     80073b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	50                   	push   %eax
  8006db:	56                   	push   %esi
  8006dc:	e8 0c 03 00 00       	call   8009ed <strnlen>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e7:	eb 16                	jmp    8006ff <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	ff d0                	call   *%eax
  8006f9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	7f e4                	jg     8006e9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	eb 34                	jmp    80073b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800707:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070b:	74 1c                	je     800729 <vprintfmt+0x207>
  80070d:	83 fb 1f             	cmp    $0x1f,%ebx
  800710:	7e 05                	jle    800717 <vprintfmt+0x1f5>
  800712:	83 fb 7e             	cmp    $0x7e,%ebx
  800715:	7e 12                	jle    800729 <vprintfmt+0x207>
					putch('?', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 3f                	push   $0x3f
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	eb 0f                	jmp    800738 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	53                   	push   %ebx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	ff 4d e4             	decl   -0x1c(%ebp)
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	8d 70 01             	lea    0x1(%eax),%esi
  800740:	8a 00                	mov    (%eax),%al
  800742:	0f be d8             	movsbl %al,%ebx
  800745:	85 db                	test   %ebx,%ebx
  800747:	74 24                	je     80076d <vprintfmt+0x24b>
  800749:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074d:	78 b8                	js     800707 <vprintfmt+0x1e5>
  80074f:	ff 4d e0             	decl   -0x20(%ebp)
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	79 af                	jns    800707 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800758:	eb 13                	jmp    80076d <vprintfmt+0x24b>
				putch(' ', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 20                	push   $0x20
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076a:	ff 4d e4             	decl   -0x1c(%ebp)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800771:	7f e7                	jg     80075a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800773:	e9 66 01 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 e8             	pushl  -0x18(%ebp)
  80077e:	8d 45 14             	lea    0x14(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	e8 3c fd ff ff       	call   8004c3 <getint>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800796:	85 d2                	test   %edx,%edx
  800798:	79 23                	jns    8007bd <vprintfmt+0x29b>
				putch('-', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	6a 2d                	push   $0x2d
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b0:	f7 d8                	neg    %eax
  8007b2:	83 d2 00             	adc    $0x0,%edx
  8007b5:	f7 da                	neg    %edx
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c4:	e9 bc 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	e8 84 fc ff ff       	call   80045c <getuint>
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e8:	e9 98 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	6a 58                	push   $0x58
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	6a 58                	push   $0x58
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 58                	push   $0x58
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			break;
  80081d:	e9 bc 00 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	6a 30                	push   $0x30
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 78                	push   $0x78
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 c0 04             	add    $0x4,%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80085d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800864:	eb 1f                	jmp    800885 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 e8             	pushl  -0x18(%ebp)
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	e8 e7 fb ff ff       	call   80045c <getuint>
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80087e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800885:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	52                   	push   %edx
  800890:	ff 75 e4             	pushl  -0x1c(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 f4             	pushl  -0xc(%ebp)
  800897:	ff 75 f0             	pushl  -0x10(%ebp)
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	ff 75 08             	pushl  0x8(%ebp)
  8008a0:	e8 00 fb ff ff       	call   8003a5 <printnum>
  8008a5:	83 c4 20             	add    $0x20,%esp
			break;
  8008a8:	eb 34                	jmp    8008de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
			break;
  8008b9:	eb 23                	jmp    8008de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	6a 25                	push   $0x25
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cb:	ff 4d 10             	decl   0x10(%ebp)
  8008ce:	eb 03                	jmp    8008d3 <vprintfmt+0x3b1>
  8008d0:	ff 4d 10             	decl   0x10(%ebp)
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	48                   	dec    %eax
  8008d7:	8a 00                	mov    (%eax),%al
  8008d9:	3c 25                	cmp    $0x25,%al
  8008db:	75 f3                	jne    8008d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008dd:	90                   	nop
		}
	}
  8008de:	e9 47 fc ff ff       	jmp    80052a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f4:	83 c0 04             	add    $0x4,%eax
  8008f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 16 fc ff ff       	call   800522 <vprintfmt>
  80090c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090f:	90                   	nop
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800915:	8b 45 0c             	mov    0xc(%ebp),%eax
  800918:	8b 40 08             	mov    0x8(%eax),%eax
  80091b:	8d 50 01             	lea    0x1(%eax),%edx
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 40 04             	mov    0x4(%eax),%eax
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	73 12                	jae    800945 <sprintputch+0x33>
		*b->buf++ = ch;
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 48 01             	lea    0x1(%eax),%ecx
  80093b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093e:	89 0a                	mov    %ecx,(%edx)
  800940:	8b 55 08             	mov    0x8(%ebp),%edx
  800943:	88 10                	mov    %dl,(%eax)
}
  800945:	90                   	nop
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	8d 50 ff             	lea    -0x1(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	01 d0                	add    %edx,%eax
  80095f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800969:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80096d:	74 06                	je     800975 <vsnprintf+0x2d>
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	7f 07                	jg     80097c <vsnprintf+0x34>
		return -E_INVAL;
  800975:	b8 03 00 00 00       	mov    $0x3,%eax
  80097a:	eb 20                	jmp    80099c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80097c:	ff 75 14             	pushl  0x14(%ebp)
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	68 12 09 80 00       	push   $0x800912
  80098b:	e8 92 fb ff ff       	call   800522 <vprintfmt>
  800990:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800996:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800999:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	ff 75 08             	pushl  0x8(%ebp)
  8009ba:	e8 89 ff ff ff       	call   800948 <vsnprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d7:	eb 06                	jmp    8009df <strlen+0x15>
		n++;
  8009d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009dc:	ff 45 08             	incl   0x8(%ebp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	84 c0                	test   %al,%al
  8009e6:	75 f1                	jne    8009d9 <strlen+0xf>
		n++;
	return n;
  8009e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009fa:	eb 09                	jmp    800a05 <strnlen+0x18>
		n++;
  8009fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ff:	ff 45 08             	incl   0x8(%ebp)
  800a02:	ff 4d 0c             	decl   0xc(%ebp)
  800a05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a09:	74 09                	je     800a14 <strnlen+0x27>
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	84 c0                	test   %al,%al
  800a12:	75 e8                	jne    8009fc <strnlen+0xf>
		n++;
	return n;
  800a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a25:	90                   	nop
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a38:	8a 12                	mov    (%edx),%dl
  800a3a:	88 10                	mov    %dl,(%eax)
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	84 c0                	test   %al,%al
  800a40:	75 e4                	jne    800a26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5a:	eb 1f                	jmp    800a7b <strncpy+0x34>
		*dst++ = *src;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8d 50 01             	lea    0x1(%eax),%edx
  800a62:	89 55 08             	mov    %edx,0x8(%ebp)
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	8a 12                	mov    (%edx),%dl
  800a6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	74 03                	je     800a78 <strncpy+0x31>
			src++;
  800a75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a78:	ff 45 fc             	incl   -0x4(%ebp)
  800a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a81:	72 d9                	jb     800a5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a98:	74 30                	je     800aca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a9a:	eb 16                	jmp    800ab2 <strlcpy+0x2a>
			*dst++ = *src++;
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8d 50 01             	lea    0x1(%eax),%edx
  800aa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aae:	8a 12                	mov    (%edx),%dl
  800ab0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab2:	ff 4d 10             	decl   0x10(%ebp)
  800ab5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab9:	74 09                	je     800ac4 <strlcpy+0x3c>
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 d8                	jne    800a9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad0:	29 c2                	sub    %eax,%edx
  800ad2:	89 d0                	mov    %edx,%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad9:	eb 06                	jmp    800ae1 <strcmp+0xb>
		p++, q++;
  800adb:	ff 45 08             	incl   0x8(%ebp)
  800ade:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	84 c0                	test   %al,%al
  800ae8:	74 0e                	je     800af8 <strcmp+0x22>
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 10                	mov    (%eax),%dl
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	38 c2                	cmp    %al,%dl
  800af6:	74 e3                	je     800adb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	0f b6 d0             	movzbl %al,%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	29 c2                	sub    %eax,%edx
  800b0a:	89 d0                	mov    %edx,%eax
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b11:	eb 09                	jmp    800b1c <strncmp+0xe>
		n--, p++, q++;
  800b13:	ff 4d 10             	decl   0x10(%ebp)
  800b16:	ff 45 08             	incl   0x8(%ebp)
  800b19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b20:	74 17                	je     800b39 <strncmp+0x2b>
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	84 c0                	test   %al,%al
  800b29:	74 0e                	je     800b39 <strncmp+0x2b>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 10                	mov    (%eax),%dl
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	38 c2                	cmp    %al,%dl
  800b37:	74 da                	je     800b13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3d:	75 07                	jne    800b46 <strncmp+0x38>
		return 0;
  800b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b44:	eb 14                	jmp    800b5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d0             	movzbl %al,%edx
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f b6 c0             	movzbl %al,%eax
  800b56:	29 c2                	sub    %eax,%edx
  800b58:	89 d0                	mov    %edx,%eax
}
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 04             	sub    $0x4,%esp
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b68:	eb 12                	jmp    800b7c <strchr+0x20>
		if (*s == c)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b72:	75 05                	jne    800b79 <strchr+0x1d>
			return (char *) s;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	eb 11                	jmp    800b8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b79:	ff 45 08             	incl   0x8(%ebp)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	75 e5                	jne    800b6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b98:	eb 0d                	jmp    800ba7 <strfind+0x1b>
		if (*s == c)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba2:	74 0e                	je     800bb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba4:	ff 45 08             	incl   0x8(%ebp)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 ea                	jne    800b9a <strfind+0xe>
  800bb0:	eb 01                	jmp    800bb3 <strfind+0x27>
		if (*s == c)
			break;
  800bb2:	90                   	nop
	return (char *) s;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bca:	eb 0e                	jmp    800bda <memset+0x22>
		*p++ = c;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcf:	8d 50 01             	lea    0x1(%eax),%edx
  800bd2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bda:	ff 4d f8             	decl   -0x8(%ebp)
  800bdd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800be1:	79 e9                	jns    800bcc <memset+0x14>
		*p++ = c;

	return v;
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bfa:	eb 16                	jmp    800c12 <memcpy+0x2a>
		*d++ = *s++;
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8d 50 01             	lea    0x1(%eax),%edx
  800c02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c0e:	8a 12                	mov    (%edx),%dl
  800c10:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	75 dd                	jne    800bfc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c3c:	73 50                	jae    800c8e <memmove+0x6a>
  800c3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	01 d0                	add    %edx,%eax
  800c46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c49:	76 43                	jbe    800c8e <memmove+0x6a>
		s += n;
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c57:	eb 10                	jmp    800c69 <memmove+0x45>
			*--d = *--s;
  800c59:	ff 4d f8             	decl   -0x8(%ebp)
  800c5c:	ff 4d fc             	decl   -0x4(%ebp)
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	8a 10                	mov    (%eax),%dl
  800c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c67:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	75 e3                	jne    800c59 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c76:	eb 23                	jmp    800c9b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c94:	89 55 10             	mov    %edx,0x10(%ebp)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	75 dd                	jne    800c78 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cb2:	eb 2a                	jmp    800cde <memcmp+0x3e>
		if (*s1 != *s2)
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	8a 10                	mov    (%eax),%dl
  800cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	38 c2                	cmp    %al,%dl
  800cc0:	74 16                	je     800cd8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d0             	movzbl %al,%edx
  800cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 c0             	movzbl %al,%eax
  800cd2:	29 c2                	sub    %eax,%edx
  800cd4:	89 d0                	mov    %edx,%eax
  800cd6:	eb 18                	jmp    800cf0 <memcmp+0x50>
		s1++, s2++;
  800cd8:	ff 45 fc             	incl   -0x4(%ebp)
  800cdb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cde:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 c9                	jne    800cb4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d03:	eb 15                	jmp    800d1a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	0f b6 c0             	movzbl %al,%eax
  800d13:	39 c2                	cmp    %eax,%edx
  800d15:	74 0d                	je     800d24 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d20:	72 e3                	jb     800d05 <memfind+0x13>
  800d22:	eb 01                	jmp    800d25 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d24:	90                   	nop
	return (void *) s;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3e:	eb 03                	jmp    800d43 <strtol+0x19>
		s++;
  800d40:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 20                	cmp    $0x20,%al
  800d4a:	74 f4                	je     800d40 <strtol+0x16>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 09                	cmp    $0x9,%al
  800d53:	74 eb                	je     800d40 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 2b                	cmp    $0x2b,%al
  800d5c:	75 05                	jne    800d63 <strtol+0x39>
		s++;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	eb 13                	jmp    800d76 <strtol+0x4c>
	else if (*s == '-')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 2d                	cmp    $0x2d,%al
  800d6a:	75 0a                	jne    800d76 <strtol+0x4c>
		s++, neg = 1;
  800d6c:	ff 45 08             	incl   0x8(%ebp)
  800d6f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	74 06                	je     800d82 <strtol+0x58>
  800d7c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d80:	75 20                	jne    800da2 <strtol+0x78>
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	3c 30                	cmp    $0x30,%al
  800d89:	75 17                	jne    800da2 <strtol+0x78>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	40                   	inc    %eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 78                	cmp    $0x78,%al
  800d93:	75 0d                	jne    800da2 <strtol+0x78>
		s += 2, base = 16;
  800d95:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d99:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da0:	eb 28                	jmp    800dca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	75 15                	jne    800dbd <strtol+0x93>
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 30                	cmp    $0x30,%al
  800daf:	75 0c                	jne    800dbd <strtol+0x93>
		s++, base = 8;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dbb:	eb 0d                	jmp    800dca <strtol+0xa0>
	else if (base == 0)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	75 07                	jne    800dca <strtol+0xa0>
		base = 10;
  800dc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	3c 2f                	cmp    $0x2f,%al
  800dd1:	7e 19                	jle    800dec <strtol+0xc2>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 39                	cmp    $0x39,%al
  800dda:	7f 10                	jg     800dec <strtol+0xc2>
			dig = *s - '0';
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f be c0             	movsbl %al,%eax
  800de4:	83 e8 30             	sub    $0x30,%eax
  800de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dea:	eb 42                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3c 60                	cmp    $0x60,%al
  800df3:	7e 19                	jle    800e0e <strtol+0xe4>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 7a                	cmp    $0x7a,%al
  800dfc:	7f 10                	jg     800e0e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f be c0             	movsbl %al,%eax
  800e06:	83 e8 57             	sub    $0x57,%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e0c:	eb 20                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	3c 40                	cmp    $0x40,%al
  800e15:	7e 39                	jle    800e50 <strtol+0x126>
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 5a                	cmp    $0x5a,%al
  800e1e:	7f 30                	jg     800e50 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f be c0             	movsbl %al,%eax
  800e28:	83 e8 37             	sub    $0x37,%eax
  800e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e34:	7d 19                	jge    800e4f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e40:	89 c2                	mov    %eax,%edx
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e4a:	e9 7b ff ff ff       	jmp    800dca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e4f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 08                	je     800e5e <strtol+0x134>
		*endptr = (char *) s;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e62:	74 07                	je     800e6b <strtol+0x141>
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	f7 d8                	neg    %eax
  800e69:	eb 03                	jmp    800e6e <strtol+0x144>
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <ltostr>:

void
ltostr(long value, char *str)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	79 13                	jns    800e9d <ltostr+0x2d>
	{
		neg = 1;
  800e8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e97:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e9a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ea5:	99                   	cltd   
  800ea6:	f7 f9                	idiv   %ecx
  800ea8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb4:	89 c2                	mov    %eax,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ebe:	83 c2 30             	add    $0x30,%edx
  800ec1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ecb:	f7 e9                	imul   %ecx
  800ecd:	c1 fa 02             	sar    $0x2,%edx
  800ed0:	89 c8                	mov    %ecx,%eax
  800ed2:	c1 f8 1f             	sar    $0x1f,%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
  800ed9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee4:	f7 e9                	imul   %ecx
  800ee6:	c1 fa 02             	sar    $0x2,%edx
  800ee9:	89 c8                	mov    %ecx,%eax
  800eeb:	c1 f8 1f             	sar    $0x1f,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
  800ef2:	c1 e0 02             	shl    $0x2,%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	29 c1                	sub    %eax,%ecx
  800efb:	89 ca                	mov    %ecx,%edx
  800efd:	85 d2                	test   %edx,%edx
  800eff:	75 9c                	jne    800e9d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0b:	48                   	dec    %eax
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f13:	74 3d                	je     800f52 <ltostr+0xe2>
		start = 1 ;
  800f15:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f1c:	eb 34                	jmp    800f52 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	01 d0                	add    %edx,%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	01 c2                	add    %eax,%edx
  800f33:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	01 c8                	add    %ecx,%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	01 c2                	add    %eax,%edx
  800f47:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f4a:	88 02                	mov    %al,(%edx)
		start++ ;
  800f4c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f58:	7c c4                	jl     800f1e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f5a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 54 fa ff ff       	call   8009ca <strlen>
  800f76:	83 c4 04             	add    $0x4,%esp
  800f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f7c:	ff 75 0c             	pushl  0xc(%ebp)
  800f7f:	e8 46 fa ff ff       	call   8009ca <strlen>
  800f84:	83 c4 04             	add    $0x4,%esp
  800f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f98:	eb 17                	jmp    800fb1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	01 c2                	add    %eax,%edx
  800fa2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	01 c8                	add    %ecx,%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb7:	7c e1                	jl     800f9a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc7:	eb 1f                	jmp    800fe8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 c2                	add    %eax,%edx
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 c8                	add    %ecx,%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe5:	ff 45 f8             	incl   -0x8(%ebp)
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fee:	7c d9                	jl     800fc9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	c6 00 00             	movb   $0x0,(%eax)
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	8b 00                	mov    (%eax),%eax
  80100f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801016:	8b 45 10             	mov    0x10(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801021:	eb 0c                	jmp    80102f <strsplit+0x31>
			*string++ = 0;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 08             	mov    %edx,0x8(%ebp)
  80102c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	74 18                	je     801050 <strsplit+0x52>
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	50                   	push   %eax
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	e8 13 fb ff ff       	call   800b5c <strchr>
  801049:	83 c4 08             	add    $0x8,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 d3                	jne    801023 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	84 c0                	test   %al,%al
  801057:	74 5a                	je     8010b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	8b 00                	mov    (%eax),%eax
  80105e:	83 f8 0f             	cmp    $0xf,%eax
  801061:	75 07                	jne    80106a <strsplit+0x6c>
		{
			return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	eb 66                	jmp    8010d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80106a:	8b 45 14             	mov    0x14(%ebp),%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	8d 48 01             	lea    0x1(%eax),%ecx
  801072:	8b 55 14             	mov    0x14(%ebp),%edx
  801075:	89 0a                	mov    %ecx,(%edx)
  801077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 c2                	add    %eax,%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801088:	eb 03                	jmp    80108d <strsplit+0x8f>
			string++;
  80108a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	74 8b                	je     801021 <strsplit+0x23>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	0f be c0             	movsbl %al,%eax
  80109e:	50                   	push   %eax
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	e8 b5 fa ff ff       	call   800b5c <strchr>
  8010a7:	83 c4 08             	add    $0x8,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	74 dc                	je     80108a <strsplit+0x8c>
			string++;
	}
  8010ae:	e9 6e ff ff ff       	jmp    801021 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 00                	mov    (%eax),%eax
  8010b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8010d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 1f                	je     801100 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8010e1:	e8 1d 00 00 00       	call   801103 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	68 90 36 80 00       	push   $0x803690
  8010ee:	e8 55 f2 ff ff       	call   800348 <cprintf>
  8010f3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8010f6:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8010fd:	00 00 00 
	}
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801109:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801110:	00 00 00 
  801113:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80111a:	00 00 00 
  80111d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801124:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801127:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80112e:	00 00 00 
  801131:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801138:	00 00 00 
  80113b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801142:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801145:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80114c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801154:	2d 00 10 00 00       	sub    $0x1000,%eax
  801159:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80115e:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801165:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801168:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80116f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801172:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801177:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80117a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80117d:	ba 00 00 00 00       	mov    $0x0,%edx
  801182:	f7 75 f0             	divl   -0x10(%ebp)
  801185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801188:	29 d0                	sub    %edx,%eax
  80118a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  80118d:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801194:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119c:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	6a 06                	push   $0x6
  8011a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8011a9:	50                   	push   %eax
  8011aa:	e8 d4 05 00 00       	call   801783 <sys_allocate_chunk>
  8011af:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011b2:	a1 20 41 80 00       	mov    0x804120,%eax
  8011b7:	83 ec 0c             	sub    $0xc,%esp
  8011ba:	50                   	push   %eax
  8011bb:	e8 49 0c 00 00       	call   801e09 <initialize_MemBlocksList>
  8011c0:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8011c3:	a1 48 41 80 00       	mov    0x804148,%eax
  8011c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8011cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011cf:	75 14                	jne    8011e5 <initialize_dyn_block_system+0xe2>
  8011d1:	83 ec 04             	sub    $0x4,%esp
  8011d4:	68 b5 36 80 00       	push   $0x8036b5
  8011d9:	6a 39                	push   $0x39
  8011db:	68 d3 36 80 00       	push   $0x8036d3
  8011e0:	e8 d2 1b 00 00       	call   802db7 <_panic>
  8011e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e8:	8b 00                	mov    (%eax),%eax
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	74 10                	je     8011fe <initialize_dyn_block_system+0xfb>
  8011ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011f1:	8b 00                	mov    (%eax),%eax
  8011f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011f6:	8b 52 04             	mov    0x4(%edx),%edx
  8011f9:	89 50 04             	mov    %edx,0x4(%eax)
  8011fc:	eb 0b                	jmp    801209 <initialize_dyn_block_system+0x106>
  8011fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801201:	8b 40 04             	mov    0x4(%eax),%eax
  801204:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120c:	8b 40 04             	mov    0x4(%eax),%eax
  80120f:	85 c0                	test   %eax,%eax
  801211:	74 0f                	je     801222 <initialize_dyn_block_system+0x11f>
  801213:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801216:	8b 40 04             	mov    0x4(%eax),%eax
  801219:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80121c:	8b 12                	mov    (%edx),%edx
  80121e:	89 10                	mov    %edx,(%eax)
  801220:	eb 0a                	jmp    80122c <initialize_dyn_block_system+0x129>
  801222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801225:	8b 00                	mov    (%eax),%eax
  801227:	a3 48 41 80 00       	mov    %eax,0x804148
  80122c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801235:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801238:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80123f:	a1 54 41 80 00       	mov    0x804154,%eax
  801244:	48                   	dec    %eax
  801245:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80124a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80124d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801254:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801257:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  80125e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801262:	75 14                	jne    801278 <initialize_dyn_block_system+0x175>
  801264:	83 ec 04             	sub    $0x4,%esp
  801267:	68 e0 36 80 00       	push   $0x8036e0
  80126c:	6a 3f                	push   $0x3f
  80126e:	68 d3 36 80 00       	push   $0x8036d3
  801273:	e8 3f 1b 00 00       	call   802db7 <_panic>
  801278:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80127e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801281:	89 10                	mov    %edx,(%eax)
  801283:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801286:	8b 00                	mov    (%eax),%eax
  801288:	85 c0                	test   %eax,%eax
  80128a:	74 0d                	je     801299 <initialize_dyn_block_system+0x196>
  80128c:	a1 38 41 80 00       	mov    0x804138,%eax
  801291:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801294:	89 50 04             	mov    %edx,0x4(%eax)
  801297:	eb 08                	jmp    8012a1 <initialize_dyn_block_system+0x19e>
  801299:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80129c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8012a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8012b8:	40                   	inc    %eax
  8012b9:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8012be:	90                   	nop
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012c7:	e8 06 fe ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012d0:	75 07                	jne    8012d9 <malloc+0x18>
  8012d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d7:	eb 7d                	jmp    801356 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8012d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8012e0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8012e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ed:	01 d0                	add    %edx,%eax
  8012ef:	48                   	dec    %eax
  8012f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012fb:	f7 75 f0             	divl   -0x10(%ebp)
  8012fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801301:	29 d0                	sub    %edx,%eax
  801303:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801306:	e8 46 08 00 00       	call   801b51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80130b:	83 f8 01             	cmp    $0x1,%eax
  80130e:	75 07                	jne    801317 <malloc+0x56>
  801310:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801317:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80131b:	75 34                	jne    801351 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80131d:	83 ec 0c             	sub    $0xc,%esp
  801320:	ff 75 e8             	pushl  -0x18(%ebp)
  801323:	e8 73 0e 00 00       	call   80219b <alloc_block_FF>
  801328:	83 c4 10             	add    $0x10,%esp
  80132b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80132e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801332:	74 16                	je     80134a <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801334:	83 ec 0c             	sub    $0xc,%esp
  801337:	ff 75 e4             	pushl  -0x1c(%ebp)
  80133a:	e8 ff 0b 00 00       	call   801f3e <insert_sorted_allocList>
  80133f:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801345:	8b 40 08             	mov    0x8(%eax),%eax
  801348:	eb 0c                	jmp    801356 <malloc+0x95>
	             }
	             else
	             	return NULL;
  80134a:	b8 00 00 00 00       	mov    $0x0,%eax
  80134f:	eb 05                	jmp    801356 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801351:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801372:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801375:	83 ec 08             	sub    $0x8,%esp
  801378:	ff 75 f4             	pushl  -0xc(%ebp)
  80137b:	68 40 40 80 00       	push   $0x804040
  801380:	e8 61 0b 00 00       	call   801ee6 <find_block>
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80138b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80138f:	0f 84 a5 00 00 00    	je     80143a <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801395:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801398:	8b 40 0c             	mov    0xc(%eax),%eax
  80139b:	83 ec 08             	sub    $0x8,%esp
  80139e:	50                   	push   %eax
  80139f:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a2:	e8 a4 03 00 00       	call   80174b <sys_free_user_mem>
  8013a7:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8013aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013ae:	75 17                	jne    8013c7 <free+0x6f>
  8013b0:	83 ec 04             	sub    $0x4,%esp
  8013b3:	68 b5 36 80 00       	push   $0x8036b5
  8013b8:	68 87 00 00 00       	push   $0x87
  8013bd:	68 d3 36 80 00       	push   $0x8036d3
  8013c2:	e8 f0 19 00 00       	call   802db7 <_panic>
  8013c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ca:	8b 00                	mov    (%eax),%eax
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	74 10                	je     8013e0 <free+0x88>
  8013d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d8:	8b 52 04             	mov    0x4(%edx),%edx
  8013db:	89 50 04             	mov    %edx,0x4(%eax)
  8013de:	eb 0b                	jmp    8013eb <free+0x93>
  8013e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e3:	8b 40 04             	mov    0x4(%eax),%eax
  8013e6:	a3 44 40 80 00       	mov    %eax,0x804044
  8013eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ee:	8b 40 04             	mov    0x4(%eax),%eax
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	74 0f                	je     801404 <free+0xac>
  8013f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013f8:	8b 40 04             	mov    0x4(%eax),%eax
  8013fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013fe:	8b 12                	mov    (%edx),%edx
  801400:	89 10                	mov    %edx,(%eax)
  801402:	eb 0a                	jmp    80140e <free+0xb6>
  801404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801407:	8b 00                	mov    (%eax),%eax
  801409:	a3 40 40 80 00       	mov    %eax,0x804040
  80140e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80141a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801421:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801426:	48                   	dec    %eax
  801427:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80142c:	83 ec 0c             	sub    $0xc,%esp
  80142f:	ff 75 ec             	pushl  -0x14(%ebp)
  801432:	e8 37 12 00 00       	call   80266e <insert_sorted_with_merge_freeList>
  801437:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80143a:	90                   	nop
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 38             	sub    $0x38,%esp
  801443:	8b 45 10             	mov    0x10(%ebp),%eax
  801446:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801449:	e8 84 fc ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  80144e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801452:	75 07                	jne    80145b <smalloc+0x1e>
  801454:	b8 00 00 00 00       	mov    $0x0,%eax
  801459:	eb 7e                	jmp    8014d9 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80145b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801462:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146f:	01 d0                	add    %edx,%eax
  801471:	48                   	dec    %eax
  801472:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801475:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801478:	ba 00 00 00 00       	mov    $0x0,%edx
  80147d:	f7 75 f0             	divl   -0x10(%ebp)
  801480:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801483:	29 d0                	sub    %edx,%eax
  801485:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801488:	e8 c4 06 00 00       	call   801b51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80148d:	83 f8 01             	cmp    $0x1,%eax
  801490:	75 42                	jne    8014d4 <smalloc+0x97>

		  va = malloc(newsize) ;
  801492:	83 ec 0c             	sub    $0xc,%esp
  801495:	ff 75 e8             	pushl  -0x18(%ebp)
  801498:	e8 24 fe ff ff       	call   8012c1 <malloc>
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8014a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014a7:	74 24                	je     8014cd <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8014a9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 e8             	pushl  -0x18(%ebp)
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 1a 04 00 00       	call   8018d6 <sys_createSharedObject>
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8014c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014c6:	78 0c                	js     8014d4 <smalloc+0x97>
					  return va ;
  8014c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014cb:	eb 0c                	jmp    8014d9 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8014cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d2:	eb 05                	jmp    8014d9 <smalloc+0x9c>
	  }
		  return NULL ;
  8014d4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014e1:	e8 ec fb ff ff       	call   8010d2 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8014e6:	83 ec 08             	sub    $0x8,%esp
  8014e9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ec:	ff 75 08             	pushl  0x8(%ebp)
  8014ef:	e8 0c 04 00 00       	call   801900 <sys_getSizeOfSharedObject>
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8014fa:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8014fe:	75 07                	jne    801507 <sget+0x2c>
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
  801505:	eb 75                	jmp    80157c <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801507:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80150e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801514:	01 d0                	add    %edx,%eax
  801516:	48                   	dec    %eax
  801517:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80151a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151d:	ba 00 00 00 00       	mov    $0x0,%edx
  801522:	f7 75 f0             	divl   -0x10(%ebp)
  801525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801528:	29 d0                	sub    %edx,%eax
  80152a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80152d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801534:	e8 18 06 00 00       	call   801b51 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801539:	83 f8 01             	cmp    $0x1,%eax
  80153c:	75 39                	jne    801577 <sget+0x9c>

		  va = malloc(newsize) ;
  80153e:	83 ec 0c             	sub    $0xc,%esp
  801541:	ff 75 e8             	pushl  -0x18(%ebp)
  801544:	e8 78 fd ff ff       	call   8012c1 <malloc>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  80154f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801553:	74 22                	je     801577 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801555:	83 ec 04             	sub    $0x4,%esp
  801558:	ff 75 e0             	pushl  -0x20(%ebp)
  80155b:	ff 75 0c             	pushl  0xc(%ebp)
  80155e:	ff 75 08             	pushl  0x8(%ebp)
  801561:	e8 b7 03 00 00       	call   80191d <sys_getSharedObject>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80156c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801570:	78 05                	js     801577 <sget+0x9c>
					  return va;
  801572:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801575:	eb 05                	jmp    80157c <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801584:	e8 49 fb ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	68 04 37 80 00       	push   $0x803704
  801591:	68 1e 01 00 00       	push   $0x11e
  801596:	68 d3 36 80 00       	push   $0x8036d3
  80159b:	e8 17 18 00 00       	call   802db7 <_panic>

008015a0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015a6:	83 ec 04             	sub    $0x4,%esp
  8015a9:	68 2c 37 80 00       	push   $0x80372c
  8015ae:	68 32 01 00 00       	push   $0x132
  8015b3:	68 d3 36 80 00       	push   $0x8036d3
  8015b8:	e8 fa 17 00 00       	call   802db7 <_panic>

008015bd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015c3:	83 ec 04             	sub    $0x4,%esp
  8015c6:	68 50 37 80 00       	push   $0x803750
  8015cb:	68 3d 01 00 00       	push   $0x13d
  8015d0:	68 d3 36 80 00       	push   $0x8036d3
  8015d5:	e8 dd 17 00 00       	call   802db7 <_panic>

008015da <shrink>:

}
void shrink(uint32 newSize)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e0:	83 ec 04             	sub    $0x4,%esp
  8015e3:	68 50 37 80 00       	push   $0x803750
  8015e8:	68 42 01 00 00       	push   $0x142
  8015ed:	68 d3 36 80 00       	push   $0x8036d3
  8015f2:	e8 c0 17 00 00       	call   802db7 <_panic>

008015f7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	68 50 37 80 00       	push   $0x803750
  801605:	68 47 01 00 00       	push   $0x147
  80160a:	68 d3 36 80 00       	push   $0x8036d3
  80160f:	e8 a3 17 00 00       	call   802db7 <_panic>

00801614 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	57                   	push   %edi
  801618:	56                   	push   %esi
  801619:	53                   	push   %ebx
  80161a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801626:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801629:	8b 7d 18             	mov    0x18(%ebp),%edi
  80162c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80162f:	cd 30                	int    $0x30
  801631:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	5b                   	pop    %ebx
  80163b:	5e                   	pop    %esi
  80163c:	5f                   	pop    %edi
  80163d:	5d                   	pop    %ebp
  80163e:	c3                   	ret    

0080163f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	8b 45 10             	mov    0x10(%ebp),%eax
  801648:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80164b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	52                   	push   %edx
  801657:	ff 75 0c             	pushl  0xc(%ebp)
  80165a:	50                   	push   %eax
  80165b:	6a 00                	push   $0x0
  80165d:	e8 b2 ff ff ff       	call   801614 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	90                   	nop
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_cgetc>:

int
sys_cgetc(void)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 01                	push   $0x1
  801677:	e8 98 ff ff ff       	call   801614 <syscall>
  80167c:	83 c4 18             	add    $0x18,%esp
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801684:	8b 55 0c             	mov    0xc(%ebp),%edx
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	52                   	push   %edx
  801691:	50                   	push   %eax
  801692:	6a 05                	push   $0x5
  801694:	e8 7b ff ff ff       	call   801614 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	56                   	push   %esi
  8016a2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016a3:	8b 75 18             	mov    0x18(%ebp),%esi
  8016a6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	51                   	push   %ecx
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	6a 06                	push   $0x6
  8016b9:	e8 56 ff ff ff       	call   801614 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c4:	5b                   	pop    %ebx
  8016c5:	5e                   	pop    %esi
  8016c6:	5d                   	pop    %ebp
  8016c7:	c3                   	ret    

008016c8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	52                   	push   %edx
  8016d8:	50                   	push   %eax
  8016d9:	6a 07                	push   $0x7
  8016db:	e8 34 ff ff ff       	call   801614 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	ff 75 0c             	pushl  0xc(%ebp)
  8016f1:	ff 75 08             	pushl  0x8(%ebp)
  8016f4:	6a 08                	push   $0x8
  8016f6:	e8 19 ff ff ff       	call   801614 <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 09                	push   $0x9
  80170f:	e8 00 ff ff ff       	call   801614 <syscall>
  801714:	83 c4 18             	add    $0x18,%esp
}
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 0a                	push   $0xa
  801728:	e8 e7 fe ff ff       	call   801614 <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 0b                	push   $0xb
  801741:	e8 ce fe ff ff       	call   801614 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	ff 75 08             	pushl  0x8(%ebp)
  80175a:	6a 0f                	push   $0xf
  80175c:	e8 b3 fe ff ff       	call   801614 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
	return;
  801764:	90                   	nop
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	6a 10                	push   $0x10
  801778:	e8 97 fe ff ff       	call   801614 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
	return ;
  801780:	90                   	nop
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	ff 75 10             	pushl  0x10(%ebp)
  80178d:	ff 75 0c             	pushl  0xc(%ebp)
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	6a 11                	push   $0x11
  801795:	e8 7a fe ff ff       	call   801614 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
	return ;
  80179d:	90                   	nop
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 0c                	push   $0xc
  8017af:	e8 60 fe ff ff       	call   801614 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	ff 75 08             	pushl  0x8(%ebp)
  8017c7:	6a 0d                	push   $0xd
  8017c9:	e8 46 fe ff ff       	call   801614 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 0e                	push   $0xe
  8017e2:	e8 2d fe ff ff       	call   801614 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	90                   	nop
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 13                	push   $0x13
  8017fc:	e8 13 fe ff ff       	call   801614 <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
}
  801804:	90                   	nop
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 14                	push   $0x14
  801816:	e8 f9 fd ff ff       	call   801614 <syscall>
  80181b:	83 c4 18             	add    $0x18,%esp
}
  80181e:	90                   	nop
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sys_cputc>:


void
sys_cputc(const char c)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 04             	sub    $0x4,%esp
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80182d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	50                   	push   %eax
  80183a:	6a 15                	push   $0x15
  80183c:	e8 d3 fd ff ff       	call   801614 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	90                   	nop
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 16                	push   $0x16
  801856:	e8 b9 fd ff ff       	call   801614 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	90                   	nop
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801864:	8b 45 08             	mov    0x8(%ebp),%eax
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	50                   	push   %eax
  801871:	6a 17                	push   $0x17
  801873:	e8 9c fd ff ff       	call   801614 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801880:	8b 55 0c             	mov    0xc(%ebp),%edx
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	52                   	push   %edx
  80188d:	50                   	push   %eax
  80188e:	6a 1a                	push   $0x1a
  801890:	e8 7f fd ff ff       	call   801614 <syscall>
  801895:	83 c4 18             	add    $0x18,%esp
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    

0080189a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80189d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	52                   	push   %edx
  8018aa:	50                   	push   %eax
  8018ab:	6a 18                	push   $0x18
  8018ad:	e8 62 fd ff ff       	call   801614 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	90                   	nop
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	52                   	push   %edx
  8018c8:	50                   	push   %eax
  8018c9:	6a 19                	push   $0x19
  8018cb:	e8 44 fd ff ff       	call   801614 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
}
  8018d3:	90                   	nop
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	83 ec 04             	sub    $0x4,%esp
  8018dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018df:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	51                   	push   %ecx
  8018ef:	52                   	push   %edx
  8018f0:	ff 75 0c             	pushl  0xc(%ebp)
  8018f3:	50                   	push   %eax
  8018f4:	6a 1b                	push   $0x1b
  8018f6:	e8 19 fd ff ff       	call   801614 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 1c                	push   $0x1c
  801913:	e8 fc fc ff ff       	call   801614 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801920:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801923:	8b 55 0c             	mov    0xc(%ebp),%edx
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	51                   	push   %ecx
  80192e:	52                   	push   %edx
  80192f:	50                   	push   %eax
  801930:	6a 1d                	push   $0x1d
  801932:	e8 dd fc ff ff       	call   801614 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80193f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	52                   	push   %edx
  80194c:	50                   	push   %eax
  80194d:	6a 1e                	push   $0x1e
  80194f:	e8 c0 fc ff ff       	call   801614 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 1f                	push   $0x1f
  801968:	e8 a7 fc ff ff       	call   801614 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	6a 00                	push   $0x0
  80197a:	ff 75 14             	pushl  0x14(%ebp)
  80197d:	ff 75 10             	pushl  0x10(%ebp)
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	50                   	push   %eax
  801984:	6a 20                	push   $0x20
  801986:	e8 89 fc ff ff       	call   801614 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	50                   	push   %eax
  80199f:	6a 21                	push   $0x21
  8019a1:	e8 6e fc ff ff       	call   801614 <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	50                   	push   %eax
  8019bb:	6a 22                	push   $0x22
  8019bd:	e8 52 fc ff ff       	call   801614 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 02                	push   $0x2
  8019d6:	e8 39 fc ff ff       	call   801614 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 03                	push   $0x3
  8019ef:	e8 20 fc ff ff       	call   801614 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 04                	push   $0x4
  801a08:	e8 07 fc ff ff       	call   801614 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_exit_env>:


void sys_exit_env(void)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 23                	push   $0x23
  801a21:	e8 ee fb ff ff       	call   801614 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a32:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a35:	8d 50 04             	lea    0x4(%eax),%edx
  801a38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	52                   	push   %edx
  801a42:	50                   	push   %eax
  801a43:	6a 24                	push   $0x24
  801a45:	e8 ca fb ff ff       	call   801614 <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
	return result;
  801a4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a53:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a56:	89 01                	mov    %eax,(%ecx)
  801a58:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	c9                   	leave  
  801a5f:	c2 04 00             	ret    $0x4

00801a62 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	ff 75 10             	pushl  0x10(%ebp)
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	ff 75 08             	pushl  0x8(%ebp)
  801a72:	6a 12                	push   $0x12
  801a74:	e8 9b fb ff ff       	call   801614 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7c:	90                   	nop
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_rcr2>:
uint32 sys_rcr2()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 25                	push   $0x25
  801a8e:	e8 81 fb ff ff       	call   801614 <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 04             	sub    $0x4,%esp
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801aa4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	50                   	push   %eax
  801ab1:	6a 26                	push   $0x26
  801ab3:	e8 5c fb ff ff       	call   801614 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
	return ;
  801abb:	90                   	nop
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <rsttst>:
void rsttst()
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 28                	push   $0x28
  801acd:	e8 42 fb ff ff       	call   801614 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad5:	90                   	nop
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ae4:	8b 55 18             	mov    0x18(%ebp),%edx
  801ae7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aeb:	52                   	push   %edx
  801aec:	50                   	push   %eax
  801aed:	ff 75 10             	pushl  0x10(%ebp)
  801af0:	ff 75 0c             	pushl  0xc(%ebp)
  801af3:	ff 75 08             	pushl  0x8(%ebp)
  801af6:	6a 27                	push   $0x27
  801af8:	e8 17 fb ff ff       	call   801614 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
	return ;
  801b00:	90                   	nop
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <chktst>:
void chktst(uint32 n)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	ff 75 08             	pushl  0x8(%ebp)
  801b11:	6a 29                	push   $0x29
  801b13:	e8 fc fa ff ff       	call   801614 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <inctst>:

void inctst()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 2a                	push   $0x2a
  801b2d:	e8 e2 fa ff ff       	call   801614 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return ;
  801b35:	90                   	nop
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <gettst>:
uint32 gettst()
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 2b                	push   $0x2b
  801b47:	e8 c8 fa ff ff       	call   801614 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 2c                	push   $0x2c
  801b63:	e8 ac fa ff ff       	call   801614 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
  801b6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b6e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b72:	75 07                	jne    801b7b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b74:	b8 01 00 00 00       	mov    $0x1,%eax
  801b79:	eb 05                	jmp    801b80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 2c                	push   $0x2c
  801b94:	e8 7b fa ff ff       	call   801614 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
  801b9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b9f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ba3:	75 07                	jne    801bac <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ba5:	b8 01 00 00 00       	mov    $0x1,%eax
  801baa:	eb 05                	jmp    801bb1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 2c                	push   $0x2c
  801bc5:	e8 4a fa ff ff       	call   801614 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
  801bcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bd0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bd4:	75 07                	jne    801bdd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdb:	eb 05                	jmp    801be2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 2c                	push   $0x2c
  801bf6:	e8 19 fa ff ff       	call   801614 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
  801bfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c01:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c05:	75 07                	jne    801c0e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c07:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0c:	eb 05                	jmp    801c13 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	ff 75 08             	pushl  0x8(%ebp)
  801c23:	6a 2d                	push   $0x2d
  801c25:	e8 ea f9 ff ff       	call   801614 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2d:	90                   	nop
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	53                   	push   %ebx
  801c43:	51                   	push   %ecx
  801c44:	52                   	push   %edx
  801c45:	50                   	push   %eax
  801c46:	6a 2e                	push   $0x2e
  801c48:	e8 c7 f9 ff ff       	call   801614 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	52                   	push   %edx
  801c65:	50                   	push   %eax
  801c66:	6a 2f                	push   $0x2f
  801c68:	e8 a7 f9 ff ff       	call   801614 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c78:	83 ec 0c             	sub    $0xc,%esp
  801c7b:	68 60 37 80 00       	push   $0x803760
  801c80:	e8 c3 e6 ff ff       	call   800348 <cprintf>
  801c85:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c8f:	83 ec 0c             	sub    $0xc,%esp
  801c92:	68 8c 37 80 00       	push   $0x80378c
  801c97:	e8 ac e6 ff ff       	call   800348 <cprintf>
  801c9c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c9f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ca3:	a1 38 41 80 00       	mov    0x804138,%eax
  801ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cab:	eb 56                	jmp    801d03 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cb1:	74 1c                	je     801ccf <print_mem_block_lists+0x5d>
  801cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb6:	8b 50 08             	mov    0x8(%eax),%edx
  801cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbc:	8b 48 08             	mov    0x8(%eax),%ecx
  801cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc5:	01 c8                	add    %ecx,%eax
  801cc7:	39 c2                	cmp    %eax,%edx
  801cc9:	73 04                	jae    801ccf <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ccb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd2:	8b 50 08             	mov    0x8(%eax),%edx
  801cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd8:	8b 40 0c             	mov    0xc(%eax),%eax
  801cdb:	01 c2                	add    %eax,%edx
  801cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce0:	8b 40 08             	mov    0x8(%eax),%eax
  801ce3:	83 ec 04             	sub    $0x4,%esp
  801ce6:	52                   	push   %edx
  801ce7:	50                   	push   %eax
  801ce8:	68 a1 37 80 00       	push   $0x8037a1
  801ced:	e8 56 e6 ff ff       	call   800348 <cprintf>
  801cf2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cfb:	a1 40 41 80 00       	mov    0x804140,%eax
  801d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d07:	74 07                	je     801d10 <print_mem_block_lists+0x9e>
  801d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0c:	8b 00                	mov    (%eax),%eax
  801d0e:	eb 05                	jmp    801d15 <print_mem_block_lists+0xa3>
  801d10:	b8 00 00 00 00       	mov    $0x0,%eax
  801d15:	a3 40 41 80 00       	mov    %eax,0x804140
  801d1a:	a1 40 41 80 00       	mov    0x804140,%eax
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	75 8a                	jne    801cad <print_mem_block_lists+0x3b>
  801d23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d27:	75 84                	jne    801cad <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d29:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d2d:	75 10                	jne    801d3f <print_mem_block_lists+0xcd>
  801d2f:	83 ec 0c             	sub    $0xc,%esp
  801d32:	68 b0 37 80 00       	push   $0x8037b0
  801d37:	e8 0c e6 ff ff       	call   800348 <cprintf>
  801d3c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d3f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d46:	83 ec 0c             	sub    $0xc,%esp
  801d49:	68 d4 37 80 00       	push   $0x8037d4
  801d4e:	e8 f5 e5 ff ff       	call   800348 <cprintf>
  801d53:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d56:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d5a:	a1 40 40 80 00       	mov    0x804040,%eax
  801d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d62:	eb 56                	jmp    801dba <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d68:	74 1c                	je     801d86 <print_mem_block_lists+0x114>
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	8b 50 08             	mov    0x8(%eax),%edx
  801d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d73:	8b 48 08             	mov    0x8(%eax),%ecx
  801d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d79:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7c:	01 c8                	add    %ecx,%eax
  801d7e:	39 c2                	cmp    %eax,%edx
  801d80:	73 04                	jae    801d86 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d82:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d89:	8b 50 08             	mov    0x8(%eax),%edx
  801d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d92:	01 c2                	add    %eax,%edx
  801d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d97:	8b 40 08             	mov    0x8(%eax),%eax
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	52                   	push   %edx
  801d9e:	50                   	push   %eax
  801d9f:	68 a1 37 80 00       	push   $0x8037a1
  801da4:	e8 9f e5 ff ff       	call   800348 <cprintf>
  801da9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801db2:	a1 48 40 80 00       	mov    0x804048,%eax
  801db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dbe:	74 07                	je     801dc7 <print_mem_block_lists+0x155>
  801dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc3:	8b 00                	mov    (%eax),%eax
  801dc5:	eb 05                	jmp    801dcc <print_mem_block_lists+0x15a>
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcc:	a3 48 40 80 00       	mov    %eax,0x804048
  801dd1:	a1 48 40 80 00       	mov    0x804048,%eax
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	75 8a                	jne    801d64 <print_mem_block_lists+0xf2>
  801dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dde:	75 84                	jne    801d64 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801de0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801de4:	75 10                	jne    801df6 <print_mem_block_lists+0x184>
  801de6:	83 ec 0c             	sub    $0xc,%esp
  801de9:	68 ec 37 80 00       	push   $0x8037ec
  801dee:	e8 55 e5 ff ff       	call   800348 <cprintf>
  801df3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801df6:	83 ec 0c             	sub    $0xc,%esp
  801df9:	68 60 37 80 00       	push   $0x803760
  801dfe:	e8 45 e5 ff ff       	call   800348 <cprintf>
  801e03:	83 c4 10             	add    $0x10,%esp

}
  801e06:	90                   	nop
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  801e0f:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e16:	00 00 00 
  801e19:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e20:	00 00 00 
  801e23:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e2a:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  801e2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e34:	e9 9e 00 00 00       	jmp    801ed7 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  801e39:	a1 50 40 80 00       	mov    0x804050,%eax
  801e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e41:	c1 e2 04             	shl    $0x4,%edx
  801e44:	01 d0                	add    %edx,%eax
  801e46:	85 c0                	test   %eax,%eax
  801e48:	75 14                	jne    801e5e <initialize_MemBlocksList+0x55>
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	68 14 38 80 00       	push   $0x803814
  801e52:	6a 47                	push   $0x47
  801e54:	68 37 38 80 00       	push   $0x803837
  801e59:	e8 59 0f 00 00       	call   802db7 <_panic>
  801e5e:	a1 50 40 80 00       	mov    0x804050,%eax
  801e63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e66:	c1 e2 04             	shl    $0x4,%edx
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e71:	89 10                	mov    %edx,(%eax)
  801e73:	8b 00                	mov    (%eax),%eax
  801e75:	85 c0                	test   %eax,%eax
  801e77:	74 18                	je     801e91 <initialize_MemBlocksList+0x88>
  801e79:	a1 48 41 80 00       	mov    0x804148,%eax
  801e7e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e84:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e87:	c1 e1 04             	shl    $0x4,%ecx
  801e8a:	01 ca                	add    %ecx,%edx
  801e8c:	89 50 04             	mov    %edx,0x4(%eax)
  801e8f:	eb 12                	jmp    801ea3 <initialize_MemBlocksList+0x9a>
  801e91:	a1 50 40 80 00       	mov    0x804050,%eax
  801e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e99:	c1 e2 04             	shl    $0x4,%edx
  801e9c:	01 d0                	add    %edx,%eax
  801e9e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ea3:	a1 50 40 80 00       	mov    0x804050,%eax
  801ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eab:	c1 e2 04             	shl    $0x4,%edx
  801eae:	01 d0                	add    %edx,%eax
  801eb0:	a3 48 41 80 00       	mov    %eax,0x804148
  801eb5:	a1 50 40 80 00       	mov    0x804050,%eax
  801eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ebd:	c1 e2 04             	shl    $0x4,%edx
  801ec0:	01 d0                	add    %edx,%eax
  801ec2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ec9:	a1 54 41 80 00       	mov    0x804154,%eax
  801ece:	40                   	inc    %eax
  801ecf:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  801ed4:	ff 45 f4             	incl   -0xc(%ebp)
  801ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eda:	3b 45 08             	cmp    0x8(%ebp),%eax
  801edd:	0f 82 56 ff ff ff    	jb     801e39 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  801ee3:	90                   	nop
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  801eec:	8b 45 08             	mov    0x8(%ebp),%eax
  801eef:	8b 00                	mov    (%eax),%eax
  801ef1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ef4:	eb 19                	jmp    801f0f <find_block+0x29>
	{
		if(element->sva == va){
  801ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef9:	8b 40 08             	mov    0x8(%eax),%eax
  801efc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801eff:	75 05                	jne    801f06 <find_block+0x20>
			 		return element;
  801f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f04:	eb 36                	jmp    801f3c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	8b 40 08             	mov    0x8(%eax),%eax
  801f0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f13:	74 07                	je     801f1c <find_block+0x36>
  801f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f18:	8b 00                	mov    (%eax),%eax
  801f1a:	eb 05                	jmp    801f21 <find_block+0x3b>
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f21:	8b 55 08             	mov    0x8(%ebp),%edx
  801f24:	89 42 08             	mov    %eax,0x8(%edx)
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	8b 40 08             	mov    0x8(%eax),%eax
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	75 c5                	jne    801ef6 <find_block+0x10>
  801f31:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f35:	75 bf                	jne    801ef6 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  801f44:	a1 44 40 80 00       	mov    0x804044,%eax
  801f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  801f4c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f51:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  801f54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f58:	74 0a                	je     801f64 <insert_sorted_allocList+0x26>
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	8b 40 08             	mov    0x8(%eax),%eax
  801f60:	85 c0                	test   %eax,%eax
  801f62:	75 65                	jne    801fc9 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  801f64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f68:	75 14                	jne    801f7e <insert_sorted_allocList+0x40>
  801f6a:	83 ec 04             	sub    $0x4,%esp
  801f6d:	68 14 38 80 00       	push   $0x803814
  801f72:	6a 6e                	push   $0x6e
  801f74:	68 37 38 80 00       	push   $0x803837
  801f79:	e8 39 0e 00 00       	call   802db7 <_panic>
  801f7e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	89 10                	mov    %edx,(%eax)
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	8b 00                	mov    (%eax),%eax
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	74 0d                	je     801f9f <insert_sorted_allocList+0x61>
  801f92:	a1 40 40 80 00       	mov    0x804040,%eax
  801f97:	8b 55 08             	mov    0x8(%ebp),%edx
  801f9a:	89 50 04             	mov    %edx,0x4(%eax)
  801f9d:	eb 08                	jmp    801fa7 <insert_sorted_allocList+0x69>
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	a3 44 40 80 00       	mov    %eax,0x804044
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	a3 40 40 80 00       	mov    %eax,0x804040
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fbe:	40                   	inc    %eax
  801fbf:	a3 4c 40 80 00       	mov    %eax,0x80404c
  801fc4:	e9 cf 01 00 00       	jmp    802198 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  801fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcc:	8b 50 08             	mov    0x8(%eax),%edx
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	8b 40 08             	mov    0x8(%eax),%eax
  801fd5:	39 c2                	cmp    %eax,%edx
  801fd7:	73 65                	jae    80203e <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801fd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fdd:	75 14                	jne    801ff3 <insert_sorted_allocList+0xb5>
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	68 50 38 80 00       	push   $0x803850
  801fe7:	6a 72                	push   $0x72
  801fe9:	68 37 38 80 00       	push   $0x803837
  801fee:	e8 c4 0d 00 00       	call   802db7 <_panic>
  801ff3:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	89 50 04             	mov    %edx,0x4(%eax)
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	8b 40 04             	mov    0x4(%eax),%eax
  802005:	85 c0                	test   %eax,%eax
  802007:	74 0c                	je     802015 <insert_sorted_allocList+0xd7>
  802009:	a1 44 40 80 00       	mov    0x804044,%eax
  80200e:	8b 55 08             	mov    0x8(%ebp),%edx
  802011:	89 10                	mov    %edx,(%eax)
  802013:	eb 08                	jmp    80201d <insert_sorted_allocList+0xdf>
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	a3 40 40 80 00       	mov    %eax,0x804040
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	a3 44 40 80 00       	mov    %eax,0x804044
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80202e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802033:	40                   	inc    %eax
  802034:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802039:	e9 5a 01 00 00       	jmp    802198 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80203e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802041:	8b 50 08             	mov    0x8(%eax),%edx
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	8b 40 08             	mov    0x8(%eax),%eax
  80204a:	39 c2                	cmp    %eax,%edx
  80204c:	75 70                	jne    8020be <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80204e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802052:	74 06                	je     80205a <insert_sorted_allocList+0x11c>
  802054:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802058:	75 14                	jne    80206e <insert_sorted_allocList+0x130>
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	68 74 38 80 00       	push   $0x803874
  802062:	6a 75                	push   $0x75
  802064:	68 37 38 80 00       	push   $0x803837
  802069:	e8 49 0d 00 00       	call   802db7 <_panic>
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	8b 10                	mov    (%eax),%edx
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	89 10                	mov    %edx,(%eax)
  802078:	8b 45 08             	mov    0x8(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	85 c0                	test   %eax,%eax
  80207f:	74 0b                	je     80208c <insert_sorted_allocList+0x14e>
  802081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802084:	8b 00                	mov    (%eax),%eax
  802086:	8b 55 08             	mov    0x8(%ebp),%edx
  802089:	89 50 04             	mov    %edx,0x4(%eax)
  80208c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208f:	8b 55 08             	mov    0x8(%ebp),%edx
  802092:	89 10                	mov    %edx,(%eax)
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80209a:	89 50 04             	mov    %edx,0x4(%eax)
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	8b 00                	mov    (%eax),%eax
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	75 08                	jne    8020ae <insert_sorted_allocList+0x170>
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	a3 44 40 80 00       	mov    %eax,0x804044
  8020ae:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020b3:	40                   	inc    %eax
  8020b4:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8020b9:	e9 da 00 00 00       	jmp    802198 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8020be:	a1 40 40 80 00       	mov    0x804040,%eax
  8020c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c6:	e9 9d 00 00 00       	jmp    802168 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	8b 00                	mov    (%eax),%eax
  8020d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	8b 50 08             	mov    0x8(%eax),%edx
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	8b 40 08             	mov    0x8(%eax),%eax
  8020df:	39 c2                	cmp    %eax,%edx
  8020e1:	76 7d                	jbe    802160 <insert_sorted_allocList+0x222>
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	8b 50 08             	mov    0x8(%eax),%edx
  8020e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020ec:	8b 40 08             	mov    0x8(%eax),%eax
  8020ef:	39 c2                	cmp    %eax,%edx
  8020f1:	73 6d                	jae    802160 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8020f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f7:	74 06                	je     8020ff <insert_sorted_allocList+0x1c1>
  8020f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020fd:	75 14                	jne    802113 <insert_sorted_allocList+0x1d5>
  8020ff:	83 ec 04             	sub    $0x4,%esp
  802102:	68 74 38 80 00       	push   $0x803874
  802107:	6a 7c                	push   $0x7c
  802109:	68 37 38 80 00       	push   $0x803837
  80210e:	e8 a4 0c 00 00       	call   802db7 <_panic>
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	8b 10                	mov    (%eax),%edx
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	89 10                	mov    %edx,(%eax)
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	8b 00                	mov    (%eax),%eax
  802122:	85 c0                	test   %eax,%eax
  802124:	74 0b                	je     802131 <insert_sorted_allocList+0x1f3>
  802126:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802129:	8b 00                	mov    (%eax),%eax
  80212b:	8b 55 08             	mov    0x8(%ebp),%edx
  80212e:	89 50 04             	mov    %edx,0x4(%eax)
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	8b 55 08             	mov    0x8(%ebp),%edx
  802137:	89 10                	mov    %edx,(%eax)
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213f:	89 50 04             	mov    %edx,0x4(%eax)
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	8b 00                	mov    (%eax),%eax
  802147:	85 c0                	test   %eax,%eax
  802149:	75 08                	jne    802153 <insert_sorted_allocList+0x215>
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	a3 44 40 80 00       	mov    %eax,0x804044
  802153:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802158:	40                   	inc    %eax
  802159:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80215e:	eb 38                	jmp    802198 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802160:	a1 48 40 80 00       	mov    0x804048,%eax
  802165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216c:	74 07                	je     802175 <insert_sorted_allocList+0x237>
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	8b 00                	mov    (%eax),%eax
  802173:	eb 05                	jmp    80217a <insert_sorted_allocList+0x23c>
  802175:	b8 00 00 00 00       	mov    $0x0,%eax
  80217a:	a3 48 40 80 00       	mov    %eax,0x804048
  80217f:	a1 48 40 80 00       	mov    0x804048,%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	0f 85 3f ff ff ff    	jne    8020cb <insert_sorted_allocList+0x18d>
  80218c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802190:	0f 85 35 ff ff ff    	jne    8020cb <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802196:	eb 00                	jmp    802198 <insert_sorted_allocList+0x25a>
  802198:	90                   	nop
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8021a1:	a1 38 41 80 00       	mov    0x804138,%eax
  8021a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a9:	e9 6b 02 00 00       	jmp    802419 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b7:	0f 85 90 00 00 00    	jne    80224d <alloc_block_FF+0xb2>
			  temp=element;
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8021c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c7:	75 17                	jne    8021e0 <alloc_block_FF+0x45>
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	68 a8 38 80 00       	push   $0x8038a8
  8021d1:	68 92 00 00 00       	push   $0x92
  8021d6:	68 37 38 80 00       	push   $0x803837
  8021db:	e8 d7 0b 00 00       	call   802db7 <_panic>
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	8b 00                	mov    (%eax),%eax
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	74 10                	je     8021f9 <alloc_block_FF+0x5e>
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	8b 00                	mov    (%eax),%eax
  8021ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f1:	8b 52 04             	mov    0x4(%edx),%edx
  8021f4:	89 50 04             	mov    %edx,0x4(%eax)
  8021f7:	eb 0b                	jmp    802204 <alloc_block_FF+0x69>
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	8b 40 04             	mov    0x4(%eax),%eax
  8021ff:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802204:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802207:	8b 40 04             	mov    0x4(%eax),%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	74 0f                	je     80221d <alloc_block_FF+0x82>
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	8b 40 04             	mov    0x4(%eax),%eax
  802214:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802217:	8b 12                	mov    (%edx),%edx
  802219:	89 10                	mov    %edx,(%eax)
  80221b:	eb 0a                	jmp    802227 <alloc_block_FF+0x8c>
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	a3 38 41 80 00       	mov    %eax,0x804138
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80223a:	a1 44 41 80 00       	mov    0x804144,%eax
  80223f:	48                   	dec    %eax
  802240:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802248:	e9 ff 01 00 00       	jmp    80244c <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 40 0c             	mov    0xc(%eax),%eax
  802253:	3b 45 08             	cmp    0x8(%ebp),%eax
  802256:	0f 86 b5 01 00 00    	jbe    802411 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 40 0c             	mov    0xc(%eax),%eax
  802262:	2b 45 08             	sub    0x8(%ebp),%eax
  802265:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802268:	a1 48 41 80 00       	mov    0x804148,%eax
  80226d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802270:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802274:	75 17                	jne    80228d <alloc_block_FF+0xf2>
  802276:	83 ec 04             	sub    $0x4,%esp
  802279:	68 a8 38 80 00       	push   $0x8038a8
  80227e:	68 99 00 00 00       	push   $0x99
  802283:	68 37 38 80 00       	push   $0x803837
  802288:	e8 2a 0b 00 00       	call   802db7 <_panic>
  80228d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802290:	8b 00                	mov    (%eax),%eax
  802292:	85 c0                	test   %eax,%eax
  802294:	74 10                	je     8022a6 <alloc_block_FF+0x10b>
  802296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802299:	8b 00                	mov    (%eax),%eax
  80229b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80229e:	8b 52 04             	mov    0x4(%edx),%edx
  8022a1:	89 50 04             	mov    %edx,0x4(%eax)
  8022a4:	eb 0b                	jmp    8022b1 <alloc_block_FF+0x116>
  8022a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a9:	8b 40 04             	mov    0x4(%eax),%eax
  8022ac:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b4:	8b 40 04             	mov    0x4(%eax),%eax
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	74 0f                	je     8022ca <alloc_block_FF+0x12f>
  8022bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022be:	8b 40 04             	mov    0x4(%eax),%eax
  8022c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022c4:	8b 12                	mov    (%edx),%edx
  8022c6:	89 10                	mov    %edx,(%eax)
  8022c8:	eb 0a                	jmp    8022d4 <alloc_block_FF+0x139>
  8022ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cd:	8b 00                	mov    (%eax),%eax
  8022cf:	a3 48 41 80 00       	mov    %eax,0x804148
  8022d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e7:	a1 54 41 80 00       	mov    0x804154,%eax
  8022ec:	48                   	dec    %eax
  8022ed:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8022f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022f6:	75 17                	jne    80230f <alloc_block_FF+0x174>
  8022f8:	83 ec 04             	sub    $0x4,%esp
  8022fb:	68 50 38 80 00       	push   $0x803850
  802300:	68 9a 00 00 00       	push   $0x9a
  802305:	68 37 38 80 00       	push   $0x803837
  80230a:	e8 a8 0a 00 00       	call   802db7 <_panic>
  80230f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802315:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802318:	89 50 04             	mov    %edx,0x4(%eax)
  80231b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231e:	8b 40 04             	mov    0x4(%eax),%eax
  802321:	85 c0                	test   %eax,%eax
  802323:	74 0c                	je     802331 <alloc_block_FF+0x196>
  802325:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80232a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80232d:	89 10                	mov    %edx,(%eax)
  80232f:	eb 08                	jmp    802339 <alloc_block_FF+0x19e>
  802331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802334:	a3 38 41 80 00       	mov    %eax,0x804138
  802339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802344:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80234a:	a1 44 41 80 00       	mov    0x804144,%eax
  80234f:	40                   	inc    %eax
  802350:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802355:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802358:	8b 55 08             	mov    0x8(%ebp),%edx
  80235b:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 50 08             	mov    0x8(%eax),%edx
  802364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802367:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802370:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 50 08             	mov    0x8(%eax),%edx
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	01 c2                	add    %eax,%edx
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802387:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80238a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80238e:	75 17                	jne    8023a7 <alloc_block_FF+0x20c>
  802390:	83 ec 04             	sub    $0x4,%esp
  802393:	68 a8 38 80 00       	push   $0x8038a8
  802398:	68 a2 00 00 00       	push   $0xa2
  80239d:	68 37 38 80 00       	push   $0x803837
  8023a2:	e8 10 0a 00 00       	call   802db7 <_panic>
  8023a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	74 10                	je     8023c0 <alloc_block_FF+0x225>
  8023b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b8:	8b 52 04             	mov    0x4(%edx),%edx
  8023bb:	89 50 04             	mov    %edx,0x4(%eax)
  8023be:	eb 0b                	jmp    8023cb <alloc_block_FF+0x230>
  8023c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c3:	8b 40 04             	mov    0x4(%eax),%eax
  8023c6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ce:	8b 40 04             	mov    0x4(%eax),%eax
  8023d1:	85 c0                	test   %eax,%eax
  8023d3:	74 0f                	je     8023e4 <alloc_block_FF+0x249>
  8023d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d8:	8b 40 04             	mov    0x4(%eax),%eax
  8023db:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023de:	8b 12                	mov    (%edx),%edx
  8023e0:	89 10                	mov    %edx,(%eax)
  8023e2:	eb 0a                	jmp    8023ee <alloc_block_FF+0x253>
  8023e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	a3 38 41 80 00       	mov    %eax,0x804138
  8023ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802401:	a1 44 41 80 00       	mov    0x804144,%eax
  802406:	48                   	dec    %eax
  802407:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80240c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80240f:	eb 3b                	jmp    80244c <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802411:	a1 40 41 80 00       	mov    0x804140,%eax
  802416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241d:	74 07                	je     802426 <alloc_block_FF+0x28b>
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	eb 05                	jmp    80242b <alloc_block_FF+0x290>
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
  80242b:	a3 40 41 80 00       	mov    %eax,0x804140
  802430:	a1 40 41 80 00       	mov    0x804140,%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	0f 85 71 fd ff ff    	jne    8021ae <alloc_block_FF+0x13>
  80243d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802441:	0f 85 67 fd ff ff    	jne    8021ae <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80245b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802462:	a1 38 41 80 00       	mov    0x804138,%eax
  802467:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80246a:	e9 d3 00 00 00       	jmp    802542 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80246f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802472:	8b 40 0c             	mov    0xc(%eax),%eax
  802475:	3b 45 08             	cmp    0x8(%ebp),%eax
  802478:	0f 85 90 00 00 00    	jne    80250e <alloc_block_BF+0xc0>
	   temp = element;
  80247e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802481:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802484:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802488:	75 17                	jne    8024a1 <alloc_block_BF+0x53>
  80248a:	83 ec 04             	sub    $0x4,%esp
  80248d:	68 a8 38 80 00       	push   $0x8038a8
  802492:	68 bd 00 00 00       	push   $0xbd
  802497:	68 37 38 80 00       	push   $0x803837
  80249c:	e8 16 09 00 00       	call   802db7 <_panic>
  8024a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	74 10                	je     8024ba <alloc_block_BF+0x6c>
  8024aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024b2:	8b 52 04             	mov    0x4(%edx),%edx
  8024b5:	89 50 04             	mov    %edx,0x4(%eax)
  8024b8:	eb 0b                	jmp    8024c5 <alloc_block_BF+0x77>
  8024ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024bd:	8b 40 04             	mov    0x4(%eax),%eax
  8024c0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c8:	8b 40 04             	mov    0x4(%eax),%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	74 0f                	je     8024de <alloc_block_BF+0x90>
  8024cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d2:	8b 40 04             	mov    0x4(%eax),%eax
  8024d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024d8:	8b 12                	mov    (%edx),%edx
  8024da:	89 10                	mov    %edx,(%eax)
  8024dc:	eb 0a                	jmp    8024e8 <alloc_block_BF+0x9a>
  8024de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	a3 38 41 80 00       	mov    %eax,0x804138
  8024e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fb:	a1 44 41 80 00       	mov    0x804144,%eax
  802500:	48                   	dec    %eax
  802501:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802506:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802509:	e9 41 01 00 00       	jmp    80264f <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80250e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802511:	8b 40 0c             	mov    0xc(%eax),%eax
  802514:	3b 45 08             	cmp    0x8(%ebp),%eax
  802517:	76 21                	jbe    80253a <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802519:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251c:	8b 40 0c             	mov    0xc(%eax),%eax
  80251f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802522:	73 16                	jae    80253a <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802524:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802527:	8b 40 0c             	mov    0xc(%eax),%eax
  80252a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80252d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802530:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802533:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80253a:	a1 40 41 80 00       	mov    0x804140,%eax
  80253f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802542:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802546:	74 07                	je     80254f <alloc_block_BF+0x101>
  802548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80254b:	8b 00                	mov    (%eax),%eax
  80254d:	eb 05                	jmp    802554 <alloc_block_BF+0x106>
  80254f:	b8 00 00 00 00       	mov    $0x0,%eax
  802554:	a3 40 41 80 00       	mov    %eax,0x804140
  802559:	a1 40 41 80 00       	mov    0x804140,%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	0f 85 09 ff ff ff    	jne    80246f <alloc_block_BF+0x21>
  802566:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80256a:	0f 85 ff fe ff ff    	jne    80246f <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802570:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802574:	0f 85 d0 00 00 00    	jne    80264a <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80257a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257d:	8b 40 0c             	mov    0xc(%eax),%eax
  802580:	2b 45 08             	sub    0x8(%ebp),%eax
  802583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802586:	a1 48 41 80 00       	mov    0x804148,%eax
  80258b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  80258e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802592:	75 17                	jne    8025ab <alloc_block_BF+0x15d>
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	68 a8 38 80 00       	push   $0x8038a8
  80259c:	68 d1 00 00 00       	push   $0xd1
  8025a1:	68 37 38 80 00       	push   $0x803837
  8025a6:	e8 0c 08 00 00       	call   802db7 <_panic>
  8025ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	74 10                	je     8025c4 <alloc_block_BF+0x176>
  8025b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b7:	8b 00                	mov    (%eax),%eax
  8025b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025bc:	8b 52 04             	mov    0x4(%edx),%edx
  8025bf:	89 50 04             	mov    %edx,0x4(%eax)
  8025c2:	eb 0b                	jmp    8025cf <alloc_block_BF+0x181>
  8025c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d2:	8b 40 04             	mov    0x4(%eax),%eax
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	74 0f                	je     8025e8 <alloc_block_BF+0x19a>
  8025d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025dc:	8b 40 04             	mov    0x4(%eax),%eax
  8025df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025e2:	8b 12                	mov    (%edx),%edx
  8025e4:	89 10                	mov    %edx,(%eax)
  8025e6:	eb 0a                	jmp    8025f2 <alloc_block_BF+0x1a4>
  8025e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	a3 48 41 80 00       	mov    %eax,0x804148
  8025f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802605:	a1 54 41 80 00       	mov    0x804154,%eax
  80260a:	48                   	dec    %eax
  80260b:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802613:	8b 55 08             	mov    0x8(%ebp),%edx
  802616:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261c:	8b 50 08             	mov    0x8(%eax),%edx
  80261f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802622:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802625:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802628:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80262b:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80262e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802631:	8b 50 08             	mov    0x8(%eax),%edx
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	01 c2                	add    %eax,%edx
  802639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263c:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80263f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802642:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802648:	eb 05                	jmp    80264f <alloc_block_BF+0x201>
	 }
	 return NULL;
  80264a:	b8 00 00 00 00       	mov    $0x0,%eax


}
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802657:	83 ec 04             	sub    $0x4,%esp
  80265a:	68 c8 38 80 00       	push   $0x8038c8
  80265f:	68 e8 00 00 00       	push   $0xe8
  802664:	68 37 38 80 00       	push   $0x803837
  802669:	e8 49 07 00 00       	call   802db7 <_panic>

0080266e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802674:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802679:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80267c:	a1 38 41 80 00       	mov    0x804138,%eax
  802681:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802684:	a1 44 41 80 00       	mov    0x804144,%eax
  802689:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80268c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802690:	75 68                	jne    8026fa <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802692:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802696:	75 17                	jne    8026af <insert_sorted_with_merge_freeList+0x41>
  802698:	83 ec 04             	sub    $0x4,%esp
  80269b:	68 14 38 80 00       	push   $0x803814
  8026a0:	68 36 01 00 00       	push   $0x136
  8026a5:	68 37 38 80 00       	push   $0x803837
  8026aa:	e8 08 07 00 00       	call   802db7 <_panic>
  8026af:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	89 10                	mov    %edx,(%eax)
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	74 0d                	je     8026d0 <insert_sorted_with_merge_freeList+0x62>
  8026c3:	a1 38 41 80 00       	mov    0x804138,%eax
  8026c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cb:	89 50 04             	mov    %edx,0x4(%eax)
  8026ce:	eb 08                	jmp    8026d8 <insert_sorted_with_merge_freeList+0x6a>
  8026d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	a3 38 41 80 00       	mov    %eax,0x804138
  8026e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ea:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ef:	40                   	inc    %eax
  8026f0:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8026f5:	e9 ba 06 00 00       	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8026fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fd:	8b 50 08             	mov    0x8(%eax),%edx
  802700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802703:	8b 40 0c             	mov    0xc(%eax),%eax
  802706:	01 c2                	add    %eax,%edx
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	8b 40 08             	mov    0x8(%eax),%eax
  80270e:	39 c2                	cmp    %eax,%edx
  802710:	73 68                	jae    80277a <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802712:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802716:	75 17                	jne    80272f <insert_sorted_with_merge_freeList+0xc1>
  802718:	83 ec 04             	sub    $0x4,%esp
  80271b:	68 50 38 80 00       	push   $0x803850
  802720:	68 3a 01 00 00       	push   $0x13a
  802725:	68 37 38 80 00       	push   $0x803837
  80272a:	e8 88 06 00 00       	call   802db7 <_panic>
  80272f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	89 50 04             	mov    %edx,0x4(%eax)
  80273b:	8b 45 08             	mov    0x8(%ebp),%eax
  80273e:	8b 40 04             	mov    0x4(%eax),%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	74 0c                	je     802751 <insert_sorted_with_merge_freeList+0xe3>
  802745:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80274a:	8b 55 08             	mov    0x8(%ebp),%edx
  80274d:	89 10                	mov    %edx,(%eax)
  80274f:	eb 08                	jmp    802759 <insert_sorted_with_merge_freeList+0xeb>
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	a3 38 41 80 00       	mov    %eax,0x804138
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276a:	a1 44 41 80 00       	mov    0x804144,%eax
  80276f:	40                   	inc    %eax
  802770:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802775:	e9 3a 06 00 00       	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80277a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277d:	8b 50 08             	mov    0x8(%eax),%edx
  802780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802783:	8b 40 0c             	mov    0xc(%eax),%eax
  802786:	01 c2                	add    %eax,%edx
  802788:	8b 45 08             	mov    0x8(%ebp),%eax
  80278b:	8b 40 08             	mov    0x8(%eax),%eax
  80278e:	39 c2                	cmp    %eax,%edx
  802790:	0f 85 90 00 00 00    	jne    802826 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802799:	8b 50 0c             	mov    0xc(%eax),%edx
  80279c:	8b 45 08             	mov    0x8(%ebp),%eax
  80279f:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a2:	01 c2                	add    %eax,%edx
  8027a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a7:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8027b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8027be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c2:	75 17                	jne    8027db <insert_sorted_with_merge_freeList+0x16d>
  8027c4:	83 ec 04             	sub    $0x4,%esp
  8027c7:	68 14 38 80 00       	push   $0x803814
  8027cc:	68 41 01 00 00       	push   $0x141
  8027d1:	68 37 38 80 00       	push   $0x803837
  8027d6:	e8 dc 05 00 00       	call   802db7 <_panic>
  8027db:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	89 10                	mov    %edx,(%eax)
  8027e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e9:	8b 00                	mov    (%eax),%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	74 0d                	je     8027fc <insert_sorted_with_merge_freeList+0x18e>
  8027ef:	a1 48 41 80 00       	mov    0x804148,%eax
  8027f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f7:	89 50 04             	mov    %edx,0x4(%eax)
  8027fa:	eb 08                	jmp    802804 <insert_sorted_with_merge_freeList+0x196>
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	a3 48 41 80 00       	mov    %eax,0x804148
  80280c:	8b 45 08             	mov    0x8(%ebp),%eax
  80280f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802816:	a1 54 41 80 00       	mov    0x804154,%eax
  80281b:	40                   	inc    %eax
  80281c:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802821:	e9 8e 05 00 00       	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	8b 50 08             	mov    0x8(%eax),%edx
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	8b 40 0c             	mov    0xc(%eax),%eax
  802832:	01 c2                	add    %eax,%edx
  802834:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802837:	8b 40 08             	mov    0x8(%eax),%eax
  80283a:	39 c2                	cmp    %eax,%edx
  80283c:	73 68                	jae    8028a6 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80283e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802842:	75 17                	jne    80285b <insert_sorted_with_merge_freeList+0x1ed>
  802844:	83 ec 04             	sub    $0x4,%esp
  802847:	68 14 38 80 00       	push   $0x803814
  80284c:	68 45 01 00 00       	push   $0x145
  802851:	68 37 38 80 00       	push   $0x803837
  802856:	e8 5c 05 00 00       	call   802db7 <_panic>
  80285b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	89 10                	mov    %edx,(%eax)
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	85 c0                	test   %eax,%eax
  80286d:	74 0d                	je     80287c <insert_sorted_with_merge_freeList+0x20e>
  80286f:	a1 38 41 80 00       	mov    0x804138,%eax
  802874:	8b 55 08             	mov    0x8(%ebp),%edx
  802877:	89 50 04             	mov    %edx,0x4(%eax)
  80287a:	eb 08                	jmp    802884 <insert_sorted_with_merge_freeList+0x216>
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802884:	8b 45 08             	mov    0x8(%ebp),%eax
  802887:	a3 38 41 80 00       	mov    %eax,0x804138
  80288c:	8b 45 08             	mov    0x8(%ebp),%eax
  80288f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802896:	a1 44 41 80 00       	mov    0x804144,%eax
  80289b:	40                   	inc    %eax
  80289c:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8028a1:	e9 0e 05 00 00       	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	8b 50 08             	mov    0x8(%eax),%edx
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b2:	01 c2                	add    %eax,%edx
  8028b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b7:	8b 40 08             	mov    0x8(%eax),%eax
  8028ba:	39 c2                	cmp    %eax,%edx
  8028bc:	0f 85 9c 00 00 00    	jne    80295e <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8028c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c5:	8b 50 0c             	mov    0xc(%eax),%edx
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ce:	01 c2                	add    %eax,%edx
  8028d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d3:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	8b 50 08             	mov    0x8(%eax),%edx
  8028dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028df:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8028f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028fa:	75 17                	jne    802913 <insert_sorted_with_merge_freeList+0x2a5>
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	68 14 38 80 00       	push   $0x803814
  802904:	68 4d 01 00 00       	push   $0x14d
  802909:	68 37 38 80 00       	push   $0x803837
  80290e:	e8 a4 04 00 00       	call   802db7 <_panic>
  802913:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	89 10                	mov    %edx,(%eax)
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	74 0d                	je     802934 <insert_sorted_with_merge_freeList+0x2c6>
  802927:	a1 48 41 80 00       	mov    0x804148,%eax
  80292c:	8b 55 08             	mov    0x8(%ebp),%edx
  80292f:	89 50 04             	mov    %edx,0x4(%eax)
  802932:	eb 08                	jmp    80293c <insert_sorted_with_merge_freeList+0x2ce>
  802934:	8b 45 08             	mov    0x8(%ebp),%eax
  802937:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	a3 48 41 80 00       	mov    %eax,0x804148
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294e:	a1 54 41 80 00       	mov    0x804154,%eax
  802953:	40                   	inc    %eax
  802954:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802959:	e9 56 04 00 00       	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80295e:	a1 38 41 80 00       	mov    0x804138,%eax
  802963:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802966:	e9 19 04 00 00       	jmp    802d84 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 50 08             	mov    0x8(%eax),%edx
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 0c             	mov    0xc(%eax),%eax
  80297f:	01 c2                	add    %eax,%edx
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	8b 40 08             	mov    0x8(%eax),%eax
  802987:	39 c2                	cmp    %eax,%edx
  802989:	0f 85 ad 01 00 00    	jne    802b3c <insert_sorted_with_merge_freeList+0x4ce>
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	8b 50 08             	mov    0x8(%eax),%edx
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	8b 40 0c             	mov    0xc(%eax),%eax
  80299b:	01 c2                	add    %eax,%edx
  80299d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a0:	8b 40 08             	mov    0x8(%eax),%eax
  8029a3:	39 c2                	cmp    %eax,%edx
  8029a5:	0f 85 91 01 00 00    	jne    802b3c <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 50 0c             	mov    0xc(%eax),%edx
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 48 0c             	mov    0xc(%eax),%ecx
  8029b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bd:	01 c8                	add    %ecx,%eax
  8029bf:	01 c2                	add    %eax,%edx
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  8029db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  8029e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  8029ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8029f3:	75 17                	jne    802a0c <insert_sorted_with_merge_freeList+0x39e>
  8029f5:	83 ec 04             	sub    $0x4,%esp
  8029f8:	68 a8 38 80 00       	push   $0x8038a8
  8029fd:	68 5b 01 00 00       	push   $0x15b
  802a02:	68 37 38 80 00       	push   $0x803837
  802a07:	e8 ab 03 00 00       	call   802db7 <_panic>
  802a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a0f:	8b 00                	mov    (%eax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	74 10                	je     802a25 <insert_sorted_with_merge_freeList+0x3b7>
  802a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a1d:	8b 52 04             	mov    0x4(%edx),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	eb 0b                	jmp    802a30 <insert_sorted_with_merge_freeList+0x3c2>
  802a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 0f                	je     802a49 <insert_sorted_with_merge_freeList+0x3db>
  802a3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a43:	8b 12                	mov    (%edx),%edx
  802a45:	89 10                	mov    %edx,(%eax)
  802a47:	eb 0a                	jmp    802a53 <insert_sorted_with_merge_freeList+0x3e5>
  802a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a66:	a1 44 41 80 00       	mov    0x804144,%eax
  802a6b:	48                   	dec    %eax
  802a6c:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802a71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a75:	75 17                	jne    802a8e <insert_sorted_with_merge_freeList+0x420>
  802a77:	83 ec 04             	sub    $0x4,%esp
  802a7a:	68 14 38 80 00       	push   $0x803814
  802a7f:	68 5c 01 00 00       	push   $0x15c
  802a84:	68 37 38 80 00       	push   $0x803837
  802a89:	e8 29 03 00 00       	call   802db7 <_panic>
  802a8e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	89 10                	mov    %edx,(%eax)
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	8b 00                	mov    (%eax),%eax
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	74 0d                	je     802aaf <insert_sorted_with_merge_freeList+0x441>
  802aa2:	a1 48 41 80 00       	mov    0x804148,%eax
  802aa7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aaa:	89 50 04             	mov    %edx,0x4(%eax)
  802aad:	eb 08                	jmp    802ab7 <insert_sorted_with_merge_freeList+0x449>
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	a3 48 41 80 00       	mov    %eax,0x804148
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac9:	a1 54 41 80 00       	mov    0x804154,%eax
  802ace:	40                   	inc    %eax
  802acf:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802ad4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ad8:	75 17                	jne    802af1 <insert_sorted_with_merge_freeList+0x483>
  802ada:	83 ec 04             	sub    $0x4,%esp
  802add:	68 14 38 80 00       	push   $0x803814
  802ae2:	68 5d 01 00 00       	push   $0x15d
  802ae7:	68 37 38 80 00       	push   $0x803837
  802aec:	e8 c6 02 00 00       	call   802db7 <_panic>
  802af1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802afa:	89 10                	mov    %edx,(%eax)
  802afc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aff:	8b 00                	mov    (%eax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	74 0d                	je     802b12 <insert_sorted_with_merge_freeList+0x4a4>
  802b05:	a1 48 41 80 00       	mov    0x804148,%eax
  802b0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b0d:	89 50 04             	mov    %edx,0x4(%eax)
  802b10:	eb 08                	jmp    802b1a <insert_sorted_with_merge_freeList+0x4ac>
  802b12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b15:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b1d:	a3 48 41 80 00       	mov    %eax,0x804148
  802b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2c:	a1 54 41 80 00       	mov    0x804154,%eax
  802b31:	40                   	inc    %eax
  802b32:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802b37:	e9 78 02 00 00       	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 50 08             	mov    0x8(%eax),%edx
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 0c             	mov    0xc(%eax),%eax
  802b48:	01 c2                	add    %eax,%edx
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	8b 40 08             	mov    0x8(%eax),%eax
  802b50:	39 c2                	cmp    %eax,%edx
  802b52:	0f 83 b8 00 00 00    	jae    802c10 <insert_sorted_with_merge_freeList+0x5a2>
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	8b 50 08             	mov    0x8(%eax),%edx
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	8b 40 0c             	mov    0xc(%eax),%eax
  802b64:	01 c2                	add    %eax,%edx
  802b66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b69:	8b 40 08             	mov    0x8(%eax),%eax
  802b6c:	39 c2                	cmp    %eax,%edx
  802b6e:	0f 85 9c 00 00 00    	jne    802c10 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b77:	8b 50 0c             	mov    0xc(%eax),%edx
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b80:	01 c2                	add    %eax,%edx
  802b82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b85:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	8b 50 08             	mov    0x8(%eax),%edx
  802b8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b91:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ba8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bac:	75 17                	jne    802bc5 <insert_sorted_with_merge_freeList+0x557>
  802bae:	83 ec 04             	sub    $0x4,%esp
  802bb1:	68 14 38 80 00       	push   $0x803814
  802bb6:	68 67 01 00 00       	push   $0x167
  802bbb:	68 37 38 80 00       	push   $0x803837
  802bc0:	e8 f2 01 00 00       	call   802db7 <_panic>
  802bc5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	89 10                	mov    %edx,(%eax)
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	74 0d                	je     802be6 <insert_sorted_with_merge_freeList+0x578>
  802bd9:	a1 48 41 80 00       	mov    0x804148,%eax
  802bde:	8b 55 08             	mov    0x8(%ebp),%edx
  802be1:	89 50 04             	mov    %edx,0x4(%eax)
  802be4:	eb 08                	jmp    802bee <insert_sorted_with_merge_freeList+0x580>
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	a3 48 41 80 00       	mov    %eax,0x804148
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c00:	a1 54 41 80 00       	mov    0x804154,%eax
  802c05:	40                   	inc    %eax
  802c06:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802c0b:	e9 a4 01 00 00       	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 50 08             	mov    0x8(%eax),%edx
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1c:	01 c2                	add    %eax,%edx
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	8b 40 08             	mov    0x8(%eax),%eax
  802c24:	39 c2                	cmp    %eax,%edx
  802c26:	0f 85 ac 00 00 00    	jne    802cd8 <insert_sorted_with_merge_freeList+0x66a>
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	8b 50 08             	mov    0x8(%eax),%edx
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	8b 40 0c             	mov    0xc(%eax),%eax
  802c38:	01 c2                	add    %eax,%edx
  802c3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c3d:	8b 40 08             	mov    0x8(%eax),%eax
  802c40:	39 c2                	cmp    %eax,%edx
  802c42:	0f 83 90 00 00 00    	jae    802cd8 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 50 0c             	mov    0xc(%eax),%edx
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	8b 40 0c             	mov    0xc(%eax),%eax
  802c54:	01 c2                	add    %eax,%edx
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c74:	75 17                	jne    802c8d <insert_sorted_with_merge_freeList+0x61f>
  802c76:	83 ec 04             	sub    $0x4,%esp
  802c79:	68 14 38 80 00       	push   $0x803814
  802c7e:	68 70 01 00 00       	push   $0x170
  802c83:	68 37 38 80 00       	push   $0x803837
  802c88:	e8 2a 01 00 00       	call   802db7 <_panic>
  802c8d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	89 10                	mov    %edx,(%eax)
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 0d                	je     802cae <insert_sorted_with_merge_freeList+0x640>
  802ca1:	a1 48 41 80 00       	mov    0x804148,%eax
  802ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca9:	89 50 04             	mov    %edx,0x4(%eax)
  802cac:	eb 08                	jmp    802cb6 <insert_sorted_with_merge_freeList+0x648>
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	a3 48 41 80 00       	mov    %eax,0x804148
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc8:	a1 54 41 80 00       	mov    0x804154,%eax
  802ccd:	40                   	inc    %eax
  802cce:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802cd3:	e9 dc 00 00 00       	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 50 08             	mov    0x8(%eax),%edx
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce4:	01 c2                	add    %eax,%edx
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	8b 40 08             	mov    0x8(%eax),%eax
  802cec:	39 c2                	cmp    %eax,%edx
  802cee:	0f 83 88 00 00 00    	jae    802d7c <insert_sorted_with_merge_freeList+0x70e>
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	8b 50 08             	mov    0x8(%eax),%edx
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802d00:	01 c2                	add    %eax,%edx
  802d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d05:	8b 40 08             	mov    0x8(%eax),%eax
  802d08:	39 c2                	cmp    %eax,%edx
  802d0a:	73 70                	jae    802d7c <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802d0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d10:	74 06                	je     802d18 <insert_sorted_with_merge_freeList+0x6aa>
  802d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d16:	75 17                	jne    802d2f <insert_sorted_with_merge_freeList+0x6c1>
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 74 38 80 00       	push   $0x803874
  802d20:	68 75 01 00 00       	push   $0x175
  802d25:	68 37 38 80 00       	push   $0x803837
  802d2a:	e8 88 00 00 00       	call   802db7 <_panic>
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 10                	mov    (%eax),%edx
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0b                	je     802d4d <insert_sorted_with_merge_freeList+0x6df>
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4a:	89 50 04             	mov    %edx,0x4(%eax)
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 55 08             	mov    0x8(%ebp),%edx
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	75 08                	jne    802d6f <insert_sorted_with_merge_freeList+0x701>
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d6f:	a1 44 41 80 00       	mov    0x804144,%eax
  802d74:	40                   	inc    %eax
  802d75:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802d7a:	eb 38                	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802d7c:	a1 40 41 80 00       	mov    0x804140,%eax
  802d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d88:	74 07                	je     802d91 <insert_sorted_with_merge_freeList+0x723>
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	eb 05                	jmp    802d96 <insert_sorted_with_merge_freeList+0x728>
  802d91:	b8 00 00 00 00       	mov    $0x0,%eax
  802d96:	a3 40 41 80 00       	mov    %eax,0x804140
  802d9b:	a1 40 41 80 00       	mov    0x804140,%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	0f 85 c3 fb ff ff    	jne    80296b <insert_sorted_with_merge_freeList+0x2fd>
  802da8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dac:	0f 85 b9 fb ff ff    	jne    80296b <insert_sorted_with_merge_freeList+0x2fd>





}
  802db2:	eb 00                	jmp    802db4 <insert_sorted_with_merge_freeList+0x746>
  802db4:	90                   	nop
  802db5:	c9                   	leave  
  802db6:	c3                   	ret    

00802db7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802db7:	55                   	push   %ebp
  802db8:	89 e5                	mov    %esp,%ebp
  802dba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802dbd:	8d 45 10             	lea    0x10(%ebp),%eax
  802dc0:	83 c0 04             	add    $0x4,%eax
  802dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802dc6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 16                	je     802de5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802dcf:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802dd4:	83 ec 08             	sub    $0x8,%esp
  802dd7:	50                   	push   %eax
  802dd8:	68 f8 38 80 00       	push   $0x8038f8
  802ddd:	e8 66 d5 ff ff       	call   800348 <cprintf>
  802de2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802de5:	a1 00 40 80 00       	mov    0x804000,%eax
  802dea:	ff 75 0c             	pushl  0xc(%ebp)
  802ded:	ff 75 08             	pushl  0x8(%ebp)
  802df0:	50                   	push   %eax
  802df1:	68 fd 38 80 00       	push   $0x8038fd
  802df6:	e8 4d d5 ff ff       	call   800348 <cprintf>
  802dfb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  802e01:	83 ec 08             	sub    $0x8,%esp
  802e04:	ff 75 f4             	pushl  -0xc(%ebp)
  802e07:	50                   	push   %eax
  802e08:	e8 d0 d4 ff ff       	call   8002dd <vcprintf>
  802e0d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802e10:	83 ec 08             	sub    $0x8,%esp
  802e13:	6a 00                	push   $0x0
  802e15:	68 19 39 80 00       	push   $0x803919
  802e1a:	e8 be d4 ff ff       	call   8002dd <vcprintf>
  802e1f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802e22:	e8 3f d4 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  802e27:	eb fe                	jmp    802e27 <_panic+0x70>

00802e29 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802e29:	55                   	push   %ebp
  802e2a:	89 e5                	mov    %esp,%ebp
  802e2c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802e2f:	a1 20 40 80 00       	mov    0x804020,%eax
  802e34:	8b 50 74             	mov    0x74(%eax),%edx
  802e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e3a:	39 c2                	cmp    %eax,%edx
  802e3c:	74 14                	je     802e52 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802e3e:	83 ec 04             	sub    $0x4,%esp
  802e41:	68 1c 39 80 00       	push   $0x80391c
  802e46:	6a 26                	push   $0x26
  802e48:	68 68 39 80 00       	push   $0x803968
  802e4d:	e8 65 ff ff ff       	call   802db7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802e52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802e59:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802e60:	e9 c2 00 00 00       	jmp    802f27 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e68:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	01 d0                	add    %edx,%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	75 08                	jne    802e82 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802e7a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802e7d:	e9 a2 00 00 00       	jmp    802f24 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802e82:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802e89:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802e90:	eb 69                	jmp    802efb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802e92:	a1 20 40 80 00       	mov    0x804020,%eax
  802e97:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802e9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ea0:	89 d0                	mov    %edx,%eax
  802ea2:	01 c0                	add    %eax,%eax
  802ea4:	01 d0                	add    %edx,%eax
  802ea6:	c1 e0 03             	shl    $0x3,%eax
  802ea9:	01 c8                	add    %ecx,%eax
  802eab:	8a 40 04             	mov    0x4(%eax),%al
  802eae:	84 c0                	test   %al,%al
  802eb0:	75 46                	jne    802ef8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802eb2:	a1 20 40 80 00       	mov    0x804020,%eax
  802eb7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802ebd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ec0:	89 d0                	mov    %edx,%eax
  802ec2:	01 c0                	add    %eax,%eax
  802ec4:	01 d0                	add    %edx,%eax
  802ec6:	c1 e0 03             	shl    $0x3,%eax
  802ec9:	01 c8                	add    %ecx,%eax
  802ecb:	8b 00                	mov    (%eax),%eax
  802ecd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ed0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802ed8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	01 c8                	add    %ecx,%eax
  802ee9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802eeb:	39 c2                	cmp    %eax,%edx
  802eed:	75 09                	jne    802ef8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  802eef:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  802ef6:	eb 12                	jmp    802f0a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802ef8:	ff 45 e8             	incl   -0x18(%ebp)
  802efb:	a1 20 40 80 00       	mov    0x804020,%eax
  802f00:	8b 50 74             	mov    0x74(%eax),%edx
  802f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f06:	39 c2                	cmp    %eax,%edx
  802f08:	77 88                	ja     802e92 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  802f0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f0e:	75 14                	jne    802f24 <CheckWSWithoutLastIndex+0xfb>
			panic(
  802f10:	83 ec 04             	sub    $0x4,%esp
  802f13:	68 74 39 80 00       	push   $0x803974
  802f18:	6a 3a                	push   $0x3a
  802f1a:	68 68 39 80 00       	push   $0x803968
  802f1f:	e8 93 fe ff ff       	call   802db7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  802f24:	ff 45 f0             	incl   -0x10(%ebp)
  802f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f2d:	0f 8c 32 ff ff ff    	jl     802e65 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  802f33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f3a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802f41:	eb 26                	jmp    802f69 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  802f43:	a1 20 40 80 00       	mov    0x804020,%eax
  802f48:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802f4e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f51:	89 d0                	mov    %edx,%eax
  802f53:	01 c0                	add    %eax,%eax
  802f55:	01 d0                	add    %edx,%eax
  802f57:	c1 e0 03             	shl    $0x3,%eax
  802f5a:	01 c8                	add    %ecx,%eax
  802f5c:	8a 40 04             	mov    0x4(%eax),%al
  802f5f:	3c 01                	cmp    $0x1,%al
  802f61:	75 03                	jne    802f66 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  802f63:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f66:	ff 45 e0             	incl   -0x20(%ebp)
  802f69:	a1 20 40 80 00       	mov    0x804020,%eax
  802f6e:	8b 50 74             	mov    0x74(%eax),%edx
  802f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f74:	39 c2                	cmp    %eax,%edx
  802f76:	77 cb                	ja     802f43 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f7e:	74 14                	je     802f94 <CheckWSWithoutLastIndex+0x16b>
		panic(
  802f80:	83 ec 04             	sub    $0x4,%esp
  802f83:	68 c8 39 80 00       	push   $0x8039c8
  802f88:	6a 44                	push   $0x44
  802f8a:	68 68 39 80 00       	push   $0x803968
  802f8f:	e8 23 fe ff ff       	call   802db7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  802f94:	90                   	nop
  802f95:	c9                   	leave  
  802f96:	c3                   	ret    
  802f97:	90                   	nop

00802f98 <__udivdi3>:
  802f98:	55                   	push   %ebp
  802f99:	57                   	push   %edi
  802f9a:	56                   	push   %esi
  802f9b:	53                   	push   %ebx
  802f9c:	83 ec 1c             	sub    $0x1c,%esp
  802f9f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802fa3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802fa7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802fab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802faf:	89 ca                	mov    %ecx,%edx
  802fb1:	89 f8                	mov    %edi,%eax
  802fb3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802fb7:	85 f6                	test   %esi,%esi
  802fb9:	75 2d                	jne    802fe8 <__udivdi3+0x50>
  802fbb:	39 cf                	cmp    %ecx,%edi
  802fbd:	77 65                	ja     803024 <__udivdi3+0x8c>
  802fbf:	89 fd                	mov    %edi,%ebp
  802fc1:	85 ff                	test   %edi,%edi
  802fc3:	75 0b                	jne    802fd0 <__udivdi3+0x38>
  802fc5:	b8 01 00 00 00       	mov    $0x1,%eax
  802fca:	31 d2                	xor    %edx,%edx
  802fcc:	f7 f7                	div    %edi
  802fce:	89 c5                	mov    %eax,%ebp
  802fd0:	31 d2                	xor    %edx,%edx
  802fd2:	89 c8                	mov    %ecx,%eax
  802fd4:	f7 f5                	div    %ebp
  802fd6:	89 c1                	mov    %eax,%ecx
  802fd8:	89 d8                	mov    %ebx,%eax
  802fda:	f7 f5                	div    %ebp
  802fdc:	89 cf                	mov    %ecx,%edi
  802fde:	89 fa                	mov    %edi,%edx
  802fe0:	83 c4 1c             	add    $0x1c,%esp
  802fe3:	5b                   	pop    %ebx
  802fe4:	5e                   	pop    %esi
  802fe5:	5f                   	pop    %edi
  802fe6:	5d                   	pop    %ebp
  802fe7:	c3                   	ret    
  802fe8:	39 ce                	cmp    %ecx,%esi
  802fea:	77 28                	ja     803014 <__udivdi3+0x7c>
  802fec:	0f bd fe             	bsr    %esi,%edi
  802fef:	83 f7 1f             	xor    $0x1f,%edi
  802ff2:	75 40                	jne    803034 <__udivdi3+0x9c>
  802ff4:	39 ce                	cmp    %ecx,%esi
  802ff6:	72 0a                	jb     803002 <__udivdi3+0x6a>
  802ff8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ffc:	0f 87 9e 00 00 00    	ja     8030a0 <__udivdi3+0x108>
  803002:	b8 01 00 00 00       	mov    $0x1,%eax
  803007:	89 fa                	mov    %edi,%edx
  803009:	83 c4 1c             	add    $0x1c,%esp
  80300c:	5b                   	pop    %ebx
  80300d:	5e                   	pop    %esi
  80300e:	5f                   	pop    %edi
  80300f:	5d                   	pop    %ebp
  803010:	c3                   	ret    
  803011:	8d 76 00             	lea    0x0(%esi),%esi
  803014:	31 ff                	xor    %edi,%edi
  803016:	31 c0                	xor    %eax,%eax
  803018:	89 fa                	mov    %edi,%edx
  80301a:	83 c4 1c             	add    $0x1c,%esp
  80301d:	5b                   	pop    %ebx
  80301e:	5e                   	pop    %esi
  80301f:	5f                   	pop    %edi
  803020:	5d                   	pop    %ebp
  803021:	c3                   	ret    
  803022:	66 90                	xchg   %ax,%ax
  803024:	89 d8                	mov    %ebx,%eax
  803026:	f7 f7                	div    %edi
  803028:	31 ff                	xor    %edi,%edi
  80302a:	89 fa                	mov    %edi,%edx
  80302c:	83 c4 1c             	add    $0x1c,%esp
  80302f:	5b                   	pop    %ebx
  803030:	5e                   	pop    %esi
  803031:	5f                   	pop    %edi
  803032:	5d                   	pop    %ebp
  803033:	c3                   	ret    
  803034:	bd 20 00 00 00       	mov    $0x20,%ebp
  803039:	89 eb                	mov    %ebp,%ebx
  80303b:	29 fb                	sub    %edi,%ebx
  80303d:	89 f9                	mov    %edi,%ecx
  80303f:	d3 e6                	shl    %cl,%esi
  803041:	89 c5                	mov    %eax,%ebp
  803043:	88 d9                	mov    %bl,%cl
  803045:	d3 ed                	shr    %cl,%ebp
  803047:	89 e9                	mov    %ebp,%ecx
  803049:	09 f1                	or     %esi,%ecx
  80304b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80304f:	89 f9                	mov    %edi,%ecx
  803051:	d3 e0                	shl    %cl,%eax
  803053:	89 c5                	mov    %eax,%ebp
  803055:	89 d6                	mov    %edx,%esi
  803057:	88 d9                	mov    %bl,%cl
  803059:	d3 ee                	shr    %cl,%esi
  80305b:	89 f9                	mov    %edi,%ecx
  80305d:	d3 e2                	shl    %cl,%edx
  80305f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803063:	88 d9                	mov    %bl,%cl
  803065:	d3 e8                	shr    %cl,%eax
  803067:	09 c2                	or     %eax,%edx
  803069:	89 d0                	mov    %edx,%eax
  80306b:	89 f2                	mov    %esi,%edx
  80306d:	f7 74 24 0c          	divl   0xc(%esp)
  803071:	89 d6                	mov    %edx,%esi
  803073:	89 c3                	mov    %eax,%ebx
  803075:	f7 e5                	mul    %ebp
  803077:	39 d6                	cmp    %edx,%esi
  803079:	72 19                	jb     803094 <__udivdi3+0xfc>
  80307b:	74 0b                	je     803088 <__udivdi3+0xf0>
  80307d:	89 d8                	mov    %ebx,%eax
  80307f:	31 ff                	xor    %edi,%edi
  803081:	e9 58 ff ff ff       	jmp    802fde <__udivdi3+0x46>
  803086:	66 90                	xchg   %ax,%ax
  803088:	8b 54 24 08          	mov    0x8(%esp),%edx
  80308c:	89 f9                	mov    %edi,%ecx
  80308e:	d3 e2                	shl    %cl,%edx
  803090:	39 c2                	cmp    %eax,%edx
  803092:	73 e9                	jae    80307d <__udivdi3+0xe5>
  803094:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803097:	31 ff                	xor    %edi,%edi
  803099:	e9 40 ff ff ff       	jmp    802fde <__udivdi3+0x46>
  80309e:	66 90                	xchg   %ax,%ax
  8030a0:	31 c0                	xor    %eax,%eax
  8030a2:	e9 37 ff ff ff       	jmp    802fde <__udivdi3+0x46>
  8030a7:	90                   	nop

008030a8 <__umoddi3>:
  8030a8:	55                   	push   %ebp
  8030a9:	57                   	push   %edi
  8030aa:	56                   	push   %esi
  8030ab:	53                   	push   %ebx
  8030ac:	83 ec 1c             	sub    $0x1c,%esp
  8030af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030c7:	89 f3                	mov    %esi,%ebx
  8030c9:	89 fa                	mov    %edi,%edx
  8030cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030cf:	89 34 24             	mov    %esi,(%esp)
  8030d2:	85 c0                	test   %eax,%eax
  8030d4:	75 1a                	jne    8030f0 <__umoddi3+0x48>
  8030d6:	39 f7                	cmp    %esi,%edi
  8030d8:	0f 86 a2 00 00 00    	jbe    803180 <__umoddi3+0xd8>
  8030de:	89 c8                	mov    %ecx,%eax
  8030e0:	89 f2                	mov    %esi,%edx
  8030e2:	f7 f7                	div    %edi
  8030e4:	89 d0                	mov    %edx,%eax
  8030e6:	31 d2                	xor    %edx,%edx
  8030e8:	83 c4 1c             	add    $0x1c,%esp
  8030eb:	5b                   	pop    %ebx
  8030ec:	5e                   	pop    %esi
  8030ed:	5f                   	pop    %edi
  8030ee:	5d                   	pop    %ebp
  8030ef:	c3                   	ret    
  8030f0:	39 f0                	cmp    %esi,%eax
  8030f2:	0f 87 ac 00 00 00    	ja     8031a4 <__umoddi3+0xfc>
  8030f8:	0f bd e8             	bsr    %eax,%ebp
  8030fb:	83 f5 1f             	xor    $0x1f,%ebp
  8030fe:	0f 84 ac 00 00 00    	je     8031b0 <__umoddi3+0x108>
  803104:	bf 20 00 00 00       	mov    $0x20,%edi
  803109:	29 ef                	sub    %ebp,%edi
  80310b:	89 fe                	mov    %edi,%esi
  80310d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803111:	89 e9                	mov    %ebp,%ecx
  803113:	d3 e0                	shl    %cl,%eax
  803115:	89 d7                	mov    %edx,%edi
  803117:	89 f1                	mov    %esi,%ecx
  803119:	d3 ef                	shr    %cl,%edi
  80311b:	09 c7                	or     %eax,%edi
  80311d:	89 e9                	mov    %ebp,%ecx
  80311f:	d3 e2                	shl    %cl,%edx
  803121:	89 14 24             	mov    %edx,(%esp)
  803124:	89 d8                	mov    %ebx,%eax
  803126:	d3 e0                	shl    %cl,%eax
  803128:	89 c2                	mov    %eax,%edx
  80312a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80312e:	d3 e0                	shl    %cl,%eax
  803130:	89 44 24 04          	mov    %eax,0x4(%esp)
  803134:	8b 44 24 08          	mov    0x8(%esp),%eax
  803138:	89 f1                	mov    %esi,%ecx
  80313a:	d3 e8                	shr    %cl,%eax
  80313c:	09 d0                	or     %edx,%eax
  80313e:	d3 eb                	shr    %cl,%ebx
  803140:	89 da                	mov    %ebx,%edx
  803142:	f7 f7                	div    %edi
  803144:	89 d3                	mov    %edx,%ebx
  803146:	f7 24 24             	mull   (%esp)
  803149:	89 c6                	mov    %eax,%esi
  80314b:	89 d1                	mov    %edx,%ecx
  80314d:	39 d3                	cmp    %edx,%ebx
  80314f:	0f 82 87 00 00 00    	jb     8031dc <__umoddi3+0x134>
  803155:	0f 84 91 00 00 00    	je     8031ec <__umoddi3+0x144>
  80315b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80315f:	29 f2                	sub    %esi,%edx
  803161:	19 cb                	sbb    %ecx,%ebx
  803163:	89 d8                	mov    %ebx,%eax
  803165:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803169:	d3 e0                	shl    %cl,%eax
  80316b:	89 e9                	mov    %ebp,%ecx
  80316d:	d3 ea                	shr    %cl,%edx
  80316f:	09 d0                	or     %edx,%eax
  803171:	89 e9                	mov    %ebp,%ecx
  803173:	d3 eb                	shr    %cl,%ebx
  803175:	89 da                	mov    %ebx,%edx
  803177:	83 c4 1c             	add    $0x1c,%esp
  80317a:	5b                   	pop    %ebx
  80317b:	5e                   	pop    %esi
  80317c:	5f                   	pop    %edi
  80317d:	5d                   	pop    %ebp
  80317e:	c3                   	ret    
  80317f:	90                   	nop
  803180:	89 fd                	mov    %edi,%ebp
  803182:	85 ff                	test   %edi,%edi
  803184:	75 0b                	jne    803191 <__umoddi3+0xe9>
  803186:	b8 01 00 00 00       	mov    $0x1,%eax
  80318b:	31 d2                	xor    %edx,%edx
  80318d:	f7 f7                	div    %edi
  80318f:	89 c5                	mov    %eax,%ebp
  803191:	89 f0                	mov    %esi,%eax
  803193:	31 d2                	xor    %edx,%edx
  803195:	f7 f5                	div    %ebp
  803197:	89 c8                	mov    %ecx,%eax
  803199:	f7 f5                	div    %ebp
  80319b:	89 d0                	mov    %edx,%eax
  80319d:	e9 44 ff ff ff       	jmp    8030e6 <__umoddi3+0x3e>
  8031a2:	66 90                	xchg   %ax,%ax
  8031a4:	89 c8                	mov    %ecx,%eax
  8031a6:	89 f2                	mov    %esi,%edx
  8031a8:	83 c4 1c             	add    $0x1c,%esp
  8031ab:	5b                   	pop    %ebx
  8031ac:	5e                   	pop    %esi
  8031ad:	5f                   	pop    %edi
  8031ae:	5d                   	pop    %ebp
  8031af:	c3                   	ret    
  8031b0:	3b 04 24             	cmp    (%esp),%eax
  8031b3:	72 06                	jb     8031bb <__umoddi3+0x113>
  8031b5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031b9:	77 0f                	ja     8031ca <__umoddi3+0x122>
  8031bb:	89 f2                	mov    %esi,%edx
  8031bd:	29 f9                	sub    %edi,%ecx
  8031bf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031c3:	89 14 24             	mov    %edx,(%esp)
  8031c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031ca:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031ce:	8b 14 24             	mov    (%esp),%edx
  8031d1:	83 c4 1c             	add    $0x1c,%esp
  8031d4:	5b                   	pop    %ebx
  8031d5:	5e                   	pop    %esi
  8031d6:	5f                   	pop    %edi
  8031d7:	5d                   	pop    %ebp
  8031d8:	c3                   	ret    
  8031d9:	8d 76 00             	lea    0x0(%esi),%esi
  8031dc:	2b 04 24             	sub    (%esp),%eax
  8031df:	19 fa                	sbb    %edi,%edx
  8031e1:	89 d1                	mov    %edx,%ecx
  8031e3:	89 c6                	mov    %eax,%esi
  8031e5:	e9 71 ff ff ff       	jmp    80315b <__umoddi3+0xb3>
  8031ea:	66 90                	xchg   %ax,%ax
  8031ec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031f0:	72 ea                	jb     8031dc <__umoddi3+0x134>
  8031f2:	89 d9                	mov    %ebx,%ecx
  8031f4:	e9 62 ff ff ff       	jmp    80315b <__umoddi3+0xb3>
