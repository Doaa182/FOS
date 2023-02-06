
obj/user/tst_semaphore_2master:     file format elf32-i386


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
  800031:	e8 8e 01 00 00       	call   8001c4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: take user input, create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	int envID = sys_getenvid();
  800041:	e8 b1 18 00 00       	call   8018f7 <sys_getenvid>
  800046:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	68 c0 1e 80 00       	push   $0x801ec0
  800058:	e8 d9 0b 00 00       	call   800c36 <readline>
  80005d:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	6a 0a                	push   $0xa
  800065:	6a 00                	push   $0x0
  800067:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80006d:	50                   	push   %eax
  80006e:	e8 29 11 00 00       	call   80119c <strtol>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	readline("Enter shop capacity: ", line) ;
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800082:	50                   	push   %eax
  800083:	68 e2 1e 80 00       	push   $0x801ee2
  800088:	e8 a9 0b 00 00       	call   800c36 <readline>
  80008d:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800090:	83 ec 04             	sub    $0x4,%esp
  800093:	6a 0a                	push   $0xa
  800095:	6a 00                	push   $0x0
  800097:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80009d:	50                   	push   %eax
  80009e:	e8 f9 10 00 00       	call   80119c <strtol>
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_createSemaphore("shopCapacity", shopCapacity);
  8000a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	50                   	push   %eax
  8000b0:	68 f8 1e 80 00       	push   $0x801ef8
  8000b5:	e8 d7 16 00 00       	call   801791 <sys_createSemaphore>
  8000ba:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore("depend", 0);
  8000bd:	83 ec 08             	sub    $0x8,%esp
  8000c0:	6a 00                	push   $0x0
  8000c2:	68 05 1f 80 00       	push   $0x801f05
  8000c7:	e8 c5 16 00 00       	call   801791 <sys_createSemaphore>
  8000cc:	83 c4 10             	add    $0x10,%esp

	int i = 0 ;
  8000cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  8000d6:	eb 5e                	jmp    800136 <_main+0xfe>
	{
		id = sys_create_env("sem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8000dd:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000ee:	89 c1                	mov    %eax,%ecx
  8000f0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f5:	8b 40 74             	mov    0x74(%eax),%eax
  8000f8:	52                   	push   %edx
  8000f9:	51                   	push   %ecx
  8000fa:	50                   	push   %eax
  8000fb:	68 0c 1f 80 00       	push   $0x801f0c
  800100:	e8 9d 17 00 00       	call   8018a2 <sys_create_env>
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (id == E_ENV_CREATION_ERROR)
  80010b:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  80010f:	75 14                	jne    800125 <_main+0xed>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
  800111:	83 ec 04             	sub    $0x4,%esp
  800114:	68 18 1f 80 00       	push   $0x801f18
  800119:	6a 18                	push   $0x18
  80011b:	68 64 1f 80 00       	push   $0x801f64
  800120:	e8 db 01 00 00       	call   800300 <_panic>
		sys_run_env(id) ;
  800125:	83 ec 0c             	sub    $0xc,%esp
  800128:	ff 75 e4             	pushl  -0x1c(%ebp)
  80012b:	e8 90 17 00 00       	call   8018c0 <sys_run_env>
  800130:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore("shopCapacity", shopCapacity);
	sys_createSemaphore("depend", 0);

	int i = 0 ;
	int id ;
	for (; i<totalNumOfCusts; i++)
  800133:	ff 45 f4             	incl   -0xc(%ebp)
  800136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800139:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80013c:	7c 9a                	jl     8000d8 <_main+0xa0>
		if (id == E_ENV_CREATION_ERROR)
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	for (i = 0 ; i<totalNumOfCusts; i++)
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	eb 16                	jmp    80015d <_main+0x125>
	{
		sys_waitSemaphore(envID, "depend") ;
  800147:	83 ec 08             	sub    $0x8,%esp
  80014a:	68 05 1f 80 00       	push   $0x801f05
  80014f:	ff 75 f0             	pushl  -0x10(%ebp)
  800152:	e8 73 16 00 00       	call   8017ca <sys_waitSemaphore>
  800157:	83 c4 10             	add    $0x10,%esp
		if (id == E_ENV_CREATION_ERROR)
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	for (i = 0 ; i<totalNumOfCusts; i++)
  80015a:	ff 45 f4             	incl   -0xc(%ebp)
  80015d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800160:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800163:	7c e2                	jl     800147 <_main+0x10f>
	{
		sys_waitSemaphore(envID, "depend") ;
	}
	int sem1val = sys_getSemaphoreValue(envID, "shopCapacity");
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	68 f8 1e 80 00       	push   $0x801ef8
  80016d:	ff 75 f0             	pushl  -0x10(%ebp)
  800170:	e8 38 16 00 00       	call   8017ad <sys_getSemaphoreValue>
  800175:	83 c4 10             	add    $0x10,%esp
  800178:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend");
  80017b:	83 ec 08             	sub    $0x8,%esp
  80017e:	68 05 1f 80 00       	push   $0x801f05
  800183:	ff 75 f0             	pushl  -0x10(%ebp)
  800186:	e8 22 16 00 00       	call   8017ad <sys_getSemaphoreValue>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (sem2val == 0 && sem1val == shopCapacity)
  800191:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800195:	75 1a                	jne    8001b1 <_main+0x179>
  800197:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80019d:	75 12                	jne    8001b1 <_main+0x179>
		cprintf("Congratulations!! Test of Semaphores [2] completed successfully!!\n\n\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 84 1f 80 00       	push   $0x801f84
  8001a7:	e8 08 04 00 00       	call   8005b4 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
  8001af:	eb 10                	jmp    8001c1 <_main+0x189>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 cc 1f 80 00       	push   $0x801fcc
  8001b9:	e8 f6 03 00 00       	call   8005b4 <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp

	return;
  8001c1:	90                   	nop
}
  8001c2:	c9                   	leave  
  8001c3:	c3                   	ret    

008001c4 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ca:	e8 41 17 00 00       	call   801910 <sys_getenvindex>
  8001cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001d5:	89 d0                	mov    %edx,%eax
  8001d7:	c1 e0 03             	shl    $0x3,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	01 c0                	add    %eax,%eax
  8001de:	01 d0                	add    %edx,%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	c1 e0 04             	shl    $0x4,%eax
  8001ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f1:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001f6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fb:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800201:	84 c0                	test   %al,%al
  800203:	74 0f                	je     800214 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800205:	a1 20 30 80 00       	mov    0x803020,%eax
  80020a:	05 5c 05 00 00       	add    $0x55c,%eax
  80020f:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800214:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800218:	7e 0a                	jle    800224 <libmain+0x60>
		binaryname = argv[0];
  80021a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021d:	8b 00                	mov    (%eax),%eax
  80021f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	ff 75 0c             	pushl  0xc(%ebp)
  80022a:	ff 75 08             	pushl  0x8(%ebp)
  80022d:	e8 06 fe ff ff       	call   800038 <_main>
  800232:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800235:	e8 e3 14 00 00       	call   80171d <sys_disable_interrupt>
	cprintf("**************************************\n");
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 30 20 80 00       	push   $0x802030
  800242:	e8 6d 03 00 00       	call   8005b4 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80024a:	a1 20 30 80 00       	mov    0x803020,%eax
  80024f:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800255:	a1 20 30 80 00       	mov    0x803020,%eax
  80025a:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800260:	83 ec 04             	sub    $0x4,%esp
  800263:	52                   	push   %edx
  800264:	50                   	push   %eax
  800265:	68 58 20 80 00       	push   $0x802058
  80026a:	e8 45 03 00 00       	call   8005b4 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800272:	a1 20 30 80 00       	mov    0x803020,%eax
  800277:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80027d:	a1 20 30 80 00       	mov    0x803020,%eax
  800282:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800288:	a1 20 30 80 00       	mov    0x803020,%eax
  80028d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800293:	51                   	push   %ecx
  800294:	52                   	push   %edx
  800295:	50                   	push   %eax
  800296:	68 80 20 80 00       	push   $0x802080
  80029b:	e8 14 03 00 00       	call   8005b4 <cprintf>
  8002a0:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a8:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	50                   	push   %eax
  8002b2:	68 d8 20 80 00       	push   $0x8020d8
  8002b7:	e8 f8 02 00 00       	call   8005b4 <cprintf>
  8002bc:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002bf:	83 ec 0c             	sub    $0xc,%esp
  8002c2:	68 30 20 80 00       	push   $0x802030
  8002c7:	e8 e8 02 00 00       	call   8005b4 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002cf:	e8 63 14 00 00       	call   801737 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002d4:	e8 19 00 00 00       	call   8002f2 <exit>
}
  8002d9:	90                   	nop
  8002da:	c9                   	leave  
  8002db:	c3                   	ret    

008002dc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002e2:	83 ec 0c             	sub    $0xc,%esp
  8002e5:	6a 00                	push   $0x0
  8002e7:	e8 f0 15 00 00       	call   8018dc <sys_destroy_env>
  8002ec:	83 c4 10             	add    $0x10,%esp
}
  8002ef:	90                   	nop
  8002f0:	c9                   	leave  
  8002f1:	c3                   	ret    

008002f2 <exit>:

void
exit(void)
{
  8002f2:	55                   	push   %ebp
  8002f3:	89 e5                	mov    %esp,%ebp
  8002f5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002f8:	e8 45 16 00 00       	call   801942 <sys_exit_env>
}
  8002fd:	90                   	nop
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800306:	8d 45 10             	lea    0x10(%ebp),%eax
  800309:	83 c0 04             	add    $0x4,%eax
  80030c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80030f:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800314:	85 c0                	test   %eax,%eax
  800316:	74 16                	je     80032e <_panic+0x2e>
		cprintf("%s: ", argv0);
  800318:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	50                   	push   %eax
  800321:	68 ec 20 80 00       	push   $0x8020ec
  800326:	e8 89 02 00 00       	call   8005b4 <cprintf>
  80032b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80032e:	a1 00 30 80 00       	mov    0x803000,%eax
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 08             	pushl  0x8(%ebp)
  800339:	50                   	push   %eax
  80033a:	68 f1 20 80 00       	push   $0x8020f1
  80033f:	e8 70 02 00 00       	call   8005b4 <cprintf>
  800344:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800347:	8b 45 10             	mov    0x10(%ebp),%eax
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	ff 75 f4             	pushl  -0xc(%ebp)
  800350:	50                   	push   %eax
  800351:	e8 f3 01 00 00       	call   800549 <vcprintf>
  800356:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800359:	83 ec 08             	sub    $0x8,%esp
  80035c:	6a 00                	push   $0x0
  80035e:	68 0d 21 80 00       	push   $0x80210d
  800363:	e8 e1 01 00 00       	call   800549 <vcprintf>
  800368:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80036b:	e8 82 ff ff ff       	call   8002f2 <exit>

	// should not return here
	while (1) ;
  800370:	eb fe                	jmp    800370 <_panic+0x70>

00800372 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800378:	a1 20 30 80 00       	mov    0x803020,%eax
  80037d:	8b 50 74             	mov    0x74(%eax),%edx
  800380:	8b 45 0c             	mov    0xc(%ebp),%eax
  800383:	39 c2                	cmp    %eax,%edx
  800385:	74 14                	je     80039b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800387:	83 ec 04             	sub    $0x4,%esp
  80038a:	68 10 21 80 00       	push   $0x802110
  80038f:	6a 26                	push   $0x26
  800391:	68 5c 21 80 00       	push   $0x80215c
  800396:	e8 65 ff ff ff       	call   800300 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80039b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003a9:	e9 c2 00 00 00       	jmp    800470 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	85 c0                	test   %eax,%eax
  8003c1:	75 08                	jne    8003cb <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003c3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003c6:	e9 a2 00 00 00       	jmp    80046d <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003d9:	eb 69                	jmp    800444 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003db:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	01 c0                	add    %eax,%eax
  8003ed:	01 d0                	add    %edx,%eax
  8003ef:	c1 e0 03             	shl    $0x3,%eax
  8003f2:	01 c8                	add    %ecx,%eax
  8003f4:	8a 40 04             	mov    0x4(%eax),%al
  8003f7:	84 c0                	test   %al,%al
  8003f9:	75 46                	jne    800441 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003fb:	a1 20 30 80 00       	mov    0x803020,%eax
  800400:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800406:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800409:	89 d0                	mov    %edx,%eax
  80040b:	01 c0                	add    %eax,%eax
  80040d:	01 d0                	add    %edx,%eax
  80040f:	c1 e0 03             	shl    $0x3,%eax
  800412:	01 c8                	add    %ecx,%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800419:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80041c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800421:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800426:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	01 c8                	add    %ecx,%eax
  800432:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800434:	39 c2                	cmp    %eax,%edx
  800436:	75 09                	jne    800441 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800438:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80043f:	eb 12                	jmp    800453 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800441:	ff 45 e8             	incl   -0x18(%ebp)
  800444:	a1 20 30 80 00       	mov    0x803020,%eax
  800449:	8b 50 74             	mov    0x74(%eax),%edx
  80044c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044f:	39 c2                	cmp    %eax,%edx
  800451:	77 88                	ja     8003db <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800453:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800457:	75 14                	jne    80046d <CheckWSWithoutLastIndex+0xfb>
			panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 68 21 80 00       	push   $0x802168
  800461:	6a 3a                	push   $0x3a
  800463:	68 5c 21 80 00       	push   $0x80215c
  800468:	e8 93 fe ff ff       	call   800300 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80046d:	ff 45 f0             	incl   -0x10(%ebp)
  800470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800473:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800476:	0f 8c 32 ff ff ff    	jl     8003ae <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80047c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800483:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80048a:	eb 26                	jmp    8004b2 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80048c:	a1 20 30 80 00       	mov    0x803020,%eax
  800491:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800497:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	c1 e0 03             	shl    $0x3,%eax
  8004a3:	01 c8                	add    %ecx,%eax
  8004a5:	8a 40 04             	mov    0x4(%eax),%al
  8004a8:	3c 01                	cmp    $0x1,%al
  8004aa:	75 03                	jne    8004af <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004ac:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004af:	ff 45 e0             	incl   -0x20(%ebp)
  8004b2:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b7:	8b 50 74             	mov    0x74(%eax),%edx
  8004ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	77 cb                	ja     80048c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004c4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c7:	74 14                	je     8004dd <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 bc 21 80 00       	push   $0x8021bc
  8004d1:	6a 44                	push   $0x44
  8004d3:	68 5c 21 80 00       	push   $0x80215c
  8004d8:	e8 23 fe ff ff       	call   800300 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004dd:	90                   	nop
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f1:	89 0a                	mov    %ecx,(%edx)
  8004f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f6:	88 d1                	mov    %dl,%cl
  8004f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fb:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	3d ff 00 00 00       	cmp    $0xff,%eax
  800509:	75 2c                	jne    800537 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80050b:	a0 24 30 80 00       	mov    0x803024,%al
  800510:	0f b6 c0             	movzbl %al,%eax
  800513:	8b 55 0c             	mov    0xc(%ebp),%edx
  800516:	8b 12                	mov    (%edx),%edx
  800518:	89 d1                	mov    %edx,%ecx
  80051a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051d:	83 c2 08             	add    $0x8,%edx
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	50                   	push   %eax
  800524:	51                   	push   %ecx
  800525:	52                   	push   %edx
  800526:	e8 44 10 00 00       	call   80156f <sys_cputs>
  80052b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80052e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800531:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053a:	8b 40 04             	mov    0x4(%eax),%eax
  80053d:	8d 50 01             	lea    0x1(%eax),%edx
  800540:	8b 45 0c             	mov    0xc(%ebp),%eax
  800543:	89 50 04             	mov    %edx,0x4(%eax)
}
  800546:	90                   	nop
  800547:	c9                   	leave  
  800548:	c3                   	ret    

