
obj/user/tst_page_replacement_LRU_Lists_1:     file format elf32-i386


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
  800031:	e8 b9 01 00 00       	call   8001ef <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
char arr[PAGE_SIZE*12];
char* ptr = (char* )0x0801000 ;
char* ptr2 = (char* )0x0804000 ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp

//	cprintf("envID = %d\n",envID);

	//("STEP 0: checking Initial WS entries ...\n");
	{
		uint32 actual_active_list[5] = {0x803000, 0x801000, 0x800000, 0xeebfd000, 0x203000};
  800041:	8d 45 b8             	lea    -0x48(%ebp),%eax
  800044:	bb 34 1e 80 00       	mov    $0x801e34,%ebx
  800049:	ba 05 00 00 00       	mov    $0x5,%edx
  80004e:	89 c7                	mov    %eax,%edi
  800050:	89 de                	mov    %ebx,%esi
  800052:	89 d1                	mov    %edx,%ecx
  800054:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		uint32 actual_second_list[5] = {0x202000, 0x201000, 0x200000, 0x802000, 0x205000};
  800056:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  800059:	bb 48 1e 80 00       	mov    $0x801e48,%ebx
  80005e:	ba 05 00 00 00       	mov    $0x5,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 5, 5);
  80006b:	6a 05                	push   $0x5
  80006d:	6a 05                	push   $0x5
  80006f:	8d 45 a4             	lea    -0x5c(%ebp),%eax
  800072:	50                   	push   %eax
  800073:	8d 45 b8             	lea    -0x48(%ebp),%eax
  800076:	50                   	push   %eax
  800077:	e8 09 19 00 00       	call   801985 <sys_check_LRU_lists>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if(check == 0)
  800082:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800086:	75 14                	jne    80009c <_main+0x64>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  800088:	83 ec 04             	sub    $0x4,%esp
  80008b:	68 40 1c 80 00       	push   $0x801c40
  800090:	6a 18                	push   $0x18
  800092:	68 90 1c 80 00       	push   $0x801c90
  800097:	e8 8f 02 00 00       	call   80032b <_panic>
	}

	int freePages = sys_calculate_free_frames();
  80009c:	e8 b4 13 00 00       	call   801455 <sys_calculate_free_frames>
  8000a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000a4:	e8 4c 14 00 00       	call   8014f5 <sys_pf_calculate_allocated_pages>
  8000a9:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8000ac:	a0 5f e0 80 00       	mov    0x80e05f,%al
  8000b1:	88 45 d7             	mov    %al,-0x29(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8000b4:	a0 5f f0 80 00       	mov    0x80f05f,%al
  8000b9:	88 45 d6             	mov    %al,-0x2a(%ebp)

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000c3:	eb 37                	jmp    8000fc <_main+0xc4>
	{
		arr[i] = -1 ;
  8000c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c8:	05 60 30 80 00       	add    $0x803060,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		*ptr2 = *ptr ;
  8000d0:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d5:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8000db:	8a 12                	mov    (%edx),%dl
  8000dd:	88 10                	mov    %dl,(%eax)
		ptr++ ; ptr2++ ;
  8000df:	a1 00 30 80 00       	mov    0x803000,%eax
  8000e4:	40                   	inc    %eax
  8000e5:	a3 00 30 80 00       	mov    %eax,0x803000
  8000ea:	a1 04 30 80 00       	mov    0x803004,%eax
  8000ef:	40                   	inc    %eax
  8000f0:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage1 = arr[PAGE_SIZE*11-1] ;
	char garbage2 = arr[PAGE_SIZE*12-1] ;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000f5:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  8000fc:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  800103:	7e c0                	jle    8000c5 <_main+0x8d>

	//===================

	//cprintf("Checking Allocation in Mem & Page File... \n");
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  800105:	e8 eb 13 00 00       	call   8014f5 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 b8 1c 80 00       	push   $0x801cb8
  800117:	6a 33                	push   $0x33
  800119:	68 90 1c 80 00       	push   $0x801c90
  80011e:	e8 08 02 00 00       	call   80032b <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  800123:	e8 2d 13 00 00       	call   801455 <sys_calculate_free_frames>
  800128:	89 c3                	mov    %eax,%ebx
  80012a:	e8 3f 13 00 00       	call   80146e <sys_calculate_modified_frames>
  80012f:	01 d8                	add    %ebx,%eax
  800131:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  800134:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800137:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80013a:	74 14                	je     800150 <_main+0x118>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 24 1d 80 00       	push   $0x801d24
  800144:	6a 37                	push   $0x37
  800146:	68 90 1c 80 00       	push   $0x801c90
  80014b:	e8 db 01 00 00       	call   80032b <_panic>
	}

	//cprintf("Checking CONTENT in Mem ... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800150:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800157:	eb 29                	jmp    800182 <_main+0x14a>
			if( arr[i] != -1) panic("Modified page(s) not restored correctly");
  800159:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80015c:	05 60 30 80 00       	add    $0x803060,%eax
  800161:	8a 00                	mov    (%eax),%al
  800163:	3c ff                	cmp    $0xff,%al
  800165:	74 14                	je     80017b <_main+0x143>
  800167:	83 ec 04             	sub    $0x4,%esp
  80016a:	68 88 1d 80 00       	push   $0x801d88
  80016f:	6a 3d                	push   $0x3d
  800171:	68 90 1c 80 00       	push   $0x801c90
  800176:	e8 b0 01 00 00       	call   80032b <_panic>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
	}

	//cprintf("Checking CONTENT in Mem ... \n");
	{
		for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  80017b:	81 45 e4 00 08 00 00 	addl   $0x800,-0x1c(%ebp)
  800182:	81 7d e4 ff 9f 00 00 	cmpl   $0x9fff,-0x1c(%ebp)
  800189:	7e ce                	jle    800159 <_main+0x121>
			if( arr[i] != -1) panic("Modified page(s) not restored correctly");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  80018b:	e8 65 13 00 00       	call   8014f5 <sys_pf_calculate_allocated_pages>
  800190:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 b8 1c 80 00       	push   $0x801cb8
  80019d:	6a 3e                	push   $0x3e
  80019f:	68 90 1c 80 00       	push   $0x801c90
  8001a4:	e8 82 01 00 00       	call   80032b <_panic>

		uint32 freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  8001a9:	e8 a7 12 00 00       	call   801455 <sys_calculate_free_frames>
  8001ae:	89 c3                	mov    %eax,%ebx
  8001b0:	e8 b9 12 00 00       	call   80146e <sys_calculate_modified_frames>
  8001b5:	01 d8                	add    %ebx,%eax
  8001b7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  8001ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001bd:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated");
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 24 1d 80 00       	push   $0x801d24
  8001ca:	6a 42                	push   $0x42
  8001cc:	68 90 1c 80 00       	push   $0x801c90
  8001d1:	e8 55 01 00 00       	call   80032b <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] by REMOVING ONLY ONE PAGE using APRROXIMATED LRU is completed successfully.\n");
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	68 b0 1d 80 00       	push   $0x801db0
  8001de:	e8 fc 03 00 00       	call   8005df <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	return;
  8001e6:	90                   	nop
}
  8001e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ea:	5b                   	pop    %ebx
  8001eb:	5e                   	pop    %esi
  8001ec:	5f                   	pop    %edi
  8001ed:	5d                   	pop    %ebp
  8001ee:	c3                   	ret    

008001ef <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ef:	55                   	push   %ebp
  8001f0:	89 e5                	mov    %esp,%ebp
  8001f2:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f5:	e8 3b 15 00 00       	call   801735 <sys_getenvindex>
  8001fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800200:	89 d0                	mov    %edx,%eax
  800202:	c1 e0 03             	shl    $0x3,%eax
  800205:	01 d0                	add    %edx,%eax
  800207:	01 c0                	add    %eax,%eax
  800209:	01 d0                	add    %edx,%eax
  80020b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800212:	01 d0                	add    %edx,%eax
  800214:	c1 e0 04             	shl    $0x4,%eax
  800217:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80021c:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800221:	a1 20 30 80 00       	mov    0x803020,%eax
  800226:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80022c:	84 c0                	test   %al,%al
  80022e:	74 0f                	je     80023f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800230:	a1 20 30 80 00       	mov    0x803020,%eax
  800235:	05 5c 05 00 00       	add    $0x55c,%eax
  80023a:	a3 08 30 80 00       	mov    %eax,0x803008

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800243:	7e 0a                	jle    80024f <libmain+0x60>
		binaryname = argv[0];
  800245:	8b 45 0c             	mov    0xc(%ebp),%eax
  800248:	8b 00                	mov    (%eax),%eax
  80024a:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	_main(argc, argv);
  80024f:	83 ec 08             	sub    $0x8,%esp
  800252:	ff 75 0c             	pushl  0xc(%ebp)
  800255:	ff 75 08             	pushl  0x8(%ebp)
  800258:	e8 db fd ff ff       	call   800038 <_main>
  80025d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800260:	e8 dd 12 00 00       	call   801542 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	68 74 1e 80 00       	push   $0x801e74
  80026d:	e8 6d 03 00 00       	call   8005df <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800275:	a1 20 30 80 00       	mov    0x803020,%eax
  80027a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800280:	a1 20 30 80 00       	mov    0x803020,%eax
  800285:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80028b:	83 ec 04             	sub    $0x4,%esp
  80028e:	52                   	push   %edx
  80028f:	50                   	push   %eax
  800290:	68 9c 1e 80 00       	push   $0x801e9c
  800295:	e8 45 03 00 00       	call   8005df <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80029d:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a8:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ad:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002be:	51                   	push   %ecx
  8002bf:	52                   	push   %edx
  8002c0:	50                   	push   %eax
  8002c1:	68 c4 1e 80 00       	push   $0x801ec4
  8002c6:	e8 14 03 00 00       	call   8005df <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002ce:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d3:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	50                   	push   %eax
  8002dd:	68 1c 1f 80 00       	push   $0x801f1c
  8002e2:	e8 f8 02 00 00       	call   8005df <cprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	68 74 1e 80 00       	push   $0x801e74
  8002f2:	e8 e8 02 00 00       	call   8005df <cprintf>
  8002f7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002fa:	e8 5d 12 00 00       	call   80155c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002ff:	e8 19 00 00 00       	call   80031d <exit>
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80030d:	83 ec 0c             	sub    $0xc,%esp
  800310:	6a 00                	push   $0x0
  800312:	e8 ea 13 00 00       	call   801701 <sys_destroy_env>
  800317:	83 c4 10             	add    $0x10,%esp
}
  80031a:	90                   	nop
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <exit>:

void
exit(void)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800323:	e8 3f 14 00 00       	call   801767 <sys_exit_env>
}
  800328:	90                   	nop
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800331:	8d 45 10             	lea    0x10(%ebp),%eax
  800334:	83 c0 04             	add    $0x4,%eax
  800337:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80033a:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  80033f:	85 c0                	test   %eax,%eax
  800341:	74 16                	je     800359 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800343:	a1 5c f1 80 00       	mov    0x80f15c,%eax
  800348:	83 ec 08             	sub    $0x8,%esp
  80034b:	50                   	push   %eax
  80034c:	68 30 1f 80 00       	push   $0x801f30
  800351:	e8 89 02 00 00       	call   8005df <cprintf>
  800356:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800359:	a1 08 30 80 00       	mov    0x803008,%eax
  80035e:	ff 75 0c             	pushl  0xc(%ebp)
  800361:	ff 75 08             	pushl  0x8(%ebp)
  800364:	50                   	push   %eax
  800365:	68 35 1f 80 00       	push   $0x801f35
  80036a:	e8 70 02 00 00       	call   8005df <cprintf>
  80036f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800372:	8b 45 10             	mov    0x10(%ebp),%eax
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	ff 75 f4             	pushl  -0xc(%ebp)
  80037b:	50                   	push   %eax
  80037c:	e8 f3 01 00 00       	call   800574 <vcprintf>
  800381:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800384:	83 ec 08             	sub    $0x8,%esp
  800387:	6a 00                	push   $0x0
  800389:	68 51 1f 80 00       	push   $0x801f51
  80038e:	e8 e1 01 00 00       	call   800574 <vcprintf>
  800393:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800396:	e8 82 ff ff ff       	call   80031d <exit>

	// should not return here
	while (1) ;
  80039b:	eb fe                	jmp    80039b <_panic+0x70>

0080039d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a3:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a8:	8b 50 74             	mov    0x74(%eax),%edx
  8003ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ae:	39 c2                	cmp    %eax,%edx
  8003b0:	74 14                	je     8003c6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	68 54 1f 80 00       	push   $0x801f54
  8003ba:	6a 26                	push   $0x26
  8003bc:	68 a0 1f 80 00       	push   $0x801fa0
  8003c1:	e8 65 ff ff ff       	call   80032b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d4:	e9 c2 00 00 00       	jmp    80049b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	85 c0                	test   %eax,%eax
  8003ec:	75 08                	jne    8003f6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003f1:	e9 a2 00 00 00       	jmp    800498 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800404:	eb 69                	jmp    80046f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800406:	a1 20 30 80 00       	mov    0x803020,%eax
  80040b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800411:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800414:	89 d0                	mov    %edx,%eax
  800416:	01 c0                	add    %eax,%eax
  800418:	01 d0                	add    %edx,%eax
  80041a:	c1 e0 03             	shl    $0x3,%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8a 40 04             	mov    0x4(%eax),%al
  800422:	84 c0                	test   %al,%al
  800424:	75 46                	jne    80046c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800426:	a1 20 30 80 00       	mov    0x803020,%eax
  80042b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800431:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800434:	89 d0                	mov    %edx,%eax
  800436:	01 c0                	add    %eax,%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	c1 e0 03             	shl    $0x3,%eax
  80043d:	01 c8                	add    %ecx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800444:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800447:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80044c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800458:	8b 45 08             	mov    0x8(%ebp),%eax
  80045b:	01 c8                	add    %ecx,%eax
  80045d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045f:	39 c2                	cmp    %eax,%edx
  800461:	75 09                	jne    80046c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800463:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80046a:	eb 12                	jmp    80047e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e8             	incl   -0x18(%ebp)
  80046f:	a1 20 30 80 00       	mov    0x803020,%eax
  800474:	8b 50 74             	mov    0x74(%eax),%edx
  800477:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 88                	ja     800406 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80047e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800482:	75 14                	jne    800498 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800484:	83 ec 04             	sub    $0x4,%esp
  800487:	68 ac 1f 80 00       	push   $0x801fac
  80048c:	6a 3a                	push   $0x3a
  80048e:	68 a0 1f 80 00       	push   $0x801fa0
  800493:	e8 93 fe ff ff       	call   80032b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800498:	ff 45 f0             	incl   -0x10(%ebp)
  80049b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a1:	0f 8c 32 ff ff ff    	jl     8003d9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b5:	eb 26                	jmp    8004dd <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b7:	a1 20 30 80 00       	mov    0x803020,%eax
  8004bc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	01 c0                	add    %eax,%eax
  8004c9:	01 d0                	add    %edx,%eax
  8004cb:	c1 e0 03             	shl    $0x3,%eax
  8004ce:	01 c8                	add    %ecx,%eax
  8004d0:	8a 40 04             	mov    0x4(%eax),%al
  8004d3:	3c 01                	cmp    $0x1,%al
  8004d5:	75 03                	jne    8004da <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004d7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004da:	ff 45 e0             	incl   -0x20(%ebp)
  8004dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e2:	8b 50 74             	mov    0x74(%eax),%edx
  8004e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e8:	39 c2                	cmp    %eax,%edx
  8004ea:	77 cb                	ja     8004b7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ef:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004f2:	74 14                	je     800508 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004f4:	83 ec 04             	sub    $0x4,%esp
  8004f7:	68 00 20 80 00       	push   $0x802000
  8004fc:	6a 44                	push   $0x44
  8004fe:	68 a0 1f 80 00       	push   $0x801fa0
  800503:	e8 23 fe ff ff       	call   80032b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800508:	90                   	nop
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	8b 00                	mov    (%eax),%eax
  800516:	8d 48 01             	lea    0x1(%eax),%ecx
  800519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051c:	89 0a                	mov    %ecx,(%edx)
  80051e:	8b 55 08             	mov    0x8(%ebp),%edx
  800521:	88 d1                	mov    %dl,%cl
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052d:	8b 00                	mov    (%eax),%eax
  80052f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800534:	75 2c                	jne    800562 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800536:	a0 24 30 80 00       	mov    0x803024,%al
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800541:	8b 12                	mov    (%edx),%edx
  800543:	89 d1                	mov    %edx,%ecx
  800545:	8b 55 0c             	mov    0xc(%ebp),%edx
  800548:	83 c2 08             	add    $0x8,%edx
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	50                   	push   %eax
  80054f:	51                   	push   %ecx
  800550:	52                   	push   %edx
  800551:	e8 3e 0e 00 00       	call   801394 <sys_cputs>
  800556:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800559:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800562:	8b 45 0c             	mov    0xc(%ebp),%eax
  800565:	8b 40 04             	mov    0x4(%eax),%eax
  800568:	8d 50 01             	lea    0x1(%eax),%edx
  80056b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056e:	89 50 04             	mov    %edx,0x4(%eax)
}
  800571:	90                   	nop
  800572:	c9                   	leave  
  800573:	c3                   	ret    

00800574 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800574:	55                   	push   %ebp
  800575:	89 e5                	mov    %esp,%ebp
  800577:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80057d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800584:	00 00 00 
	b.cnt = 0;
  800587:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800591:	ff 75 0c             	pushl  0xc(%ebp)
  800594:	ff 75 08             	pushl  0x8(%ebp)
  800597:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059d:	50                   	push   %eax
  80059e:	68 0b 05 80 00       	push   $0x80050b
  8005a3:	e8 11 02 00 00       	call   8007b9 <vprintfmt>
  8005a8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ab:	a0 24 30 80 00       	mov    0x803024,%al
  8005b0:	0f b6 c0             	movzbl %al,%eax
  8005b3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b9:	83 ec 04             	sub    $0x4,%esp
  8005bc:	50                   	push   %eax
  8005bd:	52                   	push   %edx
  8005be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c4:	83 c0 08             	add    $0x8,%eax
  8005c7:	50                   	push   %eax
  8005c8:	e8 c7 0d 00 00       	call   801394 <sys_cputs>
  8005cd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005d0:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <cprintf>:

int cprintf(const char *fmt, ...) {
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e5:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005ec:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f5:	83 ec 08             	sub    $0x8,%esp
  8005f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fb:	50                   	push   %eax
  8005fc:	e8 73 ff ff ff       	call   800574 <vcprintf>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800607:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80060a:	c9                   	leave  
  80060b:	c3                   	ret    

0080060c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800612:	e8 2b 0f 00 00       	call   801542 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800617:	8d 45 0c             	lea    0xc(%ebp),%eax
  80061a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80061d:	8b 45 08             	mov    0x8(%ebp),%eax
  800620:	83 ec 08             	sub    $0x8,%esp
  800623:	ff 75 f4             	pushl  -0xc(%ebp)
  800626:	50                   	push   %eax
  800627:	e8 48 ff ff ff       	call   800574 <vcprintf>
  80062c:	83 c4 10             	add    $0x10,%esp
  80062f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800632:	e8 25 0f 00 00       	call   80155c <sys_enable_interrupt>
	return cnt;
  800637:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80063a:	c9                   	leave  
  80063b:	c3                   	ret    

0080063c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80063c:	55                   	push   %ebp
  80063d:	89 e5                	mov    %esp,%ebp
  80063f:	53                   	push   %ebx
  800640:	83 ec 14             	sub    $0x14,%esp
  800643:	8b 45 10             	mov    0x10(%ebp),%eax
  800646:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064f:	8b 45 18             	mov    0x18(%ebp),%eax
  800652:	ba 00 00 00 00       	mov    $0x0,%edx
  800657:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065a:	77 55                	ja     8006b1 <printnum+0x75>
  80065c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065f:	72 05                	jb     800666 <printnum+0x2a>
  800661:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800664:	77 4b                	ja     8006b1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800666:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800669:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80066c:	8b 45 18             	mov    0x18(%ebp),%eax
  80066f:	ba 00 00 00 00       	mov    $0x0,%edx
  800674:	52                   	push   %edx
  800675:	50                   	push   %eax
  800676:	ff 75 f4             	pushl  -0xc(%ebp)
  800679:	ff 75 f0             	pushl  -0x10(%ebp)
  80067c:	e8 47 13 00 00       	call   8019c8 <__udivdi3>
  800681:	83 c4 10             	add    $0x10,%esp
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	ff 75 20             	pushl  0x20(%ebp)
  80068a:	53                   	push   %ebx
  80068b:	ff 75 18             	pushl  0x18(%ebp)
  80068e:	52                   	push   %edx
  80068f:	50                   	push   %eax
  800690:	ff 75 0c             	pushl  0xc(%ebp)
  800693:	ff 75 08             	pushl  0x8(%ebp)
  800696:	e8 a1 ff ff ff       	call   80063c <printnum>
  80069b:	83 c4 20             	add    $0x20,%esp
  80069e:	eb 1a                	jmp    8006ba <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006a0:	83 ec 08             	sub    $0x8,%esp
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	ff 75 20             	pushl  0x20(%ebp)
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	ff d0                	call   *%eax
  8006ae:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006b1:	ff 4d 1c             	decl   0x1c(%ebp)
  8006b4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b8:	7f e6                	jg     8006a0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006ba:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c8:	53                   	push   %ebx
  8006c9:	51                   	push   %ecx
  8006ca:	52                   	push   %edx
  8006cb:	50                   	push   %eax
  8006cc:	e8 07 14 00 00       	call   801ad8 <__umoddi3>
  8006d1:	83 c4 10             	add    $0x10,%esp
  8006d4:	05 74 22 80 00       	add    $0x802274,%eax
  8006d9:	8a 00                	mov    (%eax),%al
  8006db:	0f be c0             	movsbl %al,%eax
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	ff 75 0c             	pushl  0xc(%ebp)
  8006e4:	50                   	push   %eax
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	ff d0                	call   *%eax
  8006ea:	83 c4 10             	add    $0x10,%esp
}
  8006ed:	90                   	nop
  8006ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f1:	c9                   	leave  
  8006f2:	c3                   	ret    

