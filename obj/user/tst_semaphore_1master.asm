
obj/user/tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 8d 01 00 00       	call   8001c3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 cd 14 00 00       	call   801510 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 20 1a 80 00       	push   $0x801a20
  800050:	e8 55 13 00 00       	call   8013aa <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 24 1a 80 00       	push   $0x801a24
  800062:	e8 43 13 00 00       	call   8013aa <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80006a:	a1 20 20 80 00       	mov    0x802020,%eax
  80006f:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800075:	a1 20 20 80 00       	mov    0x802020,%eax
  80007a:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800080:	89 c1                	mov    %eax,%ecx
  800082:	a1 20 20 80 00       	mov    0x802020,%eax
  800087:	8b 40 74             	mov    0x74(%eax),%eax
  80008a:	52                   	push   %edx
  80008b:	51                   	push   %ecx
  80008c:	50                   	push   %eax
  80008d:	68 2c 1a 80 00       	push   $0x801a2c
  800092:	e8 24 14 00 00       	call   8014bb <sys_create_env>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  80009d:	a1 20 20 80 00       	mov    0x802020,%eax
  8000a2:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000a8:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ad:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000b3:	89 c1                	mov    %eax,%ecx
  8000b5:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ba:	8b 40 74             	mov    0x74(%eax),%eax
  8000bd:	52                   	push   %edx
  8000be:	51                   	push   %ecx
  8000bf:	50                   	push   %eax
  8000c0:	68 2c 1a 80 00       	push   $0x801a2c
  8000c5:	e8 f1 13 00 00       	call   8014bb <sys_create_env>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000d0:	a1 20 20 80 00       	mov    0x802020,%eax
  8000d5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000db:	a1 20 20 80 00       	mov    0x802020,%eax
  8000e0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000e6:	89 c1                	mov    %eax,%ecx
  8000e8:	a1 20 20 80 00       	mov    0x802020,%eax
  8000ed:	8b 40 74             	mov    0x74(%eax),%eax
  8000f0:	52                   	push   %edx
  8000f1:	51                   	push   %ecx
  8000f2:	50                   	push   %eax
  8000f3:	68 2c 1a 80 00       	push   $0x801a2c
  8000f8:	e8 be 13 00 00       	call   8014bb <sys_create_env>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(id1);
  800103:	83 ec 0c             	sub    $0xc,%esp
  800106:	ff 75 f0             	pushl  -0x10(%ebp)
  800109:	e8 cb 13 00 00       	call   8014d9 <sys_run_env>
  80010e:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 ec             	pushl  -0x14(%ebp)
  800117:	e8 bd 13 00 00       	call   8014d9 <sys_run_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e8             	pushl  -0x18(%ebp)
  800125:	e8 af 13 00 00       	call   8014d9 <sys_run_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	68 24 1a 80 00       	push   $0x801a24
  800135:	ff 75 f4             	pushl  -0xc(%ebp)
  800138:	e8 a6 12 00 00       	call   8013e3 <sys_waitSemaphore>
  80013d:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800140:	83 ec 08             	sub    $0x8,%esp
  800143:	68 24 1a 80 00       	push   $0x801a24
  800148:	ff 75 f4             	pushl  -0xc(%ebp)
  80014b:	e8 93 12 00 00       	call   8013e3 <sys_waitSemaphore>
  800150:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	68 24 1a 80 00       	push   $0x801a24
  80015b:	ff 75 f4             	pushl  -0xc(%ebp)
  80015e:	e8 80 12 00 00       	call   8013e3 <sys_waitSemaphore>
  800163:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  800166:	83 ec 08             	sub    $0x8,%esp
  800169:	68 20 1a 80 00       	push   $0x801a20
  80016e:	ff 75 f4             	pushl  -0xc(%ebp)
  800171:	e8 50 12 00 00       	call   8013c6 <sys_getSemaphoreValue>
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  80017c:	83 ec 08             	sub    $0x8,%esp
  80017f:	68 24 1a 80 00       	push   $0x801a24
  800184:	ff 75 f4             	pushl  -0xc(%ebp)
  800187:	e8 3a 12 00 00       	call   8013c6 <sys_getSemaphoreValue>
  80018c:	83 c4 10             	add    $0x10,%esp
  80018f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  800192:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800196:	75 18                	jne    8001b0 <_main+0x178>
  800198:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80019c:	75 12                	jne    8001b0 <_main+0x178>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	68 38 1a 80 00       	push   $0x801a38
  8001a6:	e8 28 02 00 00       	call   8003d3 <cprintf>
  8001ab:	83 c4 10             	add    $0x10,%esp
  8001ae:	eb 10                	jmp    8001c0 <_main+0x188>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b0:	83 ec 0c             	sub    $0xc,%esp
  8001b3:	68 80 1a 80 00       	push   $0x801a80
  8001b8:	e8 16 02 00 00       	call   8003d3 <cprintf>
  8001bd:	83 c4 10             	add    $0x10,%esp

	return;
  8001c0:	90                   	nop
}
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001c9:	e8 5b 13 00 00       	call   801529 <sys_getenvindex>
  8001ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001d4:	89 d0                	mov    %edx,%eax
  8001d6:	c1 e0 03             	shl    $0x3,%eax
  8001d9:	01 d0                	add    %edx,%eax
  8001db:	01 c0                	add    %eax,%eax
  8001dd:	01 d0                	add    %edx,%eax
  8001df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e6:	01 d0                	add    %edx,%eax
  8001e8:	c1 e0 04             	shl    $0x4,%eax
  8001eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f0:	a3 20 20 80 00       	mov    %eax,0x802020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001f5:	a1 20 20 80 00       	mov    0x802020,%eax
  8001fa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800200:	84 c0                	test   %al,%al
  800202:	74 0f                	je     800213 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800204:	a1 20 20 80 00       	mov    0x802020,%eax
  800209:	05 5c 05 00 00       	add    $0x55c,%eax
  80020e:	a3 00 20 80 00       	mov    %eax,0x802000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800217:	7e 0a                	jle    800223 <libmain+0x60>
		binaryname = argv[0];
  800219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021c:	8b 00                	mov    (%eax),%eax
  80021e:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	_main(argc, argv);
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	ff 75 0c             	pushl  0xc(%ebp)
  800229:	ff 75 08             	pushl  0x8(%ebp)
  80022c:	e8 07 fe ff ff       	call   800038 <_main>
  800231:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800234:	e8 fd 10 00 00       	call   801336 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	68 e4 1a 80 00       	push   $0x801ae4
  800241:	e8 8d 01 00 00       	call   8003d3 <cprintf>
  800246:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800249:	a1 20 20 80 00       	mov    0x802020,%eax
  80024e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800254:	a1 20 20 80 00       	mov    0x802020,%eax
  800259:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80025f:	83 ec 04             	sub    $0x4,%esp
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 0c 1b 80 00       	push   $0x801b0c
  800269:	e8 65 01 00 00       	call   8003d3 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800271:	a1 20 20 80 00       	mov    0x802020,%eax
  800276:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80027c:	a1 20 20 80 00       	mov    0x802020,%eax
  800281:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800287:	a1 20 20 80 00       	mov    0x802020,%eax
  80028c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800292:	51                   	push   %ecx
  800293:	52                   	push   %edx
  800294:	50                   	push   %eax
  800295:	68 34 1b 80 00       	push   $0x801b34
  80029a:	e8 34 01 00 00       	call   8003d3 <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002a2:	a1 20 20 80 00       	mov    0x802020,%eax
  8002a7:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 8c 1b 80 00       	push   $0x801b8c
  8002b6:	e8 18 01 00 00       	call   8003d3 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 e4 1a 80 00       	push   $0x801ae4
  8002c6:	e8 08 01 00 00       	call   8003d3 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002ce:	e8 7d 10 00 00       	call   801350 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002d3:	e8 19 00 00 00       	call   8002f1 <exit>
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002e1:	83 ec 0c             	sub    $0xc,%esp
  8002e4:	6a 00                	push   $0x0
  8002e6:	e8 0a 12 00 00       	call   8014f5 <sys_destroy_env>
  8002eb:	83 c4 10             	add    $0x10,%esp
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <exit>:

void
exit(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f7:	e8 5f 12 00 00       	call   80155b <sys_exit_env>
}
  8002fc:	90                   	nop
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800305:	8b 45 0c             	mov    0xc(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 48 01             	lea    0x1(%eax),%ecx
  80030d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800310:	89 0a                	mov    %ecx,(%edx)
  800312:	8b 55 08             	mov    0x8(%ebp),%edx
  800315:	88 d1                	mov    %dl,%cl
  800317:	8b 55 0c             	mov    0xc(%ebp),%edx
  80031a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80031e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800321:	8b 00                	mov    (%eax),%eax
  800323:	3d ff 00 00 00       	cmp    $0xff,%eax
  800328:	75 2c                	jne    800356 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80032a:	a0 24 20 80 00       	mov    0x802024,%al
  80032f:	0f b6 c0             	movzbl %al,%eax
  800332:	8b 55 0c             	mov    0xc(%ebp),%edx
  800335:	8b 12                	mov    (%edx),%edx
  800337:	89 d1                	mov    %edx,%ecx
  800339:	8b 55 0c             	mov    0xc(%ebp),%edx
  80033c:	83 c2 08             	add    $0x8,%edx
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	50                   	push   %eax
  800343:	51                   	push   %ecx
  800344:	52                   	push   %edx
  800345:	e8 3e 0e 00 00       	call   801188 <sys_cputs>
  80034a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80034d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	8b 40 04             	mov    0x4(%eax),%eax
  80035c:	8d 50 01             	lea    0x1(%eax),%edx
  80035f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800362:	89 50 04             	mov    %edx,0x4(%eax)
}
  800365:	90                   	nop
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800371:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800378:	00 00 00 
	b.cnt = 0;
  80037b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800382:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800385:	ff 75 0c             	pushl  0xc(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800391:	50                   	push   %eax
  800392:	68 ff 02 80 00       	push   $0x8002ff
  800397:	e8 11 02 00 00       	call   8005ad <vprintfmt>
  80039c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80039f:	a0 24 20 80 00       	mov    0x802024,%al
  8003a4:	0f b6 c0             	movzbl %al,%eax
  8003a7:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	50                   	push   %eax
  8003b1:	52                   	push   %edx
  8003b2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003b8:	83 c0 08             	add    $0x8,%eax
  8003bb:	50                   	push   %eax
  8003bc:	e8 c7 0d 00 00       	call   801188 <sys_cputs>
  8003c1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8003c4:	c6 05 24 20 80 00 00 	movb   $0x0,0x802024
	return b.cnt;
  8003cb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <cprintf>:

int cprintf(const char *fmt, ...) {
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8003d9:	c6 05 24 20 80 00 01 	movb   $0x1,0x802024
	va_start(ap, fmt);
  8003e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ef:	50                   	push   %eax
  8003f0:	e8 73 ff ff ff       	call   800368 <vcprintf>
  8003f5:	83 c4 10             	add    $0x10,%esp
  8003f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003fe:	c9                   	leave  
  8003ff:	c3                   	ret    

00800400 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800406:	e8 2b 0f 00 00       	call   801336 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80040b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80040e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	ff 75 f4             	pushl  -0xc(%ebp)
  80041a:	50                   	push   %eax
  80041b:	e8 48 ff ff ff       	call   800368 <vcprintf>
  800420:	83 c4 10             	add    $0x10,%esp
  800423:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800426:	e8 25 0f 00 00       	call   801350 <sys_enable_interrupt>
	return cnt;
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80042e:	c9                   	leave  
  80042f:	c3                   	ret    

00800430 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	53                   	push   %ebx
  800434:	83 ec 14             	sub    $0x14,%esp
  800437:	8b 45 10             	mov    0x10(%ebp),%eax
  80043a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80043d:	8b 45 14             	mov    0x14(%ebp),%eax
  800440:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800443:	8b 45 18             	mov    0x18(%ebp),%eax
  800446:	ba 00 00 00 00       	mov    $0x0,%edx
  80044b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80044e:	77 55                	ja     8004a5 <printnum+0x75>
  800450:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800453:	72 05                	jb     80045a <printnum+0x2a>
  800455:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800458:	77 4b                	ja     8004a5 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80045a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80045d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800460:	8b 45 18             	mov    0x18(%ebp),%eax
  800463:	ba 00 00 00 00       	mov    $0x0,%edx
  800468:	52                   	push   %edx
  800469:	50                   	push   %eax
  80046a:	ff 75 f4             	pushl  -0xc(%ebp)
  80046d:	ff 75 f0             	pushl  -0x10(%ebp)
  800470:	e8 47 13 00 00       	call   8017bc <__udivdi3>
  800475:	83 c4 10             	add    $0x10,%esp
  800478:	83 ec 04             	sub    $0x4,%esp
  80047b:	ff 75 20             	pushl  0x20(%ebp)
  80047e:	53                   	push   %ebx
  80047f:	ff 75 18             	pushl  0x18(%ebp)
  800482:	52                   	push   %edx
  800483:	50                   	push   %eax
  800484:	ff 75 0c             	pushl  0xc(%ebp)
  800487:	ff 75 08             	pushl  0x8(%ebp)
  80048a:	e8 a1 ff ff ff       	call   800430 <printnum>
  80048f:	83 c4 20             	add    $0x20,%esp
  800492:	eb 1a                	jmp    8004ae <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800494:	83 ec 08             	sub    $0x8,%esp
  800497:	ff 75 0c             	pushl  0xc(%ebp)
  80049a:	ff 75 20             	pushl  0x20(%ebp)
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	ff d0                	call   *%eax
  8004a2:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004a5:	ff 4d 1c             	decl   0x1c(%ebp)
  8004a8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004ac:	7f e6                	jg     800494 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ae:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8004b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8004bc:	53                   	push   %ebx
  8004bd:	51                   	push   %ecx
  8004be:	52                   	push   %edx
  8004bf:	50                   	push   %eax
  8004c0:	e8 07 14 00 00       	call   8018cc <__umoddi3>
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	05 b4 1d 80 00       	add    $0x801db4,%eax
  8004cd:	8a 00                	mov    (%eax),%al
  8004cf:	0f be c0             	movsbl %al,%eax
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	ff 75 0c             	pushl  0xc(%ebp)
  8004d8:	50                   	push   %eax
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	ff d0                	call   *%eax
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004e5:	c9                   	leave  
  8004e6:	c3                   	ret    

008004e7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ea:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ee:	7e 1c                	jle    80050c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f3:	8b 00                	mov    (%eax),%eax
  8004f5:	8d 50 08             	lea    0x8(%eax),%edx
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	89 10                	mov    %edx,(%eax)
  8004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800500:	8b 00                	mov    (%eax),%eax
  800502:	83 e8 08             	sub    $0x8,%eax
  800505:	8b 50 04             	mov    0x4(%eax),%edx
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	eb 40                	jmp    80054c <getuint+0x65>
	else if (lflag)
  80050c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800510:	74 1e                	je     800530 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800512:	8b 45 08             	mov    0x8(%ebp),%eax
  800515:	8b 00                	mov    (%eax),%eax
  800517:	8d 50 04             	lea    0x4(%eax),%edx
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 10                	mov    %edx,(%eax)
  80051f:	8b 45 08             	mov    0x8(%ebp),%eax
  800522:	8b 00                	mov    (%eax),%eax
  800524:	83 e8 04             	sub    $0x4,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	ba 00 00 00 00       	mov    $0x0,%edx
  80052e:	eb 1c                	jmp    80054c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800530:	8b 45 08             	mov    0x8(%ebp),%eax
  800533:	8b 00                	mov    (%eax),%eax
  800535:	8d 50 04             	lea    0x4(%eax),%edx
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	89 10                	mov    %edx,(%eax)
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	83 e8 04             	sub    $0x4,%eax
  800545:	8b 00                	mov    (%eax),%eax
  800547:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80054c:	5d                   	pop    %ebp
  80054d:	c3                   	ret    

0080054e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800551:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800555:	7e 1c                	jle    800573 <getint+0x25>
		return va_arg(*ap, long long);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	8d 50 08             	lea    0x8(%eax),%edx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	89 10                	mov    %edx,(%eax)
  800564:	8b 45 08             	mov    0x8(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	83 e8 08             	sub    $0x8,%eax
  80056c:	8b 50 04             	mov    0x4(%eax),%edx
  80056f:	8b 00                	mov    (%eax),%eax
  800571:	eb 38                	jmp    8005ab <getint+0x5d>
	else if (lflag)
  800573:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800577:	74 1a                	je     800593 <getint+0x45>
		return va_arg(*ap, long);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	8d 50 04             	lea    0x4(%eax),%edx
  800581:	8b 45 08             	mov    0x8(%ebp),%eax
  800584:	89 10                	mov    %edx,(%eax)
  800586:	8b 45 08             	mov    0x8(%ebp),%eax
  800589:	8b 00                	mov    (%eax),%eax
  80058b:	83 e8 04             	sub    $0x4,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	99                   	cltd   
  800591:	eb 18                	jmp    8005ab <getint+0x5d>
	else
		return va_arg(*ap, int);
  800593:	8b 45 08             	mov    0x8(%ebp),%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	8d 50 04             	lea    0x4(%eax),%edx
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	89 10                	mov    %edx,(%eax)
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	83 e8 04             	sub    $0x4,%eax
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	99                   	cltd   
}
  8005ab:	5d                   	pop    %ebp
  8005ac:	c3                   	ret    

008005ad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	56                   	push   %esi
  8005b1:	53                   	push   %ebx
  8005b2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005b5:	eb 17                	jmp    8005ce <vprintfmt+0x21>
			if (ch == '\0')
  8005b7:	85 db                	test   %ebx,%ebx
  8005b9:	0f 84 af 03 00 00    	je     80096e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8005bf:	83 ec 08             	sub    $0x8,%esp
  8005c2:	ff 75 0c             	pushl  0xc(%ebp)
  8005c5:	53                   	push   %ebx
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	ff d0                	call   *%eax
  8005cb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	8d 50 01             	lea    0x1(%eax),%edx
  8005d4:	89 55 10             	mov    %edx,0x10(%ebp)
  8005d7:	8a 00                	mov    (%eax),%al
  8005d9:	0f b6 d8             	movzbl %al,%ebx
  8005dc:	83 fb 25             	cmp    $0x25,%ebx
  8005df:	75 d6                	jne    8005b7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005e1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005e5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005ec:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	8d 50 01             	lea    0x1(%eax),%edx
  800607:	89 55 10             	mov    %edx,0x10(%ebp)
  80060a:	8a 00                	mov    (%eax),%al
  80060c:	0f b6 d8             	movzbl %al,%ebx
  80060f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800612:	83 f8 55             	cmp    $0x55,%eax
  800615:	0f 87 2b 03 00 00    	ja     800946 <vprintfmt+0x399>
  80061b:	8b 04 85 d8 1d 80 00 	mov    0x801dd8(,%eax,4),%eax
  800622:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800624:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800628:	eb d7                	jmp    800601 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80062a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80062e:	eb d1                	jmp    800601 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800630:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800637:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80063a:	89 d0                	mov    %edx,%eax
  80063c:	c1 e0 02             	shl    $0x2,%eax
  80063f:	01 d0                	add    %edx,%eax
  800641:	01 c0                	add    %eax,%eax
  800643:	01 d8                	add    %ebx,%eax
  800645:	83 e8 30             	sub    $0x30,%eax
  800648:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80064b:	8b 45 10             	mov    0x10(%ebp),%eax
  80064e:	8a 00                	mov    (%eax),%al
  800650:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800653:	83 fb 2f             	cmp    $0x2f,%ebx
  800656:	7e 3e                	jle    800696 <vprintfmt+0xe9>
  800658:	83 fb 39             	cmp    $0x39,%ebx
  80065b:	7f 39                	jg     800696 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80065d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800660:	eb d5                	jmp    800637 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	83 c0 04             	add    $0x4,%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	83 e8 04             	sub    $0x4,%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800676:	eb 1f                	jmp    800697 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067c:	79 83                	jns    800601 <vprintfmt+0x54>
				width = 0;
  80067e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800685:	e9 77 ff ff ff       	jmp    800601 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80068a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800691:	e9 6b ff ff ff       	jmp    800601 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800696:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800697:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069b:	0f 89 60 ff ff ff    	jns    800601 <vprintfmt+0x54>
				width = precision, precision = -1;
  8006a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a7:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8006ae:	e9 4e ff ff ff       	jmp    800601 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006b3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8006b6:	e9 46 ff ff ff       	jmp    800601 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	83 c0 04             	add    $0x4,%eax
  8006c1:	89 45 14             	mov    %eax,0x14(%ebp)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	83 e8 04             	sub    $0x4,%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	50                   	push   %eax
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	ff d0                	call   *%eax
  8006d8:	83 c4 10             	add    $0x10,%esp
			break;
  8006db:	e9 89 02 00 00       	jmp    800969 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	83 c0 04             	add    $0x4,%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 e8 04             	sub    $0x4,%eax
  8006ef:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006f1:	85 db                	test   %ebx,%ebx
  8006f3:	79 02                	jns    8006f7 <vprintfmt+0x14a>
				err = -err;
  8006f5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006f7:	83 fb 64             	cmp    $0x64,%ebx
  8006fa:	7f 0b                	jg     800707 <vprintfmt+0x15a>
  8006fc:	8b 34 9d 20 1c 80 00 	mov    0x801c20(,%ebx,4),%esi
  800703:	85 f6                	test   %esi,%esi
  800705:	75 19                	jne    800720 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800707:	53                   	push   %ebx
  800708:	68 c5 1d 80 00       	push   $0x801dc5
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	e8 5e 02 00 00       	call   800976 <printfmt>
  800718:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80071b:	e9 49 02 00 00       	jmp    800969 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800720:	56                   	push   %esi
  800721:	68 ce 1d 80 00       	push   $0x801dce
  800726:	ff 75 0c             	pushl  0xc(%ebp)
  800729:	ff 75 08             	pushl  0x8(%ebp)
  80072c:	e8 45 02 00 00       	call   800976 <printfmt>
  800731:	83 c4 10             	add    $0x10,%esp
			break;
  800734:	e9 30 02 00 00       	jmp    800969 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	83 c0 04             	add    $0x4,%eax
  80073f:	89 45 14             	mov    %eax,0x14(%ebp)
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 e8 04             	sub    $0x4,%eax
  800748:	8b 30                	mov    (%eax),%esi
  80074a:	85 f6                	test   %esi,%esi
  80074c:	75 05                	jne    800753 <vprintfmt+0x1a6>
				p = "(null)";
  80074e:	be d1 1d 80 00       	mov    $0x801dd1,%esi
			if (width > 0 && padc != '-')
  800753:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800757:	7e 6d                	jle    8007c6 <vprintfmt+0x219>
  800759:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80075d:	74 67                	je     8007c6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80075f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800762:	83 ec 08             	sub    $0x8,%esp
  800765:	50                   	push   %eax
  800766:	56                   	push   %esi
  800767:	e8 0c 03 00 00       	call   800a78 <strnlen>
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800772:	eb 16                	jmp    80078a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800774:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	50                   	push   %eax
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	ff d0                	call   *%eax
  800784:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800787:	ff 4d e4             	decl   -0x1c(%ebp)
  80078a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078e:	7f e4                	jg     800774 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800790:	eb 34                	jmp    8007c6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800792:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800796:	74 1c                	je     8007b4 <vprintfmt+0x207>
  800798:	83 fb 1f             	cmp    $0x1f,%ebx
  80079b:	7e 05                	jle    8007a2 <vprintfmt+0x1f5>
  80079d:	83 fb 7e             	cmp    $0x7e,%ebx
  8007a0:	7e 12                	jle    8007b4 <vprintfmt+0x207>
					putch('?', putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	6a 3f                	push   $0x3f
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	ff d0                	call   *%eax
  8007af:	83 c4 10             	add    $0x10,%esp
  8007b2:	eb 0f                	jmp    8007c3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8007b4:	83 ec 08             	sub    $0x8,%esp
  8007b7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ba:	53                   	push   %ebx
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	ff d0                	call   *%eax
  8007c0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8007c6:	89 f0                	mov    %esi,%eax
  8007c8:	8d 70 01             	lea    0x1(%eax),%esi
  8007cb:	8a 00                	mov    (%eax),%al
  8007cd:	0f be d8             	movsbl %al,%ebx
  8007d0:	85 db                	test   %ebx,%ebx
  8007d2:	74 24                	je     8007f8 <vprintfmt+0x24b>
  8007d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007d8:	78 b8                	js     800792 <vprintfmt+0x1e5>
  8007da:	ff 4d e0             	decl   -0x20(%ebp)
  8007dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007e1:	79 af                	jns    800792 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007e3:	eb 13                	jmp    8007f8 <vprintfmt+0x24b>
				putch(' ', putdat);
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 0c             	pushl  0xc(%ebp)
  8007eb:	6a 20                	push   $0x20
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	ff d0                	call   *%eax
  8007f2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007f5:	ff 4d e4             	decl   -0x1c(%ebp)
  8007f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fc:	7f e7                	jg     8007e5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007fe:	e9 66 01 00 00       	jmp    800969 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800803:	83 ec 08             	sub    $0x8,%esp
  800806:	ff 75 e8             	pushl  -0x18(%ebp)
  800809:	8d 45 14             	lea    0x14(%ebp),%eax
  80080c:	50                   	push   %eax
  80080d:	e8 3c fd ff ff       	call   80054e <getint>
  800812:	83 c4 10             	add    $0x10,%esp
  800815:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800818:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800821:	85 d2                	test   %edx,%edx
  800823:	79 23                	jns    800848 <vprintfmt+0x29b>
				putch('-', putdat);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	6a 2d                	push   $0x2d
  80082d:	8b 45 08             	mov    0x8(%ebp),%eax
  800830:	ff d0                	call   *%eax
  800832:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800838:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80083b:	f7 d8                	neg    %eax
  80083d:	83 d2 00             	adc    $0x0,%edx
  800840:	f7 da                	neg    %edx
  800842:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800845:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800848:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80084f:	e9 bc 00 00 00       	jmp    800910 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800854:	83 ec 08             	sub    $0x8,%esp
  800857:	ff 75 e8             	pushl  -0x18(%ebp)
  80085a:	8d 45 14             	lea    0x14(%ebp),%eax
  80085d:	50                   	push   %eax
  80085e:	e8 84 fc ff ff       	call   8004e7 <getuint>
  800863:	83 c4 10             	add    $0x10,%esp
  800866:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800869:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80086c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800873:	e9 98 00 00 00       	jmp    800910 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800878:	83 ec 08             	sub    $0x8,%esp
  80087b:	ff 75 0c             	pushl  0xc(%ebp)
  80087e:	6a 58                	push   $0x58
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	ff d0                	call   *%eax
  800885:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800888:	83 ec 08             	sub    $0x8,%esp
  80088b:	ff 75 0c             	pushl  0xc(%ebp)
  80088e:	6a 58                	push   $0x58
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800898:	83 ec 08             	sub    $0x8,%esp
  80089b:	ff 75 0c             	pushl  0xc(%ebp)
  80089e:	6a 58                	push   $0x58
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	ff d0                	call   *%eax
  8008a5:	83 c4 10             	add    $0x10,%esp
			break;
  8008a8:	e9 bc 00 00 00       	jmp    800969 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	6a 30                	push   $0x30
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	ff d0                	call   *%eax
  8008ba:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8008bd:	83 ec 08             	sub    $0x8,%esp
  8008c0:	ff 75 0c             	pushl  0xc(%ebp)
  8008c3:	6a 78                	push   $0x78
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	ff d0                	call   *%eax
  8008ca:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	83 c0 04             	add    $0x4,%eax
  8008d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 e8 04             	sub    $0x4,%eax
  8008dc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008e8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008ef:	eb 1f                	jmp    800910 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008f1:	83 ec 08             	sub    $0x8,%esp
  8008f4:	ff 75 e8             	pushl  -0x18(%ebp)
  8008f7:	8d 45 14             	lea    0x14(%ebp),%eax
  8008fa:	50                   	push   %eax
  8008fb:	e8 e7 fb ff ff       	call   8004e7 <getuint>
  800900:	83 c4 10             	add    $0x10,%esp
  800903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800906:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800909:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800910:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800914:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800917:	83 ec 04             	sub    $0x4,%esp
  80091a:	52                   	push   %edx
  80091b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80091e:	50                   	push   %eax
  80091f:	ff 75 f4             	pushl  -0xc(%ebp)
  800922:	ff 75 f0             	pushl  -0x10(%ebp)
  800925:	ff 75 0c             	pushl  0xc(%ebp)
  800928:	ff 75 08             	pushl  0x8(%ebp)
  80092b:	e8 00 fb ff ff       	call   800430 <printnum>
  800930:	83 c4 20             	add    $0x20,%esp
			break;
  800933:	eb 34                	jmp    800969 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	53                   	push   %ebx
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			break;
  800944:	eb 23                	jmp    800969 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800946:	83 ec 08             	sub    $0x8,%esp
  800949:	ff 75 0c             	pushl  0xc(%ebp)
  80094c:	6a 25                	push   $0x25
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800956:	ff 4d 10             	decl   0x10(%ebp)
  800959:	eb 03                	jmp    80095e <vprintfmt+0x3b1>
  80095b:	ff 4d 10             	decl   0x10(%ebp)
  80095e:	8b 45 10             	mov    0x10(%ebp),%eax
  800961:	48                   	dec    %eax
  800962:	8a 00                	mov    (%eax),%al
  800964:	3c 25                	cmp    $0x25,%al
  800966:	75 f3                	jne    80095b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800968:	90                   	nop
		}
	}
  800969:	e9 47 fc ff ff       	jmp    8005b5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80096e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80096f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800972:	5b                   	pop    %ebx
  800973:	5e                   	pop    %esi
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80097c:	8d 45 10             	lea    0x10(%ebp),%eax
  80097f:	83 c0 04             	add    $0x4,%eax
  800982:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	ff 75 f4             	pushl  -0xc(%ebp)
  80098b:	50                   	push   %eax
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	e8 16 fc ff ff       	call   8005ad <vprintfmt>
  800997:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80099a:	90                   	nop
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8009a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a3:	8b 40 08             	mov    0x8(%eax),%eax
  8009a6:	8d 50 01             	lea    0x1(%eax),%edx
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8009af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b2:	8b 10                	mov    (%eax),%edx
  8009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b7:	8b 40 04             	mov    0x4(%eax),%eax
  8009ba:	39 c2                	cmp    %eax,%edx
  8009bc:	73 12                	jae    8009d0 <sprintputch+0x33>
		*b->buf++ = ch;
  8009be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8009c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c9:	89 0a                	mov    %ecx,(%edx)
  8009cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8009ce:	88 10                	mov    %dl,(%eax)
}
  8009d0:	90                   	nop
  8009d1:	5d                   	pop    %ebp
  8009d2:	c3                   	ret    