00800549 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800549:	55                   	push   %ebp
  80054a:	89 e5                	mov    %esp,%ebp
  80054c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800552:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800559:	00 00 00 
	b.cnt = 0;
  80055c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800563:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800566:	ff 75 0c             	pushl  0xc(%ebp)
  800569:	ff 75 08             	pushl  0x8(%ebp)
  80056c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800572:	50                   	push   %eax
  800573:	68 e0 04 80 00       	push   $0x8004e0
  800578:	e8 11 02 00 00       	call   80078e <vprintfmt>
  80057d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800580:	a0 24 30 80 00       	mov    0x803024,%al
  800585:	0f b6 c0             	movzbl %al,%eax
  800588:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	50                   	push   %eax
  800592:	52                   	push   %edx
  800593:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800599:	83 c0 08             	add    $0x8,%eax
  80059c:	50                   	push   %eax
  80059d:	e8 cd 0f 00 00       	call   80156f <sys_cputs>
  8005a2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005a5:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005ac:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ba:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005c1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	50                   	push   %eax
  8005d1:	e8 73 ff ff ff       	call   800549 <vcprintf>
  8005d6:	83 c4 10             	add    $0x10,%esp
  8005d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005e7:	e8 31 11 00 00       	call   80171d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fb:	50                   	push   %eax
  8005fc:	e8 48 ff ff ff       	call   800549 <vcprintf>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800607:	e8 2b 11 00 00       	call   801737 <sys_enable_interrupt>
	return cnt;
  80060c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80060f:	c9                   	leave  
  800610:	c3                   	ret    

00800611 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800611:	55                   	push   %ebp
  800612:	89 e5                	mov    %esp,%ebp
  800614:	53                   	push   %ebx
  800615:	83 ec 14             	sub    $0x14,%esp
  800618:	8b 45 10             	mov    0x10(%ebp),%eax
  80061b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80061e:	8b 45 14             	mov    0x14(%ebp),%eax
  800621:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800624:	8b 45 18             	mov    0x18(%ebp),%eax
  800627:	ba 00 00 00 00       	mov    $0x0,%edx
  80062c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80062f:	77 55                	ja     800686 <printnum+0x75>
  800631:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800634:	72 05                	jb     80063b <printnum+0x2a>
  800636:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800639:	77 4b                	ja     800686 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80063b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80063e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800641:	8b 45 18             	mov    0x18(%ebp),%eax
  800644:	ba 00 00 00 00       	mov    $0x0,%edx
  800649:	52                   	push   %edx
  80064a:	50                   	push   %eax
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	ff 75 f0             	pushl  -0x10(%ebp)
  800651:	e8 ee 15 00 00       	call   801c44 <__udivdi3>
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	83 ec 04             	sub    $0x4,%esp
  80065c:	ff 75 20             	pushl  0x20(%ebp)
  80065f:	53                   	push   %ebx
  800660:	ff 75 18             	pushl  0x18(%ebp)
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	ff 75 0c             	pushl  0xc(%ebp)
  800668:	ff 75 08             	pushl  0x8(%ebp)
  80066b:	e8 a1 ff ff ff       	call   800611 <printnum>
  800670:	83 c4 20             	add    $0x20,%esp
  800673:	eb 1a                	jmp    80068f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	ff 75 20             	pushl  0x20(%ebp)
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	ff d0                	call   *%eax
  800683:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800686:	ff 4d 1c             	decl   0x1c(%ebp)
  800689:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80068d:	7f e6                	jg     800675 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80068f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800692:	bb 00 00 00 00       	mov    $0x0,%ebx
  800697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80069a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80069d:	53                   	push   %ebx
  80069e:	51                   	push   %ecx
  80069f:	52                   	push   %edx
  8006a0:	50                   	push   %eax
  8006a1:	e8 ae 16 00 00       	call   801d54 <__umoddi3>
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	05 34 24 80 00       	add    $0x802434,%eax
  8006ae:	8a 00                	mov    (%eax),%al
  8006b0:	0f be c0             	movsbl %al,%eax
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	50                   	push   %eax
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	ff d0                	call   *%eax
  8006bf:	83 c4 10             	add    $0x10,%esp
}
  8006c2:	90                   	nop
  8006c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006c6:	c9                   	leave  
  8006c7:	c3                   	ret    

008006c8 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006cf:	7e 1c                	jle    8006ed <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 08             	lea    0x8(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 08             	sub    $0x8,%eax
  8006e6:	8b 50 04             	mov    0x4(%eax),%edx
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	eb 40                	jmp    80072d <getuint+0x65>
	else if (lflag)
  8006ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006f1:	74 1e                	je     800711 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	ba 00 00 00 00       	mov    $0x0,%edx
  80070f:	eb 1c                	jmp    80072d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	8d 50 04             	lea    0x4(%eax),%edx
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	89 10                	mov    %edx,(%eax)
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	83 e8 04             	sub    $0x4,%eax
  800726:	8b 00                	mov    (%eax),%eax
  800728:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80072d:	5d                   	pop    %ebp
  80072e:	c3                   	ret    

0080072f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800732:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800736:	7e 1c                	jle    800754 <getint+0x25>
		return va_arg(*ap, long long);
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	8d 50 08             	lea    0x8(%eax),%edx
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	89 10                	mov    %edx,(%eax)
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	83 e8 08             	sub    $0x8,%eax
  80074d:	8b 50 04             	mov    0x4(%eax),%edx
  800750:	8b 00                	mov    (%eax),%eax
  800752:	eb 38                	jmp    80078c <getint+0x5d>
	else if (lflag)
  800754:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800758:	74 1a                	je     800774 <getint+0x45>
		return va_arg(*ap, long);
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	8d 50 04             	lea    0x4(%eax),%edx
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	89 10                	mov    %edx,(%eax)
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	8b 00                	mov    (%eax),%eax
  80076c:	83 e8 04             	sub    $0x4,%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	99                   	cltd   
  800772:	eb 18                	jmp    80078c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800774:	8b 45 08             	mov    0x8(%ebp),%eax
  800777:	8b 00                	mov    (%eax),%eax
  800779:	8d 50 04             	lea    0x4(%eax),%edx
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	89 10                	mov    %edx,(%eax)
  800781:	8b 45 08             	mov    0x8(%ebp),%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	83 e8 04             	sub    $0x4,%eax
  800789:	8b 00                	mov    (%eax),%eax
  80078b:	99                   	cltd   
}
  80078c:	5d                   	pop    %ebp
  80078d:	c3                   	ret    