008006f3 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006fa:	7e 1c                	jle    800718 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	8d 50 08             	lea    0x8(%eax),%edx
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	89 10                	mov    %edx,(%eax)
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	83 e8 08             	sub    $0x8,%eax
  800711:	8b 50 04             	mov    0x4(%eax),%edx
  800714:	8b 00                	mov    (%eax),%eax
  800716:	eb 40                	jmp    800758 <getuint+0x65>
	else if (lflag)
  800718:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80071c:	74 1e                	je     80073c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	8d 50 04             	lea    0x4(%eax),%edx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	89 10                	mov    %edx,(%eax)
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	83 e8 04             	sub    $0x4,%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	ba 00 00 00 00       	mov    $0x0,%edx
  80073a:	eb 1c                	jmp    800758 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80073c:	8b 45 08             	mov    0x8(%ebp),%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	8d 50 04             	lea    0x4(%eax),%edx
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	89 10                	mov    %edx,(%eax)
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800758:	5d                   	pop    %ebp
  800759:	c3                   	ret    

0080075a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800761:	7e 1c                	jle    80077f <getint+0x25>
		return va_arg(*ap, long long);
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	8b 00                	mov    (%eax),%eax
  800768:	8d 50 08             	lea    0x8(%eax),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	89 10                	mov    %edx,(%eax)
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	83 e8 08             	sub    $0x8,%eax
  800778:	8b 50 04             	mov    0x4(%eax),%edx
  80077b:	8b 00                	mov    (%eax),%eax
  80077d:	eb 38                	jmp    8007b7 <getint+0x5d>
	else if (lflag)
  80077f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800783:	74 1a                	je     80079f <getint+0x45>
		return va_arg(*ap, long);
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	8d 50 04             	lea    0x4(%eax),%edx
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	89 10                	mov    %edx,(%eax)
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	83 e8 04             	sub    $0x4,%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	99                   	cltd   
  80079d:	eb 18                	jmp    8007b7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	8d 50 04             	lea    0x4(%eax),%edx
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	89 10                	mov    %edx,(%eax)
  8007ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	83 e8 04             	sub    $0x4,%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	99                   	cltd   
}
  8007b7:	5d                   	pop    %ebp
  8007b8:	c3                   	ret    

008007b9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	56                   	push   %esi
  8007bd:	53                   	push   %ebx
  8007be:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c1:	eb 17                	jmp    8007da <vprintfmt+0x21>
			if (ch == '\0')
  8007c3:	85 db                	test   %ebx,%ebx
  8007c5:	0f 84 af 03 00 00    	je     800b7a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	53                   	push   %ebx
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	ff d0                	call   *%eax
  8007d7:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007da:	8b 45 10             	mov    0x10(%ebp),%eax
  8007dd:	8d 50 01             	lea    0x1(%eax),%edx
  8007e0:	89 55 10             	mov    %edx,0x10(%ebp)
  8007e3:	8a 00                	mov    (%eax),%al
  8007e5:	0f b6 d8             	movzbl %al,%ebx
  8007e8:	83 fb 25             	cmp    $0x25,%ebx
  8007eb:	75 d6                	jne    8007c3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ed:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007f1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800806:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080d:	8b 45 10             	mov    0x10(%ebp),%eax
  800810:	8d 50 01             	lea    0x1(%eax),%edx
  800813:	89 55 10             	mov    %edx,0x10(%ebp)
  800816:	8a 00                	mov    (%eax),%al
  800818:	0f b6 d8             	movzbl %al,%ebx
  80081b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80081e:	83 f8 55             	cmp    $0x55,%eax
  800821:	0f 87 2b 03 00 00    	ja     800b52 <vprintfmt+0x399>
  800827:	8b 04 85 98 22 80 00 	mov    0x802298(,%eax,4),%eax
  80082e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800830:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800834:	eb d7                	jmp    80080d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800836:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80083a:	eb d1                	jmp    80080d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80083c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800843:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800846:	89 d0                	mov    %edx,%eax
  800848:	c1 e0 02             	shl    $0x2,%eax
  80084b:	01 d0                	add    %edx,%eax
  80084d:	01 c0                	add    %eax,%eax
  80084f:	01 d8                	add    %ebx,%eax
  800851:	83 e8 30             	sub    $0x30,%eax
  800854:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800857:	8b 45 10             	mov    0x10(%ebp),%eax
  80085a:	8a 00                	mov    (%eax),%al
  80085c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085f:	83 fb 2f             	cmp    $0x2f,%ebx
  800862:	7e 3e                	jle    8008a2 <vprintfmt+0xe9>
  800864:	83 fb 39             	cmp    $0x39,%ebx
  800867:	7f 39                	jg     8008a2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800869:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80086c:	eb d5                	jmp    800843 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80086e:	8b 45 14             	mov    0x14(%ebp),%eax
  800871:	83 c0 04             	add    $0x4,%eax
  800874:	89 45 14             	mov    %eax,0x14(%ebp)
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800882:	eb 1f                	jmp    8008a3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800884:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800888:	79 83                	jns    80080d <vprintfmt+0x54>
				width = 0;
  80088a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800891:	e9 77 ff ff ff       	jmp    80080d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800896:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80089d:	e9 6b ff ff ff       	jmp    80080d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008a2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008a3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a7:	0f 89 60 ff ff ff    	jns    80080d <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008b3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008ba:	e9 4e ff ff ff       	jmp    80080d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008bf:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008c2:	e9 46 ff ff ff       	jmp    80080d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	83 c0 04             	add    $0x4,%eax
  8008cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 e8 04             	sub    $0x4,%eax
  8008d6:	8b 00                	mov    (%eax),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
			break;
  8008e7:	e9 89 02 00 00       	jmp    800b75 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ef:	83 c0 04             	add    $0x4,%eax
  8008f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f8:	83 e8 04             	sub    $0x4,%eax
  8008fb:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008fd:	85 db                	test   %ebx,%ebx
  8008ff:	79 02                	jns    800903 <vprintfmt+0x14a>
				err = -err;
  800901:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800903:	83 fb 64             	cmp    $0x64,%ebx
  800906:	7f 0b                	jg     800913 <vprintfmt+0x15a>
  800908:	8b 34 9d e0 20 80 00 	mov    0x8020e0(,%ebx,4),%esi
  80090f:	85 f6                	test   %esi,%esi
  800911:	75 19                	jne    80092c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800913:	53                   	push   %ebx
  800914:	68 85 22 80 00       	push   $0x802285
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	e8 5e 02 00 00       	call   800b82 <printfmt>
  800924:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800927:	e9 49 02 00 00       	jmp    800b75 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80092c:	56                   	push   %esi
  80092d:	68 8e 22 80 00       	push   $0x80228e
  800932:	ff 75 0c             	pushl  0xc(%ebp)
  800935:	ff 75 08             	pushl  0x8(%ebp)
  800938:	e8 45 02 00 00       	call   800b82 <printfmt>
  80093d:	83 c4 10             	add    $0x10,%esp
			break;
  800940:	e9 30 02 00 00       	jmp    800b75 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800945:	8b 45 14             	mov    0x14(%ebp),%eax
  800948:	83 c0 04             	add    $0x4,%eax
  80094b:	89 45 14             	mov    %eax,0x14(%ebp)
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	83 e8 04             	sub    $0x4,%eax
  800954:	8b 30                	mov    (%eax),%esi
  800956:	85 f6                	test   %esi,%esi
  800958:	75 05                	jne    80095f <vprintfmt+0x1a6>
				p = "(null)";
  80095a:	be 91 22 80 00       	mov    $0x802291,%esi
			if (width > 0 && padc != '-')
  80095f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800963:	7e 6d                	jle    8009d2 <vprintfmt+0x219>
  800965:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800969:	74 67                	je     8009d2 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80096b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	50                   	push   %eax
  800972:	56                   	push   %esi
  800973:	e8 0c 03 00 00       	call   800c84 <strnlen>
  800978:	83 c4 10             	add    $0x10,%esp
  80097b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80097e:	eb 16                	jmp    800996 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800980:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	50                   	push   %eax
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7f e4                	jg     800980 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80099c:	eb 34                	jmp    8009d2 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80099e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009a2:	74 1c                	je     8009c0 <vprintfmt+0x207>
  8009a4:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a7:	7e 05                	jle    8009ae <vprintfmt+0x1f5>
  8009a9:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ac:	7e 12                	jle    8009c0 <vprintfmt+0x207>
					putch('?', putdat);
  8009ae:	83 ec 08             	sub    $0x8,%esp
  8009b1:	ff 75 0c             	pushl  0xc(%ebp)
  8009b4:	6a 3f                	push   $0x3f
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	ff d0                	call   *%eax
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	eb 0f                	jmp    8009cf <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009c0:	83 ec 08             	sub    $0x8,%esp
  8009c3:	ff 75 0c             	pushl  0xc(%ebp)
  8009c6:	53                   	push   %ebx
  8009c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ca:	ff d0                	call   *%eax
  8009cc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009cf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d2:	89 f0                	mov    %esi,%eax
  8009d4:	8d 70 01             	lea    0x1(%eax),%esi
  8009d7:	8a 00                	mov    (%eax),%al
  8009d9:	0f be d8             	movsbl %al,%ebx
  8009dc:	85 db                	test   %ebx,%ebx
  8009de:	74 24                	je     800a04 <vprintfmt+0x24b>
  8009e0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e4:	78 b8                	js     80099e <vprintfmt+0x1e5>
  8009e6:	ff 4d e0             	decl   -0x20(%ebp)
  8009e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ed:	79 af                	jns    80099e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ef:	eb 13                	jmp    800a04 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 20                	push   $0x20
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a01:	ff 4d e4             	decl   -0x1c(%ebp)
  800a04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a08:	7f e7                	jg     8009f1 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a0a:	e9 66 01 00 00       	jmp    800b75 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 e8             	pushl  -0x18(%ebp)
  800a15:	8d 45 14             	lea    0x14(%ebp),%eax
  800a18:	50                   	push   %eax
  800a19:	e8 3c fd ff ff       	call   80075a <getint>
  800a1e:	83 c4 10             	add    $0x10,%esp
  800a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a24:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2d:	85 d2                	test   %edx,%edx
  800a2f:	79 23                	jns    800a54 <vprintfmt+0x29b>
				putch('-', putdat);
  800a31:	83 ec 08             	sub    $0x8,%esp
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	6a 2d                	push   $0x2d
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a47:	f7 d8                	neg    %eax
  800a49:	83 d2 00             	adc    $0x0,%edx
  800a4c:	f7 da                	neg    %edx
  800a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a54:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a5b:	e9 bc 00 00 00       	jmp    800b1c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	ff 75 e8             	pushl  -0x18(%ebp)
  800a66:	8d 45 14             	lea    0x14(%ebp),%eax
  800a69:	50                   	push   %eax
  800a6a:	e8 84 fc ff ff       	call   8006f3 <getuint>
  800a6f:	83 c4 10             	add    $0x10,%esp
  800a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a75:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a78:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7f:	e9 98 00 00 00       	jmp    800b1c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	6a 58                	push   $0x58
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	6a 58                	push   $0x58
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aa4:	83 ec 08             	sub    $0x8,%esp
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	6a 58                	push   $0x58
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	ff d0                	call   *%eax
  800ab1:	83 c4 10             	add    $0x10,%esp
			break;
  800ab4:	e9 bc 00 00 00       	jmp    800b75 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab9:	83 ec 08             	sub    $0x8,%esp
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	6a 30                	push   $0x30
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	ff d0                	call   *%eax
  800ac6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	6a 78                	push   $0x78
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad9:	8b 45 14             	mov    0x14(%ebp),%eax
  800adc:	83 c0 04             	add    $0x4,%eax
  800adf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae5:	83 e8 04             	sub    $0x4,%eax
  800ae8:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800af4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800afb:	eb 1f                	jmp    800b1c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800afd:	83 ec 08             	sub    $0x8,%esp
  800b00:	ff 75 e8             	pushl  -0x18(%ebp)
  800b03:	8d 45 14             	lea    0x14(%ebp),%eax
  800b06:	50                   	push   %eax
  800b07:	e8 e7 fb ff ff       	call   8006f3 <getuint>
  800b0c:	83 c4 10             	add    $0x10,%esp
  800b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b12:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b1c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b23:	83 ec 04             	sub    $0x4,%esp
  800b26:	52                   	push   %edx
  800b27:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b2a:	50                   	push   %eax
  800b2b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2e:	ff 75 f0             	pushl  -0x10(%ebp)
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	ff 75 08             	pushl  0x8(%ebp)
  800b37:	e8 00 fb ff ff       	call   80063c <printnum>
  800b3c:	83 c4 20             	add    $0x20,%esp
			break;
  800b3f:	eb 34                	jmp    800b75 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	53                   	push   %ebx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
			break;
  800b50:	eb 23                	jmp    800b75 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	6a 25                	push   $0x25
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b62:	ff 4d 10             	decl   0x10(%ebp)
  800b65:	eb 03                	jmp    800b6a <vprintfmt+0x3b1>
  800b67:	ff 4d 10             	decl   0x10(%ebp)
  800b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6d:	48                   	dec    %eax
  800b6e:	8a 00                	mov    (%eax),%al
  800b70:	3c 25                	cmp    $0x25,%al
  800b72:	75 f3                	jne    800b67 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b74:	90                   	nop
		}
	}
  800b75:	e9 47 fc ff ff       	jmp    8007c1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b7a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b7e:	5b                   	pop    %ebx
  800b7f:	5e                   	pop    %esi
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b88:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8b:	83 c0 04             	add    $0x4,%eax
  800b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b91:	8b 45 10             	mov    0x10(%ebp),%eax
  800b94:	ff 75 f4             	pushl  -0xc(%ebp)
  800b97:	50                   	push   %eax
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	ff 75 08             	pushl  0x8(%ebp)
  800b9e:	e8 16 fc ff ff       	call   8007b9 <vprintfmt>
  800ba3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba6:	90                   	nop
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baf:	8b 40 08             	mov    0x8(%eax),%eax
  800bb2:	8d 50 01             	lea    0x1(%eax),%edx
  800bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8b 10                	mov    (%eax),%edx
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	8b 40 04             	mov    0x4(%eax),%eax
  800bc6:	39 c2                	cmp    %eax,%edx
  800bc8:	73 12                	jae    800bdc <sprintputch+0x33>
		*b->buf++ = ch;
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8b 00                	mov    (%eax),%eax
  800bcf:	8d 48 01             	lea    0x1(%eax),%ecx
  800bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd5:	89 0a                	mov    %ecx,(%edx)
  800bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800bda:	88 10                	mov    %dl,(%eax)
}
  800bdc:	90                   	nop
  800bdd:	5d                   	pop    %ebp
  800bde:	c3                   	ret    