008009d3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	01 d0                	add    %edx,%eax
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009f8:	74 06                	je     800a00 <vsnprintf+0x2d>
  8009fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009fe:	7f 07                	jg     800a07 <vsnprintf+0x34>
		return -E_INVAL;
  800a00:	b8 03 00 00 00       	mov    $0x3,%eax
  800a05:	eb 20                	jmp    800a27 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a07:	ff 75 14             	pushl  0x14(%ebp)
  800a0a:	ff 75 10             	pushl  0x10(%ebp)
  800a0d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a10:	50                   	push   %eax
  800a11:	68 9d 09 80 00       	push   $0x80099d
  800a16:	e8 92 fb ff ff       	call   8005ad <vprintfmt>
  800a1b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a21:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a27:	c9                   	leave  
  800a28:	c3                   	ret    

00800a29 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a2f:	8d 45 10             	lea    0x10(%ebp),%eax
  800a32:	83 c0 04             	add    $0x4,%eax
  800a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a38:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a3e:	50                   	push   %eax
  800a3f:	ff 75 0c             	pushl  0xc(%ebp)
  800a42:	ff 75 08             	pushl  0x8(%ebp)
  800a45:	e8 89 ff ff ff       	call   8009d3 <vsnprintf>
  800a4a:	83 c4 10             	add    $0x10,%esp
  800a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a53:	c9                   	leave  
  800a54:	c3                   	ret    

