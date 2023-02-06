
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 0c 02 00 00       	call   800242 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 40 15 00 00       	call   8015ab <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 2f 15 00 00       	call   8015ab <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 03 1a 00 00       	call   801a8a <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 51 15 00 00       	call   801642 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 43 15 00 00       	call   801642 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 e3 18 00 00       	call   8019ea <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 96 14 00 00       	call   8015ab <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb 1c 34 80 00       	mov    $0x80341c,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	eb 7e                	jmp    8001eb <_main+0x1b3>
		{
			int found = 0 ;
  80016d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800174:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017b:	eb 3d                	jmp    8001ba <_main+0x182>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80017d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800180:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  80018f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	c1 e0 03             	shl    $0x3,%eax
  80019b:	01 d8                	add    %ebx,%eax
  80019d:	8b 00                	mov    (%eax),%eax
  80019f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001aa:	39 c1                	cmp    %eax,%ecx
  8001ac:	75 09                	jne    8001b7 <_main+0x17f>
				{
					found = 1 ;
  8001ae:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b5:	eb 12                	jmp    8001c9 <_main+0x191>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001b7:	ff 45 e0             	incl   -0x20(%ebp)
  8001ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8001bf:	8b 50 74             	mov    0x74(%eax),%edx
  8001c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c5:	39 c2                	cmp    %eax,%edx
  8001c7:	77 b4                	ja     80017d <_main+0x145>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cd:	75 19                	jne    8001e8 <_main+0x1b0>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d2:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001d6:	50                   	push   %eax
  8001d7:	68 20 33 80 00       	push   $0x803320
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 81 33 80 00       	push   $0x803381
  8001e3:	e8 96 01 00 00       	call   80037e <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001e8:	ff 45 e4             	incl   -0x1c(%ebp)
  8001eb:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001ef:	0f 8e 78 ff ff ff    	jle    80016d <_main+0x135>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001f5:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001f8:	e8 ed 17 00 00       	call   8019ea <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 dc 17 00 00       	call   8019ea <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 98 33 80 00       	push   $0x803398
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 81 33 80 00       	push   $0x803381
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 dc 33 80 00       	push   $0x8033dc
  800231:	e8 fc 03 00 00       	call   800632 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp


	return;
  800239:	90                   	nop
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    

00800242 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800248:	e8 7d 1a 00 00       	call   801cca <sys_getenvindex>
  80024d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800253:	89 d0                	mov    %edx,%eax
  800255:	c1 e0 03             	shl    $0x3,%eax
  800258:	01 d0                	add    %edx,%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800265:	01 d0                	add    %edx,%eax
  800267:	c1 e0 04             	shl    $0x4,%eax
  80026a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80027f:	84 c0                	test   %al,%al
  800281:	74 0f                	je     800292 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800283:	a1 20 40 80 00       	mov    0x804020,%eax
  800288:	05 5c 05 00 00       	add    $0x55c,%eax
  80028d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800296:	7e 0a                	jle    8002a2 <libmain+0x60>
		binaryname = argv[0];
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	e8 88 fd ff ff       	call   800038 <_main>
  8002b0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b3:	e8 1f 18 00 00       	call   801ad7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 50 34 80 00       	push   $0x803450
  8002c0:	e8 6d 03 00 00       	call   800632 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002cd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 78 34 80 00       	push   $0x803478
  8002e8:	e8 45 03 00 00       	call   800632 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800300:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800306:	a1 20 40 80 00       	mov    0x804020,%eax
  80030b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 a0 34 80 00       	push   $0x8034a0
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 40 80 00       	mov    0x804020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 f8 34 80 00       	push   $0x8034f8
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 50 34 80 00       	push   $0x803450
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 9f 17 00 00       	call   801af1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800352:	e8 19 00 00 00       	call   800370 <exit>
}
  800357:	90                   	nop
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	6a 00                	push   $0x0
  800365:	e8 2c 19 00 00       	call   801c96 <sys_destroy_env>
  80036a:	83 c4 10             	add    $0x10,%esp
}
  80036d:	90                   	nop
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <exit>:

void
exit(void)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800376:	e8 81 19 00 00       	call   801cfc <sys_exit_env>
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800384:	8d 45 10             	lea    0x10(%ebp),%eax
  800387:	83 c0 04             	add    $0x4,%eax
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80038d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800392:	85 c0                	test   %eax,%eax
  800394:	74 16                	je     8003ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800396:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	50                   	push   %eax
  80039f:	68 0c 35 80 00       	push   $0x80350c
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 11 35 80 00       	push   $0x803511
  8003bd:	e8 70 02 00 00       	call   800632 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	50                   	push   %eax
  8003cf:	e8 f3 01 00 00       	call   8005c7 <vcprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	6a 00                	push   $0x0
  8003dc:	68 2d 35 80 00       	push   $0x80352d
  8003e1:	e8 e1 01 00 00       	call   8005c7 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003e9:	e8 82 ff ff ff       	call   800370 <exit>

	// should not return here
	while (1) ;
  8003ee:	eb fe                	jmp    8003ee <_panic+0x70>

008003f0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fb:	8b 50 74             	mov    0x74(%eax),%edx
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	39 c2                	cmp    %eax,%edx
  800403:	74 14                	je     800419 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	68 30 35 80 00       	push   $0x803530
  80040d:	6a 26                	push   $0x26
  80040f:	68 7c 35 80 00       	push   $0x80357c
  800414:	e8 65 ff ff ff       	call   80037e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800427:	e9 c2 00 00 00       	jmp    8004ee <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	85 c0                	test   %eax,%eax
  80043f:	75 08                	jne    800449 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800441:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800444:	e9 a2 00 00 00       	jmp    8004eb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800449:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800457:	eb 69                	jmp    8004c2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	c1 e0 03             	shl    $0x3,%eax
  800470:	01 c8                	add    %ecx,%eax
  800472:	8a 40 04             	mov    0x4(%eax),%al
  800475:	84 c0                	test   %al,%al
  800477:	75 46                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800484:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800487:	89 d0                	mov    %edx,%eax
  800489:	01 c0                	add    %eax,%eax
  80048b:	01 d0                	add    %edx,%eax
  80048d:	c1 e0 03             	shl    $0x3,%eax
  800490:	01 c8                	add    %ecx,%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800497:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80049a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	01 c8                	add    %ecx,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b2:	39 c2                	cmp    %eax,%edx
  8004b4:	75 09                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004bd:	eb 12                	jmp    8004d1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bf:	ff 45 e8             	incl   -0x18(%ebp)
  8004c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c7:	8b 50 74             	mov    0x74(%eax),%edx
  8004ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	77 88                	ja     800459 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004d5:	75 14                	jne    8004eb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 88 35 80 00       	push   $0x803588
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 7c 35 80 00       	push   $0x80357c
  8004e6:	e8 93 fe ff ff       	call   80037e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004eb:	ff 45 f0             	incl   -0x10(%ebp)
  8004ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 32 ff ff ff    	jl     80042c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800501:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800508:	eb 26                	jmp    800530 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80050a:	a1 20 40 80 00       	mov    0x804020,%eax
  80050f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8a 40 04             	mov    0x4(%eax),%al
  800526:	3c 01                	cmp    $0x1,%al
  800528:	75 03                	jne    80052d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80052a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052d:	ff 45 e0             	incl   -0x20(%ebp)
  800530:	a1 20 40 80 00       	mov    0x804020,%eax
  800535:	8b 50 74             	mov    0x74(%eax),%edx
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	77 cb                	ja     80050a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80053f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800542:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800545:	74 14                	je     80055b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	68 dc 35 80 00       	push   $0x8035dc
  80054f:	6a 44                	push   $0x44
  800551:	68 7c 35 80 00       	push   $0x80357c
  800556:	e8 23 fe ff ff       	call   80037e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	8d 48 01             	lea    0x1(%eax),%ecx
  80056c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056f:	89 0a                	mov    %ecx,(%edx)
  800571:	8b 55 08             	mov    0x8(%ebp),%edx
  800574:	88 d1                	mov    %dl,%cl
  800576:	8b 55 0c             	mov    0xc(%ebp),%edx
  800579:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80057d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	3d ff 00 00 00       	cmp    $0xff,%eax
  800587:	75 2c                	jne    8005b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800589:	a0 24 40 80 00       	mov    0x804024,%al
  80058e:	0f b6 c0             	movzbl %al,%eax
  800591:	8b 55 0c             	mov    0xc(%ebp),%edx
  800594:	8b 12                	mov    (%edx),%edx
  800596:	89 d1                	mov    %edx,%ecx
  800598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059b:	83 c2 08             	add    $0x8,%edx
  80059e:	83 ec 04             	sub    $0x4,%esp
  8005a1:	50                   	push   %eax
  8005a2:	51                   	push   %ecx
  8005a3:	52                   	push   %edx
  8005a4:	e8 80 13 00 00       	call   801929 <sys_cputs>
  8005a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 40 04             	mov    0x4(%eax),%eax
  8005bb:	8d 50 01             	lea    0x1(%eax),%edx
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005c4:	90                   	nop
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d7:	00 00 00 
	b.cnt = 0;
  8005da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f0:	50                   	push   %eax
  8005f1:	68 5e 05 80 00       	push   $0x80055e
  8005f6:	e8 11 02 00 00       	call   80080c <vprintfmt>
  8005fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005fe:	a0 24 40 80 00       	mov    0x804024,%al
  800603:	0f b6 c0             	movzbl %al,%eax
  800606:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	50                   	push   %eax
  800610:	52                   	push   %edx
  800611:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800617:	83 c0 08             	add    $0x8,%eax
  80061a:	50                   	push   %eax
  80061b:	e8 09 13 00 00       	call   801929 <sys_cputs>
  800620:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800623:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80062a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <cprintf>:

int cprintf(const char *fmt, ...) {
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800638:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80063f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	e8 73 ff ff ff       	call   8005c7 <vcprintf>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800665:	e8 6d 14 00 00       	call   801ad7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80066a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 f4             	pushl  -0xc(%ebp)
  800679:	50                   	push   %eax
  80067a:	e8 48 ff ff ff       	call   8005c7 <vcprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800685:	e8 67 14 00 00       	call   801af1 <sys_enable_interrupt>
	return cnt;
  80068a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	53                   	push   %ebx
  800693:	83 ec 14             	sub    $0x14,%esp
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ad:	77 55                	ja     800704 <printnum+0x75>
  8006af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b2:	72 05                	jb     8006b9 <printnum+0x2a>
  8006b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b7:	77 4b                	ja     800704 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006cf:	e8 d0 29 00 00       	call   8030a4 <__udivdi3>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	ff 75 20             	pushl  0x20(%ebp)
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 18             	pushl  0x18(%ebp)
  8006e1:	52                   	push   %edx
  8006e2:	50                   	push   %eax
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 a1 ff ff ff       	call   80068f <printnum>
  8006ee:	83 c4 20             	add    $0x20,%esp
  8006f1:	eb 1a                	jmp    80070d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	ff d0                	call   *%eax
  800701:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800704:	ff 4d 1c             	decl   0x1c(%ebp)
  800707:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070b:	7f e6                	jg     8006f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800710:	bb 00 00 00 00       	mov    $0x0,%ebx
  800715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071b:	53                   	push   %ebx
  80071c:	51                   	push   %ecx
  80071d:	52                   	push   %edx
  80071e:	50                   	push   %eax
  80071f:	e8 90 2a 00 00       	call   8031b4 <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 54 38 80 00       	add    $0x803854,%eax
  80072c:	8a 00                	mov    (%eax),%al
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	50                   	push   %eax
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
}
  800740:	90                   	nop
  800741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800749:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074d:	7e 1c                	jle    80076b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 08             	lea    0x8(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 08             	sub    $0x8,%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	eb 40                	jmp    8007ab <getuint+0x65>
	else if (lflag)
  80076b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076f:	74 1e                	je     80078f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	8d 50 04             	lea    0x4(%eax),%edx
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	89 10                	mov    %edx,(%eax)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 e8 04             	sub    $0x4,%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	eb 1c                	jmp    8007ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b4:	7e 1c                	jle    8007d2 <getint+0x25>
		return va_arg(*ap, long long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 08             	lea    0x8(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 08             	sub    $0x8,%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	eb 38                	jmp    80080a <getint+0x5d>
	else if (lflag)
  8007d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d6:	74 1a                	je     8007f2 <getint+0x45>
		return va_arg(*ap, long);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	8d 50 04             	lea    0x4(%eax),%edx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	89 10                	mov    %edx,(%eax)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	83 e8 04             	sub    $0x4,%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	99                   	cltd   
  8007f0:	eb 18                	jmp    80080a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	8d 50 04             	lea    0x4(%eax),%edx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	89 10                	mov    %edx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	99                   	cltd   
}
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	56                   	push   %esi
  800810:	53                   	push   %ebx
  800811:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	eb 17                	jmp    80082d <vprintfmt+0x21>
			if (ch == '\0')
  800816:	85 db                	test   %ebx,%ebx
  800818:	0f 84 af 03 00 00    	je     800bcd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	53                   	push   %ebx
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	8d 50 01             	lea    0x1(%eax),%edx
  800833:	89 55 10             	mov    %edx,0x10(%ebp)
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f b6 d8             	movzbl %al,%ebx
  80083b:	83 fb 25             	cmp    $0x25,%ebx
  80083e:	75 d6                	jne    800816 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800840:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800844:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800859:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800860:	8b 45 10             	mov    0x10(%ebp),%eax
  800863:	8d 50 01             	lea    0x1(%eax),%edx
  800866:	89 55 10             	mov    %edx,0x10(%ebp)
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f b6 d8             	movzbl %al,%ebx
  80086e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800871:	83 f8 55             	cmp    $0x55,%eax
  800874:	0f 87 2b 03 00 00    	ja     800ba5 <vprintfmt+0x399>
  80087a:	8b 04 85 78 38 80 00 	mov    0x803878(,%eax,4),%eax
  800881:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800883:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800887:	eb d7                	jmp    800860 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800889:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80088d:	eb d1                	jmp    800860 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800896:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800899:	89 d0                	mov    %edx,%eax
  80089b:	c1 e0 02             	shl    $0x2,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d8                	add    %ebx,%eax
  8008a4:	83 e8 30             	sub    $0x30,%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ad:	8a 00                	mov    (%eax),%al
  8008af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b5:	7e 3e                	jle    8008f5 <vprintfmt+0xe9>
  8008b7:	83 fb 39             	cmp    $0x39,%ebx
  8008ba:	7f 39                	jg     8008f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008bf:	eb d5                	jmp    800896 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d5:	eb 1f                	jmp    8008f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	79 83                	jns    800860 <vprintfmt+0x54>
				width = 0;
  8008dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e4:	e9 77 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f0:	e9 6b ff ff ff       	jmp    800860 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	0f 89 60 ff ff ff    	jns    800860 <vprintfmt+0x54>
				width = precision, precision = -1;
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800906:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80090d:	e9 4e ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800912:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800915:	e9 46 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	50                   	push   %eax
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	e9 89 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800950:	85 db                	test   %ebx,%ebx
  800952:	79 02                	jns    800956 <vprintfmt+0x14a>
				err = -err;
  800954:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800956:	83 fb 64             	cmp    $0x64,%ebx
  800959:	7f 0b                	jg     800966 <vprintfmt+0x15a>
  80095b:	8b 34 9d c0 36 80 00 	mov    0x8036c0(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 65 38 80 00       	push   $0x803865
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 5e 02 00 00       	call   800bd5 <printfmt>
  800977:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097a:	e9 49 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80097f:	56                   	push   %esi
  800980:	68 6e 38 80 00       	push   $0x80386e
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	e8 45 02 00 00       	call   800bd5 <printfmt>
  800990:	83 c4 10             	add    $0x10,%esp
			break;
  800993:	e9 30 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 30                	mov    (%eax),%esi
  8009a9:	85 f6                	test   %esi,%esi
  8009ab:	75 05                	jne    8009b2 <vprintfmt+0x1a6>
				p = "(null)";
  8009ad:	be 71 38 80 00       	mov    $0x803871,%esi
			if (width > 0 && padc != '-')
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7e 6d                	jle    800a25 <vprintfmt+0x219>
  8009b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bc:	74 67                	je     800a25 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	50                   	push   %eax
  8009c5:	56                   	push   %esi
  8009c6:	e8 0c 03 00 00       	call   800cd7 <strnlen>
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d1:	eb 16                	jmp    8009e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	50                   	push   %eax
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ed:	7f e4                	jg     8009d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ef:	eb 34                	jmp    800a25 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f5:	74 1c                	je     800a13 <vprintfmt+0x207>
  8009f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fa:	7e 05                	jle    800a01 <vprintfmt+0x1f5>
  8009fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ff:	7e 12                	jle    800a13 <vprintfmt+0x207>
					putch('?', putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	6a 3f                	push   $0x3f
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a22:	ff 4d e4             	decl   -0x1c(%ebp)
  800a25:	89 f0                	mov    %esi,%eax
  800a27:	8d 70 01             	lea    0x1(%eax),%esi
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	74 24                	je     800a57 <vprintfmt+0x24b>
  800a33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a37:	78 b8                	js     8009f1 <vprintfmt+0x1e5>
  800a39:	ff 4d e0             	decl   -0x20(%ebp)
  800a3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a40:	79 af                	jns    8009f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a42:	eb 13                	jmp    800a57 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 20                	push   $0x20
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	ff 4d e4             	decl   -0x1c(%ebp)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	7f e7                	jg     800a44 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a5d:	e9 66 01 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 3c fd ff ff       	call   8007ad <getint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a80:	85 d2                	test   %edx,%edx
  800a82:	79 23                	jns    800aa7 <vprintfmt+0x29b>
				putch('-', putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	6a 2d                	push   $0x2d
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9a:	f7 d8                	neg    %eax
  800a9c:	83 d2 00             	adc    $0x0,%edx
  800a9f:	f7 da                	neg    %edx
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aae:	e9 bc 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 84 fc ff ff       	call   800746 <getuint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800acb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad2:	e9 98 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 58                	push   $0x58
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 bc 00 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 30                	push   $0x30
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 78                	push   $0x78
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	83 c0 04             	add    $0x4,%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 e8 04             	sub    $0x4,%eax
  800b3b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b4e:	eb 1f                	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 e8             	pushl  -0x18(%ebp)
  800b56:	8d 45 14             	lea    0x14(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 e7 fb ff ff       	call   800746 <getuint>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b68:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b76:	83 ec 04             	sub    $0x4,%esp
  800b79:	52                   	push   %edx
  800b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	ff 75 f0             	pushl  -0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 00 fb ff ff       	call   80068f <printnum>
  800b8f:	83 c4 20             	add    $0x20,%esp
			break;
  800b92:	eb 34                	jmp    800bc8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			break;
  800ba3:	eb 23                	jmp    800bc8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 25                	push   $0x25
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb5:	ff 4d 10             	decl   0x10(%ebp)
  800bb8:	eb 03                	jmp    800bbd <vprintfmt+0x3b1>
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	48                   	dec    %eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	3c 25                	cmp    $0x25,%al
  800bc5:	75 f3                	jne    800bba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bc7:	90                   	nop
		}
	}
  800bc8:	e9 47 fc ff ff       	jmp    800814 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bcd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bdb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bea:	50                   	push   %eax
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	ff 75 08             	pushl  0x8(%ebp)
  800bf1:	e8 16 fc ff ff       	call   80080c <vprintfmt>
  800bf6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf9:	90                   	nop
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 08             	mov    0x8(%eax),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 10                	mov    (%eax),%edx
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 40 04             	mov    0x4(%eax),%eax
  800c19:	39 c2                	cmp    %eax,%edx
  800c1b:	73 12                	jae    800c2f <sprintputch+0x33>
		*b->buf++ = ch;
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	8d 48 01             	lea    0x1(%eax),%ecx
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	89 0a                	mov    %ecx,(%edx)
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	88 10                	mov    %dl,(%eax)
}
  800c2f:	90                   	nop
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	01 d0                	add    %edx,%eax
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c57:	74 06                	je     800c5f <vsnprintf+0x2d>
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	7f 07                	jg     800c66 <vsnprintf+0x34>
		return -E_INVAL;
  800c5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c64:	eb 20                	jmp    800c86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c66:	ff 75 14             	pushl  0x14(%ebp)
  800c69:	ff 75 10             	pushl  0x10(%ebp)
  800c6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	68 fc 0b 80 00       	push   $0x800bfc
  800c75:	e8 92 fb ff ff       	call   80080c <vprintfmt>
  800c7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c91:	83 c0 04             	add    $0x4,%eax
  800c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 89 ff ff ff       	call   800c32 <vsnprintf>
  800ca9:	83 c4 10             	add    $0x10,%esp
  800cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc1:	eb 06                	jmp    800cc9 <strlen+0x15>
		n++;
  800cc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	75 f1                	jne    800cc3 <strlen+0xf>
		n++;
	return n;
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce4:	eb 09                	jmp    800cef <strnlen+0x18>
		n++;
  800ce6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	ff 4d 0c             	decl   0xc(%ebp)
  800cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf3:	74 09                	je     800cfe <strnlen+0x27>
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 e8                	jne    800ce6 <strnlen+0xf>
		n++;
	return n;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0f:	90                   	nop
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8d 50 01             	lea    0x1(%eax),%edx
  800d16:	89 55 08             	mov    %edx,0x8(%ebp)
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d22:	8a 12                	mov    (%edx),%dl
  800d24:	88 10                	mov    %dl,(%eax)
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 e4                	jne    800d10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d44:	eb 1f                	jmp    800d65 <strncpy+0x34>
		*dst++ = *src;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d52:	8a 12                	mov    (%edx),%dl
  800d54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 03                	je     800d62 <strncpy+0x31>
			src++;
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6b:	72 d9                	jb     800d46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d82:	74 30                	je     800db4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d84:	eb 16                	jmp    800d9c <strlcpy+0x2a>
			*dst++ = *src++;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9c:	ff 4d 10             	decl   0x10(%ebp)
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 09                	je     800dae <strlcpy+0x3c>
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 d8                	jne    800d86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	29 c2                	sub    %eax,%edx
  800dbc:	89 d0                	mov    %edx,%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc3:	eb 06                	jmp    800dcb <strcmp+0xb>
		p++, q++;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	84 c0                	test   %al,%al
  800dd2:	74 0e                	je     800de2 <strcmp+0x22>
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 10                	mov    (%eax),%dl
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 e3                	je     800dc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 d0             	movzbl %al,%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 c0             	movzbl %al,%eax
  800df2:	29 c2                	sub    %eax,%edx
  800df4:	89 d0                	mov    %edx,%eax
}
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfb:	eb 09                	jmp    800e06 <strncmp+0xe>
		n--, p++, q++;
  800dfd:	ff 4d 10             	decl   0x10(%ebp)
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0a:	74 17                	je     800e23 <strncmp+0x2b>
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	84 c0                	test   %al,%al
  800e13:	74 0e                	je     800e23 <strncmp+0x2b>
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 10                	mov    (%eax),%dl
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	38 c2                	cmp    %al,%dl
  800e21:	74 da                	je     800dfd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e27:	75 07                	jne    800e30 <strncmp+0x38>
		return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2e:	eb 14                	jmp    800e44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 d0             	movzbl %al,%edx
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f b6 c0             	movzbl %al,%eax
  800e40:	29 c2                	sub    %eax,%edx
  800e42:	89 d0                	mov    %edx,%eax
}
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e52:	eb 12                	jmp    800e66 <strchr+0x20>
		if (*s == c)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5c:	75 05                	jne    800e63 <strchr+0x1d>
			return (char *) s;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	eb 11                	jmp    800e74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 e5                	jne    800e54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 04             	sub    $0x4,%esp
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e82:	eb 0d                	jmp    800e91 <strfind+0x1b>
		if (*s == c)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8c:	74 0e                	je     800e9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	84 c0                	test   %al,%al
  800e98:	75 ea                	jne    800e84 <strfind+0xe>
  800e9a:	eb 01                	jmp    800e9d <strfind+0x27>
		if (*s == c)
			break;
  800e9c:	90                   	nop
	return (char *) s;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eb4:	eb 0e                	jmp    800ec4 <memset+0x22>
		*p++ = c;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	8d 50 01             	lea    0x1(%eax),%edx
  800ebc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ec4:	ff 4d f8             	decl   -0x8(%ebp)
  800ec7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ecb:	79 e9                	jns    800eb6 <memset+0x14>
		*p++ = c;

	return v;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ee4:	eb 16                	jmp    800efc <memcpy+0x2a>
		*d++ = *s++;
  800ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef8:	8a 12                	mov    (%edx),%dl
  800efa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 dd                	jne    800ee6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f26:	73 50                	jae    800f78 <memmove+0x6a>
  800f28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 d0                	add    %edx,%eax
  800f30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f33:	76 43                	jbe    800f78 <memmove+0x6a>
		s += n;
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f41:	eb 10                	jmp    800f53 <memmove+0x45>
			*--d = *--s;
  800f43:	ff 4d f8             	decl   -0x8(%ebp)
  800f46:	ff 4d fc             	decl   -0x4(%ebp)
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f59:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 e3                	jne    800f43 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f60:	eb 23                	jmp    800f85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 dd                	jne    800f62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f9c:	eb 2a                	jmp    800fc8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	8a 10                	mov    (%eax),%dl
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	38 c2                	cmp    %al,%dl
  800faa:	74 16                	je     800fc2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	eb 18                	jmp    800fda <memcmp+0x50>
		s1++, s2++;
  800fc2:	ff 45 fc             	incl   -0x4(%ebp)
  800fc5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 c9                	jne    800f9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fed:	eb 15                	jmp    801004 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	0f b6 c0             	movzbl %al,%eax
  800ffd:	39 c2                	cmp    %eax,%edx
  800fff:	74 0d                	je     80100e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100a:	72 e3                	jb     800fef <memfind+0x13>
  80100c:	eb 01                	jmp    80100f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80100e:	90                   	nop
	return (void *) s;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801021:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801028:	eb 03                	jmp    80102d <strtol+0x19>
		s++;
  80102a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 20                	cmp    $0x20,%al
  801034:	74 f4                	je     80102a <strtol+0x16>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 09                	cmp    $0x9,%al
  80103d:	74 eb                	je     80102a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 2b                	cmp    $0x2b,%al
  801046:	75 05                	jne    80104d <strtol+0x39>
		s++;
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	eb 13                	jmp    801060 <strtol+0x4c>
	else if (*s == '-')
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3c 2d                	cmp    $0x2d,%al
  801054:	75 0a                	jne    801060 <strtol+0x4c>
		s++, neg = 1;
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801064:	74 06                	je     80106c <strtol+0x58>
  801066:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106a:	75 20                	jne    80108c <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 30                	cmp    $0x30,%al
  801073:	75 17                	jne    80108c <strtol+0x78>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	40                   	inc    %eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 78                	cmp    $0x78,%al
  80107d:	75 0d                	jne    80108c <strtol+0x78>
		s += 2, base = 16;
  80107f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801083:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108a:	eb 28                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	75 15                	jne    8010a7 <strtol+0x93>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3c 30                	cmp    $0x30,%al
  801099:	75 0c                	jne    8010a7 <strtol+0x93>
		s++, base = 8;
  80109b:	ff 45 08             	incl   0x8(%ebp)
  80109e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a5:	eb 0d                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0)
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	75 07                	jne    8010b4 <strtol+0xa0>
		base = 10;
  8010ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 2f                	cmp    $0x2f,%al
  8010bb:	7e 19                	jle    8010d6 <strtol+0xc2>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 39                	cmp    $0x39,%al
  8010c4:	7f 10                	jg     8010d6 <strtol+0xc2>
			dig = *s - '0';
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	0f be c0             	movsbl %al,%eax
  8010ce:	83 e8 30             	sub    $0x30,%eax
  8010d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d4:	eb 42                	jmp    801118 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 60                	cmp    $0x60,%al
  8010dd:	7e 19                	jle    8010f8 <strtol+0xe4>
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 7a                	cmp    $0x7a,%al
  8010e6:	7f 10                	jg     8010f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	0f be c0             	movsbl %al,%eax
  8010f0:	83 e8 57             	sub    $0x57,%eax
  8010f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f6:	eb 20                	jmp    801118 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 40                	cmp    $0x40,%al
  8010ff:	7e 39                	jle    80113a <strtol+0x126>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 5a                	cmp    $0x5a,%al
  801108:	7f 30                	jg     80113a <strtol+0x126>
			dig = *s - 'A' + 10;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f be c0             	movsbl %al,%eax
  801112:	83 e8 37             	sub    $0x37,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111e:	7d 19                	jge    801139 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801120:	ff 45 08             	incl   0x8(%ebp)
  801123:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801126:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801134:	e9 7b ff ff ff       	jmp    8010b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801139:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113e:	74 08                	je     801148 <strtol+0x134>
		*endptr = (char *) s;
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114c:	74 07                	je     801155 <strtol+0x141>
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	f7 d8                	neg    %eax
  801153:	eb 03                	jmp    801158 <strtol+0x144>
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <ltostr>:

void
ltostr(long value, char *str)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801172:	79 13                	jns    801187 <ltostr+0x2d>
	{
		neg = 1;
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801181:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801184:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80118f:	99                   	cltd   
  801190:	f7 f9                	idiv   %ecx
  801192:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119e:	89 c2                	mov    %eax,%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a8:	83 c2 30             	add    $0x30,%edx
  8011ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b5:	f7 e9                	imul   %ecx
  8011b7:	c1 fa 02             	sar    $0x2,%edx
  8011ba:	89 c8                	mov    %ecx,%eax
  8011bc:	c1 f8 1f             	sar    $0x1f,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ce:	f7 e9                	imul   %ecx
  8011d0:	c1 fa 02             	sar    $0x2,%edx
  8011d3:	89 c8                	mov    %ecx,%eax
  8011d5:	c1 f8 1f             	sar    $0x1f,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
  8011dc:	c1 e0 02             	shl    $0x2,%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	01 c0                	add    %eax,%eax
  8011e3:	29 c1                	sub    %eax,%ecx
  8011e5:	89 ca                	mov    %ecx,%edx
  8011e7:	85 d2                	test   %edx,%edx
  8011e9:	75 9c                	jne    801187 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	48                   	dec    %eax
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011fd:	74 3d                	je     80123c <ltostr+0xe2>
		start = 1 ;
  8011ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801206:	eb 34                	jmp    80123c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 c8                	add    %ecx,%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 c2                	add    %eax,%edx
  801231:	8a 45 eb             	mov    -0x15(%ebp),%al
  801234:	88 02                	mov    %al,(%edx)
		start++ ;
  801236:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801239:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80123c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801242:	7c c4                	jl     801208 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801244:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 54 fa ff ff       	call   800cb4 <strlen>
  801260:	83 c4 04             	add    $0x4,%esp
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 46 fa ff ff       	call   800cb4 <strlen>
  80126e:	83 c4 04             	add    $0x4,%esp
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801282:	eb 17                	jmp    80129b <strcconcat+0x49>
		final[s] = str1[s] ;
  801284:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	01 c8                	add    %ecx,%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801298:	ff 45 fc             	incl   -0x4(%ebp)
  80129b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012a1:	7c e1                	jl     801284 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012b1:	eb 1f                	jmp    8012d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012bc:	89 c2                	mov    %eax,%edx
  8012be:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 c8                	add    %ecx,%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d8:	7c d9                	jl     8012b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f7:	8b 00                	mov    (%eax),%eax
  8012f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80130b:	eb 0c                	jmp    801319 <strsplit+0x31>
			*string++ = 0;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8d 50 01             	lea    0x1(%eax),%edx
  801313:	89 55 08             	mov    %edx,0x8(%ebp)
  801316:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	84 c0                	test   %al,%al
  801320:	74 18                	je     80133a <strsplit+0x52>
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	0f be c0             	movsbl %al,%eax
  80132a:	50                   	push   %eax
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	e8 13 fb ff ff       	call   800e46 <strchr>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	75 d3                	jne    80130d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	84 c0                	test   %al,%al
  801341:	74 5a                	je     80139d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801343:	8b 45 14             	mov    0x14(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 f8 0f             	cmp    $0xf,%eax
  80134b:	75 07                	jne    801354 <strsplit+0x6c>
		{
			return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	eb 66                	jmp    8013ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801354:	8b 45 14             	mov    0x14(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 14             	mov    0x14(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801372:	eb 03                	jmp    801377 <strsplit+0x8f>
			string++;
  801374:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 8b                	je     80130b <strsplit+0x23>
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f be c0             	movsbl %al,%eax
  801388:	50                   	push   %eax
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	e8 b5 fa ff ff       	call   800e46 <strchr>
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	74 dc                	je     801374 <strsplit+0x8c>
			string++;
	}
  801398:	e9 6e ff ff ff       	jmp    80130b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80139d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80139e:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a1:	8b 00                	mov    (%eax),%eax
  8013a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	01 d0                	add    %edx,%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 1f                	je     8013ea <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013cb:	e8 1d 00 00 00       	call   8013ed <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 d0 39 80 00       	push   $0x8039d0
  8013d8:	e8 55 f2 ff ff       	call   800632 <cprintf>
  8013dd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013e0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013e7:	00 00 00 
	}
}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8013f3:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013fa:	00 00 00 
  8013fd:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801404:	00 00 00 
  801407:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80140e:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801411:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801418:	00 00 00 
  80141b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801422:	00 00 00 
  801425:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80142c:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80142f:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801439:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80143e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801443:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801448:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80144f:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801452:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145c:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801461:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801467:	ba 00 00 00 00       	mov    $0x0,%edx
  80146c:	f7 75 f0             	divl   -0x10(%ebp)
  80146f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801472:	29 d0                	sub    %edx,%eax
  801474:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801477:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80147e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801481:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801486:	2d 00 10 00 00       	sub    $0x1000,%eax
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	6a 06                	push   $0x6
  801490:	ff 75 e8             	pushl  -0x18(%ebp)
  801493:	50                   	push   %eax
  801494:	e8 d4 05 00 00       	call   801a6d <sys_allocate_chunk>
  801499:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80149c:	a1 20 41 80 00       	mov    0x804120,%eax
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	50                   	push   %eax
  8014a5:	e8 49 0c 00 00       	call   8020f3 <initialize_MemBlocksList>
  8014aa:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8014ad:	a1 48 41 80 00       	mov    0x804148,%eax
  8014b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8014b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b9:	75 14                	jne    8014cf <initialize_dyn_block_system+0xe2>
  8014bb:	83 ec 04             	sub    $0x4,%esp
  8014be:	68 f5 39 80 00       	push   $0x8039f5
  8014c3:	6a 39                	push   $0x39
  8014c5:	68 13 3a 80 00       	push   $0x803a13
  8014ca:	e8 af ee ff ff       	call   80037e <_panic>
  8014cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d2:	8b 00                	mov    (%eax),%eax
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	74 10                	je     8014e8 <initialize_dyn_block_system+0xfb>
  8014d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014db:	8b 00                	mov    (%eax),%eax
  8014dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014e0:	8b 52 04             	mov    0x4(%edx),%edx
  8014e3:	89 50 04             	mov    %edx,0x4(%eax)
  8014e6:	eb 0b                	jmp    8014f3 <initialize_dyn_block_system+0x106>
  8014e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014eb:	8b 40 04             	mov    0x4(%eax),%eax
  8014ee:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f6:	8b 40 04             	mov    0x4(%eax),%eax
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	74 0f                	je     80150c <initialize_dyn_block_system+0x11f>
  8014fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801500:	8b 40 04             	mov    0x4(%eax),%eax
  801503:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801506:	8b 12                	mov    (%edx),%edx
  801508:	89 10                	mov    %edx,(%eax)
  80150a:	eb 0a                	jmp    801516 <initialize_dyn_block_system+0x129>
  80150c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150f:	8b 00                	mov    (%eax),%eax
  801511:	a3 48 41 80 00       	mov    %eax,0x804148
  801516:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80151f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801522:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801529:	a1 54 41 80 00       	mov    0x804154,%eax
  80152e:	48                   	dec    %eax
  80152f:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801534:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801537:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80153e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801541:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801548:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80154c:	75 14                	jne    801562 <initialize_dyn_block_system+0x175>
  80154e:	83 ec 04             	sub    $0x4,%esp
  801551:	68 20 3a 80 00       	push   $0x803a20
  801556:	6a 3f                	push   $0x3f
  801558:	68 13 3a 80 00       	push   $0x803a13
  80155d:	e8 1c ee ff ff       	call   80037e <_panic>
  801562:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156b:	89 10                	mov    %edx,(%eax)
  80156d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	85 c0                	test   %eax,%eax
  801574:	74 0d                	je     801583 <initialize_dyn_block_system+0x196>
  801576:	a1 38 41 80 00       	mov    0x804138,%eax
  80157b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80157e:	89 50 04             	mov    %edx,0x4(%eax)
  801581:	eb 08                	jmp    80158b <initialize_dyn_block_system+0x19e>
  801583:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801586:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80158b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158e:	a3 38 41 80 00       	mov    %eax,0x804138
  801593:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801596:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80159d:	a1 44 41 80 00       	mov    0x804144,%eax
  8015a2:	40                   	inc    %eax
  8015a3:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8015a8:	90                   	nop
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b1:	e8 06 fe ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ba:	75 07                	jne    8015c3 <malloc+0x18>
  8015bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c1:	eb 7d                	jmp    801640 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8015c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8015ca:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	48                   	dec    %eax
  8015da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e5:	f7 75 f0             	divl   -0x10(%ebp)
  8015e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015eb:	29 d0                	sub    %edx,%eax
  8015ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8015f0:	e8 46 08 00 00       	call   801e3b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015f5:	83 f8 01             	cmp    $0x1,%eax
  8015f8:	75 07                	jne    801601 <malloc+0x56>
  8015fa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801601:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801605:	75 34                	jne    80163b <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801607:	83 ec 0c             	sub    $0xc,%esp
  80160a:	ff 75 e8             	pushl  -0x18(%ebp)
  80160d:	e8 73 0e 00 00       	call   802485 <alloc_block_FF>
  801612:	83 c4 10             	add    $0x10,%esp
  801615:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801618:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80161c:	74 16                	je     801634 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80161e:	83 ec 0c             	sub    $0xc,%esp
  801621:	ff 75 e4             	pushl  -0x1c(%ebp)
  801624:	e8 ff 0b 00 00       	call   802228 <insert_sorted_allocList>
  801629:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80162c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162f:	8b 40 08             	mov    0x8(%eax),%eax
  801632:	eb 0c                	jmp    801640 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801634:	b8 00 00 00 00       	mov    $0x0,%eax
  801639:	eb 05                	jmp    801640 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80164e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801651:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801657:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80165c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80165f:	83 ec 08             	sub    $0x8,%esp
  801662:	ff 75 f4             	pushl  -0xc(%ebp)
  801665:	68 40 40 80 00       	push   $0x804040
  80166a:	e8 61 0b 00 00       	call   8021d0 <find_block>
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801675:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801679:	0f 84 a5 00 00 00    	je     801724 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  80167f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801682:	8b 40 0c             	mov    0xc(%eax),%eax
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	50                   	push   %eax
  801689:	ff 75 f4             	pushl  -0xc(%ebp)
  80168c:	e8 a4 03 00 00       	call   801a35 <sys_free_user_mem>
  801691:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801694:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801698:	75 17                	jne    8016b1 <free+0x6f>
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	68 f5 39 80 00       	push   $0x8039f5
  8016a2:	68 87 00 00 00       	push   $0x87
  8016a7:	68 13 3a 80 00       	push   $0x803a13
  8016ac:	e8 cd ec ff ff       	call   80037e <_panic>
  8016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b4:	8b 00                	mov    (%eax),%eax
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	74 10                	je     8016ca <free+0x88>
  8016ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bd:	8b 00                	mov    (%eax),%eax
  8016bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016c2:	8b 52 04             	mov    0x4(%edx),%edx
  8016c5:	89 50 04             	mov    %edx,0x4(%eax)
  8016c8:	eb 0b                	jmp    8016d5 <free+0x93>
  8016ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cd:	8b 40 04             	mov    0x4(%eax),%eax
  8016d0:	a3 44 40 80 00       	mov    %eax,0x804044
  8016d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d8:	8b 40 04             	mov    0x4(%eax),%eax
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	74 0f                	je     8016ee <free+0xac>
  8016df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e2:	8b 40 04             	mov    0x4(%eax),%eax
  8016e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8016e8:	8b 12                	mov    (%edx),%edx
  8016ea:	89 10                	mov    %edx,(%eax)
  8016ec:	eb 0a                	jmp    8016f8 <free+0xb6>
  8016ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	a3 40 40 80 00       	mov    %eax,0x804040
  8016f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801704:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80170b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801710:	48                   	dec    %eax
  801711:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	ff 75 ec             	pushl  -0x14(%ebp)
  80171c:	e8 37 12 00 00       	call   802958 <insert_sorted_with_merge_freeList>
  801721:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801724:	90                   	nop
  801725:	c9                   	leave  
  801726:	c3                   	ret    

00801727 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	83 ec 38             	sub    $0x38,%esp
  80172d:	8b 45 10             	mov    0x10(%ebp),%eax
  801730:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801733:	e8 84 fc ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  801738:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80173c:	75 07                	jne    801745 <smalloc+0x1e>
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
  801743:	eb 7e                	jmp    8017c3 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801745:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80174c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801753:	8b 55 0c             	mov    0xc(%ebp),%edx
  801756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801759:	01 d0                	add    %edx,%eax
  80175b:	48                   	dec    %eax
  80175c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80175f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801762:	ba 00 00 00 00       	mov    $0x0,%edx
  801767:	f7 75 f0             	divl   -0x10(%ebp)
  80176a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176d:	29 d0                	sub    %edx,%eax
  80176f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801772:	e8 c4 06 00 00       	call   801e3b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801777:	83 f8 01             	cmp    $0x1,%eax
  80177a:	75 42                	jne    8017be <smalloc+0x97>

		  va = malloc(newsize) ;
  80177c:	83 ec 0c             	sub    $0xc,%esp
  80177f:	ff 75 e8             	pushl  -0x18(%ebp)
  801782:	e8 24 fe ff ff       	call   8015ab <malloc>
  801787:	83 c4 10             	add    $0x10,%esp
  80178a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  80178d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801791:	74 24                	je     8017b7 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801793:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801797:	ff 75 e4             	pushl  -0x1c(%ebp)
  80179a:	50                   	push   %eax
  80179b:	ff 75 e8             	pushl  -0x18(%ebp)
  80179e:	ff 75 08             	pushl  0x8(%ebp)
  8017a1:	e8 1a 04 00 00       	call   801bc0 <sys_createSharedObject>
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8017ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017b0:	78 0c                	js     8017be <smalloc+0x97>
					  return va ;
  8017b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b5:	eb 0c                	jmp    8017c3 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017bc:	eb 05                	jmp    8017c3 <smalloc+0x9c>
	  }
		  return NULL ;
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017cb:	e8 ec fb ff ff       	call   8013bc <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	e8 0c 04 00 00       	call   801bea <sys_getSizeOfSharedObject>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8017e4:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017e8:	75 07                	jne    8017f1 <sget+0x2c>
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ef:	eb 75                	jmp    801866 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8017f1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fe:	01 d0                	add    %edx,%eax
  801800:	48                   	dec    %eax
  801801:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801807:	ba 00 00 00 00       	mov    $0x0,%edx
  80180c:	f7 75 f0             	divl   -0x10(%ebp)
  80180f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801812:	29 d0                	sub    %edx,%eax
  801814:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801817:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80181e:	e8 18 06 00 00       	call   801e3b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801823:	83 f8 01             	cmp    $0x1,%eax
  801826:	75 39                	jne    801861 <sget+0x9c>

		  va = malloc(newsize) ;
  801828:	83 ec 0c             	sub    $0xc,%esp
  80182b:	ff 75 e8             	pushl  -0x18(%ebp)
  80182e:	e8 78 fd ff ff       	call   8015ab <malloc>
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801839:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80183d:	74 22                	je     801861 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80183f:	83 ec 04             	sub    $0x4,%esp
  801842:	ff 75 e0             	pushl  -0x20(%ebp)
  801845:	ff 75 0c             	pushl  0xc(%ebp)
  801848:	ff 75 08             	pushl  0x8(%ebp)
  80184b:	e8 b7 03 00 00       	call   801c07 <sys_getSharedObject>
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801856:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80185a:	78 05                	js     801861 <sget+0x9c>
					  return va;
  80185c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80185f:	eb 05                	jmp    801866 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801861:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80186e:	e8 49 fb ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	68 44 3a 80 00       	push   $0x803a44
  80187b:	68 1e 01 00 00       	push   $0x11e
  801880:	68 13 3a 80 00       	push   $0x803a13
  801885:	e8 f4 ea ff ff       	call   80037e <_panic>

0080188a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	68 6c 3a 80 00       	push   $0x803a6c
  801898:	68 32 01 00 00       	push   $0x132
  80189d:	68 13 3a 80 00       	push   $0x803a13
  8018a2:	e8 d7 ea ff ff       	call   80037e <_panic>

008018a7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ad:	83 ec 04             	sub    $0x4,%esp
  8018b0:	68 90 3a 80 00       	push   $0x803a90
  8018b5:	68 3d 01 00 00       	push   $0x13d
  8018ba:	68 13 3a 80 00       	push   $0x803a13
  8018bf:	e8 ba ea ff ff       	call   80037e <_panic>

008018c4 <shrink>:

}
void shrink(uint32 newSize)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ca:	83 ec 04             	sub    $0x4,%esp
  8018cd:	68 90 3a 80 00       	push   $0x803a90
  8018d2:	68 42 01 00 00       	push   $0x142
  8018d7:	68 13 3a 80 00       	push   $0x803a13
  8018dc:	e8 9d ea ff ff       	call   80037e <_panic>