00800bdf <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	01 d0                	add    %edx,%eax
  800bf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c04:	74 06                	je     800c0c <vsnprintf+0x2d>
  800c06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c0a:	7f 07                	jg     800c13 <vsnprintf+0x34>
		return -E_INVAL;
  800c0c:	b8 03 00 00 00       	mov    $0x3,%eax
  800c11:	eb 20                	jmp    800c33 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c13:	ff 75 14             	pushl  0x14(%ebp)
  800c16:	ff 75 10             	pushl  0x10(%ebp)
  800c19:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c1c:	50                   	push   %eax
  800c1d:	68 a9 0b 80 00       	push   $0x800ba9
  800c22:	e8 92 fb ff ff       	call   8007b9 <vprintfmt>
  800c27:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c2d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c3b:	8d 45 10             	lea    0x10(%ebp),%eax
  800c3e:	83 c0 04             	add    $0x4,%eax
  800c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c44:	8b 45 10             	mov    0x10(%ebp),%eax
  800c47:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4a:	50                   	push   %eax
  800c4b:	ff 75 0c             	pushl  0xc(%ebp)
  800c4e:	ff 75 08             	pushl  0x8(%ebp)
  800c51:	e8 89 ff ff ff       	call   800bdf <vsnprintf>
  800c56:	83 c4 10             	add    $0x10,%esp
  800c59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6e:	eb 06                	jmp    800c76 <strlen+0x15>
		n++;
  800c70:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c73:	ff 45 08             	incl   0x8(%ebp)
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 f1                	jne    800c70 <strlen+0xf>
		n++;
	return n;
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c91:	eb 09                	jmp    800c9c <strnlen+0x18>
		n++;
  800c93:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c96:	ff 45 08             	incl   0x8(%ebp)
  800c99:	ff 4d 0c             	decl   0xc(%ebp)
  800c9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca0:	74 09                	je     800cab <strnlen+0x27>
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8a 00                	mov    (%eax),%al
  800ca7:	84 c0                	test   %al,%al
  800ca9:	75 e8                	jne    800c93 <strnlen+0xf>
		n++;
	return n;
  800cab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cbc:	90                   	nop
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	8d 50 01             	lea    0x1(%eax),%edx
  800cc3:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccf:	8a 12                	mov    (%edx),%dl
  800cd1:	88 10                	mov    %dl,(%eax)
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	84 c0                	test   %al,%al
  800cd7:	75 e4                	jne    800cbd <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cdc:	c9                   	leave  
  800cdd:	c3                   	ret    

00800cde <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf1:	eb 1f                	jmp    800d12 <strncpy+0x34>
		*dst++ = *src;
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8d 50 01             	lea    0x1(%eax),%edx
  800cf9:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cff:	8a 12                	mov    (%edx),%dl
  800d01:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 03                	je     800d0f <strncpy+0x31>
			src++;
  800d0c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0f:	ff 45 fc             	incl   -0x4(%ebp)
  800d12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d15:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d18:	72 d9                	jb     800cf3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

