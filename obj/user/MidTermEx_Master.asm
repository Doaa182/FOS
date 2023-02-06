
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 14 02 00 00       	call   80024a <libmain>
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
  800045:	68 20 33 80 00       	push   $0x803320
  80004a:	e8 00 15 00 00       	call   80154f <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 24 33 80 00       	push   $0x803324
  800066:	e8 ef 03 00 00       	call   80045a <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 7f 01 00 00       	call   8001f2 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 27 01 00 00       	call   8001aa <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 1a 01 00 00       	call   8001aa <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 49 33 80 00       	push   $0x803349
  80009f:	e8 ab 14 00 00       	call   80154f <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 12                	jne    8000e4 <_main+0xac>
	{
		sys_createSemaphore("T", 0);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	68 50 33 80 00       	push   $0x803350
  8000dc:	e8 92 18 00 00       	call   801973 <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 52 33 80 00       	push   $0x803352
  8000f0:	e8 5a 14 00 00       	call   80154f <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 40 80 00       	mov    0x804020,%eax
  800109:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80010f:	a1 20 40 80 00       	mov    0x804020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c1                	mov    %eax,%ecx
  80011c:	a1 20 40 80 00       	mov    0x804020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	52                   	push   %edx
  800125:	51                   	push   %ecx
  800126:	50                   	push   %eax
  800127:	68 60 33 80 00       	push   $0x803360
  80012c:	e8 53 19 00 00       	call   801a84 <sys_create_env>
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800137:	a1 20 40 80 00       	mov    0x804020,%eax
  80013c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	a1 20 40 80 00       	mov    0x804020,%eax
  800154:	8b 40 74             	mov    0x74(%eax),%eax
  800157:	52                   	push   %edx
  800158:	51                   	push   %ecx
  800159:	50                   	push   %eax
  80015a:	68 6a 33 80 00       	push   $0x80336a
  80015f:	e8 20 19 00 00       	call   801a84 <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 2d 19 00 00       	call   801aa2 <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 1f 19 00 00       	call   801aa2 <sys_run_env>
  800183:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800186:	90                   	nop
  800187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	83 f8 02             	cmp    $0x2,%eax
  80018f:	75 f6                	jne    800187 <_main+0x14f>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  800191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	50                   	push   %eax
  80019a:	68 74 33 80 00       	push   $0x803374
  80019f:	e8 b6 02 00 00       	call   80045a <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp

	return;
  8001a7:	90                   	nop
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001b6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	e8 70 17 00 00       	call   801933 <sys_cputc>
  8001c3:	83 c4 10             	add    $0x10,%esp
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001cf:	e8 2b 17 00 00       	call   8018ff <sys_disable_interrupt>
	char c = ch;
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001da:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	e8 4c 17 00 00       	call   801933 <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 2a 17 00 00       	call   801919 <sys_enable_interrupt>
}
  8001ef:	90                   	nop
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <getchar>:

int
getchar(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8001f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8001ff:	eb 08                	jmp    800209 <getchar+0x17>
	{
		c = sys_cgetc();
  800201:	e8 74 15 00 00       	call   80177a <sys_cgetc>
  800206:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80020d:	74 f2                	je     800201 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <atomic_getchar>:

int
atomic_getchar(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80021a:	e8 e0 16 00 00       	call   8018ff <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 4d 15 00 00       	call   80177a <sys_cgetc>
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800234:	74 f2                	je     800228 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800236:	e8 de 16 00 00       	call   801919 <sys_enable_interrupt>
	return c;
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <iscons>:

int iscons(int fdnum)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800243:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800250:	e8 9d 18 00 00       	call   801af2 <sys_getenvindex>
  800255:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025b:	89 d0                	mov    %edx,%eax
  80025d:	c1 e0 03             	shl    $0x3,%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	01 c0                	add    %eax,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	01 d0                	add    %edx,%eax
  80026f:	c1 e0 04             	shl    $0x4,%eax
  800272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800277:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027c:	a1 20 40 80 00       	mov    0x804020,%eax
  800281:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800287:	84 c0                	test   %al,%al
  800289:	74 0f                	je     80029a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80028b:	a1 20 40 80 00       	mov    0x804020,%eax
  800290:	05 5c 05 00 00       	add    $0x55c,%eax
  800295:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029e:	7e 0a                	jle    8002aa <libmain+0x60>
		binaryname = argv[0];
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 80 fd ff ff       	call   800038 <_main>
  8002b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002bb:	e8 3f 16 00 00       	call   8018ff <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 a4 33 80 00       	push   $0x8033a4
  8002c8:	e8 8d 01 00 00       	call   80045a <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d5:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002db:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e0:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 cc 33 80 00       	push   $0x8033cc
  8002f0:	e8 65 01 00 00       	call   80045a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fd:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800303:	a1 20 40 80 00       	mov    0x804020,%eax
  800308:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80030e:	a1 20 40 80 00       	mov    0x804020,%eax
  800313:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 f4 33 80 00       	push   $0x8033f4
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 4c 34 80 00       	push   $0x80344c
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 a4 33 80 00       	push   $0x8033a4
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 bf 15 00 00       	call   801919 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80035a:	e8 19 00 00 00       	call   800378 <exit>
}
  80035f:	90                   	nop
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	6a 00                	push   $0x0
  80036d:	e8 4c 17 00 00       	call   801abe <sys_destroy_env>
  800372:	83 c4 10             	add    $0x10,%esp
}
  800375:	90                   	nop
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <exit>:

void
exit(void)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037e:	e8 a1 17 00 00       	call   801b24 <sys_exit_env>
}
  800383:	90                   	nop
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	8d 48 01             	lea    0x1(%eax),%ecx
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 0a                	mov    %ecx,(%edx)
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	88 d1                	mov    %dl,%cl
  80039e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b1:	a0 24 40 80 00       	mov    0x804024,%al
  8003b6:	0f b6 c0             	movzbl %al,%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	8b 12                	mov    (%edx),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	83 c2 08             	add    $0x8,%edx
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	50                   	push   %eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	e8 80 13 00 00       	call   801751 <sys_cputs>
  8003d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	8b 40 04             	mov    0x4(%eax),%eax
  8003e3:	8d 50 01             	lea    0x1(%eax),%edx
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ec:	90                   	nop
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ff:	00 00 00 
	b.cnt = 0;
  800402:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800409:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	68 86 03 80 00       	push   $0x800386
  80041e:	e8 11 02 00 00       	call   800634 <vprintfmt>
  800423:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800426:	a0 24 40 80 00       	mov    0x804024,%al
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	52                   	push   %edx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 09 13 00 00       	call   801751 <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

