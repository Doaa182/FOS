
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 b4 01 00 00       	call   8001ea <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 80 33 80 00       	push   $0x803380
  80004a:	e8 80 16 00 00       	call   8016cf <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 82 33 80 00       	push   $0x803382
  80006e:	e8 5c 16 00 00       	call   8016cf <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 89 33 80 00       	push   $0x803389
  8000ab:	e8 43 1a 00 00       	call   801af3 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 8b 33 80 00       	push   $0x80338b
  8000bf:	e8 0b 16 00 00       	call   8016cf <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 99 33 80 00       	push   $0x803399
  8000f1:	e8 0e 1b 00 00       	call   801c04 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800101:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 a3 33 80 00       	push   $0x8033a3
  80011a:	e8 e5 1a 00 00       	call   801c04 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 ad 33 80 00       	push   $0x8033ad
  800139:	6a 27                	push   $0x27
  80013b:	68 c2 33 80 00       	push   $0x8033c2
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 d2 1a 00 00       	call   801c22 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 e9 2e 00 00       	call   803049 <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 b4 1a 00 00       	call   801c22 <sys_run_env>
  80016e:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800171:	90                   	nop
  800172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	83 f8 02             	cmp    $0x2,%eax
  80017a:	75 f6                	jne    800172 <_main+0x13a>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	50                   	push   %eax
  800185:	68 dd 33 80 00       	push   $0x8033dd
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 f4 1a 00 00       	call   801c8b <sys_getparentenvid>
  800197:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  80019a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80019e:	7e 47                	jle    8001e7 <_main+0x1af>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  8001a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	68 8b 33 80 00       	push   $0x80338b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 b6 15 00 00       	call   80176d <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 76 1a 00 00       	call   801c3e <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 68 1a 00 00       	call   801c3e <sys_destroy_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dc:	8b 00                	mov    (%eax),%eax
  8001de:	8d 50 01             	lea    0x1(%eax),%edx
  8001e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e4:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e6:	90                   	nop
  8001e7:	90                   	nop
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f0:	e8 7d 1a 00 00       	call   801c72 <sys_getenvindex>
  8001f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fb:	89 d0                	mov    %edx,%eax
  8001fd:	c1 e0 03             	shl    $0x3,%eax
  800200:	01 d0                	add    %edx,%eax
  800202:	01 c0                	add    %eax,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020d:	01 d0                	add    %edx,%eax
  80020f:	c1 e0 04             	shl    $0x4,%eax
  800212:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800217:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80021c:	a1 20 40 80 00       	mov    0x804020,%eax
  800221:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800227:	84 c0                	test   %al,%al
  800229:	74 0f                	je     80023a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	05 5c 05 00 00       	add    $0x55c,%eax
  800235:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023e:	7e 0a                	jle    80024a <libmain+0x60>
		binaryname = argv[0];
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	e8 e0 fd ff ff       	call   800038 <_main>
  800258:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80025b:	e8 1f 18 00 00       	call   801a7f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 0c 34 80 00       	push   $0x80340c
  800268:	e8 6d 03 00 00       	call   8005da <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800270:	a1 20 40 80 00       	mov    0x804020,%eax
  800275:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80027b:	a1 20 40 80 00       	mov    0x804020,%eax
  800280:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	68 34 34 80 00       	push   $0x803434
  800290:	e8 45 03 00 00       	call   8005da <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800298:	a1 20 40 80 00       	mov    0x804020,%eax
  80029d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002b9:	51                   	push   %ecx
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	68 5c 34 80 00       	push   $0x80345c
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 b4 34 80 00       	push   $0x8034b4
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 0c 34 80 00       	push   $0x80340c
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 9f 17 00 00       	call   801a99 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002fa:	e8 19 00 00 00       	call   800318 <exit>
}
  8002ff:	90                   	nop
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	6a 00                	push   $0x0
  80030d:	e8 2c 19 00 00       	call   801c3e <sys_destroy_env>
  800312:	83 c4 10             	add    $0x10,%esp
}
  800315:	90                   	nop
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <exit>:

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031e:	e8 81 19 00 00       	call   801ca4 <sys_exit_env>
}
  800323:	90                   	nop
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80032c:	8d 45 10             	lea    0x10(%ebp),%eax
  80032f:	83 c0 04             	add    $0x4,%eax
  800332:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800335:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80033a:	85 c0                	test   %eax,%eax
  80033c:	74 16                	je     800354 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	50                   	push   %eax
  800347:	68 c8 34 80 00       	push   $0x8034c8
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 40 80 00       	mov    0x804000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 cd 34 80 00       	push   $0x8034cd
  800365:	e8 70 02 00 00       	call   8005da <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80036d:	8b 45 10             	mov    0x10(%ebp),%eax
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 75 f4             	pushl  -0xc(%ebp)
  800376:	50                   	push   %eax
  800377:	e8 f3 01 00 00       	call   80056f <vcprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	6a 00                	push   $0x0
  800384:	68 e9 34 80 00       	push   $0x8034e9
  800389:	e8 e1 01 00 00       	call   80056f <vcprintf>
  80038e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800391:	e8 82 ff ff ff       	call   800318 <exit>

	// should not return here
	while (1) ;
  800396:	eb fe                	jmp    800396 <_panic+0x70>

00800398 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	8b 50 74             	mov    0x74(%eax),%edx
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	74 14                	je     8003c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 ec 34 80 00       	push   $0x8034ec
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 38 35 80 00       	push   $0x803538
  8003bc:	e8 65 ff ff ff       	call   800326 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003cf:	e9 c2 00 00 00       	jmp    800496 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	75 08                	jne    8003f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ec:	e9 a2 00 00 00       	jmp    800493 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ff:	eb 69                	jmp    80046a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040f:	89 d0                	mov    %edx,%eax
  800411:	01 c0                	add    %eax,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8a 40 04             	mov    0x4(%eax),%al
  80041d:	84 c0                	test   %al,%al
  80041f:	75 46                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80042c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800447:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c8                	add    %ecx,%eax
  800458:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045a:	39 c2                	cmp    %eax,%edx
  80045c:	75 09                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80045e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800465:	eb 12                	jmp    800479 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	ff 45 e8             	incl   -0x18(%ebp)
  80046a:	a1 20 40 80 00       	mov    0x804020,%eax
  80046f:	8b 50 74             	mov    0x74(%eax),%edx
  800472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800475:	39 c2                	cmp    %eax,%edx
  800477:	77 88                	ja     800401 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047d:	75 14                	jne    800493 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 44 35 80 00       	push   $0x803544
  800487:	6a 3a                	push   $0x3a
  800489:	68 38 35 80 00       	push   $0x803538
  80048e:	e8 93 fe ff ff       	call   800326 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800493:	ff 45 f0             	incl   -0x10(%ebp)
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800499:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049c:	0f 8c 32 ff ff ff    	jl     8003d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b0:	eb 26                	jmp    8004d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c0:	89 d0                	mov    %edx,%eax
  8004c2:	01 c0                	add    %eax,%eax
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	c1 e0 03             	shl    $0x3,%eax
  8004c9:	01 c8                	add    %ecx,%eax
  8004cb:	8a 40 04             	mov    0x4(%eax),%al
  8004ce:	3c 01                	cmp    $0x1,%al
  8004d0:	75 03                	jne    8004d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d5:	ff 45 e0             	incl   -0x20(%ebp)
  8004d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8004dd:	8b 50 74             	mov    0x74(%eax),%edx
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	39 c2                	cmp    %eax,%edx
  8004e5:	77 cb                	ja     8004b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ed:	74 14                	je     800503 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 98 35 80 00       	push   $0x803598
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 38 35 80 00       	push   $0x803538
  8004fe:	e8 23 fe ff ff       	call   800326 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 48 01             	lea    0x1(%eax),%ecx
  800514:	8b 55 0c             	mov    0xc(%ebp),%edx
  800517:	89 0a                	mov    %ecx,(%edx)
  800519:	8b 55 08             	mov    0x8(%ebp),%edx
  80051c:	88 d1                	mov    %dl,%cl
  80051e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800521:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052f:	75 2c                	jne    80055d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800531:	a0 24 40 80 00       	mov    0x804024,%al
  800536:	0f b6 c0             	movzbl %al,%eax
  800539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053c:	8b 12                	mov    (%edx),%edx
  80053e:	89 d1                	mov    %edx,%ecx
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	83 c2 08             	add    $0x8,%edx
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	50                   	push   %eax
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	e8 80 13 00 00       	call   8018d1 <sys_cputs>
  800551:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	8b 40 04             	mov    0x4(%eax),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	8b 45 0c             	mov    0xc(%ebp),%eax
  800569:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056c:	90                   	nop
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800578:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057f:	00 00 00 
	b.cnt = 0;
  800582:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800589:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800598:	50                   	push   %eax
  800599:	68 06 05 80 00       	push   $0x800506
  80059e:	e8 11 02 00 00       	call   8007b4 <vprintfmt>
  8005a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005a6:	a0 24 40 80 00       	mov    0x804024,%al
  8005ab:	0f b6 c0             	movzbl %al,%eax
  8005ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	50                   	push   %eax
  8005b8:	52                   	push   %edx
  8005b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bf:	83 c0 08             	add    $0x8,%eax
  8005c2:	50                   	push   %eax
  8005c3:	e8 09 13 00 00       	call   8018d1 <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cb:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <cprintf>:

int cprintf(const char *fmt, ...) {
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e0:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	e8 73 ff ff ff       	call   80056f <vcprintf>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800605:	c9                   	leave  
  800606:	c3                   	ret    

00800607 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80060d:	e8 6d 14 00 00       	call   801a7f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800612:	8d 45 0c             	lea    0xc(%ebp),%eax
  800615:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 f4             	pushl  -0xc(%ebp)
  800621:	50                   	push   %eax
  800622:	e8 48 ff ff ff       	call   80056f <vcprintf>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80062d:	e8 67 14 00 00       	call   801a99 <sys_enable_interrupt>
	return cnt;
  800632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	53                   	push   %ebx
  80063b:	83 ec 14             	sub    $0x14,%esp
  80063e:	8b 45 10             	mov    0x10(%ebp),%eax
  800641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064a:	8b 45 18             	mov    0x18(%ebp),%eax
  80064d:	ba 00 00 00 00       	mov    $0x0,%edx
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	77 55                	ja     8006ac <printnum+0x75>
  800657:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065a:	72 05                	jb     800661 <printnum+0x2a>
  80065c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065f:	77 4b                	ja     8006ac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800661:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800664:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800667:	8b 45 18             	mov    0x18(%ebp),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	52                   	push   %edx
  800670:	50                   	push   %eax
  800671:	ff 75 f4             	pushl  -0xc(%ebp)
  800674:	ff 75 f0             	pushl  -0x10(%ebp)
  800677:	e8 84 2a 00 00       	call   803100 <__udivdi3>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	ff 75 20             	pushl  0x20(%ebp)
  800685:	53                   	push   %ebx
  800686:	ff 75 18             	pushl  0x18(%ebp)
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 a1 ff ff ff       	call   800637 <printnum>
  800696:	83 c4 20             	add    $0x20,%esp
  800699:	eb 1a                	jmp    8006b5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	ff 75 20             	pushl  0x20(%ebp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ac:	ff 4d 1c             	decl   0x1c(%ebp)
  8006af:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b3:	7f e6                	jg     80069b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c3:	53                   	push   %ebx
  8006c4:	51                   	push   %ecx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	e8 44 2b 00 00       	call   803210 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 14 38 80 00       	add    $0x803814,%eax
  8006d4:	8a 00                	mov    (%eax),%al
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
}
  8006e8:	90                   	nop
  8006e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f5:	7e 1c                	jle    800713 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8d 50 08             	lea    0x8(%eax),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	89 10                	mov    %edx,(%eax)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	83 e8 08             	sub    $0x8,%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	eb 40                	jmp    800753 <getuint+0x65>
	else if (lflag)
  800713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800717:	74 1e                	je     800737 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	eb 1c                	jmp    800753 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8d 50 04             	lea    0x4(%eax),%edx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 10                	mov    %edx,(%eax)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800753:	5d                   	pop    %ebp
  800754:	c3                   	ret    

00800755 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800758:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075c:	7e 1c                	jle    80077a <getint+0x25>
		return va_arg(*ap, long long);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	8d 50 08             	lea    0x8(%eax),%edx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	89 10                	mov    %edx,(%eax)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 e8 08             	sub    $0x8,%eax
  800773:	8b 50 04             	mov    0x4(%eax),%edx
  800776:	8b 00                	mov    (%eax),%eax
  800778:	eb 38                	jmp    8007b2 <getint+0x5d>
	else if (lflag)
  80077a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077e:	74 1a                	je     80079a <getint+0x45>
		return va_arg(*ap, long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 04             	sub    $0x4,%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	99                   	cltd   
  800798:	eb 18                	jmp    8007b2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 04             	lea    0x4(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 04             	sub    $0x4,%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	99                   	cltd   
}
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bc:	eb 17                	jmp    8007d5 <vprintfmt+0x21>
			if (ch == '\0')
  8007be:	85 db                	test   %ebx,%ebx
  8007c0:	0f 84 af 03 00 00    	je     800b75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	8d 50 01             	lea    0x1(%eax),%edx
  8007db:	89 55 10             	mov    %edx,0x10(%ebp)
  8007de:	8a 00                	mov    (%eax),%al
  8007e0:	0f b6 d8             	movzbl %al,%ebx
  8007e3:	83 fb 25             	cmp    $0x25,%ebx
  8007e6:	75 d6                	jne    8007be <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800801:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	8d 50 01             	lea    0x1(%eax),%edx
  80080e:	89 55 10             	mov    %edx,0x10(%ebp)
  800811:	8a 00                	mov    (%eax),%al
  800813:	0f b6 d8             	movzbl %al,%ebx
  800816:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800819:	83 f8 55             	cmp    $0x55,%eax
  80081c:	0f 87 2b 03 00 00    	ja     800b4d <vprintfmt+0x399>
  800822:	8b 04 85 38 38 80 00 	mov    0x803838(,%eax,4),%eax
  800829:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082f:	eb d7                	jmp    800808 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800831:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800835:	eb d1                	jmp    800808 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800837:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80083e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800841:	89 d0                	mov    %edx,%eax
  800843:	c1 e0 02             	shl    $0x2,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	01 c0                	add    %eax,%eax
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	83 e8 30             	sub    $0x30,%eax
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800852:	8b 45 10             	mov    0x10(%ebp),%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085a:	83 fb 2f             	cmp    $0x2f,%ebx
  80085d:	7e 3e                	jle    80089d <vprintfmt+0xe9>
  80085f:	83 fb 39             	cmp    $0x39,%ebx
  800862:	7f 39                	jg     80089d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800864:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800867:	eb d5                	jmp    80083e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 c0 04             	add    $0x4,%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 e8 04             	sub    $0x4,%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087d:	eb 1f                	jmp    80089e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	79 83                	jns    800808 <vprintfmt+0x54>
				width = 0;
  800885:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088c:	e9 77 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800891:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800898:	e9 6b ff ff ff       	jmp    800808 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a2:	0f 89 60 ff ff ff    	jns    800808 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b5:	e9 4e ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008bd:	e9 46 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 89 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f8:	85 db                	test   %ebx,%ebx
  8008fa:	79 02                	jns    8008fe <vprintfmt+0x14a>
				err = -err;
  8008fc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008fe:	83 fb 64             	cmp    $0x64,%ebx
  800901:	7f 0b                	jg     80090e <vprintfmt+0x15a>
  800903:	8b 34 9d 80 36 80 00 	mov    0x803680(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 25 38 80 00       	push   $0x803825
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 5e 02 00 00       	call   800b7d <printfmt>
  80091f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800922:	e9 49 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800927:	56                   	push   %esi
  800928:	68 2e 38 80 00       	push   $0x80382e
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	ff 75 08             	pushl  0x8(%ebp)
  800933:	e8 45 02 00 00       	call   800b7d <printfmt>
  800938:	83 c4 10             	add    $0x10,%esp
			break;
  80093b:	e9 30 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 c0 04             	add    $0x4,%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 30                	mov    (%eax),%esi
  800951:	85 f6                	test   %esi,%esi
  800953:	75 05                	jne    80095a <vprintfmt+0x1a6>
				p = "(null)";
  800955:	be 31 38 80 00       	mov    $0x803831,%esi
			if (width > 0 && padc != '-')
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	7e 6d                	jle    8009cd <vprintfmt+0x219>
  800960:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800964:	74 67                	je     8009cd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	50                   	push   %eax
  80096d:	56                   	push   %esi
  80096e:	e8 0c 03 00 00       	call   800c7f <strnlen>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800979:	eb 16                	jmp    800991 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	50                   	push   %eax
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80098e:	ff 4d e4             	decl   -0x1c(%ebp)
  800991:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800995:	7f e4                	jg     80097b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800997:	eb 34                	jmp    8009cd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099d:	74 1c                	je     8009bb <vprintfmt+0x207>
  80099f:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a2:	7e 05                	jle    8009a9 <vprintfmt+0x1f5>
  8009a4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a7:	7e 12                	jle    8009bb <vprintfmt+0x207>
					putch('?', putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	6a 3f                	push   $0x3f
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	eb 0f                	jmp    8009ca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 70 01             	lea    0x1(%eax),%esi
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f be d8             	movsbl %al,%ebx
  8009d7:	85 db                	test   %ebx,%ebx
  8009d9:	74 24                	je     8009ff <vprintfmt+0x24b>
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	78 b8                	js     800999 <vprintfmt+0x1e5>
  8009e1:	ff 4d e0             	decl   -0x20(%ebp)
  8009e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e8:	79 af                	jns    800999 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ea:	eb 13                	jmp    8009ff <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	6a 20                	push   $0x20
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a03:	7f e7                	jg     8009ec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a05:	e9 66 01 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
  800a13:	50                   	push   %eax
  800a14:	e8 3c fd ff ff       	call   800755 <getint>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a28:	85 d2                	test   %edx,%edx
  800a2a:	79 23                	jns    800a4f <vprintfmt+0x29b>
				putch('-', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 2d                	push   $0x2d
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a42:	f7 d8                	neg    %eax
  800a44:	83 d2 00             	adc    $0x0,%edx
  800a47:	f7 da                	neg    %edx
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a56:	e9 bc 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a61:	8d 45 14             	lea    0x14(%ebp),%eax
  800a64:	50                   	push   %eax
  800a65:	e8 84 fc ff ff       	call   8006ee <getuint>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7a:	e9 98 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 58                	push   $0x58
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 58                	push   $0x58
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 58                	push   $0x58
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	e9 bc 00 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 30                	push   $0x30
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 78                	push   $0x78
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	83 e8 04             	sub    $0x4,%eax
  800ae3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af6:	eb 1f                	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 e8             	pushl  -0x18(%ebp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	50                   	push   %eax
  800b02:	e8 e7 fb ff ff       	call   8006ee <getuint>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b25:	50                   	push   %eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 00 fb ff ff       	call   800637 <printnum>
  800b37:	83 c4 20             	add    $0x20,%esp
			break;
  800b3a:	eb 34                	jmp    800b70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			break;
  800b4b:	eb 23                	jmp    800b70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 25                	push   $0x25
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5d:	ff 4d 10             	decl   0x10(%ebp)
  800b60:	eb 03                	jmp    800b65 <vprintfmt+0x3b1>
  800b62:	ff 4d 10             	decl   0x10(%ebp)
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	48                   	dec    %eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	3c 25                	cmp    $0x25,%al
  800b6d:	75 f3                	jne    800b62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b6f:	90                   	nop
		}
	}
  800b70:	e9 47 fc ff ff       	jmp    8007bc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b83:	8d 45 10             	lea    0x10(%ebp),%eax
  800b86:	83 c0 04             	add    $0x4,%eax
  800b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 08             	pushl  0x8(%ebp)
  800b99:	e8 16 fc ff ff       	call   8007b4 <vprintfmt>
  800b9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba1:	90                   	nop
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8b 40 08             	mov    0x8(%eax),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 10                	mov    (%eax),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8b 40 04             	mov    0x4(%eax),%eax
  800bc1:	39 c2                	cmp    %eax,%edx
  800bc3:	73 12                	jae    800bd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	8d 48 01             	lea    0x1(%eax),%ecx
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 0a                	mov    %ecx,(%edx)
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	88 10                	mov    %dl,(%eax)
}
  800bd7:	90                   	nop
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bff:	74 06                	je     800c07 <vsnprintf+0x2d>
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	7f 07                	jg     800c0e <vsnprintf+0x34>
		return -E_INVAL;
  800c07:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0c:	eb 20                	jmp    800c2e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c0e:	ff 75 14             	pushl  0x14(%ebp)
  800c11:	ff 75 10             	pushl  0x10(%ebp)
  800c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c17:	50                   	push   %eax
  800c18:	68 a4 0b 80 00       	push   $0x800ba4
  800c1d:	e8 92 fb ff ff       	call   8007b4 <vprintfmt>
  800c22:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c36:	8d 45 10             	lea    0x10(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c42:	ff 75 f4             	pushl  -0xc(%ebp)
  800c45:	50                   	push   %eax
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	ff 75 08             	pushl  0x8(%ebp)
  800c4c:	e8 89 ff ff ff       	call   800bda <vsnprintf>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c69:	eb 06                	jmp    800c71 <strlen+0x15>
		n++;
  800c6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6e:	ff 45 08             	incl   0x8(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	84 c0                	test   %al,%al
  800c78:	75 f1                	jne    800c6b <strlen+0xf>
		n++;
	return n;
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 09                	jmp    800c97 <strnlen+0x18>
		n++;
  800c8e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	ff 4d 0c             	decl   0xc(%ebp)
  800c97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9b:	74 09                	je     800ca6 <strnlen+0x27>
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 e8                	jne    800c8e <strnlen+0xf>
		n++;
	return n;
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb7:	90                   	nop
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 e4                	jne    800cb8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cec:	eb 1f                	jmp    800d0d <strncpy+0x34>
		*dst++ = *src;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8d 50 01             	lea    0x1(%eax),%edx
  800cf4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfa:	8a 12                	mov    (%edx),%dl
  800cfc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	74 03                	je     800d0a <strncpy+0x31>
			src++;
  800d07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0a:	ff 45 fc             	incl   -0x4(%ebp)
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d13:	72 d9                	jb     800cee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	74 30                	je     800d5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2c:	eb 16                	jmp    800d44 <strlcpy+0x2a>
			*dst++ = *src++;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 08             	mov    %edx,0x8(%ebp)
  800d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d40:	8a 12                	mov    (%edx),%dl
  800d42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	74 09                	je     800d56 <strlcpy+0x3c>
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	75 d8                	jne    800d2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	29 c2                	sub    %eax,%edx
  800d64:	89 d0                	mov    %edx,%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6b:	eb 06                	jmp    800d73 <strcmp+0xb>
		p++, q++;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 0e                	je     800d8a <strcmp+0x22>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 10                	mov    (%eax),%dl
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	38 c2                	cmp    %al,%dl
  800d88:	74 e3                	je     800d6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 d0             	movzbl %al,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f b6 c0             	movzbl %al,%eax
  800d9a:	29 c2                	sub    %eax,%edx
  800d9c:	89 d0                	mov    %edx,%eax
}
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da3:	eb 09                	jmp    800dae <strncmp+0xe>
		n--, p++, q++;
  800da5:	ff 4d 10             	decl   0x10(%ebp)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db2:	74 17                	je     800dcb <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 0e                	je     800dcb <strncmp+0x2b>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	38 c2                	cmp    %al,%dl
  800dc9:	74 da                	je     800da5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 07                	jne    800dd8 <strncmp+0x38>
		return 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	eb 14                	jmp    800dec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfa:	eb 12                	jmp    800e0e <strchr+0x20>
		if (*s == c)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e04:	75 05                	jne    800e0b <strchr+0x1d>
			return (char *) s;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	eb 11                	jmp    800e1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e5                	jne    800dfc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2a:	eb 0d                	jmp    800e39 <strfind+0x1b>
		if (*s == c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e34:	74 0e                	je     800e44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 ea                	jne    800e2c <strfind+0xe>
  800e42:	eb 01                	jmp    800e45 <strfind+0x27>
		if (*s == c)
			break;
  800e44:	90                   	nop
	return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5c:	eb 0e                	jmp    800e6c <memset+0x22>
		*p++ = c;
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6c:	ff 4d f8             	decl   -0x8(%ebp)
  800e6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e73:	79 e9                	jns    800e5e <memset+0x14>
		*p++ = c;

	return v;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8c:	eb 16                	jmp    800ea4 <memcpy+0x2a>
		*d++ = *s++;
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 dd                	jne    800e8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	73 50                	jae    800f20 <memmove+0x6a>
  800ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edb:	76 43                	jbe    800f20 <memmove+0x6a>
		s += n;
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee9:	eb 10                	jmp    800efb <memmove+0x45>
			*--d = *--s;
  800eeb:	ff 4d f8             	decl   -0x8(%ebp)
  800eee:	ff 4d fc             	decl   -0x4(%ebp)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efb:	8b 45 10             	mov    0x10(%ebp),%eax
  800efe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f01:	89 55 10             	mov    %edx,0x10(%ebp)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	75 e3                	jne    800eeb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f08:	eb 23                	jmp    800f2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f26:	89 55 10             	mov    %edx,0x10(%ebp)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	75 dd                	jne    800f0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f44:	eb 2a                	jmp    800f70 <memcmp+0x3e>
		if (*s1 != *s2)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 16                	je     800f6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 d0             	movzbl %al,%edx
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	29 c2                	sub    %eax,%edx
  800f66:	89 d0                	mov    %edx,%eax
  800f68:	eb 18                	jmp    800f82 <memcmp+0x50>
		s1++, s2++;
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 c9                	jne    800f46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f95:	eb 15                	jmp    800fac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f b6 d0             	movzbl %al,%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	39 c2                	cmp    %eax,%edx
  800fa7:	74 0d                	je     800fb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb2:	72 e3                	jb     800f97 <memfind+0x13>
  800fb4:	eb 01                	jmp    800fb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb6:	90                   	nop
	return (void *) s;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd0:	eb 03                	jmp    800fd5 <strtol+0x19>
		s++;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 20                	cmp    $0x20,%al
  800fdc:	74 f4                	je     800fd2 <strtol+0x16>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 09                	cmp    $0x9,%al
  800fe5:	74 eb                	je     800fd2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 2b                	cmp    $0x2b,%al
  800fee:	75 05                	jne    800ff5 <strtol+0x39>
		s++;
  800ff0:	ff 45 08             	incl   0x8(%ebp)
  800ff3:	eb 13                	jmp    801008 <strtol+0x4c>
	else if (*s == '-')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2d                	cmp    $0x2d,%al
  800ffc:	75 0a                	jne    801008 <strtol+0x4c>
		s++, neg = 1;
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	74 06                	je     801014 <strtol+0x58>
  80100e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801012:	75 20                	jne    801034 <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 30                	cmp    $0x30,%al
  80101b:	75 17                	jne    801034 <strtol+0x78>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	40                   	inc    %eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 78                	cmp    $0x78,%al
  801025:	75 0d                	jne    801034 <strtol+0x78>
		s += 2, base = 16;
  801027:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801032:	eb 28                	jmp    80105c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801038:	75 15                	jne    80104f <strtol+0x93>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 30                	cmp    $0x30,%al
  801041:	75 0c                	jne    80104f <strtol+0x93>
		s++, base = 8;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104d:	eb 0d                	jmp    80105c <strtol+0xa0>
	else if (base == 0)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	75 07                	jne    80105c <strtol+0xa0>
		base = 10;
  801055:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 2f                	cmp    $0x2f,%al
  801063:	7e 19                	jle    80107e <strtol+0xc2>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 39                	cmp    $0x39,%al
  80106c:	7f 10                	jg     80107e <strtol+0xc2>
			dig = *s - '0';
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	0f be c0             	movsbl %al,%eax
  801076:	83 e8 30             	sub    $0x30,%eax
  801079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107c:	eb 42                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 60                	cmp    $0x60,%al
  801085:	7e 19                	jle    8010a0 <strtol+0xe4>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 7a                	cmp    $0x7a,%al
  80108e:	7f 10                	jg     8010a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f be c0             	movsbl %al,%eax
  801098:	83 e8 57             	sub    $0x57,%eax
  80109b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109e:	eb 20                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 40                	cmp    $0x40,%al
  8010a7:	7e 39                	jle    8010e2 <strtol+0x126>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 5a                	cmp    $0x5a,%al
  8010b0:	7f 30                	jg     8010e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 37             	sub    $0x37,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c6:	7d 19                	jge    8010e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c8:	ff 45 08             	incl   0x8(%ebp)
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010dc:	e9 7b ff ff ff       	jmp    80105c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e6:	74 08                	je     8010f0 <strtol+0x134>
		*endptr = (char *) s;
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f4:	74 07                	je     8010fd <strtol+0x141>
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	f7 d8                	neg    %eax
  8010fb:	eb 03                	jmp    801100 <strtol+0x144>
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <ltostr>:

void
ltostr(long value, char *str)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111a:	79 13                	jns    80112f <ltostr+0x2d>
	{
		neg = 1;
  80111c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801129:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801137:	99                   	cltd   
  801138:	f7 f9                	idiv   %ecx
  80113a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8d 50 01             	lea    0x1(%eax),%edx
  801143:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801150:	83 c2 30             	add    $0x30,%edx
  801153:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115d:	f7 e9                	imul   %ecx
  80115f:	c1 fa 02             	sar    $0x2,%edx
  801162:	89 c8                	mov    %ecx,%eax
  801164:	c1 f8 1f             	sar    $0x1f,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80116e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801171:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801176:	f7 e9                	imul   %ecx
  801178:	c1 fa 02             	sar    $0x2,%edx
  80117b:	89 c8                	mov    %ecx,%eax
  80117d:	c1 f8 1f             	sar    $0x1f,%eax
  801180:	29 c2                	sub    %eax,%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	c1 e0 02             	shl    $0x2,%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	01 c0                	add    %eax,%eax
  80118b:	29 c1                	sub    %eax,%ecx
  80118d:	89 ca                	mov    %ecx,%edx
  80118f:	85 d2                	test   %edx,%edx
  801191:	75 9c                	jne    80112f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	48                   	dec    %eax
  80119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a5:	74 3d                	je     8011e4 <ltostr+0xe2>
		start = 1 ;
  8011a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ae:	eb 34                	jmp    8011e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	01 c2                	add    %eax,%edx
  8011c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	01 c8                	add    %ecx,%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	01 c2                	add    %eax,%edx
  8011d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8011de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c c4                	jl     8011b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	e8 54 fa ff ff       	call   800c5c <strlen>
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	e8 46 fa ff ff       	call   800c5c <strlen>
  801216:	83 c4 04             	add    $0x4,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80122a:	eb 17                	jmp    801243 <strcconcat+0x49>
		final[s] = str1[s] ;
  80122c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	01 c2                	add    %eax,%edx
  801234:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 c8                	add    %ecx,%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801240:	ff 45 fc             	incl   -0x4(%ebp)
  801243:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801246:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801249:	7c e1                	jl     80122c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80124b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801259:	eb 1f                	jmp    80127a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	8d 50 01             	lea    0x1(%eax),%edx
  801261:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801264:	89 c2                	mov    %eax,%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 c2                	add    %eax,%edx
  80126b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801277:	ff 45 f8             	incl   -0x8(%ebp)
  80127a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801280:	7c d9                	jl     80125b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c6 00 00             	movb   $0x0,(%eax)
}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80129c:	8b 45 14             	mov    0x14(%ebp),%eax
  80129f:	8b 00                	mov    (%eax),%eax
  8012a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b3:	eb 0c                	jmp    8012c1 <strsplit+0x31>
			*string++ = 0;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8d 50 01             	lea    0x1(%eax),%edx
  8012bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	74 18                	je     8012e2 <strsplit+0x52>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	e8 13 fb ff ff       	call   800dee <strchr>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 d3                	jne    8012b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 5a                	je     801345 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	83 f8 0f             	cmp    $0xf,%eax
  8012f3:	75 07                	jne    8012fc <strsplit+0x6c>
		{
			return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	eb 66                	jmp    801362 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	8d 48 01             	lea    0x1(%eax),%ecx
  801304:	8b 55 14             	mov    0x14(%ebp),%edx
  801307:	89 0a                	mov    %ecx,(%edx)
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 c2                	add    %eax,%edx
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131a:	eb 03                	jmp    80131f <strsplit+0x8f>
			string++;
  80131c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	84 c0                	test   %al,%al
  801326:	74 8b                	je     8012b3 <strsplit+0x23>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	0f be c0             	movsbl %al,%eax
  801330:	50                   	push   %eax
  801331:	ff 75 0c             	pushl  0xc(%ebp)
  801334:	e8 b5 fa ff ff       	call   800dee <strchr>
  801339:	83 c4 08             	add    $0x8,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	74 dc                	je     80131c <strsplit+0x8c>
			string++;
	}
  801340:	e9 6e ff ff ff       	jmp    8012b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801345:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80135d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80136a:	a1 04 40 80 00       	mov    0x804004,%eax
  80136f:	85 c0                	test   %eax,%eax
  801371:	74 1f                	je     801392 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801373:	e8 1d 00 00 00       	call   801395 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	68 90 39 80 00       	push   $0x803990
  801380:	e8 55 f2 ff ff       	call   8005da <cprintf>
  801385:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801388:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80138f:	00 00 00 
	}
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80139b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013a2:	00 00 00 
  8013a5:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013ac:	00 00 00 
  8013af:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013b6:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8013b9:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013c0:	00 00 00 
  8013c3:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013ca:	00 00 00 
  8013cd:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013d4:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8013d7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013eb:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8013f0:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013f7:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8013fa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801404:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801409:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80140c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80140f:	ba 00 00 00 00       	mov    $0x0,%edx
  801414:	f7 75 f0             	divl   -0x10(%ebp)
  801417:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80141a:	29 d0                	sub    %edx,%eax
  80141c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  80141f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801429:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80142e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	6a 06                	push   $0x6
  801438:	ff 75 e8             	pushl  -0x18(%ebp)
  80143b:	50                   	push   %eax
  80143c:	e8 d4 05 00 00       	call   801a15 <sys_allocate_chunk>
  801441:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801444:	a1 20 41 80 00       	mov    0x804120,%eax
  801449:	83 ec 0c             	sub    $0xc,%esp
  80144c:	50                   	push   %eax
  80144d:	e8 49 0c 00 00       	call   80209b <initialize_MemBlocksList>
  801452:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801455:	a1 48 41 80 00       	mov    0x804148,%eax
  80145a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  80145d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801461:	75 14                	jne    801477 <initialize_dyn_block_system+0xe2>
  801463:	83 ec 04             	sub    $0x4,%esp
  801466:	68 b5 39 80 00       	push   $0x8039b5
  80146b:	6a 39                	push   $0x39
  80146d:	68 d3 39 80 00       	push   $0x8039d3
  801472:	e8 af ee ff ff       	call   800326 <_panic>
  801477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	85 c0                	test   %eax,%eax
  80147e:	74 10                	je     801490 <initialize_dyn_block_system+0xfb>
  801480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801488:	8b 52 04             	mov    0x4(%edx),%edx
  80148b:	89 50 04             	mov    %edx,0x4(%eax)
  80148e:	eb 0b                	jmp    80149b <initialize_dyn_block_system+0x106>
  801490:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801493:	8b 40 04             	mov    0x4(%eax),%eax
  801496:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80149b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149e:	8b 40 04             	mov    0x4(%eax),%eax
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	74 0f                	je     8014b4 <initialize_dyn_block_system+0x11f>
  8014a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a8:	8b 40 04             	mov    0x4(%eax),%eax
  8014ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014ae:	8b 12                	mov    (%edx),%edx
  8014b0:	89 10                	mov    %edx,(%eax)
  8014b2:	eb 0a                	jmp    8014be <initialize_dyn_block_system+0x129>
  8014b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b7:	8b 00                	mov    (%eax),%eax
  8014b9:	a3 48 41 80 00       	mov    %eax,0x804148
  8014be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014d1:	a1 54 41 80 00       	mov    0x804154,%eax
  8014d6:	48                   	dec    %eax
  8014d7:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  8014dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014df:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8014e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e9:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8014f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014f4:	75 14                	jne    80150a <initialize_dyn_block_system+0x175>
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	68 e0 39 80 00       	push   $0x8039e0
  8014fe:	6a 3f                	push   $0x3f
  801500:	68 d3 39 80 00       	push   $0x8039d3
  801505:	e8 1c ee ff ff       	call   800326 <_panic>
  80150a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801510:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801513:	89 10                	mov    %edx,(%eax)
  801515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801518:	8b 00                	mov    (%eax),%eax
  80151a:	85 c0                	test   %eax,%eax
  80151c:	74 0d                	je     80152b <initialize_dyn_block_system+0x196>
  80151e:	a1 38 41 80 00       	mov    0x804138,%eax
  801523:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801526:	89 50 04             	mov    %edx,0x4(%eax)
  801529:	eb 08                	jmp    801533 <initialize_dyn_block_system+0x19e>
  80152b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801536:	a3 38 41 80 00       	mov    %eax,0x804138
  80153b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801545:	a1 44 41 80 00       	mov    0x804144,%eax
  80154a:	40                   	inc    %eax
  80154b:	a3 44 41 80 00       	mov    %eax,0x804144

}
  801550:	90                   	nop
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801559:	e8 06 fe ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  80155e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801562:	75 07                	jne    80156b <malloc+0x18>
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
  801569:	eb 7d                	jmp    8015e8 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80156b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801572:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801579:	8b 55 08             	mov    0x8(%ebp),%edx
  80157c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	48                   	dec    %eax
  801582:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801588:	ba 00 00 00 00       	mov    $0x0,%edx
  80158d:	f7 75 f0             	divl   -0x10(%ebp)
  801590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801593:	29 d0                	sub    %edx,%eax
  801595:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801598:	e8 46 08 00 00       	call   801de3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80159d:	83 f8 01             	cmp    $0x1,%eax
  8015a0:	75 07                	jne    8015a9 <malloc+0x56>
  8015a2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8015a9:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8015ad:	75 34                	jne    8015e3 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8015af:	83 ec 0c             	sub    $0xc,%esp
  8015b2:	ff 75 e8             	pushl  -0x18(%ebp)
  8015b5:	e8 73 0e 00 00       	call   80242d <alloc_block_FF>
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  8015c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015c4:	74 16                	je     8015dc <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015cc:	e8 ff 0b 00 00       	call   8021d0 <insert_sorted_allocList>
  8015d1:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8015d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d7:	8b 40 08             	mov    0x8(%eax),%eax
  8015da:	eb 0c                	jmp    8015e8 <malloc+0x95>
	             }
	             else
	             	return NULL;
  8015dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e1:	eb 05                	jmp    8015e8 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8015e3:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8015f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801604:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801607:	83 ec 08             	sub    $0x8,%esp
  80160a:	ff 75 f4             	pushl  -0xc(%ebp)
  80160d:	68 40 40 80 00       	push   $0x804040
  801612:	e8 61 0b 00 00       	call   802178 <find_block>
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80161d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801621:	0f 84 a5 00 00 00    	je     8016cc <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801627:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162a:	8b 40 0c             	mov    0xc(%eax),%eax
  80162d:	83 ec 08             	sub    $0x8,%esp
  801630:	50                   	push   %eax
  801631:	ff 75 f4             	pushl  -0xc(%ebp)
  801634:	e8 a4 03 00 00       	call   8019dd <sys_free_user_mem>
  801639:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80163c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801640:	75 17                	jne    801659 <free+0x6f>
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	68 b5 39 80 00       	push   $0x8039b5
  80164a:	68 87 00 00 00       	push   $0x87
  80164f:	68 d3 39 80 00       	push   $0x8039d3
  801654:	e8 cd ec ff ff       	call   800326 <_panic>
  801659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165c:	8b 00                	mov    (%eax),%eax
  80165e:	85 c0                	test   %eax,%eax
  801660:	74 10                	je     801672 <free+0x88>
  801662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801665:	8b 00                	mov    (%eax),%eax
  801667:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80166a:	8b 52 04             	mov    0x4(%edx),%edx
  80166d:	89 50 04             	mov    %edx,0x4(%eax)
  801670:	eb 0b                	jmp    80167d <free+0x93>
  801672:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801675:	8b 40 04             	mov    0x4(%eax),%eax
  801678:	a3 44 40 80 00       	mov    %eax,0x804044
  80167d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801680:	8b 40 04             	mov    0x4(%eax),%eax
  801683:	85 c0                	test   %eax,%eax
  801685:	74 0f                	je     801696 <free+0xac>
  801687:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168a:	8b 40 04             	mov    0x4(%eax),%eax
  80168d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801690:	8b 12                	mov    (%edx),%edx
  801692:	89 10                	mov    %edx,(%eax)
  801694:	eb 0a                	jmp    8016a0 <free+0xb6>
  801696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801699:	8b 00                	mov    (%eax),%eax
  80169b:	a3 40 40 80 00       	mov    %eax,0x804040
  8016a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016b3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016b8:	48                   	dec    %eax
  8016b9:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  8016be:	83 ec 0c             	sub    $0xc,%esp
  8016c1:	ff 75 ec             	pushl  -0x14(%ebp)
  8016c4:	e8 37 12 00 00       	call   802900 <insert_sorted_with_merge_freeList>
  8016c9:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  8016cc:	90                   	nop
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 38             	sub    $0x38,%esp
  8016d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d8:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016db:	e8 84 fc ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016e4:	75 07                	jne    8016ed <smalloc+0x1e>
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	eb 7e                	jmp    80176b <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8016ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016f4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801701:	01 d0                	add    %edx,%eax
  801703:	48                   	dec    %eax
  801704:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170a:	ba 00 00 00 00       	mov    $0x0,%edx
  80170f:	f7 75 f0             	divl   -0x10(%ebp)
  801712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801715:	29 d0                	sub    %edx,%eax
  801717:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80171a:	e8 c4 06 00 00       	call   801de3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80171f:	83 f8 01             	cmp    $0x1,%eax
  801722:	75 42                	jne    801766 <smalloc+0x97>

		  va = malloc(newsize) ;
  801724:	83 ec 0c             	sub    $0xc,%esp
  801727:	ff 75 e8             	pushl  -0x18(%ebp)
  80172a:	e8 24 fe ff ff       	call   801553 <malloc>
  80172f:	83 c4 10             	add    $0x10,%esp
  801732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801735:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801739:	74 24                	je     80175f <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80173b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80173f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801742:	50                   	push   %eax
  801743:	ff 75 e8             	pushl  -0x18(%ebp)
  801746:	ff 75 08             	pushl  0x8(%ebp)
  801749:	e8 1a 04 00 00       	call   801b68 <sys_createSharedObject>
  80174e:	83 c4 10             	add    $0x10,%esp
  801751:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801754:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801758:	78 0c                	js     801766 <smalloc+0x97>
					  return va ;
  80175a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80175d:	eb 0c                	jmp    80176b <smalloc+0x9c>
				 }
				 else
					return NULL;
  80175f:	b8 00 00 00 00       	mov    $0x0,%eax
  801764:	eb 05                	jmp    80176b <smalloc+0x9c>
	  }
		  return NULL ;
  801766:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801773:	e8 ec fb ff ff       	call   801364 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	ff 75 0c             	pushl  0xc(%ebp)
  80177e:	ff 75 08             	pushl  0x8(%ebp)
  801781:	e8 0c 04 00 00       	call   801b92 <sys_getSizeOfSharedObject>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80178c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801790:	75 07                	jne    801799 <sget+0x2c>
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
  801797:	eb 75                	jmp    80180e <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801799:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a6:	01 d0                	add    %edx,%eax
  8017a8:	48                   	dec    %eax
  8017a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017af:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b4:	f7 75 f0             	divl   -0x10(%ebp)
  8017b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ba:	29 d0                	sub    %edx,%eax
  8017bc:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  8017bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8017c6:	e8 18 06 00 00       	call   801de3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017cb:	83 f8 01             	cmp    $0x1,%eax
  8017ce:	75 39                	jne    801809 <sget+0x9c>

		  va = malloc(newsize) ;
  8017d0:	83 ec 0c             	sub    $0xc,%esp
  8017d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d6:	e8 78 fd ff ff       	call   801553 <malloc>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8017e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017e5:	74 22                	je     801809 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8017e7:	83 ec 04             	sub    $0x4,%esp
  8017ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	e8 b7 03 00 00       	call   801baf <sys_getSharedObject>
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8017fe:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801802:	78 05                	js     801809 <sget+0x9c>
					  return va;
  801804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801807:	eb 05                	jmp    80180e <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801809:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801816:	e8 49 fb ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	68 04 3a 80 00       	push   $0x803a04
  801823:	68 1e 01 00 00       	push   $0x11e
  801828:	68 d3 39 80 00       	push   $0x8039d3
  80182d:	e8 f4 ea ff ff       	call   800326 <_panic>