00800a55 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a62:	eb 06                	jmp    800a6a <strlen+0x15>
		n++;
  800a64:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a67:	ff 45 08             	incl   0x8(%ebp)
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8a 00                	mov    (%eax),%al
  800a6f:	84 c0                	test   %al,%al
  800a71:	75 f1                	jne    800a64 <strlen+0xf>
		n++;
	return n;
  800a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a85:	eb 09                	jmp    800a90 <strnlen+0x18>
		n++;
  800a87:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8a:	ff 45 08             	incl   0x8(%ebp)
  800a8d:	ff 4d 0c             	decl   0xc(%ebp)
  800a90:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a94:	74 09                	je     800a9f <strnlen+0x27>
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	8a 00                	mov    (%eax),%al
  800a9b:	84 c0                	test   %al,%al
  800a9d:	75 e8                	jne    800a87 <strnlen+0xf>
		n++;
	return n;
  800a9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aa2:	c9                   	leave  
  800aa3:	c3                   	ret    

00800aa4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ab0:	90                   	nop
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8d 50 01             	lea    0x1(%eax),%edx
  800ab7:	89 55 08             	mov    %edx,0x8(%ebp)
  800aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ac0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ac3:	8a 12                	mov    (%edx),%dl
  800ac5:	88 10                	mov    %dl,(%eax)
  800ac7:	8a 00                	mov    (%eax),%al
  800ac9:	84 c0                	test   %al,%al
  800acb:	75 e4                	jne    800ab1 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    

00800ad2 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ade:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae5:	eb 1f                	jmp    800b06 <strncpy+0x34>
		*dst++ = *src;
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	8d 50 01             	lea    0x1(%eax),%edx
  800aed:	89 55 08             	mov    %edx,0x8(%ebp)
  800af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af3:	8a 12                	mov    (%edx),%dl
  800af5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	8a 00                	mov    (%eax),%al
  800afc:	84 c0                	test   %al,%al
  800afe:	74 03                	je     800b03 <strncpy+0x31>
			src++;
  800b00:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b03:	ff 45 fc             	incl   -0x4(%ebp)
  800b06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b09:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b0c:	72 d9                	jb     800ae7 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    

00800b13 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800b1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b23:	74 30                	je     800b55 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800b25:	eb 16                	jmp    800b3d <strlcpy+0x2a>
			*dst++ = *src++;
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8d 50 01             	lea    0x1(%eax),%edx
  800b2d:	89 55 08             	mov    %edx,0x8(%ebp)
  800b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b33:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b36:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b39:	8a 12                	mov    (%edx),%dl
  800b3b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b3d:	ff 4d 10             	decl   0x10(%ebp)
  800b40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b44:	74 09                	je     800b4f <strlcpy+0x3c>
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	84 c0                	test   %al,%al
  800b4d:	75 d8                	jne    800b27 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b55:	8b 55 08             	mov    0x8(%ebp),%edx
  800b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b5b:	29 c2                	sub    %eax,%edx
  800b5d:	89 d0                	mov    %edx,%eax
}
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b64:	eb 06                	jmp    800b6c <strcmp+0xb>
		p++, q++;
  800b66:	ff 45 08             	incl   0x8(%ebp)
  800b69:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8a 00                	mov    (%eax),%al
  800b71:	84 c0                	test   %al,%al
  800b73:	74 0e                	je     800b83 <strcmp+0x22>
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	8a 10                	mov    (%eax),%dl
  800b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	38 c2                	cmp    %al,%dl
  800b81:	74 e3                	je     800b66 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8a 00                	mov    (%eax),%al
  800b88:	0f b6 d0             	movzbl %al,%edx
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	8a 00                	mov    (%eax),%al
  800b90:	0f b6 c0             	movzbl %al,%eax
  800b93:	29 c2                	sub    %eax,%edx
  800b95:	89 d0                	mov    %edx,%eax
}
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b9c:	eb 09                	jmp    800ba7 <strncmp+0xe>
		n--, p++, q++;
  800b9e:	ff 4d 10             	decl   0x10(%ebp)
  800ba1:	ff 45 08             	incl   0x8(%ebp)
  800ba4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ba7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bab:	74 17                	je     800bc4 <strncmp+0x2b>
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	8a 00                	mov    (%eax),%al
  800bb2:	84 c0                	test   %al,%al
  800bb4:	74 0e                	je     800bc4 <strncmp+0x2b>
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	8a 10                	mov    (%eax),%dl
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8a 00                	mov    (%eax),%al
  800bc0:	38 c2                	cmp    %al,%dl
  800bc2:	74 da                	je     800b9e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800bc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bc8:	75 07                	jne    800bd1 <strncmp+0x38>
		return 0;
  800bca:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcf:	eb 14                	jmp    800be5 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8a 00                	mov    (%eax),%al
  800bd6:	0f b6 d0             	movzbl %al,%edx
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8a 00                	mov    (%eax),%al
  800bde:	0f b6 c0             	movzbl %al,%eax
  800be1:	29 c2                	sub    %eax,%edx
  800be3:	89 d0                	mov    %edx,%eax
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bf3:	eb 12                	jmp    800c07 <strchr+0x20>
		if (*s == c)
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8a 00                	mov    (%eax),%al
  800bfa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bfd:	75 05                	jne    800c04 <strchr+0x1d>
			return (char *) s;
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	eb 11                	jmp    800c15 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c04:	ff 45 08             	incl   0x8(%ebp)
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e5                	jne    800bf5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	83 ec 04             	sub    $0x4,%esp
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c23:	eb 0d                	jmp    800c32 <strfind+0x1b>
		if (*s == c)
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8a 00                	mov    (%eax),%al
  800c2a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c2d:	74 0e                	je     800c3d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c2f:	ff 45 08             	incl   0x8(%ebp)
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	84 c0                	test   %al,%al
  800c39:	75 ea                	jne    800c25 <strfind+0xe>
  800c3b:	eb 01                	jmp    800c3e <strfind+0x27>
		if (*s == c)
			break;
  800c3d:	90                   	nop
	return (char *) s;
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c52:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c55:	eb 0e                	jmp    800c65 <memset+0x22>
		*p++ = c;
  800c57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5a:	8d 50 01             	lea    0x1(%eax),%edx
  800c5d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c63:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c65:	ff 4d f8             	decl   -0x8(%ebp)
  800c68:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c6c:	79 e9                	jns    800c57 <memset+0x14>
		*p++ = c;

	return v;
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c85:	eb 16                	jmp    800c9d <memcpy+0x2a>
		*d++ = *s++;
  800c87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c96:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c99:	8a 12                	mov    (%edx),%dl
  800c9b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	75 dd                	jne    800c87 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cc7:	73 50                	jae    800d19 <memmove+0x6a>
  800cc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ccc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccf:	01 d0                	add    %edx,%eax
  800cd1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800cd4:	76 43                	jbe    800d19 <memmove+0x6a>
		s += n;
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdf:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ce2:	eb 10                	jmp    800cf4 <memmove+0x45>
			*--d = *--s;
  800ce4:	ff 4d f8             	decl   -0x8(%ebp)
  800ce7:	ff 4d fc             	decl   -0x4(%ebp)
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ced:	8a 10                	mov    (%eax),%dl
  800cef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cf4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cfa:	89 55 10             	mov    %edx,0x10(%ebp)
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	75 e3                	jne    800ce4 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d01:	eb 23                	jmp    800d26 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d06:	8d 50 01             	lea    0x1(%eax),%edx
  800d09:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d12:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d15:	8a 12                	mov    (%edx),%dl
  800d17:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800d19:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d1f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d22:	85 c0                	test   %eax,%eax
  800d24:	75 dd                	jne    800d03 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d3d:	eb 2a                	jmp    800d69 <memcmp+0x3e>
		if (*s1 != *s2)
  800d3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 16                	je     800d63 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d0             	movzbl %al,%edx
  800d55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 c0             	movzbl %al,%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
  800d61:	eb 18                	jmp    800d7b <memcmp+0x50>
		s1++, s2++;
  800d63:	ff 45 fc             	incl   -0x4(%ebp)
  800d66:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d69:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	75 c9                	jne    800d3f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d7b:	c9                   	leave  
  800d7c:	c3                   	ret    