0080078e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80078e:	55                   	push   %ebp
  80078f:	89 e5                	mov    %esp,%ebp
  800791:	56                   	push   %esi
  800792:	53                   	push   %ebx
  800793:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800796:	eb 17                	jmp    8007af <vprintfmt+0x21>
			if (ch == '\0')
  800798:	85 db                	test   %ebx,%ebx
  80079a:	0f 84 af 03 00 00    	je     800b4f <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 0c             	pushl  0xc(%ebp)
  8007a6:	53                   	push   %ebx
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	ff d0                	call   *%eax
  8007ac:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007af:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b2:	8d 50 01             	lea    0x1(%eax),%edx
  8007b5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b8:	8a 00                	mov    (%eax),%al
  8007ba:	0f b6 d8             	movzbl %al,%ebx
  8007bd:	83 fb 25             	cmp    $0x25,%ebx
  8007c0:	75 d6                	jne    800798 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007c2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007cd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007db:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8d 50 01             	lea    0x1(%eax),%edx
  8007e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8007eb:	8a 00                	mov    (%eax),%al
  8007ed:	0f b6 d8             	movzbl %al,%ebx
  8007f0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007f3:	83 f8 55             	cmp    $0x55,%eax
  8007f6:	0f 87 2b 03 00 00    	ja     800b27 <vprintfmt+0x399>
  8007fc:	8b 04 85 58 24 80 00 	mov    0x802458(,%eax,4),%eax
  800803:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800805:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800809:	eb d7                	jmp    8007e2 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80080b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80080f:	eb d1                	jmp    8007e2 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800811:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800818:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80081b:	89 d0                	mov    %edx,%eax
  80081d:	c1 e0 02             	shl    $0x2,%eax
  800820:	01 d0                	add    %edx,%eax
  800822:	01 c0                	add    %eax,%eax
  800824:	01 d8                	add    %ebx,%eax
  800826:	83 e8 30             	sub    $0x30,%eax
  800829:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80082c:	8b 45 10             	mov    0x10(%ebp),%eax
  80082f:	8a 00                	mov    (%eax),%al
  800831:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800834:	83 fb 2f             	cmp    $0x2f,%ebx
  800837:	7e 3e                	jle    800877 <vprintfmt+0xe9>
  800839:	83 fb 39             	cmp    $0x39,%ebx
  80083c:	7f 39                	jg     800877 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80083e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800841:	eb d5                	jmp    800818 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800857:	eb 1f                	jmp    800878 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800859:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80085d:	79 83                	jns    8007e2 <vprintfmt+0x54>
				width = 0;
  80085f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800866:	e9 77 ff ff ff       	jmp    8007e2 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80086b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800872:	e9 6b ff ff ff       	jmp    8007e2 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800877:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800878:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087c:	0f 89 60 ff ff ff    	jns    8007e2 <vprintfmt+0x54>
				width = precision, precision = -1;
  800882:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800885:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800888:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80088f:	e9 4e ff ff ff       	jmp    8007e2 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800894:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800897:	e9 46 ff ff ff       	jmp    8007e2 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 00                	mov    (%eax),%eax
  8008ad:	83 ec 08             	sub    $0x8,%esp
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	50                   	push   %eax
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
			break;
  8008bc:	e9 89 02 00 00       	jmp    800b4a <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008d2:	85 db                	test   %ebx,%ebx
  8008d4:	79 02                	jns    8008d8 <vprintfmt+0x14a>
				err = -err;
  8008d6:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008d8:	83 fb 64             	cmp    $0x64,%ebx
  8008db:	7f 0b                	jg     8008e8 <vprintfmt+0x15a>
  8008dd:	8b 34 9d a0 22 80 00 	mov    0x8022a0(,%ebx,4),%esi
  8008e4:	85 f6                	test   %esi,%esi
  8008e6:	75 19                	jne    800901 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008e8:	53                   	push   %ebx
  8008e9:	68 45 24 80 00       	push   $0x802445
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	ff 75 08             	pushl  0x8(%ebp)
  8008f4:	e8 5e 02 00 00       	call   800b57 <printfmt>
  8008f9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008fc:	e9 49 02 00 00       	jmp    800b4a <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800901:	56                   	push   %esi
  800902:	68 4e 24 80 00       	push   $0x80244e
  800907:	ff 75 0c             	pushl  0xc(%ebp)
  80090a:	ff 75 08             	pushl  0x8(%ebp)
  80090d:	e8 45 02 00 00       	call   800b57 <printfmt>
  800912:	83 c4 10             	add    $0x10,%esp
			break;
  800915:	e9 30 02 00 00       	jmp    800b4a <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 30                	mov    (%eax),%esi
  80092b:	85 f6                	test   %esi,%esi
  80092d:	75 05                	jne    800934 <vprintfmt+0x1a6>
				p = "(null)";
  80092f:	be 51 24 80 00       	mov    $0x802451,%esi
			if (width > 0 && padc != '-')
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7e 6d                	jle    8009a7 <vprintfmt+0x219>
  80093a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80093e:	74 67                	je     8009a7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800940:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	50                   	push   %eax
  800947:	56                   	push   %esi
  800948:	e8 12 05 00 00       	call   800e5f <strnlen>
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800953:	eb 16                	jmp    80096b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800955:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800959:	83 ec 08             	sub    $0x8,%esp
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	50                   	push   %eax
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	ff d0                	call   *%eax
  800965:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800968:	ff 4d e4             	decl   -0x1c(%ebp)
  80096b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096f:	7f e4                	jg     800955 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800971:	eb 34                	jmp    8009a7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800973:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800977:	74 1c                	je     800995 <vprintfmt+0x207>
  800979:	83 fb 1f             	cmp    $0x1f,%ebx
  80097c:	7e 05                	jle    800983 <vprintfmt+0x1f5>
  80097e:	83 fb 7e             	cmp    $0x7e,%ebx
  800981:	7e 12                	jle    800995 <vprintfmt+0x207>
					putch('?', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 3f                	push   $0x3f
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
  800993:	eb 0f                	jmp    8009a4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	ff 75 0c             	pushl  0xc(%ebp)
  80099b:	53                   	push   %ebx
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	89 f0                	mov    %esi,%eax
  8009a9:	8d 70 01             	lea    0x1(%eax),%esi
  8009ac:	8a 00                	mov    (%eax),%al
  8009ae:	0f be d8             	movsbl %al,%ebx
  8009b1:	85 db                	test   %ebx,%ebx
  8009b3:	74 24                	je     8009d9 <vprintfmt+0x24b>
  8009b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009b9:	78 b8                	js     800973 <vprintfmt+0x1e5>
  8009bb:	ff 4d e0             	decl   -0x20(%ebp)
  8009be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c2:	79 af                	jns    800973 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009c4:	eb 13                	jmp    8009d9 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	ff 75 0c             	pushl  0xc(%ebp)
  8009cc:	6a 20                	push   $0x20
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e7                	jg     8009c6 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009df:	e9 66 01 00 00       	jmp    800b4a <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009e4:	83 ec 08             	sub    $0x8,%esp
  8009e7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ea:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ed:	50                   	push   %eax
  8009ee:	e8 3c fd ff ff       	call   80072f <getint>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a02:	85 d2                	test   %edx,%edx
  800a04:	79 23                	jns    800a29 <vprintfmt+0x29b>
				putch('-', putdat);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 0c             	pushl  0xc(%ebp)
  800a0c:	6a 2d                	push   $0x2d
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	ff d0                	call   *%eax
  800a13:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a1c:	f7 d8                	neg    %eax
  800a1e:	83 d2 00             	adc    $0x0,%edx
  800a21:	f7 da                	neg    %edx
  800a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a29:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a30:	e9 bc 00 00 00       	jmp    800af1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a35:	83 ec 08             	sub    $0x8,%esp
  800a38:	ff 75 e8             	pushl  -0x18(%ebp)
  800a3b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3e:	50                   	push   %eax
  800a3f:	e8 84 fc ff ff       	call   8006c8 <getuint>
  800a44:	83 c4 10             	add    $0x10,%esp
  800a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a4d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a54:	e9 98 00 00 00       	jmp    800af1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a59:	83 ec 08             	sub    $0x8,%esp
  800a5c:	ff 75 0c             	pushl  0xc(%ebp)
  800a5f:	6a 58                	push   $0x58
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	ff d0                	call   *%eax
  800a66:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a69:	83 ec 08             	sub    $0x8,%esp
  800a6c:	ff 75 0c             	pushl  0xc(%ebp)
  800a6f:	6a 58                	push   $0x58
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	ff d0                	call   *%eax
  800a76:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a79:	83 ec 08             	sub    $0x8,%esp
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	6a 58                	push   $0x58
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	ff d0                	call   *%eax
  800a86:	83 c4 10             	add    $0x10,%esp
			break;
  800a89:	e9 bc 00 00 00       	jmp    800b4a <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 30                	push   $0x30
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 78                	push   $0x78
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800aae:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab1:	83 c0 04             	add    $0x4,%eax
  800ab4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aba:	83 e8 04             	sub    $0x4,%eax
  800abd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ac9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ad0:	eb 1f                	jmp    800af1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad8:	8d 45 14             	lea    0x14(%ebp),%eax
  800adb:	50                   	push   %eax
  800adc:	e8 e7 fb ff ff       	call   8006c8 <getuint>
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aea:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800af1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800af8:	83 ec 04             	sub    $0x4,%esp
  800afb:	52                   	push   %edx
  800afc:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aff:	50                   	push   %eax
  800b00:	ff 75 f4             	pushl  -0xc(%ebp)
  800b03:	ff 75 f0             	pushl  -0x10(%ebp)
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	ff 75 08             	pushl  0x8(%ebp)
  800b0c:	e8 00 fb ff ff       	call   800611 <printnum>
  800b11:	83 c4 20             	add    $0x20,%esp
			break;
  800b14:	eb 34                	jmp    800b4a <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	53                   	push   %ebx
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	ff d0                	call   *%eax
  800b22:	83 c4 10             	add    $0x10,%esp
			break;
  800b25:	eb 23                	jmp    800b4a <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b27:	83 ec 08             	sub    $0x8,%esp
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	6a 25                	push   $0x25
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	ff d0                	call   *%eax
  800b34:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b37:	ff 4d 10             	decl   0x10(%ebp)
  800b3a:	eb 03                	jmp    800b3f <vprintfmt+0x3b1>
  800b3c:	ff 4d 10             	decl   0x10(%ebp)
  800b3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b42:	48                   	dec    %eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	3c 25                	cmp    $0x25,%al
  800b47:	75 f3                	jne    800b3c <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b49:	90                   	nop
		}
	}
  800b4a:	e9 47 fc ff ff       	jmp    800796 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b4f:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b53:	5b                   	pop    %ebx
  800b54:	5e                   	pop    %esi
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b5d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b60:	83 c0 04             	add    $0x4,%eax
  800b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b66:	8b 45 10             	mov    0x10(%ebp),%eax
  800b69:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6c:	50                   	push   %eax
  800b6d:	ff 75 0c             	pushl  0xc(%ebp)
  800b70:	ff 75 08             	pushl  0x8(%ebp)
  800b73:	e8 16 fc ff ff       	call   80078e <vprintfmt>
  800b78:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b7b:	90                   	nop
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8b 40 08             	mov    0x8(%eax),%eax
  800b87:	8d 50 01             	lea    0x1(%eax),%edx
  800b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	8b 10                	mov    (%eax),%edx
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	8b 40 04             	mov    0x4(%eax),%eax
  800b9b:	39 c2                	cmp    %eax,%edx
  800b9d:	73 12                	jae    800bb1 <sprintputch+0x33>
		*b->buf++ = ch;
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	8d 48 01             	lea    0x1(%eax),%ecx
  800ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800baa:	89 0a                	mov    %ecx,(%edx)
  800bac:	8b 55 08             	mov    0x8(%ebp),%edx
  800baf:	88 10                	mov    %dl,(%eax)
}
  800bb1:	90                   	nop
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc9:	01 d0                	add    %edx,%eax
  800bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bd5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bd9:	74 06                	je     800be1 <vsnprintf+0x2d>
  800bdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bdf:	7f 07                	jg     800be8 <vsnprintf+0x34>
		return -E_INVAL;
  800be1:	b8 03 00 00 00       	mov    $0x3,%eax
  800be6:	eb 20                	jmp    800c08 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800be8:	ff 75 14             	pushl  0x14(%ebp)
  800beb:	ff 75 10             	pushl  0x10(%ebp)
  800bee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bf1:	50                   	push   %eax
  800bf2:	68 7e 0b 80 00       	push   $0x800b7e
  800bf7:	e8 92 fb ff ff       	call   80078e <vprintfmt>
  800bfc:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c02:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c08:	c9                   	leave  
  800c09:	c3                   	ret    

