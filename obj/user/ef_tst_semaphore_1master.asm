
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 f8 01 00 00       	call   80022e <libmain>
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
  80003e:	e8 5a 1c 00 00       	call   801c9d <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 00 33 80 00       	push   $0x803300
  800050:	e8 e2 1a 00 00       	call   801b37 <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 04 33 80 00       	push   $0x803304
  800062:	e8 d0 1a 00 00       	call   801b37 <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80006a:	a1 20 40 80 00       	mov    0x804020,%eax
  80006f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	a1 20 40 80 00       	mov    0x804020,%eax
  80007c:	8b 40 74             	mov    0x74(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 0c 33 80 00       	push   $0x80330c
  800088:	e8 bb 1b 00 00       	call   801c48 <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 40 80 00       	mov    0x804020,%eax
  800098:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a5:	8b 40 74             	mov    0x74(%eax),%eax
  8000a8:	6a 32                	push   $0x32
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	68 0c 33 80 00       	push   $0x80330c
  8000b1:	e8 92 1b 00 00       	call   801c48 <sys_create_env>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c1:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ce:	8b 40 74             	mov    0x74(%eax),%eax
  8000d1:	6a 32                	push   $0x32
  8000d3:	52                   	push   %edx
  8000d4:	50                   	push   %eax
  8000d5:	68 0c 33 80 00       	push   $0x80330c
  8000da:	e8 69 1b 00 00       	call   801c48 <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000e5:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000e9:	74 0c                	je     8000f7 <_main+0xbf>
  8000eb:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  8000ef:	74 06                	je     8000f7 <_main+0xbf>
  8000f1:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  8000f5:	75 14                	jne    80010b <_main+0xd3>
		panic("NO AVAILABLE ENVs...");
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 19 33 80 00       	push   $0x803319
  8000ff:	6a 13                	push   $0x13
  800101:	68 30 33 80 00       	push   $0x803330
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 50 1b 00 00       	call   801c66 <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 42 1b 00 00       	call   801c66 <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 34 1b 00 00       	call   801c66 <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 04 33 80 00       	push   $0x803304
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 2b 1a 00 00       	call   801b70 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 04 33 80 00       	push   $0x803304
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 18 1a 00 00       	call   801b70 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 04 33 80 00       	push   $0x803304
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 05 1a 00 00       	call   801b70 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 00 33 80 00       	push   $0x803300
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 d5 19 00 00       	call   801b53 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 04 33 80 00       	push   $0x803304
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 bf 19 00 00       	call   801b53 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 50 33 80 00       	push   $0x803350
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 98 33 80 00       	push   $0x803398
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 02 1b 00 00       	call   801ccf <sys_getparentenvid>
  8001cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d4:	7e 55                	jle    80022b <_main+0x1f3>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  8001d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	68 e3 33 80 00       	push   $0x8033e3
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 c4 15 00 00       	call   8017b1 <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 84 1a 00 00       	call   801c82 <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 76 1a 00 00       	call   801c82 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 68 1a 00 00       	call   801c82 <sys_destroy_env>
  80021a:	83 c4 10             	add    $0x10,%esp
		(*finishedCount)++ ;
  80021d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 50 01             	lea    0x1(%eax),%edx
  800225:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800228:	89 10                	mov    %edx,(%eax)
	}

	return;
  80022a:	90                   	nop
  80022b:	90                   	nop
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800234:	e8 7d 1a 00 00       	call   801cb6 <sys_getenvindex>
  800239:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80023c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023f:	89 d0                	mov    %edx,%eax
  800241:	c1 e0 03             	shl    $0x3,%eax
  800244:	01 d0                	add    %edx,%eax
  800246:	01 c0                	add    %eax,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800251:	01 d0                	add    %edx,%eax
  800253:	c1 e0 04             	shl    $0x4,%eax
  800256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025b:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80026b:	84 c0                	test   %al,%al
  80026d:	74 0f                	je     80027e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80026f:	a1 20 40 80 00       	mov    0x804020,%eax
  800274:	05 5c 05 00 00       	add    $0x55c,%eax
  800279:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800282:	7e 0a                	jle    80028e <libmain+0x60>
		binaryname = argv[0];
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	e8 9c fd ff ff       	call   800038 <_main>
  80029c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80029f:	e8 1f 18 00 00       	call   801ac3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 0c 34 80 00       	push   $0x80340c
  8002ac:	e8 6d 03 00 00       	call   80061e <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	68 34 34 80 00       	push   $0x803434
  8002d4:	e8 45 03 00 00       	call   80061e <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 5c 34 80 00       	push   $0x80345c
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 b4 34 80 00       	push   $0x8034b4
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 0c 34 80 00       	push   $0x80340c
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 9f 17 00 00       	call   801add <sys_enable_interrupt>

	// exit gracefully
	exit();
  80033e:	e8 19 00 00 00       	call   80035c <exit>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	6a 00                	push   $0x0
  800351:	e8 2c 19 00 00       	call   801c82 <sys_destroy_env>
  800356:	83 c4 10             	add    $0x10,%esp
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <exit>:

void
exit(void)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800362:	e8 81 19 00 00       	call   801ce8 <sys_exit_env>
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800370:	8d 45 10             	lea    0x10(%ebp),%eax
  800373:	83 c0 04             	add    $0x4,%eax
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800379:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	74 16                	je     800398 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800382:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	50                   	push   %eax
  80038b:	68 c8 34 80 00       	push   $0x8034c8
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 40 80 00       	mov    0x804000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 cd 34 80 00       	push   $0x8034cd
  8003a9:	e8 70 02 00 00       	call   80061e <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	e8 f3 01 00 00       	call   8005b3 <vcprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	6a 00                	push   $0x0
  8003c8:	68 e9 34 80 00       	push   $0x8034e9
  8003cd:	e8 e1 01 00 00       	call   8005b3 <vcprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003d5:	e8 82 ff ff ff       	call   80035c <exit>

	// should not return here
	while (1) ;
  8003da:	eb fe                	jmp    8003da <_panic+0x70>

008003dc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	74 14                	je     800405 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 ec 34 80 00       	push   $0x8034ec
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 38 35 80 00       	push   $0x803538
  800400:	e8 65 ff ff ff       	call   80036a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80040c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800413:	e9 c2 00 00 00       	jmp    8004da <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	75 08                	jne    800435 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80042d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800430:	e9 a2 00 00 00       	jmp    8004d7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800435:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800443:	eb 69                	jmp    8004ae <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800445:	a1 20 40 80 00       	mov    0x804020,%eax
  80044a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800450:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800453:	89 d0                	mov    %edx,%eax
  800455:	01 c0                	add    %eax,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	c1 e0 03             	shl    $0x3,%eax
  80045c:	01 c8                	add    %ecx,%eax
  80045e:	8a 40 04             	mov    0x4(%eax),%al
  800461:	84 c0                	test   %al,%al
  800463:	75 46                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800465:	a1 20 40 80 00       	mov    0x804020,%eax
  80046a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800470:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800473:	89 d0                	mov    %edx,%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	01 d0                	add    %edx,%eax
  800479:	c1 e0 03             	shl    $0x3,%eax
  80047c:	01 c8                	add    %ecx,%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800486:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80048b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800490:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c8                	add    %ecx,%eax
  80049c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	75 09                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004a9:	eb 12                	jmp    8004bd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	ff 45 e8             	incl   -0x18(%ebp)
  8004ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b3:	8b 50 74             	mov    0x74(%eax),%edx
  8004b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b9:	39 c2                	cmp    %eax,%edx
  8004bb:	77 88                	ja     800445 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004c1:	75 14                	jne    8004d7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	68 44 35 80 00       	push   $0x803544
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 38 35 80 00       	push   $0x803538
  8004d2:	e8 93 fe ff ff       	call   80036a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d7:	ff 45 f0             	incl   -0x10(%ebp)
  8004da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e0:	0f 8c 32 ff ff ff    	jl     800418 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f4:	eb 26                	jmp    80051c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800501:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	01 c0                	add    %eax,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	c1 e0 03             	shl    $0x3,%eax
  80050d:	01 c8                	add    %ecx,%eax
  80050f:	8a 40 04             	mov    0x4(%eax),%al
  800512:	3c 01                	cmp    $0x1,%al
  800514:	75 03                	jne    800519 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800516:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800519:	ff 45 e0             	incl   -0x20(%ebp)
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 50 74             	mov    0x74(%eax),%edx
  800524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	77 cb                	ja     8004f6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80052b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800531:	74 14                	je     800547 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	68 98 35 80 00       	push   $0x803598
  80053b:	6a 44                	push   $0x44
  80053d:	68 38 35 80 00       	push   $0x803538
  800542:	e8 23 fe ff ff       	call   80036a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 48 01             	lea    0x1(%eax),%ecx
  800558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055b:	89 0a                	mov    %ecx,(%edx)
  80055d:	8b 55 08             	mov    0x8(%ebp),%edx
  800560:	88 d1                	mov    %dl,%cl
  800562:	8b 55 0c             	mov    0xc(%ebp),%edx
  800565:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800573:	75 2c                	jne    8005a1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800575:	a0 24 40 80 00       	mov    0x804024,%al
  80057a:	0f b6 c0             	movzbl %al,%eax
  80057d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800580:	8b 12                	mov    (%edx),%edx
  800582:	89 d1                	mov    %edx,%ecx
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	83 c2 08             	add    $0x8,%edx
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	50                   	push   %eax
  80058e:	51                   	push   %ecx
  80058f:	52                   	push   %edx
  800590:	e8 80 13 00 00       	call   801915 <sys_cputs>
  800595:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 40 04             	mov    0x4(%eax),%eax
  8005a7:	8d 50 01             	lea    0x1(%eax),%edx
  8005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ad:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b0:	90                   	nop
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c3:	00 00 00 
	b.cnt = 0;
  8005c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005cd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005dc:	50                   	push   %eax
  8005dd:	68 4a 05 80 00       	push   $0x80054a
  8005e2:	e8 11 02 00 00       	call   8007f8 <vprintfmt>
  8005e7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ea:	a0 24 40 80 00       	mov    0x804024,%al
  8005ef:	0f b6 c0             	movzbl %al,%eax
  8005f2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	50                   	push   %eax
  8005fc:	52                   	push   %edx
  8005fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800603:	83 c0 08             	add    $0x8,%eax
  800606:	50                   	push   %eax
  800607:	e8 09 13 00 00       	call   801915 <sys_cputs>
  80060c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80060f:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800616:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <cprintf>:

int cprintf(const char *fmt, ...) {
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800624:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 f4             	pushl  -0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	e8 73 ff ff ff       	call   8005b3 <vcprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800651:	e8 6d 14 00 00       	call   801ac3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800656:	8d 45 0c             	lea    0xc(%ebp),%eax
  800659:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 f4             	pushl  -0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	e8 48 ff ff ff       	call   8005b3 <vcprintf>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800671:	e8 67 14 00 00       	call   801add <sys_enable_interrupt>
	return cnt;
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
  80067e:	53                   	push   %ebx
  80067f:	83 ec 14             	sub    $0x14,%esp
  800682:	8b 45 10             	mov    0x10(%ebp),%eax
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068e:	8b 45 18             	mov    0x18(%ebp),%eax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800699:	77 55                	ja     8006f0 <printnum+0x75>
  80069b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069e:	72 05                	jb     8006a5 <printnum+0x2a>
  8006a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a3:	77 4b                	ja     8006f0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bb:	e8 d0 29 00 00       	call   803090 <__udivdi3>
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	ff 75 20             	pushl  0x20(%ebp)
  8006c9:	53                   	push   %ebx
  8006ca:	ff 75 18             	pushl  0x18(%ebp)
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 a1 ff ff ff       	call   80067b <printnum>
  8006da:	83 c4 20             	add    $0x20,%esp
  8006dd:	eb 1a                	jmp    8006f9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	ff 75 20             	pushl  0x20(%ebp)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f0:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f7:	7f e6                	jg     8006df <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800707:	53                   	push   %ebx
  800708:	51                   	push   %ecx
  800709:	52                   	push   %edx
  80070a:	50                   	push   %eax
  80070b:	e8 90 2a 00 00       	call   8031a0 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 14 38 80 00       	add    $0x803814,%eax
  800718:	8a 00                	mov    (%eax),%al
  80071a:	0f be c0             	movsbl %al,%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	50                   	push   %eax
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
}
  80072c:	90                   	nop
  80072d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800735:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800739:	7e 1c                	jle    800757 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 50 08             	lea    0x8(%eax),%edx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 10                	mov    %edx,(%eax)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 e8 08             	sub    $0x8,%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	eb 40                	jmp    800797 <getuint+0x65>
	else if (lflag)
  800757:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075b:	74 1e                	je     80077b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	ba 00 00 00 00       	mov    $0x0,%edx
  800779:	eb 1c                	jmp    800797 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a0:	7e 1c                	jle    8007be <getint+0x25>
		return va_arg(*ap, long long);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	8d 50 08             	lea    0x8(%eax),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 10                	mov    %edx,(%eax)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	83 e8 08             	sub    $0x8,%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	eb 38                	jmp    8007f6 <getint+0x5d>
	else if (lflag)
  8007be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c2:	74 1a                	je     8007de <getint+0x45>
		return va_arg(*ap, long);
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	8d 50 04             	lea    0x4(%eax),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	89 10                	mov    %edx,(%eax)
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	99                   	cltd   
  8007dc:	eb 18                	jmp    8007f6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	89 10                	mov    %edx,(%eax)
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	99                   	cltd   
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	eb 17                	jmp    800819 <vprintfmt+0x21>
			if (ch == '\0')
  800802:	85 db                	test   %ebx,%ebx
  800804:	0f 84 af 03 00 00    	je     800bb9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	53                   	push   %ebx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800819:	8b 45 10             	mov    0x10(%ebp),%eax
  80081c:	8d 50 01             	lea    0x1(%eax),%edx
  80081f:	89 55 10             	mov    %edx,0x10(%ebp)
  800822:	8a 00                	mov    (%eax),%al
  800824:	0f b6 d8             	movzbl %al,%ebx
  800827:	83 fb 25             	cmp    $0x25,%ebx
  80082a:	75 d6                	jne    800802 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80082c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800830:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800837:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800845:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085d:	83 f8 55             	cmp    $0x55,%eax
  800860:	0f 87 2b 03 00 00    	ja     800b91 <vprintfmt+0x399>
  800866:	8b 04 85 38 38 80 00 	mov    0x803838(,%eax,4),%eax
  80086d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800873:	eb d7                	jmp    80084c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800875:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800879:	eb d1                	jmp    80084c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800882:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800885:	89 d0                	mov    %edx,%eax
  800887:	c1 e0 02             	shl    $0x2,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	01 c0                	add    %eax,%eax
  80088e:	01 d8                	add    %ebx,%eax
  800890:	83 e8 30             	sub    $0x30,%eax
  800893:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800896:	8b 45 10             	mov    0x10(%ebp),%eax
  800899:	8a 00                	mov    (%eax),%al
  80089b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089e:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a1:	7e 3e                	jle    8008e1 <vprintfmt+0xe9>
  8008a3:	83 fb 39             	cmp    $0x39,%ebx
  8008a6:	7f 39                	jg     8008e1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ab:	eb d5                	jmp    800882 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 e8 04             	sub    $0x4,%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c1:	eb 1f                	jmp    8008e2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	79 83                	jns    80084c <vprintfmt+0x54>
				width = 0;
  8008c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d0:	e9 77 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008dc:	e9 6b ff ff ff       	jmp    80084c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	0f 89 60 ff ff ff    	jns    80084c <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f9:	e9 4e ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800901:	e9 46 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			break;
  800926:	e9 89 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	83 c0 04             	add    $0x4,%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 e8 04             	sub    $0x4,%eax
  80093a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	79 02                	jns    800942 <vprintfmt+0x14a>
				err = -err;
  800940:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800942:	83 fb 64             	cmp    $0x64,%ebx
  800945:	7f 0b                	jg     800952 <vprintfmt+0x15a>
  800947:	8b 34 9d 80 36 80 00 	mov    0x803680(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 25 38 80 00       	push   $0x803825
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 5e 02 00 00       	call   800bc1 <printfmt>
  800963:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800966:	e9 49 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096b:	56                   	push   %esi
  80096c:	68 2e 38 80 00       	push   $0x80382e
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	e8 45 02 00 00       	call   800bc1 <printfmt>
  80097c:	83 c4 10             	add    $0x10,%esp
			break;
  80097f:	e9 30 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 30                	mov    (%eax),%esi
  800995:	85 f6                	test   %esi,%esi
  800997:	75 05                	jne    80099e <vprintfmt+0x1a6>
				p = "(null)";
  800999:	be 31 38 80 00       	mov    $0x803831,%esi
			if (width > 0 && padc != '-')
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7e 6d                	jle    800a11 <vprintfmt+0x219>
  8009a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a8:	74 67                	je     800a11 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	50                   	push   %eax
  8009b1:	56                   	push   %esi
  8009b2:	e8 0c 03 00 00       	call   800cc3 <strnlen>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009bd:	eb 16                	jmp    8009d5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	50                   	push   %eax
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d9:	7f e4                	jg     8009bf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009db:	eb 34                	jmp    800a11 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e1:	74 1c                	je     8009ff <vprintfmt+0x207>
  8009e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e6:	7e 05                	jle    8009ed <vprintfmt+0x1f5>
  8009e8:	83 fb 7e             	cmp    $0x7e,%ebx
  8009eb:	7e 12                	jle    8009ff <vprintfmt+0x207>
					putch('?', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	6a 3f                	push   $0x3f
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	eb 0f                	jmp    800a0e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a11:	89 f0                	mov    %esi,%eax
  800a13:	8d 70 01             	lea    0x1(%eax),%esi
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	0f be d8             	movsbl %al,%ebx
  800a1b:	85 db                	test   %ebx,%ebx
  800a1d:	74 24                	je     800a43 <vprintfmt+0x24b>
  800a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a23:	78 b8                	js     8009dd <vprintfmt+0x1e5>
  800a25:	ff 4d e0             	decl   -0x20(%ebp)
  800a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2c:	79 af                	jns    8009dd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2e:	eb 13                	jmp    800a43 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	6a 20                	push   $0x20
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	ff d0                	call   *%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a40:	ff 4d e4             	decl   -0x1c(%ebp)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a47:	7f e7                	jg     800a30 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a49:	e9 66 01 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 e8             	pushl  -0x18(%ebp)
  800a54:	8d 45 14             	lea    0x14(%ebp),%eax
  800a57:	50                   	push   %eax
  800a58:	e8 3c fd ff ff       	call   800799 <getint>
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	85 d2                	test   %edx,%edx
  800a6e:	79 23                	jns    800a93 <vprintfmt+0x29b>
				putch('-', putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	6a 2d                	push   $0x2d
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a86:	f7 d8                	neg    %eax
  800a88:	83 d2 00             	adc    $0x0,%edx
  800a8b:	f7 da                	neg    %edx
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9a:	e9 bc 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	e8 84 fc ff ff       	call   800732 <getuint>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abe:	e9 98 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 58                	push   $0x58
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 58                	push   $0x58
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 58                	push   $0x58
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	e9 bc 00 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 30                	push   $0x30
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	6a 78                	push   $0x78
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	ff d0                	call   *%eax
  800b15:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b33:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3a:	eb 1f                	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b42:	8d 45 14             	lea    0x14(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 e7 fb ff ff       	call   800732 <getuint>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b62:	83 ec 04             	sub    $0x4,%esp
  800b65:	52                   	push   %edx
  800b66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b69:	50                   	push   %eax
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 00 fb ff ff       	call   80067b <printnum>
  800b7b:	83 c4 20             	add    $0x20,%esp
			break;
  800b7e:	eb 34                	jmp    800bb4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	53                   	push   %ebx
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			break;
  800b8f:	eb 23                	jmp    800bb4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 25                	push   $0x25
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba1:	ff 4d 10             	decl   0x10(%ebp)
  800ba4:	eb 03                	jmp    800ba9 <vprintfmt+0x3b1>
  800ba6:	ff 4d 10             	decl   0x10(%ebp)
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	48                   	dec    %eax
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	3c 25                	cmp    $0x25,%al
  800bb1:	75 f3                	jne    800ba6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb3:	90                   	nop
		}
	}
  800bb4:	e9 47 fc ff ff       	jmp    800800 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bca:	83 c0 04             	add    $0x4,%eax
  800bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	ff 75 08             	pushl  0x8(%ebp)
  800bdd:	e8 16 fc ff ff       	call   8007f8 <vprintfmt>
  800be2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be5:	90                   	nop
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	8b 40 08             	mov    0x8(%eax),%eax
  800bf1:	8d 50 01             	lea    0x1(%eax),%edx
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 10                	mov    (%eax),%edx
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 04             	mov    0x4(%eax),%eax
  800c05:	39 c2                	cmp    %eax,%edx
  800c07:	73 12                	jae    800c1b <sprintputch+0x33>
		*b->buf++ = ch;
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	89 0a                	mov    %ecx,(%edx)
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	88 10                	mov    %dl,(%eax)
}
  800c1b:	90                   	nop
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	01 d0                	add    %edx,%eax
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c43:	74 06                	je     800c4b <vsnprintf+0x2d>
  800c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c49:	7f 07                	jg     800c52 <vsnprintf+0x34>
		return -E_INVAL;
  800c4b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c50:	eb 20                	jmp    800c72 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c52:	ff 75 14             	pushl  0x14(%ebp)
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5b:	50                   	push   %eax
  800c5c:	68 e8 0b 80 00       	push   $0x800be8
  800c61:	e8 92 fb ff ff       	call   8007f8 <vprintfmt>
  800c66:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c6c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 89 ff ff ff       	call   800c1e <vsnprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cad:	eb 06                	jmp    800cb5 <strlen+0x15>
		n++;
  800caf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 f1                	jne    800caf <strlen+0xf>
		n++;
	return n;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd0:	eb 09                	jmp    800cdb <strnlen+0x18>
		n++;
  800cd2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	ff 4d 0c             	decl   0xc(%ebp)
  800cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdf:	74 09                	je     800cea <strnlen+0x27>
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 e8                	jne    800cd2 <strnlen+0xf>
		n++;
	return n;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cfb:	90                   	nop
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 08             	mov    %edx,0x8(%ebp)
  800d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0e:	8a 12                	mov    (%edx),%dl
  800d10:	88 10                	mov    %dl,(%eax)
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	75 e4                	jne    800cfc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d30:	eb 1f                	jmp    800d51 <strncpy+0x34>
		*dst++ = *src;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8d 50 01             	lea    0x1(%eax),%edx
  800d38:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	74 03                	je     800d4e <strncpy+0x31>
			src++;
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4e:	ff 45 fc             	incl   -0x4(%ebp)
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d57:	72 d9                	jb     800d32 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	74 30                	je     800da0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d70:	eb 16                	jmp    800d88 <strlcpy+0x2a>
			*dst++ = *src++;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8d 50 01             	lea    0x1(%eax),%edx
  800d78:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d81:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d84:	8a 12                	mov    (%edx),%dl
  800d86:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d88:	ff 4d 10             	decl   0x10(%ebp)
  800d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8f:	74 09                	je     800d9a <strlcpy+0x3c>
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 d8                	jne    800d72 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da6:	29 c2                	sub    %eax,%edx
  800da8:	89 d0                	mov    %edx,%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800daf:	eb 06                	jmp    800db7 <strcmp+0xb>
		p++, q++;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	74 0e                	je     800dce <strcmp+0x22>
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 10                	mov    (%eax),%dl
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	38 c2                	cmp    %al,%dl
  800dcc:	74 e3                	je     800db1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 d0             	movzbl %al,%edx
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	0f b6 c0             	movzbl %al,%eax
  800dde:	29 c2                	sub    %eax,%edx
  800de0:	89 d0                	mov    %edx,%eax
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de7:	eb 09                	jmp    800df2 <strncmp+0xe>
		n--, p++, q++;
  800de9:	ff 4d 10             	decl   0x10(%ebp)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df6:	74 17                	je     800e0f <strncmp+0x2b>
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	74 0e                	je     800e0f <strncmp+0x2b>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 10                	mov    (%eax),%dl
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	38 c2                	cmp    %al,%dl
  800e0d:	74 da                	je     800de9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e13:	75 07                	jne    800e1c <strncmp+0x38>
		return 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	eb 14                	jmp    800e30 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 d0             	movzbl %al,%edx
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	0f b6 c0             	movzbl %al,%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3e:	eb 12                	jmp    800e52 <strchr+0x20>
		if (*s == c)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e48:	75 05                	jne    800e4f <strchr+0x1d>
			return (char *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	eb 11                	jmp    800e60 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e5                	jne    800e40 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 04             	sub    $0x4,%esp
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6e:	eb 0d                	jmp    800e7d <strfind+0x1b>
		if (*s == c)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e78:	74 0e                	je     800e88 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 ea                	jne    800e70 <strfind+0xe>
  800e86:	eb 01                	jmp    800e89 <strfind+0x27>
		if (*s == c)
			break;
  800e88:	90                   	nop
	return (char *) s;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea0:	eb 0e                	jmp    800eb0 <memset+0x22>
		*p++ = c;
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb0:	ff 4d f8             	decl   -0x8(%ebp)
  800eb3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eb7:	79 e9                	jns    800ea2 <memset+0x14>
		*p++ = c;

	return v;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed0:	eb 16                	jmp    800ee8 <memcpy+0x2a>
		*d++ = *s++;
  800ed2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ede:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 dd                	jne    800ed2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f12:	73 50                	jae    800f64 <memmove+0x6a>
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1f:	76 43                	jbe    800f64 <memmove+0x6a>
		s += n;
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f2d:	eb 10                	jmp    800f3f <memmove+0x45>
			*--d = *--s;
  800f2f:	ff 4d f8             	decl   -0x8(%ebp)
  800f32:	ff 4d fc             	decl   -0x4(%ebp)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f45:	89 55 10             	mov    %edx,0x10(%ebp)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	75 e3                	jne    800f2f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f4c:	eb 23                	jmp    800f71 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f60:	8a 12                	mov    (%edx),%dl
  800f62:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 dd                	jne    800f4e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f88:	eb 2a                	jmp    800fb4 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	38 c2                	cmp    %al,%dl
  800f96:	74 16                	je     800fae <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 d0             	movzbl %al,%edx
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f b6 c0             	movzbl %al,%eax
  800fa8:	29 c2                	sub    %eax,%edx
  800faa:	89 d0                	mov    %edx,%eax
  800fac:	eb 18                	jmp    800fc6 <memcmp+0x50>
		s1++, s2++;
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fba:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	75 c9                	jne    800f8a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd9:	eb 15                	jmp    800ff0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	0f b6 c0             	movzbl %al,%eax
  800fe9:	39 c2                	cmp    %eax,%edx
  800feb:	74 0d                	je     800ffa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ff6:	72 e3                	jb     800fdb <memfind+0x13>
  800ff8:	eb 01                	jmp    800ffb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffa:	90                   	nop
	return (void *) s;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80100d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801014:	eb 03                	jmp    801019 <strtol+0x19>
		s++;
  801016:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 20                	cmp    $0x20,%al
  801020:	74 f4                	je     801016 <strtol+0x16>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	3c 09                	cmp    $0x9,%al
  801029:	74 eb                	je     801016 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	3c 2b                	cmp    $0x2b,%al
  801032:	75 05                	jne    801039 <strtol+0x39>
		s++;
  801034:	ff 45 08             	incl   0x8(%ebp)
  801037:	eb 13                	jmp    80104c <strtol+0x4c>
	else if (*s == '-')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 2d                	cmp    $0x2d,%al
  801040:	75 0a                	jne    80104c <strtol+0x4c>
		s++, neg = 1;
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80104c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801050:	74 06                	je     801058 <strtol+0x58>
  801052:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801056:	75 20                	jne    801078 <strtol+0x78>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 30                	cmp    $0x30,%al
  80105f:	75 17                	jne    801078 <strtol+0x78>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	40                   	inc    %eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 78                	cmp    $0x78,%al
  801069:	75 0d                	jne    801078 <strtol+0x78>
		s += 2, base = 16;
  80106b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80106f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801076:	eb 28                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	75 15                	jne    801093 <strtol+0x93>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 0c                	jne    801093 <strtol+0x93>
		s++, base = 8;
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801091:	eb 0d                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0)
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	75 07                	jne    8010a0 <strtol+0xa0>
		base = 10;
  801099:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 2f                	cmp    $0x2f,%al
  8010a7:	7e 19                	jle    8010c2 <strtol+0xc2>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 39                	cmp    $0x39,%al
  8010b0:	7f 10                	jg     8010c2 <strtol+0xc2>
			dig = *s - '0';
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 30             	sub    $0x30,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c0:	eb 42                	jmp    801104 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 60                	cmp    $0x60,%al
  8010c9:	7e 19                	jle    8010e4 <strtol+0xe4>
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 7a                	cmp    $0x7a,%al
  8010d2:	7f 10                	jg     8010e4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f be c0             	movsbl %al,%eax
  8010dc:	83 e8 57             	sub    $0x57,%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e2:	eb 20                	jmp    801104 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 40                	cmp    $0x40,%al
  8010eb:	7e 39                	jle    801126 <strtol+0x126>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 5a                	cmp    $0x5a,%al
  8010f4:	7f 30                	jg     801126 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	0f be c0             	movsbl %al,%eax
  8010fe:	83 e8 37             	sub    $0x37,%eax
  801101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110a:	7d 19                	jge    801125 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801112:	0f af 45 10          	imul   0x10(%ebp),%eax
  801116:	89 c2                	mov    %eax,%edx
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	01 d0                	add    %edx,%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801120:	e9 7b ff ff ff       	jmp    8010a0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801125:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112a:	74 08                	je     801134 <strtol+0x134>
		*endptr = (char *) s;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801138:	74 07                	je     801141 <strtol+0x141>
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	f7 d8                	neg    %eax
  80113f:	eb 03                	jmp    801144 <strtol+0x144>
  801141:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <ltostr>:

void
ltostr(long value, char *str)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801153:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115e:	79 13                	jns    801173 <ltostr+0x2d>
	{
		neg = 1;
  801160:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80116d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801170:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117b:	99                   	cltd   
  80117c:	f7 f9                	idiv   %ecx
  80117e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801194:	83 c2 30             	add    $0x30,%edx
  801197:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a1:	f7 e9                	imul   %ecx
  8011a3:	c1 fa 02             	sar    $0x2,%edx
  8011a6:	89 c8                	mov    %ecx,%eax
  8011a8:	c1 f8 1f             	sar    $0x1f,%eax
  8011ab:	29 c2                	sub    %eax,%edx
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ba:	f7 e9                	imul   %ecx
  8011bc:	c1 fa 02             	sar    $0x2,%edx
  8011bf:	89 c8                	mov    %ecx,%eax
  8011c1:	c1 f8 1f             	sar    $0x1f,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
  8011c8:	c1 e0 02             	shl    $0x2,%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	01 c0                	add    %eax,%eax
  8011cf:	29 c1                	sub    %eax,%ecx
  8011d1:	89 ca                	mov    %ecx,%edx
  8011d3:	85 d2                	test   %edx,%edx
  8011d5:	75 9c                	jne    801173 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e1:	48                   	dec    %eax
  8011e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e9:	74 3d                	je     801228 <ltostr+0xe2>
		start = 1 ;
  8011eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f2:	eb 34                	jmp    801228 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 c8                	add    %ecx,%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801220:	88 02                	mov    %al,(%edx)
		start++ ;
  801222:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801225:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122e:	7c c4                	jl     8011f4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801230:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801244:	ff 75 08             	pushl  0x8(%ebp)
  801247:	e8 54 fa ff ff       	call   800ca0 <strlen>
  80124c:	83 c4 04             	add    $0x4,%esp
  80124f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801252:	ff 75 0c             	pushl  0xc(%ebp)
  801255:	e8 46 fa ff ff       	call   800ca0 <strlen>
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801260:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126e:	eb 17                	jmp    801287 <strcconcat+0x49>
		final[s] = str1[s] ;
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	01 c2                	add    %eax,%edx
  801278:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	01 c8                	add    %ecx,%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801284:	ff 45 fc             	incl   -0x4(%ebp)
  801287:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80128d:	7c e1                	jl     801270 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80128f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801296:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80129d:	eb 1f                	jmp    8012be <strcconcat+0x80>
		final[s++] = str2[i] ;
  80129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a2:	8d 50 01             	lea    0x1(%eax),%edx
  8012a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 c8                	add    %ecx,%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bb:	ff 45 f8             	incl   -0x8(%ebp)
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c4:	7c d9                	jl     80129f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f7:	eb 0c                	jmp    801305 <strsplit+0x31>
			*string++ = 0;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8d 50 01             	lea    0x1(%eax),%edx
  8012ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801302:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	74 18                	je     801326 <strsplit+0x52>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	50                   	push   %eax
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	e8 13 fb ff ff       	call   800e32 <strchr>
  80131f:	83 c4 08             	add    $0x8,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	75 d3                	jne    8012f9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 5a                	je     801389 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80132f:	8b 45 14             	mov    0x14(%ebp),%eax
  801332:	8b 00                	mov    (%eax),%eax
  801334:	83 f8 0f             	cmp    $0xf,%eax
  801337:	75 07                	jne    801340 <strsplit+0x6c>
		{
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb 66                	jmp    8013a6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801340:	8b 45 14             	mov    0x14(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	8d 48 01             	lea    0x1(%eax),%ecx
  801348:	8b 55 14             	mov    0x14(%ebp),%edx
  80134b:	89 0a                	mov    %ecx,(%edx)
  80134d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 c2                	add    %eax,%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135e:	eb 03                	jmp    801363 <strsplit+0x8f>
			string++;
  801360:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	84 c0                	test   %al,%al
  80136a:	74 8b                	je     8012f7 <strsplit+0x23>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f be c0             	movsbl %al,%eax
  801374:	50                   	push   %eax
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 b5 fa ff ff       	call   800e32 <strchr>
  80137d:	83 c4 08             	add    $0x8,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	74 dc                	je     801360 <strsplit+0x8c>
			string++;
	}
  801384:	e9 6e ff ff ff       	jmp    8012f7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801389:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 1f                	je     8013d6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013b7:	e8 1d 00 00 00       	call   8013d9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	68 90 39 80 00       	push   $0x803990
  8013c4:	e8 55 f2 ff ff       	call   80061e <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013cc:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d3:	00 00 00 
	}
}
  8013d6:	90                   	nop
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8013df:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013e6:	00 00 00 
  8013e9:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013f0:	00 00 00 
  8013f3:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013fa:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8013fd:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801404:	00 00 00 
  801407:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80140e:	00 00 00 
  801411:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801418:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80141b:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801425:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80142a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80142f:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801434:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80143b:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80143e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801448:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80144d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801453:	ba 00 00 00 00       	mov    $0x0,%edx
  801458:	f7 75 f0             	divl   -0x10(%ebp)
  80145b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145e:	29 d0                	sub    %edx,%eax
  801460:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801463:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80146a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80146d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801472:	2d 00 10 00 00       	sub    $0x1000,%eax
  801477:	83 ec 04             	sub    $0x4,%esp
  80147a:	6a 06                	push   $0x6
  80147c:	ff 75 e8             	pushl  -0x18(%ebp)
  80147f:	50                   	push   %eax
  801480:	e8 d4 05 00 00       	call   801a59 <sys_allocate_chunk>
  801485:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801488:	a1 20 41 80 00       	mov    0x804120,%eax
  80148d:	83 ec 0c             	sub    $0xc,%esp
  801490:	50                   	push   %eax
  801491:	e8 49 0c 00 00       	call   8020df <initialize_MemBlocksList>
  801496:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801499:	a1 48 41 80 00       	mov    0x804148,%eax
  80149e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8014a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014a5:	75 14                	jne    8014bb <initialize_dyn_block_system+0xe2>
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	68 b5 39 80 00       	push   $0x8039b5
  8014af:	6a 39                	push   $0x39
  8014b1:	68 d3 39 80 00       	push   $0x8039d3
  8014b6:	e8 af ee ff ff       	call   80036a <_panic>
  8014bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014be:	8b 00                	mov    (%eax),%eax
  8014c0:	85 c0                	test   %eax,%eax
  8014c2:	74 10                	je     8014d4 <initialize_dyn_block_system+0xfb>
  8014c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c7:	8b 00                	mov    (%eax),%eax
  8014c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014cc:	8b 52 04             	mov    0x4(%edx),%edx
  8014cf:	89 50 04             	mov    %edx,0x4(%eax)
  8014d2:	eb 0b                	jmp    8014df <initialize_dyn_block_system+0x106>
  8014d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d7:	8b 40 04             	mov    0x4(%eax),%eax
  8014da:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e2:	8b 40 04             	mov    0x4(%eax),%eax
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	74 0f                	je     8014f8 <initialize_dyn_block_system+0x11f>
  8014e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ec:	8b 40 04             	mov    0x4(%eax),%eax
  8014ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014f2:	8b 12                	mov    (%edx),%edx
  8014f4:	89 10                	mov    %edx,(%eax)
  8014f6:	eb 0a                	jmp    801502 <initialize_dyn_block_system+0x129>
  8014f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fb:	8b 00                	mov    (%eax),%eax
  8014fd:	a3 48 41 80 00       	mov    %eax,0x804148
  801502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801505:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80150b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801515:	a1 54 41 80 00       	mov    0x804154,%eax
  80151a:	48                   	dec    %eax
  80151b:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801520:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801523:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80152a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801534:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801538:	75 14                	jne    80154e <initialize_dyn_block_system+0x175>
  80153a:	83 ec 04             	sub    $0x4,%esp
  80153d:	68 e0 39 80 00       	push   $0x8039e0
  801542:	6a 3f                	push   $0x3f
  801544:	68 d3 39 80 00       	push   $0x8039d3
  801549:	e8 1c ee ff ff       	call   80036a <_panic>
  80154e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801554:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801557:	89 10                	mov    %edx,(%eax)
  801559:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	85 c0                	test   %eax,%eax
  801560:	74 0d                	je     80156f <initialize_dyn_block_system+0x196>
  801562:	a1 38 41 80 00       	mov    0x804138,%eax
  801567:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80156a:	89 50 04             	mov    %edx,0x4(%eax)
  80156d:	eb 08                	jmp    801577 <initialize_dyn_block_system+0x19e>
  80156f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801572:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157a:	a3 38 41 80 00       	mov    %eax,0x804138
  80157f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801582:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801589:	a1 44 41 80 00       	mov    0x804144,%eax
  80158e:	40                   	inc    %eax
  80158f:	a3 44 41 80 00       	mov    %eax,0x804144

}
  801594:	90                   	nop
  801595:	c9                   	leave  
  801596:	c3                   	ret    