00800d7d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	01 d0                	add    %edx,%eax
  800d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d8e:	eb 15                	jmp    800da5 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	0f b6 d0             	movzbl %al,%edx
  800d98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9b:	0f b6 c0             	movzbl %al,%eax
  800d9e:	39 c2                	cmp    %eax,%edx
  800da0:	74 0d                	je     800daf <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800dab:	72 e3                	jb     800d90 <memfind+0x13>
  800dad:	eb 01                	jmp    800db0 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800daf:	90                   	nop
	return (void *) s;
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800dc2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dc9:	eb 03                	jmp    800dce <strtol+0x19>
		s++;
  800dcb:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	3c 20                	cmp    $0x20,%al
  800dd5:	74 f4                	je     800dcb <strtol+0x16>
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3c 09                	cmp    $0x9,%al
  800dde:	74 eb                	je     800dcb <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	3c 2b                	cmp    $0x2b,%al
  800de7:	75 05                	jne    800dee <strtol+0x39>
		s++;
  800de9:	ff 45 08             	incl   0x8(%ebp)
  800dec:	eb 13                	jmp    800e01 <strtol+0x4c>
	else if (*s == '-')
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8a 00                	mov    (%eax),%al
  800df3:	3c 2d                	cmp    $0x2d,%al
  800df5:	75 0a                	jne    800e01 <strtol+0x4c>
		s++, neg = 1;
  800df7:	ff 45 08             	incl   0x8(%ebp)
  800dfa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e05:	74 06                	je     800e0d <strtol+0x58>
  800e07:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e0b:	75 20                	jne    800e2d <strtol+0x78>
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	8a 00                	mov    (%eax),%al
  800e12:	3c 30                	cmp    $0x30,%al
  800e14:	75 17                	jne    800e2d <strtol+0x78>
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	40                   	inc    %eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 78                	cmp    $0x78,%al
  800e1e:	75 0d                	jne    800e2d <strtol+0x78>
		s += 2, base = 16;
  800e20:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e24:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e2b:	eb 28                	jmp    800e55 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e31:	75 15                	jne    800e48 <strtol+0x93>
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	3c 30                	cmp    $0x30,%al
  800e3a:	75 0c                	jne    800e48 <strtol+0x93>
		s++, base = 8;
  800e3c:	ff 45 08             	incl   0x8(%ebp)
  800e3f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e46:	eb 0d                	jmp    800e55 <strtol+0xa0>
	else if (base == 0)
  800e48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4c:	75 07                	jne    800e55 <strtol+0xa0>
		base = 10;
  800e4e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 2f                	cmp    $0x2f,%al
  800e5c:	7e 19                	jle    800e77 <strtol+0xc2>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 39                	cmp    $0x39,%al
  800e65:	7f 10                	jg     800e77 <strtol+0xc2>
			dig = *s - '0';
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	0f be c0             	movsbl %al,%eax
  800e6f:	83 e8 30             	sub    $0x30,%eax
  800e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e75:	eb 42                	jmp    800eb9 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	3c 60                	cmp    $0x60,%al
  800e7e:	7e 19                	jle    800e99 <strtol+0xe4>
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	3c 7a                	cmp    $0x7a,%al
  800e87:	7f 10                	jg     800e99 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f be c0             	movsbl %al,%eax
  800e91:	83 e8 57             	sub    $0x57,%eax
  800e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e97:	eb 20                	jmp    800eb9 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8a 00                	mov    (%eax),%al
  800e9e:	3c 40                	cmp    $0x40,%al
  800ea0:	7e 39                	jle    800edb <strtol+0x126>
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	3c 5a                	cmp    $0x5a,%al
  800ea9:	7f 30                	jg     800edb <strtol+0x126>
			dig = *s - 'A' + 10;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	0f be c0             	movsbl %al,%eax
  800eb3:	83 e8 37             	sub    $0x37,%eax
  800eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ebf:	7d 19                	jge    800eda <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ec1:	ff 45 08             	incl   0x8(%ebp)
  800ec4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ecb:	89 c2                	mov    %eax,%edx
  800ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed0:	01 d0                	add    %edx,%eax
  800ed2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ed5:	e9 7b ff ff ff       	jmp    800e55 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800eda:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800edb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800edf:	74 08                	je     800ee9 <strtol+0x134>
		*endptr = (char *) s;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ee9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800eed:	74 07                	je     800ef6 <strtol+0x141>
  800eef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef2:	f7 d8                	neg    %eax
  800ef4:	eb 03                	jmp    800ef9 <strtol+0x144>
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <ltostr>:

void
ltostr(long value, char *str)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f08:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f0f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f13:	79 13                	jns    800f28 <ltostr+0x2d>
	{
		neg = 1;
  800f15:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800f22:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800f25:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f30:	99                   	cltd   
  800f31:	f7 f9                	idiv   %ecx
  800f33:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f39:	8d 50 01             	lea    0x1(%eax),%edx
  800f3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	01 d0                	add    %edx,%eax
  800f46:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f49:	83 c2 30             	add    $0x30,%edx
  800f4c:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f51:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f56:	f7 e9                	imul   %ecx
  800f58:	c1 fa 02             	sar    $0x2,%edx
  800f5b:	89 c8                	mov    %ecx,%eax
  800f5d:	c1 f8 1f             	sar    $0x1f,%eax
  800f60:	29 c2                	sub    %eax,%edx
  800f62:	89 d0                	mov    %edx,%eax
  800f64:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f6a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f6f:	f7 e9                	imul   %ecx
  800f71:	c1 fa 02             	sar    $0x2,%edx
  800f74:	89 c8                	mov    %ecx,%eax
  800f76:	c1 f8 1f             	sar    $0x1f,%eax
  800f79:	29 c2                	sub    %eax,%edx
  800f7b:	89 d0                	mov    %edx,%eax
  800f7d:	c1 e0 02             	shl    $0x2,%eax
  800f80:	01 d0                	add    %edx,%eax
  800f82:	01 c0                	add    %eax,%eax
  800f84:	29 c1                	sub    %eax,%ecx
  800f86:	89 ca                	mov    %ecx,%edx
  800f88:	85 d2                	test   %edx,%edx
  800f8a:	75 9c                	jne    800f28 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	48                   	dec    %eax
  800f97:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f9e:	74 3d                	je     800fdd <ltostr+0xe2>
		start = 1 ;
  800fa0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800fa7:	eb 34                	jmp    800fdd <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800fa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	01 d0                	add    %edx,%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	01 c2                	add    %eax,%edx
  800fbe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc4:	01 c8                	add    %ecx,%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800fca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd0:	01 c2                	add    %eax,%edx
  800fd2:	8a 45 eb             	mov    -0x15(%ebp),%al
  800fd5:	88 02                	mov    %al,(%edx)
		start++ ;
  800fd7:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800fda:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fe3:	7c c4                	jl     800fa9 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800fe5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	01 d0                	add    %edx,%eax
  800fed:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ff0:	90                   	nop
  800ff1:	c9                   	leave  
  800ff2:	c3                   	ret    

00800ff3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ff9:	ff 75 08             	pushl  0x8(%ebp)
  800ffc:	e8 54 fa ff ff       	call   800a55 <strlen>
  801001:	83 c4 04             	add    $0x4,%esp
  801004:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801007:	ff 75 0c             	pushl  0xc(%ebp)
  80100a:	e8 46 fa ff ff       	call   800a55 <strlen>
  80100f:	83 c4 04             	add    $0x4,%esp
  801012:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801015:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80101c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801023:	eb 17                	jmp    80103c <strcconcat+0x49>
		final[s] = str1[s] ;
  801025:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801028:	8b 45 10             	mov    0x10(%ebp),%eax
  80102b:	01 c2                	add    %eax,%edx
  80102d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	01 c8                	add    %ecx,%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801039:	ff 45 fc             	incl   -0x4(%ebp)
  80103c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801042:	7c e1                	jl     801025 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801044:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80104b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801052:	eb 1f                	jmp    801073 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	8d 50 01             	lea    0x1(%eax),%edx
  80105a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80105d:	89 c2                	mov    %eax,%edx
  80105f:	8b 45 10             	mov    0x10(%ebp),%eax
  801062:	01 c2                	add    %eax,%edx
  801064:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801067:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106a:	01 c8                	add    %ecx,%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801070:	ff 45 f8             	incl   -0x8(%ebp)
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801079:	7c d9                	jl     801054 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80107b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 d0                	add    %edx,%eax
  801083:	c6 00 00             	movb   $0x0,(%eax)
}
  801086:	90                   	nop
  801087:	c9                   	leave  
  801088:	c3                   	ret    