008018e1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e7:	83 ec 04             	sub    $0x4,%esp
  8018ea:	68 90 3a 80 00       	push   $0x803a90
  8018ef:	68 47 01 00 00       	push   $0x147
  8018f4:	68 13 3a 80 00       	push   $0x803a13
  8018f9:	e8 80 ea ff ff       	call   80037e <_panic>

008018fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	57                   	push   %edi
  801902:	56                   	push   %esi
  801903:	53                   	push   %ebx
  801904:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801910:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801913:	8b 7d 18             	mov    0x18(%ebp),%edi
  801916:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801919:	cd 30                	int    $0x30
  80191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80191e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801921:	83 c4 10             	add    $0x10,%esp
  801924:	5b                   	pop    %ebx
  801925:	5e                   	pop    %esi
  801926:	5f                   	pop    %edi
  801927:	5d                   	pop    %ebp
  801928:	c3                   	ret    

00801929 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 04             	sub    $0x4,%esp
  80192f:	8b 45 10             	mov    0x10(%ebp),%eax
  801932:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801935:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	52                   	push   %edx
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	50                   	push   %eax
  801945:	6a 00                	push   $0x0
  801947:	e8 b2 ff ff ff       	call   8018fe <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	90                   	nop
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_cgetc>:

int
sys_cgetc(void)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 01                	push   $0x1
  801961:	e8 98 ff ff ff       	call   8018fe <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80196e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	52                   	push   %edx
  80197b:	50                   	push   %eax
  80197c:	6a 05                	push   $0x5
  80197e:	e8 7b ff ff ff       	call   8018fe <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	56                   	push   %esi
  80198c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80198d:	8b 75 18             	mov    0x18(%ebp),%esi
  801990:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801993:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801996:	8b 55 0c             	mov    0xc(%ebp),%edx
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	56                   	push   %esi
  80199d:	53                   	push   %ebx
  80199e:	51                   	push   %ecx
  80199f:	52                   	push   %edx
  8019a0:	50                   	push   %eax
  8019a1:	6a 06                	push   $0x6
  8019a3:	e8 56 ff ff ff       	call   8018fe <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ae:	5b                   	pop    %ebx
  8019af:	5e                   	pop    %esi
  8019b0:	5d                   	pop    %ebp
  8019b1:	c3                   	ret    

008019b2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	52                   	push   %edx
  8019c2:	50                   	push   %eax
  8019c3:	6a 07                	push   $0x7
  8019c5:	e8 34 ff ff ff       	call   8018fe <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	ff 75 08             	pushl  0x8(%ebp)
  8019de:	6a 08                	push   $0x8
  8019e0:	e8 19 ff ff ff       	call   8018fe <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 09                	push   $0x9
  8019f9:	e8 00 ff ff ff       	call   8018fe <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 0a                	push   $0xa
  801a12:	e8 e7 fe ff ff       	call   8018fe <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 0b                	push   $0xb
  801a2b:	e8 ce fe ff ff       	call   8018fe <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	ff 75 0c             	pushl  0xc(%ebp)
  801a41:	ff 75 08             	pushl  0x8(%ebp)
  801a44:	6a 0f                	push   $0xf
  801a46:	e8 b3 fe ff ff       	call   8018fe <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
	return;
  801a4e:	90                   	nop
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	ff 75 08             	pushl  0x8(%ebp)
  801a60:	6a 10                	push   $0x10
  801a62:	e8 97 fe ff ff       	call   8018fe <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6a:	90                   	nop
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	ff 75 10             	pushl  0x10(%ebp)
  801a77:	ff 75 0c             	pushl  0xc(%ebp)
  801a7a:	ff 75 08             	pushl  0x8(%ebp)
  801a7d:	6a 11                	push   $0x11
  801a7f:	e8 7a fe ff ff       	call   8018fe <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
	return ;
  801a87:	90                   	nop
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 0c                	push   $0xc
  801a99:	e8 60 fe ff ff       	call   8018fe <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	ff 75 08             	pushl  0x8(%ebp)
  801ab1:	6a 0d                	push   $0xd
  801ab3:	e8 46 fe ff ff       	call   8018fe <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_scarce_memory>:

void sys_scarce_memory()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 0e                	push   $0xe
  801acc:	e8 2d fe ff ff       	call   8018fe <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	90                   	nop
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 13                	push   $0x13
  801ae6:	e8 13 fe ff ff       	call   8018fe <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	90                   	nop
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 14                	push   $0x14
  801b00:	e8 f9 fd ff ff       	call   8018fe <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	90                   	nop
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_cputc>:


void
sys_cputc(const char c)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 04             	sub    $0x4,%esp
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b17:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	50                   	push   %eax
  801b24:	6a 15                	push   $0x15
  801b26:	e8 d3 fd ff ff       	call   8018fe <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 16                	push   $0x16
  801b40:	e8 b9 fd ff ff       	call   8018fe <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	90                   	nop
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	50                   	push   %eax
  801b5b:	6a 17                	push   $0x17
  801b5d:	e8 9c fd ff ff       	call   8018fe <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	52                   	push   %edx
  801b77:	50                   	push   %eax
  801b78:	6a 1a                	push   $0x1a
  801b7a:	e8 7f fd ff ff       	call   8018fe <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	6a 18                	push   $0x18
  801b97:	e8 62 fd ff ff       	call   8018fe <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	90                   	nop
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	52                   	push   %edx
  801bb2:	50                   	push   %eax
  801bb3:	6a 19                	push   $0x19
  801bb5:	e8 44 fd ff ff       	call   8018fe <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	90                   	nop
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 04             	sub    $0x4,%esp
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bcc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bcf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	51                   	push   %ecx
  801bd9:	52                   	push   %edx
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	50                   	push   %eax
  801bde:	6a 1b                	push   $0x1b
  801be0:	e8 19 fd ff ff       	call   8018fe <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	6a 1c                	push   $0x1c
  801bfd:	e8 fc fc ff ff       	call   8018fe <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	51                   	push   %ecx
  801c18:	52                   	push   %edx
  801c19:	50                   	push   %eax
  801c1a:	6a 1d                	push   $0x1d
  801c1c:	e8 dd fc ff ff       	call   8018fe <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	52                   	push   %edx
  801c36:	50                   	push   %eax
  801c37:	6a 1e                	push   $0x1e
  801c39:	e8 c0 fc ff ff       	call   8018fe <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 1f                	push   $0x1f
  801c52:	e8 a7 fc ff ff       	call   8018fe <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	6a 00                	push   $0x0
  801c64:	ff 75 14             	pushl  0x14(%ebp)
  801c67:	ff 75 10             	pushl  0x10(%ebp)
  801c6a:	ff 75 0c             	pushl  0xc(%ebp)
  801c6d:	50                   	push   %eax
  801c6e:	6a 20                	push   $0x20
  801c70:	e8 89 fc ff ff       	call   8018fe <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	50                   	push   %eax
  801c89:	6a 21                	push   $0x21
  801c8b:	e8 6e fc ff ff       	call   8018fe <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	90                   	nop
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	50                   	push   %eax
  801ca5:	6a 22                	push   $0x22
  801ca7:	e8 52 fc ff ff       	call   8018fe <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 02                	push   $0x2
  801cc0:	e8 39 fc ff ff       	call   8018fe <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 03                	push   $0x3
  801cd9:	e8 20 fc ff ff       	call   8018fe <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 04                	push   $0x4
  801cf2:	e8 07 fc ff ff       	call   8018fe <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_exit_env>:


void sys_exit_env(void)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 23                	push   $0x23
  801d0b:	e8 ee fb ff ff       	call   8018fe <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	90                   	nop
  801d14:	c9                   	leave  
  801d15:	c3                   	ret    

00801d16 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d1f:	8d 50 04             	lea    0x4(%eax),%edx
  801d22:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	52                   	push   %edx
  801d2c:	50                   	push   %eax
  801d2d:	6a 24                	push   $0x24
  801d2f:	e8 ca fb ff ff       	call   8018fe <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
	return result;
  801d37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d40:	89 01                	mov    %eax,(%ecx)
  801d42:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	c9                   	leave  
  801d49:	c2 04 00             	ret    $0x4

00801d4c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	ff 75 10             	pushl  0x10(%ebp)
  801d56:	ff 75 0c             	pushl  0xc(%ebp)
  801d59:	ff 75 08             	pushl  0x8(%ebp)
  801d5c:	6a 12                	push   $0x12
  801d5e:	e8 9b fb ff ff       	call   8018fe <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
	return ;
  801d66:	90                   	nop
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 25                	push   $0x25
  801d78:	e8 81 fb ff ff       	call   8018fe <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 04             	sub    $0x4,%esp
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d8e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	50                   	push   %eax
  801d9b:	6a 26                	push   $0x26
  801d9d:	e8 5c fb ff ff       	call   8018fe <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
	return ;
  801da5:	90                   	nop
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <rsttst>:
void rsttst()
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 28                	push   $0x28
  801db7:	e8 42 fb ff ff       	call   8018fe <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbf:	90                   	nop
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 04             	sub    $0x4,%esp
  801dc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dce:	8b 55 18             	mov    0x18(%ebp),%edx
  801dd1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd5:	52                   	push   %edx
  801dd6:	50                   	push   %eax
  801dd7:	ff 75 10             	pushl  0x10(%ebp)
  801dda:	ff 75 0c             	pushl  0xc(%ebp)
  801ddd:	ff 75 08             	pushl  0x8(%ebp)
  801de0:	6a 27                	push   $0x27
  801de2:	e8 17 fb ff ff       	call   8018fe <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dea:	90                   	nop
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <chktst>:
void chktst(uint32 n)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	ff 75 08             	pushl  0x8(%ebp)
  801dfb:	6a 29                	push   $0x29
  801dfd:	e8 fc fa ff ff       	call   8018fe <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return ;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <inctst>:

void inctst()
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 2a                	push   $0x2a
  801e17:	e8 e2 fa ff ff       	call   8018fe <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1f:	90                   	nop
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <gettst>:
uint32 gettst()
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 2b                	push   $0x2b
  801e31:	e8 c8 fa ff ff       	call   8018fe <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 2c                	push   $0x2c
  801e4d:	e8 ac fa ff ff       	call   8018fe <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
  801e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e58:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e5c:	75 07                	jne    801e65 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e63:	eb 05                	jmp    801e6a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 2c                	push   $0x2c
  801e7e:	e8 7b fa ff ff       	call   8018fe <syscall>
  801e83:	83 c4 18             	add    $0x18,%esp
  801e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e89:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e8d:	75 07                	jne    801e96 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e94:	eb 05                	jmp    801e9b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 2c                	push   $0x2c
  801eaf:	e8 4a fa ff ff       	call   8018fe <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
  801eb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eba:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ebe:	75 07                	jne    801ec7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ec0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec5:	eb 05                	jmp    801ecc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecc:	c9                   	leave  
  801ecd:	c3                   	ret    