00801832 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801838:	83 ec 04             	sub    $0x4,%esp
  80183b:	68 2c 3a 80 00       	push   $0x803a2c
  801840:	68 32 01 00 00       	push   $0x132
  801845:	68 d3 39 80 00       	push   $0x8039d3
  80184a:	e8 d7 ea ff ff       	call   800326 <_panic>

0080184f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801855:	83 ec 04             	sub    $0x4,%esp
  801858:	68 50 3a 80 00       	push   $0x803a50
  80185d:	68 3d 01 00 00       	push   $0x13d
  801862:	68 d3 39 80 00       	push   $0x8039d3
  801867:	e8 ba ea ff ff       	call   800326 <_panic>

0080186c <shrink>:

}
void shrink(uint32 newSize)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	68 50 3a 80 00       	push   $0x803a50
  80187a:	68 42 01 00 00       	push   $0x142
  80187f:	68 d3 39 80 00       	push   $0x8039d3
  801884:	e8 9d ea ff ff       	call   800326 <_panic>

00801889 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	68 50 3a 80 00       	push   $0x803a50
  801897:	68 47 01 00 00       	push   $0x147
  80189c:	68 d3 39 80 00       	push   $0x8039d3
  8018a1:	e8 80 ea ff ff       	call   800326 <_panic>