00801089 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801095:	8b 45 14             	mov    0x14(%ebp),%eax
  801098:	8b 00                	mov    (%eax),%eax
  80109a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010ac:	eb 0c                	jmp    8010ba <strsplit+0x31>
			*string++ = 0;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8d 50 01             	lea    0x1(%eax),%edx
  8010b4:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b7:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	8a 00                	mov    (%eax),%al
  8010bf:	84 c0                	test   %al,%al
  8010c1:	74 18                	je     8010db <strsplit+0x52>
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	0f be c0             	movsbl %al,%eax
  8010cb:	50                   	push   %eax
  8010cc:	ff 75 0c             	pushl  0xc(%ebp)
  8010cf:	e8 13 fb ff ff       	call   800be7 <strchr>
  8010d4:	83 c4 08             	add    $0x8,%esp
  8010d7:	85 c0                	test   %eax,%eax
  8010d9:	75 d3                	jne    8010ae <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	84 c0                	test   %al,%al
  8010e2:	74 5a                	je     80113e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8010e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e7:	8b 00                	mov    (%eax),%eax
  8010e9:	83 f8 0f             	cmp    $0xf,%eax
  8010ec:	75 07                	jne    8010f5 <strsplit+0x6c>
		{
			return 0;
  8010ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f3:	eb 66                	jmp    80115b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f8:	8b 00                	mov    (%eax),%eax
  8010fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8010fd:	8b 55 14             	mov    0x14(%ebp),%edx
  801100:	89 0a                	mov    %ecx,(%edx)
  801102:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801109:	8b 45 10             	mov    0x10(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801113:	eb 03                	jmp    801118 <strsplit+0x8f>
			string++;
  801115:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	84 c0                	test   %al,%al
  80111f:	74 8b                	je     8010ac <strsplit+0x23>
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8a 00                	mov    (%eax),%al
  801126:	0f be c0             	movsbl %al,%eax
  801129:	50                   	push   %eax
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	e8 b5 fa ff ff       	call   800be7 <strchr>
  801132:	83 c4 08             	add    $0x8,%esp
  801135:	85 c0                	test   %eax,%eax
  801137:	74 dc                	je     801115 <strsplit+0x8c>
			string++;
	}
  801139:	e9 6e ff ff ff       	jmp    8010ac <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80113e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80113f:	8b 45 14             	mov    0x14(%ebp),%eax
  801142:	8b 00                	mov    (%eax),%eax
  801144:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801156:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80115b:	c9                   	leave  
  80115c:	c3                   	ret    

0080115d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
  801160:	57                   	push   %edi
  801161:	56                   	push   %esi
  801162:	53                   	push   %ebx
  801163:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80116f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801172:	8b 7d 18             	mov    0x18(%ebp),%edi
  801175:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801178:	cd 30                	int    $0x30
  80117a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80117d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	5b                   	pop    %ebx
  801184:	5e                   	pop    %esi
  801185:	5f                   	pop    %edi
  801186:	5d                   	pop    %ebp
  801187:	c3                   	ret    

00801188 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 04             	sub    $0x4,%esp
  80118e:	8b 45 10             	mov    0x10(%ebp),%eax
  801191:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801194:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801198:	8b 45 08             	mov    0x8(%ebp),%eax
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	52                   	push   %edx
  8011a0:	ff 75 0c             	pushl  0xc(%ebp)
  8011a3:	50                   	push   %eax
  8011a4:	6a 00                	push   $0x0
  8011a6:	e8 b2 ff ff ff       	call   80115d <syscall>
  8011ab:	83 c4 18             	add    $0x18,%esp
}
  8011ae:	90                   	nop
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 01                	push   $0x1
  8011c0:	e8 98 ff ff ff       	call   80115d <syscall>
  8011c5:	83 c4 18             	add    $0x18,%esp
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8011cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 00                	push   $0x0
  8011d7:	6a 00                	push   $0x0
  8011d9:	52                   	push   %edx
  8011da:	50                   	push   %eax
  8011db:	6a 05                	push   $0x5
  8011dd:	e8 7b ff ff ff       	call   80115d <syscall>
  8011e2:	83 c4 18             	add    $0x18,%esp
}
  8011e5:	c9                   	leave  
  8011e6:	c3                   	ret    

008011e7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	56                   	push   %esi
  8011eb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8011ec:	8b 75 18             	mov    0x18(%ebp),%esi
  8011ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8011f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8011f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	56                   	push   %esi
  8011fc:	53                   	push   %ebx
  8011fd:	51                   	push   %ecx
  8011fe:	52                   	push   %edx
  8011ff:	50                   	push   %eax
  801200:	6a 06                	push   $0x6
  801202:	e8 56 ff ff ff       	call   80115d <syscall>
  801207:	83 c4 18             	add    $0x18,%esp
}
  80120a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80120d:	5b                   	pop    %ebx
  80120e:	5e                   	pop    %esi
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801214:	8b 55 0c             	mov    0xc(%ebp),%edx
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	6a 00                	push   $0x0
  80121c:	6a 00                	push   $0x0
  80121e:	6a 00                	push   $0x0
  801220:	52                   	push   %edx
  801221:	50                   	push   %eax
  801222:	6a 07                	push   $0x7
  801224:	e8 34 ff ff ff       	call   80115d <syscall>
  801229:	83 c4 18             	add    $0x18,%esp
}
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	ff 75 08             	pushl  0x8(%ebp)
  80123d:	6a 08                	push   $0x8
  80123f:	e8 19 ff ff ff       	call   80115d <syscall>
  801244:	83 c4 18             	add    $0x18,%esp
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    

00801249 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80124c:	6a 00                	push   $0x0
  80124e:	6a 00                	push   $0x0
  801250:	6a 00                	push   $0x0
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	6a 09                	push   $0x9
  801258:	e8 00 ff ff ff       	call   80115d <syscall>
  80125d:	83 c4 18             	add    $0x18,%esp
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	6a 00                	push   $0x0
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 0a                	push   $0xa
  801271:	e8 e7 fe ff ff       	call   80115d <syscall>
  801276:	83 c4 18             	add    $0x18,%esp
}
  801279:	c9                   	leave  
  80127a:	c3                   	ret    

0080127b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80127b:	55                   	push   %ebp
  80127c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80127e:	6a 00                	push   $0x0
  801280:	6a 00                	push   $0x0
  801282:	6a 00                	push   $0x0
  801284:	6a 00                	push   $0x0
  801286:	6a 00                	push   $0x0
  801288:	6a 0b                	push   $0xb
  80128a:	e8 ce fe ff ff       	call   80115d <syscall>
  80128f:	83 c4 18             	add    $0x18,%esp
}
  801292:	c9                   	leave  
  801293:	c3                   	ret    

00801294 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801294:	55                   	push   %ebp
  801295:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801297:	6a 00                	push   $0x0
  801299:	6a 00                	push   $0x0
  80129b:	6a 00                	push   $0x0
  80129d:	ff 75 0c             	pushl  0xc(%ebp)
  8012a0:	ff 75 08             	pushl  0x8(%ebp)
  8012a3:	6a 0f                	push   $0xf
  8012a5:	e8 b3 fe ff ff       	call   80115d <syscall>
  8012aa:	83 c4 18             	add    $0x18,%esp
	return;
  8012ad:	90                   	nop
}
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8012b3:	6a 00                	push   $0x0
  8012b5:	6a 00                	push   $0x0
  8012b7:	6a 00                	push   $0x0
  8012b9:	ff 75 0c             	pushl  0xc(%ebp)
  8012bc:	ff 75 08             	pushl  0x8(%ebp)
  8012bf:	6a 10                	push   $0x10
  8012c1:	e8 97 fe ff ff       	call   80115d <syscall>
  8012c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8012c9:	90                   	nop
}
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8012cf:	6a 00                	push   $0x0
  8012d1:	6a 00                	push   $0x0
  8012d3:	ff 75 10             	pushl  0x10(%ebp)
  8012d6:	ff 75 0c             	pushl  0xc(%ebp)
  8012d9:	ff 75 08             	pushl  0x8(%ebp)
  8012dc:	6a 11                	push   $0x11
  8012de:	e8 7a fe ff ff       	call   80115d <syscall>
  8012e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8012e6:	90                   	nop
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 0c                	push   $0xc
  8012f8:	e8 60 fe ff ff       	call   80115d <syscall>
  8012fd:	83 c4 18             	add    $0x18,%esp
}
  801300:	c9                   	leave  
  801301:	c3                   	ret    

00801302 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	ff 75 08             	pushl  0x8(%ebp)
  801310:	6a 0d                	push   $0xd
  801312:	e8 46 fe ff ff       	call   80115d <syscall>
  801317:	83 c4 18             	add    $0x18,%esp
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 0e                	push   $0xe
  80132b:	e8 2d fe ff ff       	call   80115d <syscall>
  801330:	83 c4 18             	add    $0x18,%esp
}
  801333:	90                   	nop
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 13                	push   $0x13
  801345:	e8 13 fe ff ff       	call   80115d <syscall>
  80134a:	83 c4 18             	add    $0x18,%esp
}
  80134d:	90                   	nop
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801353:	6a 00                	push   $0x0
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 14                	push   $0x14
  80135f:	e8 f9 fd ff ff       	call   80115d <syscall>
  801364:	83 c4 18             	add    $0x18,%esp
}
  801367:	90                   	nop
  801368:	c9                   	leave  
  801369:	c3                   	ret    

0080136a <sys_cputc>:


void
sys_cputc(const char c)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	83 ec 04             	sub    $0x4,%esp
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801376:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	50                   	push   %eax
  801383:	6a 15                	push   $0x15
  801385:	e8 d3 fd ff ff       	call   80115d <syscall>
  80138a:	83 c4 18             	add    $0x18,%esp
}
  80138d:	90                   	nop
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 16                	push   $0x16
  80139f:	e8 b9 fd ff ff       	call   80115d <syscall>
  8013a4:	83 c4 18             	add    $0x18,%esp
}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	50                   	push   %eax
  8013ba:	6a 17                	push   $0x17
  8013bc:	e8 9c fd ff ff       	call   80115d <syscall>
  8013c1:	83 c4 18             	add    $0x18,%esp
}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8013c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	52                   	push   %edx
  8013d6:	50                   	push   %eax
  8013d7:	6a 1a                	push   $0x1a
  8013d9:	e8 7f fd ff ff       	call   80115d <syscall>
  8013de:	83 c4 18             	add    $0x18,%esp
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8013e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	52                   	push   %edx
  8013f3:	50                   	push   %eax
  8013f4:	6a 18                	push   $0x18
  8013f6:	e8 62 fd ff ff       	call   80115d <syscall>
  8013fb:	83 c4 18             	add    $0x18,%esp
}
  8013fe:	90                   	nop
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801404:	8b 55 0c             	mov    0xc(%ebp),%edx
  801407:	8b 45 08             	mov    0x8(%ebp),%eax
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	52                   	push   %edx
  801411:	50                   	push   %eax
  801412:	6a 19                	push   $0x19
  801414:	e8 44 fd ff ff       	call   80115d <syscall>
  801419:	83 c4 18             	add    $0x18,%esp
}
  80141c:	90                   	nop
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	83 ec 04             	sub    $0x4,%esp
  801425:	8b 45 10             	mov    0x10(%ebp),%eax
  801428:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80142b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80142e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	6a 00                	push   $0x0
  801437:	51                   	push   %ecx
  801438:	52                   	push   %edx
  801439:	ff 75 0c             	pushl  0xc(%ebp)
  80143c:	50                   	push   %eax
  80143d:	6a 1b                	push   $0x1b
  80143f:	e8 19 fd ff ff       	call   80115d <syscall>
  801444:	83 c4 18             	add    $0x18,%esp
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80144c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80144f:	8b 45 08             	mov    0x8(%ebp),%eax
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	52                   	push   %edx
  801459:	50                   	push   %eax
  80145a:	6a 1c                	push   $0x1c
  80145c:	e8 fc fc ff ff       	call   80115d <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801469:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80146c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	51                   	push   %ecx
  801477:	52                   	push   %edx
  801478:	50                   	push   %eax
  801479:	6a 1d                	push   $0x1d
  80147b:	e8 dd fc ff ff       	call   80115d <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	c9                   	leave  
  801484:	c3                   	ret    