00801ece <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 2c                	push   $0x2c
  801ee0:	e8 19 fa ff ff       	call   8018fe <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
  801ee8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eeb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eef:	75 07                	jne    801ef8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ef1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef6:	eb 05                	jmp    801efd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	ff 75 08             	pushl  0x8(%ebp)
  801f0d:	6a 2d                	push   $0x2d
  801f0f:	e8 ea f9 ff ff       	call   8018fe <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
	return ;
  801f17:	90                   	nop
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f1e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	53                   	push   %ebx
  801f2d:	51                   	push   %ecx
  801f2e:	52                   	push   %edx
  801f2f:	50                   	push   %eax
  801f30:	6a 2e                	push   $0x2e
  801f32:	e8 c7 f9 ff ff       	call   8018fe <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	52                   	push   %edx
  801f4f:	50                   	push   %eax
  801f50:	6a 2f                	push   $0x2f
  801f52:	e8 a7 f9 ff ff       	call   8018fe <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f62:	83 ec 0c             	sub    $0xc,%esp
  801f65:	68 a0 3a 80 00       	push   $0x803aa0
  801f6a:	e8 c3 e6 ff ff       	call   800632 <cprintf>
  801f6f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f79:	83 ec 0c             	sub    $0xc,%esp
  801f7c:	68 cc 3a 80 00       	push   $0x803acc
  801f81:	e8 ac e6 ff ff       	call   800632 <cprintf>
  801f86:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f89:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f8d:	a1 38 41 80 00       	mov    0x804138,%eax
  801f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f95:	eb 56                	jmp    801fed <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f9b:	74 1c                	je     801fb9 <print_mem_block_lists+0x5d>
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	8b 50 08             	mov    0x8(%eax),%edx
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	8b 48 08             	mov    0x8(%eax),%ecx
  801fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fac:	8b 40 0c             	mov    0xc(%eax),%eax
  801faf:	01 c8                	add    %ecx,%eax
  801fb1:	39 c2                	cmp    %eax,%edx
  801fb3:	73 04                	jae    801fb9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fb5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	8b 50 08             	mov    0x8(%eax),%edx
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc5:	01 c2                	add    %eax,%edx
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 40 08             	mov    0x8(%eax),%eax
  801fcd:	83 ec 04             	sub    $0x4,%esp
  801fd0:	52                   	push   %edx
  801fd1:	50                   	push   %eax
  801fd2:	68 e1 3a 80 00       	push   $0x803ae1
  801fd7:	e8 56 e6 ff ff       	call   800632 <cprintf>
  801fdc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fe5:	a1 40 41 80 00       	mov    0x804140,%eax
  801fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff1:	74 07                	je     801ffa <print_mem_block_lists+0x9e>
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	8b 00                	mov    (%eax),%eax
  801ff8:	eb 05                	jmp    801fff <print_mem_block_lists+0xa3>
  801ffa:	b8 00 00 00 00       	mov    $0x0,%eax
  801fff:	a3 40 41 80 00       	mov    %eax,0x804140
  802004:	a1 40 41 80 00       	mov    0x804140,%eax
  802009:	85 c0                	test   %eax,%eax
  80200b:	75 8a                	jne    801f97 <print_mem_block_lists+0x3b>
  80200d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802011:	75 84                	jne    801f97 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802013:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802017:	75 10                	jne    802029 <print_mem_block_lists+0xcd>
  802019:	83 ec 0c             	sub    $0xc,%esp
  80201c:	68 f0 3a 80 00       	push   $0x803af0
  802021:	e8 0c e6 ff ff       	call   800632 <cprintf>
  802026:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802029:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802030:	83 ec 0c             	sub    $0xc,%esp
  802033:	68 14 3b 80 00       	push   $0x803b14
  802038:	e8 f5 e5 ff ff       	call   800632 <cprintf>
  80203d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802040:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802044:	a1 40 40 80 00       	mov    0x804040,%eax
  802049:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80204c:	eb 56                	jmp    8020a4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80204e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802052:	74 1c                	je     802070 <print_mem_block_lists+0x114>
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	8b 50 08             	mov    0x8(%eax),%edx
  80205a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205d:	8b 48 08             	mov    0x8(%eax),%ecx
  802060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802063:	8b 40 0c             	mov    0xc(%eax),%eax
  802066:	01 c8                	add    %ecx,%eax
  802068:	39 c2                	cmp    %eax,%edx
  80206a:	73 04                	jae    802070 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80206c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	8b 50 08             	mov    0x8(%eax),%edx
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	8b 40 0c             	mov    0xc(%eax),%eax
  80207c:	01 c2                	add    %eax,%edx
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	8b 40 08             	mov    0x8(%eax),%eax
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	52                   	push   %edx
  802088:	50                   	push   %eax
  802089:	68 e1 3a 80 00       	push   $0x803ae1
  80208e:	e8 9f e5 ff ff       	call   800632 <cprintf>
  802093:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80209c:	a1 48 40 80 00       	mov    0x804048,%eax
  8020a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a8:	74 07                	je     8020b1 <print_mem_block_lists+0x155>
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 00                	mov    (%eax),%eax
  8020af:	eb 05                	jmp    8020b6 <print_mem_block_lists+0x15a>
  8020b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b6:	a3 48 40 80 00       	mov    %eax,0x804048
  8020bb:	a1 48 40 80 00       	mov    0x804048,%eax
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	75 8a                	jne    80204e <print_mem_block_lists+0xf2>
  8020c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c8:	75 84                	jne    80204e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020ca:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ce:	75 10                	jne    8020e0 <print_mem_block_lists+0x184>
  8020d0:	83 ec 0c             	sub    $0xc,%esp
  8020d3:	68 2c 3b 80 00       	push   $0x803b2c
  8020d8:	e8 55 e5 ff ff       	call   800632 <cprintf>
  8020dd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020e0:	83 ec 0c             	sub    $0xc,%esp
  8020e3:	68 a0 3a 80 00       	push   $0x803aa0
  8020e8:	e8 45 e5 ff ff       	call   800632 <cprintf>
  8020ed:	83 c4 10             	add    $0x10,%esp

}
  8020f0:	90                   	nop
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8020f9:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802100:	00 00 00 
  802103:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80210a:	00 00 00 
  80210d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802114:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80211e:	e9 9e 00 00 00       	jmp    8021c1 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802123:	a1 50 40 80 00       	mov    0x804050,%eax
  802128:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212b:	c1 e2 04             	shl    $0x4,%edx
  80212e:	01 d0                	add    %edx,%eax
  802130:	85 c0                	test   %eax,%eax
  802132:	75 14                	jne    802148 <initialize_MemBlocksList+0x55>
  802134:	83 ec 04             	sub    $0x4,%esp
  802137:	68 54 3b 80 00       	push   $0x803b54
  80213c:	6a 47                	push   $0x47
  80213e:	68 77 3b 80 00       	push   $0x803b77
  802143:	e8 36 e2 ff ff       	call   80037e <_panic>
  802148:	a1 50 40 80 00       	mov    0x804050,%eax
  80214d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802150:	c1 e2 04             	shl    $0x4,%edx
  802153:	01 d0                	add    %edx,%eax
  802155:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80215b:	89 10                	mov    %edx,(%eax)
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	85 c0                	test   %eax,%eax
  802161:	74 18                	je     80217b <initialize_MemBlocksList+0x88>
  802163:	a1 48 41 80 00       	mov    0x804148,%eax
  802168:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80216e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802171:	c1 e1 04             	shl    $0x4,%ecx
  802174:	01 ca                	add    %ecx,%edx
  802176:	89 50 04             	mov    %edx,0x4(%eax)
  802179:	eb 12                	jmp    80218d <initialize_MemBlocksList+0x9a>
  80217b:	a1 50 40 80 00       	mov    0x804050,%eax
  802180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802183:	c1 e2 04             	shl    $0x4,%edx
  802186:	01 d0                	add    %edx,%eax
  802188:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80218d:	a1 50 40 80 00       	mov    0x804050,%eax
  802192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802195:	c1 e2 04             	shl    $0x4,%edx
  802198:	01 d0                	add    %edx,%eax
  80219a:	a3 48 41 80 00       	mov    %eax,0x804148
  80219f:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a7:	c1 e2 04             	shl    $0x4,%edx
  8021aa:	01 d0                	add    %edx,%eax
  8021ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b3:	a1 54 41 80 00       	mov    0x804154,%eax
  8021b8:	40                   	inc    %eax
  8021b9:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8021be:	ff 45 f4             	incl   -0xc(%ebp)
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c7:	0f 82 56 ff ff ff    	jb     802123 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8021cd:	90                   	nop
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	8b 00                	mov    (%eax),%eax
  8021db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021de:	eb 19                	jmp    8021f9 <find_block+0x29>
	{
		if(element->sva == va){
  8021e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e3:	8b 40 08             	mov    0x8(%eax),%eax
  8021e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021e9:	75 05                	jne    8021f0 <find_block+0x20>
			 		return element;
  8021eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ee:	eb 36                	jmp    802226 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8b 40 08             	mov    0x8(%eax),%eax
  8021f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021fd:	74 07                	je     802206 <find_block+0x36>
  8021ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802202:	8b 00                	mov    (%eax),%eax
  802204:	eb 05                	jmp    80220b <find_block+0x3b>
  802206:	b8 00 00 00 00       	mov    $0x0,%eax
  80220b:	8b 55 08             	mov    0x8(%ebp),%edx
  80220e:	89 42 08             	mov    %eax,0x8(%edx)
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	8b 40 08             	mov    0x8(%eax),%eax
  802217:	85 c0                	test   %eax,%eax
  802219:	75 c5                	jne    8021e0 <find_block+0x10>
  80221b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80221f:	75 bf                	jne    8021e0 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
  80222b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80222e:	a1 44 40 80 00       	mov    0x804044,%eax
  802233:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802236:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80223b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80223e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802242:	74 0a                	je     80224e <insert_sorted_allocList+0x26>
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	8b 40 08             	mov    0x8(%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	75 65                	jne    8022b3 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80224e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802252:	75 14                	jne    802268 <insert_sorted_allocList+0x40>
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 54 3b 80 00       	push   $0x803b54
  80225c:	6a 6e                	push   $0x6e
  80225e:	68 77 3b 80 00       	push   $0x803b77
  802263:	e8 16 e1 ff ff       	call   80037e <_panic>
  802268:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	89 10                	mov    %edx,(%eax)
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	85 c0                	test   %eax,%eax
  80227a:	74 0d                	je     802289 <insert_sorted_allocList+0x61>
  80227c:	a1 40 40 80 00       	mov    0x804040,%eax
  802281:	8b 55 08             	mov    0x8(%ebp),%edx
  802284:	89 50 04             	mov    %edx,0x4(%eax)
  802287:	eb 08                	jmp    802291 <insert_sorted_allocList+0x69>
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	a3 44 40 80 00       	mov    %eax,0x804044
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	a3 40 40 80 00       	mov    %eax,0x804040
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a8:	40                   	inc    %eax
  8022a9:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8022ae:	e9 cf 01 00 00       	jmp    802482 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8022b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b6:	8b 50 08             	mov    0x8(%eax),%edx
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	8b 40 08             	mov    0x8(%eax),%eax
  8022bf:	39 c2                	cmp    %eax,%edx
  8022c1:	73 65                	jae    802328 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c7:	75 14                	jne    8022dd <insert_sorted_allocList+0xb5>
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	68 90 3b 80 00       	push   $0x803b90
  8022d1:	6a 72                	push   $0x72
  8022d3:	68 77 3b 80 00       	push   $0x803b77
  8022d8:	e8 a1 e0 ff ff       	call   80037e <_panic>
  8022dd:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 50 04             	mov    %edx,0x4(%eax)
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	8b 40 04             	mov    0x4(%eax),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	74 0c                	je     8022ff <insert_sorted_allocList+0xd7>
  8022f3:	a1 44 40 80 00       	mov    0x804044,%eax
  8022f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fb:	89 10                	mov    %edx,(%eax)
  8022fd:	eb 08                	jmp    802307 <insert_sorted_allocList+0xdf>
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	a3 40 40 80 00       	mov    %eax,0x804040
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	a3 44 40 80 00       	mov    %eax,0x804044
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802318:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231d:	40                   	inc    %eax
  80231e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802323:	e9 5a 01 00 00       	jmp    802482 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232b:	8b 50 08             	mov    0x8(%eax),%edx
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	8b 40 08             	mov    0x8(%eax),%eax
  802334:	39 c2                	cmp    %eax,%edx
  802336:	75 70                	jne    8023a8 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802338:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80233c:	74 06                	je     802344 <insert_sorted_allocList+0x11c>
  80233e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802342:	75 14                	jne    802358 <insert_sorted_allocList+0x130>
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 b4 3b 80 00       	push   $0x803bb4
  80234c:	6a 75                	push   $0x75
  80234e:	68 77 3b 80 00       	push   $0x803b77
  802353:	e8 26 e0 ff ff       	call   80037e <_panic>
  802358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235b:	8b 10                	mov    (%eax),%edx
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	89 10                	mov    %edx,(%eax)
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	74 0b                	je     802376 <insert_sorted_allocList+0x14e>
  80236b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236e:	8b 00                	mov    (%eax),%eax
  802370:	8b 55 08             	mov    0x8(%ebp),%edx
  802373:	89 50 04             	mov    %edx,0x4(%eax)
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	8b 55 08             	mov    0x8(%ebp),%edx
  80237c:	89 10                	mov    %edx,(%eax)
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802384:	89 50 04             	mov    %edx,0x4(%eax)
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	8b 00                	mov    (%eax),%eax
  80238c:	85 c0                	test   %eax,%eax
  80238e:	75 08                	jne    802398 <insert_sorted_allocList+0x170>
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	a3 44 40 80 00       	mov    %eax,0x804044
  802398:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80239d:	40                   	inc    %eax
  80239e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8023a3:	e9 da 00 00 00       	jmp    802482 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8023a8:	a1 40 40 80 00       	mov    0x804040,%eax
  8023ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b0:	e9 9d 00 00 00       	jmp    802452 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 00                	mov    (%eax),%eax
  8023ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	8b 50 08             	mov    0x8(%eax),%edx
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 40 08             	mov    0x8(%eax),%eax
  8023c9:	39 c2                	cmp    %eax,%edx
  8023cb:	76 7d                	jbe    80244a <insert_sorted_allocList+0x222>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8b 50 08             	mov    0x8(%eax),%edx
  8023d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d6:	8b 40 08             	mov    0x8(%eax),%eax
  8023d9:	39 c2                	cmp    %eax,%edx
  8023db:	73 6d                	jae    80244a <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8023dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e1:	74 06                	je     8023e9 <insert_sorted_allocList+0x1c1>
  8023e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e7:	75 14                	jne    8023fd <insert_sorted_allocList+0x1d5>
  8023e9:	83 ec 04             	sub    $0x4,%esp
  8023ec:	68 b4 3b 80 00       	push   $0x803bb4
  8023f1:	6a 7c                	push   $0x7c
  8023f3:	68 77 3b 80 00       	push   $0x803b77
  8023f8:	e8 81 df ff ff       	call   80037e <_panic>
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 10                	mov    (%eax),%edx
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	89 10                	mov    %edx,(%eax)
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	74 0b                	je     80241b <insert_sorted_allocList+0x1f3>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 00                	mov    (%eax),%eax
  802415:	8b 55 08             	mov    0x8(%ebp),%edx
  802418:	89 50 04             	mov    %edx,0x4(%eax)
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 55 08             	mov    0x8(%ebp),%edx
  802421:	89 10                	mov    %edx,(%eax)
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802429:	89 50 04             	mov    %edx,0x4(%eax)
  80242c:	8b 45 08             	mov    0x8(%ebp),%eax
  80242f:	8b 00                	mov    (%eax),%eax
  802431:	85 c0                	test   %eax,%eax
  802433:	75 08                	jne    80243d <insert_sorted_allocList+0x215>
  802435:	8b 45 08             	mov    0x8(%ebp),%eax
  802438:	a3 44 40 80 00       	mov    %eax,0x804044
  80243d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802442:	40                   	inc    %eax
  802443:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802448:	eb 38                	jmp    802482 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80244a:	a1 48 40 80 00       	mov    0x804048,%eax
  80244f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802456:	74 07                	je     80245f <insert_sorted_allocList+0x237>
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 00                	mov    (%eax),%eax
  80245d:	eb 05                	jmp    802464 <insert_sorted_allocList+0x23c>
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
  802464:	a3 48 40 80 00       	mov    %eax,0x804048
  802469:	a1 48 40 80 00       	mov    0x804048,%eax
  80246e:	85 c0                	test   %eax,%eax
  802470:	0f 85 3f ff ff ff    	jne    8023b5 <insert_sorted_allocList+0x18d>
  802476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247a:	0f 85 35 ff ff ff    	jne    8023b5 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802480:	eb 00                	jmp    802482 <insert_sorted_allocList+0x25a>
  802482:	90                   	nop
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80248b:	a1 38 41 80 00       	mov    0x804138,%eax
  802490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802493:	e9 6b 02 00 00       	jmp    802703 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 40 0c             	mov    0xc(%eax),%eax
  80249e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a1:	0f 85 90 00 00 00    	jne    802537 <alloc_block_FF+0xb2>
			  temp=element;
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8024ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b1:	75 17                	jne    8024ca <alloc_block_FF+0x45>
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	68 e8 3b 80 00       	push   $0x803be8
  8024bb:	68 92 00 00 00       	push   $0x92
  8024c0:	68 77 3b 80 00       	push   $0x803b77
  8024c5:	e8 b4 de ff ff       	call   80037e <_panic>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	85 c0                	test   %eax,%eax
  8024d1:	74 10                	je     8024e3 <alloc_block_FF+0x5e>
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024db:	8b 52 04             	mov    0x4(%edx),%edx
  8024de:	89 50 04             	mov    %edx,0x4(%eax)
  8024e1:	eb 0b                	jmp    8024ee <alloc_block_FF+0x69>
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 04             	mov    0x4(%eax),%eax
  8024e9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 04             	mov    0x4(%eax),%eax
  8024f4:	85 c0                	test   %eax,%eax
  8024f6:	74 0f                	je     802507 <alloc_block_FF+0x82>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802501:	8b 12                	mov    (%edx),%edx
  802503:	89 10                	mov    %edx,(%eax)
  802505:	eb 0a                	jmp    802511 <alloc_block_FF+0x8c>
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 00                	mov    (%eax),%eax
  80250c:	a3 38 41 80 00       	mov    %eax,0x804138
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802524:	a1 44 41 80 00       	mov    0x804144,%eax
  802529:	48                   	dec    %eax
  80252a:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80252f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802532:	e9 ff 01 00 00       	jmp    802736 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 0c             	mov    0xc(%eax),%eax
  80253d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802540:	0f 86 b5 01 00 00    	jbe    8026fb <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 0c             	mov    0xc(%eax),%eax
  80254c:	2b 45 08             	sub    0x8(%ebp),%eax
  80254f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802552:	a1 48 41 80 00       	mov    0x804148,%eax
  802557:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80255a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80255e:	75 17                	jne    802577 <alloc_block_FF+0xf2>
  802560:	83 ec 04             	sub    $0x4,%esp
  802563:	68 e8 3b 80 00       	push   $0x803be8
  802568:	68 99 00 00 00       	push   $0x99
  80256d:	68 77 3b 80 00       	push   $0x803b77
  802572:	e8 07 de ff ff       	call   80037e <_panic>
  802577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 10                	je     802590 <alloc_block_FF+0x10b>
  802580:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802588:	8b 52 04             	mov    0x4(%edx),%edx
  80258b:	89 50 04             	mov    %edx,0x4(%eax)
  80258e:	eb 0b                	jmp    80259b <alloc_block_FF+0x116>
  802590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80259b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	74 0f                	je     8025b4 <alloc_block_FF+0x12f>
  8025a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a8:	8b 40 04             	mov    0x4(%eax),%eax
  8025ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025ae:	8b 12                	mov    (%edx),%edx
  8025b0:	89 10                	mov    %edx,(%eax)
  8025b2:	eb 0a                	jmp    8025be <alloc_block_FF+0x139>
  8025b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b7:	8b 00                	mov    (%eax),%eax
  8025b9:	a3 48 41 80 00       	mov    %eax,0x804148
  8025be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d1:	a1 54 41 80 00       	mov    0x804154,%eax
  8025d6:	48                   	dec    %eax
  8025d7:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8025dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025e0:	75 17                	jne    8025f9 <alloc_block_FF+0x174>
  8025e2:	83 ec 04             	sub    $0x4,%esp
  8025e5:	68 90 3b 80 00       	push   $0x803b90
  8025ea:	68 9a 00 00 00       	push   $0x9a
  8025ef:	68 77 3b 80 00       	push   $0x803b77
  8025f4:	e8 85 dd ff ff       	call   80037e <_panic>
  8025f9:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8025ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802602:	89 50 04             	mov    %edx,0x4(%eax)
  802605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802608:	8b 40 04             	mov    0x4(%eax),%eax
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 0c                	je     80261b <alloc_block_FF+0x196>
  80260f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802614:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802617:	89 10                	mov    %edx,(%eax)
  802619:	eb 08                	jmp    802623 <alloc_block_FF+0x19e>
  80261b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261e:	a3 38 41 80 00       	mov    %eax,0x804138
  802623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802626:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80262b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802634:	a1 44 41 80 00       	mov    0x804144,%eax
  802639:	40                   	inc    %eax
  80263a:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  80263f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802642:	8b 55 08             	mov    0x8(%ebp),%edx
  802645:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 50 08             	mov    0x8(%eax),%edx
  80264e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802651:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80265a:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 50 08             	mov    0x8(%eax),%edx
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	01 c2                	add    %eax,%edx
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  80266e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802671:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802674:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802678:	75 17                	jne    802691 <alloc_block_FF+0x20c>
  80267a:	83 ec 04             	sub    $0x4,%esp
  80267d:	68 e8 3b 80 00       	push   $0x803be8
  802682:	68 a2 00 00 00       	push   $0xa2
  802687:	68 77 3b 80 00       	push   $0x803b77
  80268c:	e8 ed dc ff ff       	call   80037e <_panic>
  802691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802694:	8b 00                	mov    (%eax),%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	74 10                	je     8026aa <alloc_block_FF+0x225>
  80269a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269d:	8b 00                	mov    (%eax),%eax
  80269f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a2:	8b 52 04             	mov    0x4(%edx),%edx
  8026a5:	89 50 04             	mov    %edx,0x4(%eax)
  8026a8:	eb 0b                	jmp    8026b5 <alloc_block_FF+0x230>
  8026aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b8:	8b 40 04             	mov    0x4(%eax),%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	74 0f                	je     8026ce <alloc_block_FF+0x249>
  8026bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c2:	8b 40 04             	mov    0x4(%eax),%eax
  8026c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026c8:	8b 12                	mov    (%edx),%edx
  8026ca:	89 10                	mov    %edx,(%eax)
  8026cc:	eb 0a                	jmp    8026d8 <alloc_block_FF+0x253>
  8026ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	a3 38 41 80 00       	mov    %eax,0x804138
  8026d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026eb:	a1 44 41 80 00       	mov    0x804144,%eax
  8026f0:	48                   	dec    %eax
  8026f1:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  8026f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f9:	eb 3b                	jmp    802736 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8026fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802700:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802707:	74 07                	je     802710 <alloc_block_FF+0x28b>
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	eb 05                	jmp    802715 <alloc_block_FF+0x290>
  802710:	b8 00 00 00 00       	mov    $0x0,%eax
  802715:	a3 40 41 80 00       	mov    %eax,0x804140
  80271a:	a1 40 41 80 00       	mov    0x804140,%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	0f 85 71 fd ff ff    	jne    802498 <alloc_block_FF+0x13>
  802727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272b:	0f 85 67 fd ff ff    	jne    802498 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
  80273b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80273e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802745:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80274c:	a1 38 41 80 00       	mov    0x804138,%eax
  802751:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802754:	e9 d3 00 00 00       	jmp    80282c <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802759:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275c:	8b 40 0c             	mov    0xc(%eax),%eax
  80275f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802762:	0f 85 90 00 00 00    	jne    8027f8 <alloc_block_BF+0xc0>
	   temp = element;
  802768:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80276e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802772:	75 17                	jne    80278b <alloc_block_BF+0x53>
  802774:	83 ec 04             	sub    $0x4,%esp
  802777:	68 e8 3b 80 00       	push   $0x803be8
  80277c:	68 bd 00 00 00       	push   $0xbd
  802781:	68 77 3b 80 00       	push   $0x803b77
  802786:	e8 f3 db ff ff       	call   80037e <_panic>
  80278b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	74 10                	je     8027a4 <alloc_block_BF+0x6c>
  802794:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80279c:	8b 52 04             	mov    0x4(%edx),%edx
  80279f:	89 50 04             	mov    %edx,0x4(%eax)
  8027a2:	eb 0b                	jmp    8027af <alloc_block_BF+0x77>
  8027a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a7:	8b 40 04             	mov    0x4(%eax),%eax
  8027aa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b2:	8b 40 04             	mov    0x4(%eax),%eax
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	74 0f                	je     8027c8 <alloc_block_BF+0x90>
  8027b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027bc:	8b 40 04             	mov    0x4(%eax),%eax
  8027bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027c2:	8b 12                	mov    (%edx),%edx
  8027c4:	89 10                	mov    %edx,(%eax)
  8027c6:	eb 0a                	jmp    8027d2 <alloc_block_BF+0x9a>
  8027c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	a3 38 41 80 00       	mov    %eax,0x804138
  8027d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e5:	a1 44 41 80 00       	mov    0x804144,%eax
  8027ea:	48                   	dec    %eax
  8027eb:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  8027f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027f3:	e9 41 01 00 00       	jmp    802939 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8027f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802801:	76 21                	jbe    802824 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802806:	8b 40 0c             	mov    0xc(%eax),%eax
  802809:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80280c:	73 16                	jae    802824 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  80280e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802811:	8b 40 0c             	mov    0xc(%eax),%eax
  802814:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802817:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80281a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80281d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802824:	a1 40 41 80 00       	mov    0x804140,%eax
  802829:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80282c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802830:	74 07                	je     802839 <alloc_block_BF+0x101>
  802832:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802835:	8b 00                	mov    (%eax),%eax
  802837:	eb 05                	jmp    80283e <alloc_block_BF+0x106>
  802839:	b8 00 00 00 00       	mov    $0x0,%eax
  80283e:	a3 40 41 80 00       	mov    %eax,0x804140
  802843:	a1 40 41 80 00       	mov    0x804140,%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	0f 85 09 ff ff ff    	jne    802759 <alloc_block_BF+0x21>
  802850:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802854:	0f 85 ff fe ff ff    	jne    802759 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  80285a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80285e:	0f 85 d0 00 00 00    	jne    802934 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802867:	8b 40 0c             	mov    0xc(%eax),%eax
  80286a:	2b 45 08             	sub    0x8(%ebp),%eax
  80286d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802870:	a1 48 41 80 00       	mov    0x804148,%eax
  802875:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802878:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80287c:	75 17                	jne    802895 <alloc_block_BF+0x15d>
  80287e:	83 ec 04             	sub    $0x4,%esp
  802881:	68 e8 3b 80 00       	push   $0x803be8
  802886:	68 d1 00 00 00       	push   $0xd1
  80288b:	68 77 3b 80 00       	push   $0x803b77
  802890:	e8 e9 da ff ff       	call   80037e <_panic>
  802895:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	74 10                	je     8028ae <alloc_block_BF+0x176>
  80289e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028a6:	8b 52 04             	mov    0x4(%edx),%edx
  8028a9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ac:	eb 0b                	jmp    8028b9 <alloc_block_BF+0x181>
  8028ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b1:	8b 40 04             	mov    0x4(%eax),%eax
  8028b4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028bc:	8b 40 04             	mov    0x4(%eax),%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	74 0f                	je     8028d2 <alloc_block_BF+0x19a>
  8028c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c6:	8b 40 04             	mov    0x4(%eax),%eax
  8028c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028cc:	8b 12                	mov    (%edx),%edx
  8028ce:	89 10                	mov    %edx,(%eax)
  8028d0:	eb 0a                	jmp    8028dc <alloc_block_BF+0x1a4>
  8028d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	a3 48 41 80 00       	mov    %eax,0x804148
  8028dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ef:	a1 54 41 80 00       	mov    0x804154,%eax
  8028f4:	48                   	dec    %eax
  8028f5:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  8028fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802900:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802906:	8b 50 08             	mov    0x8(%eax),%edx
  802909:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290c:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  80290f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802912:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802915:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291b:	8b 50 08             	mov    0x8(%eax),%edx
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	01 c2                	add    %eax,%edx
  802923:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802926:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  80292f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802932:	eb 05                	jmp    802939 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802934:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802939:	c9                   	leave  
  80293a:	c3                   	ret    

0080293b <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80293b:	55                   	push   %ebp
  80293c:	89 e5                	mov    %esp,%ebp
  80293e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802941:	83 ec 04             	sub    $0x4,%esp
  802944:	68 08 3c 80 00       	push   $0x803c08
  802949:	68 e8 00 00 00       	push   $0xe8
  80294e:	68 77 3b 80 00       	push   $0x803b77
  802953:	e8 26 da ff ff       	call   80037e <_panic>

00802958 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802958:	55                   	push   %ebp
  802959:	89 e5                	mov    %esp,%ebp
  80295b:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  80295e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802963:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802966:	a1 38 41 80 00       	mov    0x804138,%eax
  80296b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  80296e:	a1 44 41 80 00       	mov    0x804144,%eax
  802973:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802976:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80297a:	75 68                	jne    8029e4 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80297c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802980:	75 17                	jne    802999 <insert_sorted_with_merge_freeList+0x41>
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	68 54 3b 80 00       	push   $0x803b54
  80298a:	68 36 01 00 00       	push   $0x136
  80298f:	68 77 3b 80 00       	push   $0x803b77
  802994:	e8 e5 d9 ff ff       	call   80037e <_panic>
  802999:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	89 10                	mov    %edx,(%eax)
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	8b 00                	mov    (%eax),%eax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	74 0d                	je     8029ba <insert_sorted_with_merge_freeList+0x62>
  8029ad:	a1 38 41 80 00       	mov    0x804138,%eax
  8029b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b5:	89 50 04             	mov    %edx,0x4(%eax)
  8029b8:	eb 08                	jmp    8029c2 <insert_sorted_with_merge_freeList+0x6a>
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d4:	a1 44 41 80 00       	mov    0x804144,%eax
  8029d9:	40                   	inc    %eax
  8029da:	a3 44 41 80 00       	mov    %eax,0x804144





}
  8029df:	e9 ba 06 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	01 c2                	add    %eax,%edx
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	8b 40 08             	mov    0x8(%eax),%eax
  8029f8:	39 c2                	cmp    %eax,%edx
  8029fa:	73 68                	jae    802a64 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8029fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a00:	75 17                	jne    802a19 <insert_sorted_with_merge_freeList+0xc1>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 90 3b 80 00       	push   $0x803b90
  802a0a:	68 3a 01 00 00       	push   $0x13a
  802a0f:	68 77 3b 80 00       	push   $0x803b77
  802a14:	e8 65 d9 ff ff       	call   80037e <_panic>
  802a19:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	8b 45 08             	mov    0x8(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	74 0c                	je     802a3b <insert_sorted_with_merge_freeList+0xe3>
  802a2f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a34:	8b 55 08             	mov    0x8(%ebp),%edx
  802a37:	89 10                	mov    %edx,(%eax)
  802a39:	eb 08                	jmp    802a43 <insert_sorted_with_merge_freeList+0xeb>
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a54:	a1 44 41 80 00       	mov    0x804144,%eax
  802a59:	40                   	inc    %eax
  802a5a:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a5f:	e9 3a 06 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a67:	8b 50 08             	mov    0x8(%eax),%edx
  802a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a70:	01 c2                	add    %eax,%edx
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	8b 40 08             	mov    0x8(%eax),%eax
  802a78:	39 c2                	cmp    %eax,%edx
  802a7a:	0f 85 90 00 00 00    	jne    802b10 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a83:	8b 50 0c             	mov    0xc(%eax),%edx
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8c:	01 c2                	add    %eax,%edx
  802a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a91:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802aa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aac:	75 17                	jne    802ac5 <insert_sorted_with_merge_freeList+0x16d>
  802aae:	83 ec 04             	sub    $0x4,%esp
  802ab1:	68 54 3b 80 00       	push   $0x803b54
  802ab6:	68 41 01 00 00       	push   $0x141
  802abb:	68 77 3b 80 00       	push   $0x803b77
  802ac0:	e8 b9 d8 ff ff       	call   80037e <_panic>
  802ac5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	89 10                	mov    %edx,(%eax)
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	8b 00                	mov    (%eax),%eax
  802ad5:	85 c0                	test   %eax,%eax
  802ad7:	74 0d                	je     802ae6 <insert_sorted_with_merge_freeList+0x18e>
  802ad9:	a1 48 41 80 00       	mov    0x804148,%eax
  802ade:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae1:	89 50 04             	mov    %edx,0x4(%eax)
  802ae4:	eb 08                	jmp    802aee <insert_sorted_with_merge_freeList+0x196>
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aee:	8b 45 08             	mov    0x8(%ebp),%eax
  802af1:	a3 48 41 80 00       	mov    %eax,0x804148
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b00:	a1 54 41 80 00       	mov    0x804154,%eax
  802b05:	40                   	inc    %eax
  802b06:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b0b:	e9 8e 05 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	8b 50 08             	mov    0x8(%eax),%edx
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1c:	01 c2                	add    %eax,%edx
  802b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b21:	8b 40 08             	mov    0x8(%eax),%eax
  802b24:	39 c2                	cmp    %eax,%edx
  802b26:	73 68                	jae    802b90 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2c:	75 17                	jne    802b45 <insert_sorted_with_merge_freeList+0x1ed>
  802b2e:	83 ec 04             	sub    $0x4,%esp
  802b31:	68 54 3b 80 00       	push   $0x803b54
  802b36:	68 45 01 00 00       	push   $0x145
  802b3b:	68 77 3b 80 00       	push   $0x803b77
  802b40:	e8 39 d8 ff ff       	call   80037e <_panic>
  802b45:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	89 10                	mov    %edx,(%eax)
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 0d                	je     802b66 <insert_sorted_with_merge_freeList+0x20e>
  802b59:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b61:	89 50 04             	mov    %edx,0x4(%eax)
  802b64:	eb 08                	jmp    802b6e <insert_sorted_with_merge_freeList+0x216>
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	a3 38 41 80 00       	mov    %eax,0x804138
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b80:	a1 44 41 80 00       	mov    0x804144,%eax
  802b85:	40                   	inc    %eax
  802b86:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b8b:	e9 0e 05 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	8b 50 08             	mov    0x8(%eax),%edx
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9c:	01 c2                	add    %eax,%edx
  802b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba1:	8b 40 08             	mov    0x8(%eax),%eax
  802ba4:	39 c2                	cmp    %eax,%edx
  802ba6:	0f 85 9c 00 00 00    	jne    802c48 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baf:	8b 50 0c             	mov    0xc(%eax),%edx
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb8:	01 c2                	add    %eax,%edx
  802bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbd:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	8b 50 08             	mov    0x8(%eax),%edx
  802bc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc9:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802be0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be4:	75 17                	jne    802bfd <insert_sorted_with_merge_freeList+0x2a5>
  802be6:	83 ec 04             	sub    $0x4,%esp
  802be9:	68 54 3b 80 00       	push   $0x803b54
  802bee:	68 4d 01 00 00       	push   $0x14d
  802bf3:	68 77 3b 80 00       	push   $0x803b77
  802bf8:	e8 81 d7 ff ff       	call   80037e <_panic>
  802bfd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	89 10                	mov    %edx,(%eax)
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	8b 00                	mov    (%eax),%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	74 0d                	je     802c1e <insert_sorted_with_merge_freeList+0x2c6>
  802c11:	a1 48 41 80 00       	mov    0x804148,%eax
  802c16:	8b 55 08             	mov    0x8(%ebp),%edx
  802c19:	89 50 04             	mov    %edx,0x4(%eax)
  802c1c:	eb 08                	jmp    802c26 <insert_sorted_with_merge_freeList+0x2ce>
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	a3 48 41 80 00       	mov    %eax,0x804148
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c38:	a1 54 41 80 00       	mov    0x804154,%eax
  802c3d:	40                   	inc    %eax
  802c3e:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c43:	e9 56 04 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802c48:	a1 38 41 80 00       	mov    0x804138,%eax
  802c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c50:	e9 19 04 00 00       	jmp    80306e <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 00                	mov    (%eax),%eax
  802c5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 50 08             	mov    0x8(%eax),%edx
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	8b 40 0c             	mov    0xc(%eax),%eax
  802c69:	01 c2                	add    %eax,%edx
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 40 08             	mov    0x8(%eax),%eax
  802c71:	39 c2                	cmp    %eax,%edx
  802c73:	0f 85 ad 01 00 00    	jne    802e26 <insert_sorted_with_merge_freeList+0x4ce>
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	8b 50 08             	mov    0x8(%eax),%edx
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	8b 40 0c             	mov    0xc(%eax),%eax
  802c85:	01 c2                	add    %eax,%edx
  802c87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c8a:	8b 40 08             	mov    0x8(%eax),%eax
  802c8d:	39 c2                	cmp    %eax,%edx
  802c8f:	0f 85 91 01 00 00    	jne    802e26 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	8b 50 0c             	mov    0xc(%eax),%edx
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ca1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ca4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca7:	01 c8                	add    %ecx,%eax
  802ca9:	01 c2                	add    %eax,%edx
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cc8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802cd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802cdd:	75 17                	jne    802cf6 <insert_sorted_with_merge_freeList+0x39e>
  802cdf:	83 ec 04             	sub    $0x4,%esp
  802ce2:	68 e8 3b 80 00       	push   $0x803be8
  802ce7:	68 5b 01 00 00       	push   $0x15b
  802cec:	68 77 3b 80 00       	push   $0x803b77
  802cf1:	e8 88 d6 ff ff       	call   80037e <_panic>
  802cf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	85 c0                	test   %eax,%eax
  802cfd:	74 10                	je     802d0f <insert_sorted_with_merge_freeList+0x3b7>
  802cff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d07:	8b 52 04             	mov    0x4(%edx),%edx
  802d0a:	89 50 04             	mov    %edx,0x4(%eax)
  802d0d:	eb 0b                	jmp    802d1a <insert_sorted_with_merge_freeList+0x3c2>
  802d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d12:	8b 40 04             	mov    0x4(%eax),%eax
  802d15:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1d:	8b 40 04             	mov    0x4(%eax),%eax
  802d20:	85 c0                	test   %eax,%eax
  802d22:	74 0f                	je     802d33 <insert_sorted_with_merge_freeList+0x3db>
  802d24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d27:	8b 40 04             	mov    0x4(%eax),%eax
  802d2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d2d:	8b 12                	mov    (%edx),%edx
  802d2f:	89 10                	mov    %edx,(%eax)
  802d31:	eb 0a                	jmp    802d3d <insert_sorted_with_merge_freeList+0x3e5>
  802d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	a3 38 41 80 00       	mov    %eax,0x804138
  802d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d50:	a1 44 41 80 00       	mov    0x804144,%eax
  802d55:	48                   	dec    %eax
  802d56:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5f:	75 17                	jne    802d78 <insert_sorted_with_merge_freeList+0x420>
  802d61:	83 ec 04             	sub    $0x4,%esp
  802d64:	68 54 3b 80 00       	push   $0x803b54
  802d69:	68 5c 01 00 00       	push   $0x15c
  802d6e:	68 77 3b 80 00       	push   $0x803b77
  802d73:	e8 06 d6 ff ff       	call   80037e <_panic>
  802d78:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	89 10                	mov    %edx,(%eax)
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	85 c0                	test   %eax,%eax
  802d8a:	74 0d                	je     802d99 <insert_sorted_with_merge_freeList+0x441>
  802d8c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d91:	8b 55 08             	mov    0x8(%ebp),%edx
  802d94:	89 50 04             	mov    %edx,0x4(%eax)
  802d97:	eb 08                	jmp    802da1 <insert_sorted_with_merge_freeList+0x449>
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	a3 48 41 80 00       	mov    %eax,0x804148
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db3:	a1 54 41 80 00       	mov    0x804154,%eax
  802db8:	40                   	inc    %eax
  802db9:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802dbe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dc2:	75 17                	jne    802ddb <insert_sorted_with_merge_freeList+0x483>
  802dc4:	83 ec 04             	sub    $0x4,%esp
  802dc7:	68 54 3b 80 00       	push   $0x803b54
  802dcc:	68 5d 01 00 00       	push   $0x15d
  802dd1:	68 77 3b 80 00       	push   $0x803b77
  802dd6:	e8 a3 d5 ff ff       	call   80037e <_panic>
  802ddb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de4:	89 10                	mov    %edx,(%eax)
  802de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	74 0d                	je     802dfc <insert_sorted_with_merge_freeList+0x4a4>
  802def:	a1 48 41 80 00       	mov    0x804148,%eax
  802df4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802df7:	89 50 04             	mov    %edx,0x4(%eax)
  802dfa:	eb 08                	jmp    802e04 <insert_sorted_with_merge_freeList+0x4ac>
  802dfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dff:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e07:	a3 48 41 80 00       	mov    %eax,0x804148
  802e0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e16:	a1 54 41 80 00       	mov    0x804154,%eax
  802e1b:	40                   	inc    %eax
  802e1c:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e21:	e9 78 02 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 50 08             	mov    0x8(%eax),%edx
  802e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e32:	01 c2                	add    %eax,%edx
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	8b 40 08             	mov    0x8(%eax),%eax
  802e3a:	39 c2                	cmp    %eax,%edx
  802e3c:	0f 83 b8 00 00 00    	jae    802efa <insert_sorted_with_merge_freeList+0x5a2>
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 50 08             	mov    0x8(%eax),%edx
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4e:	01 c2                	add    %eax,%edx
  802e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e53:	8b 40 08             	mov    0x8(%eax),%eax
  802e56:	39 c2                	cmp    %eax,%edx
  802e58:	0f 85 9c 00 00 00    	jne    802efa <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802e5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e61:	8b 50 0c             	mov    0xc(%eax),%edx
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6a:	01 c2                	add    %eax,%edx
  802e6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6f:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	8b 50 08             	mov    0x8(%eax),%edx
  802e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7b:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e96:	75 17                	jne    802eaf <insert_sorted_with_merge_freeList+0x557>
  802e98:	83 ec 04             	sub    $0x4,%esp
  802e9b:	68 54 3b 80 00       	push   $0x803b54
  802ea0:	68 67 01 00 00       	push   $0x167
  802ea5:	68 77 3b 80 00       	push   $0x803b77
  802eaa:	e8 cf d4 ff ff       	call   80037e <_panic>
  802eaf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	89 10                	mov    %edx,(%eax)
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 0d                	je     802ed0 <insert_sorted_with_merge_freeList+0x578>
  802ec3:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecb:	89 50 04             	mov    %edx,0x4(%eax)
  802ece:	eb 08                	jmp    802ed8 <insert_sorted_with_merge_freeList+0x580>
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eea:	a1 54 41 80 00       	mov    0x804154,%eax
  802eef:	40                   	inc    %eax
  802ef0:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802ef5:	e9 a4 01 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efd:	8b 50 08             	mov    0x8(%eax),%edx
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 40 0c             	mov    0xc(%eax),%eax
  802f06:	01 c2                	add    %eax,%edx
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	8b 40 08             	mov    0x8(%eax),%eax
  802f0e:	39 c2                	cmp    %eax,%edx
  802f10:	0f 85 ac 00 00 00    	jne    802fc2 <insert_sorted_with_merge_freeList+0x66a>
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 50 08             	mov    0x8(%eax),%edx
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f22:	01 c2                	add    %eax,%edx
  802f24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f27:	8b 40 08             	mov    0x8(%eax),%eax
  802f2a:	39 c2                	cmp    %eax,%edx
  802f2c:	0f 83 90 00 00 00    	jae    802fc2 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 50 0c             	mov    0xc(%eax),%edx
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3e:	01 c2                	add    %eax,%edx
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5e:	75 17                	jne    802f77 <insert_sorted_with_merge_freeList+0x61f>
  802f60:	83 ec 04             	sub    $0x4,%esp
  802f63:	68 54 3b 80 00       	push   $0x803b54
  802f68:	68 70 01 00 00       	push   $0x170
  802f6d:	68 77 3b 80 00       	push   $0x803b77
  802f72:	e8 07 d4 ff ff       	call   80037e <_panic>
  802f77:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	89 10                	mov    %edx,(%eax)
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	8b 00                	mov    (%eax),%eax
  802f87:	85 c0                	test   %eax,%eax
  802f89:	74 0d                	je     802f98 <insert_sorted_with_merge_freeList+0x640>
  802f8b:	a1 48 41 80 00       	mov    0x804148,%eax
  802f90:	8b 55 08             	mov    0x8(%ebp),%edx
  802f93:	89 50 04             	mov    %edx,0x4(%eax)
  802f96:	eb 08                	jmp    802fa0 <insert_sorted_with_merge_freeList+0x648>
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	a3 48 41 80 00       	mov    %eax,0x804148
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb2:	a1 54 41 80 00       	mov    0x804154,%eax
  802fb7:	40                   	inc    %eax
  802fb8:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  802fbd:	e9 dc 00 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc5:	8b 50 08             	mov    0x8(%eax),%edx
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802fce:	01 c2                	add    %eax,%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	8b 40 08             	mov    0x8(%eax),%eax
  802fd6:	39 c2                	cmp    %eax,%edx
  802fd8:	0f 83 88 00 00 00    	jae    803066 <insert_sorted_with_merge_freeList+0x70e>
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	8b 50 08             	mov    0x8(%eax),%edx
  802fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fea:	01 c2                	add    %eax,%edx
  802fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fef:	8b 40 08             	mov    0x8(%eax),%eax
  802ff2:	39 c2                	cmp    %eax,%edx
  802ff4:	73 70                	jae    803066 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  802ff6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffa:	74 06                	je     803002 <insert_sorted_with_merge_freeList+0x6aa>
  802ffc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803000:	75 17                	jne    803019 <insert_sorted_with_merge_freeList+0x6c1>
  803002:	83 ec 04             	sub    $0x4,%esp
  803005:	68 b4 3b 80 00       	push   $0x803bb4
  80300a:	68 75 01 00 00       	push   $0x175
  80300f:	68 77 3b 80 00       	push   $0x803b77
  803014:	e8 65 d3 ff ff       	call   80037e <_panic>
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	8b 10                	mov    (%eax),%edx
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	89 10                	mov    %edx,(%eax)
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	8b 00                	mov    (%eax),%eax
  803028:	85 c0                	test   %eax,%eax
  80302a:	74 0b                	je     803037 <insert_sorted_with_merge_freeList+0x6df>
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	8b 55 08             	mov    0x8(%ebp),%edx
  803034:	89 50 04             	mov    %edx,0x4(%eax)
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 55 08             	mov    0x8(%ebp),%edx
  80303d:	89 10                	mov    %edx,(%eax)
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803045:	89 50 04             	mov    %edx,0x4(%eax)
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	85 c0                	test   %eax,%eax
  80304f:	75 08                	jne    803059 <insert_sorted_with_merge_freeList+0x701>
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803059:	a1 44 41 80 00       	mov    0x804144,%eax
  80305e:	40                   	inc    %eax
  80305f:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  803064:	eb 38                	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803066:	a1 40 41 80 00       	mov    0x804140,%eax
  80306b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803072:	74 07                	je     80307b <insert_sorted_with_merge_freeList+0x723>
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	eb 05                	jmp    803080 <insert_sorted_with_merge_freeList+0x728>
  80307b:	b8 00 00 00 00       	mov    $0x0,%eax
  803080:	a3 40 41 80 00       	mov    %eax,0x804140
  803085:	a1 40 41 80 00       	mov    0x804140,%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	0f 85 c3 fb ff ff    	jne    802c55 <insert_sorted_with_merge_freeList+0x2fd>
  803092:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803096:	0f 85 b9 fb ff ff    	jne    802c55 <insert_sorted_with_merge_freeList+0x2fd>





}
  80309c:	eb 00                	jmp    80309e <insert_sorted_with_merge_freeList+0x746>
  80309e:	90                   	nop
  80309f:	c9                   	leave  
  8030a0:	c3                   	ret    
  8030a1:	66 90                	xchg   %ax,%ax
  8030a3:	90                   	nop

008030a4 <__udivdi3>:
  8030a4:	55                   	push   %ebp
  8030a5:	57                   	push   %edi
  8030a6:	56                   	push   %esi
  8030a7:	53                   	push   %ebx
  8030a8:	83 ec 1c             	sub    $0x1c,%esp
  8030ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030bb:	89 ca                	mov    %ecx,%edx
  8030bd:	89 f8                	mov    %edi,%eax
  8030bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030c3:	85 f6                	test   %esi,%esi
  8030c5:	75 2d                	jne    8030f4 <__udivdi3+0x50>
  8030c7:	39 cf                	cmp    %ecx,%edi
  8030c9:	77 65                	ja     803130 <__udivdi3+0x8c>
  8030cb:	89 fd                	mov    %edi,%ebp
  8030cd:	85 ff                	test   %edi,%edi
  8030cf:	75 0b                	jne    8030dc <__udivdi3+0x38>
  8030d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8030d6:	31 d2                	xor    %edx,%edx
  8030d8:	f7 f7                	div    %edi
  8030da:	89 c5                	mov    %eax,%ebp
  8030dc:	31 d2                	xor    %edx,%edx
  8030de:	89 c8                	mov    %ecx,%eax
  8030e0:	f7 f5                	div    %ebp
  8030e2:	89 c1                	mov    %eax,%ecx
  8030e4:	89 d8                	mov    %ebx,%eax
  8030e6:	f7 f5                	div    %ebp
  8030e8:	89 cf                	mov    %ecx,%edi
  8030ea:	89 fa                	mov    %edi,%edx
  8030ec:	83 c4 1c             	add    $0x1c,%esp
  8030ef:	5b                   	pop    %ebx
  8030f0:	5e                   	pop    %esi
  8030f1:	5f                   	pop    %edi
  8030f2:	5d                   	pop    %ebp
  8030f3:	c3                   	ret    
  8030f4:	39 ce                	cmp    %ecx,%esi
  8030f6:	77 28                	ja     803120 <__udivdi3+0x7c>
  8030f8:	0f bd fe             	bsr    %esi,%edi
  8030fb:	83 f7 1f             	xor    $0x1f,%edi
  8030fe:	75 40                	jne    803140 <__udivdi3+0x9c>
  803100:	39 ce                	cmp    %ecx,%esi
  803102:	72 0a                	jb     80310e <__udivdi3+0x6a>
  803104:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803108:	0f 87 9e 00 00 00    	ja     8031ac <__udivdi3+0x108>
  80310e:	b8 01 00 00 00       	mov    $0x1,%eax
  803113:	89 fa                	mov    %edi,%edx
  803115:	83 c4 1c             	add    $0x1c,%esp
  803118:	5b                   	pop    %ebx
  803119:	5e                   	pop    %esi
  80311a:	5f                   	pop    %edi
  80311b:	5d                   	pop    %ebp
  80311c:	c3                   	ret    
  80311d:	8d 76 00             	lea    0x0(%esi),%esi
  803120:	31 ff                	xor    %edi,%edi
  803122:	31 c0                	xor    %eax,%eax
  803124:	89 fa                	mov    %edi,%edx
  803126:	83 c4 1c             	add    $0x1c,%esp
  803129:	5b                   	pop    %ebx
  80312a:	5e                   	pop    %esi
  80312b:	5f                   	pop    %edi
  80312c:	5d                   	pop    %ebp
  80312d:	c3                   	ret    
  80312e:	66 90                	xchg   %ax,%ax
  803130:	89 d8                	mov    %ebx,%eax
  803132:	f7 f7                	div    %edi
  803134:	31 ff                	xor    %edi,%edi
  803136:	89 fa                	mov    %edi,%edx
  803138:	83 c4 1c             	add    $0x1c,%esp
  80313b:	5b                   	pop    %ebx
  80313c:	5e                   	pop    %esi
  80313d:	5f                   	pop    %edi
  80313e:	5d                   	pop    %ebp
  80313f:	c3                   	ret    
  803140:	bd 20 00 00 00       	mov    $0x20,%ebp
  803145:	89 eb                	mov    %ebp,%ebx
  803147:	29 fb                	sub    %edi,%ebx
  803149:	89 f9                	mov    %edi,%ecx
  80314b:	d3 e6                	shl    %cl,%esi
  80314d:	89 c5                	mov    %eax,%ebp
  80314f:	88 d9                	mov    %bl,%cl
  803151:	d3 ed                	shr    %cl,%ebp
  803153:	89 e9                	mov    %ebp,%ecx
  803155:	09 f1                	or     %esi,%ecx
  803157:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80315b:	89 f9                	mov    %edi,%ecx
  80315d:	d3 e0                	shl    %cl,%eax
  80315f:	89 c5                	mov    %eax,%ebp
  803161:	89 d6                	mov    %edx,%esi
  803163:	88 d9                	mov    %bl,%cl
  803165:	d3 ee                	shr    %cl,%esi
  803167:	89 f9                	mov    %edi,%ecx
  803169:	d3 e2                	shl    %cl,%edx
  80316b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80316f:	88 d9                	mov    %bl,%cl
  803171:	d3 e8                	shr    %cl,%eax
  803173:	09 c2                	or     %eax,%edx
  803175:	89 d0                	mov    %edx,%eax
  803177:	89 f2                	mov    %esi,%edx
  803179:	f7 74 24 0c          	divl   0xc(%esp)
  80317d:	89 d6                	mov    %edx,%esi
  80317f:	89 c3                	mov    %eax,%ebx
  803181:	f7 e5                	mul    %ebp
  803183:	39 d6                	cmp    %edx,%esi
  803185:	72 19                	jb     8031a0 <__udivdi3+0xfc>
  803187:	74 0b                	je     803194 <__udivdi3+0xf0>
  803189:	89 d8                	mov    %ebx,%eax
  80318b:	31 ff                	xor    %edi,%edi
  80318d:	e9 58 ff ff ff       	jmp    8030ea <__udivdi3+0x46>
  803192:	66 90                	xchg   %ax,%ax
  803194:	8b 54 24 08          	mov    0x8(%esp),%edx
  803198:	89 f9                	mov    %edi,%ecx
  80319a:	d3 e2                	shl    %cl,%edx
  80319c:	39 c2                	cmp    %eax,%edx
  80319e:	73 e9                	jae    803189 <__udivdi3+0xe5>
  8031a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031a3:	31 ff                	xor    %edi,%edi
  8031a5:	e9 40 ff ff ff       	jmp    8030ea <__udivdi3+0x46>
  8031aa:	66 90                	xchg   %ax,%ax
  8031ac:	31 c0                	xor    %eax,%eax
  8031ae:	e9 37 ff ff ff       	jmp    8030ea <__udivdi3+0x46>
  8031b3:	90                   	nop

008031b4 <__umoddi3>:
  8031b4:	55                   	push   %ebp
  8031b5:	57                   	push   %edi
  8031b6:	56                   	push   %esi
  8031b7:	53                   	push   %ebx
  8031b8:	83 ec 1c             	sub    $0x1c,%esp
  8031bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031d3:	89 f3                	mov    %esi,%ebx
  8031d5:	89 fa                	mov    %edi,%edx
  8031d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031db:	89 34 24             	mov    %esi,(%esp)
  8031de:	85 c0                	test   %eax,%eax
  8031e0:	75 1a                	jne    8031fc <__umoddi3+0x48>
  8031e2:	39 f7                	cmp    %esi,%edi
  8031e4:	0f 86 a2 00 00 00    	jbe    80328c <__umoddi3+0xd8>
  8031ea:	89 c8                	mov    %ecx,%eax
  8031ec:	89 f2                	mov    %esi,%edx
  8031ee:	f7 f7                	div    %edi
  8031f0:	89 d0                	mov    %edx,%eax
  8031f2:	31 d2                	xor    %edx,%edx
  8031f4:	83 c4 1c             	add    $0x1c,%esp
  8031f7:	5b                   	pop    %ebx
  8031f8:	5e                   	pop    %esi
  8031f9:	5f                   	pop    %edi
  8031fa:	5d                   	pop    %ebp
  8031fb:	c3                   	ret    
  8031fc:	39 f0                	cmp    %esi,%eax
  8031fe:	0f 87 ac 00 00 00    	ja     8032b0 <__umoddi3+0xfc>
  803204:	0f bd e8             	bsr    %eax,%ebp
  803207:	83 f5 1f             	xor    $0x1f,%ebp
  80320a:	0f 84 ac 00 00 00    	je     8032bc <__umoddi3+0x108>
  803210:	bf 20 00 00 00       	mov    $0x20,%edi
  803215:	29 ef                	sub    %ebp,%edi
  803217:	89 fe                	mov    %edi,%esi
  803219:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80321d:	89 e9                	mov    %ebp,%ecx
  80321f:	d3 e0                	shl    %cl,%eax
  803221:	89 d7                	mov    %edx,%edi
  803223:	89 f1                	mov    %esi,%ecx
  803225:	d3 ef                	shr    %cl,%edi
  803227:	09 c7                	or     %eax,%edi
  803229:	89 e9                	mov    %ebp,%ecx
  80322b:	d3 e2                	shl    %cl,%edx
  80322d:	89 14 24             	mov    %edx,(%esp)
  803230:	89 d8                	mov    %ebx,%eax
  803232:	d3 e0                	shl    %cl,%eax
  803234:	89 c2                	mov    %eax,%edx
  803236:	8b 44 24 08          	mov    0x8(%esp),%eax
  80323a:	d3 e0                	shl    %cl,%eax
  80323c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803240:	8b 44 24 08          	mov    0x8(%esp),%eax
  803244:	89 f1                	mov    %esi,%ecx
  803246:	d3 e8                	shr    %cl,%eax
  803248:	09 d0                	or     %edx,%eax
  80324a:	d3 eb                	shr    %cl,%ebx
  80324c:	89 da                	mov    %ebx,%edx
  80324e:	f7 f7                	div    %edi
  803250:	89 d3                	mov    %edx,%ebx
  803252:	f7 24 24             	mull   (%esp)
  803255:	89 c6                	mov    %eax,%esi
  803257:	89 d1                	mov    %edx,%ecx
  803259:	39 d3                	cmp    %edx,%ebx
  80325b:	0f 82 87 00 00 00    	jb     8032e8 <__umoddi3+0x134>
  803261:	0f 84 91 00 00 00    	je     8032f8 <__umoddi3+0x144>
  803267:	8b 54 24 04          	mov    0x4(%esp),%edx
  80326b:	29 f2                	sub    %esi,%edx
  80326d:	19 cb                	sbb    %ecx,%ebx
  80326f:	89 d8                	mov    %ebx,%eax
  803271:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803275:	d3 e0                	shl    %cl,%eax
  803277:	89 e9                	mov    %ebp,%ecx
  803279:	d3 ea                	shr    %cl,%edx
  80327b:	09 d0                	or     %edx,%eax
  80327d:	89 e9                	mov    %ebp,%ecx
  80327f:	d3 eb                	shr    %cl,%ebx
  803281:	89 da                	mov    %ebx,%edx
  803283:	83 c4 1c             	add    $0x1c,%esp
  803286:	5b                   	pop    %ebx
  803287:	5e                   	pop    %esi
  803288:	5f                   	pop    %edi
  803289:	5d                   	pop    %ebp
  80328a:	c3                   	ret    
  80328b:	90                   	nop
  80328c:	89 fd                	mov    %edi,%ebp
  80328e:	85 ff                	test   %edi,%edi
  803290:	75 0b                	jne    80329d <__umoddi3+0xe9>
  803292:	b8 01 00 00 00       	mov    $0x1,%eax
  803297:	31 d2                	xor    %edx,%edx
  803299:	f7 f7                	div    %edi
  80329b:	89 c5                	mov    %eax,%ebp
  80329d:	89 f0                	mov    %esi,%eax
  80329f:	31 d2                	xor    %edx,%edx
  8032a1:	f7 f5                	div    %ebp
  8032a3:	89 c8                	mov    %ecx,%eax
  8032a5:	f7 f5                	div    %ebp
  8032a7:	89 d0                	mov    %edx,%eax
  8032a9:	e9 44 ff ff ff       	jmp    8031f2 <__umoddi3+0x3e>
  8032ae:	66 90                	xchg   %ax,%ax
  8032b0:	89 c8                	mov    %ecx,%eax
  8032b2:	89 f2                	mov    %esi,%edx
  8032b4:	83 c4 1c             	add    $0x1c,%esp
  8032b7:	5b                   	pop    %ebx
  8032b8:	5e                   	pop    %esi
  8032b9:	5f                   	pop    %edi
  8032ba:	5d                   	pop    %ebp
  8032bb:	c3                   	ret    
  8032bc:	3b 04 24             	cmp    (%esp),%eax
  8032bf:	72 06                	jb     8032c7 <__umoddi3+0x113>
  8032c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032c5:	77 0f                	ja     8032d6 <__umoddi3+0x122>
  8032c7:	89 f2                	mov    %esi,%edx
  8032c9:	29 f9                	sub    %edi,%ecx
  8032cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032cf:	89 14 24             	mov    %edx,(%esp)
  8032d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032da:	8b 14 24             	mov    (%esp),%edx
  8032dd:	83 c4 1c             	add    $0x1c,%esp
  8032e0:	5b                   	pop    %ebx
  8032e1:	5e                   	pop    %esi
  8032e2:	5f                   	pop    %edi
  8032e3:	5d                   	pop    %ebp
  8032e4:	c3                   	ret    
  8032e5:	8d 76 00             	lea    0x0(%esi),%esi
  8032e8:	2b 04 24             	sub    (%esp),%eax
  8032eb:	19 fa                	sbb    %edi,%edx
  8032ed:	89 d1                	mov    %edx,%ecx
  8032ef:	89 c6                	mov    %eax,%esi
  8032f1:	e9 71 ff ff ff       	jmp    803267 <__umoddi3+0xb3>
  8032f6:	66 90                	xchg   %ax,%ax
  8032f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032fc:	72 ea                	jb     8032e8 <__umoddi3+0x134>
  8032fe:	89 d9                	mov    %ebx,%ecx
  803300:	e9 62 ff ff ff       	jmp    803267 <__umoddi3+0xb3>