int cprintf(const char *fmt, ...) {
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800460:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 73 ff ff ff       	call   8003ef <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80048d:	e8 6d 14 00 00       	call   8018ff <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800492:	8d 45 0c             	lea    0xc(%ebp),%eax
  800495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a1:	50                   	push   %eax
  8004a2:	e8 48 ff ff ff       	call   8003ef <vcprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004ad:	e8 67 14 00 00       	call   801919 <sys_enable_interrupt>
	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 14             	sub    $0x14,%esp
  8004be:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d5:	77 55                	ja     80052c <printnum+0x75>
  8004d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004da:	72 05                	jb     8004e1 <printnum+0x2a>
  8004dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004df:	77 4b                	ja     80052c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	52                   	push   %edx
  8004f0:	50                   	push   %eax
  8004f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f7:	e8 b0 2b 00 00       	call   8030ac <__udivdi3>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	ff 75 20             	pushl  0x20(%ebp)
  800505:	53                   	push   %ebx
  800506:	ff 75 18             	pushl  0x18(%ebp)
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 a1 ff ff ff       	call   8004b7 <printnum>
  800516:	83 c4 20             	add    $0x20,%esp
  800519:	eb 1a                	jmp    800535 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 20             	pushl  0x20(%ebp)
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	ff d0                	call   *%eax
  800529:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052c:	ff 4d 1c             	decl   0x1c(%ebp)
  80052f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800533:	7f e6                	jg     80051b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800535:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800538:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800543:	53                   	push   %ebx
  800544:	51                   	push   %ecx
  800545:	52                   	push   %edx
  800546:	50                   	push   %eax
  800547:	e8 70 2c 00 00       	call   8031bc <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 74 36 80 00       	add    $0x803674,%eax
  800554:	8a 00                	mov    (%eax),%al
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	ff d0                	call   *%eax
  800565:	83 c4 10             	add    $0x10,%esp
}
  800568:	90                   	nop
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800575:	7e 1c                	jle    800593 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 08             	sub    $0x8,%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	eb 40                	jmp    8005d3 <getuint+0x65>
	else if (lflag)
  800593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800597:	74 1e                	je     8005b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 10                	mov    %edx,(%eax)
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 e8 04             	sub    $0x4,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	eb 1c                	jmp    8005d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dc:	7e 1c                	jle    8005fa <getint+0x25>
		return va_arg(*ap, long long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 08             	lea    0x8(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 08             	sub    $0x8,%eax
  8005f3:	8b 50 04             	mov    0x4(%eax),%edx
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	eb 38                	jmp    800632 <getint+0x5d>
	else if (lflag)
  8005fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fe:	74 1a                	je     80061a <getint+0x45>
		return va_arg(*ap, long);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 50 04             	lea    0x4(%eax),%edx
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 10                	mov    %edx,(%eax)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	83 e8 04             	sub    $0x4,%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	99                   	cltd   
  800618:	eb 18                	jmp    800632 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	8d 50 04             	lea    0x4(%eax),%edx
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	89 10                	mov    %edx,(%eax)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
}
  800632:	5d                   	pop    %ebp
  800633:	c3                   	ret    

00800634 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	56                   	push   %esi
  800638:	53                   	push   %ebx
  800639:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x21>
			if (ch == '\0')
  80063e:	85 db                	test   %ebx,%ebx
  800640:	0f 84 af 03 00 00    	je     8009f5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	53                   	push   %ebx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	8b 45 10             	mov    0x10(%ebp),%eax
  800658:	8d 50 01             	lea    0x1(%eax),%edx
  80065b:	89 55 10             	mov    %edx,0x10(%ebp)
  80065e:	8a 00                	mov    (%eax),%al
  800660:	0f b6 d8             	movzbl %al,%ebx
  800663:	83 fb 25             	cmp    $0x25,%ebx
  800666:	75 d6                	jne    80063e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800668:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800673:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800681:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 45 10             	mov    0x10(%ebp),%eax
  80068b:	8d 50 01             	lea    0x1(%eax),%edx
  80068e:	89 55 10             	mov    %edx,0x10(%ebp)
  800691:	8a 00                	mov    (%eax),%al
  800693:	0f b6 d8             	movzbl %al,%ebx
  800696:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800699:	83 f8 55             	cmp    $0x55,%eax
  80069c:	0f 87 2b 03 00 00    	ja     8009cd <vprintfmt+0x399>
  8006a2:	8b 04 85 98 36 80 00 	mov    0x803698(,%eax,4),%eax
  8006a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d7                	jmp    800688 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d1                	jmp    800688 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	c1 e0 02             	shl    $0x2,%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	01 c0                	add    %eax,%eax
  8006ca:	01 d8                	add    %ebx,%eax
  8006cc:	83 e8 30             	sub    $0x30,%eax
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 3e                	jle    80071d <vprintfmt+0xe9>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 39                	jg     80071d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e7:	eb d5                	jmp    8006be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 c0 04             	add    $0x4,%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fd:	eb 1f                	jmp    80071e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	79 83                	jns    800688 <vprintfmt+0x54>
				width = 0;
  800705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070c:	e9 77 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800711:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800718:	e9 6b ff ff ff       	jmp    800688 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800722:	0f 89 60 ff ff ff    	jns    800688 <vprintfmt+0x54>
				width = precision, precision = -1;
  800728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800735:	e9 4e ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073d:	e9 46 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 c0 04             	add    $0x4,%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
			break;
  800762:	e9 89 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800778:	85 db                	test   %ebx,%ebx
  80077a:	79 02                	jns    80077e <vprintfmt+0x14a>
				err = -err;
  80077c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077e:	83 fb 64             	cmp    $0x64,%ebx
  800781:	7f 0b                	jg     80078e <vprintfmt+0x15a>
  800783:	8b 34 9d e0 34 80 00 	mov    0x8034e0(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 85 36 80 00       	push   $0x803685
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 5e 02 00 00       	call   8009fd <printfmt>
  80079f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a2:	e9 49 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a7:	56                   	push   %esi
  8007a8:	68 8e 36 80 00       	push   $0x80368e
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 45 02 00 00       	call   8009fd <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 30 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 30                	mov    (%eax),%esi
  8007d1:	85 f6                	test   %esi,%esi
  8007d3:	75 05                	jne    8007da <vprintfmt+0x1a6>
				p = "(null)";
  8007d5:	be 91 36 80 00       	mov    $0x803691,%esi
			if (width > 0 && padc != '-')
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	7e 6d                	jle    80084d <vprintfmt+0x219>
  8007e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e4:	74 67                	je     80084d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	50                   	push   %eax
  8007ed:	56                   	push   %esi
  8007ee:	e8 0c 03 00 00       	call   800aff <strnlen>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f9:	eb 16                	jmp    800811 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	50                   	push   %eax
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080e:	ff 4d e4             	decl   -0x1c(%ebp)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800815:	7f e4                	jg     8007fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800817:	eb 34                	jmp    80084d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800819:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081d:	74 1c                	je     80083b <vprintfmt+0x207>
  80081f:	83 fb 1f             	cmp    $0x1f,%ebx
  800822:	7e 05                	jle    800829 <vprintfmt+0x1f5>
  800824:	83 fb 7e             	cmp    $0x7e,%ebx
  800827:	7e 12                	jle    80083b <vprintfmt+0x207>
					putch('?', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 3f                	push   $0x3f
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	eb 0f                	jmp    80084a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084a:	ff 4d e4             	decl   -0x1c(%ebp)
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 70 01             	lea    0x1(%eax),%esi
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f be d8             	movsbl %al,%ebx
  800857:	85 db                	test   %ebx,%ebx
  800859:	74 24                	je     80087f <vprintfmt+0x24b>
  80085b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085f:	78 b8                	js     800819 <vprintfmt+0x1e5>
  800861:	ff 4d e0             	decl   -0x20(%ebp)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 af                	jns    800819 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086a:	eb 13                	jmp    80087f <vprintfmt+0x24b>
				putch(' ', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 20                	push   $0x20
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087c:	ff 4d e4             	decl   -0x1c(%ebp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7f e7                	jg     80086c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800885:	e9 66 01 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 e8             	pushl  -0x18(%ebp)
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	e8 3c fd ff ff       	call   8005d5 <getint>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	79 23                	jns    8008cf <vprintfmt+0x29b>
				putch('-', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 2d                	push   $0x2d
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c2:	f7 d8                	neg    %eax
  8008c4:	83 d2 00             	adc    $0x0,%edx
  8008c7:	f7 da                	neg    %edx
  8008c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d6:	e9 bc 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	e8 84 fc ff ff       	call   80056e <getuint>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fa:	e9 98 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	6a 58                	push   $0x58
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	6a 58                	push   $0x58
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	6a 58                	push   $0x58
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			break;
  80092f:	e9 bc 00 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	6a 30                	push   $0x30
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 78                	push   $0x78
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 c0 04             	add    $0x4,%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 e8 04             	sub    $0x4,%eax
  800963:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80096f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800976:	eb 1f                	jmp    800997 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 e8             	pushl  -0x18(%ebp)
  80097e:	8d 45 14             	lea    0x14(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	e8 e7 fb ff ff       	call   80056e <getuint>
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800990:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800997:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	52                   	push   %edx
  8009a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 00 fb ff ff       	call   8004b7 <printnum>
  8009b7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ba:	eb 34                	jmp    8009f0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			break;
  8009cb:	eb 23                	jmp    8009f0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	6a 25                	push   $0x25
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009dd:	ff 4d 10             	decl   0x10(%ebp)
  8009e0:	eb 03                	jmp    8009e5 <vprintfmt+0x3b1>
  8009e2:	ff 4d 10             	decl   0x10(%ebp)
  8009e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e8:	48                   	dec    %eax
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	3c 25                	cmp    $0x25,%al
  8009ed:	75 f3                	jne    8009e2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009ef:	90                   	nop
		}
	}
  8009f0:	e9 47 fc ff ff       	jmp    80063c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a03:	8d 45 10             	lea    0x10(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a12:	50                   	push   %eax
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	ff 75 08             	pushl  0x8(%ebp)
  800a19:	e8 16 fc ff ff       	call   800634 <vprintfmt>
  800a1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8b 40 08             	mov    0x8(%eax),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8b 10                	mov    (%eax),%edx
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 40 04             	mov    0x4(%eax),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	73 12                	jae    800a57 <sprintputch+0x33>
		*b->buf++ = ch;
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a50:	89 0a                	mov    %ecx,(%edx)
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	88 10                	mov    %dl,(%eax)
}
  800a57:	90                   	nop
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	01 d0                	add    %edx,%eax
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7f:	74 06                	je     800a87 <vsnprintf+0x2d>
  800a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a85:	7f 07                	jg     800a8e <vsnprintf+0x34>
		return -E_INVAL;
  800a87:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8c:	eb 20                	jmp    800aae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8e:	ff 75 14             	pushl  0x14(%ebp)
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a97:	50                   	push   %eax
  800a98:	68 24 0a 80 00       	push   $0x800a24
  800a9d:	e8 92 fb ff ff       	call   800634 <vprintfmt>
  800aa2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	ff 75 08             	pushl  0x8(%ebp)
  800acc:	e8 89 ff ff ff       	call   800a5a <vsnprintf>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae9:	eb 06                	jmp    800af1 <strlen+0x15>
		n++;
  800aeb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aee:	ff 45 08             	incl   0x8(%ebp)
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	75 f1                	jne    800aeb <strlen+0xf>
		n++;
	return n;
  800afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 09                	jmp    800b17 <strnlen+0x18>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	ff 4d 0c             	decl   0xc(%ebp)
  800b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1b:	74 09                	je     800b26 <strnlen+0x27>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	75 e8                	jne    800b0e <strnlen+0xf>
		n++;
	return n;
  800b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b37:	90                   	nop
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8d 50 01             	lea    0x1(%eax),%edx
  800b3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b47:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4a:	8a 12                	mov    (%edx),%dl
  800b4c:	88 10                	mov    %dl,(%eax)
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	84 c0                	test   %al,%al
  800b52:	75 e4                	jne    800b38 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6c:	eb 1f                	jmp    800b8d <strncpy+0x34>
		*dst++ = *src;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 08             	mov    %edx,0x8(%ebp)
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8a 12                	mov    (%edx),%dl
  800b7c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	84 c0                	test   %al,%al
  800b85:	74 03                	je     800b8a <strncpy+0x31>
			src++;
  800b87:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8a:	ff 45 fc             	incl   -0x4(%ebp)
  800b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b93:	72 d9                	jb     800b6e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800baa:	74 30                	je     800bdc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bac:	eb 16                	jmp    800bc4 <strlcpy+0x2a>
			*dst++ = *src++;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8d 50 01             	lea    0x1(%eax),%edx
  800bb4:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc0:	8a 12                	mov    (%edx),%dl
  800bc2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc4:	ff 4d 10             	decl   0x10(%ebp)
  800bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcb:	74 09                	je     800bd6 <strlcpy+0x3c>
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 d8                	jne    800bae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be2:	29 c2                	sub    %eax,%edx
  800be4:	89 d0                	mov    %edx,%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800beb:	eb 06                	jmp    800bf3 <strcmp+0xb>
		p++, q++;
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	74 0e                	je     800c0a <strcmp+0x22>
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8a 10                	mov    (%eax),%dl
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	38 c2                	cmp    %al,%dl
  800c08:	74 e3                	je     800bed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	0f b6 d0             	movzbl %al,%edx
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	0f b6 c0             	movzbl %al,%eax
  800c1a:	29 c2                	sub    %eax,%edx
  800c1c:	89 d0                	mov    %edx,%eax
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c23:	eb 09                	jmp    800c2e <strncmp+0xe>
		n--, p++, q++;
  800c25:	ff 4d 10             	decl   0x10(%ebp)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c32:	74 17                	je     800c4b <strncmp+0x2b>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	74 0e                	je     800c4b <strncmp+0x2b>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 10                	mov    (%eax),%dl
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	38 c2                	cmp    %al,%dl
  800c49:	74 da                	je     800c25 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4f:	75 07                	jne    800c58 <strncmp+0x38>
		return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	eb 14                	jmp    800c6c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f b6 d0             	movzbl %al,%edx
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	0f b6 c0             	movzbl %al,%eax
  800c68:	29 c2                	sub    %eax,%edx
  800c6a:	89 d0                	mov    %edx,%eax
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 04             	sub    $0x4,%esp
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7a:	eb 12                	jmp    800c8e <strchr+0x20>
		if (*s == c)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c84:	75 05                	jne    800c8b <strchr+0x1d>
			return (char *) s;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	eb 11                	jmp    800c9c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8b:	ff 45 08             	incl   0x8(%ebp)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e5                	jne    800c7c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 04             	sub    $0x4,%esp
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800caa:	eb 0d                	jmp    800cb9 <strfind+0x1b>
		if (*s == c)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb4:	74 0e                	je     800cc4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 ea                	jne    800cac <strfind+0xe>
  800cc2:	eb 01                	jmp    800cc5 <strfind+0x27>
		if (*s == c)
			break;
  800cc4:	90                   	nop
	return (char *) s;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cdc:	eb 0e                	jmp    800cec <memset+0x22>
		*p++ = c;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce1:	8d 50 01             	lea    0x1(%eax),%edx
  800ce4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cec:	ff 4d f8             	decl   -0x8(%ebp)
  800cef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf3:	79 e9                	jns    800cde <memset+0x14>
		*p++ = c;

	return v;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0c:	eb 16                	jmp    800d24 <memcpy+0x2a>
		*d++ = *s++;
  800d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d11:	8d 50 01             	lea    0x1(%eax),%edx
  800d14:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d20:	8a 12                	mov    (%edx),%dl
  800d22:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	75 dd                	jne    800d0e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4e:	73 50                	jae    800da0 <memmove+0x6a>
  800d50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5b:	76 43                	jbe    800da0 <memmove+0x6a>
		s += n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d69:	eb 10                	jmp    800d7b <memmove+0x45>
			*--d = *--s;
  800d6b:	ff 4d f8             	decl   -0x8(%ebp)
  800d6e:	ff 4d fc             	decl   -0x4(%ebp)
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d79:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	89 55 10             	mov    %edx,0x10(%ebp)
  800d84:	85 c0                	test   %eax,%eax
  800d86:	75 e3                	jne    800d6b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d88:	eb 23                	jmp    800dad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d99:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9c:	8a 12                	mov    (%edx),%dl
  800d9e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da0:	8b 45 10             	mov    0x10(%ebp),%eax
  800da3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da6:	89 55 10             	mov    %edx,0x10(%ebp)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	75 dd                	jne    800d8a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc4:	eb 2a                	jmp    800df0 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc9:	8a 10                	mov    (%eax),%dl
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	38 c2                	cmp    %al,%dl
  800dd2:	74 16                	je     800dea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d0             	movzbl %al,%edx
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 c0             	movzbl %al,%eax
  800de4:	29 c2                	sub    %eax,%edx
  800de6:	89 d0                	mov    %edx,%eax
  800de8:	eb 18                	jmp    800e02 <memcmp+0x50>
		s1++, s2++;
  800dea:	ff 45 fc             	incl   -0x4(%ebp)
  800ded:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df6:	89 55 10             	mov    %edx,0x10(%ebp)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	75 c9                	jne    800dc6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 d0                	add    %edx,%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e15:	eb 15                	jmp    800e2c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	39 c2                	cmp    %eax,%edx
  800e27:	74 0d                	je     800e36 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e32:	72 e3                	jb     800e17 <memfind+0x13>
  800e34:	eb 01                	jmp    800e37 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e36:	90                   	nop
	return (void *) s;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e50:	eb 03                	jmp    800e55 <strtol+0x19>
		s++;
  800e52:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 20                	cmp    $0x20,%al
  800e5c:	74 f4                	je     800e52 <strtol+0x16>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 09                	cmp    $0x9,%al
  800e65:	74 eb                	je     800e52 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 2b                	cmp    $0x2b,%al
  800e6e:	75 05                	jne    800e75 <strtol+0x39>
		s++;
  800e70:	ff 45 08             	incl   0x8(%ebp)
  800e73:	eb 13                	jmp    800e88 <strtol+0x4c>
	else if (*s == '-')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 2d                	cmp    $0x2d,%al
  800e7c:	75 0a                	jne    800e88 <strtol+0x4c>
		s++, neg = 1;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8c:	74 06                	je     800e94 <strtol+0x58>
  800e8e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e92:	75 20                	jne    800eb4 <strtol+0x78>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 30                	cmp    $0x30,%al
  800e9b:	75 17                	jne    800eb4 <strtol+0x78>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	40                   	inc    %eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	3c 78                	cmp    $0x78,%al
  800ea5:	75 0d                	jne    800eb4 <strtol+0x78>
		s += 2, base = 16;
  800ea7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb2:	eb 28                	jmp    800edc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb8:	75 15                	jne    800ecf <strtol+0x93>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 30                	cmp    $0x30,%al
  800ec1:	75 0c                	jne    800ecf <strtol+0x93>
		s++, base = 8;
  800ec3:	ff 45 08             	incl   0x8(%ebp)
  800ec6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ecd:	eb 0d                	jmp    800edc <strtol+0xa0>
	else if (base == 0)
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	75 07                	jne    800edc <strtol+0xa0>
		base = 10;
  800ed5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 2f                	cmp    $0x2f,%al
  800ee3:	7e 19                	jle    800efe <strtol+0xc2>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 39                	cmp    $0x39,%al
  800eec:	7f 10                	jg     800efe <strtol+0xc2>
			dig = *s - '0';
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	0f be c0             	movsbl %al,%eax
  800ef6:	83 e8 30             	sub    $0x30,%eax
  800ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efc:	eb 42                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 60                	cmp    $0x60,%al
  800f05:	7e 19                	jle    800f20 <strtol+0xe4>
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 7a                	cmp    $0x7a,%al
  800f0e:	7f 10                	jg     800f20 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f be c0             	movsbl %al,%eax
  800f18:	83 e8 57             	sub    $0x57,%eax
  800f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1e:	eb 20                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 40                	cmp    $0x40,%al
  800f27:	7e 39                	jle    800f62 <strtol+0x126>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 5a                	cmp    $0x5a,%al
  800f30:	7f 30                	jg     800f62 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f be c0             	movsbl %al,%eax
  800f3a:	83 e8 37             	sub    $0x37,%eax
  800f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f46:	7d 19                	jge    800f61 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5c:	e9 7b ff ff ff       	jmp    800edc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f61:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f66:	74 08                	je     800f70 <strtol+0x134>
		*endptr = (char *) s;
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f74:	74 07                	je     800f7d <strtol+0x141>
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f79:	f7 d8                	neg    %eax
  800f7b:	eb 03                	jmp    800f80 <strtol+0x144>
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <ltostr>:

void
ltostr(long value, char *str)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9a:	79 13                	jns    800faf <ltostr+0x2d>
	{
		neg = 1;
  800f9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb7:	99                   	cltd   
  800fb8:	f7 f9                	idiv   %ecx
  800fba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc0:	8d 50 01             	lea    0x1(%eax),%edx
  800fc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd0:	83 c2 30             	add    $0x30,%edx
  800fd3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fdd:	f7 e9                	imul   %ecx
  800fdf:	c1 fa 02             	sar    $0x2,%edx
  800fe2:	89 c8                	mov    %ecx,%eax
  800fe4:	c1 f8 1f             	sar    $0x1f,%eax
  800fe7:	29 c2                	sub    %eax,%edx
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff6:	f7 e9                	imul   %ecx
  800ff8:	c1 fa 02             	sar    $0x2,%edx
  800ffb:	89 c8                	mov    %ecx,%eax
  800ffd:	c1 f8 1f             	sar    $0x1f,%eax
  801000:	29 c2                	sub    %eax,%edx
  801002:	89 d0                	mov    %edx,%eax
  801004:	c1 e0 02             	shl    $0x2,%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	01 c0                	add    %eax,%eax
  80100b:	29 c1                	sub    %eax,%ecx
  80100d:	89 ca                	mov    %ecx,%edx
  80100f:	85 d2                	test   %edx,%edx
  801011:	75 9c                	jne    800faf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801013:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	48                   	dec    %eax
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801025:	74 3d                	je     801064 <ltostr+0xe2>
		start = 1 ;
  801027:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102e:	eb 34                	jmp    801064 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c2                	add    %eax,%edx
  801045:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c8                	add    %ecx,%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105c:	88 02                	mov    %al,(%edx)
		start++ ;
  80105e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801061:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106a:	7c c4                	jl     801030 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801077:	90                   	nop
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 54 fa ff ff       	call   800adc <strlen>
  801088:	83 c4 04             	add    $0x4,%esp
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	e8 46 fa ff ff       	call   800adc <strlen>
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010aa:	eb 17                	jmp    8010c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	01 c8                	add    %ecx,%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c0:	ff 45 fc             	incl   -0x4(%ebp)
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c9:	7c e1                	jl     8010ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d9:	eb 1f                	jmp    8010fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801100:	7c d9                	jl     8010db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801133:	eb 0c                	jmp    801141 <strsplit+0x31>
			*string++ = 0;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 18                	je     801162 <strsplit+0x52>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	50                   	push   %eax
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 13 fb ff ff       	call   800c6e <strchr>
  80115b:	83 c4 08             	add    $0x8,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	75 d3                	jne    801135 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	74 5a                	je     8011c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116b:	8b 45 14             	mov    0x14(%ebp),%eax
  80116e:	8b 00                	mov    (%eax),%eax
  801170:	83 f8 0f             	cmp    $0xf,%eax
  801173:	75 07                	jne    80117c <strsplit+0x6c>
		{
			return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb 66                	jmp    8011e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117c:	8b 45 14             	mov    0x14(%ebp),%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	8d 48 01             	lea    0x1(%eax),%ecx
  801184:	8b 55 14             	mov    0x14(%ebp),%edx
  801187:	89 0a                	mov    %ecx,(%edx)
  801189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119a:	eb 03                	jmp    80119f <strsplit+0x8f>
			string++;
  80119c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 8b                	je     801133 <strsplit+0x23>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 b5 fa ff ff       	call   800c6e <strchr>
  8011b9:	83 c4 08             	add    $0x8,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 dc                	je     80119c <strsplit+0x8c>
			string++;
	}
  8011c0:	e9 6e ff ff ff       	jmp    801133 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8011ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 1f                	je     801212 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8011f3:	e8 1d 00 00 00       	call   801215 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8011f8:	83 ec 0c             	sub    $0xc,%esp
  8011fb:	68 f0 37 80 00       	push   $0x8037f0
  801200:	e8 55 f2 ff ff       	call   80045a <cprintf>
  801205:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801208:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80120f:	00 00 00 
	}
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80121b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801222:	00 00 00 
  801225:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80122c:	00 00 00 
  80122f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801236:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801239:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801240:	00 00 00 
  801243:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80124a:	00 00 00 
  80124d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801254:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801257:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80125e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801261:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801266:	2d 00 10 00 00       	sub    $0x1000,%eax
  80126b:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801270:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801277:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80127a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801284:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801289:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80128c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80128f:	ba 00 00 00 00       	mov    $0x0,%edx
  801294:	f7 75 f0             	divl   -0x10(%ebp)
  801297:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80129a:	29 d0                	sub    %edx,%eax
  80129c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  80129f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8012a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ae:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012b3:	83 ec 04             	sub    $0x4,%esp
  8012b6:	6a 06                	push   $0x6
  8012b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8012bb:	50                   	push   %eax
  8012bc:	e8 d4 05 00 00       	call   801895 <sys_allocate_chunk>
  8012c1:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012c4:	a1 20 41 80 00       	mov    0x804120,%eax
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	50                   	push   %eax
  8012cd:	e8 49 0c 00 00       	call   801f1b <initialize_MemBlocksList>
  8012d2:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8012d5:	a1 48 41 80 00       	mov    0x804148,%eax
  8012da:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8012dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012e1:	75 14                	jne    8012f7 <initialize_dyn_block_system+0xe2>
  8012e3:	83 ec 04             	sub    $0x4,%esp
  8012e6:	68 15 38 80 00       	push   $0x803815
  8012eb:	6a 39                	push   $0x39
  8012ed:	68 33 38 80 00       	push   $0x803833
  8012f2:	e8 d2 1b 00 00       	call   802ec9 <_panic>
  8012f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012fa:	8b 00                	mov    (%eax),%eax
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	74 10                	je     801310 <initialize_dyn_block_system+0xfb>
  801300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801303:	8b 00                	mov    (%eax),%eax
  801305:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801308:	8b 52 04             	mov    0x4(%edx),%edx
  80130b:	89 50 04             	mov    %edx,0x4(%eax)
  80130e:	eb 0b                	jmp    80131b <initialize_dyn_block_system+0x106>
  801310:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801313:	8b 40 04             	mov    0x4(%eax),%eax
  801316:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80131b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80131e:	8b 40 04             	mov    0x4(%eax),%eax
  801321:	85 c0                	test   %eax,%eax
  801323:	74 0f                	je     801334 <initialize_dyn_block_system+0x11f>
  801325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801328:	8b 40 04             	mov    0x4(%eax),%eax
  80132b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80132e:	8b 12                	mov    (%edx),%edx
  801330:	89 10                	mov    %edx,(%eax)
  801332:	eb 0a                	jmp    80133e <initialize_dyn_block_system+0x129>
  801334:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801337:	8b 00                	mov    (%eax),%eax
  801339:	a3 48 41 80 00       	mov    %eax,0x804148
  80133e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801341:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801347:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801351:	a1 54 41 80 00       	mov    0x804154,%eax
  801356:	48                   	dec    %eax
  801357:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80135c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80135f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801366:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801369:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801370:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801374:	75 14                	jne    80138a <initialize_dyn_block_system+0x175>
  801376:	83 ec 04             	sub    $0x4,%esp
  801379:	68 40 38 80 00       	push   $0x803840
  80137e:	6a 3f                	push   $0x3f
  801380:	68 33 38 80 00       	push   $0x803833
  801385:	e8 3f 1b 00 00       	call   802ec9 <_panic>
  80138a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801390:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801393:	89 10                	mov    %edx,(%eax)
  801395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801398:	8b 00                	mov    (%eax),%eax
  80139a:	85 c0                	test   %eax,%eax
  80139c:	74 0d                	je     8013ab <initialize_dyn_block_system+0x196>
  80139e:	a1 38 41 80 00       	mov    0x804138,%eax
  8013a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013a6:	89 50 04             	mov    %edx,0x4(%eax)
  8013a9:	eb 08                	jmp    8013b3 <initialize_dyn_block_system+0x19e>
  8013ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8013b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b6:	a3 38 41 80 00       	mov    %eax,0x804138
  8013bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013c5:	a1 44 41 80 00       	mov    0x804144,%eax
  8013ca:	40                   	inc    %eax
  8013cb:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8013d0:	90                   	nop
  8013d1:	c9                   	leave  
  8013d2:	c3                   	ret    

008013d3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013d9:	e8 06 fe ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8013de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e2:	75 07                	jne    8013eb <malloc+0x18>
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e9:	eb 7d                	jmp    801468 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8013eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8013f2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ff:	01 d0                	add    %edx,%eax
  801401:	48                   	dec    %eax
  801402:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801405:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801408:	ba 00 00 00 00       	mov    $0x0,%edx
  80140d:	f7 75 f0             	divl   -0x10(%ebp)
  801410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801413:	29 d0                	sub    %edx,%eax
  801415:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801418:	e8 46 08 00 00       	call   801c63 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80141d:	83 f8 01             	cmp    $0x1,%eax
  801420:	75 07                	jne    801429 <malloc+0x56>
  801422:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801429:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80142d:	75 34                	jne    801463 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80142f:	83 ec 0c             	sub    $0xc,%esp
  801432:	ff 75 e8             	pushl  -0x18(%ebp)
  801435:	e8 73 0e 00 00       	call   8022ad <alloc_block_FF>
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801440:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801444:	74 16                	je     80145c <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	ff 75 e4             	pushl  -0x1c(%ebp)
  80144c:	e8 ff 0b 00 00       	call   802050 <insert_sorted_allocList>
  801451:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801454:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801457:	8b 40 08             	mov    0x8(%eax),%eax
  80145a:	eb 0c                	jmp    801468 <malloc+0x95>
	             }
	             else
	             	return NULL;
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
  801461:	eb 05                	jmp    801468 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801463:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801479:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80147c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801484:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801487:	83 ec 08             	sub    $0x8,%esp
  80148a:	ff 75 f4             	pushl  -0xc(%ebp)
  80148d:	68 40 40 80 00       	push   $0x804040
  801492:	e8 61 0b 00 00       	call   801ff8 <find_block>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80149d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014a1:	0f 84 a5 00 00 00    	je     80154c <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8014a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ad:	83 ec 08             	sub    $0x8,%esp
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b4:	e8 a4 03 00 00       	call   80185d <sys_free_user_mem>
  8014b9:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8014bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014c0:	75 17                	jne    8014d9 <free+0x6f>
  8014c2:	83 ec 04             	sub    $0x4,%esp
  8014c5:	68 15 38 80 00       	push   $0x803815
  8014ca:	68 87 00 00 00       	push   $0x87
  8014cf:	68 33 38 80 00       	push   $0x803833
  8014d4:	e8 f0 19 00 00       	call   802ec9 <_panic>
  8014d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014dc:	8b 00                	mov    (%eax),%eax
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	74 10                	je     8014f2 <free+0x88>
  8014e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e5:	8b 00                	mov    (%eax),%eax
  8014e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014ea:	8b 52 04             	mov    0x4(%edx),%edx
  8014ed:	89 50 04             	mov    %edx,0x4(%eax)
  8014f0:	eb 0b                	jmp    8014fd <free+0x93>
  8014f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f5:	8b 40 04             	mov    0x4(%eax),%eax
  8014f8:	a3 44 40 80 00       	mov    %eax,0x804044
  8014fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801500:	8b 40 04             	mov    0x4(%eax),%eax
  801503:	85 c0                	test   %eax,%eax
  801505:	74 0f                	je     801516 <free+0xac>
  801507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80150a:	8b 40 04             	mov    0x4(%eax),%eax
  80150d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801510:	8b 12                	mov    (%edx),%edx
  801512:	89 10                	mov    %edx,(%eax)
  801514:	eb 0a                	jmp    801520 <free+0xb6>
  801516:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	a3 40 40 80 00       	mov    %eax,0x804040
  801520:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801533:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801538:	48                   	dec    %eax
  801539:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80153e:	83 ec 0c             	sub    $0xc,%esp
  801541:	ff 75 ec             	pushl  -0x14(%ebp)
  801544:	e8 37 12 00 00       	call   802780 <insert_sorted_with_merge_freeList>
  801549:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80154c:	90                   	nop
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 38             	sub    $0x38,%esp
  801555:	8b 45 10             	mov    0x10(%ebp),%eax
  801558:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80155b:	e8 84 fc ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801560:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801564:	75 07                	jne    80156d <smalloc+0x1e>
  801566:	b8 00 00 00 00       	mov    $0x0,%eax
  80156b:	eb 7e                	jmp    8015eb <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80156d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801574:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801581:	01 d0                	add    %edx,%eax
  801583:	48                   	dec    %eax
  801584:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158a:	ba 00 00 00 00       	mov    $0x0,%edx
  80158f:	f7 75 f0             	divl   -0x10(%ebp)
  801592:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801595:	29 d0                	sub    %edx,%eax
  801597:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80159a:	e8 c4 06 00 00       	call   801c63 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80159f:	83 f8 01             	cmp    $0x1,%eax
  8015a2:	75 42                	jne    8015e6 <smalloc+0x97>

		  va = malloc(newsize) ;
  8015a4:	83 ec 0c             	sub    $0xc,%esp
  8015a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8015aa:	e8 24 fe ff ff       	call   8013d3 <malloc>
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8015b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015b9:	74 24                	je     8015df <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8015bb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015c2:	50                   	push   %eax
  8015c3:	ff 75 e8             	pushl  -0x18(%ebp)
  8015c6:	ff 75 08             	pushl  0x8(%ebp)
  8015c9:	e8 1a 04 00 00       	call   8019e8 <sys_createSharedObject>
  8015ce:	83 c4 10             	add    $0x10,%esp
  8015d1:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8015d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015d8:	78 0c                	js     8015e6 <smalloc+0x97>
					  return va ;
  8015da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015dd:	eb 0c                	jmp    8015eb <smalloc+0x9c>
				 }
				 else
					return NULL;
  8015df:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e4:	eb 05                	jmp    8015eb <smalloc+0x9c>
	  }
		  return NULL ;
  8015e6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f3:	e8 ec fb ff ff       	call   8011e4 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	ff 75 0c             	pushl  0xc(%ebp)
  8015fe:	ff 75 08             	pushl  0x8(%ebp)
  801601:	e8 0c 04 00 00       	call   801a12 <sys_getSizeOfSharedObject>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80160c:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801610:	75 07                	jne    801619 <sget+0x2c>
  801612:	b8 00 00 00 00       	mov    $0x0,%eax
  801617:	eb 75                	jmp    80168e <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801619:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801620:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	48                   	dec    %eax
  801629:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80162c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162f:	ba 00 00 00 00       	mov    $0x0,%edx
  801634:	f7 75 f0             	divl   -0x10(%ebp)
  801637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163a:	29 d0                	sub    %edx,%eax
  80163c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80163f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801646:	e8 18 06 00 00       	call   801c63 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164b:	83 f8 01             	cmp    $0x1,%eax
  80164e:	75 39                	jne    801689 <sget+0x9c>

		  va = malloc(newsize) ;
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	ff 75 e8             	pushl  -0x18(%ebp)
  801656:	e8 78 fd ff ff       	call   8013d3 <malloc>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801661:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801665:	74 22                	je     801689 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801667:	83 ec 04             	sub    $0x4,%esp
  80166a:	ff 75 e0             	pushl  -0x20(%ebp)
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	ff 75 08             	pushl  0x8(%ebp)
  801673:	e8 b7 03 00 00       	call   801a2f <sys_getSharedObject>
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80167e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801682:	78 05                	js     801689 <sget+0x9c>
					  return va;
  801684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801687:	eb 05                	jmp    80168e <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801696:	e8 49 fb ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	68 64 38 80 00       	push   $0x803864
  8016a3:	68 1e 01 00 00       	push   $0x11e
  8016a8:	68 33 38 80 00       	push   $0x803833
  8016ad:	e8 17 18 00 00       	call   802ec9 <_panic>

008016b2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016b8:	83 ec 04             	sub    $0x4,%esp
  8016bb:	68 8c 38 80 00       	push   $0x80388c
  8016c0:	68 32 01 00 00       	push   $0x132
  8016c5:	68 33 38 80 00       	push   $0x803833
  8016ca:	e8 fa 17 00 00       	call   802ec9 <_panic>

008016cf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d5:	83 ec 04             	sub    $0x4,%esp
  8016d8:	68 b0 38 80 00       	push   $0x8038b0
  8016dd:	68 3d 01 00 00       	push   $0x13d
  8016e2:	68 33 38 80 00       	push   $0x803833
  8016e7:	e8 dd 17 00 00       	call   802ec9 <_panic>

008016ec <shrink>:

}
void shrink(uint32 newSize)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f2:	83 ec 04             	sub    $0x4,%esp
  8016f5:	68 b0 38 80 00       	push   $0x8038b0
  8016fa:	68 42 01 00 00       	push   $0x142
  8016ff:	68 33 38 80 00       	push   $0x803833
  801704:	e8 c0 17 00 00       	call   802ec9 <_panic>

00801709 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	68 b0 38 80 00       	push   $0x8038b0
  801717:	68 47 01 00 00       	push   $0x147
  80171c:	68 33 38 80 00       	push   $0x803833
  801721:	e8 a3 17 00 00       	call   802ec9 <_panic>

00801726 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	57                   	push   %edi
  80172a:	56                   	push   %esi
  80172b:	53                   	push   %ebx
  80172c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	8b 55 0c             	mov    0xc(%ebp),%edx
  801735:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801738:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80173e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801741:	cd 30                	int    $0x30
  801743:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801746:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801749:	83 c4 10             	add    $0x10,%esp
  80174c:	5b                   	pop    %ebx
  80174d:	5e                   	pop    %esi
  80174e:	5f                   	pop    %edi
  80174f:	5d                   	pop    %ebp
  801750:	c3                   	ret    

00801751 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	8b 45 10             	mov    0x10(%ebp),%eax
  80175a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80175d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	52                   	push   %edx
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	50                   	push   %eax
  80176d:	6a 00                	push   $0x0
  80176f:	e8 b2 ff ff ff       	call   801726 <syscall>
  801774:	83 c4 18             	add    $0x18,%esp
}
  801777:	90                   	nop
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <sys_cgetc>:

int
sys_cgetc(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 01                	push   $0x1
  801789:	e8 98 ff ff ff       	call   801726 <syscall>
  80178e:	83 c4 18             	add    $0x18,%esp
}
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801796:	8b 55 0c             	mov    0xc(%ebp),%edx
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	52                   	push   %edx
  8017a3:	50                   	push   %eax
  8017a4:	6a 05                	push   $0x5
  8017a6:	e8 7b ff ff ff       	call   801726 <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	56                   	push   %esi
  8017b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8017b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	56                   	push   %esi
  8017c5:	53                   	push   %ebx
  8017c6:	51                   	push   %ecx
  8017c7:	52                   	push   %edx
  8017c8:	50                   	push   %eax
  8017c9:	6a 06                	push   $0x6
  8017cb:	e8 56 ff ff ff       	call   801726 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d6:	5b                   	pop    %ebx
  8017d7:	5e                   	pop    %esi
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    

008017da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	52                   	push   %edx
  8017ea:	50                   	push   %eax
  8017eb:	6a 07                	push   $0x7
  8017ed:	e8 34 ff ff ff       	call   801726 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	ff 75 0c             	pushl  0xc(%ebp)
  801803:	ff 75 08             	pushl  0x8(%ebp)
  801806:	6a 08                	push   $0x8
  801808:	e8 19 ff ff ff       	call   801726 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 09                	push   $0x9
  801821:	e8 00 ff ff ff       	call   801726 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 0a                	push   $0xa
  80183a:	e8 e7 fe ff ff       	call   801726 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 0b                	push   $0xb
  801853:	e8 ce fe ff ff       	call   801726 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	ff 75 08             	pushl  0x8(%ebp)
  80186c:	6a 0f                	push   $0xf
  80186e:	e8 b3 fe ff ff       	call   801726 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
	return;
  801876:	90                   	nop
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	ff 75 0c             	pushl  0xc(%ebp)
  801885:	ff 75 08             	pushl  0x8(%ebp)
  801888:	6a 10                	push   $0x10
  80188a:	e8 97 fe ff ff       	call   801726 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
	return ;
  801892:	90                   	nop
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 10             	pushl  0x10(%ebp)
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	ff 75 08             	pushl  0x8(%ebp)
  8018a5:	6a 11                	push   $0x11
  8018a7:	e8 7a fe ff ff       	call   801726 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8018af:	90                   	nop
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 0c                	push   $0xc
  8018c1:	e8 60 fe ff ff       	call   801726 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 0d                	push   $0xd
  8018db:	e8 46 fe ff ff       	call   801726 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 0e                	push   $0xe
  8018f4:	e8 2d fe ff ff       	call   801726 <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	90                   	nop
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 13                	push   $0x13
  80190e:	e8 13 fe ff ff       	call   801726 <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	90                   	nop
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 14                	push   $0x14
  801928:	e8 f9 fd ff ff       	call   801726 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	90                   	nop
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_cputc>:


void
sys_cputc(const char c)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 04             	sub    $0x4,%esp
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80193f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	50                   	push   %eax
  80194c:	6a 15                	push   $0x15
  80194e:	e8 d3 fd ff ff       	call   801726 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	90                   	nop
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 16                	push   $0x16
  801968:	e8 b9 fd ff ff       	call   801726 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	90                   	nop
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	50                   	push   %eax
  801983:	6a 17                	push   $0x17
  801985:	e8 9c fd ff ff       	call   801726 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801992:	8b 55 0c             	mov    0xc(%ebp),%edx
  801995:	8b 45 08             	mov    0x8(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	52                   	push   %edx
  80199f:	50                   	push   %eax
  8019a0:	6a 1a                	push   $0x1a
  8019a2:	e8 7f fd ff ff       	call   801726 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	52                   	push   %edx
  8019bc:	50                   	push   %eax
  8019bd:	6a 18                	push   $0x18
  8019bf:	e8 62 fd ff ff       	call   801726 <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	90                   	nop
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	52                   	push   %edx
  8019da:	50                   	push   %eax
  8019db:	6a 19                	push   $0x19
  8019dd:	e8 44 fd ff ff       	call   801726 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	90                   	nop
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	6a 00                	push   $0x0
  801a00:	51                   	push   %ecx
  801a01:	52                   	push   %edx
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	50                   	push   %eax
  801a06:	6a 1b                	push   $0x1b
  801a08:	e8 19 fd ff ff       	call   801726 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	52                   	push   %edx
  801a22:	50                   	push   %eax
  801a23:	6a 1c                	push   $0x1c
  801a25:	e8 fc fc ff ff       	call   801726 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	51                   	push   %ecx
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 1d                	push   $0x1d
  801a44:	e8 dd fc ff ff       	call   801726 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	52                   	push   %edx
  801a5e:	50                   	push   %eax
  801a5f:	6a 1e                	push   $0x1e
  801a61:	e8 c0 fc ff ff       	call   801726 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 1f                	push   $0x1f
  801a7a:	e8 a7 fc ff ff       	call   801726 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	ff 75 14             	pushl  0x14(%ebp)
  801a8f:	ff 75 10             	pushl  0x10(%ebp)
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	50                   	push   %eax
  801a96:	6a 20                	push   $0x20
  801a98:	e8 89 fc ff ff       	call   801726 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	50                   	push   %eax
  801ab1:	6a 21                	push   $0x21
  801ab3:	e8 6e fc ff ff       	call   801726 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	90                   	nop
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	50                   	push   %eax
  801acd:	6a 22                	push   $0x22
  801acf:	e8 52 fc ff ff       	call   801726 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 02                	push   $0x2
  801ae8:	e8 39 fc ff ff       	call   801726 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 03                	push   $0x3
  801b01:	e8 20 fc ff ff       	call   801726 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 04                	push   $0x4
  801b1a:	e8 07 fc ff ff       	call   801726 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_exit_env>:


void sys_exit_env(void)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 23                	push   $0x23
  801b33:	e8 ee fb ff ff       	call   801726 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	90                   	nop
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b44:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b47:	8d 50 04             	lea    0x4(%eax),%edx
  801b4a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	52                   	push   %edx
  801b54:	50                   	push   %eax
  801b55:	6a 24                	push   $0x24
  801b57:	e8 ca fb ff ff       	call   801726 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return result;
  801b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b68:	89 01                	mov    %eax,(%ecx)
  801b6a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	c9                   	leave  
  801b71:	c2 04 00             	ret    $0x4

00801b74 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 10             	pushl  0x10(%ebp)
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	ff 75 08             	pushl  0x8(%ebp)
  801b84:	6a 12                	push   $0x12
  801b86:	e8 9b fb ff ff       	call   801726 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8e:	90                   	nop
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 25                	push   $0x25
  801ba0:	e8 81 fb ff ff       	call   801726 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	50                   	push   %eax
  801bc3:	6a 26                	push   $0x26
  801bc5:	e8 5c fb ff ff       	call   801726 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcd:	90                   	nop
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <rsttst>:
void rsttst()
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 28                	push   $0x28
  801bdf:	e8 42 fb ff ff       	call   801726 <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
	return ;
  801be7:	90                   	nop
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 04             	sub    $0x4,%esp
  801bf0:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf6:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bfd:	52                   	push   %edx
  801bfe:	50                   	push   %eax
  801bff:	ff 75 10             	pushl  0x10(%ebp)
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	ff 75 08             	pushl  0x8(%ebp)
  801c08:	6a 27                	push   $0x27
  801c0a:	e8 17 fb ff ff       	call   801726 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c12:	90                   	nop
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <chktst>:
void chktst(uint32 n)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	ff 75 08             	pushl  0x8(%ebp)
  801c23:	6a 29                	push   $0x29
  801c25:	e8 fc fa ff ff       	call   801726 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2d:	90                   	nop
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <inctst>:

void inctst()
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 2a                	push   $0x2a
  801c3f:	e8 e2 fa ff ff       	call   801726 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
	return ;
  801c47:	90                   	nop
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <gettst>:
uint32 gettst()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 2b                	push   $0x2b
  801c59:	e8 c8 fa ff ff       	call   801726 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 2c                	push   $0x2c
  801c75:	e8 ac fa ff ff       	call   801726 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
  801c7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c80:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c84:	75 07                	jne    801c8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c86:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8b:	eb 05                	jmp    801c92 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 2c                	push   $0x2c
  801ca6:	e8 7b fa ff ff       	call   801726 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
  801cae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cb1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cb5:	75 07                	jne    801cbe <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cb7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbc:	eb 05                	jmp    801cc3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 2c                	push   $0x2c
  801cd7:	e8 4a fa ff ff       	call   801726 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
  801cdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ce2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ce6:	75 07                	jne    801cef <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ce8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ced:	eb 05                	jmp    801cf4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 2c                	push   $0x2c
  801d08:	e8 19 fa ff ff       	call   801726 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
  801d10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d13:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d17:	75 07                	jne    801d20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d19:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1e:	eb 05                	jmp    801d25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	ff 75 08             	pushl  0x8(%ebp)
  801d35:	6a 2d                	push   $0x2d
  801d37:	e8 ea f9 ff ff       	call   801726 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3f:	90                   	nop
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d46:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	53                   	push   %ebx
  801d55:	51                   	push   %ecx
  801d56:	52                   	push   %edx
  801d57:	50                   	push   %eax
  801d58:	6a 2e                	push   $0x2e
  801d5a:	e8 c7 f9 ff ff       	call   801726 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
}
  801d62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	52                   	push   %edx
  801d77:	50                   	push   %eax
  801d78:	6a 2f                	push   $0x2f
  801d7a:	e8 a7 f9 ff ff       	call   801726 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d8a:	83 ec 0c             	sub    $0xc,%esp
  801d8d:	68 c0 38 80 00       	push   $0x8038c0
  801d92:	e8 c3 e6 ff ff       	call   80045a <cprintf>
  801d97:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801da1:	83 ec 0c             	sub    $0xc,%esp
  801da4:	68 ec 38 80 00       	push   $0x8038ec
  801da9:	e8 ac e6 ff ff       	call   80045a <cprintf>
  801dae:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801db1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801db5:	a1 38 41 80 00       	mov    0x804138,%eax
  801dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dbd:	eb 56                	jmp    801e15 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dc3:	74 1c                	je     801de1 <print_mem_block_lists+0x5d>
  801dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc8:	8b 50 08             	mov    0x8(%eax),%edx
  801dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dce:	8b 48 08             	mov    0x8(%eax),%ecx
  801dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd4:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd7:	01 c8                	add    %ecx,%eax
  801dd9:	39 c2                	cmp    %eax,%edx
  801ddb:	73 04                	jae    801de1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ddd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	8b 50 08             	mov    0x8(%eax),%edx
  801de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dea:	8b 40 0c             	mov    0xc(%eax),%eax
  801ded:	01 c2                	add    %eax,%edx
  801def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df2:	8b 40 08             	mov    0x8(%eax),%eax
  801df5:	83 ec 04             	sub    $0x4,%esp
  801df8:	52                   	push   %edx
  801df9:	50                   	push   %eax
  801dfa:	68 01 39 80 00       	push   $0x803901
  801dff:	e8 56 e6 ff ff       	call   80045a <cprintf>
  801e04:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e0d:	a1 40 41 80 00       	mov    0x804140,%eax
  801e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e19:	74 07                	je     801e22 <print_mem_block_lists+0x9e>
  801e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1e:	8b 00                	mov    (%eax),%eax
  801e20:	eb 05                	jmp    801e27 <print_mem_block_lists+0xa3>
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
  801e27:	a3 40 41 80 00       	mov    %eax,0x804140
  801e2c:	a1 40 41 80 00       	mov    0x804140,%eax
  801e31:	85 c0                	test   %eax,%eax
  801e33:	75 8a                	jne    801dbf <print_mem_block_lists+0x3b>
  801e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e39:	75 84                	jne    801dbf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e3b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e3f:	75 10                	jne    801e51 <print_mem_block_lists+0xcd>
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	68 10 39 80 00       	push   $0x803910
  801e49:	e8 0c e6 ff ff       	call   80045a <cprintf>
  801e4e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	68 34 39 80 00       	push   $0x803934
  801e60:	e8 f5 e5 ff ff       	call   80045a <cprintf>
  801e65:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e68:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e6c:	a1 40 40 80 00       	mov    0x804040,%eax
  801e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e74:	eb 56                	jmp    801ecc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e7a:	74 1c                	je     801e98 <print_mem_block_lists+0x114>
  801e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7f:	8b 50 08             	mov    0x8(%eax),%edx
  801e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e85:	8b 48 08             	mov    0x8(%eax),%ecx
  801e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8e:	01 c8                	add    %ecx,%eax
  801e90:	39 c2                	cmp    %eax,%edx
  801e92:	73 04                	jae    801e98 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e94:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 50 08             	mov    0x8(%eax),%edx
  801e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea4:	01 c2                	add    %eax,%edx
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	8b 40 08             	mov    0x8(%eax),%eax
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	68 01 39 80 00       	push   $0x803901
  801eb6:	e8 9f e5 ff ff       	call   80045a <cprintf>
  801ebb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ec4:	a1 48 40 80 00       	mov    0x804048,%eax
  801ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed0:	74 07                	je     801ed9 <print_mem_block_lists+0x155>
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 00                	mov    (%eax),%eax
  801ed7:	eb 05                	jmp    801ede <print_mem_block_lists+0x15a>
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	a3 48 40 80 00       	mov    %eax,0x804048
  801ee3:	a1 48 40 80 00       	mov    0x804048,%eax
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	75 8a                	jne    801e76 <print_mem_block_lists+0xf2>
  801eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef0:	75 84                	jne    801e76 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ef2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef6:	75 10                	jne    801f08 <print_mem_block_lists+0x184>
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	68 4c 39 80 00       	push   $0x80394c
  801f00:	e8 55 e5 ff ff       	call   80045a <cprintf>
  801f05:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	68 c0 38 80 00       	push   $0x8038c0
  801f10:	e8 45 e5 ff ff       	call   80045a <cprintf>
  801f15:	83 c4 10             	add    $0x10,%esp

}
  801f18:	90                   	nop
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  801f21:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f28:	00 00 00 
  801f2b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f32:	00 00 00 
  801f35:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f3c:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  801f3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f46:	e9 9e 00 00 00       	jmp    801fe9 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  801f4b:	a1 50 40 80 00       	mov    0x804050,%eax
  801f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f53:	c1 e2 04             	shl    $0x4,%edx
  801f56:	01 d0                	add    %edx,%eax
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	75 14                	jne    801f70 <initialize_MemBlocksList+0x55>
  801f5c:	83 ec 04             	sub    $0x4,%esp
  801f5f:	68 74 39 80 00       	push   $0x803974
  801f64:	6a 47                	push   $0x47
  801f66:	68 97 39 80 00       	push   $0x803997
  801f6b:	e8 59 0f 00 00       	call   802ec9 <_panic>
  801f70:	a1 50 40 80 00       	mov    0x804050,%eax
  801f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f78:	c1 e2 04             	shl    $0x4,%edx
  801f7b:	01 d0                	add    %edx,%eax
  801f7d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f83:	89 10                	mov    %edx,(%eax)
  801f85:	8b 00                	mov    (%eax),%eax
  801f87:	85 c0                	test   %eax,%eax
  801f89:	74 18                	je     801fa3 <initialize_MemBlocksList+0x88>
  801f8b:	a1 48 41 80 00       	mov    0x804148,%eax
  801f90:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f96:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f99:	c1 e1 04             	shl    $0x4,%ecx
  801f9c:	01 ca                	add    %ecx,%edx
  801f9e:	89 50 04             	mov    %edx,0x4(%eax)
  801fa1:	eb 12                	jmp    801fb5 <initialize_MemBlocksList+0x9a>
  801fa3:	a1 50 40 80 00       	mov    0x804050,%eax
  801fa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fab:	c1 e2 04             	shl    $0x4,%edx
  801fae:	01 d0                	add    %edx,%eax
  801fb0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801fb5:	a1 50 40 80 00       	mov    0x804050,%eax
  801fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbd:	c1 e2 04             	shl    $0x4,%edx
  801fc0:	01 d0                	add    %edx,%eax
  801fc2:	a3 48 41 80 00       	mov    %eax,0x804148
  801fc7:	a1 50 40 80 00       	mov    0x804050,%eax
  801fcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcf:	c1 e2 04             	shl    $0x4,%edx
  801fd2:	01 d0                	add    %edx,%eax
  801fd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fdb:	a1 54 41 80 00       	mov    0x804154,%eax
  801fe0:	40                   	inc    %eax
  801fe1:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  801fe6:	ff 45 f4             	incl   -0xc(%ebp)
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fef:	0f 82 56 ff ff ff    	jb     801f4b <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  801ff5:	90                   	nop
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
  801ffb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	8b 00                	mov    (%eax),%eax
  802003:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802006:	eb 19                	jmp    802021 <find_block+0x29>
	{
		if(element->sva == va){
  802008:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80200b:	8b 40 08             	mov    0x8(%eax),%eax
  80200e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802011:	75 05                	jne    802018 <find_block+0x20>
			 		return element;
  802013:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802016:	eb 36                	jmp    80204e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	8b 40 08             	mov    0x8(%eax),%eax
  80201e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802025:	74 07                	je     80202e <find_block+0x36>
  802027:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80202a:	8b 00                	mov    (%eax),%eax
  80202c:	eb 05                	jmp    802033 <find_block+0x3b>
  80202e:	b8 00 00 00 00       	mov    $0x0,%eax
  802033:	8b 55 08             	mov    0x8(%ebp),%edx
  802036:	89 42 08             	mov    %eax,0x8(%edx)
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	8b 40 08             	mov    0x8(%eax),%eax
  80203f:	85 c0                	test   %eax,%eax
  802041:	75 c5                	jne    802008 <find_block+0x10>
  802043:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802047:	75 bf                	jne    802008 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802049:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802056:	a1 44 40 80 00       	mov    0x804044,%eax
  80205b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80205e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802063:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802066:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80206a:	74 0a                	je     802076 <insert_sorted_allocList+0x26>
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	8b 40 08             	mov    0x8(%eax),%eax
  802072:	85 c0                	test   %eax,%eax
  802074:	75 65                	jne    8020db <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802076:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80207a:	75 14                	jne    802090 <insert_sorted_allocList+0x40>
  80207c:	83 ec 04             	sub    $0x4,%esp
  80207f:	68 74 39 80 00       	push   $0x803974
  802084:	6a 6e                	push   $0x6e
  802086:	68 97 39 80 00       	push   $0x803997
  80208b:	e8 39 0e 00 00       	call   802ec9 <_panic>
  802090:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	89 10                	mov    %edx,(%eax)
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	8b 00                	mov    (%eax),%eax
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	74 0d                	je     8020b1 <insert_sorted_allocList+0x61>
  8020a4:	a1 40 40 80 00       	mov    0x804040,%eax
  8020a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ac:	89 50 04             	mov    %edx,0x4(%eax)
  8020af:	eb 08                	jmp    8020b9 <insert_sorted_allocList+0x69>
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	a3 44 40 80 00       	mov    %eax,0x804044
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	a3 40 40 80 00       	mov    %eax,0x804040
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020cb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020d0:	40                   	inc    %eax
  8020d1:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8020d6:	e9 cf 01 00 00       	jmp    8022aa <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8020db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020de:	8b 50 08             	mov    0x8(%eax),%edx
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8b 40 08             	mov    0x8(%eax),%eax
  8020e7:	39 c2                	cmp    %eax,%edx
  8020e9:	73 65                	jae    802150 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ef:	75 14                	jne    802105 <insert_sorted_allocList+0xb5>
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	68 b0 39 80 00       	push   $0x8039b0
  8020f9:	6a 72                	push   $0x72
  8020fb:	68 97 39 80 00       	push   $0x803997
  802100:	e8 c4 0d 00 00       	call   802ec9 <_panic>
  802105:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	89 50 04             	mov    %edx,0x4(%eax)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8b 40 04             	mov    0x4(%eax),%eax
  802117:	85 c0                	test   %eax,%eax
  802119:	74 0c                	je     802127 <insert_sorted_allocList+0xd7>
  80211b:	a1 44 40 80 00       	mov    0x804044,%eax
  802120:	8b 55 08             	mov    0x8(%ebp),%edx
  802123:	89 10                	mov    %edx,(%eax)
  802125:	eb 08                	jmp    80212f <insert_sorted_allocList+0xdf>
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	a3 40 40 80 00       	mov    %eax,0x804040
  80212f:	8b 45 08             	mov    0x8(%ebp),%eax
  802132:	a3 44 40 80 00       	mov    %eax,0x804044
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802140:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802145:	40                   	inc    %eax
  802146:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80214b:	e9 5a 01 00 00       	jmp    8022aa <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802153:	8b 50 08             	mov    0x8(%eax),%edx
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	8b 40 08             	mov    0x8(%eax),%eax
  80215c:	39 c2                	cmp    %eax,%edx
  80215e:	75 70                	jne    8021d0 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802160:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802164:	74 06                	je     80216c <insert_sorted_allocList+0x11c>
  802166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80216a:	75 14                	jne    802180 <insert_sorted_allocList+0x130>
  80216c:	83 ec 04             	sub    $0x4,%esp
  80216f:	68 d4 39 80 00       	push   $0x8039d4
  802174:	6a 75                	push   $0x75
  802176:	68 97 39 80 00       	push   $0x803997
  80217b:	e8 49 0d 00 00       	call   802ec9 <_panic>
  802180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802183:	8b 10                	mov    (%eax),%edx
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	89 10                	mov    %edx,(%eax)
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	85 c0                	test   %eax,%eax
  802191:	74 0b                	je     80219e <insert_sorted_allocList+0x14e>
  802193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802196:	8b 00                	mov    (%eax),%eax
  802198:	8b 55 08             	mov    0x8(%ebp),%edx
  80219b:	89 50 04             	mov    %edx,0x4(%eax)
  80219e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a4:	89 10                	mov    %edx,(%eax)
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ac:	89 50 04             	mov    %edx,0x4(%eax)
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	75 08                	jne    8021c0 <insert_sorted_allocList+0x170>
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	a3 44 40 80 00       	mov    %eax,0x804044
  8021c0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021c5:	40                   	inc    %eax
  8021c6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8021cb:	e9 da 00 00 00       	jmp    8022aa <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8021d0:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d8:	e9 9d 00 00 00       	jmp    80227a <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	8b 50 08             	mov    0x8(%eax),%edx
  8021eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ee:	8b 40 08             	mov    0x8(%eax),%eax
  8021f1:	39 c2                	cmp    %eax,%edx
  8021f3:	76 7d                	jbe    802272 <insert_sorted_allocList+0x222>
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	8b 50 08             	mov    0x8(%eax),%edx
  8021fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021fe:	8b 40 08             	mov    0x8(%eax),%eax
  802201:	39 c2                	cmp    %eax,%edx
  802203:	73 6d                	jae    802272 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802209:	74 06                	je     802211 <insert_sorted_allocList+0x1c1>
  80220b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80220f:	75 14                	jne    802225 <insert_sorted_allocList+0x1d5>
  802211:	83 ec 04             	sub    $0x4,%esp
  802214:	68 d4 39 80 00       	push   $0x8039d4
  802219:	6a 7c                	push   $0x7c
  80221b:	68 97 39 80 00       	push   $0x803997
  802220:	e8 a4 0c 00 00       	call   802ec9 <_panic>
  802225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802228:	8b 10                	mov    (%eax),%edx
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	89 10                	mov    %edx,(%eax)
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	8b 00                	mov    (%eax),%eax
  802234:	85 c0                	test   %eax,%eax
  802236:	74 0b                	je     802243 <insert_sorted_allocList+0x1f3>
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	8b 55 08             	mov    0x8(%ebp),%edx
  802240:	89 50 04             	mov    %edx,0x4(%eax)
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 55 08             	mov    0x8(%ebp),%edx
  802249:	89 10                	mov    %edx,(%eax)
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802251:	89 50 04             	mov    %edx,0x4(%eax)
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	75 08                	jne    802265 <insert_sorted_allocList+0x215>
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	a3 44 40 80 00       	mov    %eax,0x804044
  802265:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80226a:	40                   	inc    %eax
  80226b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802270:	eb 38                	jmp    8022aa <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802272:	a1 48 40 80 00       	mov    0x804048,%eax
  802277:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227e:	74 07                	je     802287 <insert_sorted_allocList+0x237>
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	eb 05                	jmp    80228c <insert_sorted_allocList+0x23c>
  802287:	b8 00 00 00 00       	mov    $0x0,%eax
  80228c:	a3 48 40 80 00       	mov    %eax,0x804048
  802291:	a1 48 40 80 00       	mov    0x804048,%eax
  802296:	85 c0                	test   %eax,%eax
  802298:	0f 85 3f ff ff ff    	jne    8021dd <insert_sorted_allocList+0x18d>
  80229e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a2:	0f 85 35 ff ff ff    	jne    8021dd <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8022a8:	eb 00                	jmp    8022aa <insert_sorted_allocList+0x25a>
  8022aa:	90                   	nop
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8022b3:	a1 38 41 80 00       	mov    0x804138,%eax
  8022b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022bb:	e9 6b 02 00 00       	jmp    80252b <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c9:	0f 85 90 00 00 00    	jne    80235f <alloc_block_FF+0xb2>
			  temp=element;
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8022d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d9:	75 17                	jne    8022f2 <alloc_block_FF+0x45>
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	68 08 3a 80 00       	push   $0x803a08
  8022e3:	68 92 00 00 00       	push   $0x92
  8022e8:	68 97 39 80 00       	push   $0x803997
  8022ed:	e8 d7 0b 00 00       	call   802ec9 <_panic>
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 00                	mov    (%eax),%eax
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	74 10                	je     80230b <alloc_block_FF+0x5e>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802303:	8b 52 04             	mov    0x4(%edx),%edx
  802306:	89 50 04             	mov    %edx,0x4(%eax)
  802309:	eb 0b                	jmp    802316 <alloc_block_FF+0x69>
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 40 04             	mov    0x4(%eax),%eax
  802311:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 40 04             	mov    0x4(%eax),%eax
  80231c:	85 c0                	test   %eax,%eax
  80231e:	74 0f                	je     80232f <alloc_block_FF+0x82>
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 40 04             	mov    0x4(%eax),%eax
  802326:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802329:	8b 12                	mov    (%edx),%edx
  80232b:	89 10                	mov    %edx,(%eax)
  80232d:	eb 0a                	jmp    802339 <alloc_block_FF+0x8c>
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	8b 00                	mov    (%eax),%eax
  802334:	a3 38 41 80 00       	mov    %eax,0x804138
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234c:	a1 44 41 80 00       	mov    0x804144,%eax
  802351:	48                   	dec    %eax
  802352:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80235a:	e9 ff 01 00 00       	jmp    80255e <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 40 0c             	mov    0xc(%eax),%eax
  802365:	3b 45 08             	cmp    0x8(%ebp),%eax
  802368:	0f 86 b5 01 00 00    	jbe    802523 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	8b 40 0c             	mov    0xc(%eax),%eax
  802374:	2b 45 08             	sub    0x8(%ebp),%eax
  802377:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80237a:	a1 48 41 80 00       	mov    0x804148,%eax
  80237f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802382:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802386:	75 17                	jne    80239f <alloc_block_FF+0xf2>
  802388:	83 ec 04             	sub    $0x4,%esp
  80238b:	68 08 3a 80 00       	push   $0x803a08
  802390:	68 99 00 00 00       	push   $0x99
  802395:	68 97 39 80 00       	push   $0x803997
  80239a:	e8 2a 0b 00 00       	call   802ec9 <_panic>
  80239f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	74 10                	je     8023b8 <alloc_block_FF+0x10b>
  8023a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b0:	8b 52 04             	mov    0x4(%edx),%edx
  8023b3:	89 50 04             	mov    %edx,0x4(%eax)
  8023b6:	eb 0b                	jmp    8023c3 <alloc_block_FF+0x116>
  8023b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bb:	8b 40 04             	mov    0x4(%eax),%eax
  8023be:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c6:	8b 40 04             	mov    0x4(%eax),%eax
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	74 0f                	je     8023dc <alloc_block_FF+0x12f>
  8023cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d0:	8b 40 04             	mov    0x4(%eax),%eax
  8023d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023d6:	8b 12                	mov    (%edx),%edx
  8023d8:	89 10                	mov    %edx,(%eax)
  8023da:	eb 0a                	jmp    8023e6 <alloc_block_FF+0x139>
  8023dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023df:	8b 00                	mov    (%eax),%eax
  8023e1:	a3 48 41 80 00       	mov    %eax,0x804148
  8023e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f9:	a1 54 41 80 00       	mov    0x804154,%eax
  8023fe:	48                   	dec    %eax
  8023ff:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802404:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802408:	75 17                	jne    802421 <alloc_block_FF+0x174>
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	68 b0 39 80 00       	push   $0x8039b0
  802412:	68 9a 00 00 00       	push   $0x9a
  802417:	68 97 39 80 00       	push   $0x803997
  80241c:	e8 a8 0a 00 00       	call   802ec9 <_panic>
  802421:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802427:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242a:	89 50 04             	mov    %edx,0x4(%eax)
  80242d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802430:	8b 40 04             	mov    0x4(%eax),%eax
  802433:	85 c0                	test   %eax,%eax
  802435:	74 0c                	je     802443 <alloc_block_FF+0x196>
  802437:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80243c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80243f:	89 10                	mov    %edx,(%eax)
  802441:	eb 08                	jmp    80244b <alloc_block_FF+0x19e>
  802443:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802446:	a3 38 41 80 00       	mov    %eax,0x804138
  80244b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802453:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802456:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245c:	a1 44 41 80 00       	mov    0x804144,%eax
  802461:	40                   	inc    %eax
  802462:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802467:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246a:	8b 55 08             	mov    0x8(%ebp),%edx
  80246d:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 50 08             	mov    0x8(%eax),%edx
  802476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802479:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802482:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 50 08             	mov    0x8(%eax),%edx
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	01 c2                	add    %eax,%edx
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802499:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80249c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024a0:	75 17                	jne    8024b9 <alloc_block_FF+0x20c>
  8024a2:	83 ec 04             	sub    $0x4,%esp
  8024a5:	68 08 3a 80 00       	push   $0x803a08
  8024aa:	68 a2 00 00 00       	push   $0xa2
  8024af:	68 97 39 80 00       	push   $0x803997
  8024b4:	e8 10 0a 00 00       	call   802ec9 <_panic>
  8024b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	74 10                	je     8024d2 <alloc_block_FF+0x225>
  8024c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c5:	8b 00                	mov    (%eax),%eax
  8024c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024ca:	8b 52 04             	mov    0x4(%edx),%edx
  8024cd:	89 50 04             	mov    %edx,0x4(%eax)
  8024d0:	eb 0b                	jmp    8024dd <alloc_block_FF+0x230>
  8024d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d5:	8b 40 04             	mov    0x4(%eax),%eax
  8024d8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e0:	8b 40 04             	mov    0x4(%eax),%eax
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	74 0f                	je     8024f6 <alloc_block_FF+0x249>
  8024e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ea:	8b 40 04             	mov    0x4(%eax),%eax
  8024ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f0:	8b 12                	mov    (%edx),%edx
  8024f2:	89 10                	mov    %edx,(%eax)
  8024f4:	eb 0a                	jmp    802500 <alloc_block_FF+0x253>
  8024f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f9:	8b 00                	mov    (%eax),%eax
  8024fb:	a3 38 41 80 00       	mov    %eax,0x804138
  802500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802503:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802513:	a1 44 41 80 00       	mov    0x804144,%eax
  802518:	48                   	dec    %eax
  802519:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80251e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802521:	eb 3b                	jmp    80255e <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802523:	a1 40 41 80 00       	mov    0x804140,%eax
  802528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252f:	74 07                	je     802538 <alloc_block_FF+0x28b>
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 00                	mov    (%eax),%eax
  802536:	eb 05                	jmp    80253d <alloc_block_FF+0x290>
  802538:	b8 00 00 00 00       	mov    $0x0,%eax
  80253d:	a3 40 41 80 00       	mov    %eax,0x804140
  802542:	a1 40 41 80 00       	mov    0x804140,%eax
  802547:	85 c0                	test   %eax,%eax
  802549:	0f 85 71 fd ff ff    	jne    8022c0 <alloc_block_FF+0x13>
  80254f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802553:	0f 85 67 fd ff ff    	jne    8022c0 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802559:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802566:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80256d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802574:	a1 38 41 80 00       	mov    0x804138,%eax
  802579:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80257c:	e9 d3 00 00 00       	jmp    802654 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802581:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802584:	8b 40 0c             	mov    0xc(%eax),%eax
  802587:	3b 45 08             	cmp    0x8(%ebp),%eax
  80258a:	0f 85 90 00 00 00    	jne    802620 <alloc_block_BF+0xc0>
	   temp = element;
  802590:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802593:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802596:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80259a:	75 17                	jne    8025b3 <alloc_block_BF+0x53>
  80259c:	83 ec 04             	sub    $0x4,%esp
  80259f:	68 08 3a 80 00       	push   $0x803a08
  8025a4:	68 bd 00 00 00       	push   $0xbd
  8025a9:	68 97 39 80 00       	push   $0x803997
  8025ae:	e8 16 09 00 00       	call   802ec9 <_panic>
  8025b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 10                	je     8025cc <alloc_block_BF+0x6c>
  8025bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025c4:	8b 52 04             	mov    0x4(%edx),%edx
  8025c7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ca:	eb 0b                	jmp    8025d7 <alloc_block_BF+0x77>
  8025cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025cf:	8b 40 04             	mov    0x4(%eax),%eax
  8025d2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025da:	8b 40 04             	mov    0x4(%eax),%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 0f                	je     8025f0 <alloc_block_BF+0x90>
  8025e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025e4:	8b 40 04             	mov    0x4(%eax),%eax
  8025e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025ea:	8b 12                	mov    (%edx),%edx
  8025ec:	89 10                	mov    %edx,(%eax)
  8025ee:	eb 0a                	jmp    8025fa <alloc_block_BF+0x9a>
  8025f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802603:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80260d:	a1 44 41 80 00       	mov    0x804144,%eax
  802612:	48                   	dec    %eax
  802613:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802618:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80261b:	e9 41 01 00 00       	jmp    802761 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802623:	8b 40 0c             	mov    0xc(%eax),%eax
  802626:	3b 45 08             	cmp    0x8(%ebp),%eax
  802629:	76 21                	jbe    80264c <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80262b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80262e:	8b 40 0c             	mov    0xc(%eax),%eax
  802631:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802634:	73 16                	jae    80264c <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802636:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802639:	8b 40 0c             	mov    0xc(%eax),%eax
  80263c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80263f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802642:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802645:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80264c:	a1 40 41 80 00       	mov    0x804140,%eax
  802651:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802654:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802658:	74 07                	je     802661 <alloc_block_BF+0x101>
  80265a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	eb 05                	jmp    802666 <alloc_block_BF+0x106>
  802661:	b8 00 00 00 00       	mov    $0x0,%eax
  802666:	a3 40 41 80 00       	mov    %eax,0x804140
  80266b:	a1 40 41 80 00       	mov    0x804140,%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	0f 85 09 ff ff ff    	jne    802581 <alloc_block_BF+0x21>
  802678:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80267c:	0f 85 ff fe ff ff    	jne    802581 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802682:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802686:	0f 85 d0 00 00 00    	jne    80275c <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80268c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268f:	8b 40 0c             	mov    0xc(%eax),%eax
  802692:	2b 45 08             	sub    0x8(%ebp),%eax
  802695:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802698:	a1 48 41 80 00       	mov    0x804148,%eax
  80269d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8026a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026a4:	75 17                	jne    8026bd <alloc_block_BF+0x15d>
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	68 08 3a 80 00       	push   $0x803a08
  8026ae:	68 d1 00 00 00       	push   $0xd1
  8026b3:	68 97 39 80 00       	push   $0x803997
  8026b8:	e8 0c 08 00 00       	call   802ec9 <_panic>
  8026bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	74 10                	je     8026d6 <alloc_block_BF+0x176>
  8026c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c9:	8b 00                	mov    (%eax),%eax
  8026cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ce:	8b 52 04             	mov    0x4(%edx),%edx
  8026d1:	89 50 04             	mov    %edx,0x4(%eax)
  8026d4:	eb 0b                	jmp    8026e1 <alloc_block_BF+0x181>
  8026d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d9:	8b 40 04             	mov    0x4(%eax),%eax
  8026dc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e4:	8b 40 04             	mov    0x4(%eax),%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	74 0f                	je     8026fa <alloc_block_BF+0x19a>
  8026eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ee:	8b 40 04             	mov    0x4(%eax),%eax
  8026f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026f4:	8b 12                	mov    (%edx),%edx
  8026f6:	89 10                	mov    %edx,(%eax)
  8026f8:	eb 0a                	jmp    802704 <alloc_block_BF+0x1a4>
  8026fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	a3 48 41 80 00       	mov    %eax,0x804148
  802704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802710:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802717:	a1 54 41 80 00       	mov    0x804154,%eax
  80271c:	48                   	dec    %eax
  80271d:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802725:	8b 55 08             	mov    0x8(%ebp),%edx
  802728:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  80272b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272e:	8b 50 08             	mov    0x8(%eax),%edx
  802731:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802734:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802737:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80273d:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802743:	8b 50 08             	mov    0x8(%eax),%edx
  802746:	8b 45 08             	mov    0x8(%ebp),%eax
  802749:	01 c2                	add    %eax,%edx
  80274b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274e:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802751:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802754:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802757:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80275a:	eb 05                	jmp    802761 <alloc_block_BF+0x201>
	 }
	 return NULL;
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802761:	c9                   	leave  
  802762:	c3                   	ret    

00802763 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802763:	55                   	push   %ebp
  802764:	89 e5                	mov    %esp,%ebp
  802766:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802769:	83 ec 04             	sub    $0x4,%esp
  80276c:	68 28 3a 80 00       	push   $0x803a28
  802771:	68 e8 00 00 00       	push   $0xe8
  802776:	68 97 39 80 00       	push   $0x803997
  80277b:	e8 49 07 00 00       	call   802ec9 <_panic>

00802780 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802786:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80278b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  80278e:	a1 38 41 80 00       	mov    0x804138,%eax
  802793:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802796:	a1 44 41 80 00       	mov    0x804144,%eax
  80279b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  80279e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027a2:	75 68                	jne    80280c <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8027a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027a8:	75 17                	jne    8027c1 <insert_sorted_with_merge_freeList+0x41>
  8027aa:	83 ec 04             	sub    $0x4,%esp
  8027ad:	68 74 39 80 00       	push   $0x803974
  8027b2:	68 36 01 00 00       	push   $0x136
  8027b7:	68 97 39 80 00       	push   $0x803997
  8027bc:	e8 08 07 00 00       	call   802ec9 <_panic>
  8027c1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8027c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ca:	89 10                	mov    %edx,(%eax)
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	74 0d                	je     8027e2 <insert_sorted_with_merge_freeList+0x62>
  8027d5:	a1 38 41 80 00       	mov    0x804138,%eax
  8027da:	8b 55 08             	mov    0x8(%ebp),%edx
  8027dd:	89 50 04             	mov    %edx,0x4(%eax)
  8027e0:	eb 08                	jmp    8027ea <insert_sorted_with_merge_freeList+0x6a>
  8027e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ed:	a3 38 41 80 00       	mov    %eax,0x804138
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027fc:	a1 44 41 80 00       	mov    0x804144,%eax
  802801:	40                   	inc    %eax
  802802:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802807:	e9 ba 06 00 00       	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  80280c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280f:	8b 50 08             	mov    0x8(%eax),%edx
  802812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802815:	8b 40 0c             	mov    0xc(%eax),%eax
  802818:	01 c2                	add    %eax,%edx
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	8b 40 08             	mov    0x8(%eax),%eax
  802820:	39 c2                	cmp    %eax,%edx
  802822:	73 68                	jae    80288c <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802824:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802828:	75 17                	jne    802841 <insert_sorted_with_merge_freeList+0xc1>
  80282a:	83 ec 04             	sub    $0x4,%esp
  80282d:	68 b0 39 80 00       	push   $0x8039b0
  802832:	68 3a 01 00 00       	push   $0x13a
  802837:	68 97 39 80 00       	push   $0x803997
  80283c:	e8 88 06 00 00       	call   802ec9 <_panic>
  802841:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	89 50 04             	mov    %edx,0x4(%eax)
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	8b 40 04             	mov    0x4(%eax),%eax
  802853:	85 c0                	test   %eax,%eax
  802855:	74 0c                	je     802863 <insert_sorted_with_merge_freeList+0xe3>
  802857:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80285c:	8b 55 08             	mov    0x8(%ebp),%edx
  80285f:	89 10                	mov    %edx,(%eax)
  802861:	eb 08                	jmp    80286b <insert_sorted_with_merge_freeList+0xeb>
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	a3 38 41 80 00       	mov    %eax,0x804138
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287c:	a1 44 41 80 00       	mov    0x804144,%eax
  802881:	40                   	inc    %eax
  802882:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802887:	e9 3a 06 00 00       	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  80288c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288f:	8b 50 08             	mov    0x8(%eax),%edx
  802892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802895:	8b 40 0c             	mov    0xc(%eax),%eax
  802898:	01 c2                	add    %eax,%edx
  80289a:	8b 45 08             	mov    0x8(%ebp),%eax
  80289d:	8b 40 08             	mov    0x8(%eax),%eax
  8028a0:	39 c2                	cmp    %eax,%edx
  8028a2:	0f 85 90 00 00 00    	jne    802938 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b4:	01 c2                	add    %eax,%edx
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8028d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d4:	75 17                	jne    8028ed <insert_sorted_with_merge_freeList+0x16d>
  8028d6:	83 ec 04             	sub    $0x4,%esp
  8028d9:	68 74 39 80 00       	push   $0x803974
  8028de:	68 41 01 00 00       	push   $0x141
  8028e3:	68 97 39 80 00       	push   $0x803997
  8028e8:	e8 dc 05 00 00       	call   802ec9 <_panic>
  8028ed:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	89 10                	mov    %edx,(%eax)
  8028f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	74 0d                	je     80290e <insert_sorted_with_merge_freeList+0x18e>
  802901:	a1 48 41 80 00       	mov    0x804148,%eax
  802906:	8b 55 08             	mov    0x8(%ebp),%edx
  802909:	89 50 04             	mov    %edx,0x4(%eax)
  80290c:	eb 08                	jmp    802916 <insert_sorted_with_merge_freeList+0x196>
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802916:	8b 45 08             	mov    0x8(%ebp),%eax
  802919:	a3 48 41 80 00       	mov    %eax,0x804148
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802928:	a1 54 41 80 00       	mov    0x804154,%eax
  80292d:	40                   	inc    %eax
  80292e:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802933:	e9 8e 05 00 00       	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802938:	8b 45 08             	mov    0x8(%ebp),%eax
  80293b:	8b 50 08             	mov    0x8(%eax),%edx
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	8b 40 0c             	mov    0xc(%eax),%eax
  802944:	01 c2                	add    %eax,%edx
  802946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802949:	8b 40 08             	mov    0x8(%eax),%eax
  80294c:	39 c2                	cmp    %eax,%edx
  80294e:	73 68                	jae    8029b8 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802950:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802954:	75 17                	jne    80296d <insert_sorted_with_merge_freeList+0x1ed>
  802956:	83 ec 04             	sub    $0x4,%esp
  802959:	68 74 39 80 00       	push   $0x803974
  80295e:	68 45 01 00 00       	push   $0x145
  802963:	68 97 39 80 00       	push   $0x803997
  802968:	e8 5c 05 00 00       	call   802ec9 <_panic>
  80296d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	89 10                	mov    %edx,(%eax)
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	74 0d                	je     80298e <insert_sorted_with_merge_freeList+0x20e>
  802981:	a1 38 41 80 00       	mov    0x804138,%eax
  802986:	8b 55 08             	mov    0x8(%ebp),%edx
  802989:	89 50 04             	mov    %edx,0x4(%eax)
  80298c:	eb 08                	jmp    802996 <insert_sorted_with_merge_freeList+0x216>
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	a3 38 41 80 00       	mov    %eax,0x804138
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ad:	40                   	inc    %eax
  8029ae:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8029b3:	e9 0e 05 00 00       	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	8b 50 08             	mov    0x8(%eax),%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c4:	01 c2                	add    %eax,%edx
  8029c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c9:	8b 40 08             	mov    0x8(%eax),%eax
  8029cc:	39 c2                	cmp    %eax,%edx
  8029ce:	0f 85 9c 00 00 00    	jne    802a70 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  8029d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e0:	01 c2                	add    %eax,%edx
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	8b 50 08             	mov    0x8(%eax),%edx
  8029ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f1:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802a08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a0c:	75 17                	jne    802a25 <insert_sorted_with_merge_freeList+0x2a5>
  802a0e:	83 ec 04             	sub    $0x4,%esp
  802a11:	68 74 39 80 00       	push   $0x803974
  802a16:	68 4d 01 00 00       	push   $0x14d
  802a1b:	68 97 39 80 00       	push   $0x803997
  802a20:	e8 a4 04 00 00       	call   802ec9 <_panic>
  802a25:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	89 10                	mov    %edx,(%eax)
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 0d                	je     802a46 <insert_sorted_with_merge_freeList+0x2c6>
  802a39:	a1 48 41 80 00       	mov    0x804148,%eax
  802a3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a41:	89 50 04             	mov    %edx,0x4(%eax)
  802a44:	eb 08                	jmp    802a4e <insert_sorted_with_merge_freeList+0x2ce>
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	a3 48 41 80 00       	mov    %eax,0x804148
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a60:	a1 54 41 80 00       	mov    0x804154,%eax
  802a65:	40                   	inc    %eax
  802a66:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802a6b:	e9 56 04 00 00       	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802a70:	a1 38 41 80 00       	mov    0x804138,%eax
  802a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a78:	e9 19 04 00 00       	jmp    802e96 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 00                	mov    (%eax),%eax
  802a82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 50 08             	mov    0x8(%eax),%edx
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a91:	01 c2                	add    %eax,%edx
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	8b 40 08             	mov    0x8(%eax),%eax
  802a99:	39 c2                	cmp    %eax,%edx
  802a9b:	0f 85 ad 01 00 00    	jne    802c4e <insert_sorted_with_merge_freeList+0x4ce>
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	8b 50 08             	mov    0x8(%eax),%edx
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802aad:	01 c2                	add    %eax,%edx
  802aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ab2:	8b 40 08             	mov    0x8(%eax),%eax
  802ab5:	39 c2                	cmp    %eax,%edx
  802ab7:	0f 85 91 01 00 00    	jne    802c4e <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802acc:	8b 40 0c             	mov    0xc(%eax),%eax
  802acf:	01 c8                	add    %ecx,%eax
  802ad1:	01 c2                	add    %eax,%edx
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802af0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802af7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802afa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802b01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802b05:	75 17                	jne    802b1e <insert_sorted_with_merge_freeList+0x39e>
  802b07:	83 ec 04             	sub    $0x4,%esp
  802b0a:	68 08 3a 80 00       	push   $0x803a08
  802b0f:	68 5b 01 00 00       	push   $0x15b
  802b14:	68 97 39 80 00       	push   $0x803997
  802b19:	e8 ab 03 00 00       	call   802ec9 <_panic>
  802b1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	85 c0                	test   %eax,%eax
  802b25:	74 10                	je     802b37 <insert_sorted_with_merge_freeList+0x3b7>
  802b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2a:	8b 00                	mov    (%eax),%eax
  802b2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b2f:	8b 52 04             	mov    0x4(%edx),%edx
  802b32:	89 50 04             	mov    %edx,0x4(%eax)
  802b35:	eb 0b                	jmp    802b42 <insert_sorted_with_merge_freeList+0x3c2>
  802b37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b3a:	8b 40 04             	mov    0x4(%eax),%eax
  802b3d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	85 c0                	test   %eax,%eax
  802b4a:	74 0f                	je     802b5b <insert_sorted_with_merge_freeList+0x3db>
  802b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b4f:	8b 40 04             	mov    0x4(%eax),%eax
  802b52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b55:	8b 12                	mov    (%edx),%edx
  802b57:	89 10                	mov    %edx,(%eax)
  802b59:	eb 0a                	jmp    802b65 <insert_sorted_with_merge_freeList+0x3e5>
  802b5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5e:	8b 00                	mov    (%eax),%eax
  802b60:	a3 38 41 80 00       	mov    %eax,0x804138
  802b65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b78:	a1 44 41 80 00       	mov    0x804144,%eax
  802b7d:	48                   	dec    %eax
  802b7e:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b87:	75 17                	jne    802ba0 <insert_sorted_with_merge_freeList+0x420>
  802b89:	83 ec 04             	sub    $0x4,%esp
  802b8c:	68 74 39 80 00       	push   $0x803974
  802b91:	68 5c 01 00 00       	push   $0x15c
  802b96:	68 97 39 80 00       	push   $0x803997
  802b9b:	e8 29 03 00 00       	call   802ec9 <_panic>
  802ba0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	89 10                	mov    %edx,(%eax)
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	85 c0                	test   %eax,%eax
  802bb2:	74 0d                	je     802bc1 <insert_sorted_with_merge_freeList+0x441>
  802bb4:	a1 48 41 80 00       	mov    0x804148,%eax
  802bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbc:	89 50 04             	mov    %edx,0x4(%eax)
  802bbf:	eb 08                	jmp    802bc9 <insert_sorted_with_merge_freeList+0x449>
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	a3 48 41 80 00       	mov    %eax,0x804148
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdb:	a1 54 41 80 00       	mov    0x804154,%eax
  802be0:	40                   	inc    %eax
  802be1:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802be6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bea:	75 17                	jne    802c03 <insert_sorted_with_merge_freeList+0x483>
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	68 74 39 80 00       	push   $0x803974
  802bf4:	68 5d 01 00 00       	push   $0x15d
  802bf9:	68 97 39 80 00       	push   $0x803997
  802bfe:	e8 c6 02 00 00       	call   802ec9 <_panic>
  802c03:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0c:	89 10                	mov    %edx,(%eax)
  802c0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	74 0d                	je     802c24 <insert_sorted_with_merge_freeList+0x4a4>
  802c17:	a1 48 41 80 00       	mov    0x804148,%eax
  802c1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c1f:	89 50 04             	mov    %edx,0x4(%eax)
  802c22:	eb 08                	jmp    802c2c <insert_sorted_with_merge_freeList+0x4ac>
  802c24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c27:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2f:	a3 48 41 80 00       	mov    %eax,0x804148
  802c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3e:	a1 54 41 80 00       	mov    0x804154,%eax
  802c43:	40                   	inc    %eax
  802c44:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802c49:	e9 78 02 00 00       	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 50 08             	mov    0x8(%eax),%edx
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5a:	01 c2                	add    %eax,%edx
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	8b 40 08             	mov    0x8(%eax),%eax
  802c62:	39 c2                	cmp    %eax,%edx
  802c64:	0f 83 b8 00 00 00    	jae    802d22 <insert_sorted_with_merge_freeList+0x5a2>
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	8b 50 08             	mov    0x8(%eax),%edx
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	8b 40 0c             	mov    0xc(%eax),%eax
  802c76:	01 c2                	add    %eax,%edx
  802c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7b:	8b 40 08             	mov    0x8(%eax),%eax
  802c7e:	39 c2                	cmp    %eax,%edx
  802c80:	0f 85 9c 00 00 00    	jne    802d22 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802c86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c89:	8b 50 0c             	mov    0xc(%eax),%edx
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c92:	01 c2                	add    %eax,%edx
  802c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c97:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca3:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802cba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cbe:	75 17                	jne    802cd7 <insert_sorted_with_merge_freeList+0x557>
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 74 39 80 00       	push   $0x803974
  802cc8:	68 67 01 00 00       	push   $0x167
  802ccd:	68 97 39 80 00       	push   $0x803997
  802cd2:	e8 f2 01 00 00       	call   802ec9 <_panic>
  802cd7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce0:	89 10                	mov    %edx,(%eax)
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	74 0d                	je     802cf8 <insert_sorted_with_merge_freeList+0x578>
  802ceb:	a1 48 41 80 00       	mov    0x804148,%eax
  802cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf3:	89 50 04             	mov    %edx,0x4(%eax)
  802cf6:	eb 08                	jmp    802d00 <insert_sorted_with_merge_freeList+0x580>
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	a3 48 41 80 00       	mov    %eax,0x804148
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d12:	a1 54 41 80 00       	mov    0x804154,%eax
  802d17:	40                   	inc    %eax
  802d18:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802d1d:	e9 a4 01 00 00       	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 50 08             	mov    0x8(%eax),%edx
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2e:	01 c2                	add    %eax,%edx
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 40 08             	mov    0x8(%eax),%eax
  802d36:	39 c2                	cmp    %eax,%edx
  802d38:	0f 85 ac 00 00 00    	jne    802dea <insert_sorted_with_merge_freeList+0x66a>
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	8b 50 08             	mov    0x8(%eax),%edx
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4a:	01 c2                	add    %eax,%edx
  802d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d4f:	8b 40 08             	mov    0x8(%eax),%eax
  802d52:	39 c2                	cmp    %eax,%edx
  802d54:	0f 83 90 00 00 00    	jae    802dea <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	8b 40 0c             	mov    0xc(%eax),%eax
  802d66:	01 c2                	add    %eax,%edx
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d86:	75 17                	jne    802d9f <insert_sorted_with_merge_freeList+0x61f>
  802d88:	83 ec 04             	sub    $0x4,%esp
  802d8b:	68 74 39 80 00       	push   $0x803974
  802d90:	68 70 01 00 00       	push   $0x170
  802d95:	68 97 39 80 00       	push   $0x803997
  802d9a:	e8 2a 01 00 00       	call   802ec9 <_panic>
  802d9f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	89 10                	mov    %edx,(%eax)
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	85 c0                	test   %eax,%eax
  802db1:	74 0d                	je     802dc0 <insert_sorted_with_merge_freeList+0x640>
  802db3:	a1 48 41 80 00       	mov    0x804148,%eax
  802db8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbb:	89 50 04             	mov    %edx,0x4(%eax)
  802dbe:	eb 08                	jmp    802dc8 <insert_sorted_with_merge_freeList+0x648>
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	a3 48 41 80 00       	mov    %eax,0x804148
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dda:	a1 54 41 80 00       	mov    0x804154,%eax
  802ddf:	40                   	inc    %eax
  802de0:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802de5:	e9 dc 00 00 00       	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 50 08             	mov    0x8(%eax),%edx
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 40 0c             	mov    0xc(%eax),%eax
  802df6:	01 c2                	add    %eax,%edx
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	8b 40 08             	mov    0x8(%eax),%eax
  802dfe:	39 c2                	cmp    %eax,%edx
  802e00:	0f 83 88 00 00 00    	jae    802e8e <insert_sorted_with_merge_freeList+0x70e>
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 50 08             	mov    0x8(%eax),%edx
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e12:	01 c2                	add    %eax,%edx
  802e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e17:	8b 40 08             	mov    0x8(%eax),%eax
  802e1a:	39 c2                	cmp    %eax,%edx
  802e1c:	73 70                	jae    802e8e <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e22:	74 06                	je     802e2a <insert_sorted_with_merge_freeList+0x6aa>
  802e24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e28:	75 17                	jne    802e41 <insert_sorted_with_merge_freeList+0x6c1>
  802e2a:	83 ec 04             	sub    $0x4,%esp
  802e2d:	68 d4 39 80 00       	push   $0x8039d4
  802e32:	68 75 01 00 00       	push   $0x175
  802e37:	68 97 39 80 00       	push   $0x803997
  802e3c:	e8 88 00 00 00       	call   802ec9 <_panic>
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 10                	mov    (%eax),%edx
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	89 10                	mov    %edx,(%eax)
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	74 0b                	je     802e5f <insert_sorted_with_merge_freeList+0x6df>
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5c:	89 50 04             	mov    %edx,0x4(%eax)
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	8b 55 08             	mov    0x8(%ebp),%edx
  802e65:	89 10                	mov    %edx,(%eax)
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6d:	89 50 04             	mov    %edx,0x4(%eax)
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	75 08                	jne    802e81 <insert_sorted_with_merge_freeList+0x701>
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e81:	a1 44 41 80 00       	mov    0x804144,%eax
  802e86:	40                   	inc    %eax
  802e87:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  802e8c:	eb 38                	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802e8e:	a1 40 41 80 00       	mov    0x804140,%eax
  802e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e9a:	74 07                	je     802ea3 <insert_sorted_with_merge_freeList+0x723>
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 00                	mov    (%eax),%eax
  802ea1:	eb 05                	jmp    802ea8 <insert_sorted_with_merge_freeList+0x728>
  802ea3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ea8:	a3 40 41 80 00       	mov    %eax,0x804140
  802ead:	a1 40 41 80 00       	mov    0x804140,%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	0f 85 c3 fb ff ff    	jne    802a7d <insert_sorted_with_merge_freeList+0x2fd>
  802eba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebe:	0f 85 b9 fb ff ff    	jne    802a7d <insert_sorted_with_merge_freeList+0x2fd>





}
  802ec4:	eb 00                	jmp    802ec6 <insert_sorted_with_merge_freeList+0x746>
  802ec6:	90                   	nop
  802ec7:	c9                   	leave  
  802ec8:	c3                   	ret    