00801485 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	52                   	push   %edx
  801495:	50                   	push   %eax
  801496:	6a 1e                	push   $0x1e
  801498:	e8 c0 fc ff ff       	call   80115d <syscall>
  80149d:	83 c4 18             	add    $0x18,%esp
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	6a 00                	push   $0x0
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 1f                	push   $0x1f
  8014b1:	e8 a7 fc ff ff       	call   80115d <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	6a 00                	push   $0x0
  8014c3:	ff 75 14             	pushl  0x14(%ebp)
  8014c6:	ff 75 10             	pushl  0x10(%ebp)
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	50                   	push   %eax
  8014cd:	6a 20                	push   $0x20
  8014cf:	e8 89 fc ff ff       	call   80115d <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	6a 00                	push   $0x0
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	6a 00                	push   $0x0
  8014e7:	50                   	push   %eax
  8014e8:	6a 21                	push   $0x21
  8014ea:	e8 6e fc ff ff       	call   80115d <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
}
  8014f2:	90                   	nop
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	50                   	push   %eax
  801504:	6a 22                	push   $0x22
  801506:	e8 52 fc ff ff       	call   80115d <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 02                	push   $0x2
  80151f:	e8 39 fc ff ff       	call   80115d <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 03                	push   $0x3
  801538:	e8 20 fc ff ff       	call   80115d <syscall>
  80153d:	83 c4 18             	add    $0x18,%esp
}
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 04                	push   $0x4
  801551:	e8 07 fc ff ff       	call   80115d <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <sys_exit_env>:


void sys_exit_env(void)
{
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	6a 23                	push   $0x23
  80156a:	e8 ee fb ff ff       	call   80115d <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	90                   	nop
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80157b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80157e:	8d 50 04             	lea    0x4(%eax),%edx
  801581:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	52                   	push   %edx
  80158b:	50                   	push   %eax
  80158c:	6a 24                	push   $0x24
  80158e:	e8 ca fb ff ff       	call   80115d <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
	return result;
  801596:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801599:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80159c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80159f:	89 01                	mov    %eax,(%ecx)
  8015a1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	c9                   	leave  
  8015a8:	c2 04 00             	ret    $0x4

008015ab <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	ff 75 10             	pushl  0x10(%ebp)
  8015b5:	ff 75 0c             	pushl  0xc(%ebp)
  8015b8:	ff 75 08             	pushl  0x8(%ebp)
  8015bb:	6a 12                	push   $0x12
  8015bd:	e8 9b fb ff ff       	call   80115d <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c5:	90                   	nop
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_rcr2>:
uint32 sys_rcr2()
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 25                	push   $0x25
  8015d7:	e8 81 fb ff ff       	call   80115d <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	c9                   	leave  
  8015e0:	c3                   	ret    

008015e1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8015ed:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	50                   	push   %eax
  8015fa:	6a 26                	push   $0x26
  8015fc:	e8 5c fb ff ff       	call   80115d <syscall>
  801601:	83 c4 18             	add    $0x18,%esp
	return ;
  801604:	90                   	nop
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <rsttst>:
void rsttst()
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 28                	push   $0x28
  801616:	e8 42 fb ff ff       	call   80115d <syscall>
  80161b:	83 c4 18             	add    $0x18,%esp
	return ;
  80161e:	90                   	nop
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	8b 45 14             	mov    0x14(%ebp),%eax
  80162a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80162d:	8b 55 18             	mov    0x18(%ebp),%edx
  801630:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801634:	52                   	push   %edx
  801635:	50                   	push   %eax
  801636:	ff 75 10             	pushl  0x10(%ebp)
  801639:	ff 75 0c             	pushl  0xc(%ebp)
  80163c:	ff 75 08             	pushl  0x8(%ebp)
  80163f:	6a 27                	push   $0x27
  801641:	e8 17 fb ff ff       	call   80115d <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
	return ;
  801649:	90                   	nop
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <chktst>:
void chktst(uint32 n)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	ff 75 08             	pushl  0x8(%ebp)
  80165a:	6a 29                	push   $0x29
  80165c:	e8 fc fa ff ff       	call   80115d <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
	return ;
  801664:	90                   	nop
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <inctst>:

void inctst()
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 2a                	push   $0x2a
  801676:	e8 e2 fa ff ff       	call   80115d <syscall>
  80167b:	83 c4 18             	add    $0x18,%esp
	return ;
  80167e:	90                   	nop
}
  80167f:	c9                   	leave  
  801680:	c3                   	ret    

00801681 <gettst>:
uint32 gettst()
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 2b                	push   $0x2b
  801690:	e8 c8 fa ff ff       	call   80115d <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
}
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 2c                	push   $0x2c
  8016ac:	e8 ac fa ff ff       	call   80115d <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
  8016b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8016b7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8016bb:	75 07                	jne    8016c4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8016bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8016c2:	eb 05                	jmp    8016c9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 2c                	push   $0x2c
  8016dd:	e8 7b fa ff ff       	call   80115d <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
  8016e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8016e8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8016ec:	75 07                	jne    8016f5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8016ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8016f3:	eb 05                	jmp    8016fa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 2c                	push   $0x2c
  80170e:	e8 4a fa ff ff       	call   80115d <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
  801716:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801719:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80171d:	75 07                	jne    801726 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80171f:	b8 01 00 00 00       	mov    $0x1,%eax
  801724:	eb 05                	jmp    80172b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 2c                	push   $0x2c
  80173f:	e8 19 fa ff ff       	call   80115d <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
  801747:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80174a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80174e:	75 07                	jne    801757 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801750:	b8 01 00 00 00       	mov    $0x1,%eax
  801755:	eb 05                	jmp    80175c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	ff 75 08             	pushl  0x8(%ebp)
  80176c:	6a 2d                	push   $0x2d
  80176e:	e8 ea f9 ff ff       	call   80115d <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
	return ;
  801776:	90                   	nop
}
  801777:	c9                   	leave  
  801778:	c3                   	ret    

00801779 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80177d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801780:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801783:	8b 55 0c             	mov    0xc(%ebp),%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	53                   	push   %ebx
  80178c:	51                   	push   %ecx
  80178d:	52                   	push   %edx
  80178e:	50                   	push   %eax
  80178f:	6a 2e                	push   $0x2e
  801791:	e8 c7 f9 ff ff       	call   80115d <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8017a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	52                   	push   %edx
  8017ae:	50                   	push   %eax
  8017af:	6a 2f                	push   $0x2f
  8017b1:	e8 a7 f9 ff ff       	call   80115d <syscall>
  8017b6:	83 c4 18             	add    $0x18,%esp
}
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    
  8017bb:	90                   	nop