00800d1f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2f:	74 30                	je     800d61 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d31:	eb 16                	jmp    800d49 <strlcpy+0x2a>
			*dst++ = *src++;
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	8d 50 01             	lea    0x1(%eax),%edx
  800d39:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d42:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d45:	8a 12                	mov    (%edx),%dl
  800d47:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d49:	ff 4d 10             	decl   0x10(%ebp)
  800d4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d50:	74 09                	je     800d5b <strlcpy+0x3c>
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	84 c0                	test   %al,%al
  800d59:	75 d8                	jne    800d33 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d61:	8b 55 08             	mov    0x8(%ebp),%edx
  800d64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d67:	29 c2                	sub    %eax,%edx
  800d69:	89 d0                	mov    %edx,%eax
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d70:	eb 06                	jmp    800d78 <strcmp+0xb>
		p++, q++;
  800d72:	ff 45 08             	incl   0x8(%ebp)
  800d75:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	74 0e                	je     800d8f <strcmp+0x22>
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	8a 10                	mov    (%eax),%dl
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	38 c2                	cmp    %al,%dl
  800d8d:	74 e3                	je     800d72 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d92:	8a 00                	mov    (%eax),%al
  800d94:	0f b6 d0             	movzbl %al,%edx
  800d97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	0f b6 c0             	movzbl %al,%eax
  800d9f:	29 c2                	sub    %eax,%edx
  800da1:	89 d0                	mov    %edx,%eax
}
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da8:	eb 09                	jmp    800db3 <strncmp+0xe>
		n--, p++, q++;
  800daa:	ff 4d 10             	decl   0x10(%ebp)
  800dad:	ff 45 08             	incl   0x8(%ebp)
  800db0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800db3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db7:	74 17                	je     800dd0 <strncmp+0x2b>
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	74 0e                	je     800dd0 <strncmp+0x2b>
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	8a 10                	mov    (%eax),%dl
  800dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	38 c2                	cmp    %al,%dl
  800dce:	74 da                	je     800daa <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd4:	75 07                	jne    800ddd <strncmp+0x38>
		return 0;
  800dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ddb:	eb 14                	jmp    800df1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	0f b6 d0             	movzbl %al,%edx
  800de5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de8:	8a 00                	mov    (%eax),%al
  800dea:	0f b6 c0             	movzbl %al,%eax
  800ded:	29 c2                	sub    %eax,%edx
  800def:	89 d0                	mov    %edx,%eax
}
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 04             	sub    $0x4,%esp
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dff:	eb 12                	jmp    800e13 <strchr+0x20>
		if (*s == c)
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e09:	75 05                	jne    800e10 <strchr+0x1d>
			return (char *) s;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	eb 11                	jmp    800e21 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e10:	ff 45 08             	incl   0x8(%ebp)
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	8a 00                	mov    (%eax),%al
  800e18:	84 c0                	test   %al,%al
  800e1a:	75 e5                	jne    800e01 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 04             	sub    $0x4,%esp
  800e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2f:	eb 0d                	jmp    800e3e <strfind+0x1b>
		if (*s == c)
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e39:	74 0e                	je     800e49 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 ea                	jne    800e31 <strfind+0xe>
  800e47:	eb 01                	jmp    800e4a <strfind+0x27>
		if (*s == c)
			break;
  800e49:	90                   	nop
	return (char *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4d:	c9                   	leave  
  800e4e:	c3                   	ret    

00800e4f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e61:	eb 0e                	jmp    800e71 <memset+0x22>
		*p++ = c;
  800e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e71:	ff 4d f8             	decl   -0x8(%ebp)
  800e74:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e78:	79 e9                	jns    800e63 <memset+0x14>
		*p++ = c;

	return v;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e91:	eb 16                	jmp    800ea9 <memcpy+0x2a>
		*d++ = *s++;
  800e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e96:	8d 50 01             	lea    0x1(%eax),%edx
  800e99:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea5:	8a 12                	mov    (%edx),%dl
  800ea7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaf:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	75 dd                	jne    800e93 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb9:	c9                   	leave  
  800eba:	c3                   	ret    

00800ebb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ecd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed3:	73 50                	jae    800f25 <memmove+0x6a>
  800ed5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ee0:	76 43                	jbe    800f25 <memmove+0x6a>
		s += n;
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eee:	eb 10                	jmp    800f00 <memmove+0x45>
			*--d = *--s;
  800ef0:	ff 4d f8             	decl   -0x8(%ebp)
  800ef3:	ff 4d fc             	decl   -0x4(%ebp)
  800ef6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef9:	8a 10                	mov    (%eax),%dl
  800efb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efe:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 e3                	jne    800ef0 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f0d:	eb 23                	jmp    800f32 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f12:	8d 50 01             	lea    0x1(%eax),%edx
  800f15:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f21:	8a 12                	mov    (%edx),%dl
  800f23:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f2b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2e:	85 c0                	test   %eax,%eax
  800f30:	75 dd                	jne    800f0f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f49:	eb 2a                	jmp    800f75 <memcmp+0x3e>
		if (*s1 != *s2)
  800f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4e:	8a 10                	mov    (%eax),%dl
  800f50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	38 c2                	cmp    %al,%dl
  800f57:	74 16                	je     800f6f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
  800f6d:	eb 18                	jmp    800f87 <memcmp+0x50>
		s1++, s2++;
  800f6f:	ff 45 fc             	incl   -0x4(%ebp)
  800f72:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f75:	8b 45 10             	mov    0x10(%ebp),%eax
  800f78:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7e:	85 c0                	test   %eax,%eax
  800f80:	75 c9                	jne    800f4b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	01 d0                	add    %edx,%eax
  800f97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f9a:	eb 15                	jmp    800fb1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	0f b6 c0             	movzbl %al,%eax
  800faa:	39 c2                	cmp    %eax,%edx
  800fac:	74 0d                	je     800fbb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fae:	ff 45 08             	incl   0x8(%ebp)
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb7:	72 e3                	jb     800f9c <memfind+0x13>
  800fb9:	eb 01                	jmp    800fbc <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fbb:	90                   	nop
	return (void *) s;
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbf:	c9                   	leave  
  800fc0:	c3                   	ret    

00800fc1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	eb 03                	jmp    800fda <strtol+0x19>
		s++;
  800fd7:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 20                	cmp    $0x20,%al
  800fe1:	74 f4                	je     800fd7 <strtol+0x16>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 09                	cmp    $0x9,%al
  800fea:	74 eb                	je     800fd7 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2b                	cmp    $0x2b,%al
  800ff3:	75 05                	jne    800ffa <strtol+0x39>
		s++;
  800ff5:	ff 45 08             	incl   0x8(%ebp)
  800ff8:	eb 13                	jmp    80100d <strtol+0x4c>
	else if (*s == '-')
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 2d                	cmp    $0x2d,%al
  801001:	75 0a                	jne    80100d <strtol+0x4c>
		s++, neg = 1;
  801003:	ff 45 08             	incl   0x8(%ebp)
  801006:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80100d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801011:	74 06                	je     801019 <strtol+0x58>
  801013:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801017:	75 20                	jne    801039 <strtol+0x78>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 30                	cmp    $0x30,%al
  801020:	75 17                	jne    801039 <strtol+0x78>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	40                   	inc    %eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 78                	cmp    $0x78,%al
  80102a:	75 0d                	jne    801039 <strtol+0x78>
		s += 2, base = 16;
  80102c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801030:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801037:	eb 28                	jmp    801061 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801039:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103d:	75 15                	jne    801054 <strtol+0x93>
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 30                	cmp    $0x30,%al
  801046:	75 0c                	jne    801054 <strtol+0x93>
		s++, base = 8;
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801052:	eb 0d                	jmp    801061 <strtol+0xa0>
	else if (base == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strtol+0xa0>
		base = 10;
  80105a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	3c 2f                	cmp    $0x2f,%al
  801068:	7e 19                	jle    801083 <strtol+0xc2>
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	8a 00                	mov    (%eax),%al
  80106f:	3c 39                	cmp    $0x39,%al
  801071:	7f 10                	jg     801083 <strtol+0xc2>
			dig = *s - '0';
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8a 00                	mov    (%eax),%al
  801078:	0f be c0             	movsbl %al,%eax
  80107b:	83 e8 30             	sub    $0x30,%eax
  80107e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801081:	eb 42                	jmp    8010c5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	3c 60                	cmp    $0x60,%al
  80108a:	7e 19                	jle    8010a5 <strtol+0xe4>
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	8a 00                	mov    (%eax),%al
  801091:	3c 7a                	cmp    $0x7a,%al
  801093:	7f 10                	jg     8010a5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	0f be c0             	movsbl %al,%eax
  80109d:	83 e8 57             	sub    $0x57,%eax
  8010a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010a3:	eb 20                	jmp    8010c5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8a 00                	mov    (%eax),%al
  8010aa:	3c 40                	cmp    $0x40,%al
  8010ac:	7e 39                	jle    8010e7 <strtol+0x126>
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	3c 5a                	cmp    $0x5a,%al
  8010b5:	7f 30                	jg     8010e7 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f be c0             	movsbl %al,%eax
  8010bf:	83 e8 37             	sub    $0x37,%eax
  8010c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010cb:	7d 19                	jge    8010e6 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010cd:	ff 45 08             	incl   0x8(%ebp)
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d3:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d7:	89 c2                	mov    %eax,%edx
  8010d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010dc:	01 d0                	add    %edx,%eax
  8010de:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010e1:	e9 7b ff ff ff       	jmp    801061 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e6:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010eb:	74 08                	je     8010f5 <strtol+0x134>
		*endptr = (char *) s;
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f3:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f9:	74 07                	je     801102 <strtol+0x141>
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	f7 d8                	neg    %eax
  801100:	eb 03                	jmp    801105 <strtol+0x144>
  801102:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801105:	c9                   	leave  
  801106:	c3                   	ret    

00801107 <ltostr>:

void
ltostr(long value, char *str)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80110d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801114:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80111b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111f:	79 13                	jns    801134 <ltostr+0x2d>
	{
		neg = 1;
  801121:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80112e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801131:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80113c:	99                   	cltd   
  80113d:	f7 f9                	idiv   %ecx
  80113f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	8d 50 01             	lea    0x1(%eax),%edx
  801148:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80114b:	89 c2                	mov    %eax,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	01 d0                	add    %edx,%eax
  801152:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801155:	83 c2 30             	add    $0x30,%edx
  801158:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80115a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80115d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801162:	f7 e9                	imul   %ecx
  801164:	c1 fa 02             	sar    $0x2,%edx
  801167:	89 c8                	mov    %ecx,%eax
  801169:	c1 f8 1f             	sar    $0x1f,%eax
  80116c:	29 c2                	sub    %eax,%edx
  80116e:	89 d0                	mov    %edx,%eax
  801170:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801176:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80117b:	f7 e9                	imul   %ecx
  80117d:	c1 fa 02             	sar    $0x2,%edx
  801180:	89 c8                	mov    %ecx,%eax
  801182:	c1 f8 1f             	sar    $0x1f,%eax
  801185:	29 c2                	sub    %eax,%edx
  801187:	89 d0                	mov    %edx,%eax
  801189:	c1 e0 02             	shl    $0x2,%eax
  80118c:	01 d0                	add    %edx,%eax
  80118e:	01 c0                	add    %eax,%eax
  801190:	29 c1                	sub    %eax,%ecx
  801192:	89 ca                	mov    %ecx,%edx
  801194:	85 d2                	test   %edx,%edx
  801196:	75 9c                	jne    801134 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801198:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	48                   	dec    %eax
  8011a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011aa:	74 3d                	je     8011e9 <ltostr+0xe2>
		start = 1 ;
  8011ac:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011b3:	eb 34                	jmp    8011e9 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	01 d0                	add    %edx,%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	01 c2                	add    %eax,%edx
  8011ca:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	01 c8                	add    %ecx,%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dc:	01 c2                	add    %eax,%edx
  8011de:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011e1:	88 02                	mov    %al,(%edx)
		start++ ;
  8011e3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ef:	7c c4                	jl     8011b5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011fc:	90                   	nop
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801205:	ff 75 08             	pushl  0x8(%ebp)
  801208:	e8 54 fa ff ff       	call   800c61 <strlen>
  80120d:	83 c4 04             	add    $0x4,%esp
  801210:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	e8 46 fa ff ff       	call   800c61 <strlen>
  80121b:	83 c4 04             	add    $0x4,%esp
  80121e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801221:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801228:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80122f:	eb 17                	jmp    801248 <strcconcat+0x49>
		final[s] = str1[s] ;
  801231:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	01 c2                	add    %eax,%edx
  801239:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	01 c8                	add    %ecx,%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801245:	ff 45 fc             	incl   -0x4(%ebp)
  801248:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80124e:	7c e1                	jl     801231 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801250:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801257:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80125e:	eb 1f                	jmp    80127f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801269:	89 c2                	mov    %eax,%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 c2                	add    %eax,%edx
  801270:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801273:	8b 45 0c             	mov    0xc(%ebp),%eax
  801276:	01 c8                	add    %ecx,%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80127c:	ff 45 f8             	incl   -0x8(%ebp)
  80127f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801282:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801285:	7c d9                	jl     801260 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801287:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128a:	8b 45 10             	mov    0x10(%ebp),%eax
  80128d:	01 d0                	add    %edx,%eax
  80128f:	c6 00 00             	movb   $0x0,(%eax)
}
  801292:	90                   	nop
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801298:	8b 45 14             	mov    0x14(%ebp),%eax
  80129b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	8b 00                	mov    (%eax),%eax
  8012a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	01 d0                	add    %edx,%eax
  8012b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b8:	eb 0c                	jmp    8012c6 <strsplit+0x31>
			*string++ = 0;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	8d 50 01             	lea    0x1(%eax),%edx
  8012c0:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	8a 00                	mov    (%eax),%al
  8012cb:	84 c0                	test   %al,%al
  8012cd:	74 18                	je     8012e7 <strsplit+0x52>
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	8a 00                	mov    (%eax),%al
  8012d4:	0f be c0             	movsbl %al,%eax
  8012d7:	50                   	push   %eax
  8012d8:	ff 75 0c             	pushl  0xc(%ebp)
  8012db:	e8 13 fb ff ff       	call   800df3 <strchr>
  8012e0:	83 c4 08             	add    $0x8,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	75 d3                	jne    8012ba <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	84 c0                	test   %al,%al
  8012ee:	74 5a                	je     80134a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f3:	8b 00                	mov    (%eax),%eax
  8012f5:	83 f8 0f             	cmp    $0xf,%eax
  8012f8:	75 07                	jne    801301 <strsplit+0x6c>
		{
			return 0;
  8012fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ff:	eb 66                	jmp    801367 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801301:	8b 45 14             	mov    0x14(%ebp),%eax
  801304:	8b 00                	mov    (%eax),%eax
  801306:	8d 48 01             	lea    0x1(%eax),%ecx
  801309:	8b 55 14             	mov    0x14(%ebp),%edx
  80130c:	89 0a                	mov    %ecx,(%edx)
  80130e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 c2                	add    %eax,%edx
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131f:	eb 03                	jmp    801324 <strsplit+0x8f>
			string++;
  801321:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	84 c0                	test   %al,%al
  80132b:	74 8b                	je     8012b8 <strsplit+0x23>
  80132d:	8b 45 08             	mov    0x8(%ebp),%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	0f be c0             	movsbl %al,%eax
  801335:	50                   	push   %eax
  801336:	ff 75 0c             	pushl  0xc(%ebp)
  801339:	e8 b5 fa ff ff       	call   800df3 <strchr>
  80133e:	83 c4 08             	add    $0x8,%esp
  801341:	85 c0                	test   %eax,%eax
  801343:	74 dc                	je     801321 <strsplit+0x8c>
			string++;
	}
  801345:	e9 6e ff ff ff       	jmp    8012b8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80134a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80134b:	8b 45 14             	mov    0x14(%ebp),%eax
  80134e:	8b 00                	mov    (%eax),%eax
  801350:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801357:	8b 45 10             	mov    0x10(%ebp),%eax
  80135a:	01 d0                	add    %edx,%eax
  80135c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801362:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801367:	c9                   	leave  
  801368:	c3                   	ret    

00801369 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801369:	55                   	push   %ebp
  80136a:	89 e5                	mov    %esp,%ebp
  80136c:	57                   	push   %edi
  80136d:	56                   	push   %esi
  80136e:	53                   	push   %ebx
  80136f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	8b 55 0c             	mov    0xc(%ebp),%edx
  801378:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80137b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80137e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801381:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801384:	cd 30                	int    $0x30
  801386:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801389:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5f                   	pop    %edi
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    

00801394 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8013a0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	52                   	push   %edx
  8013ac:	ff 75 0c             	pushl  0xc(%ebp)
  8013af:	50                   	push   %eax
  8013b0:	6a 00                	push   $0x0
  8013b2:	e8 b2 ff ff ff       	call   801369 <syscall>
  8013b7:	83 c4 18             	add    $0x18,%esp
}
  8013ba:	90                   	nop
  8013bb:	c9                   	leave  
  8013bc:	c3                   	ret    

008013bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013c0:	6a 00                	push   $0x0
  8013c2:	6a 00                	push   $0x0
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 01                	push   $0x1
  8013cc:	e8 98 ff ff ff       	call   801369 <syscall>
  8013d1:	83 c4 18             	add    $0x18,%esp
}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8013d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	52                   	push   %edx
  8013e6:	50                   	push   %eax
  8013e7:	6a 05                	push   $0x5
  8013e9:	e8 7b ff ff ff       	call   801369 <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	56                   	push   %esi
  8013f7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8013f8:	8b 75 18             	mov    0x18(%ebp),%esi
  8013fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801401:	8b 55 0c             	mov    0xc(%ebp),%edx
  801404:	8b 45 08             	mov    0x8(%ebp),%eax
  801407:	56                   	push   %esi
  801408:	53                   	push   %ebx
  801409:	51                   	push   %ecx
  80140a:	52                   	push   %edx
  80140b:	50                   	push   %eax
  80140c:	6a 06                	push   $0x6
  80140e:	e8 56 ff ff ff       	call   801369 <syscall>
  801413:	83 c4 18             	add    $0x18,%esp
}
  801416:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801419:	5b                   	pop    %ebx
  80141a:	5e                   	pop    %esi
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    