00802ec9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802ec9:	55                   	push   %ebp
  802eca:	89 e5                	mov    %esp,%ebp
  802ecc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802ecf:	8d 45 10             	lea    0x10(%ebp),%eax
  802ed2:	83 c0 04             	add    $0x4,%eax
  802ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802ed8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	74 16                	je     802ef7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802ee1:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802ee6:	83 ec 08             	sub    $0x8,%esp
  802ee9:	50                   	push   %eax
  802eea:	68 58 3a 80 00       	push   $0x803a58
  802eef:	e8 66 d5 ff ff       	call   80045a <cprintf>
  802ef4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802ef7:	a1 00 40 80 00       	mov    0x804000,%eax
  802efc:	ff 75 0c             	pushl  0xc(%ebp)
  802eff:	ff 75 08             	pushl  0x8(%ebp)
  802f02:	50                   	push   %eax
  802f03:	68 5d 3a 80 00       	push   $0x803a5d
  802f08:	e8 4d d5 ff ff       	call   80045a <cprintf>
  802f0d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802f10:	8b 45 10             	mov    0x10(%ebp),%eax
  802f13:	83 ec 08             	sub    $0x8,%esp
  802f16:	ff 75 f4             	pushl  -0xc(%ebp)
  802f19:	50                   	push   %eax
  802f1a:	e8 d0 d4 ff ff       	call   8003ef <vcprintf>
  802f1f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802f22:	83 ec 08             	sub    $0x8,%esp
  802f25:	6a 00                	push   $0x0
  802f27:	68 79 3a 80 00       	push   $0x803a79
  802f2c:	e8 be d4 ff ff       	call   8003ef <vcprintf>
  802f31:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802f34:	e8 3f d4 ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  802f39:	eb fe                	jmp    802f39 <_panic+0x70>