00801597 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159d:	e8 06 fe ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015a6:	75 07                	jne    8015af <malloc+0x18>
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ad:	eb 7d                	jmp    80162c <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8015af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8015b6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c3:	01 d0                	add    %edx,%eax
  8015c5:	48                   	dec    %eax
  8015c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d1:	f7 75 f0             	divl   -0x10(%ebp)
  8015d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d7:	29 d0                	sub    %edx,%eax
  8015d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8015dc:	e8 46 08 00 00       	call   801e27 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015e1:	83 f8 01             	cmp    $0x1,%eax
  8015e4:	75 07                	jne    8015ed <malloc+0x56>
  8015e6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8015ed:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8015f1:	75 34                	jne    801627 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8015f3:	83 ec 0c             	sub    $0xc,%esp
  8015f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f9:	e8 73 0e 00 00       	call   802471 <alloc_block_FF>
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801604:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801608:	74 16                	je     801620 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80160a:	83 ec 0c             	sub    $0xc,%esp
  80160d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801610:	e8 ff 0b 00 00       	call   802214 <insert_sorted_allocList>
  801615:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80161b:	8b 40 08             	mov    0x8(%eax),%eax
  80161e:	eb 0c                	jmp    80162c <malloc+0x95>
	             }
	             else
	             	return NULL;
  801620:	b8 00 00 00 00       	mov    $0x0,%eax
  801625:	eb 05                	jmp    80162c <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801627:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80163a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801643:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801648:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80164b:	83 ec 08             	sub    $0x8,%esp
  80164e:	ff 75 f4             	pushl  -0xc(%ebp)
  801651:	68 40 40 80 00       	push   $0x804040
  801656:	e8 61 0b 00 00       	call   8021bc <find_block>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801661:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801665:	0f 84 a5 00 00 00    	je     801710 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166e:	8b 40 0c             	mov    0xc(%eax),%eax
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	50                   	push   %eax
  801675:	ff 75 f4             	pushl  -0xc(%ebp)
  801678:	e8 a4 03 00 00       	call   801a21 <sys_free_user_mem>
  80167d:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801680:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801684:	75 17                	jne    80169d <free+0x6f>
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	68 b5 39 80 00       	push   $0x8039b5
  80168e:	68 87 00 00 00       	push   $0x87
  801693:	68 d3 39 80 00       	push   $0x8039d3
  801698:	e8 cd ec ff ff       	call   80036a <_panic>
  80169d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a0:	8b 00                	mov    (%eax),%eax
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	74 10                	je     8016b6 <free+0x88>
  8016a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016ae:	8b 52 04             	mov    0x4(%edx),%edx
  8016b1:	89 50 04             	mov    %edx,0x4(%eax)
  8016b4:	eb 0b                	jmp    8016c1 <free+0x93>
  8016b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b9:	8b 40 04             	mov    0x4(%eax),%eax
  8016bc:	a3 44 40 80 00       	mov    %eax,0x804044
  8016c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c4:	8b 40 04             	mov    0x4(%eax),%eax
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	74 0f                	je     8016da <free+0xac>
  8016cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ce:	8b 40 04             	mov    0x4(%eax),%eax
  8016d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016d4:	8b 12                	mov    (%edx),%edx
  8016d6:	89 10                	mov    %edx,(%eax)
  8016d8:	eb 0a                	jmp    8016e4 <free+0xb6>
  8016da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016dd:	8b 00                	mov    (%eax),%eax
  8016df:	a3 40 40 80 00       	mov    %eax,0x804040
  8016e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016f7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016fc:	48                   	dec    %eax
  8016fd:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801702:	83 ec 0c             	sub    $0xc,%esp
  801705:	ff 75 ec             	pushl  -0x14(%ebp)
  801708:	e8 37 12 00 00       	call   802944 <insert_sorted_with_merge_freeList>
  80170d:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801710:	90                   	nop
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 38             	sub    $0x38,%esp
  801719:	8b 45 10             	mov    0x10(%ebp),%eax
  80171c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80171f:	e8 84 fc ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801724:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801728:	75 07                	jne    801731 <smalloc+0x1e>
  80172a:	b8 00 00 00 00       	mov    $0x0,%eax
  80172f:	eb 7e                	jmp    8017af <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801731:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801738:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80173f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	01 d0                	add    %edx,%eax
  801747:	48                   	dec    %eax
  801748:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80174b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174e:	ba 00 00 00 00       	mov    $0x0,%edx
  801753:	f7 75 f0             	divl   -0x10(%ebp)
  801756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801759:	29 d0                	sub    %edx,%eax
  80175b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80175e:	e8 c4 06 00 00       	call   801e27 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801763:	83 f8 01             	cmp    $0x1,%eax
  801766:	75 42                	jne    8017aa <smalloc+0x97>

		  va = malloc(newsize) ;
  801768:	83 ec 0c             	sub    $0xc,%esp
  80176b:	ff 75 e8             	pushl  -0x18(%ebp)
  80176e:	e8 24 fe ff ff       	call   801597 <malloc>
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801779:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80177d:	74 24                	je     8017a3 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80177f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801783:	ff 75 e4             	pushl  -0x1c(%ebp)
  801786:	50                   	push   %eax
  801787:	ff 75 e8             	pushl  -0x18(%ebp)
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	e8 1a 04 00 00       	call   801bac <sys_createSharedObject>
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801798:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80179c:	78 0c                	js     8017aa <smalloc+0x97>
					  return va ;
  80179e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a1:	eb 0c                	jmp    8017af <smalloc+0x9c>
				 }
				 else
					return NULL;
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a8:	eb 05                	jmp    8017af <smalloc+0x9c>
	  }
		  return NULL ;
  8017aa:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017b7:	e8 ec fb ff ff       	call   8013a8 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8017bc:	83 ec 08             	sub    $0x8,%esp
  8017bf:	ff 75 0c             	pushl  0xc(%ebp)
  8017c2:	ff 75 08             	pushl  0x8(%ebp)
  8017c5:	e8 0c 04 00 00       	call   801bd6 <sys_getSizeOfSharedObject>
  8017ca:	83 c4 10             	add    $0x10,%esp
  8017cd:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8017d0:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017d4:	75 07                	jne    8017dd <sget+0x2c>
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017db:	eb 75                	jmp    801852 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8017dd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ea:	01 d0                	add    %edx,%eax
  8017ec:	48                   	dec    %eax
  8017ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f8:	f7 75 f0             	divl   -0x10(%ebp)
  8017fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fe:	29 d0                	sub    %edx,%eax
  801800:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801803:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80180a:	e8 18 06 00 00       	call   801e27 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80180f:	83 f8 01             	cmp    $0x1,%eax
  801812:	75 39                	jne    80184d <sget+0x9c>

		  va = malloc(newsize) ;
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	ff 75 e8             	pushl  -0x18(%ebp)
  80181a:	e8 78 fd ff ff       	call   801597 <malloc>
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801825:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801829:	74 22                	je     80184d <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	ff 75 e0             	pushl  -0x20(%ebp)
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	ff 75 08             	pushl  0x8(%ebp)
  801837:	e8 b7 03 00 00       	call   801bf3 <sys_getSharedObject>
  80183c:	83 c4 10             	add    $0x10,%esp
  80183f:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801842:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801846:	78 05                	js     80184d <sget+0x9c>
					  return va;
  801848:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184b:	eb 05                	jmp    801852 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80184d:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80185a:	e8 49 fb ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	68 04 3a 80 00       	push   $0x803a04
  801867:	68 1e 01 00 00       	push   $0x11e
  80186c:	68 d3 39 80 00       	push   $0x8039d3
  801871:	e8 f4 ea ff ff       	call   80036a <_panic>