0080141d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801420:	8b 55 0c             	mov    0xc(%ebp),%edx
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 00                	push   $0x0
  80142c:	52                   	push   %edx
  80142d:	50                   	push   %eax
  80142e:	6a 07                	push   $0x7
  801430:	e8 34 ff ff ff       	call   801369 <syscall>
  801435:	83 c4 18             	add    $0x18,%esp
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	ff 75 0c             	pushl  0xc(%ebp)
  801446:	ff 75 08             	pushl  0x8(%ebp)
  801449:	6a 08                	push   $0x8
  80144b:	e8 19 ff ff ff       	call   801369 <syscall>
  801450:	83 c4 18             	add    $0x18,%esp
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801458:	6a 00                	push   $0x0
  80145a:	6a 00                	push   $0x0
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 09                	push   $0x9
  801464:	e8 00 ff ff ff       	call   801369 <syscall>
  801469:	83 c4 18             	add    $0x18,%esp
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 0a                	push   $0xa
  80147d:	e8 e7 fe ff ff       	call   801369 <syscall>
  801482:	83 c4 18             	add    $0x18,%esp
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80148a:	6a 00                	push   $0x0
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 0b                	push   $0xb
  801496:	e8 ce fe ff ff       	call   801369 <syscall>
  80149b:	83 c4 18             	add    $0x18,%esp
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	ff 75 0c             	pushl  0xc(%ebp)
  8014ac:	ff 75 08             	pushl  0x8(%ebp)
  8014af:	6a 0f                	push   $0xf
  8014b1:	e8 b3 fe ff ff       	call   801369 <syscall>
  8014b6:	83 c4 18             	add    $0x18,%esp
	return;
  8014b9:	90                   	nop
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	ff 75 0c             	pushl  0xc(%ebp)
  8014c8:	ff 75 08             	pushl  0x8(%ebp)
  8014cb:	6a 10                	push   $0x10
  8014cd:	e8 97 fe ff ff       	call   801369 <syscall>
  8014d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8014d5:	90                   	nop
}
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	ff 75 10             	pushl  0x10(%ebp)
  8014e2:	ff 75 0c             	pushl  0xc(%ebp)
  8014e5:	ff 75 08             	pushl  0x8(%ebp)
  8014e8:	6a 11                	push   $0x11
  8014ea:	e8 7a fe ff ff       	call   801369 <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8014f2:	90                   	nop
}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 0c                	push   $0xc
  801504:	e8 60 fe ff ff       	call   801369 <syscall>
  801509:	83 c4 18             	add    $0x18,%esp
}
  80150c:	c9                   	leave  
  80150d:	c3                   	ret    

0080150e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	ff 75 08             	pushl  0x8(%ebp)
  80151c:	6a 0d                	push   $0xd
  80151e:	e8 46 fe ff ff       	call   801369 <syscall>
  801523:	83 c4 18             	add    $0x18,%esp
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 0e                	push   $0xe
  801537:	e8 2d fe ff ff       	call   801369 <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
}
  80153f:	90                   	nop
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 13                	push   $0x13
  801551:	e8 13 fe ff ff       	call   801369 <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	90                   	nop
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 14                	push   $0x14
  80156b:	e8 f9 fd ff ff       	call   801369 <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
}
  801573:	90                   	nop
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <sys_cputc>:


void
sys_cputc(const char c)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	8b 45 08             	mov    0x8(%ebp),%eax
  80157f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801582:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	50                   	push   %eax
  80158f:	6a 15                	push   $0x15
  801591:	e8 d3 fd ff ff       	call   801369 <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	90                   	nop
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 16                	push   $0x16
  8015ab:	e8 b9 fd ff ff       	call   801369 <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
}
  8015b3:	90                   	nop
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	50                   	push   %eax
  8015c6:	6a 17                	push   $0x17
  8015c8:	e8 9c fd ff ff       	call   801369 <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	52                   	push   %edx
  8015e2:	50                   	push   %eax
  8015e3:	6a 1a                	push   $0x1a
  8015e5:	e8 7f fd ff ff       	call   801369 <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
}
  8015ed:	c9                   	leave  
  8015ee:	c3                   	ret    