00802f3b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802f3b:	55                   	push   %ebp
  802f3c:	89 e5                	mov    %esp,%ebp
  802f3e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802f41:	a1 20 40 80 00       	mov    0x804020,%eax
  802f46:	8b 50 74             	mov    0x74(%eax),%edx
  802f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4c:	39 c2                	cmp    %eax,%edx
  802f4e:	74 14                	je     802f64 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	68 7c 3a 80 00       	push   $0x803a7c
  802f58:	6a 26                	push   $0x26
  802f5a:	68 c8 3a 80 00       	push   $0x803ac8
  802f5f:	e8 65 ff ff ff       	call   802ec9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802f64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802f6b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802f72:	e9 c2 00 00 00       	jmp    803039 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	01 d0                	add    %edx,%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	75 08                	jne    802f94 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802f8c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802f8f:	e9 a2 00 00 00       	jmp    803036 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802f94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  802f9b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  802fa2:	eb 69                	jmp    80300d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  802fa4:	a1 20 40 80 00       	mov    0x804020,%eax
  802fa9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802faf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb2:	89 d0                	mov    %edx,%eax
  802fb4:	01 c0                	add    %eax,%eax
  802fb6:	01 d0                	add    %edx,%eax
  802fb8:	c1 e0 03             	shl    $0x3,%eax
  802fbb:	01 c8                	add    %ecx,%eax
  802fbd:	8a 40 04             	mov    0x4(%eax),%al
  802fc0:	84 c0                	test   %al,%al
  802fc2:	75 46                	jne    80300a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802fc4:	a1 20 40 80 00       	mov    0x804020,%eax
  802fc9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  802fcf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd2:	89 d0                	mov    %edx,%eax
  802fd4:	01 c0                	add    %eax,%eax
  802fd6:	01 d0                	add    %edx,%eax
  802fd8:	c1 e0 03             	shl    $0x3,%eax
  802fdb:	01 c8                	add    %ecx,%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fe2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802fea:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  802fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	01 c8                	add    %ecx,%eax
  802ffb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  802ffd:	39 c2                	cmp    %eax,%edx
  802fff:	75 09                	jne    80300a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803001:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803008:	eb 12                	jmp    80301c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80300a:	ff 45 e8             	incl   -0x18(%ebp)
  80300d:	a1 20 40 80 00       	mov    0x804020,%eax
  803012:	8b 50 74             	mov    0x74(%eax),%edx
  803015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803018:	39 c2                	cmp    %eax,%edx
  80301a:	77 88                	ja     802fa4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80301c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803020:	75 14                	jne    803036 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	68 d4 3a 80 00       	push   $0x803ad4
  80302a:	6a 3a                	push   $0x3a
  80302c:	68 c8 3a 80 00       	push   $0x803ac8
  803031:	e8 93 fe ff ff       	call   802ec9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803036:	ff 45 f0             	incl   -0x10(%ebp)
  803039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80303f:	0f 8c 32 ff ff ff    	jl     802f77 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803045:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80304c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803053:	eb 26                	jmp    80307b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803055:	a1 20 40 80 00       	mov    0x804020,%eax
  80305a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803060:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803063:	89 d0                	mov    %edx,%eax
  803065:	01 c0                	add    %eax,%eax
  803067:	01 d0                	add    %edx,%eax
  803069:	c1 e0 03             	shl    $0x3,%eax
  80306c:	01 c8                	add    %ecx,%eax
  80306e:	8a 40 04             	mov    0x4(%eax),%al
  803071:	3c 01                	cmp    $0x1,%al
  803073:	75 03                	jne    803078 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803075:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803078:	ff 45 e0             	incl   -0x20(%ebp)
  80307b:	a1 20 40 80 00       	mov    0x804020,%eax
  803080:	8b 50 74             	mov    0x74(%eax),%edx
  803083:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803086:	39 c2                	cmp    %eax,%edx
  803088:	77 cb                	ja     803055 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803090:	74 14                	je     8030a6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	68 28 3b 80 00       	push   $0x803b28
  80309a:	6a 44                	push   $0x44
  80309c:	68 c8 3a 80 00       	push   $0x803ac8
  8030a1:	e8 23 fe ff ff       	call   802ec9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8030a6:	90                   	nop
  8030a7:	c9                   	leave  
  8030a8:	c3                   	ret    
  8030a9:	66 90                	xchg   %ax,%ax
  8030ab:	90                   	nop