008018a6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	57                   	push   %edi
  8018aa:	56                   	push   %esi
  8018ab:	53                   	push   %ebx
  8018ac:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018bb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018be:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018c1:	cd 30                	int    $0x30
  8018c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	5b                   	pop    %ebx
  8018cd:	5e                   	pop    %esi
  8018ce:	5f                   	pop    %edi
  8018cf:	5d                   	pop    %ebp
  8018d0:	c3                   	ret    

008018d1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 04             	sub    $0x4,%esp
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018dd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	52                   	push   %edx
  8018e9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ec:	50                   	push   %eax
  8018ed:	6a 00                	push   $0x0
  8018ef:	e8 b2 ff ff ff       	call   8018a6 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	90                   	nop
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_cgetc>:

int
sys_cgetc(void)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 01                	push   $0x1
  801909:	e8 98 ff ff ff       	call   8018a6 <syscall>
  80190e:	83 c4 18             	add    $0x18,%esp
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801916:	8b 55 0c             	mov    0xc(%ebp),%edx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	52                   	push   %edx
  801923:	50                   	push   %eax
  801924:	6a 05                	push   $0x5
  801926:	e8 7b ff ff ff       	call   8018a6 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	56                   	push   %esi
  801934:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801935:	8b 75 18             	mov    0x18(%ebp),%esi
  801938:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80193b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	56                   	push   %esi
  801945:	53                   	push   %ebx
  801946:	51                   	push   %ecx
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	6a 06                	push   $0x6
  80194b:	e8 56 ff ff ff       	call   8018a6 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5d                   	pop    %ebp
  801959:	c3                   	ret    

0080195a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80195d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	6a 07                	push   $0x7
  80196d:	e8 34 ff ff ff       	call   8018a6 <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	6a 08                	push   $0x8
  801988:	e8 19 ff ff ff       	call   8018a6 <syscall>
  80198d:	83 c4 18             	add    $0x18,%esp
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 09                	push   $0x9
  8019a1:	e8 00 ff ff ff       	call   8018a6 <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 0a                	push   $0xa
  8019ba:	e8 e7 fe ff ff       	call   8018a6 <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 0b                	push   $0xb
  8019d3:	e8 ce fe ff ff       	call   8018a6 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	6a 0f                	push   $0xf
  8019ee:	e8 b3 fe ff ff       	call   8018a6 <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
	return;
  8019f6:	90                   	nop
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	ff 75 08             	pushl  0x8(%ebp)
  801a08:	6a 10                	push   $0x10
  801a0a:	e8 97 fe ff ff       	call   8018a6 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a12:	90                   	nop
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	ff 75 10             	pushl  0x10(%ebp)
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	ff 75 08             	pushl  0x8(%ebp)
  801a25:	6a 11                	push   $0x11
  801a27:	e8 7a fe ff ff       	call   8018a6 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2f:	90                   	nop
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 0c                	push   $0xc
  801a41:	e8 60 fe ff ff       	call   8018a6 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 08             	pushl  0x8(%ebp)
  801a59:	6a 0d                	push   $0xd
  801a5b:	e8 46 fe ff ff       	call   8018a6 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 0e                	push   $0xe
  801a74:	e8 2d fe ff ff       	call   8018a6 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 13                	push   $0x13
  801a8e:	e8 13 fe ff ff       	call   8018a6 <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	90                   	nop
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 14                	push   $0x14
  801aa8:	e8 f9 fd ff ff       	call   8018a6 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	90                   	nop
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 04             	sub    $0x4,%esp
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801abf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	50                   	push   %eax
  801acc:	6a 15                	push   $0x15
  801ace:	e8 d3 fd ff ff       	call   8018a6 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 16                	push   $0x16
  801ae8:	e8 b9 fd ff ff       	call   8018a6 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	90                   	nop
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	50                   	push   %eax
  801b03:	6a 17                	push   $0x17
  801b05:	e8 9c fd ff ff       	call   8018a6 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	52                   	push   %edx
  801b1f:	50                   	push   %eax
  801b20:	6a 1a                	push   $0x1a
  801b22:	e8 7f fd ff ff       	call   8018a6 <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 18                	push   $0x18
  801b3f:	e8 62 fd ff ff       	call   8018a6 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	52                   	push   %edx
  801b5a:	50                   	push   %eax
  801b5b:	6a 19                	push   $0x19
  801b5d:	e8 44 fd ff ff       	call   8018a6 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	90                   	nop
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	83 ec 04             	sub    $0x4,%esp
  801b6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b71:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b74:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b77:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	51                   	push   %ecx
  801b81:	52                   	push   %edx
  801b82:	ff 75 0c             	pushl  0xc(%ebp)
  801b85:	50                   	push   %eax
  801b86:	6a 1b                	push   $0x1b
  801b88:	e8 19 fd ff ff       	call   8018a6 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 1c                	push   $0x1c
  801ba5:	e8 fc fc ff ff       	call   8018a6 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bb2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	51                   	push   %ecx
  801bc0:	52                   	push   %edx
  801bc1:	50                   	push   %eax
  801bc2:	6a 1d                	push   $0x1d
  801bc4:	e8 dd fc ff ff       	call   8018a6 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	52                   	push   %edx
  801bde:	50                   	push   %eax
  801bdf:	6a 1e                	push   $0x1e
  801be1:	e8 c0 fc ff ff       	call   8018a6 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 1f                	push   $0x1f
  801bfa:	e8 a7 fc ff ff       	call   8018a6 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c07:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0a:	6a 00                	push   $0x0
  801c0c:	ff 75 14             	pushl  0x14(%ebp)
  801c0f:	ff 75 10             	pushl  0x10(%ebp)
  801c12:	ff 75 0c             	pushl  0xc(%ebp)
  801c15:	50                   	push   %eax
  801c16:	6a 20                	push   $0x20
  801c18:	e8 89 fc ff ff       	call   8018a6 <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	50                   	push   %eax
  801c31:	6a 21                	push   $0x21
  801c33:	e8 6e fc ff ff       	call   8018a6 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	90                   	nop
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	50                   	push   %eax
  801c4d:	6a 22                	push   $0x22
  801c4f:	e8 52 fc ff ff       	call   8018a6 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 02                	push   $0x2
  801c68:	e8 39 fc ff ff       	call   8018a6 <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 03                	push   $0x3
  801c81:	e8 20 fc ff ff       	call   8018a6 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 04                	push   $0x4
  801c9a:	e8 07 fc ff ff       	call   8018a6 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_exit_env>:


void sys_exit_env(void)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 23                	push   $0x23
  801cb3:	e8 ee fb ff ff       	call   8018a6 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	90                   	nop
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cc4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc7:	8d 50 04             	lea    0x4(%eax),%edx
  801cca:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	52                   	push   %edx
  801cd4:	50                   	push   %eax
  801cd5:	6a 24                	push   $0x24
  801cd7:	e8 ca fb ff ff       	call   8018a6 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
	return result;
  801cdf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ce2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ce8:	89 01                	mov    %eax,(%ecx)
  801cea:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	c9                   	leave  
  801cf1:	c2 04 00             	ret    $0x4

00801cf4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	ff 75 10             	pushl  0x10(%ebp)
  801cfe:	ff 75 0c             	pushl  0xc(%ebp)
  801d01:	ff 75 08             	pushl  0x8(%ebp)
  801d04:	6a 12                	push   $0x12
  801d06:	e8 9b fb ff ff       	call   8018a6 <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0e:	90                   	nop
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 25                	push   $0x25
  801d20:	e8 81 fb ff ff       	call   8018a6 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 04             	sub    $0x4,%esp
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d36:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	50                   	push   %eax
  801d43:	6a 26                	push   $0x26
  801d45:	e8 5c fb ff ff       	call   8018a6 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4d:	90                   	nop
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <rsttst>:
void rsttst()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 28                	push   $0x28
  801d5f:	e8 42 fb ff ff       	call   8018a6 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
	return ;
  801d67:	90                   	nop
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	8b 45 14             	mov    0x14(%ebp),%eax
  801d73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d76:	8b 55 18             	mov    0x18(%ebp),%edx
  801d79:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d7d:	52                   	push   %edx
  801d7e:	50                   	push   %eax
  801d7f:	ff 75 10             	pushl  0x10(%ebp)
  801d82:	ff 75 0c             	pushl  0xc(%ebp)
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	6a 27                	push   $0x27
  801d8a:	e8 17 fb ff ff       	call   8018a6 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d92:	90                   	nop
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <chktst>:
void chktst(uint32 n)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	ff 75 08             	pushl  0x8(%ebp)
  801da3:	6a 29                	push   $0x29
  801da5:	e8 fc fa ff ff       	call   8018a6 <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dad:	90                   	nop
}
  801dae:	c9                   	leave  
  801daf:	c3                   	ret    

00801db0 <inctst>:

void inctst()
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 2a                	push   $0x2a
  801dbf:	e8 e2 fa ff ff       	call   8018a6 <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc7:	90                   	nop
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <gettst>:
uint32 gettst()
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 2b                	push   $0x2b
  801dd9:	e8 c8 fa ff ff       	call   8018a6 <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 2c                	push   $0x2c
  801df5:	e8 ac fa ff ff       	call   8018a6 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
  801dfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e00:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e04:	75 07                	jne    801e0d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e06:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0b:	eb 05                	jmp    801e12 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 2c                	push   $0x2c
  801e26:	e8 7b fa ff ff       	call   8018a6 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
  801e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e31:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e35:	75 07                	jne    801e3e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e37:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3c:	eb 05                	jmp    801e43 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 2c                	push   $0x2c
  801e57:	e8 4a fa ff ff       	call   8018a6 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
  801e5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e62:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e66:	75 07                	jne    801e6f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e68:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6d:	eb 05                	jmp    801e74 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 2c                	push   $0x2c
  801e88:	e8 19 fa ff ff       	call   8018a6 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
  801e90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e93:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e97:	75 07                	jne    801ea0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e99:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9e:	eb 05                	jmp    801ea5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ea0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	6a 2d                	push   $0x2d
  801eb7:	e8 ea f9 ff ff       	call   8018a6 <syscall>
  801ebc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebf:	90                   	nop
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ec6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	6a 00                	push   $0x0
  801ed4:	53                   	push   %ebx
  801ed5:	51                   	push   %ecx
  801ed6:	52                   	push   %edx
  801ed7:	50                   	push   %eax
  801ed8:	6a 2e                	push   $0x2e
  801eda:	e8 c7 f9 ff ff       	call   8018a6 <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
}
  801ee2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	52                   	push   %edx
  801ef7:	50                   	push   %eax
  801ef8:	6a 2f                	push   $0x2f
  801efa:	e8 a7 f9 ff ff       	call   8018a6 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	c9                   	leave  
  801f03:	c3                   	ret    