008015ef <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8015f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	52                   	push   %edx
  8015ff:	50                   	push   %eax
  801600:	6a 18                	push   $0x18
  801602:	e8 62 fd ff ff       	call   801369 <syscall>
  801607:	83 c4 18             	add    $0x18,%esp
}
  80160a:	90                   	nop
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801610:	8b 55 0c             	mov    0xc(%ebp),%edx
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	52                   	push   %edx
  80161d:	50                   	push   %eax
  80161e:	6a 19                	push   $0x19
  801620:	e8 44 fd ff ff       	call   801369 <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	90                   	nop
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	8b 45 10             	mov    0x10(%ebp),%eax
  801634:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801637:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80163a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	51                   	push   %ecx
  801644:	52                   	push   %edx
  801645:	ff 75 0c             	pushl  0xc(%ebp)
  801648:	50                   	push   %eax
  801649:	6a 1b                	push   $0x1b
  80164b:	e8 19 fd ff ff       	call   801369 <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	52                   	push   %edx
  801665:	50                   	push   %eax
  801666:	6a 1c                	push   $0x1c
  801668:	e8 fc fc ff ff       	call   801369 <syscall>
  80166d:	83 c4 18             	add    $0x18,%esp
}
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801675:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	51                   	push   %ecx
  801683:	52                   	push   %edx
  801684:	50                   	push   %eax
  801685:	6a 1d                	push   $0x1d
  801687:	e8 dd fc ff ff       	call   801369 <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801694:	8b 55 0c             	mov    0xc(%ebp),%edx
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	52                   	push   %edx
  8016a1:	50                   	push   %eax
  8016a2:	6a 1e                	push   $0x1e
  8016a4:	e8 c0 fc ff ff       	call   801369 <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
}
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 1f                	push   $0x1f
  8016bd:	e8 a7 fc ff ff       	call   801369 <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	6a 00                	push   $0x0
  8016cf:	ff 75 14             	pushl  0x14(%ebp)
  8016d2:	ff 75 10             	pushl  0x10(%ebp)
  8016d5:	ff 75 0c             	pushl  0xc(%ebp)
  8016d8:	50                   	push   %eax
  8016d9:	6a 20                	push   $0x20
  8016db:	e8 89 fc ff ff       	call   801369 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	50                   	push   %eax
  8016f4:	6a 21                	push   $0x21
  8016f6:	e8 6e fc ff ff       	call   801369 <syscall>
  8016fb:	83 c4 18             	add    $0x18,%esp
}
  8016fe:	90                   	nop
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	50                   	push   %eax
  801710:	6a 22                	push   $0x22
  801712:	e8 52 fc ff ff       	call   801369 <syscall>
  801717:	83 c4 18             	add    $0x18,%esp
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 02                	push   $0x2
  80172b:	e8 39 fc ff ff       	call   801369 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 03                	push   $0x3
  801744:	e8 20 fc ff ff       	call   801369 <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 04                	push   $0x4
  80175d:	e8 07 fc ff ff       	call   801369 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_exit_env>:


void sys_exit_env(void)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 23                	push   $0x23
  801776:	e8 ee fb ff ff       	call   801369 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	90                   	nop
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801787:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80178a:	8d 50 04             	lea    0x4(%eax),%edx
  80178d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	52                   	push   %edx
  801797:	50                   	push   %eax
  801798:	6a 24                	push   $0x24
  80179a:	e8 ca fb ff ff       	call   801369 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
	return result;
  8017a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017ab:	89 01                	mov    %eax,(%ecx)
  8017ad:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	c9                   	leave  
  8017b4:	c2 04 00             	ret    $0x4

008017b7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	ff 75 10             	pushl  0x10(%ebp)
  8017c1:	ff 75 0c             	pushl  0xc(%ebp)
  8017c4:	ff 75 08             	pushl  0x8(%ebp)
  8017c7:	6a 12                	push   $0x12
  8017c9:	e8 9b fb ff ff       	call   801369 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d1:	90                   	nop
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 25                	push   $0x25
  8017e3:	e8 81 fb ff ff       	call   801369 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8017f9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	50                   	push   %eax
  801806:	6a 26                	push   $0x26
  801808:	e8 5c fb ff ff       	call   801369 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
	return ;
  801810:	90                   	nop
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <rsttst>:
void rsttst()
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 28                	push   $0x28
  801822:	e8 42 fb ff ff       	call   801369 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
	return ;
  80182a:	90                   	nop
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	8b 45 14             	mov    0x14(%ebp),%eax
  801836:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801839:	8b 55 18             	mov    0x18(%ebp),%edx
  80183c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	ff 75 10             	pushl  0x10(%ebp)
  801845:	ff 75 0c             	pushl  0xc(%ebp)
  801848:	ff 75 08             	pushl  0x8(%ebp)
  80184b:	6a 27                	push   $0x27
  80184d:	e8 17 fb ff ff       	call   801369 <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
	return ;
  801855:	90                   	nop
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <chktst>:
void chktst(uint32 n)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	ff 75 08             	pushl  0x8(%ebp)
  801866:	6a 29                	push   $0x29
  801868:	e8 fc fa ff ff       	call   801369 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
	return ;
  801870:	90                   	nop
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <inctst>:

void inctst()
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 2a                	push   $0x2a
  801882:	e8 e2 fa ff ff       	call   801369 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
	return ;
  80188a:	90                   	nop
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <gettst>:
uint32 gettst()
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 2b                	push   $0x2b
  80189c:	e8 c8 fa ff ff       	call   801369 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 2c                	push   $0x2c
  8018b8:	e8 ac fa ff ff       	call   801369 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
  8018c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8018c3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8018c7:	75 07                	jne    8018d0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8018c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ce:	eb 05                	jmp    8018d5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8018d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 2c                	push   $0x2c
  8018e9:	e8 7b fa ff ff       	call   801369 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
  8018f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8018f4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8018f8:	75 07                	jne    801901 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8018fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ff:	eb 05                	jmp    801906 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 2c                	push   $0x2c
  80191a:	e8 4a fa ff ff       	call   801369 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
  801922:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801925:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801929:	75 07                	jne    801932 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80192b:	b8 01 00 00 00       	mov    $0x1,%eax
  801930:	eb 05                	jmp    801937 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801932:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 2c                	push   $0x2c
  80194b:	e8 19 fa ff ff       	call   801369 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
  801953:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801956:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80195a:	75 07                	jne    801963 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80195c:	b8 01 00 00 00       	mov    $0x1,%eax
  801961:	eb 05                	jmp    801968 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 2d                	push   $0x2d
  80197a:	e8 ea f9 ff ff       	call   801369 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return ;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801989:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	53                   	push   %ebx
  801998:	51                   	push   %ecx
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	6a 2e                	push   $0x2e
  80199d:	e8 c7 f9 ff ff       	call   801369 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8019ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	52                   	push   %edx
  8019ba:	50                   	push   %eax
  8019bb:	6a 2f                	push   $0x2f
  8019bd:	e8 a7 f9 ff ff       	call   801369 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    
  8019c7:	90                   	nop