008017bc <__udivdi3>:
  8017bc:	55                   	push   %ebp
  8017bd:	57                   	push   %edi
  8017be:	56                   	push   %esi
  8017bf:	53                   	push   %ebx
  8017c0:	83 ec 1c             	sub    $0x1c,%esp
  8017c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8017c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8017cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8017cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017d3:	89 ca                	mov    %ecx,%edx
  8017d5:	89 f8                	mov    %edi,%eax
  8017d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8017db:	85 f6                	test   %esi,%esi
  8017dd:	75 2d                	jne    80180c <__udivdi3+0x50>
  8017df:	39 cf                	cmp    %ecx,%edi
  8017e1:	77 65                	ja     801848 <__udivdi3+0x8c>
  8017e3:	89 fd                	mov    %edi,%ebp
  8017e5:	85 ff                	test   %edi,%edi
  8017e7:	75 0b                	jne    8017f4 <__udivdi3+0x38>
  8017e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ee:	31 d2                	xor    %edx,%edx
  8017f0:	f7 f7                	div    %edi
  8017f2:	89 c5                	mov    %eax,%ebp
  8017f4:	31 d2                	xor    %edx,%edx
  8017f6:	89 c8                	mov    %ecx,%eax
  8017f8:	f7 f5                	div    %ebp
  8017fa:	89 c1                	mov    %eax,%ecx
  8017fc:	89 d8                	mov    %ebx,%eax
  8017fe:	f7 f5                	div    %ebp
  801800:	89 cf                	mov    %ecx,%edi
  801802:	89 fa                	mov    %edi,%edx
  801804:	83 c4 1c             	add    $0x1c,%esp
  801807:	5b                   	pop    %ebx
  801808:	5e                   	pop    %esi
  801809:	5f                   	pop    %edi
  80180a:	5d                   	pop    %ebp
  80180b:	c3                   	ret    
  80180c:	39 ce                	cmp    %ecx,%esi
  80180e:	77 28                	ja     801838 <__udivdi3+0x7c>
  801810:	0f bd fe             	bsr    %esi,%edi
  801813:	83 f7 1f             	xor    $0x1f,%edi
  801816:	75 40                	jne    801858 <__udivdi3+0x9c>
  801818:	39 ce                	cmp    %ecx,%esi
  80181a:	72 0a                	jb     801826 <__udivdi3+0x6a>
  80181c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801820:	0f 87 9e 00 00 00    	ja     8018c4 <__udivdi3+0x108>
  801826:	b8 01 00 00 00       	mov    $0x1,%eax
  80182b:	89 fa                	mov    %edi,%edx
  80182d:	83 c4 1c             	add    $0x1c,%esp
  801830:	5b                   	pop    %ebx
  801831:	5e                   	pop    %esi
  801832:	5f                   	pop    %edi
  801833:	5d                   	pop    %ebp
  801834:	c3                   	ret    
  801835:	8d 76 00             	lea    0x0(%esi),%esi
  801838:	31 ff                	xor    %edi,%edi
  80183a:	31 c0                	xor    %eax,%eax
  80183c:	89 fa                	mov    %edi,%edx
  80183e:	83 c4 1c             	add    $0x1c,%esp
  801841:	5b                   	pop    %ebx
  801842:	5e                   	pop    %esi
  801843:	5f                   	pop    %edi
  801844:	5d                   	pop    %ebp
  801845:	c3                   	ret    
  801846:	66 90                	xchg   %ax,%ax
  801848:	89 d8                	mov    %ebx,%eax
  80184a:	f7 f7                	div    %edi
  80184c:	31 ff                	xor    %edi,%edi
  80184e:	89 fa                	mov    %edi,%edx
  801850:	83 c4 1c             	add    $0x1c,%esp
  801853:	5b                   	pop    %ebx
  801854:	5e                   	pop    %esi
  801855:	5f                   	pop    %edi
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    
  801858:	bd 20 00 00 00       	mov    $0x20,%ebp
  80185d:	89 eb                	mov    %ebp,%ebx
  80185f:	29 fb                	sub    %edi,%ebx
  801861:	89 f9                	mov    %edi,%ecx
  801863:	d3 e6                	shl    %cl,%esi
  801865:	89 c5                	mov    %eax,%ebp
  801867:	88 d9                	mov    %bl,%cl
  801869:	d3 ed                	shr    %cl,%ebp
  80186b:	89 e9                	mov    %ebp,%ecx
  80186d:	09 f1                	or     %esi,%ecx
  80186f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801873:	89 f9                	mov    %edi,%ecx
  801875:	d3 e0                	shl    %cl,%eax
  801877:	89 c5                	mov    %eax,%ebp
  801879:	89 d6                	mov    %edx,%esi
  80187b:	88 d9                	mov    %bl,%cl
  80187d:	d3 ee                	shr    %cl,%esi
  80187f:	89 f9                	mov    %edi,%ecx
  801881:	d3 e2                	shl    %cl,%edx
  801883:	8b 44 24 08          	mov    0x8(%esp),%eax
  801887:	88 d9                	mov    %bl,%cl
  801889:	d3 e8                	shr    %cl,%eax
  80188b:	09 c2                	or     %eax,%edx
  80188d:	89 d0                	mov    %edx,%eax
  80188f:	89 f2                	mov    %esi,%edx
  801891:	f7 74 24 0c          	divl   0xc(%esp)
  801895:	89 d6                	mov    %edx,%esi
  801897:	89 c3                	mov    %eax,%ebx
  801899:	f7 e5                	mul    %ebp
  80189b:	39 d6                	cmp    %edx,%esi
  80189d:	72 19                	jb     8018b8 <__udivdi3+0xfc>
  80189f:	74 0b                	je     8018ac <__udivdi3+0xf0>
  8018a1:	89 d8                	mov    %ebx,%eax
  8018a3:	31 ff                	xor    %edi,%edi
  8018a5:	e9 58 ff ff ff       	jmp    801802 <__udivdi3+0x46>
  8018aa:	66 90                	xchg   %ax,%ax
  8018ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8018b0:	89 f9                	mov    %edi,%ecx
  8018b2:	d3 e2                	shl    %cl,%edx
  8018b4:	39 c2                	cmp    %eax,%edx
  8018b6:	73 e9                	jae    8018a1 <__udivdi3+0xe5>
  8018b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8018bb:	31 ff                	xor    %edi,%edi
  8018bd:	e9 40 ff ff ff       	jmp    801802 <__udivdi3+0x46>
  8018c2:	66 90                	xchg   %ax,%ax
  8018c4:	31 c0                	xor    %eax,%eax
  8018c6:	e9 37 ff ff ff       	jmp    801802 <__udivdi3+0x46>
  8018cb:	90                   	nop

008018cc <__umoddi3>:
  8018cc:	55                   	push   %ebp
  8018cd:	57                   	push   %edi
  8018ce:	56                   	push   %esi
  8018cf:	53                   	push   %ebx
  8018d0:	83 ec 1c             	sub    $0x1c,%esp
  8018d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8018d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8018db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8018e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018eb:	89 f3                	mov    %esi,%ebx
  8018ed:	89 fa                	mov    %edi,%edx
  8018ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018f3:	89 34 24             	mov    %esi,(%esp)
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	75 1a                	jne    801914 <__umoddi3+0x48>
  8018fa:	39 f7                	cmp    %esi,%edi
  8018fc:	0f 86 a2 00 00 00    	jbe    8019a4 <__umoddi3+0xd8>
  801902:	89 c8                	mov    %ecx,%eax
  801904:	89 f2                	mov    %esi,%edx
  801906:	f7 f7                	div    %edi
  801908:	89 d0                	mov    %edx,%eax
  80190a:	31 d2                	xor    %edx,%edx
  80190c:	83 c4 1c             	add    $0x1c,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5f                   	pop    %edi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    
  801914:	39 f0                	cmp    %esi,%eax
  801916:	0f 87 ac 00 00 00    	ja     8019c8 <__umoddi3+0xfc>
  80191c:	0f bd e8             	bsr    %eax,%ebp
  80191f:	83 f5 1f             	xor    $0x1f,%ebp
  801922:	0f 84 ac 00 00 00    	je     8019d4 <__umoddi3+0x108>
  801928:	bf 20 00 00 00       	mov    $0x20,%edi
  80192d:	29 ef                	sub    %ebp,%edi
  80192f:	89 fe                	mov    %edi,%esi
  801931:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801935:	89 e9                	mov    %ebp,%ecx
  801937:	d3 e0                	shl    %cl,%eax
  801939:	89 d7                	mov    %edx,%edi
  80193b:	89 f1                	mov    %esi,%ecx
  80193d:	d3 ef                	shr    %cl,%edi
  80193f:	09 c7                	or     %eax,%edi
  801941:	89 e9                	mov    %ebp,%ecx
  801943:	d3 e2                	shl    %cl,%edx
  801945:	89 14 24             	mov    %edx,(%esp)
  801948:	89 d8                	mov    %ebx,%eax
  80194a:	d3 e0                	shl    %cl,%eax
  80194c:	89 c2                	mov    %eax,%edx
  80194e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801952:	d3 e0                	shl    %cl,%eax
  801954:	89 44 24 04          	mov    %eax,0x4(%esp)
  801958:	8b 44 24 08          	mov    0x8(%esp),%eax
  80195c:	89 f1                	mov    %esi,%ecx
  80195e:	d3 e8                	shr    %cl,%eax
  801960:	09 d0                	or     %edx,%eax
  801962:	d3 eb                	shr    %cl,%ebx
  801964:	89 da                	mov    %ebx,%edx
  801966:	f7 f7                	div    %edi
  801968:	89 d3                	mov    %edx,%ebx
  80196a:	f7 24 24             	mull   (%esp)
  80196d:	89 c6                	mov    %eax,%esi
  80196f:	89 d1                	mov    %edx,%ecx
  801971:	39 d3                	cmp    %edx,%ebx
  801973:	0f 82 87 00 00 00    	jb     801a00 <__umoddi3+0x134>
  801979:	0f 84 91 00 00 00    	je     801a10 <__umoddi3+0x144>
  80197f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801983:	29 f2                	sub    %esi,%edx
  801985:	19 cb                	sbb    %ecx,%ebx
  801987:	89 d8                	mov    %ebx,%eax
  801989:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80198d:	d3 e0                	shl    %cl,%eax
  80198f:	89 e9                	mov    %ebp,%ecx
  801991:	d3 ea                	shr    %cl,%edx
  801993:	09 d0                	or     %edx,%eax
  801995:	89 e9                	mov    %ebp,%ecx
  801997:	d3 eb                	shr    %cl,%ebx
  801999:	89 da                	mov    %ebx,%edx
  80199b:	83 c4 1c             	add    $0x1c,%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5f                   	pop    %edi
  8019a1:	5d                   	pop    %ebp
  8019a2:	c3                   	ret    
  8019a3:	90                   	nop
  8019a4:	89 fd                	mov    %edi,%ebp
  8019a6:	85 ff                	test   %edi,%edi
  8019a8:	75 0b                	jne    8019b5 <__umoddi3+0xe9>
  8019aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8019af:	31 d2                	xor    %edx,%edx
  8019b1:	f7 f7                	div    %edi
  8019b3:	89 c5                	mov    %eax,%ebp
  8019b5:	89 f0                	mov    %esi,%eax
  8019b7:	31 d2                	xor    %edx,%edx
  8019b9:	f7 f5                	div    %ebp
  8019bb:	89 c8                	mov    %ecx,%eax
  8019bd:	f7 f5                	div    %ebp
  8019bf:	89 d0                	mov    %edx,%eax
  8019c1:	e9 44 ff ff ff       	jmp    80190a <__umoddi3+0x3e>
  8019c6:	66 90                	xchg   %ax,%ax
  8019c8:	89 c8                	mov    %ecx,%eax
  8019ca:	89 f2                	mov    %esi,%edx
  8019cc:	83 c4 1c             	add    $0x1c,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5e                   	pop    %esi
  8019d1:	5f                   	pop    %edi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    
  8019d4:	3b 04 24             	cmp    (%esp),%eax
  8019d7:	72 06                	jb     8019df <__umoddi3+0x113>
  8019d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8019dd:	77 0f                	ja     8019ee <__umoddi3+0x122>
  8019df:	89 f2                	mov    %esi,%edx
  8019e1:	29 f9                	sub    %edi,%ecx
  8019e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8019e7:	89 14 24             	mov    %edx,(%esp)
  8019ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8019f2:	8b 14 24             	mov    (%esp),%edx
  8019f5:	83 c4 1c             	add    $0x1c,%esp
  8019f8:	5b                   	pop    %ebx
  8019f9:	5e                   	pop    %esi
  8019fa:	5f                   	pop    %edi
  8019fb:	5d                   	pop    %ebp
  8019fc:	c3                   	ret    
  8019fd:	8d 76 00             	lea    0x0(%esi),%esi
  801a00:	2b 04 24             	sub    (%esp),%eax
  801a03:	19 fa                	sbb    %edi,%edx
  801a05:	89 d1                	mov    %edx,%ecx
  801a07:	89 c6                	mov    %eax,%esi
  801a09:	e9 71 ff ff ff       	jmp    80197f <__umoddi3+0xb3>
  801a0e:	66 90                	xchg   %ax,%ax
  801a10:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801a14:	72 ea                	jb     801a00 <__umoddi3+0x134>
  801a16:	89 d9                	mov    %ebx,%ecx
  801a18:	e9 62 ff ff ff       	jmp    80197f <__umoddi3+0xb3>