00800c0a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c10:	8d 45 10             	lea    0x10(%ebp),%eax
  800c13:	83 c0 04             	add    $0x4,%eax
  800c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c1f:	50                   	push   %eax
  800c20:	ff 75 0c             	pushl  0xc(%ebp)
  800c23:	ff 75 08             	pushl  0x8(%ebp)
  800c26:	e8 89 ff ff ff       	call   800bb4 <vsnprintf>
  800c2b:	83 c4 10             	add    $0x10,%esp
  800c2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  800c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c40:	74 13                	je     800c55 <readline+0x1f>
		cprintf("%s", prompt);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	ff 75 08             	pushl  0x8(%ebp)
  800c48:	68 b0 25 80 00       	push   $0x8025b0
  800c4d:	e8 62 f9 ff ff       	call   8005b4 <cprintf>
  800c52:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800c55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800c5c:	83 ec 0c             	sub    $0xc,%esp
  800c5f:	6a 00                	push   $0x0
  800c61:	e8 d2 0f 00 00       	call   801c38 <iscons>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800c6c:	e8 79 0f 00 00       	call   801bea <getchar>
  800c71:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800c74:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800c78:	79 22                	jns    800c9c <readline+0x66>
			if (c != -E_EOF)
  800c7a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800c7e:	0f 84 ad 00 00 00    	je     800d31 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800c84:	83 ec 08             	sub    $0x8,%esp
  800c87:	ff 75 ec             	pushl  -0x14(%ebp)
  800c8a:	68 b3 25 80 00       	push   $0x8025b3
  800c8f:	e8 20 f9 ff ff       	call   8005b4 <cprintf>
  800c94:	83 c4 10             	add    $0x10,%esp
			return;
  800c97:	e9 95 00 00 00       	jmp    800d31 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800c9c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800ca0:	7e 34                	jle    800cd6 <readline+0xa0>
  800ca2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ca9:	7f 2b                	jg     800cd6 <readline+0xa0>
			if (echoing)
  800cab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800caf:	74 0e                	je     800cbf <readline+0x89>
				cputchar(c);
  800cb1:	83 ec 0c             	sub    $0xc,%esp
  800cb4:	ff 75 ec             	pushl  -0x14(%ebp)
  800cb7:	e8 e6 0e 00 00       	call   801ba2 <cputchar>
  800cbc:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cc2:	8d 50 01             	lea    0x1(%eax),%edx
  800cc5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800cc8:	89 c2                	mov    %eax,%edx
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	01 d0                	add    %edx,%eax
  800ccf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800cd2:	88 10                	mov    %dl,(%eax)
  800cd4:	eb 56                	jmp    800d2c <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800cd6:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800cda:	75 1f                	jne    800cfb <readline+0xc5>
  800cdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ce0:	7e 19                	jle    800cfb <readline+0xc5>
			if (echoing)
  800ce2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ce6:	74 0e                	je     800cf6 <readline+0xc0>
				cputchar(c);
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 af 0e 00 00       	call   801ba2 <cputchar>
  800cf3:	83 c4 10             	add    $0x10,%esp

			i--;
  800cf6:	ff 4d f4             	decl   -0xc(%ebp)
  800cf9:	eb 31                	jmp    800d2c <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800cfb:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800cff:	74 0a                	je     800d0b <readline+0xd5>
  800d01:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800d05:	0f 85 61 ff ff ff    	jne    800c6c <readline+0x36>
			if (echoing)
  800d0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d0f:	74 0e                	je     800d1f <readline+0xe9>
				cputchar(c);
  800d11:	83 ec 0c             	sub    $0xc,%esp
  800d14:	ff 75 ec             	pushl  -0x14(%ebp)
  800d17:	e8 86 0e 00 00       	call   801ba2 <cputchar>
  800d1c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800d1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	01 d0                	add    %edx,%eax
  800d27:	c6 00 00             	movb   $0x0,(%eax)
			return;
  800d2a:	eb 06                	jmp    800d32 <readline+0xfc>
		}
	}
  800d2c:	e9 3b ff ff ff       	jmp    800c6c <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  800d31:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  800d32:	c9                   	leave  
  800d33:	c3                   	ret    

00800d34 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d3a:	e8 de 09 00 00       	call   80171d <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  800d3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d43:	74 13                	je     800d58 <atomic_readline+0x24>
		cprintf("%s", prompt);
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	ff 75 08             	pushl  0x8(%ebp)
  800d4b:	68 b0 25 80 00       	push   $0x8025b0
  800d50:	e8 5f f8 ff ff       	call   8005b4 <cprintf>
  800d55:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800d58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800d5f:	83 ec 0c             	sub    $0xc,%esp
  800d62:	6a 00                	push   $0x0
  800d64:	e8 cf 0e 00 00       	call   801c38 <iscons>
  800d69:	83 c4 10             	add    $0x10,%esp
  800d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800d6f:	e8 76 0e 00 00       	call   801bea <getchar>
  800d74:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800d77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d7b:	79 23                	jns    800da0 <atomic_readline+0x6c>
			if (c != -E_EOF)
  800d7d:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800d81:	74 13                	je     800d96 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  800d83:	83 ec 08             	sub    $0x8,%esp
  800d86:	ff 75 ec             	pushl  -0x14(%ebp)
  800d89:	68 b3 25 80 00       	push   $0x8025b3
  800d8e:	e8 21 f8 ff ff       	call   8005b4 <cprintf>
  800d93:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800d96:	e8 9c 09 00 00       	call   801737 <sys_enable_interrupt>
			return;
  800d9b:	e9 9a 00 00 00       	jmp    800e3a <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800da0:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800da4:	7e 34                	jle    800dda <atomic_readline+0xa6>
  800da6:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800dad:	7f 2b                	jg     800dda <atomic_readline+0xa6>
			if (echoing)
  800daf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800db3:	74 0e                	je     800dc3 <atomic_readline+0x8f>
				cputchar(c);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	ff 75 ec             	pushl  -0x14(%ebp)
  800dbb:	e8 e2 0d 00 00       	call   801ba2 <cputchar>
  800dc0:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800dcc:	89 c2                	mov    %eax,%edx
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	01 d0                	add    %edx,%eax
  800dd3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800dd6:	88 10                	mov    %dl,(%eax)
  800dd8:	eb 5b                	jmp    800e35 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  800dda:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800dde:	75 1f                	jne    800dff <atomic_readline+0xcb>
  800de0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800de4:	7e 19                	jle    800dff <atomic_readline+0xcb>
			if (echoing)
  800de6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dea:	74 0e                	je     800dfa <atomic_readline+0xc6>
				cputchar(c);
  800dec:	83 ec 0c             	sub    $0xc,%esp
  800def:	ff 75 ec             	pushl  -0x14(%ebp)
  800df2:	e8 ab 0d 00 00       	call   801ba2 <cputchar>
  800df7:	83 c4 10             	add    $0x10,%esp
			i--;
  800dfa:	ff 4d f4             	decl   -0xc(%ebp)
  800dfd:	eb 36                	jmp    800e35 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  800dff:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800e03:	74 0a                	je     800e0f <atomic_readline+0xdb>
  800e05:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800e09:	0f 85 60 ff ff ff    	jne    800d6f <atomic_readline+0x3b>
			if (echoing)
  800e0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e13:	74 0e                	je     800e23 <atomic_readline+0xef>
				cputchar(c);
  800e15:	83 ec 0c             	sub    $0xc,%esp
  800e18:	ff 75 ec             	pushl  -0x14(%ebp)
  800e1b:	e8 82 0d 00 00       	call   801ba2 <cputchar>
  800e20:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  800e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	01 d0                	add    %edx,%eax
  800e2b:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  800e2e:	e8 04 09 00 00       	call   801737 <sys_enable_interrupt>
			return;
  800e33:	eb 05                	jmp    800e3a <atomic_readline+0x106>
		}
	}
  800e35:	e9 35 ff ff ff       	jmp    800d6f <atomic_readline+0x3b>
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e49:	eb 06                	jmp    800e51 <strlen+0x15>
		n++;
  800e4b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e4e:	ff 45 08             	incl   0x8(%ebp)
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8a 00                	mov    (%eax),%al
  800e56:	84 c0                	test   %al,%al
  800e58:	75 f1                	jne    800e4b <strlen+0xf>
		n++;
	return n;
  800e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6c:	eb 09                	jmp    800e77 <strnlen+0x18>
		n++;
  800e6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e71:	ff 45 08             	incl   0x8(%ebp)
  800e74:	ff 4d 0c             	decl   0xc(%ebp)
  800e77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e7b:	74 09                	je     800e86 <strnlen+0x27>
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 e8                	jne    800e6e <strnlen+0xf>
		n++;
	return n;
  800e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e97:	90                   	nop
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8d 50 01             	lea    0x1(%eax),%edx
  800e9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	84 c0                	test   %al,%al
  800eb2:	75 e4                	jne    800e98 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ec5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ecc:	eb 1f                	jmp    800eed <strncpy+0x34>
		*dst++ = *src;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	8d 50 01             	lea    0x1(%eax),%edx
  800ed4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eda:	8a 12                	mov    (%edx),%dl
  800edc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	84 c0                	test   %al,%al
  800ee5:	74 03                	je     800eea <strncpy+0x31>
			src++;
  800ee7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eea:	ff 45 fc             	incl   -0x4(%ebp)
  800eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef3:	72 d9                	jb     800ece <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ef5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0a:	74 30                	je     800f3c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f0c:	eb 16                	jmp    800f24 <strlcpy+0x2a>
			*dst++ = *src++;
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8d 50 01             	lea    0x1(%eax),%edx
  800f14:	89 55 08             	mov    %edx,0x8(%ebp)
  800f17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f20:	8a 12                	mov    (%edx),%dl
  800f22:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f24:	ff 4d 10             	decl   0x10(%ebp)
  800f27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f2b:	74 09                	je     800f36 <strlcpy+0x3c>
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	84 c0                	test   %al,%al
  800f34:	75 d8                	jne    800f0e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f42:	29 c2                	sub    %eax,%edx
  800f44:	89 d0                	mov    %edx,%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f4b:	eb 06                	jmp    800f53 <strcmp+0xb>
		p++, q++;
  800f4d:	ff 45 08             	incl   0x8(%ebp)
  800f50:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	84 c0                	test   %al,%al
  800f5a:	74 0e                	je     800f6a <strcmp+0x22>
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 10                	mov    (%eax),%dl
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	38 c2                	cmp    %al,%dl
  800f68:	74 e3                	je     800f4d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	0f b6 d0             	movzbl %al,%edx
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	0f b6 c0             	movzbl %al,%eax
  800f7a:	29 c2                	sub    %eax,%edx
  800f7c:	89 d0                	mov    %edx,%eax
}
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f83:	eb 09                	jmp    800f8e <strncmp+0xe>
		n--, p++, q++;
  800f85:	ff 4d 10             	decl   0x10(%ebp)
  800f88:	ff 45 08             	incl   0x8(%ebp)
  800f8b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f92:	74 17                	je     800fab <strncmp+0x2b>
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	84 c0                	test   %al,%al
  800f9b:	74 0e                	je     800fab <strncmp+0x2b>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 10                	mov    (%eax),%dl
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	38 c2                	cmp    %al,%dl
  800fa9:	74 da                	je     800f85 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strncmp+0x38>
		return 0;
  800fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb6:	eb 14                	jmp    800fcc <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	0f b6 d0             	movzbl %al,%edx
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	0f b6 c0             	movzbl %al,%eax
  800fc8:	29 c2                	sub    %eax,%edx
  800fca:	89 d0                	mov    %edx,%eax
}
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    