008019c8 <__udivdi3>:
  8019c8:	55                   	push   %ebp
  8019c9:	57                   	push   %edi
  8019ca:	56                   	push   %esi
  8019cb:	53                   	push   %ebx
  8019cc:	83 ec 1c             	sub    $0x1c,%esp
  8019cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019df:	89 ca                	mov    %ecx,%edx
  8019e1:	89 f8                	mov    %edi,%eax
  8019e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019e7:	85 f6                	test   %esi,%esi
  8019e9:	75 2d                	jne    801a18 <__udivdi3+0x50>
  8019eb:	39 cf                	cmp    %ecx,%edi
  8019ed:	77 65                	ja     801a54 <__udivdi3+0x8c>
  8019ef:	89 fd                	mov    %edi,%ebp
  8019f1:	85 ff                	test   %edi,%edi
  8019f3:	75 0b                	jne    801a00 <__udivdi3+0x38>
  8019f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fa:	31 d2                	xor    %edx,%edx
  8019fc:	f7 f7                	div    %edi
  8019fe:	89 c5                	mov    %eax,%ebp
  801a00:	31 d2                	xor    %edx,%edx
  801a02:	89 c8                	mov    %ecx,%eax
  801a04:	f7 f5                	div    %ebp
  801a06:	89 c1                	mov    %eax,%ecx
  801a08:	89 d8                	mov    %ebx,%eax
  801a0a:	f7 f5                	div    %ebp
  801a0c:	89 cf                	mov    %ecx,%edi
  801a0e:	89 fa                	mov    %edi,%edx
  801a10:	83 c4 1c             	add    $0x1c,%esp
  801a13:	5b                   	pop    %ebx
  801a14:	5e                   	pop    %esi
  801a15:	5f                   	pop    %edi
  801a16:	5d                   	pop    %ebp
  801a17:	c3                   	ret    
  801a18:	39 ce                	cmp    %ecx,%esi
  801a1a:	77 28                	ja     801a44 <__udivdi3+0x7c>
  801a1c:	0f bd fe             	bsr    %esi,%edi
  801a1f:	83 f7 1f             	xor    $0x1f,%edi
  801a22:	75 40                	jne    801a64 <__udivdi3+0x9c>
  801a24:	39 ce                	cmp    %ecx,%esi
  801a26:	72 0a                	jb     801a32 <__udivdi3+0x6a>
  801a28:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a2c:	0f 87 9e 00 00 00    	ja     801ad0 <__udivdi3+0x108>
  801a32:	b8 01 00 00 00       	mov    $0x1,%eax
  801a37:	89 fa                	mov    %edi,%edx
  801a39:	83 c4 1c             	add    $0x1c,%esp
  801a3c:	5b                   	pop    %ebx
  801a3d:	5e                   	pop    %esi
  801a3e:	5f                   	pop    %edi
  801a3f:	5d                   	pop    %ebp
  801a40:	c3                   	ret    
  801a41:	8d 76 00             	lea    0x0(%esi),%esi
  801a44:	31 ff                	xor    %edi,%edi
  801a46:	31 c0                	xor    %eax,%eax
  801a48:	89 fa                	mov    %edi,%edx
  801a4a:	83 c4 1c             	add    $0x1c,%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5e                   	pop    %esi
  801a4f:	5f                   	pop    %edi
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    
  801a52:	66 90                	xchg   %ax,%ax
  801a54:	89 d8                	mov    %ebx,%eax
  801a56:	f7 f7                	div    %edi
  801a58:	31 ff                	xor    %edi,%edi
  801a5a:	89 fa                	mov    %edi,%edx
  801a5c:	83 c4 1c             	add    $0x1c,%esp
  801a5f:	5b                   	pop    %ebx
  801a60:	5e                   	pop    %esi
  801a61:	5f                   	pop    %edi
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    
  801a64:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a69:	89 eb                	mov    %ebp,%ebx
  801a6b:	29 fb                	sub    %edi,%ebx
  801a6d:	89 f9                	mov    %edi,%ecx
  801a6f:	d3 e6                	shl    %cl,%esi
  801a71:	89 c5                	mov    %eax,%ebp
  801a73:	88 d9                	mov    %bl,%cl
  801a75:	d3 ed                	shr    %cl,%ebp
  801a77:	89 e9                	mov    %ebp,%ecx
  801a79:	09 f1                	or     %esi,%ecx
  801a7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a7f:	89 f9                	mov    %edi,%ecx
  801a81:	d3 e0                	shl    %cl,%eax
  801a83:	89 c5                	mov    %eax,%ebp
  801a85:	89 d6                	mov    %edx,%esi
  801a87:	88 d9                	mov    %bl,%cl
  801a89:	d3 ee                	shr    %cl,%esi
  801a8b:	89 f9                	mov    %edi,%ecx
  801a8d:	d3 e2                	shl    %cl,%edx
  801a8f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a93:	88 d9                	mov    %bl,%cl
  801a95:	d3 e8                	shr    %cl,%eax
  801a97:	09 c2                	or     %eax,%edx
  801a99:	89 d0                	mov    %edx,%eax
  801a9b:	89 f2                	mov    %esi,%edx
  801a9d:	f7 74 24 0c          	divl   0xc(%esp)
  801aa1:	89 d6                	mov    %edx,%esi
  801aa3:	89 c3                	mov    %eax,%ebx
  801aa5:	f7 e5                	mul    %ebp
  801aa7:	39 d6                	cmp    %edx,%esi
  801aa9:	72 19                	jb     801ac4 <__udivdi3+0xfc>
  801aab:	74 0b                	je     801ab8 <__udivdi3+0xf0>
  801aad:	89 d8                	mov    %ebx,%eax
  801aaf:	31 ff                	xor    %edi,%edi
  801ab1:	e9 58 ff ff ff       	jmp    801a0e <__udivdi3+0x46>
  801ab6:	66 90                	xchg   %ax,%ax
  801ab8:	8b 54 24 08          	mov    0x8(%esp),%edx
  801abc:	89 f9                	mov    %edi,%ecx
  801abe:	d3 e2                	shl    %cl,%edx
  801ac0:	39 c2                	cmp    %eax,%edx
  801ac2:	73 e9                	jae    801aad <__udivdi3+0xe5>
  801ac4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801ac7:	31 ff                	xor    %edi,%edi
  801ac9:	e9 40 ff ff ff       	jmp    801a0e <__udivdi3+0x46>
  801ace:	66 90                	xchg   %ax,%ax
  801ad0:	31 c0                	xor    %eax,%eax
  801ad2:	e9 37 ff ff ff       	jmp    801a0e <__udivdi3+0x46>
  801ad7:	90                   	nop

00801ad8 <__umoddi3>:
  801ad8:	55                   	push   %ebp
  801ad9:	57                   	push   %edi
  801ada:	56                   	push   %esi
  801adb:	53                   	push   %ebx
  801adc:	83 ec 1c             	sub    $0x1c,%esp
  801adf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ae3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ae7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aeb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801aef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801af3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801af7:	89 f3                	mov    %esi,%ebx
  801af9:	89 fa                	mov    %edi,%edx
  801afb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801aff:	89 34 24             	mov    %esi,(%esp)
  801b02:	85 c0                	test   %eax,%eax
  801b04:	75 1a                	jne    801b20 <__umoddi3+0x48>
  801b06:	39 f7                	cmp    %esi,%edi
  801b08:	0f 86 a2 00 00 00    	jbe    801bb0 <__umoddi3+0xd8>
  801b0e:	89 c8                	mov    %ecx,%eax
  801b10:	89 f2                	mov    %esi,%edx
  801b12:	f7 f7                	div    %edi
  801b14:	89 d0                	mov    %edx,%eax
  801b16:	31 d2                	xor    %edx,%edx
  801b18:	83 c4 1c             	add    $0x1c,%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5f                   	pop    %edi
  801b1e:	5d                   	pop    %ebp
  801b1f:	c3                   	ret    
  801b20:	39 f0                	cmp    %esi,%eax
  801b22:	0f 87 ac 00 00 00    	ja     801bd4 <__umoddi3+0xfc>
  801b28:	0f bd e8             	bsr    %eax,%ebp
  801b2b:	83 f5 1f             	xor    $0x1f,%ebp
  801b2e:	0f 84 ac 00 00 00    	je     801be0 <__umoddi3+0x108>
  801b34:	bf 20 00 00 00       	mov    $0x20,%edi
  801b39:	29 ef                	sub    %ebp,%edi
  801b3b:	89 fe                	mov    %edi,%esi
  801b3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b41:	89 e9                	mov    %ebp,%ecx
  801b43:	d3 e0                	shl    %cl,%eax
  801b45:	89 d7                	mov    %edx,%edi
  801b47:	89 f1                	mov    %esi,%ecx
  801b49:	d3 ef                	shr    %cl,%edi
  801b4b:	09 c7                	or     %eax,%edi
  801b4d:	89 e9                	mov    %ebp,%ecx
  801b4f:	d3 e2                	shl    %cl,%edx
  801b51:	89 14 24             	mov    %edx,(%esp)
  801b54:	89 d8                	mov    %ebx,%eax
  801b56:	d3 e0                	shl    %cl,%eax
  801b58:	89 c2                	mov    %eax,%edx
  801b5a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b5e:	d3 e0                	shl    %cl,%eax
  801b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b64:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b68:	89 f1                	mov    %esi,%ecx
  801b6a:	d3 e8                	shr    %cl,%eax
  801b6c:	09 d0                	or     %edx,%eax
  801b6e:	d3 eb                	shr    %cl,%ebx
  801b70:	89 da                	mov    %ebx,%edx
  801b72:	f7 f7                	div    %edi
  801b74:	89 d3                	mov    %edx,%ebx
  801b76:	f7 24 24             	mull   (%esp)
  801b79:	89 c6                	mov    %eax,%esi
  801b7b:	89 d1                	mov    %edx,%ecx
  801b7d:	39 d3                	cmp    %edx,%ebx
  801b7f:	0f 82 87 00 00 00    	jb     801c0c <__umoddi3+0x134>
  801b85:	0f 84 91 00 00 00    	je     801c1c <__umoddi3+0x144>
  801b8b:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b8f:	29 f2                	sub    %esi,%edx
  801b91:	19 cb                	sbb    %ecx,%ebx
  801b93:	89 d8                	mov    %ebx,%eax
  801b95:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b99:	d3 e0                	shl    %cl,%eax
  801b9b:	89 e9                	mov    %ebp,%ecx
  801b9d:	d3 ea                	shr    %cl,%edx
  801b9f:	09 d0                	or     %edx,%eax
  801ba1:	89 e9                	mov    %ebp,%ecx
  801ba3:	d3 eb                	shr    %cl,%ebx
  801ba5:	89 da                	mov    %ebx,%edx
  801ba7:	83 c4 1c             	add    $0x1c,%esp
  801baa:	5b                   	pop    %ebx
  801bab:	5e                   	pop    %esi
  801bac:	5f                   	pop    %edi
  801bad:	5d                   	pop    %ebp
  801bae:	c3                   	ret    
  801baf:	90                   	nop
  801bb0:	89 fd                	mov    %edi,%ebp
  801bb2:	85 ff                	test   %edi,%edi
  801bb4:	75 0b                	jne    801bc1 <__umoddi3+0xe9>
  801bb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbb:	31 d2                	xor    %edx,%edx
  801bbd:	f7 f7                	div    %edi
  801bbf:	89 c5                	mov    %eax,%ebp
  801bc1:	89 f0                	mov    %esi,%eax
  801bc3:	31 d2                	xor    %edx,%edx
  801bc5:	f7 f5                	div    %ebp
  801bc7:	89 c8                	mov    %ecx,%eax
  801bc9:	f7 f5                	div    %ebp
  801bcb:	89 d0                	mov    %edx,%eax
  801bcd:	e9 44 ff ff ff       	jmp    801b16 <__umoddi3+0x3e>
  801bd2:	66 90                	xchg   %ax,%ax
  801bd4:	89 c8                	mov    %ecx,%eax
  801bd6:	89 f2                	mov    %esi,%edx
  801bd8:	83 c4 1c             	add    $0x1c,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5f                   	pop    %edi
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    
  801be0:	3b 04 24             	cmp    (%esp),%eax
  801be3:	72 06                	jb     801beb <__umoddi3+0x113>
  801be5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801be9:	77 0f                	ja     801bfa <__umoddi3+0x122>
  801beb:	89 f2                	mov    %esi,%edx
  801bed:	29 f9                	sub    %edi,%ecx
  801bef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bf3:	89 14 24             	mov    %edx,(%esp)
  801bf6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bfa:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bfe:	8b 14 24             	mov    (%esp),%edx
  801c01:	83 c4 1c             	add    $0x1c,%esp
  801c04:	5b                   	pop    %ebx
  801c05:	5e                   	pop    %esi
  801c06:	5f                   	pop    %edi
  801c07:	5d                   	pop    %ebp
  801c08:	c3                   	ret    
  801c09:	8d 76 00             	lea    0x0(%esi),%esi
  801c0c:	2b 04 24             	sub    (%esp),%eax
  801c0f:	19 fa                	sbb    %edi,%edx
  801c11:	89 d1                	mov    %edx,%ecx
  801c13:	89 c6                	mov    %eax,%esi
  801c15:	e9 71 ff ff ff       	jmp    801b8b <__umoddi3+0xb3>
  801c1a:	66 90                	xchg   %ax,%ax
  801c1c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c20:	72 ea                	jb     801c0c <__umoddi3+0x134>
  801c22:	89 d9                	mov    %ebx,%ecx
  801c24:	e9 62 ff ff ff       	jmp    801b8b <__umoddi3+0xb3>