00801f04 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	68 60 3a 80 00       	push   $0x803a60
  801f12:	e8 c3 e6 ff ff       	call   8005da <cprintf>
  801f17:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f21:	83 ec 0c             	sub    $0xc,%esp
  801f24:	68 8c 3a 80 00       	push   $0x803a8c
  801f29:	e8 ac e6 ff ff       	call   8005da <cprintf>
  801f2e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f31:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f35:	a1 38 41 80 00       	mov    0x804138,%eax
  801f3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3d:	eb 56                	jmp    801f95 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f43:	74 1c                	je     801f61 <print_mem_block_lists+0x5d>
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 50 08             	mov    0x8(%eax),%edx
  801f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f54:	8b 40 0c             	mov    0xc(%eax),%eax
  801f57:	01 c8                	add    %ecx,%eax
  801f59:	39 c2                	cmp    %eax,%edx
  801f5b:	73 04                	jae    801f61 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f5d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	8b 50 08             	mov    0x8(%eax),%edx
  801f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6d:	01 c2                	add    %eax,%edx
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	8b 40 08             	mov    0x8(%eax),%eax
  801f75:	83 ec 04             	sub    $0x4,%esp
  801f78:	52                   	push   %edx
  801f79:	50                   	push   %eax
  801f7a:	68 a1 3a 80 00       	push   $0x803aa1
  801f7f:	e8 56 e6 ff ff       	call   8005da <cprintf>
  801f84:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f8d:	a1 40 41 80 00       	mov    0x804140,%eax
  801f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f99:	74 07                	je     801fa2 <print_mem_block_lists+0x9e>
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	8b 00                	mov    (%eax),%eax
  801fa0:	eb 05                	jmp    801fa7 <print_mem_block_lists+0xa3>
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa7:	a3 40 41 80 00       	mov    %eax,0x804140
  801fac:	a1 40 41 80 00       	mov    0x804140,%eax
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	75 8a                	jne    801f3f <print_mem_block_lists+0x3b>
  801fb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb9:	75 84                	jne    801f3f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fbb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fbf:	75 10                	jne    801fd1 <print_mem_block_lists+0xcd>
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	68 b0 3a 80 00       	push   $0x803ab0
  801fc9:	e8 0c e6 ff ff       	call   8005da <cprintf>
  801fce:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fd1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	68 d4 3a 80 00       	push   $0x803ad4
  801fe0:	e8 f5 e5 ff ff       	call   8005da <cprintf>
  801fe5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fe8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fec:	a1 40 40 80 00       	mov    0x804040,%eax
  801ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff4:	eb 56                	jmp    80204c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ff6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ffa:	74 1c                	je     802018 <print_mem_block_lists+0x114>
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	8b 50 08             	mov    0x8(%eax),%edx
  802002:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802005:	8b 48 08             	mov    0x8(%eax),%ecx
  802008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200b:	8b 40 0c             	mov    0xc(%eax),%eax
  80200e:	01 c8                	add    %ecx,%eax
  802010:	39 c2                	cmp    %eax,%edx
  802012:	73 04                	jae    802018 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802014:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	8b 50 08             	mov    0x8(%eax),%edx
  80201e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802021:	8b 40 0c             	mov    0xc(%eax),%eax
  802024:	01 c2                	add    %eax,%edx
  802026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802029:	8b 40 08             	mov    0x8(%eax),%eax
  80202c:	83 ec 04             	sub    $0x4,%esp
  80202f:	52                   	push   %edx
  802030:	50                   	push   %eax
  802031:	68 a1 3a 80 00       	push   $0x803aa1
  802036:	e8 9f e5 ff ff       	call   8005da <cprintf>
  80203b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802044:	a1 48 40 80 00       	mov    0x804048,%eax
  802049:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80204c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802050:	74 07                	je     802059 <print_mem_block_lists+0x155>
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	8b 00                	mov    (%eax),%eax
  802057:	eb 05                	jmp    80205e <print_mem_block_lists+0x15a>
  802059:	b8 00 00 00 00       	mov    $0x0,%eax
  80205e:	a3 48 40 80 00       	mov    %eax,0x804048
  802063:	a1 48 40 80 00       	mov    0x804048,%eax
  802068:	85 c0                	test   %eax,%eax
  80206a:	75 8a                	jne    801ff6 <print_mem_block_lists+0xf2>
  80206c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802070:	75 84                	jne    801ff6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802072:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802076:	75 10                	jne    802088 <print_mem_block_lists+0x184>
  802078:	83 ec 0c             	sub    $0xc,%esp
  80207b:	68 ec 3a 80 00       	push   $0x803aec
  802080:	e8 55 e5 ff ff       	call   8005da <cprintf>
  802085:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	68 60 3a 80 00       	push   $0x803a60
  802090:	e8 45 e5 ff ff       	call   8005da <cprintf>
  802095:	83 c4 10             	add    $0x10,%esp

}
  802098:	90                   	nop
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8020a1:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020a8:	00 00 00 
  8020ab:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020b2:	00 00 00 
  8020b5:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020bc:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8020bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020c6:	e9 9e 00 00 00       	jmp    802169 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8020cb:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d3:	c1 e2 04             	shl    $0x4,%edx
  8020d6:	01 d0                	add    %edx,%eax
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	75 14                	jne    8020f0 <initialize_MemBlocksList+0x55>
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	68 14 3b 80 00       	push   $0x803b14
  8020e4:	6a 47                	push   $0x47
  8020e6:	68 37 3b 80 00       	push   $0x803b37
  8020eb:	e8 36 e2 ff ff       	call   800326 <_panic>
  8020f0:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f8:	c1 e2 04             	shl    $0x4,%edx
  8020fb:	01 d0                	add    %edx,%eax
  8020fd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802103:	89 10                	mov    %edx,(%eax)
  802105:	8b 00                	mov    (%eax),%eax
  802107:	85 c0                	test   %eax,%eax
  802109:	74 18                	je     802123 <initialize_MemBlocksList+0x88>
  80210b:	a1 48 41 80 00       	mov    0x804148,%eax
  802110:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802116:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802119:	c1 e1 04             	shl    $0x4,%ecx
  80211c:	01 ca                	add    %ecx,%edx
  80211e:	89 50 04             	mov    %edx,0x4(%eax)
  802121:	eb 12                	jmp    802135 <initialize_MemBlocksList+0x9a>
  802123:	a1 50 40 80 00       	mov    0x804050,%eax
  802128:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212b:	c1 e2 04             	shl    $0x4,%edx
  80212e:	01 d0                	add    %edx,%eax
  802130:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802135:	a1 50 40 80 00       	mov    0x804050,%eax
  80213a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213d:	c1 e2 04             	shl    $0x4,%edx
  802140:	01 d0                	add    %edx,%eax
  802142:	a3 48 41 80 00       	mov    %eax,0x804148
  802147:	a1 50 40 80 00       	mov    0x804050,%eax
  80214c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214f:	c1 e2 04             	shl    $0x4,%edx
  802152:	01 d0                	add    %edx,%eax
  802154:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215b:	a1 54 41 80 00       	mov    0x804154,%eax
  802160:	40                   	inc    %eax
  802161:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802166:	ff 45 f4             	incl   -0xc(%ebp)
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80216f:	0f 82 56 ff ff ff    	jb     8020cb <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802175:	90                   	nop
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	8b 00                	mov    (%eax),%eax
  802183:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802186:	eb 19                	jmp    8021a1 <find_block+0x29>
	{
		if(element->sva == va){
  802188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218b:	8b 40 08             	mov    0x8(%eax),%eax
  80218e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802191:	75 05                	jne    802198 <find_block+0x20>
			 		return element;
  802193:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802196:	eb 36                	jmp    8021ce <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	8b 40 08             	mov    0x8(%eax),%eax
  80219e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a5:	74 07                	je     8021ae <find_block+0x36>
  8021a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021aa:	8b 00                	mov    (%eax),%eax
  8021ac:	eb 05                	jmp    8021b3 <find_block+0x3b>
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b6:	89 42 08             	mov    %eax,0x8(%edx)
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	8b 40 08             	mov    0x8(%eax),%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	75 c5                	jne    802188 <find_block+0x10>
  8021c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021c7:	75 bf                	jne    802188 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8021d6:	a1 44 40 80 00       	mov    0x804044,%eax
  8021db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8021de:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8021e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021ea:	74 0a                	je     8021f6 <insert_sorted_allocList+0x26>
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	8b 40 08             	mov    0x8(%eax),%eax
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	75 65                	jne    80225b <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fa:	75 14                	jne    802210 <insert_sorted_allocList+0x40>
  8021fc:	83 ec 04             	sub    $0x4,%esp
  8021ff:	68 14 3b 80 00       	push   $0x803b14
  802204:	6a 6e                	push   $0x6e
  802206:	68 37 3b 80 00       	push   $0x803b37
  80220b:	e8 16 e1 ff ff       	call   800326 <_panic>
  802210:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	89 10                	mov    %edx,(%eax)
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	8b 00                	mov    (%eax),%eax
  802220:	85 c0                	test   %eax,%eax
  802222:	74 0d                	je     802231 <insert_sorted_allocList+0x61>
  802224:	a1 40 40 80 00       	mov    0x804040,%eax
  802229:	8b 55 08             	mov    0x8(%ebp),%edx
  80222c:	89 50 04             	mov    %edx,0x4(%eax)
  80222f:	eb 08                	jmp    802239 <insert_sorted_allocList+0x69>
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	a3 44 40 80 00       	mov    %eax,0x804044
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	a3 40 40 80 00       	mov    %eax,0x804040
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802250:	40                   	inc    %eax
  802251:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802256:	e9 cf 01 00 00       	jmp    80242a <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225e:	8b 50 08             	mov    0x8(%eax),%edx
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	8b 40 08             	mov    0x8(%eax),%eax
  802267:	39 c2                	cmp    %eax,%edx
  802269:	73 65                	jae    8022d0 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80226b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80226f:	75 14                	jne    802285 <insert_sorted_allocList+0xb5>
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	68 50 3b 80 00       	push   $0x803b50
  802279:	6a 72                	push   $0x72
  80227b:	68 37 3b 80 00       	push   $0x803b37
  802280:	e8 a1 e0 ff ff       	call   800326 <_panic>
  802285:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	89 50 04             	mov    %edx,0x4(%eax)
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	8b 40 04             	mov    0x4(%eax),%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	74 0c                	je     8022a7 <insert_sorted_allocList+0xd7>
  80229b:	a1 44 40 80 00       	mov    0x804044,%eax
  8022a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a3:	89 10                	mov    %edx,(%eax)
  8022a5:	eb 08                	jmp    8022af <insert_sorted_allocList+0xdf>
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	a3 40 40 80 00       	mov    %eax,0x804040
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022c5:	40                   	inc    %eax
  8022c6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8022cb:	e9 5a 01 00 00       	jmp    80242a <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8022d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d3:	8b 50 08             	mov    0x8(%eax),%edx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	8b 40 08             	mov    0x8(%eax),%eax
  8022dc:	39 c2                	cmp    %eax,%edx
  8022de:	75 70                	jne    802350 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8022e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022e4:	74 06                	je     8022ec <insert_sorted_allocList+0x11c>
  8022e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ea:	75 14                	jne    802300 <insert_sorted_allocList+0x130>
  8022ec:	83 ec 04             	sub    $0x4,%esp
  8022ef:	68 74 3b 80 00       	push   $0x803b74
  8022f4:	6a 75                	push   $0x75
  8022f6:	68 37 3b 80 00       	push   $0x803b37
  8022fb:	e8 26 e0 ff ff       	call   800326 <_panic>
  802300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802303:	8b 10                	mov    (%eax),%edx
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	89 10                	mov    %edx,(%eax)
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	8b 00                	mov    (%eax),%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 0b                	je     80231e <insert_sorted_allocList+0x14e>
  802313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	8b 55 08             	mov    0x8(%ebp),%edx
  80231b:	89 50 04             	mov    %edx,0x4(%eax)
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802321:	8b 55 08             	mov    0x8(%ebp),%edx
  802324:	89 10                	mov    %edx,(%eax)
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80232c:	89 50 04             	mov    %edx,0x4(%eax)
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	8b 00                	mov    (%eax),%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	75 08                	jne    802340 <insert_sorted_allocList+0x170>
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	a3 44 40 80 00       	mov    %eax,0x804044
  802340:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802345:	40                   	inc    %eax
  802346:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80234b:	e9 da 00 00 00       	jmp    80242a <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802350:	a1 40 40 80 00       	mov    0x804040,%eax
  802355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802358:	e9 9d 00 00 00       	jmp    8023fa <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	8b 00                	mov    (%eax),%eax
  802362:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	8b 50 08             	mov    0x8(%eax),%edx
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 40 08             	mov    0x8(%eax),%eax
  802371:	39 c2                	cmp    %eax,%edx
  802373:	76 7d                	jbe    8023f2 <insert_sorted_allocList+0x222>
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	8b 50 08             	mov    0x8(%eax),%edx
  80237b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80237e:	8b 40 08             	mov    0x8(%eax),%eax
  802381:	39 c2                	cmp    %eax,%edx
  802383:	73 6d                	jae    8023f2 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802389:	74 06                	je     802391 <insert_sorted_allocList+0x1c1>
  80238b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238f:	75 14                	jne    8023a5 <insert_sorted_allocList+0x1d5>
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	68 74 3b 80 00       	push   $0x803b74
  802399:	6a 7c                	push   $0x7c
  80239b:	68 37 3b 80 00       	push   $0x803b37
  8023a0:	e8 81 df ff ff       	call   800326 <_panic>
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 10                	mov    (%eax),%edx
  8023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ad:	89 10                	mov    %edx,(%eax)
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	74 0b                	je     8023c3 <insert_sorted_allocList+0x1f3>
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 00                	mov    (%eax),%eax
  8023bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c0:	89 50 04             	mov    %edx,0x4(%eax)
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c9:	89 10                	mov    %edx,(%eax)
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d1:	89 50 04             	mov    %edx,0x4(%eax)
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	75 08                	jne    8023e5 <insert_sorted_allocList+0x215>
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	a3 44 40 80 00       	mov    %eax,0x804044
  8023e5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ea:	40                   	inc    %eax
  8023eb:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8023f0:	eb 38                	jmp    80242a <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8023f2:	a1 48 40 80 00       	mov    0x804048,%eax
  8023f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fe:	74 07                	je     802407 <insert_sorted_allocList+0x237>
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	8b 00                	mov    (%eax),%eax
  802405:	eb 05                	jmp    80240c <insert_sorted_allocList+0x23c>
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
  80240c:	a3 48 40 80 00       	mov    %eax,0x804048
  802411:	a1 48 40 80 00       	mov    0x804048,%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	0f 85 3f ff ff ff    	jne    80235d <insert_sorted_allocList+0x18d>
  80241e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802422:	0f 85 35 ff ff ff    	jne    80235d <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802428:	eb 00                	jmp    80242a <insert_sorted_allocList+0x25a>
  80242a:	90                   	nop
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802433:	a1 38 41 80 00       	mov    0x804138,%eax
  802438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243b:	e9 6b 02 00 00       	jmp    8026ab <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 40 0c             	mov    0xc(%eax),%eax
  802446:	3b 45 08             	cmp    0x8(%ebp),%eax
  802449:	0f 85 90 00 00 00    	jne    8024df <alloc_block_FF+0xb2>
			  temp=element;
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802459:	75 17                	jne    802472 <alloc_block_FF+0x45>
  80245b:	83 ec 04             	sub    $0x4,%esp
  80245e:	68 a8 3b 80 00       	push   $0x803ba8
  802463:	68 92 00 00 00       	push   $0x92
  802468:	68 37 3b 80 00       	push   $0x803b37
  80246d:	e8 b4 de ff ff       	call   800326 <_panic>
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 00                	mov    (%eax),%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	74 10                	je     80248b <alloc_block_FF+0x5e>
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 00                	mov    (%eax),%eax
  802480:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802483:	8b 52 04             	mov    0x4(%edx),%edx
  802486:	89 50 04             	mov    %edx,0x4(%eax)
  802489:	eb 0b                	jmp    802496 <alloc_block_FF+0x69>
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 40 04             	mov    0x4(%eax),%eax
  80249c:	85 c0                	test   %eax,%eax
  80249e:	74 0f                	je     8024af <alloc_block_FF+0x82>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 04             	mov    0x4(%eax),%eax
  8024a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a9:	8b 12                	mov    (%edx),%edx
  8024ab:	89 10                	mov    %edx,(%eax)
  8024ad:	eb 0a                	jmp    8024b9 <alloc_block_FF+0x8c>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cc:	a1 44 41 80 00       	mov    0x804144,%eax
  8024d1:	48                   	dec    %eax
  8024d2:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  8024d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024da:	e9 ff 01 00 00       	jmp    8026de <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e8:	0f 86 b5 01 00 00    	jbe    8026a3 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f4:	2b 45 08             	sub    0x8(%ebp),%eax
  8024f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8024fa:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802502:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802506:	75 17                	jne    80251f <alloc_block_FF+0xf2>
  802508:	83 ec 04             	sub    $0x4,%esp
  80250b:	68 a8 3b 80 00       	push   $0x803ba8
  802510:	68 99 00 00 00       	push   $0x99
  802515:	68 37 3b 80 00       	push   $0x803b37
  80251a:	e8 07 de ff ff       	call   800326 <_panic>
  80251f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802522:	8b 00                	mov    (%eax),%eax
  802524:	85 c0                	test   %eax,%eax
  802526:	74 10                	je     802538 <alloc_block_FF+0x10b>
  802528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802530:	8b 52 04             	mov    0x4(%edx),%edx
  802533:	89 50 04             	mov    %edx,0x4(%eax)
  802536:	eb 0b                	jmp    802543 <alloc_block_FF+0x116>
  802538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253b:	8b 40 04             	mov    0x4(%eax),%eax
  80253e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802546:	8b 40 04             	mov    0x4(%eax),%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	74 0f                	je     80255c <alloc_block_FF+0x12f>
  80254d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802550:	8b 40 04             	mov    0x4(%eax),%eax
  802553:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802556:	8b 12                	mov    (%edx),%edx
  802558:	89 10                	mov    %edx,(%eax)
  80255a:	eb 0a                	jmp    802566 <alloc_block_FF+0x139>
  80255c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255f:	8b 00                	mov    (%eax),%eax
  802561:	a3 48 41 80 00       	mov    %eax,0x804148
  802566:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802579:	a1 54 41 80 00       	mov    0x804154,%eax
  80257e:	48                   	dec    %eax
  80257f:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802584:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802588:	75 17                	jne    8025a1 <alloc_block_FF+0x174>
  80258a:	83 ec 04             	sub    $0x4,%esp
  80258d:	68 50 3b 80 00       	push   $0x803b50
  802592:	68 9a 00 00 00       	push   $0x9a
  802597:	68 37 3b 80 00       	push   $0x803b37
  80259c:	e8 85 dd ff ff       	call   800326 <_panic>
  8025a1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8025a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025aa:	89 50 04             	mov    %edx,0x4(%eax)
  8025ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b0:	8b 40 04             	mov    0x4(%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 0c                	je     8025c3 <alloc_block_FF+0x196>
  8025b7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8025bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025bf:	89 10                	mov    %edx,(%eax)
  8025c1:	eb 08                	jmp    8025cb <alloc_block_FF+0x19e>
  8025c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8025cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ce:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025dc:	a1 44 41 80 00       	mov    0x804144,%eax
  8025e1:	40                   	inc    %eax
  8025e2:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  8025e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ed:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 50 08             	mov    0x8(%eax),%edx
  8025f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f9:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802602:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802605:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802608:	8b 50 08             	mov    0x8(%eax),%edx
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	01 c2                	add    %eax,%edx
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802616:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802619:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80261c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802620:	75 17                	jne    802639 <alloc_block_FF+0x20c>
  802622:	83 ec 04             	sub    $0x4,%esp
  802625:	68 a8 3b 80 00       	push   $0x803ba8
  80262a:	68 a2 00 00 00       	push   $0xa2
  80262f:	68 37 3b 80 00       	push   $0x803b37
  802634:	e8 ed dc ff ff       	call   800326 <_panic>
  802639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	85 c0                	test   %eax,%eax
  802640:	74 10                	je     802652 <alloc_block_FF+0x225>
  802642:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80264a:	8b 52 04             	mov    0x4(%edx),%edx
  80264d:	89 50 04             	mov    %edx,0x4(%eax)
  802650:	eb 0b                	jmp    80265d <alloc_block_FF+0x230>
  802652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802655:	8b 40 04             	mov    0x4(%eax),%eax
  802658:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80265d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802660:	8b 40 04             	mov    0x4(%eax),%eax
  802663:	85 c0                	test   %eax,%eax
  802665:	74 0f                	je     802676 <alloc_block_FF+0x249>
  802667:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266a:	8b 40 04             	mov    0x4(%eax),%eax
  80266d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802670:	8b 12                	mov    (%edx),%edx
  802672:	89 10                	mov    %edx,(%eax)
  802674:	eb 0a                	jmp    802680 <alloc_block_FF+0x253>
  802676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802679:	8b 00                	mov    (%eax),%eax
  80267b:	a3 38 41 80 00       	mov    %eax,0x804138
  802680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802683:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802693:	a1 44 41 80 00       	mov    0x804144,%eax
  802698:	48                   	dec    %eax
  802699:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80269e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a1:	eb 3b                	jmp    8026de <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8026a3:	a1 40 41 80 00       	mov    0x804140,%eax
  8026a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026af:	74 07                	je     8026b8 <alloc_block_FF+0x28b>
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	eb 05                	jmp    8026bd <alloc_block_FF+0x290>
  8026b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bd:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c2:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	0f 85 71 fd ff ff    	jne    802440 <alloc_block_FF+0x13>
  8026cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d3:	0f 85 67 fd ff ff    	jne    802440 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8026d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    

008026e0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
  8026e3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8026e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8026ed:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8026f4:	a1 38 41 80 00       	mov    0x804138,%eax
  8026f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026fc:	e9 d3 00 00 00       	jmp    8027d4 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802701:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802704:	8b 40 0c             	mov    0xc(%eax),%eax
  802707:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270a:	0f 85 90 00 00 00    	jne    8027a0 <alloc_block_BF+0xc0>
	   temp = element;
  802710:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802713:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802716:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80271a:	75 17                	jne    802733 <alloc_block_BF+0x53>
  80271c:	83 ec 04             	sub    $0x4,%esp
  80271f:	68 a8 3b 80 00       	push   $0x803ba8
  802724:	68 bd 00 00 00       	push   $0xbd
  802729:	68 37 3b 80 00       	push   $0x803b37
  80272e:	e8 f3 db ff ff       	call   800326 <_panic>
  802733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	74 10                	je     80274c <alloc_block_BF+0x6c>
  80273c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802744:	8b 52 04             	mov    0x4(%edx),%edx
  802747:	89 50 04             	mov    %edx,0x4(%eax)
  80274a:	eb 0b                	jmp    802757 <alloc_block_BF+0x77>
  80274c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274f:	8b 40 04             	mov    0x4(%eax),%eax
  802752:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802757:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275a:	8b 40 04             	mov    0x4(%eax),%eax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	74 0f                	je     802770 <alloc_block_BF+0x90>
  802761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802764:	8b 40 04             	mov    0x4(%eax),%eax
  802767:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80276a:	8b 12                	mov    (%edx),%edx
  80276c:	89 10                	mov    %edx,(%eax)
  80276e:	eb 0a                	jmp    80277a <alloc_block_BF+0x9a>
  802770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802773:	8b 00                	mov    (%eax),%eax
  802775:	a3 38 41 80 00       	mov    %eax,0x804138
  80277a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802786:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278d:	a1 44 41 80 00       	mov    0x804144,%eax
  802792:	48                   	dec    %eax
  802793:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802798:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80279b:	e9 41 01 00 00       	jmp    8028e1 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8027a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a9:	76 21                	jbe    8027cc <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8027ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027b4:	73 16                	jae    8027cc <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8027b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  8027bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  8027c5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8027cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027d8:	74 07                	je     8027e1 <alloc_block_BF+0x101>
  8027da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	eb 05                	jmp    8027e6 <alloc_block_BF+0x106>
  8027e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e6:	a3 40 41 80 00       	mov    %eax,0x804140
  8027eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	0f 85 09 ff ff ff    	jne    802701 <alloc_block_BF+0x21>
  8027f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027fc:	0f 85 ff fe ff ff    	jne    802701 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802802:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802806:	0f 85 d0 00 00 00    	jne    8028dc <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80280c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280f:	8b 40 0c             	mov    0xc(%eax),%eax
  802812:	2b 45 08             	sub    0x8(%ebp),%eax
  802815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802818:	a1 48 41 80 00       	mov    0x804148,%eax
  80281d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802820:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802824:	75 17                	jne    80283d <alloc_block_BF+0x15d>
  802826:	83 ec 04             	sub    $0x4,%esp
  802829:	68 a8 3b 80 00       	push   $0x803ba8
  80282e:	68 d1 00 00 00       	push   $0xd1
  802833:	68 37 3b 80 00       	push   $0x803b37
  802838:	e8 e9 da ff ff       	call   800326 <_panic>
  80283d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	74 10                	je     802856 <alloc_block_BF+0x176>
  802846:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80284e:	8b 52 04             	mov    0x4(%edx),%edx
  802851:	89 50 04             	mov    %edx,0x4(%eax)
  802854:	eb 0b                	jmp    802861 <alloc_block_BF+0x181>
  802856:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802861:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802864:	8b 40 04             	mov    0x4(%eax),%eax
  802867:	85 c0                	test   %eax,%eax
  802869:	74 0f                	je     80287a <alloc_block_BF+0x19a>
  80286b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80286e:	8b 40 04             	mov    0x4(%eax),%eax
  802871:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802874:	8b 12                	mov    (%edx),%edx
  802876:	89 10                	mov    %edx,(%eax)
  802878:	eb 0a                	jmp    802884 <alloc_block_BF+0x1a4>
  80287a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287d:	8b 00                	mov    (%eax),%eax
  80287f:	a3 48 41 80 00       	mov    %eax,0x804148
  802884:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802897:	a1 54 41 80 00       	mov    0x804154,%eax
  80289c:	48                   	dec    %eax
  80289d:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8028a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8028ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ae:	8b 50 08             	mov    0x8(%eax),%edx
  8028b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b4:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8028b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028bd:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  8028c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c3:	8b 50 08             	mov    0x8(%eax),%edx
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	01 c2                	add    %eax,%edx
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  8028d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8028d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028da:	eb 05                	jmp    8028e1 <alloc_block_BF+0x201>
	 }
	 return NULL;
  8028dc:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8028e9:	83 ec 04             	sub    $0x4,%esp
  8028ec:	68 c8 3b 80 00       	push   $0x803bc8
  8028f1:	68 e8 00 00 00       	push   $0xe8
  8028f6:	68 37 3b 80 00       	push   $0x803b37
  8028fb:	e8 26 da ff ff       	call   800326 <_panic>

00802900 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802906:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80290b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80290e:	a1 38 41 80 00       	mov    0x804138,%eax
  802913:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802916:	a1 44 41 80 00       	mov    0x804144,%eax
  80291b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80291e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802922:	75 68                	jne    80298c <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802924:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802928:	75 17                	jne    802941 <insert_sorted_with_merge_freeList+0x41>
  80292a:	83 ec 04             	sub    $0x4,%esp
  80292d:	68 14 3b 80 00       	push   $0x803b14
  802932:	68 36 01 00 00       	push   $0x136
  802937:	68 37 3b 80 00       	push   $0x803b37
  80293c:	e8 e5 d9 ff ff       	call   800326 <_panic>
  802941:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	89 10                	mov    %edx,(%eax)
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	74 0d                	je     802962 <insert_sorted_with_merge_freeList+0x62>
  802955:	a1 38 41 80 00       	mov    0x804138,%eax
  80295a:	8b 55 08             	mov    0x8(%ebp),%edx
  80295d:	89 50 04             	mov    %edx,0x4(%eax)
  802960:	eb 08                	jmp    80296a <insert_sorted_with_merge_freeList+0x6a>
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	a3 38 41 80 00       	mov    %eax,0x804138
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297c:	a1 44 41 80 00       	mov    0x804144,%eax
  802981:	40                   	inc    %eax
  802982:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802987:	e9 ba 06 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80298c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298f:	8b 50 08             	mov    0x8(%eax),%edx
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	8b 40 0c             	mov    0xc(%eax),%eax
  802998:	01 c2                	add    %eax,%edx
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	8b 40 08             	mov    0x8(%eax),%eax
  8029a0:	39 c2                	cmp    %eax,%edx
  8029a2:	73 68                	jae    802a0c <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8029a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a8:	75 17                	jne    8029c1 <insert_sorted_with_merge_freeList+0xc1>
  8029aa:	83 ec 04             	sub    $0x4,%esp
  8029ad:	68 50 3b 80 00       	push   $0x803b50
  8029b2:	68 3a 01 00 00       	push   $0x13a
  8029b7:	68 37 3b 80 00       	push   $0x803b37
  8029bc:	e8 65 d9 ff ff       	call   800326 <_panic>
  8029c1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	89 50 04             	mov    %edx,0x4(%eax)
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 40 04             	mov    0x4(%eax),%eax
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	74 0c                	je     8029e3 <insert_sorted_with_merge_freeList+0xe3>
  8029d7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029df:	89 10                	mov    %edx,(%eax)
  8029e1:	eb 08                	jmp    8029eb <insert_sorted_with_merge_freeList+0xeb>
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	a3 38 41 80 00       	mov    %eax,0x804138
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fc:	a1 44 41 80 00       	mov    0x804144,%eax
  802a01:	40                   	inc    %eax
  802a02:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a07:	e9 3a 06 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0f:	8b 50 08             	mov    0x8(%eax),%edx
  802a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a15:	8b 40 0c             	mov    0xc(%eax),%eax
  802a18:	01 c2                	add    %eax,%edx
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	8b 40 08             	mov    0x8(%eax),%eax
  802a20:	39 c2                	cmp    %eax,%edx
  802a22:	0f 85 90 00 00 00    	jne    802ab8 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2b:	8b 50 0c             	mov    0xc(%eax),%edx
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	8b 40 0c             	mov    0xc(%eax),%eax
  802a34:	01 c2                	add    %eax,%edx
  802a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a39:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802a50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a54:	75 17                	jne    802a6d <insert_sorted_with_merge_freeList+0x16d>
  802a56:	83 ec 04             	sub    $0x4,%esp
  802a59:	68 14 3b 80 00       	push   $0x803b14
  802a5e:	68 41 01 00 00       	push   $0x141
  802a63:	68 37 3b 80 00       	push   $0x803b37
  802a68:	e8 b9 d8 ff ff       	call   800326 <_panic>
  802a6d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	89 10                	mov    %edx,(%eax)
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 0d                	je     802a8e <insert_sorted_with_merge_freeList+0x18e>
  802a81:	a1 48 41 80 00       	mov    0x804148,%eax
  802a86:	8b 55 08             	mov    0x8(%ebp),%edx
  802a89:	89 50 04             	mov    %edx,0x4(%eax)
  802a8c:	eb 08                	jmp    802a96 <insert_sorted_with_merge_freeList+0x196>
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	a3 48 41 80 00       	mov    %eax,0x804148
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa8:	a1 54 41 80 00       	mov    0x804154,%eax
  802aad:	40                   	inc    %eax
  802aae:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802ab3:	e9 8e 05 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	8b 50 08             	mov    0x8(%eax),%edx
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac4:	01 c2                	add    %eax,%edx
  802ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac9:	8b 40 08             	mov    0x8(%eax),%eax
  802acc:	39 c2                	cmp    %eax,%edx
  802ace:	73 68                	jae    802b38 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ad0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad4:	75 17                	jne    802aed <insert_sorted_with_merge_freeList+0x1ed>
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	68 14 3b 80 00       	push   $0x803b14
  802ade:	68 45 01 00 00       	push   $0x145
  802ae3:	68 37 3b 80 00       	push   $0x803b37
  802ae8:	e8 39 d8 ff ff       	call   800326 <_panic>
  802aed:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	89 10                	mov    %edx,(%eax)
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	85 c0                	test   %eax,%eax
  802aff:	74 0d                	je     802b0e <insert_sorted_with_merge_freeList+0x20e>
  802b01:	a1 38 41 80 00       	mov    0x804138,%eax
  802b06:	8b 55 08             	mov    0x8(%ebp),%edx
  802b09:	89 50 04             	mov    %edx,0x4(%eax)
  802b0c:	eb 08                	jmp    802b16 <insert_sorted_with_merge_freeList+0x216>
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	a3 38 41 80 00       	mov    %eax,0x804138
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b28:	a1 44 41 80 00       	mov    0x804144,%eax
  802b2d:	40                   	inc    %eax
  802b2e:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b33:	e9 0e 05 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	8b 50 08             	mov    0x8(%eax),%edx
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	8b 40 0c             	mov    0xc(%eax),%eax
  802b44:	01 c2                	add    %eax,%edx
  802b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b49:	8b 40 08             	mov    0x8(%eax),%eax
  802b4c:	39 c2                	cmp    %eax,%edx
  802b4e:	0f 85 9c 00 00 00    	jne    802bf0 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b57:	8b 50 0c             	mov    0xc(%eax),%edx
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b60:	01 c2                	add    %eax,%edx
  802b62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b65:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	8b 50 08             	mov    0x8(%eax),%edx
  802b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b71:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8c:	75 17                	jne    802ba5 <insert_sorted_with_merge_freeList+0x2a5>
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	68 14 3b 80 00       	push   $0x803b14
  802b96:	68 4d 01 00 00       	push   $0x14d
  802b9b:	68 37 3b 80 00       	push   $0x803b37
  802ba0:	e8 81 d7 ff ff       	call   800326 <_panic>
  802ba5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	89 10                	mov    %edx,(%eax)
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	74 0d                	je     802bc6 <insert_sorted_with_merge_freeList+0x2c6>
  802bb9:	a1 48 41 80 00       	mov    0x804148,%eax
  802bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc1:	89 50 04             	mov    %edx,0x4(%eax)
  802bc4:	eb 08                	jmp    802bce <insert_sorted_with_merge_freeList+0x2ce>
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	a3 48 41 80 00       	mov    %eax,0x804148
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be0:	a1 54 41 80 00       	mov    0x804154,%eax
  802be5:	40                   	inc    %eax
  802be6:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802beb:	e9 56 04 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802bf0:	a1 38 41 80 00       	mov    0x804138,%eax
  802bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf8:	e9 19 04 00 00       	jmp    803016 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 50 08             	mov    0x8(%eax),%edx
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c11:	01 c2                	add    %eax,%edx
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	8b 40 08             	mov    0x8(%eax),%eax
  802c19:	39 c2                	cmp    %eax,%edx
  802c1b:	0f 85 ad 01 00 00    	jne    802dce <insert_sorted_with_merge_freeList+0x4ce>
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	8b 50 08             	mov    0x8(%eax),%edx
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2d:	01 c2                	add    %eax,%edx
  802c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c32:	8b 40 08             	mov    0x8(%eax),%eax
  802c35:	39 c2                	cmp    %eax,%edx
  802c37:	0f 85 91 01 00 00    	jne    802dce <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 50 0c             	mov    0xc(%eax),%edx
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4f:	01 c8                	add    %ecx,%eax
  802c51:	01 c2                	add    %eax,%edx
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802c77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802c81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c85:	75 17                	jne    802c9e <insert_sorted_with_merge_freeList+0x39e>
  802c87:	83 ec 04             	sub    $0x4,%esp
  802c8a:	68 a8 3b 80 00       	push   $0x803ba8
  802c8f:	68 5b 01 00 00       	push   $0x15b
  802c94:	68 37 3b 80 00       	push   $0x803b37
  802c99:	e8 88 d6 ff ff       	call   800326 <_panic>
  802c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca1:	8b 00                	mov    (%eax),%eax
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	74 10                	je     802cb7 <insert_sorted_with_merge_freeList+0x3b7>
  802ca7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802caf:	8b 52 04             	mov    0x4(%edx),%edx
  802cb2:	89 50 04             	mov    %edx,0x4(%eax)
  802cb5:	eb 0b                	jmp    802cc2 <insert_sorted_with_merge_freeList+0x3c2>
  802cb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cba:	8b 40 04             	mov    0x4(%eax),%eax
  802cbd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc5:	8b 40 04             	mov    0x4(%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 0f                	je     802cdb <insert_sorted_with_merge_freeList+0x3db>
  802ccc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cd5:	8b 12                	mov    (%edx),%edx
  802cd7:	89 10                	mov    %edx,(%eax)
  802cd9:	eb 0a                	jmp    802ce5 <insert_sorted_with_merge_freeList+0x3e5>
  802cdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ce5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf8:	a1 44 41 80 00       	mov    0x804144,%eax
  802cfd:	48                   	dec    %eax
  802cfe:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d07:	75 17                	jne    802d20 <insert_sorted_with_merge_freeList+0x420>
  802d09:	83 ec 04             	sub    $0x4,%esp
  802d0c:	68 14 3b 80 00       	push   $0x803b14
  802d11:	68 5c 01 00 00       	push   $0x15c
  802d16:	68 37 3b 80 00       	push   $0x803b37
  802d1b:	e8 06 d6 ff ff       	call   800326 <_panic>
  802d20:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	89 10                	mov    %edx,(%eax)
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	8b 00                	mov    (%eax),%eax
  802d30:	85 c0                	test   %eax,%eax
  802d32:	74 0d                	je     802d41 <insert_sorted_with_merge_freeList+0x441>
  802d34:	a1 48 41 80 00       	mov    0x804148,%eax
  802d39:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3c:	89 50 04             	mov    %edx,0x4(%eax)
  802d3f:	eb 08                	jmp    802d49 <insert_sorted_with_merge_freeList+0x449>
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5b:	a1 54 41 80 00       	mov    0x804154,%eax
  802d60:	40                   	inc    %eax
  802d61:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802d66:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d6a:	75 17                	jne    802d83 <insert_sorted_with_merge_freeList+0x483>
  802d6c:	83 ec 04             	sub    $0x4,%esp
  802d6f:	68 14 3b 80 00       	push   $0x803b14
  802d74:	68 5d 01 00 00       	push   $0x15d
  802d79:	68 37 3b 80 00       	push   $0x803b37
  802d7e:	e8 a3 d5 ff ff       	call   800326 <_panic>
  802d83:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d8c:	89 10                	mov    %edx,(%eax)
  802d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d91:	8b 00                	mov    (%eax),%eax
  802d93:	85 c0                	test   %eax,%eax
  802d95:	74 0d                	je     802da4 <insert_sorted_with_merge_freeList+0x4a4>
  802d97:	a1 48 41 80 00       	mov    0x804148,%eax
  802d9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d9f:	89 50 04             	mov    %edx,0x4(%eax)
  802da2:	eb 08                	jmp    802dac <insert_sorted_with_merge_freeList+0x4ac>
  802da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802daf:	a3 48 41 80 00       	mov    %eax,0x804148
  802db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbe:	a1 54 41 80 00       	mov    0x804154,%eax
  802dc3:	40                   	inc    %eax
  802dc4:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802dc9:	e9 78 02 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 50 08             	mov    0x8(%eax),%edx
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dda:	01 c2                	add    %eax,%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 40 08             	mov    0x8(%eax),%eax
  802de2:	39 c2                	cmp    %eax,%edx
  802de4:	0f 83 b8 00 00 00    	jae    802ea2 <insert_sorted_with_merge_freeList+0x5a2>
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	8b 50 08             	mov    0x8(%eax),%edx
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	8b 40 0c             	mov    0xc(%eax),%eax
  802df6:	01 c2                	add    %eax,%edx
  802df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfb:	8b 40 08             	mov    0x8(%eax),%eax
  802dfe:	39 c2                	cmp    %eax,%edx
  802e00:	0f 85 9c 00 00 00    	jne    802ea2 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e09:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	01 c2                	add    %eax,%edx
  802e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e17:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 50 08             	mov    0x8(%eax),%edx
  802e20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e23:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3e:	75 17                	jne    802e57 <insert_sorted_with_merge_freeList+0x557>
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	68 14 3b 80 00       	push   $0x803b14
  802e48:	68 67 01 00 00       	push   $0x167
  802e4d:	68 37 3b 80 00       	push   $0x803b37
  802e52:	e8 cf d4 ff ff       	call   800326 <_panic>
  802e57:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	89 10                	mov    %edx,(%eax)
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 0d                	je     802e78 <insert_sorted_with_merge_freeList+0x578>
  802e6b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e70:	8b 55 08             	mov    0x8(%ebp),%edx
  802e73:	89 50 04             	mov    %edx,0x4(%eax)
  802e76:	eb 08                	jmp    802e80 <insert_sorted_with_merge_freeList+0x580>
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	a3 48 41 80 00       	mov    %eax,0x804148
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e92:	a1 54 41 80 00       	mov    0x804154,%eax
  802e97:	40                   	inc    %eax
  802e98:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e9d:	e9 a4 01 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 50 08             	mov    0x8(%eax),%edx
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 40 0c             	mov    0xc(%eax),%eax
  802eae:	01 c2                	add    %eax,%edx
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 40 08             	mov    0x8(%eax),%eax
  802eb6:	39 c2                	cmp    %eax,%edx
  802eb8:	0f 85 ac 00 00 00    	jne    802f6a <insert_sorted_with_merge_freeList+0x66a>
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	8b 50 08             	mov    0x8(%eax),%edx
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eca:	01 c2                	add    %eax,%edx
  802ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecf:	8b 40 08             	mov    0x8(%eax),%eax
  802ed2:	39 c2                	cmp    %eax,%edx
  802ed4:	0f 83 90 00 00 00    	jae    802f6a <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee6:	01 c2                	add    %eax,%edx
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f06:	75 17                	jne    802f1f <insert_sorted_with_merge_freeList+0x61f>
  802f08:	83 ec 04             	sub    $0x4,%esp
  802f0b:	68 14 3b 80 00       	push   $0x803b14
  802f10:	68 70 01 00 00       	push   $0x170
  802f15:	68 37 3b 80 00       	push   $0x803b37
  802f1a:	e8 07 d4 ff ff       	call   800326 <_panic>
  802f1f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	89 10                	mov    %edx,(%eax)
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 0d                	je     802f40 <insert_sorted_with_merge_freeList+0x640>
  802f33:	a1 48 41 80 00       	mov    0x804148,%eax
  802f38:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3b:	89 50 04             	mov    %edx,0x4(%eax)
  802f3e:	eb 08                	jmp    802f48 <insert_sorted_with_merge_freeList+0x648>
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	a3 48 41 80 00       	mov    %eax,0x804148
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5a:	a1 54 41 80 00       	mov    0x804154,%eax
  802f5f:	40                   	inc    %eax
  802f60:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802f65:	e9 dc 00 00 00       	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 50 08             	mov    0x8(%eax),%edx
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 40 0c             	mov    0xc(%eax),%eax
  802f76:	01 c2                	add    %eax,%edx
  802f78:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7b:	8b 40 08             	mov    0x8(%eax),%eax
  802f7e:	39 c2                	cmp    %eax,%edx
  802f80:	0f 83 88 00 00 00    	jae    80300e <insert_sorted_with_merge_freeList+0x70e>
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	8b 50 08             	mov    0x8(%eax),%edx
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f92:	01 c2                	add    %eax,%edx
  802f94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f97:	8b 40 08             	mov    0x8(%eax),%eax
  802f9a:	39 c2                	cmp    %eax,%edx
  802f9c:	73 70                	jae    80300e <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802f9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa2:	74 06                	je     802faa <insert_sorted_with_merge_freeList+0x6aa>
  802fa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa8:	75 17                	jne    802fc1 <insert_sorted_with_merge_freeList+0x6c1>
  802faa:	83 ec 04             	sub    $0x4,%esp
  802fad:	68 74 3b 80 00       	push   $0x803b74
  802fb2:	68 75 01 00 00       	push   $0x175
  802fb7:	68 37 3b 80 00       	push   $0x803b37
  802fbc:	e8 65 d3 ff ff       	call   800326 <_panic>
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 10                	mov    (%eax),%edx
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	89 10                	mov    %edx,(%eax)
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 0b                	je     802fdf <insert_sorted_with_merge_freeList+0x6df>
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 00                	mov    (%eax),%eax
  802fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fdc:	89 50 04             	mov    %edx,0x4(%eax)
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe5:	89 10                	mov    %edx,(%eax)
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fed:	89 50 04             	mov    %edx,0x4(%eax)
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	75 08                	jne    803001 <insert_sorted_with_merge_freeList+0x701>
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803001:	a1 44 41 80 00       	mov    0x804144,%eax
  803006:	40                   	inc    %eax
  803007:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  80300c:	eb 38                	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80300e:	a1 40 41 80 00       	mov    0x804140,%eax
  803013:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803016:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301a:	74 07                	je     803023 <insert_sorted_with_merge_freeList+0x723>
  80301c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	eb 05                	jmp    803028 <insert_sorted_with_merge_freeList+0x728>
  803023:	b8 00 00 00 00       	mov    $0x0,%eax
  803028:	a3 40 41 80 00       	mov    %eax,0x804140
  80302d:	a1 40 41 80 00       	mov    0x804140,%eax
  803032:	85 c0                	test   %eax,%eax
  803034:	0f 85 c3 fb ff ff    	jne    802bfd <insert_sorted_with_merge_freeList+0x2fd>
  80303a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303e:	0f 85 b9 fb ff ff    	jne    802bfd <insert_sorted_with_merge_freeList+0x2fd>





}
  803044:	eb 00                	jmp    803046 <insert_sorted_with_merge_freeList+0x746>
  803046:	90                   	nop
  803047:	c9                   	leave  
  803048:	c3                   	ret    

00803049 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803049:	55                   	push   %ebp
  80304a:	89 e5                	mov    %esp,%ebp
  80304c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80304f:	8b 55 08             	mov    0x8(%ebp),%edx
  803052:	89 d0                	mov    %edx,%eax
  803054:	c1 e0 02             	shl    $0x2,%eax
  803057:	01 d0                	add    %edx,%eax
  803059:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803060:	01 d0                	add    %edx,%eax
  803062:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803069:	01 d0                	add    %edx,%eax
  80306b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803072:	01 d0                	add    %edx,%eax
  803074:	c1 e0 04             	shl    $0x4,%eax
  803077:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80307a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803081:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803084:	83 ec 0c             	sub    $0xc,%esp
  803087:	50                   	push   %eax
  803088:	e8 31 ec ff ff       	call   801cbe <sys_get_virtual_time>
  80308d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803090:	eb 41                	jmp    8030d3 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803092:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803095:	83 ec 0c             	sub    $0xc,%esp
  803098:	50                   	push   %eax
  803099:	e8 20 ec ff ff       	call   801cbe <sys_get_virtual_time>
  80309e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a7:	29 c2                	sub    %eax,%edx
  8030a9:	89 d0                	mov    %edx,%eax
  8030ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030ae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b4:	89 d1                	mov    %edx,%ecx
  8030b6:	29 c1                	sub    %eax,%ecx
  8030b8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030be:	39 c2                	cmp    %eax,%edx
  8030c0:	0f 97 c0             	seta   %al
  8030c3:	0f b6 c0             	movzbl %al,%eax
  8030c6:	29 c1                	sub    %eax,%ecx
  8030c8:	89 c8                	mov    %ecx,%eax
  8030ca:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030d9:	72 b7                	jb     803092 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030db:	90                   	nop
  8030dc:	c9                   	leave  
  8030dd:	c3                   	ret    

008030de <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030de:	55                   	push   %ebp
  8030df:	89 e5                	mov    %esp,%ebp
  8030e1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030eb:	eb 03                	jmp    8030f0 <busy_wait+0x12>
  8030ed:	ff 45 fc             	incl   -0x4(%ebp)
  8030f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f6:	72 f5                	jb     8030ed <busy_wait+0xf>
	return i;
  8030f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030fb:	c9                   	leave  
  8030fc:	c3                   	ret    
  8030fd:	66 90                	xchg   %ax,%ax
  8030ff:	90                   	nop

00803100 <__udivdi3>:
  803100:	55                   	push   %ebp
  803101:	57                   	push   %edi
  803102:	56                   	push   %esi
  803103:	53                   	push   %ebx
  803104:	83 ec 1c             	sub    $0x1c,%esp
  803107:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80310b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80310f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803113:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803117:	89 ca                	mov    %ecx,%edx
  803119:	89 f8                	mov    %edi,%eax
  80311b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80311f:	85 f6                	test   %esi,%esi
  803121:	75 2d                	jne    803150 <__udivdi3+0x50>
  803123:	39 cf                	cmp    %ecx,%edi
  803125:	77 65                	ja     80318c <__udivdi3+0x8c>
  803127:	89 fd                	mov    %edi,%ebp
  803129:	85 ff                	test   %edi,%edi
  80312b:	75 0b                	jne    803138 <__udivdi3+0x38>
  80312d:	b8 01 00 00 00       	mov    $0x1,%eax
  803132:	31 d2                	xor    %edx,%edx
  803134:	f7 f7                	div    %edi
  803136:	89 c5                	mov    %eax,%ebp
  803138:	31 d2                	xor    %edx,%edx
  80313a:	89 c8                	mov    %ecx,%eax
  80313c:	f7 f5                	div    %ebp
  80313e:	89 c1                	mov    %eax,%ecx
  803140:	89 d8                	mov    %ebx,%eax
  803142:	f7 f5                	div    %ebp
  803144:	89 cf                	mov    %ecx,%edi
  803146:	89 fa                	mov    %edi,%edx
  803148:	83 c4 1c             	add    $0x1c,%esp
  80314b:	5b                   	pop    %ebx
  80314c:	5e                   	pop    %esi
  80314d:	5f                   	pop    %edi
  80314e:	5d                   	pop    %ebp
  80314f:	c3                   	ret    
  803150:	39 ce                	cmp    %ecx,%esi
  803152:	77 28                	ja     80317c <__udivdi3+0x7c>
  803154:	0f bd fe             	bsr    %esi,%edi
  803157:	83 f7 1f             	xor    $0x1f,%edi
  80315a:	75 40                	jne    80319c <__udivdi3+0x9c>
  80315c:	39 ce                	cmp    %ecx,%esi
  80315e:	72 0a                	jb     80316a <__udivdi3+0x6a>
  803160:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803164:	0f 87 9e 00 00 00    	ja     803208 <__udivdi3+0x108>
  80316a:	b8 01 00 00 00       	mov    $0x1,%eax
  80316f:	89 fa                	mov    %edi,%edx
  803171:	83 c4 1c             	add    $0x1c,%esp
  803174:	5b                   	pop    %ebx
  803175:	5e                   	pop    %esi
  803176:	5f                   	pop    %edi
  803177:	5d                   	pop    %ebp
  803178:	c3                   	ret    
  803179:	8d 76 00             	lea    0x0(%esi),%esi
  80317c:	31 ff                	xor    %edi,%edi
  80317e:	31 c0                	xor    %eax,%eax
  803180:	89 fa                	mov    %edi,%edx
  803182:	83 c4 1c             	add    $0x1c,%esp
  803185:	5b                   	pop    %ebx
  803186:	5e                   	pop    %esi
  803187:	5f                   	pop    %edi
  803188:	5d                   	pop    %ebp
  803189:	c3                   	ret    
  80318a:	66 90                	xchg   %ax,%ax
  80318c:	89 d8                	mov    %ebx,%eax
  80318e:	f7 f7                	div    %edi
  803190:	31 ff                	xor    %edi,%edi
  803192:	89 fa                	mov    %edi,%edx
  803194:	83 c4 1c             	add    $0x1c,%esp
  803197:	5b                   	pop    %ebx
  803198:	5e                   	pop    %esi
  803199:	5f                   	pop    %edi
  80319a:	5d                   	pop    %ebp
  80319b:	c3                   	ret    
  80319c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031a1:	89 eb                	mov    %ebp,%ebx
  8031a3:	29 fb                	sub    %edi,%ebx
  8031a5:	89 f9                	mov    %edi,%ecx
  8031a7:	d3 e6                	shl    %cl,%esi
  8031a9:	89 c5                	mov    %eax,%ebp
  8031ab:	88 d9                	mov    %bl,%cl
  8031ad:	d3 ed                	shr    %cl,%ebp
  8031af:	89 e9                	mov    %ebp,%ecx
  8031b1:	09 f1                	or     %esi,%ecx
  8031b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031b7:	89 f9                	mov    %edi,%ecx
  8031b9:	d3 e0                	shl    %cl,%eax
  8031bb:	89 c5                	mov    %eax,%ebp
  8031bd:	89 d6                	mov    %edx,%esi
  8031bf:	88 d9                	mov    %bl,%cl
  8031c1:	d3 ee                	shr    %cl,%esi
  8031c3:	89 f9                	mov    %edi,%ecx
  8031c5:	d3 e2                	shl    %cl,%edx
  8031c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031cb:	88 d9                	mov    %bl,%cl
  8031cd:	d3 e8                	shr    %cl,%eax
  8031cf:	09 c2                	or     %eax,%edx
  8031d1:	89 d0                	mov    %edx,%eax
  8031d3:	89 f2                	mov    %esi,%edx
  8031d5:	f7 74 24 0c          	divl   0xc(%esp)
  8031d9:	89 d6                	mov    %edx,%esi
  8031db:	89 c3                	mov    %eax,%ebx
  8031dd:	f7 e5                	mul    %ebp
  8031df:	39 d6                	cmp    %edx,%esi
  8031e1:	72 19                	jb     8031fc <__udivdi3+0xfc>
  8031e3:	74 0b                	je     8031f0 <__udivdi3+0xf0>
  8031e5:	89 d8                	mov    %ebx,%eax
  8031e7:	31 ff                	xor    %edi,%edi
  8031e9:	e9 58 ff ff ff       	jmp    803146 <__udivdi3+0x46>
  8031ee:	66 90                	xchg   %ax,%ax
  8031f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031f4:	89 f9                	mov    %edi,%ecx
  8031f6:	d3 e2                	shl    %cl,%edx
  8031f8:	39 c2                	cmp    %eax,%edx
  8031fa:	73 e9                	jae    8031e5 <__udivdi3+0xe5>
  8031fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031ff:	31 ff                	xor    %edi,%edi
  803201:	e9 40 ff ff ff       	jmp    803146 <__udivdi3+0x46>
  803206:	66 90                	xchg   %ax,%ax
  803208:	31 c0                	xor    %eax,%eax
  80320a:	e9 37 ff ff ff       	jmp    803146 <__udivdi3+0x46>
  80320f:	90                   	nop

00803210 <__umoddi3>:
  803210:	55                   	push   %ebp
  803211:	57                   	push   %edi
  803212:	56                   	push   %esi
  803213:	53                   	push   %ebx
  803214:	83 ec 1c             	sub    $0x1c,%esp
  803217:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80321b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80321f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803223:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803227:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80322b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80322f:	89 f3                	mov    %esi,%ebx
  803231:	89 fa                	mov    %edi,%edx
  803233:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803237:	89 34 24             	mov    %esi,(%esp)
  80323a:	85 c0                	test   %eax,%eax
  80323c:	75 1a                	jne    803258 <__umoddi3+0x48>
  80323e:	39 f7                	cmp    %esi,%edi
  803240:	0f 86 a2 00 00 00    	jbe    8032e8 <__umoddi3+0xd8>
  803246:	89 c8                	mov    %ecx,%eax
  803248:	89 f2                	mov    %esi,%edx
  80324a:	f7 f7                	div    %edi
  80324c:	89 d0                	mov    %edx,%eax
  80324e:	31 d2                	xor    %edx,%edx
  803250:	83 c4 1c             	add    $0x1c,%esp
  803253:	5b                   	pop    %ebx
  803254:	5e                   	pop    %esi
  803255:	5f                   	pop    %edi
  803256:	5d                   	pop    %ebp
  803257:	c3                   	ret    
  803258:	39 f0                	cmp    %esi,%eax
  80325a:	0f 87 ac 00 00 00    	ja     80330c <__umoddi3+0xfc>
  803260:	0f bd e8             	bsr    %eax,%ebp
  803263:	83 f5 1f             	xor    $0x1f,%ebp
  803266:	0f 84 ac 00 00 00    	je     803318 <__umoddi3+0x108>
  80326c:	bf 20 00 00 00       	mov    $0x20,%edi
  803271:	29 ef                	sub    %ebp,%edi
  803273:	89 fe                	mov    %edi,%esi
  803275:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803279:	89 e9                	mov    %ebp,%ecx
  80327b:	d3 e0                	shl    %cl,%eax
  80327d:	89 d7                	mov    %edx,%edi
  80327f:	89 f1                	mov    %esi,%ecx
  803281:	d3 ef                	shr    %cl,%edi
  803283:	09 c7                	or     %eax,%edi
  803285:	89 e9                	mov    %ebp,%ecx
  803287:	d3 e2                	shl    %cl,%edx
  803289:	89 14 24             	mov    %edx,(%esp)
  80328c:	89 d8                	mov    %ebx,%eax
  80328e:	d3 e0                	shl    %cl,%eax
  803290:	89 c2                	mov    %eax,%edx
  803292:	8b 44 24 08          	mov    0x8(%esp),%eax
  803296:	d3 e0                	shl    %cl,%eax
  803298:	89 44 24 04          	mov    %eax,0x4(%esp)
  80329c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032a0:	89 f1                	mov    %esi,%ecx
  8032a2:	d3 e8                	shr    %cl,%eax
  8032a4:	09 d0                	or     %edx,%eax
  8032a6:	d3 eb                	shr    %cl,%ebx
  8032a8:	89 da                	mov    %ebx,%edx
  8032aa:	f7 f7                	div    %edi
  8032ac:	89 d3                	mov    %edx,%ebx
  8032ae:	f7 24 24             	mull   (%esp)
  8032b1:	89 c6                	mov    %eax,%esi
  8032b3:	89 d1                	mov    %edx,%ecx
  8032b5:	39 d3                	cmp    %edx,%ebx
  8032b7:	0f 82 87 00 00 00    	jb     803344 <__umoddi3+0x134>
  8032bd:	0f 84 91 00 00 00    	je     803354 <__umoddi3+0x144>
  8032c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032c7:	29 f2                	sub    %esi,%edx
  8032c9:	19 cb                	sbb    %ecx,%ebx
  8032cb:	89 d8                	mov    %ebx,%eax
  8032cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032d1:	d3 e0                	shl    %cl,%eax
  8032d3:	89 e9                	mov    %ebp,%ecx
  8032d5:	d3 ea                	shr    %cl,%edx
  8032d7:	09 d0                	or     %edx,%eax
  8032d9:	89 e9                	mov    %ebp,%ecx
  8032db:	d3 eb                	shr    %cl,%ebx
  8032dd:	89 da                	mov    %ebx,%edx
  8032df:	83 c4 1c             	add    $0x1c,%esp
  8032e2:	5b                   	pop    %ebx
  8032e3:	5e                   	pop    %esi
  8032e4:	5f                   	pop    %edi
  8032e5:	5d                   	pop    %ebp
  8032e6:	c3                   	ret    
  8032e7:	90                   	nop
  8032e8:	89 fd                	mov    %edi,%ebp
  8032ea:	85 ff                	test   %edi,%edi
  8032ec:	75 0b                	jne    8032f9 <__umoddi3+0xe9>
  8032ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8032f3:	31 d2                	xor    %edx,%edx
  8032f5:	f7 f7                	div    %edi
  8032f7:	89 c5                	mov    %eax,%ebp
  8032f9:	89 f0                	mov    %esi,%eax
  8032fb:	31 d2                	xor    %edx,%edx
  8032fd:	f7 f5                	div    %ebp
  8032ff:	89 c8                	mov    %ecx,%eax
  803301:	f7 f5                	div    %ebp
  803303:	89 d0                	mov    %edx,%eax
  803305:	e9 44 ff ff ff       	jmp    80324e <__umoddi3+0x3e>
  80330a:	66 90                	xchg   %ax,%ax
  80330c:	89 c8                	mov    %ecx,%eax
  80330e:	89 f2                	mov    %esi,%edx
  803310:	83 c4 1c             	add    $0x1c,%esp
  803313:	5b                   	pop    %ebx
  803314:	5e                   	pop    %esi
  803315:	5f                   	pop    %edi
  803316:	5d                   	pop    %ebp
  803317:	c3                   	ret    
  803318:	3b 04 24             	cmp    (%esp),%eax
  80331b:	72 06                	jb     803323 <__umoddi3+0x113>
  80331d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803321:	77 0f                	ja     803332 <__umoddi3+0x122>
  803323:	89 f2                	mov    %esi,%edx
  803325:	29 f9                	sub    %edi,%ecx
  803327:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80332b:	89 14 24             	mov    %edx,(%esp)
  80332e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803332:	8b 44 24 04          	mov    0x4(%esp),%eax
  803336:	8b 14 24             	mov    (%esp),%edx
  803339:	83 c4 1c             	add    $0x1c,%esp
  80333c:	5b                   	pop    %ebx
  80333d:	5e                   	pop    %esi
  80333e:	5f                   	pop    %edi
  80333f:	5d                   	pop    %ebp
  803340:	c3                   	ret    
  803341:	8d 76 00             	lea    0x0(%esi),%esi
  803344:	2b 04 24             	sub    (%esp),%eax
  803347:	19 fa                	sbb    %edi,%edx
  803349:	89 d1                	mov    %edx,%ecx
  80334b:	89 c6                	mov    %eax,%esi
  80334d:	e9 71 ff ff ff       	jmp    8032c3 <__umoddi3+0xb3>
  803352:	66 90                	xchg   %ax,%ax
  803354:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803358:	72 ea                	jb     803344 <__umoddi3+0x134>
  80335a:	89 d9                	mov    %ebx,%ecx
  80335c:	e9 62 ff ff ff       	jmp    8032c3 <__umoddi3+0xb3>