008030ac <__udivdi3>:
  8030ac:	55                   	push   %ebp
  8030ad:	57                   	push   %edi
  8030ae:	56                   	push   %esi
  8030af:	53                   	push   %ebx
  8030b0:	83 ec 1c             	sub    $0x1c,%esp
  8030b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030c3:	89 ca                	mov    %ecx,%edx
  8030c5:	89 f8                	mov    %edi,%eax
  8030c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030cb:	85 f6                	test   %esi,%esi
  8030cd:	75 2d                	jne    8030fc <__udivdi3+0x50>
  8030cf:	39 cf                	cmp    %ecx,%edi
  8030d1:	77 65                	ja     803138 <__udivdi3+0x8c>
  8030d3:	89 fd                	mov    %edi,%ebp
  8030d5:	85 ff                	test   %edi,%edi
  8030d7:	75 0b                	jne    8030e4 <__udivdi3+0x38>
  8030d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8030de:	31 d2                	xor    %edx,%edx
  8030e0:	f7 f7                	div    %edi
  8030e2:	89 c5                	mov    %eax,%ebp
  8030e4:	31 d2                	xor    %edx,%edx
  8030e6:	89 c8                	mov    %ecx,%eax
  8030e8:	f7 f5                	div    %ebp
  8030ea:	89 c1                	mov    %eax,%ecx
  8030ec:	89 d8                	mov    %ebx,%eax
  8030ee:	f7 f5                	div    %ebp
  8030f0:	89 cf                	mov    %ecx,%edi
  8030f2:	89 fa                	mov    %edi,%edx
  8030f4:	83 c4 1c             	add    $0x1c,%esp
  8030f7:	5b                   	pop    %ebx
  8030f8:	5e                   	pop    %esi
  8030f9:	5f                   	pop    %edi
  8030fa:	5d                   	pop    %ebp
  8030fb:	c3                   	ret    
  8030fc:	39 ce                	cmp    %ecx,%esi
  8030fe:	77 28                	ja     803128 <__udivdi3+0x7c>
  803100:	0f bd fe             	bsr    %esi,%edi
  803103:	83 f7 1f             	xor    $0x1f,%edi
  803106:	75 40                	jne    803148 <__udivdi3+0x9c>
  803108:	39 ce                	cmp    %ecx,%esi
  80310a:	72 0a                	jb     803116 <__udivdi3+0x6a>
  80310c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803110:	0f 87 9e 00 00 00    	ja     8031b4 <__udivdi3+0x108>
  803116:	b8 01 00 00 00       	mov    $0x1,%eax
  80311b:	89 fa                	mov    %edi,%edx
  80311d:	83 c4 1c             	add    $0x1c,%esp
  803120:	5b                   	pop    %ebx
  803121:	5e                   	pop    %esi
  803122:	5f                   	pop    %edi
  803123:	5d                   	pop    %ebp
  803124:	c3                   	ret    
  803125:	8d 76 00             	lea    0x0(%esi),%esi
  803128:	31 ff                	xor    %edi,%edi
  80312a:	31 c0                	xor    %eax,%eax
  80312c:	89 fa                	mov    %edi,%edx
  80312e:	83 c4 1c             	add    $0x1c,%esp
  803131:	5b                   	pop    %ebx
  803132:	5e                   	pop    %esi
  803133:	5f                   	pop    %edi
  803134:	5d                   	pop    %ebp
  803135:	c3                   	ret    
  803136:	66 90                	xchg   %ax,%ax
  803138:	89 d8                	mov    %ebx,%eax
  80313a:	f7 f7                	div    %edi
  80313c:	31 ff                	xor    %edi,%edi
  80313e:	89 fa                	mov    %edi,%edx
  803140:	83 c4 1c             	add    $0x1c,%esp
  803143:	5b                   	pop    %ebx
  803144:	5e                   	pop    %esi
  803145:	5f                   	pop    %edi
  803146:	5d                   	pop    %ebp
  803147:	c3                   	ret    
  803148:	bd 20 00 00 00       	mov    $0x20,%ebp
  80314d:	89 eb                	mov    %ebp,%ebx
  80314f:	29 fb                	sub    %edi,%ebx
  803151:	89 f9                	mov    %edi,%ecx
  803153:	d3 e6                	shl    %cl,%esi
  803155:	89 c5                	mov    %eax,%ebp
  803157:	88 d9                	mov    %bl,%cl
  803159:	d3 ed                	shr    %cl,%ebp
  80315b:	89 e9                	mov    %ebp,%ecx
  80315d:	09 f1                	or     %esi,%ecx
  80315f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803163:	89 f9                	mov    %edi,%ecx
  803165:	d3 e0                	shl    %cl,%eax
  803167:	89 c5                	mov    %eax,%ebp
  803169:	89 d6                	mov    %edx,%esi
  80316b:	88 d9                	mov    %bl,%cl
  80316d:	d3 ee                	shr    %cl,%esi
  80316f:	89 f9                	mov    %edi,%ecx
  803171:	d3 e2                	shl    %cl,%edx
  803173:	8b 44 24 08          	mov    0x8(%esp),%eax
  803177:	88 d9                	mov    %bl,%cl
  803179:	d3 e8                	shr    %cl,%eax
  80317b:	09 c2                	or     %eax,%edx
  80317d:	89 d0                	mov    %edx,%eax
  80317f:	89 f2                	mov    %esi,%edx
  803181:	f7 74 24 0c          	divl   0xc(%esp)
  803185:	89 d6                	mov    %edx,%esi
  803187:	89 c3                	mov    %eax,%ebx
  803189:	f7 e5                	mul    %ebp
  80318b:	39 d6                	cmp    %edx,%esi
  80318d:	72 19                	jb     8031a8 <__udivdi3+0xfc>
  80318f:	74 0b                	je     80319c <__udivdi3+0xf0>
  803191:	89 d8                	mov    %ebx,%eax
  803193:	31 ff                	xor    %edi,%edi
  803195:	e9 58 ff ff ff       	jmp    8030f2 <__udivdi3+0x46>
  80319a:	66 90                	xchg   %ax,%ax
  80319c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031a0:	89 f9                	mov    %edi,%ecx
  8031a2:	d3 e2                	shl    %cl,%edx
  8031a4:	39 c2                	cmp    %eax,%edx
  8031a6:	73 e9                	jae    803191 <__udivdi3+0xe5>
  8031a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031ab:	31 ff                	xor    %edi,%edi
  8031ad:	e9 40 ff ff ff       	jmp    8030f2 <__udivdi3+0x46>
  8031b2:	66 90                	xchg   %ax,%ax
  8031b4:	31 c0                	xor    %eax,%eax
  8031b6:	e9 37 ff ff ff       	jmp    8030f2 <__udivdi3+0x46>
  8031bb:	90                   	nop