00800fce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 12                	jmp    800fee <strchr+0x20>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	75 05                	jne    800feb <strchr+0x1d>
			return (char *) s;
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	eb 11                	jmp    800ffc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	84 c0                	test   %al,%al
  800ff5:	75 e5                	jne    800fdc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ff7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	83 ec 04             	sub    $0x4,%esp
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80100a:	eb 0d                	jmp    801019 <strfind+0x1b>
		if (*s == c)
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801014:	74 0e                	je     801024 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801016:	ff 45 08             	incl   0x8(%ebp)
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	84 c0                	test   %al,%al
  801020:	75 ea                	jne    80100c <strfind+0xe>
  801022:	eb 01                	jmp    801025 <strfind+0x27>
		if (*s == c)
			break;
  801024:	90                   	nop
	return (char *) s;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80103c:	eb 0e                	jmp    80104c <memset+0x22>
		*p++ = c;
  80103e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801047:	8b 55 0c             	mov    0xc(%ebp),%edx
  80104a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80104c:	ff 4d f8             	decl   -0x8(%ebp)
  80104f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801053:	79 e9                	jns    80103e <memset+0x14>
		*p++ = c;

	return v;
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801060:	8b 45 0c             	mov    0xc(%ebp),%eax
  801063:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80106c:	eb 16                	jmp    801084 <memcpy+0x2a>
		*d++ = *s++;
  80106e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801071:	8d 50 01             	lea    0x1(%eax),%edx
  801074:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801077:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80107a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801080:	8a 12                	mov    (%edx),%dl
  801082:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801084:	8b 45 10             	mov    0x10(%ebp),%eax
  801087:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108a:	89 55 10             	mov    %edx,0x10(%ebp)
  80108d:	85 c0                	test   %eax,%eax
  80108f:	75 dd                	jne    80106e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801094:	c9                   	leave  
  801095:	c3                   	ret    

00801096 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ae:	73 50                	jae    801100 <memmove+0x6a>
  8010b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b6:	01 d0                	add    %edx,%eax
  8010b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010bb:	76 43                	jbe    801100 <memmove+0x6a>
		s += n;
  8010bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010c9:	eb 10                	jmp    8010db <memmove+0x45>
			*--d = *--s;
  8010cb:	ff 4d f8             	decl   -0x8(%ebp)
  8010ce:	ff 4d fc             	decl   -0x4(%ebp)
  8010d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d4:	8a 10                	mov    (%eax),%dl
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010db:	8b 45 10             	mov    0x10(%ebp),%eax
  8010de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	75 e3                	jne    8010cb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010e8:	eb 23                	jmp    80110d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ed:	8d 50 01             	lea    0x1(%eax),%edx
  8010f0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010fc:	8a 12                	mov    (%edx),%dl
  8010fe:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	8d 50 ff             	lea    -0x1(%eax),%edx
  801106:	89 55 10             	mov    %edx,0x10(%ebp)
  801109:	85 c0                	test   %eax,%eax
  80110b:	75 dd                	jne    8010ea <memmove+0x54>
			*d++ = *s++;

	return dst;
  80110d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801124:	eb 2a                	jmp    801150 <memcmp+0x3e>
		if (*s1 != *s2)
  801126:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801129:	8a 10                	mov    (%eax),%dl
  80112b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	38 c2                	cmp    %al,%dl
  801132:	74 16                	je     80114a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801134:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	0f b6 d0             	movzbl %al,%edx
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f b6 c0             	movzbl %al,%eax
  801144:	29 c2                	sub    %eax,%edx
  801146:	89 d0                	mov    %edx,%eax
  801148:	eb 18                	jmp    801162 <memcmp+0x50>
		s1++, s2++;
  80114a:	ff 45 fc             	incl   -0x4(%ebp)
  80114d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801150:	8b 45 10             	mov    0x10(%ebp),%eax
  801153:	8d 50 ff             	lea    -0x1(%eax),%edx
  801156:	89 55 10             	mov    %edx,0x10(%ebp)
  801159:	85 c0                	test   %eax,%eax
  80115b:	75 c9                	jne    801126 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80115d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80116a:	8b 55 08             	mov    0x8(%ebp),%edx
  80116d:	8b 45 10             	mov    0x10(%ebp),%eax
  801170:	01 d0                	add    %edx,%eax
  801172:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801175:	eb 15                	jmp    80118c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	0f b6 d0             	movzbl %al,%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	0f b6 c0             	movzbl %al,%eax
  801185:	39 c2                	cmp    %eax,%edx
  801187:	74 0d                	je     801196 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801189:	ff 45 08             	incl   0x8(%ebp)
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801192:	72 e3                	jb     801177 <memfind+0x13>
  801194:	eb 01                	jmp    801197 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801196:	90                   	nop
	return (void *) s;
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b0:	eb 03                	jmp    8011b5 <strtol+0x19>
		s++;
  8011b2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	3c 20                	cmp    $0x20,%al
  8011bc:	74 f4                	je     8011b2 <strtol+0x16>
  8011be:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c1:	8a 00                	mov    (%eax),%al
  8011c3:	3c 09                	cmp    $0x9,%al
  8011c5:	74 eb                	je     8011b2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 2b                	cmp    $0x2b,%al
  8011ce:	75 05                	jne    8011d5 <strtol+0x39>
		s++;
  8011d0:	ff 45 08             	incl   0x8(%ebp)
  8011d3:	eb 13                	jmp    8011e8 <strtol+0x4c>
	else if (*s == '-')
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3c 2d                	cmp    $0x2d,%al
  8011dc:	75 0a                	jne    8011e8 <strtol+0x4c>
		s++, neg = 1;
  8011de:	ff 45 08             	incl   0x8(%ebp)
  8011e1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ec:	74 06                	je     8011f4 <strtol+0x58>
  8011ee:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011f2:	75 20                	jne    801214 <strtol+0x78>
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3c 30                	cmp    $0x30,%al
  8011fb:	75 17                	jne    801214 <strtol+0x78>
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	40                   	inc    %eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	3c 78                	cmp    $0x78,%al
  801205:	75 0d                	jne    801214 <strtol+0x78>
		s += 2, base = 16;
  801207:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80120b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801212:	eb 28                	jmp    80123c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801214:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801218:	75 15                	jne    80122f <strtol+0x93>
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	3c 30                	cmp    $0x30,%al
  801221:	75 0c                	jne    80122f <strtol+0x93>
		s++, base = 8;
  801223:	ff 45 08             	incl   0x8(%ebp)
  801226:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80122d:	eb 0d                	jmp    80123c <strtol+0xa0>
	else if (base == 0)
  80122f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801233:	75 07                	jne    80123c <strtol+0xa0>
		base = 10;
  801235:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	8a 00                	mov    (%eax),%al
  801241:	3c 2f                	cmp    $0x2f,%al
  801243:	7e 19                	jle    80125e <strtol+0xc2>
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8a 00                	mov    (%eax),%al
  80124a:	3c 39                	cmp    $0x39,%al
  80124c:	7f 10                	jg     80125e <strtol+0xc2>
			dig = *s - '0';
  80124e:	8b 45 08             	mov    0x8(%ebp),%eax
  801251:	8a 00                	mov    (%eax),%al
  801253:	0f be c0             	movsbl %al,%eax
  801256:	83 e8 30             	sub    $0x30,%eax
  801259:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80125c:	eb 42                	jmp    8012a0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 60                	cmp    $0x60,%al
  801265:	7e 19                	jle    801280 <strtol+0xe4>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 7a                	cmp    $0x7a,%al
  80126e:	7f 10                	jg     801280 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	0f be c0             	movsbl %al,%eax
  801278:	83 e8 57             	sub    $0x57,%eax
  80127b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80127e:	eb 20                	jmp    8012a0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 40                	cmp    $0x40,%al
  801287:	7e 39                	jle    8012c2 <strtol+0x126>
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 5a                	cmp    $0x5a,%al
  801290:	7f 30                	jg     8012c2 <strtol+0x126>
			dig = *s - 'A' + 10;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	83 e8 37             	sub    $0x37,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012a6:	7d 19                	jge    8012c1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
  8012ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ae:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012b2:	89 c2                	mov    %eax,%edx
  8012b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b7:	01 d0                	add    %edx,%eax
  8012b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012bc:	e9 7b ff ff ff       	jmp    80123c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012c1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012c6:	74 08                	je     8012d0 <strtol+0x134>
		*endptr = (char *) s;
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ce:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012d4:	74 07                	je     8012dd <strtol+0x141>
  8012d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d9:	f7 d8                	neg    %eax
  8012db:	eb 03                	jmp    8012e0 <strtol+0x144>
  8012dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e0:	c9                   	leave  
  8012e1:	c3                   	ret    