00801876 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 2c 3a 80 00       	push   $0x803a2c
  801884:	68 32 01 00 00       	push   $0x132
  801889:	68 d3 39 80 00       	push   $0x8039d3
  80188e:	e8 d7 ea ff ff       	call   80036a <_panic>

00801893 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801899:	83 ec 04             	sub    $0x4,%esp
  80189c:	68 50 3a 80 00       	push   $0x803a50
  8018a1:	68 3d 01 00 00       	push   $0x13d
  8018a6:	68 d3 39 80 00       	push   $0x8039d3
  8018ab:	e8 ba ea ff ff       	call   80036a <_panic>

008018b0 <shrink>:

}
void shrink(uint32 newSize)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b6:	83 ec 04             	sub    $0x4,%esp
  8018b9:	68 50 3a 80 00       	push   $0x803a50
  8018be:	68 42 01 00 00       	push   $0x142
  8018c3:	68 d3 39 80 00       	push   $0x8039d3
  8018c8:	e8 9d ea ff ff       	call   80036a <_panic>

008018cd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d3:	83 ec 04             	sub    $0x4,%esp
  8018d6:	68 50 3a 80 00       	push   $0x803a50
  8018db:	68 47 01 00 00       	push   $0x147
  8018e0:	68 d3 39 80 00       	push   $0x8039d3
  8018e5:	e8 80 ea ff ff       	call   80036a <_panic>

008018ea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	57                   	push   %edi
  8018ee:	56                   	push   %esi
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ff:	8b 7d 18             	mov    0x18(%ebp),%edi
  801902:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801905:	cd 30                	int    $0x30
  801907:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80190a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5f                   	pop    %edi
  801913:	5d                   	pop    %ebp
  801914:	c3                   	ret    

00801915 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 04             	sub    $0x4,%esp
  80191b:	8b 45 10             	mov    0x10(%ebp),%eax
  80191e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801921:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	52                   	push   %edx
  80192d:	ff 75 0c             	pushl  0xc(%ebp)
  801930:	50                   	push   %eax
  801931:	6a 00                	push   $0x0
  801933:	e8 b2 ff ff ff       	call   8018ea <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_cgetc>:

int
sys_cgetc(void)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 01                	push   $0x1
  80194d:	e8 98 ff ff ff       	call   8018ea <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80195a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	52                   	push   %edx
  801967:	50                   	push   %eax
  801968:	6a 05                	push   $0x5
  80196a:	e8 7b ff ff ff       	call   8018ea <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	56                   	push   %esi
  801978:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801979:	8b 75 18             	mov    0x18(%ebp),%esi
  80197c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80197f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801982:	8b 55 0c             	mov    0xc(%ebp),%edx
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	56                   	push   %esi
  801989:	53                   	push   %ebx
  80198a:	51                   	push   %ecx
  80198b:	52                   	push   %edx
  80198c:	50                   	push   %eax
  80198d:	6a 06                	push   $0x6
  80198f:	e8 56 ff ff ff       	call   8018ea <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199a:	5b                   	pop    %ebx
  80199b:	5e                   	pop    %esi
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    

0080199e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	52                   	push   %edx
  8019ae:	50                   	push   %eax
  8019af:	6a 07                	push   $0x7
  8019b1:	e8 34 ff ff ff       	call   8018ea <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	ff 75 08             	pushl  0x8(%ebp)
  8019ca:	6a 08                	push   $0x8
  8019cc:	e8 19 ff ff ff       	call   8018ea <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 09                	push   $0x9
  8019e5:	e8 00 ff ff ff       	call   8018ea <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 0a                	push   $0xa
  8019fe:	e8 e7 fe ff ff       	call   8018ea <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 0b                	push   $0xb
  801a17:	e8 ce fe ff ff       	call   8018ea <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	ff 75 0c             	pushl  0xc(%ebp)
  801a2d:	ff 75 08             	pushl  0x8(%ebp)
  801a30:	6a 0f                	push   $0xf
  801a32:	e8 b3 fe ff ff       	call   8018ea <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
	return;
  801a3a:	90                   	nop
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	ff 75 08             	pushl  0x8(%ebp)
  801a4c:	6a 10                	push   $0x10
  801a4e:	e8 97 fe ff ff       	call   8018ea <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
	return ;
  801a56:	90                   	nop
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	ff 75 10             	pushl  0x10(%ebp)
  801a63:	ff 75 0c             	pushl  0xc(%ebp)
  801a66:	ff 75 08             	pushl  0x8(%ebp)
  801a69:	6a 11                	push   $0x11
  801a6b:	e8 7a fe ff ff       	call   8018ea <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
	return ;
  801a73:	90                   	nop
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 0c                	push   $0xc
  801a85:	e8 60 fe ff ff       	call   8018ea <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	ff 75 08             	pushl  0x8(%ebp)
  801a9d:	6a 0d                	push   $0xd
  801a9f:	e8 46 fe ff ff       	call   8018ea <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 0e                	push   $0xe
  801ab8:	e8 2d fe ff ff       	call   8018ea <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	90                   	nop
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 13                	push   $0x13
  801ad2:	e8 13 fe ff ff       	call   8018ea <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	90                   	nop
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 14                	push   $0x14
  801aec:	e8 f9 fd ff ff       	call   8018ea <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	8b 45 08             	mov    0x8(%ebp),%eax
  801b00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b03:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	50                   	push   %eax
  801b10:	6a 15                	push   $0x15
  801b12:	e8 d3 fd ff ff       	call   8018ea <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	90                   	nop
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 16                	push   $0x16
  801b2c:	e8 b9 fd ff ff       	call   8018ea <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	90                   	nop
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 0c             	pushl  0xc(%ebp)
  801b46:	50                   	push   %eax
  801b47:	6a 17                	push   $0x17
  801b49:	e8 9c fd ff ff       	call   8018ea <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	52                   	push   %edx
  801b63:	50                   	push   %eax
  801b64:	6a 1a                	push   $0x1a
  801b66:	e8 7f fd ff ff       	call   8018ea <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 18                	push   $0x18
  801b83:	e8 62 fd ff ff       	call   8018ea <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	90                   	nop
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	52                   	push   %edx
  801b9e:	50                   	push   %eax
  801b9f:	6a 19                	push   $0x19
  801ba1:	e8 44 fd ff ff       	call   8018ea <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	90                   	nop
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bb8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bbb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	51                   	push   %ecx
  801bc5:	52                   	push   %edx
  801bc6:	ff 75 0c             	pushl  0xc(%ebp)
  801bc9:	50                   	push   %eax
  801bca:	6a 1b                	push   $0x1b
  801bcc:	e8 19 fd ff ff       	call   8018ea <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	52                   	push   %edx
  801be6:	50                   	push   %eax
  801be7:	6a 1c                	push   $0x1c
  801be9:	e8 fc fc ff ff       	call   8018ea <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	51                   	push   %ecx
  801c04:	52                   	push   %edx
  801c05:	50                   	push   %eax
  801c06:	6a 1d                	push   $0x1d
  801c08:	e8 dd fc ff ff       	call   8018ea <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	52                   	push   %edx
  801c22:	50                   	push   %eax
  801c23:	6a 1e                	push   $0x1e
  801c25:	e8 c0 fc ff ff       	call   8018ea <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 1f                	push   $0x1f
  801c3e:	e8 a7 fc ff ff       	call   8018ea <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	6a 00                	push   $0x0
  801c50:	ff 75 14             	pushl  0x14(%ebp)
  801c53:	ff 75 10             	pushl  0x10(%ebp)
  801c56:	ff 75 0c             	pushl  0xc(%ebp)
  801c59:	50                   	push   %eax
  801c5a:	6a 20                	push   $0x20
  801c5c:	e8 89 fc ff ff       	call   8018ea <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	50                   	push   %eax
  801c75:	6a 21                	push   $0x21
  801c77:	e8 6e fc ff ff       	call   8018ea <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	90                   	nop
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	50                   	push   %eax
  801c91:	6a 22                	push   $0x22
  801c93:	e8 52 fc ff ff       	call   8018ea <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 02                	push   $0x2
  801cac:	e8 39 fc ff ff       	call   8018ea <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 03                	push   $0x3
  801cc5:	e8 20 fc ff ff       	call   8018ea <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 04                	push   $0x4
  801cde:	e8 07 fc ff ff       	call   8018ea <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_exit_env>:


void sys_exit_env(void)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 23                	push   $0x23
  801cf7:	e8 ee fb ff ff       	call   8018ea <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	90                   	nop
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d08:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d0b:	8d 50 04             	lea    0x4(%eax),%edx
  801d0e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	52                   	push   %edx
  801d18:	50                   	push   %eax
  801d19:	6a 24                	push   $0x24
  801d1b:	e8 ca fb ff ff       	call   8018ea <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return result;
  801d23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d2c:	89 01                	mov    %eax,(%ecx)
  801d2e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	c9                   	leave  
  801d35:	c2 04 00             	ret    $0x4

00801d38 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	ff 75 10             	pushl  0x10(%ebp)
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	6a 12                	push   $0x12
  801d4a:	e8 9b fb ff ff       	call   8018ea <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d52:	90                   	nop
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 25                	push   $0x25
  801d64:	e8 81 fb ff ff       	call   8018ea <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 04             	sub    $0x4,%esp
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d7a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	50                   	push   %eax
  801d87:	6a 26                	push   $0x26
  801d89:	e8 5c fb ff ff       	call   8018ea <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d91:	90                   	nop
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <rsttst>:
void rsttst()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 28                	push   $0x28
  801da3:	e8 42 fb ff ff       	call   8018ea <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dab:	90                   	nop
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 04             	sub    $0x4,%esp
  801db4:	8b 45 14             	mov    0x14(%ebp),%eax
  801db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dba:	8b 55 18             	mov    0x18(%ebp),%edx
  801dbd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dc1:	52                   	push   %edx
  801dc2:	50                   	push   %eax
  801dc3:	ff 75 10             	pushl  0x10(%ebp)
  801dc6:	ff 75 0c             	pushl  0xc(%ebp)
  801dc9:	ff 75 08             	pushl  0x8(%ebp)
  801dcc:	6a 27                	push   $0x27
  801dce:	e8 17 fb ff ff       	call   8018ea <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd6:	90                   	nop
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <chktst>:
void chktst(uint32 n)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	ff 75 08             	pushl  0x8(%ebp)
  801de7:	6a 29                	push   $0x29
  801de9:	e8 fc fa ff ff       	call   8018ea <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return ;
  801df1:	90                   	nop
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <inctst>:

void inctst()
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 2a                	push   $0x2a
  801e03:	e8 e2 fa ff ff       	call   8018ea <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0b:	90                   	nop
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <gettst>:
uint32 gettst()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 2b                	push   $0x2b
  801e1d:	e8 c8 fa ff ff       	call   8018ea <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
  801e2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 2c                	push   $0x2c
  801e39:	e8 ac fa ff ff       	call   8018ea <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
  801e41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e44:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e48:	75 07                	jne    801e51 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4f:	eb 05                	jmp    801e56 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 2c                	push   $0x2c
  801e6a:	e8 7b fa ff ff       	call   8018ea <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
  801e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e75:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e79:	75 07                	jne    801e82 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e80:	eb 05                	jmp    801e87 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 2c                	push   $0x2c
  801e9b:	e8 4a fa ff ff       	call   8018ea <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
  801ea3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ea6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eaa:	75 07                	jne    801eb3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eac:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb1:	eb 05                	jmp    801eb8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 2c                	push   $0x2c
  801ecc:	e8 19 fa ff ff       	call   8018ea <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
  801ed4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ed7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801edb:	75 07                	jne    801ee4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801edd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee2:	eb 05                	jmp    801ee9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	ff 75 08             	pushl  0x8(%ebp)
  801ef9:	6a 2d                	push   $0x2d
  801efb:	e8 ea f9 ff ff       	call   8018ea <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
	return ;
  801f03:	90                   	nop
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	6a 00                	push   $0x0
  801f18:	53                   	push   %ebx
  801f19:	51                   	push   %ecx
  801f1a:	52                   	push   %edx
  801f1b:	50                   	push   %eax
  801f1c:	6a 2e                	push   $0x2e
  801f1e:	e8 c7 f9 ff ff       	call   8018ea <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f31:	8b 45 08             	mov    0x8(%ebp),%eax
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	52                   	push   %edx
  801f3b:	50                   	push   %eax
  801f3c:	6a 2f                	push   $0x2f
  801f3e:	e8 a7 f9 ff ff       	call   8018ea <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	68 60 3a 80 00       	push   $0x803a60
  801f56:	e8 c3 e6 ff ff       	call   80061e <cprintf>
  801f5b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f5e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 8c 3a 80 00       	push   $0x803a8c
  801f6d:	e8 ac e6 ff ff       	call   80061e <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f75:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f79:	a1 38 41 80 00       	mov    0x804138,%eax
  801f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f81:	eb 56                	jmp    801fd9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f87:	74 1c                	je     801fa5 <print_mem_block_lists+0x5d>
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 50 08             	mov    0x8(%eax),%edx
  801f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f92:	8b 48 08             	mov    0x8(%eax),%ecx
  801f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f98:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9b:	01 c8                	add    %ecx,%eax
  801f9d:	39 c2                	cmp    %eax,%edx
  801f9f:	73 04                	jae    801fa5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fa1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa8:	8b 50 08             	mov    0x8(%eax),%edx
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb1:	01 c2                	add    %eax,%edx
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	8b 40 08             	mov    0x8(%eax),%eax
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	52                   	push   %edx
  801fbd:	50                   	push   %eax
  801fbe:	68 a1 3a 80 00       	push   $0x803aa1
  801fc3:	e8 56 e6 ff ff       	call   80061e <cprintf>
  801fc8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fd1:	a1 40 41 80 00       	mov    0x804140,%eax
  801fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdd:	74 07                	je     801fe6 <print_mem_block_lists+0x9e>
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	8b 00                	mov    (%eax),%eax
  801fe4:	eb 05                	jmp    801feb <print_mem_block_lists+0xa3>
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	a3 40 41 80 00       	mov    %eax,0x804140
  801ff0:	a1 40 41 80 00       	mov    0x804140,%eax
  801ff5:	85 c0                	test   %eax,%eax
  801ff7:	75 8a                	jne    801f83 <print_mem_block_lists+0x3b>
  801ff9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffd:	75 84                	jne    801f83 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fff:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802003:	75 10                	jne    802015 <print_mem_block_lists+0xcd>
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	68 b0 3a 80 00       	push   $0x803ab0
  80200d:	e8 0c e6 ff ff       	call   80061e <cprintf>
  802012:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802015:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	68 d4 3a 80 00       	push   $0x803ad4
  802024:	e8 f5 e5 ff ff       	call   80061e <cprintf>
  802029:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80202c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802030:	a1 40 40 80 00       	mov    0x804040,%eax
  802035:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802038:	eb 56                	jmp    802090 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80203a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80203e:	74 1c                	je     80205c <print_mem_block_lists+0x114>
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	8b 50 08             	mov    0x8(%eax),%edx
  802046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802049:	8b 48 08             	mov    0x8(%eax),%ecx
  80204c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204f:	8b 40 0c             	mov    0xc(%eax),%eax
  802052:	01 c8                	add    %ecx,%eax
  802054:	39 c2                	cmp    %eax,%edx
  802056:	73 04                	jae    80205c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802058:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	8b 50 08             	mov    0x8(%eax),%edx
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	8b 40 0c             	mov    0xc(%eax),%eax
  802068:	01 c2                	add    %eax,%edx
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 40 08             	mov    0x8(%eax),%eax
  802070:	83 ec 04             	sub    $0x4,%esp
  802073:	52                   	push   %edx
  802074:	50                   	push   %eax
  802075:	68 a1 3a 80 00       	push   $0x803aa1
  80207a:	e8 9f e5 ff ff       	call   80061e <cprintf>
  80207f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802088:	a1 48 40 80 00       	mov    0x804048,%eax
  80208d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802090:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802094:	74 07                	je     80209d <print_mem_block_lists+0x155>
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	eb 05                	jmp    8020a2 <print_mem_block_lists+0x15a>
  80209d:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a2:	a3 48 40 80 00       	mov    %eax,0x804048
  8020a7:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ac:	85 c0                	test   %eax,%eax
  8020ae:	75 8a                	jne    80203a <print_mem_block_lists+0xf2>
  8020b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b4:	75 84                	jne    80203a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020b6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ba:	75 10                	jne    8020cc <print_mem_block_lists+0x184>
  8020bc:	83 ec 0c             	sub    $0xc,%esp
  8020bf:	68 ec 3a 80 00       	push   $0x803aec
  8020c4:	e8 55 e5 ff ff       	call   80061e <cprintf>
  8020c9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020cc:	83 ec 0c             	sub    $0xc,%esp
  8020cf:	68 60 3a 80 00       	push   $0x803a60
  8020d4:	e8 45 e5 ff ff       	call   80061e <cprintf>
  8020d9:	83 c4 10             	add    $0x10,%esp

}
  8020dc:	90                   	nop
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8020e5:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020ec:	00 00 00 
  8020ef:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020f6:	00 00 00 
  8020f9:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802100:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802103:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80210a:	e9 9e 00 00 00       	jmp    8021ad <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80210f:	a1 50 40 80 00       	mov    0x804050,%eax
  802114:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802117:	c1 e2 04             	shl    $0x4,%edx
  80211a:	01 d0                	add    %edx,%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	75 14                	jne    802134 <initialize_MemBlocksList+0x55>
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	68 14 3b 80 00       	push   $0x803b14
  802128:	6a 47                	push   $0x47
  80212a:	68 37 3b 80 00       	push   $0x803b37
  80212f:	e8 36 e2 ff ff       	call   80036a <_panic>
  802134:	a1 50 40 80 00       	mov    0x804050,%eax
  802139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213c:	c1 e2 04             	shl    $0x4,%edx
  80213f:	01 d0                	add    %edx,%eax
  802141:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802147:	89 10                	mov    %edx,(%eax)
  802149:	8b 00                	mov    (%eax),%eax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	74 18                	je     802167 <initialize_MemBlocksList+0x88>
  80214f:	a1 48 41 80 00       	mov    0x804148,%eax
  802154:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80215a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80215d:	c1 e1 04             	shl    $0x4,%ecx
  802160:	01 ca                	add    %ecx,%edx
  802162:	89 50 04             	mov    %edx,0x4(%eax)
  802165:	eb 12                	jmp    802179 <initialize_MemBlocksList+0x9a>
  802167:	a1 50 40 80 00       	mov    0x804050,%eax
  80216c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216f:	c1 e2 04             	shl    $0x4,%edx
  802172:	01 d0                	add    %edx,%eax
  802174:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802179:	a1 50 40 80 00       	mov    0x804050,%eax
  80217e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802181:	c1 e2 04             	shl    $0x4,%edx
  802184:	01 d0                	add    %edx,%eax
  802186:	a3 48 41 80 00       	mov    %eax,0x804148
  80218b:	a1 50 40 80 00       	mov    0x804050,%eax
  802190:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802193:	c1 e2 04             	shl    $0x4,%edx
  802196:	01 d0                	add    %edx,%eax
  802198:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80219f:	a1 54 41 80 00       	mov    0x804154,%eax
  8021a4:	40                   	inc    %eax
  8021a5:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8021aa:	ff 45 f4             	incl   -0xc(%ebp)
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b3:	0f 82 56 ff ff ff    	jb     80210f <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8021b9:	90                   	nop
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ca:	eb 19                	jmp    8021e5 <find_block+0x29>
	{
		if(element->sva == va){
  8021cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021cf:	8b 40 08             	mov    0x8(%eax),%eax
  8021d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021d5:	75 05                	jne    8021dc <find_block+0x20>
			 		return element;
  8021d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021da:	eb 36                	jmp    802212 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8b 40 08             	mov    0x8(%eax),%eax
  8021e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021e9:	74 07                	je     8021f2 <find_block+0x36>
  8021eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	eb 05                	jmp    8021f7 <find_block+0x3b>
  8021f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fa:	89 42 08             	mov    %eax,0x8(%edx)
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	8b 40 08             	mov    0x8(%eax),%eax
  802203:	85 c0                	test   %eax,%eax
  802205:	75 c5                	jne    8021cc <find_block+0x10>
  802207:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80220b:	75 bf                	jne    8021cc <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80220d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80221a:	a1 44 40 80 00       	mov    0x804044,%eax
  80221f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802222:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802227:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80222a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80222e:	74 0a                	je     80223a <insert_sorted_allocList+0x26>
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	8b 40 08             	mov    0x8(%eax),%eax
  802236:	85 c0                	test   %eax,%eax
  802238:	75 65                	jne    80229f <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80223a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223e:	75 14                	jne    802254 <insert_sorted_allocList+0x40>
  802240:	83 ec 04             	sub    $0x4,%esp
  802243:	68 14 3b 80 00       	push   $0x803b14
  802248:	6a 6e                	push   $0x6e
  80224a:	68 37 3b 80 00       	push   $0x803b37
  80224f:	e8 16 e1 ff ff       	call   80036a <_panic>
  802254:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	89 10                	mov    %edx,(%eax)
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	8b 00                	mov    (%eax),%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	74 0d                	je     802275 <insert_sorted_allocList+0x61>
  802268:	a1 40 40 80 00       	mov    0x804040,%eax
  80226d:	8b 55 08             	mov    0x8(%ebp),%edx
  802270:	89 50 04             	mov    %edx,0x4(%eax)
  802273:	eb 08                	jmp    80227d <insert_sorted_allocList+0x69>
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	a3 44 40 80 00       	mov    %eax,0x804044
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	a3 40 40 80 00       	mov    %eax,0x804040
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80228f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802294:	40                   	inc    %eax
  802295:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80229a:	e9 cf 01 00 00       	jmp    80246e <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80229f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a2:	8b 50 08             	mov    0x8(%eax),%edx
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	8b 40 08             	mov    0x8(%eax),%eax
  8022ab:	39 c2                	cmp    %eax,%edx
  8022ad:	73 65                	jae    802314 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b3:	75 14                	jne    8022c9 <insert_sorted_allocList+0xb5>
  8022b5:	83 ec 04             	sub    $0x4,%esp
  8022b8:	68 50 3b 80 00       	push   $0x803b50
  8022bd:	6a 72                	push   $0x72
  8022bf:	68 37 3b 80 00       	push   $0x803b37
  8022c4:	e8 a1 e0 ff ff       	call   80036a <_panic>
  8022c9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	89 50 04             	mov    %edx,0x4(%eax)
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	8b 40 04             	mov    0x4(%eax),%eax
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	74 0c                	je     8022eb <insert_sorted_allocList+0xd7>
  8022df:	a1 44 40 80 00       	mov    0x804044,%eax
  8022e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e7:	89 10                	mov    %edx,(%eax)
  8022e9:	eb 08                	jmp    8022f3 <insert_sorted_allocList+0xdf>
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	a3 44 40 80 00       	mov    %eax,0x804044
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802304:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802309:	40                   	inc    %eax
  80230a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80230f:	e9 5a 01 00 00       	jmp    80246e <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	8b 50 08             	mov    0x8(%eax),%edx
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	8b 40 08             	mov    0x8(%eax),%eax
  802320:	39 c2                	cmp    %eax,%edx
  802322:	75 70                	jne    802394 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802324:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802328:	74 06                	je     802330 <insert_sorted_allocList+0x11c>
  80232a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80232e:	75 14                	jne    802344 <insert_sorted_allocList+0x130>
  802330:	83 ec 04             	sub    $0x4,%esp
  802333:	68 74 3b 80 00       	push   $0x803b74
  802338:	6a 75                	push   $0x75
  80233a:	68 37 3b 80 00       	push   $0x803b37
  80233f:	e8 26 e0 ff ff       	call   80036a <_panic>
  802344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802347:	8b 10                	mov    (%eax),%edx
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	89 10                	mov    %edx,(%eax)
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8b 00                	mov    (%eax),%eax
  802353:	85 c0                	test   %eax,%eax
  802355:	74 0b                	je     802362 <insert_sorted_allocList+0x14e>
  802357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	8b 55 08             	mov    0x8(%ebp),%edx
  80235f:	89 50 04             	mov    %edx,0x4(%eax)
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	8b 55 08             	mov    0x8(%ebp),%edx
  802368:	89 10                	mov    %edx,(%eax)
  80236a:	8b 45 08             	mov    0x8(%ebp),%eax
  80236d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802370:	89 50 04             	mov    %edx,0x4(%eax)
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	8b 00                	mov    (%eax),%eax
  802378:	85 c0                	test   %eax,%eax
  80237a:	75 08                	jne    802384 <insert_sorted_allocList+0x170>
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	a3 44 40 80 00       	mov    %eax,0x804044
  802384:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802389:	40                   	inc    %eax
  80238a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80238f:	e9 da 00 00 00       	jmp    80246e <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802394:	a1 40 40 80 00       	mov    0x804040,%eax
  802399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239c:	e9 9d 00 00 00       	jmp    80243e <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 00                	mov    (%eax),%eax
  8023a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	8b 50 08             	mov    0x8(%eax),%edx
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 40 08             	mov    0x8(%eax),%eax
  8023b5:	39 c2                	cmp    %eax,%edx
  8023b7:	76 7d                	jbe    802436 <insert_sorted_allocList+0x222>
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	8b 50 08             	mov    0x8(%eax),%edx
  8023bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c2:	8b 40 08             	mov    0x8(%eax),%eax
  8023c5:	39 c2                	cmp    %eax,%edx
  8023c7:	73 6d                	jae    802436 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8023c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cd:	74 06                	je     8023d5 <insert_sorted_allocList+0x1c1>
  8023cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023d3:	75 14                	jne    8023e9 <insert_sorted_allocList+0x1d5>
  8023d5:	83 ec 04             	sub    $0x4,%esp
  8023d8:	68 74 3b 80 00       	push   $0x803b74
  8023dd:	6a 7c                	push   $0x7c
  8023df:	68 37 3b 80 00       	push   $0x803b37
  8023e4:	e8 81 df ff ff       	call   80036a <_panic>
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 10                	mov    (%eax),%edx
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	89 10                	mov    %edx,(%eax)
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	74 0b                	je     802407 <insert_sorted_allocList+0x1f3>
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	8b 55 08             	mov    0x8(%ebp),%edx
  802404:	89 50 04             	mov    %edx,0x4(%eax)
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 55 08             	mov    0x8(%ebp),%edx
  80240d:	89 10                	mov    %edx,(%eax)
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802415:	89 50 04             	mov    %edx,0x4(%eax)
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	85 c0                	test   %eax,%eax
  80241f:	75 08                	jne    802429 <insert_sorted_allocList+0x215>
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	a3 44 40 80 00       	mov    %eax,0x804044
  802429:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80242e:	40                   	inc    %eax
  80242f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802434:	eb 38                	jmp    80246e <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802436:	a1 48 40 80 00       	mov    0x804048,%eax
  80243b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802442:	74 07                	je     80244b <insert_sorted_allocList+0x237>
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	eb 05                	jmp    802450 <insert_sorted_allocList+0x23c>
  80244b:	b8 00 00 00 00       	mov    $0x0,%eax
  802450:	a3 48 40 80 00       	mov    %eax,0x804048
  802455:	a1 48 40 80 00       	mov    0x804048,%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	0f 85 3f ff ff ff    	jne    8023a1 <insert_sorted_allocList+0x18d>
  802462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802466:	0f 85 35 ff ff ff    	jne    8023a1 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80246c:	eb 00                	jmp    80246e <insert_sorted_allocList+0x25a>
  80246e:	90                   	nop
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802477:	a1 38 41 80 00       	mov    0x804138,%eax
  80247c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247f:	e9 6b 02 00 00       	jmp    8026ef <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248d:	0f 85 90 00 00 00    	jne    802523 <alloc_block_FF+0xb2>
			  temp=element;
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249d:	75 17                	jne    8024b6 <alloc_block_FF+0x45>
  80249f:	83 ec 04             	sub    $0x4,%esp
  8024a2:	68 a8 3b 80 00       	push   $0x803ba8
  8024a7:	68 92 00 00 00       	push   $0x92
  8024ac:	68 37 3b 80 00       	push   $0x803b37
  8024b1:	e8 b4 de ff ff       	call   80036a <_panic>
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 00                	mov    (%eax),%eax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	74 10                	je     8024cf <alloc_block_FF+0x5e>
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c7:	8b 52 04             	mov    0x4(%edx),%edx
  8024ca:	89 50 04             	mov    %edx,0x4(%eax)
  8024cd:	eb 0b                	jmp    8024da <alloc_block_FF+0x69>
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 40 04             	mov    0x4(%eax),%eax
  8024d5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 40 04             	mov    0x4(%eax),%eax
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	74 0f                	je     8024f3 <alloc_block_FF+0x82>
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ed:	8b 12                	mov    (%edx),%edx
  8024ef:	89 10                	mov    %edx,(%eax)
  8024f1:	eb 0a                	jmp    8024fd <alloc_block_FF+0x8c>
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	8b 00                	mov    (%eax),%eax
  8024f8:	a3 38 41 80 00       	mov    %eax,0x804138
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802510:	a1 44 41 80 00       	mov    0x804144,%eax
  802515:	48                   	dec    %eax
  802516:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80251b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80251e:	e9 ff 01 00 00       	jmp    802722 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 40 0c             	mov    0xc(%eax),%eax
  802529:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252c:	0f 86 b5 01 00 00    	jbe    8026e7 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 40 0c             	mov    0xc(%eax),%eax
  802538:	2b 45 08             	sub    0x8(%ebp),%eax
  80253b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80253e:	a1 48 41 80 00       	mov    0x804148,%eax
  802543:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802546:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80254a:	75 17                	jne    802563 <alloc_block_FF+0xf2>
  80254c:	83 ec 04             	sub    $0x4,%esp
  80254f:	68 a8 3b 80 00       	push   $0x803ba8
  802554:	68 99 00 00 00       	push   $0x99
  802559:	68 37 3b 80 00       	push   $0x803b37
  80255e:	e8 07 de ff ff       	call   80036a <_panic>
  802563:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802566:	8b 00                	mov    (%eax),%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	74 10                	je     80257c <alloc_block_FF+0x10b>
  80256c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802574:	8b 52 04             	mov    0x4(%edx),%edx
  802577:	89 50 04             	mov    %edx,0x4(%eax)
  80257a:	eb 0b                	jmp    802587 <alloc_block_FF+0x116>
  80257c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257f:	8b 40 04             	mov    0x4(%eax),%eax
  802582:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	85 c0                	test   %eax,%eax
  80258f:	74 0f                	je     8025a0 <alloc_block_FF+0x12f>
  802591:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802594:	8b 40 04             	mov    0x4(%eax),%eax
  802597:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259a:	8b 12                	mov    (%edx),%edx
  80259c:	89 10                	mov    %edx,(%eax)
  80259e:	eb 0a                	jmp    8025aa <alloc_block_FF+0x139>
  8025a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a3:	8b 00                	mov    (%eax),%eax
  8025a5:	a3 48 41 80 00       	mov    %eax,0x804148
  8025aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025bd:	a1 54 41 80 00       	mov    0x804154,%eax
  8025c2:	48                   	dec    %eax
  8025c3:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8025c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025cc:	75 17                	jne    8025e5 <alloc_block_FF+0x174>
  8025ce:	83 ec 04             	sub    $0x4,%esp
  8025d1:	68 50 3b 80 00       	push   $0x803b50
  8025d6:	68 9a 00 00 00       	push   $0x9a
  8025db:	68 37 3b 80 00       	push   $0x803b37
  8025e0:	e8 85 dd ff ff       	call   80036a <_panic>
  8025e5:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8025eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ee:	89 50 04             	mov    %edx,0x4(%eax)
  8025f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f4:	8b 40 04             	mov    0x4(%eax),%eax
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	74 0c                	je     802607 <alloc_block_FF+0x196>
  8025fb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802600:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802603:	89 10                	mov    %edx,(%eax)
  802605:	eb 08                	jmp    80260f <alloc_block_FF+0x19e>
  802607:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260a:	a3 38 41 80 00       	mov    %eax,0x804138
  80260f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802612:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802620:	a1 44 41 80 00       	mov    0x804144,%eax
  802625:	40                   	inc    %eax
  802626:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  80262b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262e:	8b 55 08             	mov    0x8(%ebp),%edx
  802631:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 50 08             	mov    0x8(%eax),%edx
  80263a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263d:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802646:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 50 08             	mov    0x8(%eax),%edx
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	01 c2                	add    %eax,%edx
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  80265a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802660:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802664:	75 17                	jne    80267d <alloc_block_FF+0x20c>
  802666:	83 ec 04             	sub    $0x4,%esp
  802669:	68 a8 3b 80 00       	push   $0x803ba8
  80266e:	68 a2 00 00 00       	push   $0xa2
  802673:	68 37 3b 80 00       	push   $0x803b37
  802678:	e8 ed dc ff ff       	call   80036a <_panic>
  80267d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 10                	je     802696 <alloc_block_FF+0x225>
  802686:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80268e:	8b 52 04             	mov    0x4(%edx),%edx
  802691:	89 50 04             	mov    %edx,0x4(%eax)
  802694:	eb 0b                	jmp    8026a1 <alloc_block_FF+0x230>
  802696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802699:	8b 40 04             	mov    0x4(%eax),%eax
  80269c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a4:	8b 40 04             	mov    0x4(%eax),%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	74 0f                	je     8026ba <alloc_block_FF+0x249>
  8026ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b4:	8b 12                	mov    (%edx),%edx
  8026b6:	89 10                	mov    %edx,(%eax)
  8026b8:	eb 0a                	jmp    8026c4 <alloc_block_FF+0x253>
  8026ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	a3 38 41 80 00       	mov    %eax,0x804138
  8026c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d7:	a1 44 41 80 00       	mov    0x804144,%eax
  8026dc:	48                   	dec    %eax
  8026dd:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  8026e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e5:	eb 3b                	jmp    802722 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8026e7:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	74 07                	je     8026fc <alloc_block_FF+0x28b>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	eb 05                	jmp    802701 <alloc_block_FF+0x290>
  8026fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802701:	a3 40 41 80 00       	mov    %eax,0x804140
  802706:	a1 40 41 80 00       	mov    0x804140,%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	0f 85 71 fd ff ff    	jne    802484 <alloc_block_FF+0x13>
  802713:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802717:	0f 85 67 fd ff ff    	jne    802484 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80272a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802731:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802738:	a1 38 41 80 00       	mov    0x804138,%eax
  80273d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802740:	e9 d3 00 00 00       	jmp    802818 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802745:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802748:	8b 40 0c             	mov    0xc(%eax),%eax
  80274b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274e:	0f 85 90 00 00 00    	jne    8027e4 <alloc_block_BF+0xc0>
	   temp = element;
  802754:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802757:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80275a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80275e:	75 17                	jne    802777 <alloc_block_BF+0x53>
  802760:	83 ec 04             	sub    $0x4,%esp
  802763:	68 a8 3b 80 00       	push   $0x803ba8
  802768:	68 bd 00 00 00       	push   $0xbd
  80276d:	68 37 3b 80 00       	push   $0x803b37
  802772:	e8 f3 db ff ff       	call   80036a <_panic>
  802777:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	85 c0                	test   %eax,%eax
  80277e:	74 10                	je     802790 <alloc_block_BF+0x6c>
  802780:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802788:	8b 52 04             	mov    0x4(%edx),%edx
  80278b:	89 50 04             	mov    %edx,0x4(%eax)
  80278e:	eb 0b                	jmp    80279b <alloc_block_BF+0x77>
  802790:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802793:	8b 40 04             	mov    0x4(%eax),%eax
  802796:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80279b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279e:	8b 40 04             	mov    0x4(%eax),%eax
  8027a1:	85 c0                	test   %eax,%eax
  8027a3:	74 0f                	je     8027b4 <alloc_block_BF+0x90>
  8027a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a8:	8b 40 04             	mov    0x4(%eax),%eax
  8027ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ae:	8b 12                	mov    (%edx),%edx
  8027b0:	89 10                	mov    %edx,(%eax)
  8027b2:	eb 0a                	jmp    8027be <alloc_block_BF+0x9a>
  8027b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b7:	8b 00                	mov    (%eax),%eax
  8027b9:	a3 38 41 80 00       	mov    %eax,0x804138
  8027be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d1:	a1 44 41 80 00       	mov    0x804144,%eax
  8027d6:	48                   	dec    %eax
  8027d7:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8027dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027df:	e9 41 01 00 00       	jmp    802925 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8027e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ed:	76 21                	jbe    802810 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8027ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027f8:	73 16                	jae    802810 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8027fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802800:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802806:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802809:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802810:	a1 40 41 80 00       	mov    0x804140,%eax
  802815:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802818:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80281c:	74 07                	je     802825 <alloc_block_BF+0x101>
  80281e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	eb 05                	jmp    80282a <alloc_block_BF+0x106>
  802825:	b8 00 00 00 00       	mov    $0x0,%eax
  80282a:	a3 40 41 80 00       	mov    %eax,0x804140
  80282f:	a1 40 41 80 00       	mov    0x804140,%eax
  802834:	85 c0                	test   %eax,%eax
  802836:	0f 85 09 ff ff ff    	jne    802745 <alloc_block_BF+0x21>
  80283c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802840:	0f 85 ff fe ff ff    	jne    802745 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802846:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80284a:	0f 85 d0 00 00 00    	jne    802920 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802850:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802853:	8b 40 0c             	mov    0xc(%eax),%eax
  802856:	2b 45 08             	sub    0x8(%ebp),%eax
  802859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80285c:	a1 48 41 80 00       	mov    0x804148,%eax
  802861:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802868:	75 17                	jne    802881 <alloc_block_BF+0x15d>
  80286a:	83 ec 04             	sub    $0x4,%esp
  80286d:	68 a8 3b 80 00       	push   $0x803ba8
  802872:	68 d1 00 00 00       	push   $0xd1
  802877:	68 37 3b 80 00       	push   $0x803b37
  80287c:	e8 e9 da ff ff       	call   80036a <_panic>
  802881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	85 c0                	test   %eax,%eax
  802888:	74 10                	je     80289a <alloc_block_BF+0x176>
  80288a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288d:	8b 00                	mov    (%eax),%eax
  80288f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802892:	8b 52 04             	mov    0x4(%edx),%edx
  802895:	89 50 04             	mov    %edx,0x4(%eax)
  802898:	eb 0b                	jmp    8028a5 <alloc_block_BF+0x181>
  80289a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a8:	8b 40 04             	mov    0x4(%eax),%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	74 0f                	je     8028be <alloc_block_BF+0x19a>
  8028af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b2:	8b 40 04             	mov    0x4(%eax),%eax
  8028b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028b8:	8b 12                	mov    (%edx),%edx
  8028ba:	89 10                	mov    %edx,(%eax)
  8028bc:	eb 0a                	jmp    8028c8 <alloc_block_BF+0x1a4>
  8028be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c1:	8b 00                	mov    (%eax),%eax
  8028c3:	a3 48 41 80 00       	mov    %eax,0x804148
  8028c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028db:	a1 54 41 80 00       	mov    0x804154,%eax
  8028e0:	48                   	dec    %eax
  8028e1:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8028e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ec:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  8028ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f2:	8b 50 08             	mov    0x8(%eax),%edx
  8028f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f8:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  8028fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802901:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802907:	8b 50 08             	mov    0x8(%eax),%edx
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	01 c2                	add    %eax,%edx
  80290f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802912:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802915:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802918:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80291b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80291e:	eb 05                	jmp    802925 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802920:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802925:	c9                   	leave  
  802926:	c3                   	ret    

00802927 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802927:	55                   	push   %ebp
  802928:	89 e5                	mov    %esp,%ebp
  80292a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80292d:	83 ec 04             	sub    $0x4,%esp
  802930:	68 c8 3b 80 00       	push   $0x803bc8
  802935:	68 e8 00 00 00       	push   $0xe8
  80293a:	68 37 3b 80 00       	push   $0x803b37
  80293f:	e8 26 da ff ff       	call   80036a <_panic>

00802944 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  80294a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80294f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802952:	a1 38 41 80 00       	mov    0x804138,%eax
  802957:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  80295a:	a1 44 41 80 00       	mov    0x804144,%eax
  80295f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802962:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802966:	75 68                	jne    8029d0 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802968:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80296c:	75 17                	jne    802985 <insert_sorted_with_merge_freeList+0x41>
  80296e:	83 ec 04             	sub    $0x4,%esp
  802971:	68 14 3b 80 00       	push   $0x803b14
  802976:	68 36 01 00 00       	push   $0x136
  80297b:	68 37 3b 80 00       	push   $0x803b37
  802980:	e8 e5 d9 ff ff       	call   80036a <_panic>
  802985:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	89 10                	mov    %edx,(%eax)
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	8b 00                	mov    (%eax),%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	74 0d                	je     8029a6 <insert_sorted_with_merge_freeList+0x62>
  802999:	a1 38 41 80 00       	mov    0x804138,%eax
  80299e:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a1:	89 50 04             	mov    %edx,0x4(%eax)
  8029a4:	eb 08                	jmp    8029ae <insert_sorted_with_merge_freeList+0x6a>
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	a3 38 41 80 00       	mov    %eax,0x804138
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c0:	a1 44 41 80 00       	mov    0x804144,%eax
  8029c5:	40                   	inc    %eax
  8029c6:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8029cb:	e9 ba 06 00 00       	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	8b 50 08             	mov    0x8(%eax),%edx
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dc:	01 c2                	add    %eax,%edx
  8029de:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e1:	8b 40 08             	mov    0x8(%eax),%eax
  8029e4:	39 c2                	cmp    %eax,%edx
  8029e6:	73 68                	jae    802a50 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8029e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ec:	75 17                	jne    802a05 <insert_sorted_with_merge_freeList+0xc1>
  8029ee:	83 ec 04             	sub    $0x4,%esp
  8029f1:	68 50 3b 80 00       	push   $0x803b50
  8029f6:	68 3a 01 00 00       	push   $0x13a
  8029fb:	68 37 3b 80 00       	push   $0x803b37
  802a00:	e8 65 d9 ff ff       	call   80036a <_panic>
  802a05:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 0c                	je     802a27 <insert_sorted_with_merge_freeList+0xe3>
  802a1b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a20:	8b 55 08             	mov    0x8(%ebp),%edx
  802a23:	89 10                	mov    %edx,(%eax)
  802a25:	eb 08                	jmp    802a2f <insert_sorted_with_merge_freeList+0xeb>
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	a3 38 41 80 00       	mov    %eax,0x804138
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a40:	a1 44 41 80 00       	mov    0x804144,%eax
  802a45:	40                   	inc    %eax
  802a46:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a4b:	e9 3a 06 00 00       	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a53:	8b 50 08             	mov    0x8(%eax),%edx
  802a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a59:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5c:	01 c2                	add    %eax,%edx
  802a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a61:	8b 40 08             	mov    0x8(%eax),%eax
  802a64:	39 c2                	cmp    %eax,%edx
  802a66:	0f 85 90 00 00 00    	jne    802afc <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6f:	8b 50 0c             	mov    0xc(%eax),%edx
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	8b 40 0c             	mov    0xc(%eax),%eax
  802a78:	01 c2                	add    %eax,%edx
  802a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7d:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802a94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a98:	75 17                	jne    802ab1 <insert_sorted_with_merge_freeList+0x16d>
  802a9a:	83 ec 04             	sub    $0x4,%esp
  802a9d:	68 14 3b 80 00       	push   $0x803b14
  802aa2:	68 41 01 00 00       	push   $0x141
  802aa7:	68 37 3b 80 00       	push   $0x803b37
  802aac:	e8 b9 d8 ff ff       	call   80036a <_panic>
  802ab1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	89 10                	mov    %edx,(%eax)
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	74 0d                	je     802ad2 <insert_sorted_with_merge_freeList+0x18e>
  802ac5:	a1 48 41 80 00       	mov    0x804148,%eax
  802aca:	8b 55 08             	mov    0x8(%ebp),%edx
  802acd:	89 50 04             	mov    %edx,0x4(%eax)
  802ad0:	eb 08                	jmp    802ada <insert_sorted_with_merge_freeList+0x196>
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	a3 48 41 80 00       	mov    %eax,0x804148
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aec:	a1 54 41 80 00       	mov    0x804154,%eax
  802af1:	40                   	inc    %eax
  802af2:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802af7:	e9 8e 05 00 00       	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	8b 50 08             	mov    0x8(%eax),%edx
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 40 0c             	mov    0xc(%eax),%eax
  802b08:	01 c2                	add    %eax,%edx
  802b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0d:	8b 40 08             	mov    0x8(%eax),%eax
  802b10:	39 c2                	cmp    %eax,%edx
  802b12:	73 68                	jae    802b7c <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b18:	75 17                	jne    802b31 <insert_sorted_with_merge_freeList+0x1ed>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 14 3b 80 00       	push   $0x803b14
  802b22:	68 45 01 00 00       	push   $0x145
  802b27:	68 37 3b 80 00       	push   $0x803b37
  802b2c:	e8 39 d8 ff ff       	call   80036a <_panic>
  802b31:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	89 10                	mov    %edx,(%eax)
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 0d                	je     802b52 <insert_sorted_with_merge_freeList+0x20e>
  802b45:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4d:	89 50 04             	mov    %edx,0x4(%eax)
  802b50:	eb 08                	jmp    802b5a <insert_sorted_with_merge_freeList+0x216>
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	a3 38 41 80 00       	mov    %eax,0x804138
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6c:	a1 44 41 80 00       	mov    0x804144,%eax
  802b71:	40                   	inc    %eax
  802b72:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b77:	e9 0e 05 00 00       	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8b 50 08             	mov    0x8(%eax),%edx
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 40 0c             	mov    0xc(%eax),%eax
  802b88:	01 c2                	add    %eax,%edx
  802b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8d:	8b 40 08             	mov    0x8(%eax),%eax
  802b90:	39 c2                	cmp    %eax,%edx
  802b92:	0f 85 9c 00 00 00    	jne    802c34 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	01 c2                	add    %eax,%edx
  802ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba9:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	8b 50 08             	mov    0x8(%eax),%edx
  802bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb5:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd0:	75 17                	jne    802be9 <insert_sorted_with_merge_freeList+0x2a5>
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	68 14 3b 80 00       	push   $0x803b14
  802bda:	68 4d 01 00 00       	push   $0x14d
  802bdf:	68 37 3b 80 00       	push   $0x803b37
  802be4:	e8 81 d7 ff ff       	call   80036a <_panic>
  802be9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	89 10                	mov    %edx,(%eax)
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 0d                	je     802c0a <insert_sorted_with_merge_freeList+0x2c6>
  802bfd:	a1 48 41 80 00       	mov    0x804148,%eax
  802c02:	8b 55 08             	mov    0x8(%ebp),%edx
  802c05:	89 50 04             	mov    %edx,0x4(%eax)
  802c08:	eb 08                	jmp    802c12 <insert_sorted_with_merge_freeList+0x2ce>
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	a3 48 41 80 00       	mov    %eax,0x804148
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c24:	a1 54 41 80 00       	mov    0x804154,%eax
  802c29:	40                   	inc    %eax
  802c2a:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c2f:	e9 56 04 00 00       	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802c34:	a1 38 41 80 00       	mov    0x804138,%eax
  802c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3c:	e9 19 04 00 00       	jmp    80305a <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 50 08             	mov    0x8(%eax),%edx
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 0c             	mov    0xc(%eax),%eax
  802c55:	01 c2                	add    %eax,%edx
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	39 c2                	cmp    %eax,%edx
  802c5f:	0f 85 ad 01 00 00    	jne    802e12 <insert_sorted_with_merge_freeList+0x4ce>
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	8b 50 08             	mov    0x8(%eax),%edx
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c71:	01 c2                	add    %eax,%edx
  802c73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c76:	8b 40 08             	mov    0x8(%eax),%eax
  802c79:	39 c2                	cmp    %eax,%edx
  802c7b:	0f 85 91 01 00 00    	jne    802e12 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 50 0c             	mov    0xc(%eax),%edx
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c90:	8b 40 0c             	mov    0xc(%eax),%eax
  802c93:	01 c8                	add    %ecx,%eax
  802c95:	01 c2                	add    %eax,%edx
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802cc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cc9:	75 17                	jne    802ce2 <insert_sorted_with_merge_freeList+0x39e>
  802ccb:	83 ec 04             	sub    $0x4,%esp
  802cce:	68 a8 3b 80 00       	push   $0x803ba8
  802cd3:	68 5b 01 00 00       	push   $0x15b
  802cd8:	68 37 3b 80 00       	push   $0x803b37
  802cdd:	e8 88 d6 ff ff       	call   80036a <_panic>
  802ce2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	74 10                	je     802cfb <insert_sorted_with_merge_freeList+0x3b7>
  802ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cf3:	8b 52 04             	mov    0x4(%edx),%edx
  802cf6:	89 50 04             	mov    %edx,0x4(%eax)
  802cf9:	eb 0b                	jmp    802d06 <insert_sorted_with_merge_freeList+0x3c2>
  802cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	74 0f                	je     802d1f <insert_sorted_with_merge_freeList+0x3db>
  802d10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d19:	8b 12                	mov    (%edx),%edx
  802d1b:	89 10                	mov    %edx,(%eax)
  802d1d:	eb 0a                	jmp    802d29 <insert_sorted_with_merge_freeList+0x3e5>
  802d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	a3 38 41 80 00       	mov    %eax,0x804138
  802d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3c:	a1 44 41 80 00       	mov    0x804144,%eax
  802d41:	48                   	dec    %eax
  802d42:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4b:	75 17                	jne    802d64 <insert_sorted_with_merge_freeList+0x420>
  802d4d:	83 ec 04             	sub    $0x4,%esp
  802d50:	68 14 3b 80 00       	push   $0x803b14
  802d55:	68 5c 01 00 00       	push   $0x15c
  802d5a:	68 37 3b 80 00       	push   $0x803b37
  802d5f:	e8 06 d6 ff ff       	call   80036a <_panic>
  802d64:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	89 10                	mov    %edx,(%eax)
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	74 0d                	je     802d85 <insert_sorted_with_merge_freeList+0x441>
  802d78:	a1 48 41 80 00       	mov    0x804148,%eax
  802d7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d80:	89 50 04             	mov    %edx,0x4(%eax)
  802d83:	eb 08                	jmp    802d8d <insert_sorted_with_merge_freeList+0x449>
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	a3 48 41 80 00       	mov    %eax,0x804148
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9f:	a1 54 41 80 00       	mov    0x804154,%eax
  802da4:	40                   	inc    %eax
  802da5:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802daa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dae:	75 17                	jne    802dc7 <insert_sorted_with_merge_freeList+0x483>
  802db0:	83 ec 04             	sub    $0x4,%esp
  802db3:	68 14 3b 80 00       	push   $0x803b14
  802db8:	68 5d 01 00 00       	push   $0x15d
  802dbd:	68 37 3b 80 00       	push   $0x803b37
  802dc2:	e8 a3 d5 ff ff       	call   80036a <_panic>
  802dc7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd0:	89 10                	mov    %edx,(%eax)
  802dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0d                	je     802de8 <insert_sorted_with_merge_freeList+0x4a4>
  802ddb:	a1 48 41 80 00       	mov    0x804148,%eax
  802de0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802de3:	89 50 04             	mov    %edx,0x4(%eax)
  802de6:	eb 08                	jmp    802df0 <insert_sorted_with_merge_freeList+0x4ac>
  802de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802deb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df3:	a3 48 41 80 00       	mov    %eax,0x804148
  802df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e02:	a1 54 41 80 00       	mov    0x804154,%eax
  802e07:	40                   	inc    %eax
  802e08:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e0d:	e9 78 02 00 00       	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 50 08             	mov    0x8(%eax),%edx
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1e:	01 c2                	add    %eax,%edx
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	8b 40 08             	mov    0x8(%eax),%eax
  802e26:	39 c2                	cmp    %eax,%edx
  802e28:	0f 83 b8 00 00 00    	jae    802ee6 <insert_sorted_with_merge_freeList+0x5a2>
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 50 08             	mov    0x8(%eax),%edx
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3a:	01 c2                	add    %eax,%edx
  802e3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3f:	8b 40 08             	mov    0x8(%eax),%eax
  802e42:	39 c2                	cmp    %eax,%edx
  802e44:	0f 85 9c 00 00 00    	jne    802ee6 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e4d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	8b 40 0c             	mov    0xc(%eax),%eax
  802e56:	01 c2                	add    %eax,%edx
  802e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5b:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	8b 50 08             	mov    0x8(%eax),%edx
  802e64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e67:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e82:	75 17                	jne    802e9b <insert_sorted_with_merge_freeList+0x557>
  802e84:	83 ec 04             	sub    $0x4,%esp
  802e87:	68 14 3b 80 00       	push   $0x803b14
  802e8c:	68 67 01 00 00       	push   $0x167
  802e91:	68 37 3b 80 00       	push   $0x803b37
  802e96:	e8 cf d4 ff ff       	call   80036a <_panic>
  802e9b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	89 10                	mov    %edx,(%eax)
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	85 c0                	test   %eax,%eax
  802ead:	74 0d                	je     802ebc <insert_sorted_with_merge_freeList+0x578>
  802eaf:	a1 48 41 80 00       	mov    0x804148,%eax
  802eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb7:	89 50 04             	mov    %edx,0x4(%eax)
  802eba:	eb 08                	jmp    802ec4 <insert_sorted_with_merge_freeList+0x580>
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	a3 48 41 80 00       	mov    %eax,0x804148
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed6:	a1 54 41 80 00       	mov    0x804154,%eax
  802edb:	40                   	inc    %eax
  802edc:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802ee1:	e9 a4 01 00 00       	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 50 08             	mov    0x8(%eax),%edx
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef2:	01 c2                	add    %eax,%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 40 08             	mov    0x8(%eax),%eax
  802efa:	39 c2                	cmp    %eax,%edx
  802efc:	0f 85 ac 00 00 00    	jne    802fae <insert_sorted_with_merge_freeList+0x66a>
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	8b 50 08             	mov    0x8(%eax),%edx
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0e:	01 c2                	add    %eax,%edx
  802f10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f13:	8b 40 08             	mov    0x8(%eax),%eax
  802f16:	39 c2                	cmp    %eax,%edx
  802f18:	0f 83 90 00 00 00    	jae    802fae <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 50 0c             	mov    0xc(%eax),%edx
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2a:	01 c2                	add    %eax,%edx
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4a:	75 17                	jne    802f63 <insert_sorted_with_merge_freeList+0x61f>
  802f4c:	83 ec 04             	sub    $0x4,%esp
  802f4f:	68 14 3b 80 00       	push   $0x803b14
  802f54:	68 70 01 00 00       	push   $0x170
  802f59:	68 37 3b 80 00       	push   $0x803b37
  802f5e:	e8 07 d4 ff ff       	call   80036a <_panic>
  802f63:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	89 10                	mov    %edx,(%eax)
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	85 c0                	test   %eax,%eax
  802f75:	74 0d                	je     802f84 <insert_sorted_with_merge_freeList+0x640>
  802f77:	a1 48 41 80 00       	mov    0x804148,%eax
  802f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7f:	89 50 04             	mov    %edx,0x4(%eax)
  802f82:	eb 08                	jmp    802f8c <insert_sorted_with_merge_freeList+0x648>
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	a3 48 41 80 00       	mov    %eax,0x804148
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9e:	a1 54 41 80 00       	mov    0x804154,%eax
  802fa3:	40                   	inc    %eax
  802fa4:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802fa9:	e9 dc 00 00 00       	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 50 08             	mov    0x8(%eax),%edx
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fba:	01 c2                	add    %eax,%edx
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	8b 40 08             	mov    0x8(%eax),%eax
  802fc2:	39 c2                	cmp    %eax,%edx
  802fc4:	0f 83 88 00 00 00    	jae    803052 <insert_sorted_with_merge_freeList+0x70e>
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	8b 50 08             	mov    0x8(%eax),%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd6:	01 c2                	add    %eax,%edx
  802fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fdb:	8b 40 08             	mov    0x8(%eax),%eax
  802fde:	39 c2                	cmp    %eax,%edx
  802fe0:	73 70                	jae    803052 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe6:	74 06                	je     802fee <insert_sorted_with_merge_freeList+0x6aa>
  802fe8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fec:	75 17                	jne    803005 <insert_sorted_with_merge_freeList+0x6c1>
  802fee:	83 ec 04             	sub    $0x4,%esp
  802ff1:	68 74 3b 80 00       	push   $0x803b74
  802ff6:	68 75 01 00 00       	push   $0x175
  802ffb:	68 37 3b 80 00       	push   $0x803b37
  803000:	e8 65 d3 ff ff       	call   80036a <_panic>
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	8b 10                	mov    (%eax),%edx
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	89 10                	mov    %edx,(%eax)
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	8b 00                	mov    (%eax),%eax
  803014:	85 c0                	test   %eax,%eax
  803016:	74 0b                	je     803023 <insert_sorted_with_merge_freeList+0x6df>
  803018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	8b 55 08             	mov    0x8(%ebp),%edx
  803020:	89 50 04             	mov    %edx,0x4(%eax)
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 55 08             	mov    0x8(%ebp),%edx
  803029:	89 10                	mov    %edx,(%eax)
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803031:	89 50 04             	mov    %edx,0x4(%eax)
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	8b 00                	mov    (%eax),%eax
  803039:	85 c0                	test   %eax,%eax
  80303b:	75 08                	jne    803045 <insert_sorted_with_merge_freeList+0x701>
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803045:	a1 44 41 80 00       	mov    0x804144,%eax
  80304a:	40                   	inc    %eax
  80304b:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  803050:	eb 38                	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803052:	a1 40 41 80 00       	mov    0x804140,%eax
  803057:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80305a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305e:	74 07                	je     803067 <insert_sorted_with_merge_freeList+0x723>
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	eb 05                	jmp    80306c <insert_sorted_with_merge_freeList+0x728>
  803067:	b8 00 00 00 00       	mov    $0x0,%eax
  80306c:	a3 40 41 80 00       	mov    %eax,0x804140
  803071:	a1 40 41 80 00       	mov    0x804140,%eax
  803076:	85 c0                	test   %eax,%eax
  803078:	0f 85 c3 fb ff ff    	jne    802c41 <insert_sorted_with_merge_freeList+0x2fd>
  80307e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803082:	0f 85 b9 fb ff ff    	jne    802c41 <insert_sorted_with_merge_freeList+0x2fd>





}
  803088:	eb 00                	jmp    80308a <insert_sorted_with_merge_freeList+0x746>
  80308a:	90                   	nop
  80308b:	c9                   	leave  
  80308c:	c3                   	ret    
  80308d:	66 90                	xchg   %ax,%ax
  80308f:	90                   	nop

00803090 <__udivdi3>:
  803090:	55                   	push   %ebp
  803091:	57                   	push   %edi
  803092:	56                   	push   %esi
  803093:	53                   	push   %ebx
  803094:	83 ec 1c             	sub    $0x1c,%esp
  803097:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80309b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80309f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030a7:	89 ca                	mov    %ecx,%edx
  8030a9:	89 f8                	mov    %edi,%eax
  8030ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030af:	85 f6                	test   %esi,%esi
  8030b1:	75 2d                	jne    8030e0 <__udivdi3+0x50>
  8030b3:	39 cf                	cmp    %ecx,%edi
  8030b5:	77 65                	ja     80311c <__udivdi3+0x8c>
  8030b7:	89 fd                	mov    %edi,%ebp
  8030b9:	85 ff                	test   %edi,%edi
  8030bb:	75 0b                	jne    8030c8 <__udivdi3+0x38>
  8030bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c2:	31 d2                	xor    %edx,%edx
  8030c4:	f7 f7                	div    %edi
  8030c6:	89 c5                	mov    %eax,%ebp
  8030c8:	31 d2                	xor    %edx,%edx
  8030ca:	89 c8                	mov    %ecx,%eax
  8030cc:	f7 f5                	div    %ebp
  8030ce:	89 c1                	mov    %eax,%ecx
  8030d0:	89 d8                	mov    %ebx,%eax
  8030d2:	f7 f5                	div    %ebp
  8030d4:	89 cf                	mov    %ecx,%edi
  8030d6:	89 fa                	mov    %edi,%edx
  8030d8:	83 c4 1c             	add    $0x1c,%esp
  8030db:	5b                   	pop    %ebx
  8030dc:	5e                   	pop    %esi
  8030dd:	5f                   	pop    %edi
  8030de:	5d                   	pop    %ebp
  8030df:	c3                   	ret    
  8030e0:	39 ce                	cmp    %ecx,%esi
  8030e2:	77 28                	ja     80310c <__udivdi3+0x7c>
  8030e4:	0f bd fe             	bsr    %esi,%edi
  8030e7:	83 f7 1f             	xor    $0x1f,%edi
  8030ea:	75 40                	jne    80312c <__udivdi3+0x9c>
  8030ec:	39 ce                	cmp    %ecx,%esi
  8030ee:	72 0a                	jb     8030fa <__udivdi3+0x6a>
  8030f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030f4:	0f 87 9e 00 00 00    	ja     803198 <__udivdi3+0x108>
  8030fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ff:	89 fa                	mov    %edi,%edx
  803101:	83 c4 1c             	add    $0x1c,%esp
  803104:	5b                   	pop    %ebx
  803105:	5e                   	pop    %esi
  803106:	5f                   	pop    %edi
  803107:	5d                   	pop    %ebp
  803108:	c3                   	ret    
  803109:	8d 76 00             	lea    0x0(%esi),%esi
  80310c:	31 ff                	xor    %edi,%edi
  80310e:	31 c0                	xor    %eax,%eax
  803110:	89 fa                	mov    %edi,%edx
  803112:	83 c4 1c             	add    $0x1c,%esp
  803115:	5b                   	pop    %ebx
  803116:	5e                   	pop    %esi
  803117:	5f                   	pop    %edi
  803118:	5d                   	pop    %ebp
  803119:	c3                   	ret    
  80311a:	66 90                	xchg   %ax,%ax
  80311c:	89 d8                	mov    %ebx,%eax
  80311e:	f7 f7                	div    %edi
  803120:	31 ff                	xor    %edi,%edi
  803122:	89 fa                	mov    %edi,%edx
  803124:	83 c4 1c             	add    $0x1c,%esp
  803127:	5b                   	pop    %ebx
  803128:	5e                   	pop    %esi
  803129:	5f                   	pop    %edi
  80312a:	5d                   	pop    %ebp
  80312b:	c3                   	ret    
  80312c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803131:	89 eb                	mov    %ebp,%ebx
  803133:	29 fb                	sub    %edi,%ebx
  803135:	89 f9                	mov    %edi,%ecx
  803137:	d3 e6                	shl    %cl,%esi
  803139:	89 c5                	mov    %eax,%ebp
  80313b:	88 d9                	mov    %bl,%cl
  80313d:	d3 ed                	shr    %cl,%ebp
  80313f:	89 e9                	mov    %ebp,%ecx
  803141:	09 f1                	or     %esi,%ecx
  803143:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803147:	89 f9                	mov    %edi,%ecx
  803149:	d3 e0                	shl    %cl,%eax
  80314b:	89 c5                	mov    %eax,%ebp
  80314d:	89 d6                	mov    %edx,%esi
  80314f:	88 d9                	mov    %bl,%cl
  803151:	d3 ee                	shr    %cl,%esi
  803153:	89 f9                	mov    %edi,%ecx
  803155:	d3 e2                	shl    %cl,%edx
  803157:	8b 44 24 08          	mov    0x8(%esp),%eax
  80315b:	88 d9                	mov    %bl,%cl
  80315d:	d3 e8                	shr    %cl,%eax
  80315f:	09 c2                	or     %eax,%edx
  803161:	89 d0                	mov    %edx,%eax
  803163:	89 f2                	mov    %esi,%edx
  803165:	f7 74 24 0c          	divl   0xc(%esp)
  803169:	89 d6                	mov    %edx,%esi
  80316b:	89 c3                	mov    %eax,%ebx
  80316d:	f7 e5                	mul    %ebp
  80316f:	39 d6                	cmp    %edx,%esi
  803171:	72 19                	jb     80318c <__udivdi3+0xfc>
  803173:	74 0b                	je     803180 <__udivdi3+0xf0>
  803175:	89 d8                	mov    %ebx,%eax
  803177:	31 ff                	xor    %edi,%edi
  803179:	e9 58 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  80317e:	66 90                	xchg   %ax,%ax
  803180:	8b 54 24 08          	mov    0x8(%esp),%edx
  803184:	89 f9                	mov    %edi,%ecx
  803186:	d3 e2                	shl    %cl,%edx
  803188:	39 c2                	cmp    %eax,%edx
  80318a:	73 e9                	jae    803175 <__udivdi3+0xe5>
  80318c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80318f:	31 ff                	xor    %edi,%edi
  803191:	e9 40 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  803196:	66 90                	xchg   %ax,%ax
  803198:	31 c0                	xor    %eax,%eax
  80319a:	e9 37 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  80319f:	90                   	nop

008031a0 <__umoddi3>:
  8031a0:	55                   	push   %ebp
  8031a1:	57                   	push   %edi
  8031a2:	56                   	push   %esi
  8031a3:	53                   	push   %ebx
  8031a4:	83 ec 1c             	sub    $0x1c,%esp
  8031a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031bf:	89 f3                	mov    %esi,%ebx
  8031c1:	89 fa                	mov    %edi,%edx
  8031c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031c7:	89 34 24             	mov    %esi,(%esp)
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	75 1a                	jne    8031e8 <__umoddi3+0x48>
  8031ce:	39 f7                	cmp    %esi,%edi
  8031d0:	0f 86 a2 00 00 00    	jbe    803278 <__umoddi3+0xd8>
  8031d6:	89 c8                	mov    %ecx,%eax
  8031d8:	89 f2                	mov    %esi,%edx
  8031da:	f7 f7                	div    %edi
  8031dc:	89 d0                	mov    %edx,%eax
  8031de:	31 d2                	xor    %edx,%edx
  8031e0:	83 c4 1c             	add    $0x1c,%esp
  8031e3:	5b                   	pop    %ebx
  8031e4:	5e                   	pop    %esi
  8031e5:	5f                   	pop    %edi
  8031e6:	5d                   	pop    %ebp
  8031e7:	c3                   	ret    
  8031e8:	39 f0                	cmp    %esi,%eax
  8031ea:	0f 87 ac 00 00 00    	ja     80329c <__umoddi3+0xfc>
  8031f0:	0f bd e8             	bsr    %eax,%ebp
  8031f3:	83 f5 1f             	xor    $0x1f,%ebp
  8031f6:	0f 84 ac 00 00 00    	je     8032a8 <__umoddi3+0x108>
  8031fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803201:	29 ef                	sub    %ebp,%edi
  803203:	89 fe                	mov    %edi,%esi
  803205:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803209:	89 e9                	mov    %ebp,%ecx
  80320b:	d3 e0                	shl    %cl,%eax
  80320d:	89 d7                	mov    %edx,%edi
  80320f:	89 f1                	mov    %esi,%ecx
  803211:	d3 ef                	shr    %cl,%edi
  803213:	09 c7                	or     %eax,%edi
  803215:	89 e9                	mov    %ebp,%ecx
  803217:	d3 e2                	shl    %cl,%edx
  803219:	89 14 24             	mov    %edx,(%esp)
  80321c:	89 d8                	mov    %ebx,%eax
  80321e:	d3 e0                	shl    %cl,%eax
  803220:	89 c2                	mov    %eax,%edx
  803222:	8b 44 24 08          	mov    0x8(%esp),%eax
  803226:	d3 e0                	shl    %cl,%eax
  803228:	89 44 24 04          	mov    %eax,0x4(%esp)
  80322c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803230:	89 f1                	mov    %esi,%ecx
  803232:	d3 e8                	shr    %cl,%eax
  803234:	09 d0                	or     %edx,%eax
  803236:	d3 eb                	shr    %cl,%ebx
  803238:	89 da                	mov    %ebx,%edx
  80323a:	f7 f7                	div    %edi
  80323c:	89 d3                	mov    %edx,%ebx
  80323e:	f7 24 24             	mull   (%esp)
  803241:	89 c6                	mov    %eax,%esi
  803243:	89 d1                	mov    %edx,%ecx
  803245:	39 d3                	cmp    %edx,%ebx
  803247:	0f 82 87 00 00 00    	jb     8032d4 <__umoddi3+0x134>
  80324d:	0f 84 91 00 00 00    	je     8032e4 <__umoddi3+0x144>
  803253:	8b 54 24 04          	mov    0x4(%esp),%edx
  803257:	29 f2                	sub    %esi,%edx
  803259:	19 cb                	sbb    %ecx,%ebx
  80325b:	89 d8                	mov    %ebx,%eax
  80325d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803261:	d3 e0                	shl    %cl,%eax
  803263:	89 e9                	mov    %ebp,%ecx
  803265:	d3 ea                	shr    %cl,%edx
  803267:	09 d0                	or     %edx,%eax
  803269:	89 e9                	mov    %ebp,%ecx
  80326b:	d3 eb                	shr    %cl,%ebx
  80326d:	89 da                	mov    %ebx,%edx
  80326f:	83 c4 1c             	add    $0x1c,%esp
  803272:	5b                   	pop    %ebx
  803273:	5e                   	pop    %esi
  803274:	5f                   	pop    %edi
  803275:	5d                   	pop    %ebp
  803276:	c3                   	ret    
  803277:	90                   	nop
  803278:	89 fd                	mov    %edi,%ebp
  80327a:	85 ff                	test   %edi,%edi
  80327c:	75 0b                	jne    803289 <__umoddi3+0xe9>
  80327e:	b8 01 00 00 00       	mov    $0x1,%eax
  803283:	31 d2                	xor    %edx,%edx
  803285:	f7 f7                	div    %edi
  803287:	89 c5                	mov    %eax,%ebp
  803289:	89 f0                	mov    %esi,%eax
  80328b:	31 d2                	xor    %edx,%edx
  80328d:	f7 f5                	div    %ebp
  80328f:	89 c8                	mov    %ecx,%eax
  803291:	f7 f5                	div    %ebp
  803293:	89 d0                	mov    %edx,%eax
  803295:	e9 44 ff ff ff       	jmp    8031de <__umoddi3+0x3e>
  80329a:	66 90                	xchg   %ax,%ax
  80329c:	89 c8                	mov    %ecx,%eax
  80329e:	89 f2                	mov    %esi,%edx
  8032a0:	83 c4 1c             	add    $0x1c,%esp
  8032a3:	5b                   	pop    %ebx
  8032a4:	5e                   	pop    %esi
  8032a5:	5f                   	pop    %edi
  8032a6:	5d                   	pop    %ebp
  8032a7:	c3                   	ret    
  8032a8:	3b 04 24             	cmp    (%esp),%eax
  8032ab:	72 06                	jb     8032b3 <__umoddi3+0x113>
  8032ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032b1:	77 0f                	ja     8032c2 <__umoddi3+0x122>
  8032b3:	89 f2                	mov    %esi,%edx
  8032b5:	29 f9                	sub    %edi,%ecx
  8032b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032bb:	89 14 24             	mov    %edx,(%esp)
  8032be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032c6:	8b 14 24             	mov    (%esp),%edx
  8032c9:	83 c4 1c             	add    $0x1c,%esp
  8032cc:	5b                   	pop    %ebx
  8032cd:	5e                   	pop    %esi
  8032ce:	5f                   	pop    %edi
  8032cf:	5d                   	pop    %ebp
  8032d0:	c3                   	ret    
  8032d1:	8d 76 00             	lea    0x0(%esi),%esi
  8032d4:	2b 04 24             	sub    (%esp),%eax
  8032d7:	19 fa                	sbb    %edi,%edx
  8032d9:	89 d1                	mov    %edx,%ecx
  8032db:	89 c6                	mov    %eax,%esi
  8032dd:	e9 71 ff ff ff       	jmp    803253 <__umoddi3+0xb3>
  8032e2:	66 90                	xchg   %ax,%ax
  8032e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032e8:	72 ea                	jb     8032d4 <__umoddi3+0x134>
  8032ea:	89 d9                	mov    %ebx,%ecx
  8032ec:	e9 62 ff ff ff       	jmp    803253 <__umoddi3+0xb3>