008031bc <__umoddi3>:
  8031bc:	55                   	push   %ebp
  8031bd:	57                   	push   %edi
  8031be:	56                   	push   %esi
  8031bf:	53                   	push   %ebx
  8031c0:	83 ec 1c             	sub    $0x1c,%esp
  8031c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031db:	89 f3                	mov    %esi,%ebx
  8031dd:	89 fa                	mov    %edi,%edx
  8031df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031e3:	89 34 24             	mov    %esi,(%esp)
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	75 1a                	jne    803204 <__umoddi3+0x48>
  8031ea:	39 f7                	cmp    %esi,%edi
  8031ec:	0f 86 a2 00 00 00    	jbe    803294 <__umoddi3+0xd8>
  8031f2:	89 c8                	mov    %ecx,%eax
  8031f4:	89 f2                	mov    %esi,%edx
  8031f6:	f7 f7                	div    %edi
  8031f8:	89 d0                	mov    %edx,%eax
  8031fa:	31 d2                	xor    %edx,%edx
  8031fc:	83 c4 1c             	add    $0x1c,%esp
  8031ff:	5b                   	pop    %ebx
  803200:	5e                   	pop    %esi
  803201:	5f                   	pop    %edi
  803202:	5d                   	pop    %ebp
  803203:	c3                   	ret    
  803204:	39 f0                	cmp    %esi,%eax
  803206:	0f 87 ac 00 00 00    	ja     8032b8 <__umoddi3+0xfc>
  80320c:	0f bd e8             	bsr    %eax,%ebp
  80320f:	83 f5 1f             	xor    $0x1f,%ebp
  803212:	0f 84 ac 00 00 00    	je     8032c4 <__umoddi3+0x108>
  803218:	bf 20 00 00 00       	mov    $0x20,%edi
  80321d:	29 ef                	sub    %ebp,%edi
  80321f:	89 fe                	mov    %edi,%esi
  803221:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803225:	89 e9                	mov    %ebp,%ecx
  803227:	d3 e0                	shl    %cl,%eax
  803229:	89 d7                	mov    %edx,%edi
  80322b:	89 f1                	mov    %esi,%ecx
  80322d:	d3 ef                	shr    %cl,%edi
  80322f:	09 c7                	or     %eax,%edi
  803231:	89 e9                	mov    %ebp,%ecx
  803233:	d3 e2                	shl    %cl,%edx
  803235:	89 14 24             	mov    %edx,(%esp)
  803238:	89 d8                	mov    %ebx,%eax
  80323a:	d3 e0                	shl    %cl,%eax
  80323c:	89 c2                	mov    %eax,%edx
  80323e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803242:	d3 e0                	shl    %cl,%eax
  803244:	89 44 24 04          	mov    %eax,0x4(%esp)
  803248:	8b 44 24 08          	mov    0x8(%esp),%eax
  80324c:	89 f1                	mov    %esi,%ecx
  80324e:	d3 e8                	shr    %cl,%eax
  803250:	09 d0                	or     %edx,%eax
  803252:	d3 eb                	shr    %cl,%ebx
  803254:	89 da                	mov    %ebx,%edx
  803256:	f7 f7                	div    %edi
  803258:	89 d3                	mov    %edx,%ebx
  80325a:	f7 24 24             	mull   (%esp)
  80325d:	89 c6                	mov    %eax,%esi
  80325f:	89 d1                	mov    %edx,%ecx
  803261:	39 d3                	cmp    %edx,%ebx
  803263:	0f 82 87 00 00 00    	jb     8032f0 <__umoddi3+0x134>
  803269:	0f 84 91 00 00 00    	je     803300 <__umoddi3+0x144>
  80326f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803273:	29 f2                	sub    %esi,%edx
  803275:	19 cb                	sbb    %ecx,%ebx
  803277:	89 d8                	mov    %ebx,%eax
  803279:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80327d:	d3 e0                	shl    %cl,%eax
  80327f:	89 e9                	mov    %ebp,%ecx
  803281:	d3 ea                	shr    %cl,%edx
  803283:	09 d0                	or     %edx,%eax
  803285:	89 e9                	mov    %ebp,%ecx
  803287:	d3 eb                	shr    %cl,%ebx
  803289:	89 da                	mov    %ebx,%edx
  80328b:	83 c4 1c             	add    $0x1c,%esp
  80328e:	5b                   	pop    %ebx
  80328f:	5e                   	pop    %esi
  803290:	5f                   	pop    %edi
  803291:	5d                   	pop    %ebp
  803292:	c3                   	ret    
  803293:	90                   	nop
  803294:	89 fd                	mov    %edi,%ebp
  803296:	85 ff                	test   %edi,%edi
  803298:	75 0b                	jne    8032a5 <__umoddi3+0xe9>
  80329a:	b8 01 00 00 00       	mov    $0x1,%eax
  80329f:	31 d2                	xor    %edx,%edx
  8032a1:	f7 f7                	div    %edi
  8032a3:	89 c5                	mov    %eax,%ebp
  8032a5:	89 f0                	mov    %esi,%eax
  8032a7:	31 d2                	xor    %edx,%edx
  8032a9:	f7 f5                	div    %ebp
  8032ab:	89 c8                	mov    %ecx,%eax
  8032ad:	f7 f5                	div    %ebp
  8032af:	89 d0                	mov    %edx,%eax
  8032b1:	e9 44 ff ff ff       	jmp    8031fa <__umoddi3+0x3e>
  8032b6:	66 90                	xchg   %ax,%ax
  8032b8:	89 c8                	mov    %ecx,%eax
  8032ba:	89 f2                	mov    %esi,%edx
  8032bc:	83 c4 1c             	add    $0x1c,%esp
  8032bf:	5b                   	pop    %ebx
  8032c0:	5e                   	pop    %esi
  8032c1:	5f                   	pop    %edi
  8032c2:	5d                   	pop    %ebp
  8032c3:	c3                   	ret    
  8032c4:	3b 04 24             	cmp    (%esp),%eax
  8032c7:	72 06                	jb     8032cf <__umoddi3+0x113>
  8032c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032cd:	77 0f                	ja     8032de <__umoddi3+0x122>
  8032cf:	89 f2                	mov    %esi,%edx
  8032d1:	29 f9                	sub    %edi,%ecx
  8032d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032d7:	89 14 24             	mov    %edx,(%esp)
  8032da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032e2:	8b 14 24             	mov    (%esp),%edx
  8032e5:	83 c4 1c             	add    $0x1c,%esp
  8032e8:	5b                   	pop    %ebx
  8032e9:	5e                   	pop    %esi
  8032ea:	5f                   	pop    %edi
  8032eb:	5d                   	pop    %ebp
  8032ec:	c3                   	ret    
  8032ed:	8d 76 00             	lea    0x0(%esi),%esi
  8032f0:	2b 04 24             	sub    (%esp),%eax
  8032f3:	19 fa                	sbb    %edi,%edx
  8032f5:	89 d1                	mov    %edx,%ecx
  8032f7:	89 c6                	mov    %eax,%esi
  8032f9:	e9 71 ff ff ff       	jmp    80326f <__umoddi3+0xb3>
  8032fe:	66 90                	xchg   %ax,%ax
  803300:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803304:	72 ea                	jb     8032f0 <__umoddi3+0x134>
  803306:	89 d9                	mov    %ebx,%ecx
  803308:	e9 62 ff ff ff       	jmp    80326f <__umoddi3+0xb3>