008012e2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012fa:	79 13                	jns    80130f <ltostr+0x2d>
	{
		neg = 1;
  8012fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801303:	8b 45 0c             	mov    0xc(%ebp),%eax
  801306:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801309:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80130c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801317:	99                   	cltd   
  801318:	f7 f9                	idiv   %ecx
  80131a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80131d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801320:	8d 50 01             	lea    0x1(%eax),%edx
  801323:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801326:	89 c2                	mov    %eax,%edx
  801328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132b:	01 d0                	add    %edx,%eax
  80132d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801330:	83 c2 30             	add    $0x30,%edx
  801333:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801335:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801338:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80133d:	f7 e9                	imul   %ecx
  80133f:	c1 fa 02             	sar    $0x2,%edx
  801342:	89 c8                	mov    %ecx,%eax
  801344:	c1 f8 1f             	sar    $0x1f,%eax
  801347:	29 c2                	sub    %eax,%edx
  801349:	89 d0                	mov    %edx,%eax
  80134b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80134e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801351:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801356:	f7 e9                	imul   %ecx
  801358:	c1 fa 02             	sar    $0x2,%edx
  80135b:	89 c8                	mov    %ecx,%eax
  80135d:	c1 f8 1f             	sar    $0x1f,%eax
  801360:	29 c2                	sub    %eax,%edx
  801362:	89 d0                	mov    %edx,%eax
  801364:	c1 e0 02             	shl    $0x2,%eax
  801367:	01 d0                	add    %edx,%eax
  801369:	01 c0                	add    %eax,%eax
  80136b:	29 c1                	sub    %eax,%ecx
  80136d:	89 ca                	mov    %ecx,%edx
  80136f:	85 d2                	test   %edx,%edx
  801371:	75 9c                	jne    80130f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801373:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80137a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137d:	48                   	dec    %eax
  80137e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801381:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801385:	74 3d                	je     8013c4 <ltostr+0xe2>
		start = 1 ;
  801387:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80138e:	eb 34                	jmp    8013c4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	01 d0                	add    %edx,%eax
  801398:	8a 00                	mov    (%eax),%al
  80139a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80139d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	01 c8                	add    %ecx,%eax
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b7:	01 c2                	add    %eax,%edx
  8013b9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013bc:	88 02                	mov    %al,(%edx)
		start++ ;
  8013be:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013c1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ca:	7c c4                	jl     801390 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013d7:	90                   	nop
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013e0:	ff 75 08             	pushl  0x8(%ebp)
  8013e3:	e8 54 fa ff ff       	call   800e3c <strlen>
  8013e8:	83 c4 04             	add    $0x4,%esp
  8013eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013ee:	ff 75 0c             	pushl  0xc(%ebp)
  8013f1:	e8 46 fa ff ff       	call   800e3c <strlen>
  8013f6:	83 c4 04             	add    $0x4,%esp
  8013f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80140a:	eb 17                	jmp    801423 <strcconcat+0x49>
		final[s] = str1[s] ;
  80140c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80140f:	8b 45 10             	mov    0x10(%ebp),%eax
  801412:	01 c2                	add    %eax,%edx
  801414:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	01 c8                	add    %ecx,%eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801420:	ff 45 fc             	incl   -0x4(%ebp)
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801426:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801429:	7c e1                	jl     80140c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80142b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801432:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801439:	eb 1f                	jmp    80145a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80143b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143e:	8d 50 01             	lea    0x1(%eax),%edx
  801441:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801444:	89 c2                	mov    %eax,%edx
  801446:	8b 45 10             	mov    0x10(%ebp),%eax
  801449:	01 c2                	add    %eax,%edx
  80144b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80144e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801451:	01 c8                	add    %ecx,%eax
  801453:	8a 00                	mov    (%eax),%al
  801455:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801457:	ff 45 f8             	incl   -0x8(%ebp)
  80145a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801460:	7c d9                	jl     80143b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801462:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801465:	8b 45 10             	mov    0x10(%ebp),%eax
  801468:	01 d0                	add    %edx,%eax
  80146a:	c6 00 00             	movb   $0x0,(%eax)
}
  80146d:	90                   	nop
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801473:	8b 45 14             	mov    0x14(%ebp),%eax
  801476:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80147c:	8b 45 14             	mov    0x14(%ebp),%eax
  80147f:	8b 00                	mov    (%eax),%eax
  801481:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801488:	8b 45 10             	mov    0x10(%ebp),%eax
  80148b:	01 d0                	add    %edx,%eax
  80148d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801493:	eb 0c                	jmp    8014a1 <strsplit+0x31>
			*string++ = 0;
  801495:	8b 45 08             	mov    0x8(%ebp),%eax
  801498:	8d 50 01             	lea    0x1(%eax),%edx
  80149b:	89 55 08             	mov    %edx,0x8(%ebp)
  80149e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	84 c0                	test   %al,%al
  8014a8:	74 18                	je     8014c2 <strsplit+0x52>
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	50                   	push   %eax
  8014b3:	ff 75 0c             	pushl  0xc(%ebp)
  8014b6:	e8 13 fb ff ff       	call   800fce <strchr>
  8014bb:	83 c4 08             	add    $0x8,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	75 d3                	jne    801495 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	84 c0                	test   %al,%al
  8014c9:	74 5a                	je     801525 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ce:	8b 00                	mov    (%eax),%eax
  8014d0:	83 f8 0f             	cmp    $0xf,%eax
  8014d3:	75 07                	jne    8014dc <strsplit+0x6c>
		{
			return 0;
  8014d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014da:	eb 66                	jmp    801542 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	8b 00                	mov    (%eax),%eax
  8014e1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014e4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014e7:	89 0a                	mov    %ecx,(%edx)
  8014e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f3:	01 c2                	add    %eax,%edx
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014fa:	eb 03                	jmp    8014ff <strsplit+0x8f>
			string++;
  8014fc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	8a 00                	mov    (%eax),%al
  801504:	84 c0                	test   %al,%al
  801506:	74 8b                	je     801493 <strsplit+0x23>
  801508:	8b 45 08             	mov    0x8(%ebp),%eax
  80150b:	8a 00                	mov    (%eax),%al
  80150d:	0f be c0             	movsbl %al,%eax
  801510:	50                   	push   %eax
  801511:	ff 75 0c             	pushl  0xc(%ebp)
  801514:	e8 b5 fa ff ff       	call   800fce <strchr>
  801519:	83 c4 08             	add    $0x8,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	74 dc                	je     8014fc <strsplit+0x8c>
			string++;
	}
  801520:	e9 6e ff ff ff       	jmp    801493 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801525:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801526:	8b 45 14             	mov    0x14(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801532:	8b 45 10             	mov    0x10(%ebp),%eax
  801535:	01 d0                	add    %edx,%eax
  801537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80153d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801542:	c9                   	leave  
  801543:	c3                   	ret    

00801544 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	57                   	push   %edi
  801548:	56                   	push   %esi
  801549:	53                   	push   %ebx
  80154a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	8b 55 0c             	mov    0xc(%ebp),%edx
  801553:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801556:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801559:	8b 7d 18             	mov    0x18(%ebp),%edi
  80155c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80155f:	cd 30                	int    $0x30
  801561:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801564:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801567:	83 c4 10             	add    $0x10,%esp
  80156a:	5b                   	pop    %ebx
  80156b:	5e                   	pop    %esi
  80156c:	5f                   	pop    %edi
  80156d:	5d                   	pop    %ebp
  80156e:	c3                   	ret    

0080156f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
  801572:	83 ec 04             	sub    $0x4,%esp
  801575:	8b 45 10             	mov    0x10(%ebp),%eax
  801578:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80157b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	52                   	push   %edx
  801587:	ff 75 0c             	pushl  0xc(%ebp)
  80158a:	50                   	push   %eax
  80158b:	6a 00                	push   $0x0
  80158d:	e8 b2 ff ff ff       	call   801544 <syscall>
  801592:	83 c4 18             	add    $0x18,%esp
}
  801595:	90                   	nop
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_cgetc>:

int
sys_cgetc(void)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 01                	push   $0x1
  8015a7:	e8 98 ff ff ff       	call   801544 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	52                   	push   %edx
  8015c1:	50                   	push   %eax
  8015c2:	6a 05                	push   $0x5
  8015c4:	e8 7b ff ff ff       	call   801544 <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	56                   	push   %esi
  8015d2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015d3:	8b 75 18             	mov    0x18(%ebp),%esi
  8015d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	56                   	push   %esi
  8015e3:	53                   	push   %ebx
  8015e4:	51                   	push   %ecx
  8015e5:	52                   	push   %edx
  8015e6:	50                   	push   %eax
  8015e7:	6a 06                	push   $0x6
  8015e9:	e8 56 ff ff ff       	call   801544 <syscall>
  8015ee:	83 c4 18             	add    $0x18,%esp
}
  8015f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f4:	5b                   	pop    %ebx
  8015f5:	5e                   	pop    %esi
  8015f6:	5d                   	pop    %ebp
  8015f7:	c3                   	ret    

008015f8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	52                   	push   %edx
  801608:	50                   	push   %eax
  801609:	6a 07                	push   $0x7
  80160b:	e8 34 ff ff ff       	call   801544 <syscall>
  801610:	83 c4 18             	add    $0x18,%esp
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	ff 75 08             	pushl  0x8(%ebp)
  801624:	6a 08                	push   $0x8
  801626:	e8 19 ff ff ff       	call   801544 <syscall>
  80162b:	83 c4 18             	add    $0x18,%esp
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 09                	push   $0x9
  80163f:	e8 00 ff ff ff       	call   801544 <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 0a                	push   $0xa
  801658:	e8 e7 fe ff ff       	call   801544 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 0b                	push   $0xb
  801671:	e8 ce fe ff ff       	call   801544 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	ff 75 08             	pushl  0x8(%ebp)
  80168a:	6a 0f                	push   $0xf
  80168c:	e8 b3 fe ff ff       	call   801544 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
	return;
  801694:	90                   	nop
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	ff 75 08             	pushl  0x8(%ebp)
  8016a6:	6a 10                	push   $0x10
  8016a8:	e8 97 fe ff ff       	call   801544 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b0:	90                   	nop
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	ff 75 10             	pushl  0x10(%ebp)
  8016bd:	ff 75 0c             	pushl  0xc(%ebp)
  8016c0:	ff 75 08             	pushl  0x8(%ebp)
  8016c3:	6a 11                	push   $0x11
  8016c5:	e8 7a fe ff ff       	call   801544 <syscall>
  8016ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8016cd:	90                   	nop
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 0c                	push   $0xc
  8016df:	e8 60 fe ff ff       	call   801544 <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	ff 75 08             	pushl  0x8(%ebp)
  8016f7:	6a 0d                	push   $0xd
  8016f9:	e8 46 fe ff ff       	call   801544 <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 0e                	push   $0xe
  801712:	e8 2d fe ff ff       	call   801544 <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	90                   	nop
  80171b:	c9                   	leave  
  80171c:	c3                   	ret    

0080171d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 13                	push   $0x13
  80172c:	e8 13 fe ff ff       	call   801544 <syscall>
  801731:	83 c4 18             	add    $0x18,%esp
}
  801734:	90                   	nop
  801735:	c9                   	leave  
  801736:	c3                   	ret    

00801737 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 14                	push   $0x14
  801746:	e8 f9 fd ff ff       	call   801544 <syscall>
  80174b:	83 c4 18             	add    $0x18,%esp
}
  80174e:	90                   	nop
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_cputc>:


void
sys_cputc(const char c)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80175d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	50                   	push   %eax
  80176a:	6a 15                	push   $0x15
  80176c:	e8 d3 fd ff ff       	call   801544 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 16                	push   $0x16
  801786:	e8 b9 fd ff ff       	call   801544 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	90                   	nop
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	50                   	push   %eax
  8017a1:	6a 17                	push   $0x17
  8017a3:	e8 9c fd ff ff       	call   801544 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	52                   	push   %edx
  8017bd:	50                   	push   %eax
  8017be:	6a 1a                	push   $0x1a
  8017c0:	e8 7f fd ff ff       	call   801544 <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	52                   	push   %edx
  8017da:	50                   	push   %eax
  8017db:	6a 18                	push   $0x18
  8017dd:	e8 62 fd ff ff       	call   801544 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	90                   	nop
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	52                   	push   %edx
  8017f8:	50                   	push   %eax
  8017f9:	6a 19                	push   $0x19
  8017fb:	e8 44 fd ff ff       	call   801544 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	90                   	nop
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801812:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801815:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	6a 00                	push   $0x0
  80181e:	51                   	push   %ecx
  80181f:	52                   	push   %edx
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	50                   	push   %eax
  801824:	6a 1b                	push   $0x1b
  801826:	e8 19 fd ff ff       	call   801544 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801833:	8b 55 0c             	mov    0xc(%ebp),%edx
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	52                   	push   %edx
  801840:	50                   	push   %eax
  801841:	6a 1c                	push   $0x1c
  801843:	e8 fc fc ff ff       	call   801544 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801850:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801853:	8b 55 0c             	mov    0xc(%ebp),%edx
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	51                   	push   %ecx
  80185e:	52                   	push   %edx
  80185f:	50                   	push   %eax
  801860:	6a 1d                	push   $0x1d
  801862:	e8 dd fc ff ff       	call   801544 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80186f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	6a 1e                	push   $0x1e
  80187f:	e8 c0 fc ff ff       	call   801544 <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 1f                	push   $0x1f
  801898:	e8 a7 fc ff ff       	call   801544 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	6a 00                	push   $0x0
  8018aa:	ff 75 14             	pushl  0x14(%ebp)
  8018ad:	ff 75 10             	pushl  0x10(%ebp)
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	50                   	push   %eax
  8018b4:	6a 20                	push   $0x20
  8018b6:	e8 89 fc ff ff       	call   801544 <syscall>
  8018bb:	83 c4 18             	add    $0x18,%esp
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	50                   	push   %eax
  8018cf:	6a 21                	push   $0x21
  8018d1:	e8 6e fc ff ff       	call   801544 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	90                   	nop
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	50                   	push   %eax
  8018eb:	6a 22                	push   $0x22
  8018ed:	e8 52 fc ff ff       	call   801544 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 02                	push   $0x2
  801906:	e8 39 fc ff ff       	call   801544 <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 03                	push   $0x3
  80191f:	e8 20 fc ff ff       	call   801544 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 04                	push   $0x4
  801938:	e8 07 fc ff ff       	call   801544 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_exit_env>:


void sys_exit_env(void)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 23                	push   $0x23
  801951:	e8 ee fb ff ff       	call   801544 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	90                   	nop
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801962:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801965:	8d 50 04             	lea    0x4(%eax),%edx
  801968:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	52                   	push   %edx
  801972:	50                   	push   %eax
  801973:	6a 24                	push   $0x24
  801975:	e8 ca fb ff ff       	call   801544 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
	return result;
  80197d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801980:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801983:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801986:	89 01                	mov    %eax,(%ecx)
  801988:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	c9                   	leave  
  80198f:	c2 04 00             	ret    $0x4

00801992 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	ff 75 10             	pushl  0x10(%ebp)
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	6a 12                	push   $0x12
  8019a4:	e8 9b fb ff ff       	call   801544 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ac:	90                   	nop
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_rcr2>:
uint32 sys_rcr2()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 25                	push   $0x25
  8019be:	e8 81 fb ff ff       	call   801544 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019d4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	50                   	push   %eax
  8019e1:	6a 26                	push   $0x26
  8019e3:	e8 5c fb ff ff       	call   801544 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019eb:	90                   	nop
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <rsttst>:
void rsttst()
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 28                	push   $0x28
  8019fd:	e8 42 fb ff ff       	call   801544 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return ;
  801a05:	90                   	nop
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a14:	8b 55 18             	mov    0x18(%ebp),%edx
  801a17:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a1b:	52                   	push   %edx
  801a1c:	50                   	push   %eax
  801a1d:	ff 75 10             	pushl  0x10(%ebp)
  801a20:	ff 75 0c             	pushl  0xc(%ebp)
  801a23:	ff 75 08             	pushl  0x8(%ebp)
  801a26:	6a 27                	push   $0x27
  801a28:	e8 17 fb ff ff       	call   801544 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a30:	90                   	nop
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <chktst>:
void chktst(uint32 n)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	ff 75 08             	pushl  0x8(%ebp)
  801a41:	6a 29                	push   $0x29
  801a43:	e8 fc fa ff ff       	call   801544 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4b:	90                   	nop
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <inctst>:

void inctst()
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 2a                	push   $0x2a
  801a5d:	e8 e2 fa ff ff       	call   801544 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
	return ;
  801a65:	90                   	nop
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <gettst>:
uint32 gettst()
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 2b                	push   $0x2b
  801a77:	e8 c8 fa ff ff       	call   801544 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 2c                	push   $0x2c
  801a93:	e8 ac fa ff ff       	call   801544 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
  801a9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a9e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801aa2:	75 07                	jne    801aab <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801aa4:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa9:	eb 05                	jmp    801ab0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801aab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 2c                	push   $0x2c
  801ac4:	e8 7b fa ff ff       	call   801544 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
  801acc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801acf:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ad3:	75 07                	jne    801adc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ad5:	b8 01 00 00 00       	mov    $0x1,%eax
  801ada:	eb 05                	jmp    801ae1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801adc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 2c                	push   $0x2c
  801af5:	e8 4a fa ff ff       	call   801544 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
  801afd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b00:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b04:	75 07                	jne    801b0d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b06:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0b:	eb 05                	jmp    801b12 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 2c                	push   $0x2c
  801b26:	e8 19 fa ff ff       	call   801544 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
  801b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b31:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b35:	75 07                	jne    801b3e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b37:	b8 01 00 00 00       	mov    $0x1,%eax
  801b3c:	eb 05                	jmp    801b43 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	ff 75 08             	pushl  0x8(%ebp)
  801b53:	6a 2d                	push   $0x2d
  801b55:	e8 ea f9 ff ff       	call   801544 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5d:	90                   	nop
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b64:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b67:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	6a 00                	push   $0x0
  801b72:	53                   	push   %ebx
  801b73:	51                   	push   %ecx
  801b74:	52                   	push   %edx
  801b75:	50                   	push   %eax
  801b76:	6a 2e                	push   $0x2e
  801b78:	e8 c7 f9 ff ff       	call   801544 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	6a 2f                	push   $0x2f
  801b98:	e8 a7 f9 ff ff       	call   801544 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801bae:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801bb2:	83 ec 0c             	sub    $0xc,%esp
  801bb5:	50                   	push   %eax
  801bb6:	e8 96 fb ff ff       	call   801751 <sys_cputc>
  801bbb:	83 c4 10             	add    $0x10,%esp
}
  801bbe:	90                   	nop
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801bc7:	e8 51 fb ff ff       	call   80171d <sys_disable_interrupt>
	char c = ch;
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801bd2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801bd6:	83 ec 0c             	sub    $0xc,%esp
  801bd9:	50                   	push   %eax
  801bda:	e8 72 fb ff ff       	call   801751 <sys_cputc>
  801bdf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  801be2:	e8 50 fb ff ff       	call   801737 <sys_enable_interrupt>
}
  801be7:	90                   	nop
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <getchar>:

int
getchar(void)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  801bf0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801bf7:	eb 08                	jmp    801c01 <getchar+0x17>
	{
		c = sys_cgetc();
  801bf9:	e8 9a f9 ff ff       	call   801598 <sys_cgetc>
  801bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  801c01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c05:	74 f2                	je     801bf9 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  801c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <atomic_getchar>:

int
atomic_getchar(void)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801c12:	e8 06 fb ff ff       	call   80171d <sys_disable_interrupt>
	int c=0;
  801c17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  801c1e:	eb 08                	jmp    801c28 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  801c20:	e8 73 f9 ff ff       	call   801598 <sys_cgetc>
  801c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  801c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c2c:	74 f2                	je     801c20 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  801c2e:	e8 04 fb ff ff       	call   801737 <sys_enable_interrupt>
	return c;
  801c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801c36:	c9                   	leave  
  801c37:	c3                   	ret    

00801c38 <iscons>:

int iscons(int fdnum)
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801c3b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c40:	5d                   	pop    %ebp
  801c41:	c3                   	ret    
  801c42:	66 90                	xchg   %ax,%ax

00801c44 <__udivdi3>:
  801c44:	55                   	push   %ebp
  801c45:	57                   	push   %edi
  801c46:	56                   	push   %esi
  801c47:	53                   	push   %ebx
  801c48:	83 ec 1c             	sub    $0x1c,%esp
  801c4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c57:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c5b:	89 ca                	mov    %ecx,%edx
  801c5d:	89 f8                	mov    %edi,%eax
  801c5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c63:	85 f6                	test   %esi,%esi
  801c65:	75 2d                	jne    801c94 <__udivdi3+0x50>
  801c67:	39 cf                	cmp    %ecx,%edi
  801c69:	77 65                	ja     801cd0 <__udivdi3+0x8c>
  801c6b:	89 fd                	mov    %edi,%ebp
  801c6d:	85 ff                	test   %edi,%edi
  801c6f:	75 0b                	jne    801c7c <__udivdi3+0x38>
  801c71:	b8 01 00 00 00       	mov    $0x1,%eax
  801c76:	31 d2                	xor    %edx,%edx
  801c78:	f7 f7                	div    %edi
  801c7a:	89 c5                	mov    %eax,%ebp
  801c7c:	31 d2                	xor    %edx,%edx
  801c7e:	89 c8                	mov    %ecx,%eax
  801c80:	f7 f5                	div    %ebp
  801c82:	89 c1                	mov    %eax,%ecx
  801c84:	89 d8                	mov    %ebx,%eax
  801c86:	f7 f5                	div    %ebp
  801c88:	89 cf                	mov    %ecx,%edi
  801c8a:	89 fa                	mov    %edi,%edx
  801c8c:	83 c4 1c             	add    $0x1c,%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5e                   	pop    %esi
  801c91:	5f                   	pop    %edi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    
  801c94:	39 ce                	cmp    %ecx,%esi
  801c96:	77 28                	ja     801cc0 <__udivdi3+0x7c>
  801c98:	0f bd fe             	bsr    %esi,%edi
  801c9b:	83 f7 1f             	xor    $0x1f,%edi
  801c9e:	75 40                	jne    801ce0 <__udivdi3+0x9c>
  801ca0:	39 ce                	cmp    %ecx,%esi
  801ca2:	72 0a                	jb     801cae <__udivdi3+0x6a>
  801ca4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ca8:	0f 87 9e 00 00 00    	ja     801d4c <__udivdi3+0x108>
  801cae:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb3:	89 fa                	mov    %edi,%edx
  801cb5:	83 c4 1c             	add    $0x1c,%esp
  801cb8:	5b                   	pop    %ebx
  801cb9:	5e                   	pop    %esi
  801cba:	5f                   	pop    %edi
  801cbb:	5d                   	pop    %ebp
  801cbc:	c3                   	ret    
  801cbd:	8d 76 00             	lea    0x0(%esi),%esi
  801cc0:	31 ff                	xor    %edi,%edi
  801cc2:	31 c0                	xor    %eax,%eax
  801cc4:	89 fa                	mov    %edi,%edx
  801cc6:	83 c4 1c             	add    $0x1c,%esp
  801cc9:	5b                   	pop    %ebx
  801cca:	5e                   	pop    %esi
  801ccb:	5f                   	pop    %edi
  801ccc:	5d                   	pop    %ebp
  801ccd:	c3                   	ret    
  801cce:	66 90                	xchg   %ax,%ax
  801cd0:	89 d8                	mov    %ebx,%eax
  801cd2:	f7 f7                	div    %edi
  801cd4:	31 ff                	xor    %edi,%edi
  801cd6:	89 fa                	mov    %edi,%edx
  801cd8:	83 c4 1c             	add    $0x1c,%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5f                   	pop    %edi
  801cde:	5d                   	pop    %ebp
  801cdf:	c3                   	ret    
  801ce0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ce5:	89 eb                	mov    %ebp,%ebx
  801ce7:	29 fb                	sub    %edi,%ebx
  801ce9:	89 f9                	mov    %edi,%ecx
  801ceb:	d3 e6                	shl    %cl,%esi
  801ced:	89 c5                	mov    %eax,%ebp
  801cef:	88 d9                	mov    %bl,%cl
  801cf1:	d3 ed                	shr    %cl,%ebp
  801cf3:	89 e9                	mov    %ebp,%ecx
  801cf5:	09 f1                	or     %esi,%ecx
  801cf7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cfb:	89 f9                	mov    %edi,%ecx
  801cfd:	d3 e0                	shl    %cl,%eax
  801cff:	89 c5                	mov    %eax,%ebp
  801d01:	89 d6                	mov    %edx,%esi
  801d03:	88 d9                	mov    %bl,%cl
  801d05:	d3 ee                	shr    %cl,%esi
  801d07:	89 f9                	mov    %edi,%ecx
  801d09:	d3 e2                	shl    %cl,%edx
  801d0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0f:	88 d9                	mov    %bl,%cl
  801d11:	d3 e8                	shr    %cl,%eax
  801d13:	09 c2                	or     %eax,%edx
  801d15:	89 d0                	mov    %edx,%eax
  801d17:	89 f2                	mov    %esi,%edx
  801d19:	f7 74 24 0c          	divl   0xc(%esp)
  801d1d:	89 d6                	mov    %edx,%esi
  801d1f:	89 c3                	mov    %eax,%ebx
  801d21:	f7 e5                	mul    %ebp
  801d23:	39 d6                	cmp    %edx,%esi
  801d25:	72 19                	jb     801d40 <__udivdi3+0xfc>
  801d27:	74 0b                	je     801d34 <__udivdi3+0xf0>
  801d29:	89 d8                	mov    %ebx,%eax
  801d2b:	31 ff                	xor    %edi,%edi
  801d2d:	e9 58 ff ff ff       	jmp    801c8a <__udivdi3+0x46>
  801d32:	66 90                	xchg   %ax,%ax
  801d34:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d38:	89 f9                	mov    %edi,%ecx
  801d3a:	d3 e2                	shl    %cl,%edx
  801d3c:	39 c2                	cmp    %eax,%edx
  801d3e:	73 e9                	jae    801d29 <__udivdi3+0xe5>
  801d40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d43:	31 ff                	xor    %edi,%edi
  801d45:	e9 40 ff ff ff       	jmp    801c8a <__udivdi3+0x46>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	31 c0                	xor    %eax,%eax
  801d4e:	e9 37 ff ff ff       	jmp    801c8a <__udivdi3+0x46>
  801d53:	90                   	nop

00801d54 <__umoddi3>:
  801d54:	55                   	push   %ebp
  801d55:	57                   	push   %edi
  801d56:	56                   	push   %esi
  801d57:	53                   	push   %ebx
  801d58:	83 ec 1c             	sub    $0x1c,%esp
  801d5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d73:	89 f3                	mov    %esi,%ebx
  801d75:	89 fa                	mov    %edi,%edx
  801d77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d7b:	89 34 24             	mov    %esi,(%esp)
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	75 1a                	jne    801d9c <__umoddi3+0x48>
  801d82:	39 f7                	cmp    %esi,%edi
  801d84:	0f 86 a2 00 00 00    	jbe    801e2c <__umoddi3+0xd8>
  801d8a:	89 c8                	mov    %ecx,%eax
  801d8c:	89 f2                	mov    %esi,%edx
  801d8e:	f7 f7                	div    %edi
  801d90:	89 d0                	mov    %edx,%eax
  801d92:	31 d2                	xor    %edx,%edx
  801d94:	83 c4 1c             	add    $0x1c,%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    
  801d9c:	39 f0                	cmp    %esi,%eax
  801d9e:	0f 87 ac 00 00 00    	ja     801e50 <__umoddi3+0xfc>
  801da4:	0f bd e8             	bsr    %eax,%ebp
  801da7:	83 f5 1f             	xor    $0x1f,%ebp
  801daa:	0f 84 ac 00 00 00    	je     801e5c <__umoddi3+0x108>
  801db0:	bf 20 00 00 00       	mov    $0x20,%edi
  801db5:	29 ef                	sub    %ebp,%edi
  801db7:	89 fe                	mov    %edi,%esi
  801db9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801dbd:	89 e9                	mov    %ebp,%ecx
  801dbf:	d3 e0                	shl    %cl,%eax
  801dc1:	89 d7                	mov    %edx,%edi
  801dc3:	89 f1                	mov    %esi,%ecx
  801dc5:	d3 ef                	shr    %cl,%edi
  801dc7:	09 c7                	or     %eax,%edi
  801dc9:	89 e9                	mov    %ebp,%ecx
  801dcb:	d3 e2                	shl    %cl,%edx
  801dcd:	89 14 24             	mov    %edx,(%esp)
  801dd0:	89 d8                	mov    %ebx,%eax
  801dd2:	d3 e0                	shl    %cl,%eax
  801dd4:	89 c2                	mov    %eax,%edx
  801dd6:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dda:	d3 e0                	shl    %cl,%eax
  801ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801de4:	89 f1                	mov    %esi,%ecx
  801de6:	d3 e8                	shr    %cl,%eax
  801de8:	09 d0                	or     %edx,%eax
  801dea:	d3 eb                	shr    %cl,%ebx
  801dec:	89 da                	mov    %ebx,%edx
  801dee:	f7 f7                	div    %edi
  801df0:	89 d3                	mov    %edx,%ebx
  801df2:	f7 24 24             	mull   (%esp)
  801df5:	89 c6                	mov    %eax,%esi
  801df7:	89 d1                	mov    %edx,%ecx
  801df9:	39 d3                	cmp    %edx,%ebx
  801dfb:	0f 82 87 00 00 00    	jb     801e88 <__umoddi3+0x134>
  801e01:	0f 84 91 00 00 00    	je     801e98 <__umoddi3+0x144>
  801e07:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e0b:	29 f2                	sub    %esi,%edx
  801e0d:	19 cb                	sbb    %ecx,%ebx
  801e0f:	89 d8                	mov    %ebx,%eax
  801e11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801e15:	d3 e0                	shl    %cl,%eax
  801e17:	89 e9                	mov    %ebp,%ecx
  801e19:	d3 ea                	shr    %cl,%edx
  801e1b:	09 d0                	or     %edx,%eax
  801e1d:	89 e9                	mov    %ebp,%ecx
  801e1f:	d3 eb                	shr    %cl,%ebx
  801e21:	89 da                	mov    %ebx,%edx
  801e23:	83 c4 1c             	add    $0x1c,%esp
  801e26:	5b                   	pop    %ebx
  801e27:	5e                   	pop    %esi
  801e28:	5f                   	pop    %edi
  801e29:	5d                   	pop    %ebp
  801e2a:	c3                   	ret    
  801e2b:	90                   	nop
  801e2c:	89 fd                	mov    %edi,%ebp
  801e2e:	85 ff                	test   %edi,%edi
  801e30:	75 0b                	jne    801e3d <__umoddi3+0xe9>
  801e32:	b8 01 00 00 00       	mov    $0x1,%eax
  801e37:	31 d2                	xor    %edx,%edx
  801e39:	f7 f7                	div    %edi
  801e3b:	89 c5                	mov    %eax,%ebp
  801e3d:	89 f0                	mov    %esi,%eax
  801e3f:	31 d2                	xor    %edx,%edx
  801e41:	f7 f5                	div    %ebp
  801e43:	89 c8                	mov    %ecx,%eax
  801e45:	f7 f5                	div    %ebp
  801e47:	89 d0                	mov    %edx,%eax
  801e49:	e9 44 ff ff ff       	jmp    801d92 <__umoddi3+0x3e>
  801e4e:	66 90                	xchg   %ax,%ax
  801e50:	89 c8                	mov    %ecx,%eax
  801e52:	89 f2                	mov    %esi,%edx
  801e54:	83 c4 1c             	add    $0x1c,%esp
  801e57:	5b                   	pop    %ebx
  801e58:	5e                   	pop    %esi
  801e59:	5f                   	pop    %edi
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    
  801e5c:	3b 04 24             	cmp    (%esp),%eax
  801e5f:	72 06                	jb     801e67 <__umoddi3+0x113>
  801e61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e65:	77 0f                	ja     801e76 <__umoddi3+0x122>
  801e67:	89 f2                	mov    %esi,%edx
  801e69:	29 f9                	sub    %edi,%ecx
  801e6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e6f:	89 14 24             	mov    %edx,(%esp)
  801e72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e76:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e7a:	8b 14 24             	mov    (%esp),%edx
  801e7d:	83 c4 1c             	add    $0x1c,%esp
  801e80:	5b                   	pop    %ebx
  801e81:	5e                   	pop    %esi
  801e82:	5f                   	pop    %edi
  801e83:	5d                   	pop    %ebp
  801e84:	c3                   	ret    
  801e85:	8d 76 00             	lea    0x0(%esi),%esi
  801e88:	2b 04 24             	sub    (%esp),%eax
  801e8b:	19 fa                	sbb    %edi,%edx
  801e8d:	89 d1                	mov    %edx,%ecx
  801e8f:	89 c6                	mov    %eax,%esi
  801e91:	e9 71 ff ff ff       	jmp    801e07 <__umoddi3+0xb3>
  801e96:	66 90                	xchg   %ax,%ax
  801e98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e9c:	72 ea                	jb     801e88 <__umoddi3+0x134>
  801e9e:	89 d9                	mov    %ebx,%ecx
  801ea0:	e9 62 ff ff ff       	jmp    801e07 <__umoddi3+0xb3>
