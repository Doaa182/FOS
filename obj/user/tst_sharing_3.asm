
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 8a 02 00 00       	call   8002c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 50 80 00       	mov    0x805020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 50 80 00       	mov    0x805020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 a0 33 80 00       	push   $0x8033a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 33 80 00       	push   $0x8033bc
  800098:	e8 5f 03 00 00       	call   8003fc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 82 15 00 00       	call   801629 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	68 d4 33 80 00       	push   $0x8033d4
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 08 34 80 00       	push   $0x803408
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 64 34 80 00       	push   $0x803464
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 98 34 80 00       	push   $0x803498
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 e0 34 80 00       	push   $0x8034e0
  8000f9:	e8 a7 16 00 00       	call   8017a5 <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 5f 19 00 00       	call   801a68 <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 e0 34 80 00       	push   $0x8034e0
  80011b:	e8 85 16 00 00       	call   8017a5 <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 e4 34 80 00       	push   $0x8034e4
  800134:	6a 24                	push   $0x24
  800136:	68 bc 33 80 00       	push   $0x8033bc
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 23 19 00 00       	call   801a68 <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 38 35 80 00       	push   $0x803538
  800156:	6a 25                	push   $0x25
  800158:	68 bc 33 80 00       	push   $0x8033bc
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 94 35 80 00       	push   $0x803594
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 f1 18 00 00       	call   801a68 <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 ec 35 80 00       	push   $0x8035ec
  80018e:	e8 12 16 00 00       	call   8017a5 <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 f0 35 80 00       	push   $0x8035f0
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 bc 33 80 00       	push   $0x8033bc
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 b0 18 00 00       	call   801a68 <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 64 36 80 00       	push   $0x803664
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 bc 33 80 00       	push   $0x8033bc
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 d8 36 80 00       	push   $0x8036d8
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 d7 1a 00 00       	call   801cc1 <sys_getMaxShares>
  8001ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f4:	eb 45                	jmp    80023b <_main+0x203>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  8001fc:	50                   	push   %eax
  8001fd:	ff 75 ec             	pushl  -0x14(%ebp)
  800200:	e8 d3 0f 00 00       	call   8011d8 <ltostr>
  800205:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	6a 01                	push   $0x1
  80020d:	6a 01                	push   $0x1
  80020f:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  800212:	50                   	push   %eax
  800213:	e8 8d 15 00 00       	call   8017a5 <smalloc>
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80021e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800222:	75 14                	jne    800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 4c 37 80 00       	push   $0x80374c
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 bc 33 80 00       	push   $0x8033bc
  800233:	e8 c4 01 00 00       	call   8003fc <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  800238:	ff 45 ec             	incl   -0x14(%ebp)
  80023b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800244:	39 c2                	cmp    %eax,%edx
  800246:	77 ae                	ja     8001f6 <_main+0x1be>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	6a 01                	push   $0x1
  80024d:	6a 01                	push   $0x1
  80024f:	68 7c 37 80 00       	push   $0x80377c
  800254:	e8 4c 15 00 00       	call   8017a5 <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 5d 1a 00 00       	call   801cc1 <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 88 37 80 00       	push   $0x803788
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 bc 33 80 00       	push   $0x8033bc
  800284:	e8 73 01 00 00       	call   8003fc <_panic>
		//else
		if ((maxShares_after == 2*maxShares) && (z == NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS, krealloc should be invoked to double the size of shares array!!");
  800289:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800291:	75 1a                	jne    8002ad <_main+0x275>
  800293:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800297:	75 14                	jne    8002ad <_main+0x275>
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 04 38 80 00       	push   $0x803804
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 bc 33 80 00       	push   $0x8033bc
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 90 38 80 00       	push   $0x803890
  8002b5:	e8 f6 03 00 00       	call   8006b0 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp

	return;
  8002bd:	90                   	nop
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002c6:	e8 7d 1a 00 00       	call   801d48 <sys_getenvindex>
  8002cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002d1:	89 d0                	mov    %edx,%eax
  8002d3:	c1 e0 03             	shl    $0x3,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	01 c0                	add    %eax,%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	c1 e0 04             	shl    $0x4,%eax
  8002e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ed:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002fd:	84 c0                	test   %al,%al
  8002ff:	74 0f                	je     800310 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800301:	a1 20 50 80 00       	mov    0x805020,%eax
  800306:	05 5c 05 00 00       	add    $0x55c,%eax
  80030b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x60>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800331:	e8 1f 18 00 00       	call   801b55 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 08 39 80 00       	push   $0x803908
  80033e:	e8 6d 03 00 00       	call   8006b0 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800346:	a1 20 50 80 00       	mov    0x805020,%eax
  80034b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800351:	a1 20 50 80 00       	mov    0x805020,%eax
  800356:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	68 30 39 80 00       	push   $0x803930
  800366:	e8 45 03 00 00       	call   8006b0 <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036e:	a1 20 50 80 00       	mov    0x805020,%eax
  800373:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800379:	a1 20 50 80 00       	mov    0x805020,%eax
  80037e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800384:	a1 20 50 80 00       	mov    0x805020,%eax
  800389:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80038f:	51                   	push   %ecx
  800390:	52                   	push   %edx
  800391:	50                   	push   %eax
  800392:	68 58 39 80 00       	push   $0x803958
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 b0 39 80 00       	push   $0x8039b0
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 08 39 80 00       	push   $0x803908
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 9f 17 00 00       	call   801b6f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003d0:	e8 19 00 00 00       	call   8003ee <exit>
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	6a 00                	push   $0x0
  8003e3:	e8 2c 19 00 00       	call   801d14 <sys_destroy_env>
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	90                   	nop
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <exit>:

void
exit(void)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f4:	e8 81 19 00 00       	call   801d7a <sys_exit_env>
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800402:	8d 45 10             	lea    0x10(%ebp),%eax
  800405:	83 c0 04             	add    $0x4,%eax
  800408:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80040b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800410:	85 c0                	test   %eax,%eax
  800412:	74 16                	je     80042a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800414:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 c4 39 80 00       	push   $0x8039c4
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 c9 39 80 00       	push   $0x8039c9
  80043b:	e8 70 02 00 00       	call   8006b0 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800443:	8b 45 10             	mov    0x10(%ebp),%eax
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 f4             	pushl  -0xc(%ebp)
  80044c:	50                   	push   %eax
  80044d:	e8 f3 01 00 00       	call   800645 <vcprintf>
  800452:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	6a 00                	push   $0x0
  80045a:	68 e5 39 80 00       	push   $0x8039e5
  80045f:	e8 e1 01 00 00       	call   800645 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800467:	e8 82 ff ff ff       	call   8003ee <exit>

	// should not return here
	while (1) ;
  80046c:	eb fe                	jmp    80046c <_panic+0x70>

0080046e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800474:	a1 20 50 80 00       	mov    0x805020,%eax
  800479:	8b 50 74             	mov    0x74(%eax),%edx
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	39 c2                	cmp    %eax,%edx
  800481:	74 14                	je     800497 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	68 e8 39 80 00       	push   $0x8039e8
  80048b:	6a 26                	push   $0x26
  80048d:	68 34 3a 80 00       	push   $0x803a34
  800492:	e8 65 ff ff ff       	call   8003fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80049e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a5:	e9 c2 00 00 00       	jmp    80056c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	75 08                	jne    8004c7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c2:	e9 a2 00 00 00       	jmp    800569 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d5:	eb 69                	jmp    800540 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004dc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	01 c0                	add    %eax,%eax
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	c1 e0 03             	shl    $0x3,%eax
  8004ee:	01 c8                	add    %ecx,%eax
  8004f0:	8a 40 04             	mov    0x4(%eax),%al
  8004f3:	84 c0                	test   %al,%al
  8004f5:	75 46                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800502:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800505:	89 d0                	mov    %edx,%eax
  800507:	01 c0                	add    %eax,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	c1 e0 03             	shl    $0x3,%eax
  80050e:	01 c8                	add    %ecx,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800518:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80051d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800522:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800530:	39 c2                	cmp    %eax,%edx
  800532:	75 09                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800534:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80053b:	eb 12                	jmp    80054f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053d:	ff 45 e8             	incl   -0x18(%ebp)
  800540:	a1 20 50 80 00       	mov    0x805020,%eax
  800545:	8b 50 74             	mov    0x74(%eax),%edx
  800548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	77 88                	ja     8004d7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800553:	75 14                	jne    800569 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 40 3a 80 00       	push   $0x803a40
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 34 3a 80 00       	push   $0x803a34
  800564:	e8 93 fe ff ff       	call   8003fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800569:	ff 45 f0             	incl   -0x10(%ebp)
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800572:	0f 8c 32 ff ff ff    	jl     8004aa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800578:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800586:	eb 26                	jmp    8005ae <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800588:	a1 20 50 80 00       	mov    0x805020,%eax
  80058d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	01 c0                	add    %eax,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 03             	shl    $0x3,%eax
  80059f:	01 c8                	add    %ecx,%eax
  8005a1:	8a 40 04             	mov    0x4(%eax),%al
  8005a4:	3c 01                	cmp    $0x1,%al
  8005a6:	75 03                	jne    8005ab <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e0             	incl   -0x20(%ebp)
  8005ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b3:	8b 50 74             	mov    0x74(%eax),%edx
  8005b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b9:	39 c2                	cmp    %eax,%edx
  8005bb:	77 cb                	ja     800588 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c3:	74 14                	je     8005d9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 94 3a 80 00       	push   $0x803a94
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 34 3a 80 00       	push   $0x803a34
  8005d4:	e8 23 fe ff ff       	call   8003fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d9:	90                   	nop
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	89 0a                	mov    %ecx,(%edx)
  8005ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f2:	88 d1                	mov    %dl,%cl
  8005f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	3d ff 00 00 00       	cmp    $0xff,%eax
  800605:	75 2c                	jne    800633 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800607:	a0 24 50 80 00       	mov    0x805024,%al
  80060c:	0f b6 c0             	movzbl %al,%eax
  80060f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800612:	8b 12                	mov    (%edx),%edx
  800614:	89 d1                	mov    %edx,%ecx
  800616:	8b 55 0c             	mov    0xc(%ebp),%edx
  800619:	83 c2 08             	add    $0x8,%edx
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	50                   	push   %eax
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	e8 80 13 00 00       	call   8019a7 <sys_cputs>
  800627:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	8b 40 04             	mov    0x4(%eax),%eax
  800639:	8d 50 01             	lea    0x1(%eax),%edx
  80063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800655:	00 00 00 
	b.cnt = 0;
  800658:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	68 dc 05 80 00       	push   $0x8005dc
  800674:	e8 11 02 00 00       	call   80088a <vprintfmt>
  800679:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80067c:	a0 24 50 80 00       	mov    0x805024,%al
  800681:	0f b6 c0             	movzbl %al,%eax
  800684:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	50                   	push   %eax
  80068e:	52                   	push   %edx
  80068f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800695:	83 c0 08             	add    $0x8,%eax
  800698:	50                   	push   %eax
  800699:	e8 09 13 00 00       	call   8019a7 <sys_cputs>
  80069e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a1:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8006a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b6:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8006bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	e8 73 ff ff ff       	call   800645 <vcprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e3:	e8 6d 14 00 00       	call   801b55 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	e8 48 ff ff ff       	call   800645 <vcprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800703:	e8 67 14 00 00       	call   801b6f <sys_enable_interrupt>
	return cnt;
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	53                   	push   %ebx
  800711:	83 ec 14             	sub    $0x14,%esp
  800714:	8b 45 10             	mov    0x10(%ebp),%eax
  800717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800720:	8b 45 18             	mov    0x18(%ebp),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072b:	77 55                	ja     800782 <printnum+0x75>
  80072d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800730:	72 05                	jb     800737 <printnum+0x2a>
  800732:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800735:	77 4b                	ja     800782 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800737:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073d:	8b 45 18             	mov    0x18(%ebp),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	ff 75 f4             	pushl  -0xc(%ebp)
  80074a:	ff 75 f0             	pushl  -0x10(%ebp)
  80074d:	e8 ce 29 00 00       	call   803120 <__udivdi3>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	ff 75 20             	pushl  0x20(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	ff 75 18             	pushl  0x18(%ebp)
  80075f:	52                   	push   %edx
  800760:	50                   	push   %eax
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	e8 a1 ff ff ff       	call   80070d <printnum>
  80076c:	83 c4 20             	add    $0x20,%esp
  80076f:	eb 1a                	jmp    80078b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	ff 75 20             	pushl  0x20(%ebp)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800782:	ff 4d 1c             	decl   0x1c(%ebp)
  800785:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800789:	7f e6                	jg     800771 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800799:	53                   	push   %ebx
  80079a:	51                   	push   %ecx
  80079b:	52                   	push   %edx
  80079c:	50                   	push   %eax
  80079d:	e8 8e 2a 00 00       	call   803230 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 f4 3c 80 00       	add    $0x803cf4,%eax
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f be c0             	movsbl %al,%eax
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	ff d0                	call   *%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	90                   	nop
  8007bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cb:	7e 1c                	jle    8007e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 50 08             	lea    0x8(%eax),%edx
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 10                	mov    %edx,(%eax)
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	83 e8 08             	sub    $0x8,%eax
  8007e2:	8b 50 04             	mov    0x4(%eax),%edx
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	eb 40                	jmp    800829 <getuint+0x65>
	else if (lflag)
  8007e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ed:	74 1e                	je     80080d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	89 10                	mov    %edx,(%eax)
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	eb 1c                	jmp    800829 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	8d 50 04             	lea    0x4(%eax),%edx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 10                	mov    %edx,(%eax)
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800832:	7e 1c                	jle    800850 <getint+0x25>
		return va_arg(*ap, long long);
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	8d 50 08             	lea    0x8(%eax),%edx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	89 10                	mov    %edx,(%eax)
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	83 e8 08             	sub    $0x8,%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	eb 38                	jmp    800888 <getint+0x5d>
	else if (lflag)
  800850:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800854:	74 1a                	je     800870 <getint+0x45>
		return va_arg(*ap, long);
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	8d 50 04             	lea    0x4(%eax),%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	89 10                	mov    %edx,(%eax)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	99                   	cltd   
  80086e:	eb 18                	jmp    800888 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	8d 50 04             	lea    0x4(%eax),%edx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	89 10                	mov    %edx,(%eax)
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	99                   	cltd   
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	56                   	push   %esi
  80088e:	53                   	push   %ebx
  80088f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800892:	eb 17                	jmp    8008ab <vprintfmt+0x21>
			if (ch == '\0')
  800894:	85 db                	test   %ebx,%ebx
  800896:	0f 84 af 03 00 00    	je     800c4b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	53                   	push   %ebx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f b6 d8             	movzbl %al,%ebx
  8008b9:	83 fb 25             	cmp    $0x25,%ebx
  8008bc:	75 d6                	jne    800894 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	8d 50 01             	lea    0x1(%eax),%edx
  8008e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e7:	8a 00                	mov    (%eax),%al
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ef:	83 f8 55             	cmp    $0x55,%eax
  8008f2:	0f 87 2b 03 00 00    	ja     800c23 <vprintfmt+0x399>
  8008f8:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
  8008ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800901:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800905:	eb d7                	jmp    8008de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800907:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090b:	eb d1                	jmp    8008de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800917:	89 d0                	mov    %edx,%eax
  800919:	c1 e0 02             	shl    $0x2,%eax
  80091c:	01 d0                	add    %edx,%eax
  80091e:	01 c0                	add    %eax,%eax
  800920:	01 d8                	add    %ebx,%eax
  800922:	83 e8 30             	sub    $0x30,%eax
  800925:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800928:	8b 45 10             	mov    0x10(%ebp),%eax
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800930:	83 fb 2f             	cmp    $0x2f,%ebx
  800933:	7e 3e                	jle    800973 <vprintfmt+0xe9>
  800935:	83 fb 39             	cmp    $0x39,%ebx
  800938:	7f 39                	jg     800973 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093d:	eb d5                	jmp    800914 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800953:	eb 1f                	jmp    800974 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	79 83                	jns    8008de <vprintfmt+0x54>
				width = 0;
  80095b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800967:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096e:	e9 6b ff ff ff       	jmp    8008de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800973:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800978:	0f 89 60 ff ff ff    	jns    8008de <vprintfmt+0x54>
				width = precision, precision = -1;
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800984:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098b:	e9 4e ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800990:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800993:	e9 46 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
			break;
  8009b8:	e9 89 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	83 c0 04             	add    $0x4,%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	83 e8 04             	sub    $0x4,%eax
  8009cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	79 02                	jns    8009d4 <vprintfmt+0x14a>
				err = -err;
  8009d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d4:	83 fb 64             	cmp    $0x64,%ebx
  8009d7:	7f 0b                	jg     8009e4 <vprintfmt+0x15a>
  8009d9:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 05 3d 80 00       	push   $0x803d05
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 5e 02 00 00       	call   800c53 <printfmt>
  8009f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f8:	e9 49 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fd:	56                   	push   %esi
  8009fe:	68 0e 3d 80 00       	push   $0x803d0e
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	ff 75 08             	pushl  0x8(%ebp)
  800a09:	e8 45 02 00 00       	call   800c53 <printfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
			break;
  800a11:	e9 30 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 e8 04             	sub    $0x4,%eax
  800a25:	8b 30                	mov    (%eax),%esi
  800a27:	85 f6                	test   %esi,%esi
  800a29:	75 05                	jne    800a30 <vprintfmt+0x1a6>
				p = "(null)";
  800a2b:	be 11 3d 80 00       	mov    $0x803d11,%esi
			if (width > 0 && padc != '-')
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	7e 6d                	jle    800aa3 <vprintfmt+0x219>
  800a36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3a:	74 67                	je     800aa3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	50                   	push   %eax
  800a43:	56                   	push   %esi
  800a44:	e8 0c 03 00 00       	call   800d55 <strnlen>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4f:	eb 16                	jmp    800a67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	50                   	push   %eax
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a64:	ff 4d e4             	decl   -0x1c(%ebp)
  800a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6b:	7f e4                	jg     800a51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6d:	eb 34                	jmp    800aa3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a73:	74 1c                	je     800a91 <vprintfmt+0x207>
  800a75:	83 fb 1f             	cmp    $0x1f,%ebx
  800a78:	7e 05                	jle    800a7f <vprintfmt+0x1f5>
  800a7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7d:	7e 12                	jle    800a91 <vprintfmt+0x207>
					putch('?', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 3f                	push   $0x3f
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	eb 0f                	jmp    800aa0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa0:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	8d 70 01             	lea    0x1(%eax),%esi
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	0f be d8             	movsbl %al,%ebx
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	74 24                	je     800ad5 <vprintfmt+0x24b>
  800ab1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab5:	78 b8                	js     800a6f <vprintfmt+0x1e5>
  800ab7:	ff 4d e0             	decl   -0x20(%ebp)
  800aba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abe:	79 af                	jns    800a6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac0:	eb 13                	jmp    800ad5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	6a 20                	push   $0x20
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad9:	7f e7                	jg     800ac2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adb:	e9 66 01 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	e8 3c fd ff ff       	call   80082b <getint>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afe:	85 d2                	test   %edx,%edx
  800b00:	79 23                	jns    800b25 <vprintfmt+0x29b>
				putch('-', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 2d                	push   $0x2d
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b18:	f7 d8                	neg    %eax
  800b1a:	83 d2 00             	adc    $0x0,%edx
  800b1d:	f7 da                	neg    %edx
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2c:	e9 bc 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 e8             	pushl  -0x18(%ebp)
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3a:	50                   	push   %eax
  800b3b:	e8 84 fc ff ff       	call   8007c4 <getuint>
  800b40:	83 c4 10             	add    $0x10,%esp
  800b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b50:	e9 98 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	6a 58                	push   $0x58
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 58                	push   $0x58
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 58                	push   $0x58
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			break;
  800b85:	e9 bc 00 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 30                	push   $0x30
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 78                	push   $0x78
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	83 c0 04             	add    $0x4,%eax
  800bb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bcc:	eb 1f                	jmp    800bed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 e7 fb ff ff       	call   8007c4 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf4:	83 ec 04             	sub    $0x4,%esp
  800bf7:	52                   	push   %edx
  800bf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bff:	ff 75 f0             	pushl  -0x10(%ebp)
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 00 fb ff ff       	call   80070d <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
			break;
  800c10:	eb 34                	jmp    800c46 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	53                   	push   %ebx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			break;
  800c21:	eb 23                	jmp    800c46 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 25                	push   $0x25
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c33:	ff 4d 10             	decl   0x10(%ebp)
  800c36:	eb 03                	jmp    800c3b <vprintfmt+0x3b1>
  800c38:	ff 4d 10             	decl   0x10(%ebp)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	48                   	dec    %eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	3c 25                	cmp    $0x25,%al
  800c43:	75 f3                	jne    800c38 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c45:	90                   	nop
		}
	}
  800c46:	e9 47 fc ff ff       	jmp    800892 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c59:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5c:	83 c0 04             	add    $0x4,%eax
  800c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	50                   	push   %eax
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 16 fc ff ff       	call   80088a <vprintfmt>
  800c74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c77:	90                   	nop
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8b 40 08             	mov    0x8(%eax),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8b 10                	mov    (%eax),%edx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 40 04             	mov    0x4(%eax),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	73 12                	jae    800cad <sprintputch+0x33>
		*b->buf++ = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 10                	mov    %dl,(%eax)
}
  800cad:	90                   	nop
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	01 d0                	add    %edx,%eax
  800cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd5:	74 06                	je     800cdd <vsnprintf+0x2d>
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	7f 07                	jg     800ce4 <vsnprintf+0x34>
		return -E_INVAL;
  800cdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce2:	eb 20                	jmp    800d04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce4:	ff 75 14             	pushl  0x14(%ebp)
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	68 7a 0c 80 00       	push   $0x800c7a
  800cf3:	e8 92 fb ff ff       	call   80088a <vprintfmt>
  800cf8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1b:	50                   	push   %eax
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 89 ff ff ff       	call   800cb0 <vsnprintf>
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3f:	eb 06                	jmp    800d47 <strlen+0x15>
		n++;
  800d41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d44:	ff 45 08             	incl   0x8(%ebp)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	84 c0                	test   %al,%al
  800d4e:	75 f1                	jne    800d41 <strlen+0xf>
		n++;
	return n;
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d62:	eb 09                	jmp    800d6d <strnlen+0x18>
		n++;
  800d64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	ff 4d 0c             	decl   0xc(%ebp)
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	74 09                	je     800d7c <strnlen+0x27>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	75 e8                	jne    800d64 <strnlen+0xf>
		n++;
	return n;
  800d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d8d:	90                   	nop
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 08             	mov    %edx,0x8(%ebp)
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da0:	8a 12                	mov    (%edx),%dl
  800da2:	88 10                	mov    %dl,(%eax)
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	75 e4                	jne    800d8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc2:	eb 1f                	jmp    800de3 <strncpy+0x34>
		*dst++ = *src;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8d 50 01             	lea    0x1(%eax),%edx
  800dca:	89 55 08             	mov    %edx,0x8(%ebp)
  800dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd0:	8a 12                	mov    (%edx),%dl
  800dd2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	74 03                	je     800de0 <strncpy+0x31>
			src++;
  800ddd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de0:	ff 45 fc             	incl   -0x4(%ebp)
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de9:	72 d9                	jb     800dc4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	74 30                	je     800e32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e02:	eb 16                	jmp    800e1a <strlcpy+0x2a>
			*dst++ = *src++;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1a:	ff 4d 10             	decl   0x10(%ebp)
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	74 09                	je     800e2c <strlcpy+0x3c>
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 d8                	jne    800e04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e38:	29 c2                	sub    %eax,%edx
  800e3a:	89 d0                	mov    %edx,%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e41:	eb 06                	jmp    800e49 <strcmp+0xb>
		p++, q++;
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	74 0e                	je     800e60 <strcmp+0x22>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 10                	mov    (%eax),%dl
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	38 c2                	cmp    %al,%dl
  800e5e:	74 e3                	je     800e43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 d0             	movzbl %al,%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 c0             	movzbl %al,%eax
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	89 d0                	mov    %edx,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e79:	eb 09                	jmp    800e84 <strncmp+0xe>
		n--, p++, q++;
  800e7b:	ff 4d 10             	decl   0x10(%ebp)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e88:	74 17                	je     800ea1 <strncmp+0x2b>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 0e                	je     800ea1 <strncmp+0x2b>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	38 c2                	cmp    %al,%dl
  800e9f:	74 da                	je     800e7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	75 07                	jne    800eae <strncmp+0x38>
		return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	eb 14                	jmp    800ec2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 d0             	movzbl %al,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 c0             	movzbl %al,%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed0:	eb 12                	jmp    800ee4 <strchr+0x20>
		if (*s == c)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eda:	75 05                	jne    800ee1 <strchr+0x1d>
			return (char *) s;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	eb 11                	jmp    800ef2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 e5                	jne    800ed2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 04             	sub    $0x4,%esp
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f00:	eb 0d                	jmp    800f0f <strfind+0x1b>
		if (*s == c)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0a:	74 0e                	je     800f1a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f0c:	ff 45 08             	incl   0x8(%ebp)
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	75 ea                	jne    800f02 <strfind+0xe>
  800f18:	eb 01                	jmp    800f1b <strfind+0x27>
		if (*s == c)
			break;
  800f1a:	90                   	nop
	return (char *) s;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f32:	eb 0e                	jmp    800f42 <memset+0x22>
		*p++ = c;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	8d 50 01             	lea    0x1(%eax),%edx
  800f3a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f42:	ff 4d f8             	decl   -0x8(%ebp)
  800f45:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f49:	79 e9                	jns    800f34 <memset+0x14>
		*p++ = c;

	return v;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f62:	eb 16                	jmp    800f7a <memcpy+0x2a>
		*d++ = *s++;
  800f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f76:	8a 12                	mov    (%edx),%dl
  800f78:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 dd                	jne    800f64 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa4:	73 50                	jae    800ff6 <memmove+0x6a>
  800fa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb1:	76 43                	jbe    800ff6 <memmove+0x6a>
		s += n;
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbf:	eb 10                	jmp    800fd1 <memmove+0x45>
			*--d = *--s;
  800fc1:	ff 4d f8             	decl   -0x8(%ebp)
  800fc4:	ff 4d fc             	decl   -0x4(%ebp)
  800fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fca:	8a 10                	mov    (%eax),%dl
  800fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	75 e3                	jne    800fc1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fde:	eb 23                	jmp    801003 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff2:	8a 12                	mov    (%edx),%dl
  800ff4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fff:	85 c0                	test   %eax,%eax
  801001:	75 dd                	jne    800fe0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101a:	eb 2a                	jmp    801046 <memcmp+0x3e>
		if (*s1 != *s2)
  80101c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101f:	8a 10                	mov    (%eax),%dl
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	38 c2                	cmp    %al,%dl
  801028:	74 16                	je     801040 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 d0             	movzbl %al,%edx
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 c0             	movzbl %al,%eax
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	eb 18                	jmp    801058 <memcmp+0x50>
		s1++, s2++;
  801040:	ff 45 fc             	incl   -0x4(%ebp)
  801043:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104c:	89 55 10             	mov    %edx,0x10(%ebp)
  80104f:	85 c0                	test   %eax,%eax
  801051:	75 c9                	jne    80101c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106b:	eb 15                	jmp    801082 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	39 c2                	cmp    %eax,%edx
  80107d:	74 0d                	je     80108c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80107f:	ff 45 08             	incl   0x8(%ebp)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801088:	72 e3                	jb     80106d <memfind+0x13>
  80108a:	eb 01                	jmp    80108d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108c:	90                   	nop
	return (void *) s;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a6:	eb 03                	jmp    8010ab <strtol+0x19>
		s++;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 20                	cmp    $0x20,%al
  8010b2:	74 f4                	je     8010a8 <strtol+0x16>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 09                	cmp    $0x9,%al
  8010bb:	74 eb                	je     8010a8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 2b                	cmp    $0x2b,%al
  8010c4:	75 05                	jne    8010cb <strtol+0x39>
		s++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	eb 13                	jmp    8010de <strtol+0x4c>
	else if (*s == '-')
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 2d                	cmp    $0x2d,%al
  8010d2:	75 0a                	jne    8010de <strtol+0x4c>
		s++, neg = 1;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e2:	74 06                	je     8010ea <strtol+0x58>
  8010e4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e8:	75 20                	jne    80110a <strtol+0x78>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 30                	cmp    $0x30,%al
  8010f1:	75 17                	jne    80110a <strtol+0x78>
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	40                   	inc    %eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	3c 78                	cmp    $0x78,%al
  8010fb:	75 0d                	jne    80110a <strtol+0x78>
		s += 2, base = 16;
  8010fd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801101:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801108:	eb 28                	jmp    801132 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110e:	75 15                	jne    801125 <strtol+0x93>
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 30                	cmp    $0x30,%al
  801117:	75 0c                	jne    801125 <strtol+0x93>
		s++, base = 8;
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801123:	eb 0d                	jmp    801132 <strtol+0xa0>
	else if (base == 0)
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	75 07                	jne    801132 <strtol+0xa0>
		base = 10;
  80112b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 2f                	cmp    $0x2f,%al
  801139:	7e 19                	jle    801154 <strtol+0xc2>
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 39                	cmp    $0x39,%al
  801142:	7f 10                	jg     801154 <strtol+0xc2>
			dig = *s - '0';
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	83 e8 30             	sub    $0x30,%eax
  80114f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801152:	eb 42                	jmp    801196 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 60                	cmp    $0x60,%al
  80115b:	7e 19                	jle    801176 <strtol+0xe4>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3c 7a                	cmp    $0x7a,%al
  801164:	7f 10                	jg     801176 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f be c0             	movsbl %al,%eax
  80116e:	83 e8 57             	sub    $0x57,%eax
  801171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801174:	eb 20                	jmp    801196 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 40                	cmp    $0x40,%al
  80117d:	7e 39                	jle    8011b8 <strtol+0x126>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 5a                	cmp    $0x5a,%al
  801186:	7f 30                	jg     8011b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f be c0             	movsbl %al,%eax
  801190:	83 e8 37             	sub    $0x37,%eax
  801193:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801199:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119c:	7d 19                	jge    8011b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b2:	e9 7b ff ff ff       	jmp    801132 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bc:	74 08                	je     8011c6 <strtol+0x134>
		*endptr = (char *) s;
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ca:	74 07                	je     8011d3 <strtol+0x141>
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	f7 d8                	neg    %eax
  8011d1:	eb 03                	jmp    8011d6 <strtol+0x144>
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f0:	79 13                	jns    801205 <ltostr+0x2d>
	{
		neg = 1;
  8011f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801202:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80120d:	99                   	cltd   
  80120e:	f7 f9                	idiv   %ecx
  801210:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801226:	83 c2 30             	add    $0x30,%edx
  801229:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801233:	f7 e9                	imul   %ecx
  801235:	c1 fa 02             	sar    $0x2,%edx
  801238:	89 c8                	mov    %ecx,%eax
  80123a:	c1 f8 1f             	sar    $0x1f,%eax
  80123d:	29 c2                	sub    %eax,%edx
  80123f:	89 d0                	mov    %edx,%eax
  801241:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124c:	f7 e9                	imul   %ecx
  80124e:	c1 fa 02             	sar    $0x2,%edx
  801251:	89 c8                	mov    %ecx,%eax
  801253:	c1 f8 1f             	sar    $0x1f,%eax
  801256:	29 c2                	sub    %eax,%edx
  801258:	89 d0                	mov    %edx,%eax
  80125a:	c1 e0 02             	shl    $0x2,%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	01 c0                	add    %eax,%eax
  801261:	29 c1                	sub    %eax,%ecx
  801263:	89 ca                	mov    %ecx,%edx
  801265:	85 d2                	test   %edx,%edx
  801267:	75 9c                	jne    801205 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801273:	48                   	dec    %eax
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801277:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127b:	74 3d                	je     8012ba <ltostr+0xe2>
		start = 1 ;
  80127d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801284:	eb 34                	jmp    8012ba <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c0:	7c c4                	jl     801286 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cd:	90                   	nop
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 54 fa ff ff       	call   800d32 <strlen>
  8012de:	83 c4 04             	add    $0x4,%esp
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	e8 46 fa ff ff       	call   800d32 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801300:	eb 17                	jmp    801319 <strcconcat+0x49>
		final[s] = str1[s] ;
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 c8                	add    %ecx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801316:	ff 45 fc             	incl   -0x4(%ebp)
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131f:	7c e1                	jl     801302 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132f:	eb 1f                	jmp    801350 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	01 c2                	add    %eax,%edx
  801341:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c8                	add    %ecx,%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134d:	ff 45 f8             	incl   -0x8(%ebp)
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c d9                	jl     801331 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801358:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135b:	8b 45 10             	mov    0x10(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801372:	8b 45 14             	mov    0x14(%ebp),%eax
  801375:	8b 00                	mov    (%eax),%eax
  801377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801389:	eb 0c                	jmp    801397 <strsplit+0x31>
			*string++ = 0;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8d 50 01             	lea    0x1(%eax),%edx
  801391:	89 55 08             	mov    %edx,0x8(%ebp)
  801394:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	84 c0                	test   %al,%al
  80139e:	74 18                	je     8013b8 <strsplit+0x52>
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	0f be c0             	movsbl %al,%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	e8 13 fb ff ff       	call   800ec4 <strchr>
  8013b1:	83 c4 08             	add    $0x8,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	75 d3                	jne    80138b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 5a                	je     80141b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c4:	8b 00                	mov    (%eax),%eax
  8013c6:	83 f8 0f             	cmp    $0xf,%eax
  8013c9:	75 07                	jne    8013d2 <strsplit+0x6c>
		{
			return 0;
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	eb 66                	jmp    801438 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013da:	8b 55 14             	mov    0x14(%ebp),%edx
  8013dd:	89 0a                	mov    %ecx,(%edx)
  8013df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	01 c2                	add    %eax,%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f0:	eb 03                	jmp    8013f5 <strsplit+0x8f>
			string++;
  8013f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	84 c0                	test   %al,%al
  8013fc:	74 8b                	je     801389 <strsplit+0x23>
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	0f be c0             	movsbl %al,%eax
  801406:	50                   	push   %eax
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	e8 b5 fa ff ff       	call   800ec4 <strchr>
  80140f:	83 c4 08             	add    $0x8,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	74 dc                	je     8013f2 <strsplit+0x8c>
			string++;
	}
  801416:	e9 6e ff ff ff       	jmp    801389 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801433:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801440:	a1 04 50 80 00       	mov    0x805004,%eax
  801445:	85 c0                	test   %eax,%eax
  801447:	74 1f                	je     801468 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801449:	e8 1d 00 00 00       	call   80146b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	68 70 3e 80 00       	push   $0x803e70
  801456:	e8 55 f2 ff ff       	call   8006b0 <cprintf>
  80145b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80145e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801465:	00 00 00 
	}
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801471:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801478:	00 00 00 
  80147b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801482:	00 00 00 
  801485:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80148c:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80148f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801496:	00 00 00 
  801499:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8014a0:	00 00 00 
  8014a3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8014aa:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8014ad:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8014b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014bc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014c1:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8014c6:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8014cd:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8014d0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8014df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ea:	f7 75 f0             	divl   -0x10(%ebp)
  8014ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f0:	29 d0                	sub    %edx,%eax
  8014f2:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8014f5:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801504:	2d 00 10 00 00       	sub    $0x1000,%eax
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	6a 06                	push   $0x6
  80150e:	ff 75 e8             	pushl  -0x18(%ebp)
  801511:	50                   	push   %eax
  801512:	e8 d4 05 00 00       	call   801aeb <sys_allocate_chunk>
  801517:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80151a:	a1 20 51 80 00       	mov    0x805120,%eax
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	50                   	push   %eax
  801523:	e8 49 0c 00 00       	call   802171 <initialize_MemBlocksList>
  801528:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  80152b:	a1 48 51 80 00       	mov    0x805148,%eax
  801530:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801533:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801537:	75 14                	jne    80154d <initialize_dyn_block_system+0xe2>
  801539:	83 ec 04             	sub    $0x4,%esp
  80153c:	68 95 3e 80 00       	push   $0x803e95
  801541:	6a 39                	push   $0x39
  801543:	68 b3 3e 80 00       	push   $0x803eb3
  801548:	e8 af ee ff ff       	call   8003fc <_panic>
  80154d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	85 c0                	test   %eax,%eax
  801554:	74 10                	je     801566 <initialize_dyn_block_system+0xfb>
  801556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801559:	8b 00                	mov    (%eax),%eax
  80155b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80155e:	8b 52 04             	mov    0x4(%edx),%edx
  801561:	89 50 04             	mov    %edx,0x4(%eax)
  801564:	eb 0b                	jmp    801571 <initialize_dyn_block_system+0x106>
  801566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801569:	8b 40 04             	mov    0x4(%eax),%eax
  80156c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801574:	8b 40 04             	mov    0x4(%eax),%eax
  801577:	85 c0                	test   %eax,%eax
  801579:	74 0f                	je     80158a <initialize_dyn_block_system+0x11f>
  80157b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157e:	8b 40 04             	mov    0x4(%eax),%eax
  801581:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801584:	8b 12                	mov    (%edx),%edx
  801586:	89 10                	mov    %edx,(%eax)
  801588:	eb 0a                	jmp    801594 <initialize_dyn_block_system+0x129>
  80158a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158d:	8b 00                	mov    (%eax),%eax
  80158f:	a3 48 51 80 00       	mov    %eax,0x805148
  801594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801597:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80159d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8015ac:	48                   	dec    %eax
  8015ad:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  8015b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8015bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015bf:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8015c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015ca:	75 14                	jne    8015e0 <initialize_dyn_block_system+0x175>
  8015cc:	83 ec 04             	sub    $0x4,%esp
  8015cf:	68 c0 3e 80 00       	push   $0x803ec0
  8015d4:	6a 3f                	push   $0x3f
  8015d6:	68 b3 3e 80 00       	push   $0x803eb3
  8015db:	e8 1c ee ff ff       	call   8003fc <_panic>
  8015e0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8015e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e9:	89 10                	mov    %edx,(%eax)
  8015eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ee:	8b 00                	mov    (%eax),%eax
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	74 0d                	je     801601 <initialize_dyn_block_system+0x196>
  8015f4:	a1 38 51 80 00       	mov    0x805138,%eax
  8015f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015fc:	89 50 04             	mov    %edx,0x4(%eax)
  8015ff:	eb 08                	jmp    801609 <initialize_dyn_block_system+0x19e>
  801601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801604:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801609:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160c:	a3 38 51 80 00       	mov    %eax,0x805138
  801611:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801614:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80161b:	a1 44 51 80 00       	mov    0x805144,%eax
  801620:	40                   	inc    %eax
  801621:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801626:	90                   	nop
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80162f:	e8 06 fe ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  801634:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801638:	75 07                	jne    801641 <malloc+0x18>
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
  80163f:	eb 7d                	jmp    8016be <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801641:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801648:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80164f:	8b 55 08             	mov    0x8(%ebp),%edx
  801652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801655:	01 d0                	add    %edx,%eax
  801657:	48                   	dec    %eax
  801658:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80165b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165e:	ba 00 00 00 00       	mov    $0x0,%edx
  801663:	f7 75 f0             	divl   -0x10(%ebp)
  801666:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801669:	29 d0                	sub    %edx,%eax
  80166b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  80166e:	e8 46 08 00 00       	call   801eb9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801673:	83 f8 01             	cmp    $0x1,%eax
  801676:	75 07                	jne    80167f <malloc+0x56>
  801678:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  80167f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801683:	75 34                	jne    8016b9 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	ff 75 e8             	pushl  -0x18(%ebp)
  80168b:	e8 73 0e 00 00       	call   802503 <alloc_block_FF>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801696:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80169a:	74 16                	je     8016b2 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016a2:	e8 ff 0b 00 00       	call   8022a6 <insert_sorted_allocList>
  8016a7:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8016aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ad:	8b 40 08             	mov    0x8(%eax),%eax
  8016b0:	eb 0c                	jmp    8016be <malloc+0x95>
	             }
	             else
	             	return NULL;
  8016b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b7:	eb 05                	jmp    8016be <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8016b9:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8016c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c9:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8016cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016da:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8016dd:	83 ec 08             	sub    $0x8,%esp
  8016e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e3:	68 40 50 80 00       	push   $0x805040
  8016e8:	e8 61 0b 00 00       	call   80224e <find_block>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8016f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016f7:	0f 84 a5 00 00 00    	je     8017a2 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8016fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801700:	8b 40 0c             	mov    0xc(%eax),%eax
  801703:	83 ec 08             	sub    $0x8,%esp
  801706:	50                   	push   %eax
  801707:	ff 75 f4             	pushl  -0xc(%ebp)
  80170a:	e8 a4 03 00 00       	call   801ab3 <sys_free_user_mem>
  80170f:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801712:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801716:	75 17                	jne    80172f <free+0x6f>
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	68 95 3e 80 00       	push   $0x803e95
  801720:	68 87 00 00 00       	push   $0x87
  801725:	68 b3 3e 80 00       	push   $0x803eb3
  80172a:	e8 cd ec ff ff       	call   8003fc <_panic>
  80172f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	85 c0                	test   %eax,%eax
  801736:	74 10                	je     801748 <free+0x88>
  801738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173b:	8b 00                	mov    (%eax),%eax
  80173d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801740:	8b 52 04             	mov    0x4(%edx),%edx
  801743:	89 50 04             	mov    %edx,0x4(%eax)
  801746:	eb 0b                	jmp    801753 <free+0x93>
  801748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174b:	8b 40 04             	mov    0x4(%eax),%eax
  80174e:	a3 44 50 80 00       	mov    %eax,0x805044
  801753:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801756:	8b 40 04             	mov    0x4(%eax),%eax
  801759:	85 c0                	test   %eax,%eax
  80175b:	74 0f                	je     80176c <free+0xac>
  80175d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801760:	8b 40 04             	mov    0x4(%eax),%eax
  801763:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801766:	8b 12                	mov    (%edx),%edx
  801768:	89 10                	mov    %edx,(%eax)
  80176a:	eb 0a                	jmp    801776 <free+0xb6>
  80176c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176f:	8b 00                	mov    (%eax),%eax
  801771:	a3 40 50 80 00       	mov    %eax,0x805040
  801776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80177f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801782:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801789:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80178e:	48                   	dec    %eax
  80178f:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801794:	83 ec 0c             	sub    $0xc,%esp
  801797:	ff 75 ec             	pushl  -0x14(%ebp)
  80179a:	e8 37 12 00 00       	call   8029d6 <insert_sorted_with_merge_freeList>
  80179f:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  8017a2:	90                   	nop
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 38             	sub    $0x38,%esp
  8017ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ae:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017b1:	e8 84 fc ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  8017b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017ba:	75 07                	jne    8017c3 <smalloc+0x1e>
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c1:	eb 7e                	jmp    801841 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8017c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8017ca:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d7:	01 d0                	add    %edx,%eax
  8017d9:	48                   	dec    %eax
  8017da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e5:	f7 75 f0             	divl   -0x10(%ebp)
  8017e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017eb:	29 d0                	sub    %edx,%eax
  8017ed:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8017f0:	e8 c4 06 00 00       	call   801eb9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017f5:	83 f8 01             	cmp    $0x1,%eax
  8017f8:	75 42                	jne    80183c <smalloc+0x97>

		  va = malloc(newsize) ;
  8017fa:	83 ec 0c             	sub    $0xc,%esp
  8017fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801800:	e8 24 fe ff ff       	call   801629 <malloc>
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  80180b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80180f:	74 24                	je     801835 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801811:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801815:	ff 75 e4             	pushl  -0x1c(%ebp)
  801818:	50                   	push   %eax
  801819:	ff 75 e8             	pushl  -0x18(%ebp)
  80181c:	ff 75 08             	pushl  0x8(%ebp)
  80181f:	e8 1a 04 00 00       	call   801c3e <sys_createSharedObject>
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  80182a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80182e:	78 0c                	js     80183c <smalloc+0x97>
					  return va ;
  801830:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801833:	eb 0c                	jmp    801841 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801835:	b8 00 00 00 00       	mov    $0x0,%eax
  80183a:	eb 05                	jmp    801841 <smalloc+0x9c>
	  }
		  return NULL ;
  80183c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801849:	e8 ec fb ff ff       	call   80143a <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  80184e:	83 ec 08             	sub    $0x8,%esp
  801851:	ff 75 0c             	pushl  0xc(%ebp)
  801854:	ff 75 08             	pushl  0x8(%ebp)
  801857:	e8 0c 04 00 00       	call   801c68 <sys_getSizeOfSharedObject>
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801862:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801866:	75 07                	jne    80186f <sget+0x2c>
  801868:	b8 00 00 00 00       	mov    $0x0,%eax
  80186d:	eb 75                	jmp    8018e4 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80186f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801876:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187c:	01 d0                	add    %edx,%eax
  80187e:	48                   	dec    %eax
  80187f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801885:	ba 00 00 00 00       	mov    $0x0,%edx
  80188a:	f7 75 f0             	divl   -0x10(%ebp)
  80188d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801890:	29 d0                	sub    %edx,%eax
  801892:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801895:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80189c:	e8 18 06 00 00       	call   801eb9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018a1:	83 f8 01             	cmp    $0x1,%eax
  8018a4:	75 39                	jne    8018df <sget+0x9c>

		  va = malloc(newsize) ;
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8018ac:	e8 78 fd ff ff       	call   801629 <malloc>
  8018b1:	83 c4 10             	add    $0x10,%esp
  8018b4:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8018b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018bb:	74 22                	je     8018df <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	ff 75 e0             	pushl  -0x20(%ebp)
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	ff 75 08             	pushl  0x8(%ebp)
  8018c9:	e8 b7 03 00 00       	call   801c85 <sys_getSharedObject>
  8018ce:	83 c4 10             	add    $0x10,%esp
  8018d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8018d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018d8:	78 05                	js     8018df <sget+0x9c>
					  return va;
  8018da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018dd:	eb 05                	jmp    8018e4 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8018df:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ec:	e8 49 fb ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	68 e4 3e 80 00       	push   $0x803ee4
  8018f9:	68 1e 01 00 00       	push   $0x11e
  8018fe:	68 b3 3e 80 00       	push   $0x803eb3
  801903:	e8 f4 ea ff ff       	call   8003fc <_panic>

00801908 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	68 0c 3f 80 00       	push   $0x803f0c
  801916:	68 32 01 00 00       	push   $0x132
  80191b:	68 b3 3e 80 00       	push   $0x803eb3
  801920:	e8 d7 ea ff ff       	call   8003fc <_panic>

00801925 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80192b:	83 ec 04             	sub    $0x4,%esp
  80192e:	68 30 3f 80 00       	push   $0x803f30
  801933:	68 3d 01 00 00       	push   $0x13d
  801938:	68 b3 3e 80 00       	push   $0x803eb3
  80193d:	e8 ba ea ff ff       	call   8003fc <_panic>

00801942 <shrink>:

}
void shrink(uint32 newSize)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801948:	83 ec 04             	sub    $0x4,%esp
  80194b:	68 30 3f 80 00       	push   $0x803f30
  801950:	68 42 01 00 00       	push   $0x142
  801955:	68 b3 3e 80 00       	push   $0x803eb3
  80195a:	e8 9d ea ff ff       	call   8003fc <_panic>

0080195f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801965:	83 ec 04             	sub    $0x4,%esp
  801968:	68 30 3f 80 00       	push   $0x803f30
  80196d:	68 47 01 00 00       	push   $0x147
  801972:	68 b3 3e 80 00       	push   $0x803eb3
  801977:	e8 80 ea ff ff       	call   8003fc <_panic>

0080197c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	57                   	push   %edi
  801980:	56                   	push   %esi
  801981:	53                   	push   %ebx
  801982:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801991:	8b 7d 18             	mov    0x18(%ebp),%edi
  801994:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801997:	cd 30                	int    $0x30
  801999:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80199c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	5b                   	pop    %ebx
  8019a3:	5e                   	pop    %esi
  8019a4:	5f                   	pop    %edi
  8019a5:	5d                   	pop    %ebp
  8019a6:	c3                   	ret    

008019a7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	52                   	push   %edx
  8019bf:	ff 75 0c             	pushl  0xc(%ebp)
  8019c2:	50                   	push   %eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	e8 b2 ff ff ff       	call   80197c <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	90                   	nop
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 01                	push   $0x1
  8019df:	e8 98 ff ff ff       	call   80197c <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	52                   	push   %edx
  8019f9:	50                   	push   %eax
  8019fa:	6a 05                	push   $0x5
  8019fc:	e8 7b ff ff ff       	call   80197c <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	56                   	push   %esi
  801a0a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a0b:	8b 75 18             	mov    0x18(%ebp),%esi
  801a0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	56                   	push   %esi
  801a1b:	53                   	push   %ebx
  801a1c:	51                   	push   %ecx
  801a1d:	52                   	push   %edx
  801a1e:	50                   	push   %eax
  801a1f:	6a 06                	push   $0x6
  801a21:	e8 56 ff ff ff       	call   80197c <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a2c:	5b                   	pop    %ebx
  801a2d:	5e                   	pop    %esi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	52                   	push   %edx
  801a40:	50                   	push   %eax
  801a41:	6a 07                	push   $0x7
  801a43:	e8 34 ff ff ff       	call   80197c <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	6a 08                	push   $0x8
  801a5e:	e8 19 ff ff ff       	call   80197c <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 09                	push   $0x9
  801a77:	e8 00 ff ff ff       	call   80197c <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 0a                	push   $0xa
  801a90:	e8 e7 fe ff ff       	call   80197c <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 0b                	push   $0xb
  801aa9:	e8 ce fe ff ff       	call   80197c <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	ff 75 0c             	pushl  0xc(%ebp)
  801abf:	ff 75 08             	pushl  0x8(%ebp)
  801ac2:	6a 0f                	push   $0xf
  801ac4:	e8 b3 fe ff ff       	call   80197c <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
	return;
  801acc:	90                   	nop
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	ff 75 08             	pushl  0x8(%ebp)
  801ade:	6a 10                	push   $0x10
  801ae0:	e8 97 fe ff ff       	call   80197c <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae8:	90                   	nop
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	ff 75 10             	pushl  0x10(%ebp)
  801af5:	ff 75 0c             	pushl  0xc(%ebp)
  801af8:	ff 75 08             	pushl  0x8(%ebp)
  801afb:	6a 11                	push   $0x11
  801afd:	e8 7a fe ff ff       	call   80197c <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
	return ;
  801b05:	90                   	nop
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 0c                	push   $0xc
  801b17:	e8 60 fe ff ff       	call   80197c <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	ff 75 08             	pushl  0x8(%ebp)
  801b2f:	6a 0d                	push   $0xd
  801b31:	e8 46 fe ff ff       	call   80197c <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 0e                	push   $0xe
  801b4a:	e8 2d fe ff ff       	call   80197c <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	90                   	nop
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 13                	push   $0x13
  801b64:	e8 13 fe ff ff       	call   80197c <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 14                	push   $0x14
  801b7e:	e8 f9 fd ff ff       	call   80197c <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	90                   	nop
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 04             	sub    $0x4,%esp
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b95:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	50                   	push   %eax
  801ba2:	6a 15                	push   $0x15
  801ba4:	e8 d3 fd ff ff       	call   80197c <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	90                   	nop
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 16                	push   $0x16
  801bbe:	e8 b9 fd ff ff       	call   80197c <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	90                   	nop
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	ff 75 0c             	pushl  0xc(%ebp)
  801bd8:	50                   	push   %eax
  801bd9:	6a 17                	push   $0x17
  801bdb:	e8 9c fd ff ff       	call   80197c <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	52                   	push   %edx
  801bf5:	50                   	push   %eax
  801bf6:	6a 1a                	push   $0x1a
  801bf8:	e8 7f fd ff ff       	call   80197c <syscall>
  801bfd:	83 c4 18             	add    $0x18,%esp
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	6a 18                	push   $0x18
  801c15:	e8 62 fd ff ff       	call   80197c <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	90                   	nop
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	52                   	push   %edx
  801c30:	50                   	push   %eax
  801c31:	6a 19                	push   $0x19
  801c33:	e8 44 fd ff ff       	call   80197c <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	90                   	nop
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	8b 45 10             	mov    0x10(%ebp),%eax
  801c47:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c4a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c4d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	6a 00                	push   $0x0
  801c56:	51                   	push   %ecx
  801c57:	52                   	push   %edx
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	50                   	push   %eax
  801c5c:	6a 1b                	push   $0x1b
  801c5e:	e8 19 fd ff ff       	call   80197c <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	52                   	push   %edx
  801c78:	50                   	push   %eax
  801c79:	6a 1c                	push   $0x1c
  801c7b:	e8 fc fc ff ff       	call   80197c <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	51                   	push   %ecx
  801c96:	52                   	push   %edx
  801c97:	50                   	push   %eax
  801c98:	6a 1d                	push   $0x1d
  801c9a:	e8 dd fc ff ff       	call   80197c <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	52                   	push   %edx
  801cb4:	50                   	push   %eax
  801cb5:	6a 1e                	push   $0x1e
  801cb7:	e8 c0 fc ff ff       	call   80197c <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 1f                	push   $0x1f
  801cd0:	e8 a7 fc ff ff       	call   80197c <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	ff 75 14             	pushl  0x14(%ebp)
  801ce5:	ff 75 10             	pushl  0x10(%ebp)
  801ce8:	ff 75 0c             	pushl  0xc(%ebp)
  801ceb:	50                   	push   %eax
  801cec:	6a 20                	push   $0x20
  801cee:	e8 89 fc ff ff       	call   80197c <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	50                   	push   %eax
  801d07:	6a 21                	push   $0x21
  801d09:	e8 6e fc ff ff       	call   80197c <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	90                   	nop
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	50                   	push   %eax
  801d23:	6a 22                	push   $0x22
  801d25:	e8 52 fc ff ff       	call   80197c <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 02                	push   $0x2
  801d3e:	e8 39 fc ff ff       	call   80197c <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 03                	push   $0x3
  801d57:	e8 20 fc ff ff       	call   80197c <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 04                	push   $0x4
  801d70:	e8 07 fc ff ff       	call   80197c <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_exit_env>:


void sys_exit_env(void)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 23                	push   $0x23
  801d89:	e8 ee fb ff ff       	call   80197c <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	90                   	nop
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d9d:	8d 50 04             	lea    0x4(%eax),%edx
  801da0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	6a 24                	push   $0x24
  801dad:	e8 ca fb ff ff       	call   80197c <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
	return result;
  801db5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dbe:	89 01                	mov    %eax,(%ecx)
  801dc0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	c9                   	leave  
  801dc7:	c2 04 00             	ret    $0x4

00801dca <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	ff 75 10             	pushl  0x10(%ebp)
  801dd4:	ff 75 0c             	pushl  0xc(%ebp)
  801dd7:	ff 75 08             	pushl  0x8(%ebp)
  801dda:	6a 12                	push   $0x12
  801ddc:	e8 9b fb ff ff       	call   80197c <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
	return ;
  801de4:	90                   	nop
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 25                	push   $0x25
  801df6:	e8 81 fb ff ff       	call   80197c <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 04             	sub    $0x4,%esp
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e0c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	50                   	push   %eax
  801e19:	6a 26                	push   $0x26
  801e1b:	e8 5c fb ff ff       	call   80197c <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
	return ;
  801e23:	90                   	nop
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <rsttst>:
void rsttst()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 28                	push   $0x28
  801e35:	e8 42 fb ff ff       	call   80197c <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3d:	90                   	nop
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	8b 45 14             	mov    0x14(%ebp),%eax
  801e49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e4c:	8b 55 18             	mov    0x18(%ebp),%edx
  801e4f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e53:	52                   	push   %edx
  801e54:	50                   	push   %eax
  801e55:	ff 75 10             	pushl  0x10(%ebp)
  801e58:	ff 75 0c             	pushl  0xc(%ebp)
  801e5b:	ff 75 08             	pushl  0x8(%ebp)
  801e5e:	6a 27                	push   $0x27
  801e60:	e8 17 fb ff ff       	call   80197c <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
	return ;
  801e68:	90                   	nop
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <chktst>:
void chktst(uint32 n)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	ff 75 08             	pushl  0x8(%ebp)
  801e79:	6a 29                	push   $0x29
  801e7b:	e8 fc fa ff ff       	call   80197c <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
	return ;
  801e83:	90                   	nop
}
  801e84:	c9                   	leave  
  801e85:	c3                   	ret    

00801e86 <inctst>:

void inctst()
{
  801e86:	55                   	push   %ebp
  801e87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 2a                	push   $0x2a
  801e95:	e8 e2 fa ff ff       	call   80197c <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9d:	90                   	nop
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <gettst>:
uint32 gettst()
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 2b                	push   $0x2b
  801eaf:	e8 c8 fa ff ff       	call   80197c <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 2c                	push   $0x2c
  801ecb:	e8 ac fa ff ff       	call   80197c <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
  801ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ed6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801eda:	75 07                	jne    801ee3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801edc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee1:	eb 05                	jmp    801ee8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 2c                	push   $0x2c
  801efc:	e8 7b fa ff ff       	call   80197c <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
  801f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f07:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f0b:	75 07                	jne    801f14 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f12:	eb 05                	jmp    801f19 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 2c                	push   $0x2c
  801f2d:	e8 4a fa ff ff       	call   80197c <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
  801f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f38:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f3c:	75 07                	jne    801f45 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f43:	eb 05                	jmp    801f4a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 2c                	push   $0x2c
  801f5e:	e8 19 fa ff ff       	call   80197c <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
  801f66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f69:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f6d:	75 07                	jne    801f76 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801f74:	eb 05                	jmp    801f7b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	ff 75 08             	pushl  0x8(%ebp)
  801f8b:	6a 2d                	push   $0x2d
  801f8d:	e8 ea f9 ff ff       	call   80197c <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
	return ;
  801f95:	90                   	nop
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f9c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	6a 00                	push   $0x0
  801faa:	53                   	push   %ebx
  801fab:	51                   	push   %ecx
  801fac:	52                   	push   %edx
  801fad:	50                   	push   %eax
  801fae:	6a 2e                	push   $0x2e
  801fb0:	e8 c7 f9 ff ff       	call   80197c <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	52                   	push   %edx
  801fcd:	50                   	push   %eax
  801fce:	6a 2f                	push   $0x2f
  801fd0:	e8 a7 f9 ff ff       	call   80197c <syscall>
  801fd5:	83 c4 18             	add    $0x18,%esp
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fe0:	83 ec 0c             	sub    $0xc,%esp
  801fe3:	68 40 3f 80 00       	push   $0x803f40
  801fe8:	e8 c3 e6 ff ff       	call   8006b0 <cprintf>
  801fed:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ff0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ff7:	83 ec 0c             	sub    $0xc,%esp
  801ffa:	68 6c 3f 80 00       	push   $0x803f6c
  801fff:	e8 ac e6 ff ff       	call   8006b0 <cprintf>
  802004:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802007:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80200b:	a1 38 51 80 00       	mov    0x805138,%eax
  802010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802013:	eb 56                	jmp    80206b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802015:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802019:	74 1c                	je     802037 <print_mem_block_lists+0x5d>
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	8b 50 08             	mov    0x8(%eax),%edx
  802021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802024:	8b 48 08             	mov    0x8(%eax),%ecx
  802027:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202a:	8b 40 0c             	mov    0xc(%eax),%eax
  80202d:	01 c8                	add    %ecx,%eax
  80202f:	39 c2                	cmp    %eax,%edx
  802031:	73 04                	jae    802037 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802033:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	8b 50 08             	mov    0x8(%eax),%edx
  80203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802040:	8b 40 0c             	mov    0xc(%eax),%eax
  802043:	01 c2                	add    %eax,%edx
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	8b 40 08             	mov    0x8(%eax),%eax
  80204b:	83 ec 04             	sub    $0x4,%esp
  80204e:	52                   	push   %edx
  80204f:	50                   	push   %eax
  802050:	68 81 3f 80 00       	push   $0x803f81
  802055:	e8 56 e6 ff ff       	call   8006b0 <cprintf>
  80205a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802063:	a1 40 51 80 00       	mov    0x805140,%eax
  802068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80206b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206f:	74 07                	je     802078 <print_mem_block_lists+0x9e>
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	8b 00                	mov    (%eax),%eax
  802076:	eb 05                	jmp    80207d <print_mem_block_lists+0xa3>
  802078:	b8 00 00 00 00       	mov    $0x0,%eax
  80207d:	a3 40 51 80 00       	mov    %eax,0x805140
  802082:	a1 40 51 80 00       	mov    0x805140,%eax
  802087:	85 c0                	test   %eax,%eax
  802089:	75 8a                	jne    802015 <print_mem_block_lists+0x3b>
  80208b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208f:	75 84                	jne    802015 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802091:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802095:	75 10                	jne    8020a7 <print_mem_block_lists+0xcd>
  802097:	83 ec 0c             	sub    $0xc,%esp
  80209a:	68 90 3f 80 00       	push   $0x803f90
  80209f:	e8 0c e6 ff ff       	call   8006b0 <cprintf>
  8020a4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020ae:	83 ec 0c             	sub    $0xc,%esp
  8020b1:	68 b4 3f 80 00       	push   $0x803fb4
  8020b6:	e8 f5 e5 ff ff       	call   8006b0 <cprintf>
  8020bb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020be:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020c2:	a1 40 50 80 00       	mov    0x805040,%eax
  8020c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ca:	eb 56                	jmp    802122 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d0:	74 1c                	je     8020ee <print_mem_block_lists+0x114>
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 50 08             	mov    0x8(%eax),%edx
  8020d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020db:	8b 48 08             	mov    0x8(%eax),%ecx
  8020de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e4:	01 c8                	add    %ecx,%eax
  8020e6:	39 c2                	cmp    %eax,%edx
  8020e8:	73 04                	jae    8020ee <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020ea:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	8b 50 08             	mov    0x8(%eax),%edx
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020fa:	01 c2                	add    %eax,%edx
  8020fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ff:	8b 40 08             	mov    0x8(%eax),%eax
  802102:	83 ec 04             	sub    $0x4,%esp
  802105:	52                   	push   %edx
  802106:	50                   	push   %eax
  802107:	68 81 3f 80 00       	push   $0x803f81
  80210c:	e8 9f e5 ff ff       	call   8006b0 <cprintf>
  802111:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80211a:	a1 48 50 80 00       	mov    0x805048,%eax
  80211f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802126:	74 07                	je     80212f <print_mem_block_lists+0x155>
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 00                	mov    (%eax),%eax
  80212d:	eb 05                	jmp    802134 <print_mem_block_lists+0x15a>
  80212f:	b8 00 00 00 00       	mov    $0x0,%eax
  802134:	a3 48 50 80 00       	mov    %eax,0x805048
  802139:	a1 48 50 80 00       	mov    0x805048,%eax
  80213e:	85 c0                	test   %eax,%eax
  802140:	75 8a                	jne    8020cc <print_mem_block_lists+0xf2>
  802142:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802146:	75 84                	jne    8020cc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802148:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80214c:	75 10                	jne    80215e <print_mem_block_lists+0x184>
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	68 cc 3f 80 00       	push   $0x803fcc
  802156:	e8 55 e5 ff ff       	call   8006b0 <cprintf>
  80215b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80215e:	83 ec 0c             	sub    $0xc,%esp
  802161:	68 40 3f 80 00       	push   $0x803f40
  802166:	e8 45 e5 ff ff       	call   8006b0 <cprintf>
  80216b:	83 c4 10             	add    $0x10,%esp

}
  80216e:	90                   	nop
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802177:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80217e:	00 00 00 
  802181:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802188:	00 00 00 
  80218b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802192:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802195:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80219c:	e9 9e 00 00 00       	jmp    80223f <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8021a1:	a1 50 50 80 00       	mov    0x805050,%eax
  8021a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a9:	c1 e2 04             	shl    $0x4,%edx
  8021ac:	01 d0                	add    %edx,%eax
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	75 14                	jne    8021c6 <initialize_MemBlocksList+0x55>
  8021b2:	83 ec 04             	sub    $0x4,%esp
  8021b5:	68 f4 3f 80 00       	push   $0x803ff4
  8021ba:	6a 47                	push   $0x47
  8021bc:	68 17 40 80 00       	push   $0x804017
  8021c1:	e8 36 e2 ff ff       	call   8003fc <_panic>
  8021c6:	a1 50 50 80 00       	mov    0x805050,%eax
  8021cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ce:	c1 e2 04             	shl    $0x4,%edx
  8021d1:	01 d0                	add    %edx,%eax
  8021d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8021d9:	89 10                	mov    %edx,(%eax)
  8021db:	8b 00                	mov    (%eax),%eax
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	74 18                	je     8021f9 <initialize_MemBlocksList+0x88>
  8021e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8021e6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8021ec:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021ef:	c1 e1 04             	shl    $0x4,%ecx
  8021f2:	01 ca                	add    %ecx,%edx
  8021f4:	89 50 04             	mov    %edx,0x4(%eax)
  8021f7:	eb 12                	jmp    80220b <initialize_MemBlocksList+0x9a>
  8021f9:	a1 50 50 80 00       	mov    0x805050,%eax
  8021fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802201:	c1 e2 04             	shl    $0x4,%edx
  802204:	01 d0                	add    %edx,%eax
  802206:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80220b:	a1 50 50 80 00       	mov    0x805050,%eax
  802210:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802213:	c1 e2 04             	shl    $0x4,%edx
  802216:	01 d0                	add    %edx,%eax
  802218:	a3 48 51 80 00       	mov    %eax,0x805148
  80221d:	a1 50 50 80 00       	mov    0x805050,%eax
  802222:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802225:	c1 e2 04             	shl    $0x4,%edx
  802228:	01 d0                	add    %edx,%eax
  80222a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802231:	a1 54 51 80 00       	mov    0x805154,%eax
  802236:	40                   	inc    %eax
  802237:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80223c:	ff 45 f4             	incl   -0xc(%ebp)
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	3b 45 08             	cmp    0x8(%ebp),%eax
  802245:	0f 82 56 ff ff ff    	jb     8021a1 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80224b:	90                   	nop
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80225c:	eb 19                	jmp    802277 <find_block+0x29>
	{
		if(element->sva == va){
  80225e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802261:	8b 40 08             	mov    0x8(%eax),%eax
  802264:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802267:	75 05                	jne    80226e <find_block+0x20>
			 		return element;
  802269:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80226c:	eb 36                	jmp    8022a4 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	8b 40 08             	mov    0x8(%eax),%eax
  802274:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802277:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80227b:	74 07                	je     802284 <find_block+0x36>
  80227d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802280:	8b 00                	mov    (%eax),%eax
  802282:	eb 05                	jmp    802289 <find_block+0x3b>
  802284:	b8 00 00 00 00       	mov    $0x0,%eax
  802289:	8b 55 08             	mov    0x8(%ebp),%edx
  80228c:	89 42 08             	mov    %eax,0x8(%edx)
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	8b 40 08             	mov    0x8(%eax),%eax
  802295:	85 c0                	test   %eax,%eax
  802297:	75 c5                	jne    80225e <find_block+0x10>
  802299:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80229d:	75 bf                	jne    80225e <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8022ac:	a1 44 50 80 00       	mov    0x805044,%eax
  8022b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8022b4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8022bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022c0:	74 0a                	je     8022cc <insert_sorted_allocList+0x26>
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	8b 40 08             	mov    0x8(%eax),%eax
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	75 65                	jne    802331 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8022cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d0:	75 14                	jne    8022e6 <insert_sorted_allocList+0x40>
  8022d2:	83 ec 04             	sub    $0x4,%esp
  8022d5:	68 f4 3f 80 00       	push   $0x803ff4
  8022da:	6a 6e                	push   $0x6e
  8022dc:	68 17 40 80 00       	push   $0x804017
  8022e1:	e8 16 e1 ff ff       	call   8003fc <_panic>
  8022e6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	89 10                	mov    %edx,(%eax)
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	74 0d                	je     802307 <insert_sorted_allocList+0x61>
  8022fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8022ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802302:	89 50 04             	mov    %edx,0x4(%eax)
  802305:	eb 08                	jmp    80230f <insert_sorted_allocList+0x69>
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	a3 44 50 80 00       	mov    %eax,0x805044
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	a3 40 50 80 00       	mov    %eax,0x805040
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802321:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802326:	40                   	inc    %eax
  802327:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80232c:	e9 cf 01 00 00       	jmp    802500 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802334:	8b 50 08             	mov    0x8(%eax),%edx
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	8b 40 08             	mov    0x8(%eax),%eax
  80233d:	39 c2                	cmp    %eax,%edx
  80233f:	73 65                	jae    8023a6 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802341:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802345:	75 14                	jne    80235b <insert_sorted_allocList+0xb5>
  802347:	83 ec 04             	sub    $0x4,%esp
  80234a:	68 30 40 80 00       	push   $0x804030
  80234f:	6a 72                	push   $0x72
  802351:	68 17 40 80 00       	push   $0x804017
  802356:	e8 a1 e0 ff ff       	call   8003fc <_panic>
  80235b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802361:	8b 45 08             	mov    0x8(%ebp),%eax
  802364:	89 50 04             	mov    %edx,0x4(%eax)
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	8b 40 04             	mov    0x4(%eax),%eax
  80236d:	85 c0                	test   %eax,%eax
  80236f:	74 0c                	je     80237d <insert_sorted_allocList+0xd7>
  802371:	a1 44 50 80 00       	mov    0x805044,%eax
  802376:	8b 55 08             	mov    0x8(%ebp),%edx
  802379:	89 10                	mov    %edx,(%eax)
  80237b:	eb 08                	jmp    802385 <insert_sorted_allocList+0xdf>
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	a3 40 50 80 00       	mov    %eax,0x805040
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	a3 44 50 80 00       	mov    %eax,0x805044
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802396:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80239b:	40                   	inc    %eax
  80239c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8023a1:	e9 5a 01 00 00       	jmp    802500 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8023a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a9:	8b 50 08             	mov    0x8(%eax),%edx
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	8b 40 08             	mov    0x8(%eax),%eax
  8023b2:	39 c2                	cmp    %eax,%edx
  8023b4:	75 70                	jne    802426 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8023b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ba:	74 06                	je     8023c2 <insert_sorted_allocList+0x11c>
  8023bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c0:	75 14                	jne    8023d6 <insert_sorted_allocList+0x130>
  8023c2:	83 ec 04             	sub    $0x4,%esp
  8023c5:	68 54 40 80 00       	push   $0x804054
  8023ca:	6a 75                	push   $0x75
  8023cc:	68 17 40 80 00       	push   $0x804017
  8023d1:	e8 26 e0 ff ff       	call   8003fc <_panic>
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	8b 10                	mov    (%eax),%edx
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	89 10                	mov    %edx,(%eax)
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	8b 00                	mov    (%eax),%eax
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	74 0b                	je     8023f4 <insert_sorted_allocList+0x14e>
  8023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f1:	89 50 04             	mov    %edx,0x4(%eax)
  8023f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fa:	89 10                	mov    %edx,(%eax)
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802402:	89 50 04             	mov    %edx,0x4(%eax)
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	75 08                	jne    802416 <insert_sorted_allocList+0x170>
  80240e:	8b 45 08             	mov    0x8(%ebp),%eax
  802411:	a3 44 50 80 00       	mov    %eax,0x805044
  802416:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80241b:	40                   	inc    %eax
  80241c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802421:	e9 da 00 00 00       	jmp    802500 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802426:	a1 40 50 80 00       	mov    0x805040,%eax
  80242b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242e:	e9 9d 00 00 00       	jmp    8024d0 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	8b 50 08             	mov    0x8(%eax),%edx
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	8b 40 08             	mov    0x8(%eax),%eax
  802447:	39 c2                	cmp    %eax,%edx
  802449:	76 7d                	jbe    8024c8 <insert_sorted_allocList+0x222>
  80244b:	8b 45 08             	mov    0x8(%ebp),%eax
  80244e:	8b 50 08             	mov    0x8(%eax),%edx
  802451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802454:	8b 40 08             	mov    0x8(%eax),%eax
  802457:	39 c2                	cmp    %eax,%edx
  802459:	73 6d                	jae    8024c8 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80245b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245f:	74 06                	je     802467 <insert_sorted_allocList+0x1c1>
  802461:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802465:	75 14                	jne    80247b <insert_sorted_allocList+0x1d5>
  802467:	83 ec 04             	sub    $0x4,%esp
  80246a:	68 54 40 80 00       	push   $0x804054
  80246f:	6a 7c                	push   $0x7c
  802471:	68 17 40 80 00       	push   $0x804017
  802476:	e8 81 df ff ff       	call   8003fc <_panic>
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 10                	mov    (%eax),%edx
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	89 10                	mov    %edx,(%eax)
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	8b 00                	mov    (%eax),%eax
  80248a:	85 c0                	test   %eax,%eax
  80248c:	74 0b                	je     802499 <insert_sorted_allocList+0x1f3>
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 00                	mov    (%eax),%eax
  802493:	8b 55 08             	mov    0x8(%ebp),%edx
  802496:	89 50 04             	mov    %edx,0x4(%eax)
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 55 08             	mov    0x8(%ebp),%edx
  80249f:	89 10                	mov    %edx,(%eax)
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a7:	89 50 04             	mov    %edx,0x4(%eax)
  8024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	75 08                	jne    8024bb <insert_sorted_allocList+0x215>
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	a3 44 50 80 00       	mov    %eax,0x805044
  8024bb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024c0:	40                   	inc    %eax
  8024c1:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8024c6:	eb 38                	jmp    802500 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8024c8:	a1 48 50 80 00       	mov    0x805048,%eax
  8024cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d4:	74 07                	je     8024dd <insert_sorted_allocList+0x237>
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	eb 05                	jmp    8024e2 <insert_sorted_allocList+0x23c>
  8024dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e2:	a3 48 50 80 00       	mov    %eax,0x805048
  8024e7:	a1 48 50 80 00       	mov    0x805048,%eax
  8024ec:	85 c0                	test   %eax,%eax
  8024ee:	0f 85 3f ff ff ff    	jne    802433 <insert_sorted_allocList+0x18d>
  8024f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f8:	0f 85 35 ff ff ff    	jne    802433 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8024fe:	eb 00                	jmp    802500 <insert_sorted_allocList+0x25a>
  802500:	90                   	nop
  802501:	c9                   	leave  
  802502:	c3                   	ret    

00802503 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802509:	a1 38 51 80 00       	mov    0x805138,%eax
  80250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802511:	e9 6b 02 00 00       	jmp    802781 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 40 0c             	mov    0xc(%eax),%eax
  80251c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251f:	0f 85 90 00 00 00    	jne    8025b5 <alloc_block_FF+0xb2>
			  temp=element;
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  80252b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252f:	75 17                	jne    802548 <alloc_block_FF+0x45>
  802531:	83 ec 04             	sub    $0x4,%esp
  802534:	68 88 40 80 00       	push   $0x804088
  802539:	68 92 00 00 00       	push   $0x92
  80253e:	68 17 40 80 00       	push   $0x804017
  802543:	e8 b4 de ff ff       	call   8003fc <_panic>
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 00                	mov    (%eax),%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	74 10                	je     802561 <alloc_block_FF+0x5e>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 00                	mov    (%eax),%eax
  802556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802559:	8b 52 04             	mov    0x4(%edx),%edx
  80255c:	89 50 04             	mov    %edx,0x4(%eax)
  80255f:	eb 0b                	jmp    80256c <alloc_block_FF+0x69>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 40 04             	mov    0x4(%eax),%eax
  802572:	85 c0                	test   %eax,%eax
  802574:	74 0f                	je     802585 <alloc_block_FF+0x82>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 04             	mov    0x4(%eax),%eax
  80257c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257f:	8b 12                	mov    (%edx),%edx
  802581:	89 10                	mov    %edx,(%eax)
  802583:	eb 0a                	jmp    80258f <alloc_block_FF+0x8c>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	a3 38 51 80 00       	mov    %eax,0x805138
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8025a7:	48                   	dec    %eax
  8025a8:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  8025ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b0:	e9 ff 01 00 00       	jmp    8027b4 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025be:	0f 86 b5 01 00 00    	jbe    802779 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ca:	2b 45 08             	sub    0x8(%ebp),%eax
  8025cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8025d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8025d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8025d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025dc:	75 17                	jne    8025f5 <alloc_block_FF+0xf2>
  8025de:	83 ec 04             	sub    $0x4,%esp
  8025e1:	68 88 40 80 00       	push   $0x804088
  8025e6:	68 99 00 00 00       	push   $0x99
  8025eb:	68 17 40 80 00       	push   $0x804017
  8025f0:	e8 07 de ff ff       	call   8003fc <_panic>
  8025f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f8:	8b 00                	mov    (%eax),%eax
  8025fa:	85 c0                	test   %eax,%eax
  8025fc:	74 10                	je     80260e <alloc_block_FF+0x10b>
  8025fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802606:	8b 52 04             	mov    0x4(%edx),%edx
  802609:	89 50 04             	mov    %edx,0x4(%eax)
  80260c:	eb 0b                	jmp    802619 <alloc_block_FF+0x116>
  80260e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802611:	8b 40 04             	mov    0x4(%eax),%eax
  802614:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261c:	8b 40 04             	mov    0x4(%eax),%eax
  80261f:	85 c0                	test   %eax,%eax
  802621:	74 0f                	je     802632 <alloc_block_FF+0x12f>
  802623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802626:	8b 40 04             	mov    0x4(%eax),%eax
  802629:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80262c:	8b 12                	mov    (%edx),%edx
  80262e:	89 10                	mov    %edx,(%eax)
  802630:	eb 0a                	jmp    80263c <alloc_block_FF+0x139>
  802632:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	a3 48 51 80 00       	mov    %eax,0x805148
  80263c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802648:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264f:	a1 54 51 80 00       	mov    0x805154,%eax
  802654:	48                   	dec    %eax
  802655:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80265a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80265e:	75 17                	jne    802677 <alloc_block_FF+0x174>
  802660:	83 ec 04             	sub    $0x4,%esp
  802663:	68 30 40 80 00       	push   $0x804030
  802668:	68 9a 00 00 00       	push   $0x9a
  80266d:	68 17 40 80 00       	push   $0x804017
  802672:	e8 85 dd ff ff       	call   8003fc <_panic>
  802677:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80267d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802680:	89 50 04             	mov    %edx,0x4(%eax)
  802683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802686:	8b 40 04             	mov    0x4(%eax),%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	74 0c                	je     802699 <alloc_block_FF+0x196>
  80268d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802692:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802695:	89 10                	mov    %edx,(%eax)
  802697:	eb 08                	jmp    8026a1 <alloc_block_FF+0x19e>
  802699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269c:	a3 38 51 80 00       	mov    %eax,0x805138
  8026a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8026b7:	40                   	inc    %eax
  8026b8:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  8026bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c3:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8026c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c9:	8b 50 08             	mov    0x8(%eax),%edx
  8026cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cf:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d8:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	8b 50 08             	mov    0x8(%eax),%edx
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	01 c2                	add    %eax,%edx
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8026ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8026f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026f6:	75 17                	jne    80270f <alloc_block_FF+0x20c>
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	68 88 40 80 00       	push   $0x804088
  802700:	68 a2 00 00 00       	push   $0xa2
  802705:	68 17 40 80 00       	push   $0x804017
  80270a:	e8 ed dc ff ff       	call   8003fc <_panic>
  80270f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	85 c0                	test   %eax,%eax
  802716:	74 10                	je     802728 <alloc_block_FF+0x225>
  802718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802720:	8b 52 04             	mov    0x4(%edx),%edx
  802723:	89 50 04             	mov    %edx,0x4(%eax)
  802726:	eb 0b                	jmp    802733 <alloc_block_FF+0x230>
  802728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272b:	8b 40 04             	mov    0x4(%eax),%eax
  80272e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802733:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802736:	8b 40 04             	mov    0x4(%eax),%eax
  802739:	85 c0                	test   %eax,%eax
  80273b:	74 0f                	je     80274c <alloc_block_FF+0x249>
  80273d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802740:	8b 40 04             	mov    0x4(%eax),%eax
  802743:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802746:	8b 12                	mov    (%edx),%edx
  802748:	89 10                	mov    %edx,(%eax)
  80274a:	eb 0a                	jmp    802756 <alloc_block_FF+0x253>
  80274c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274f:	8b 00                	mov    (%eax),%eax
  802751:	a3 38 51 80 00       	mov    %eax,0x805138
  802756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802759:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802762:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802769:	a1 44 51 80 00       	mov    0x805144,%eax
  80276e:	48                   	dec    %eax
  80276f:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802774:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802777:	eb 3b                	jmp    8027b4 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802779:	a1 40 51 80 00       	mov    0x805140,%eax
  80277e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802785:	74 07                	je     80278e <alloc_block_FF+0x28b>
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 00                	mov    (%eax),%eax
  80278c:	eb 05                	jmp    802793 <alloc_block_FF+0x290>
  80278e:	b8 00 00 00 00       	mov    $0x0,%eax
  802793:	a3 40 51 80 00       	mov    %eax,0x805140
  802798:	a1 40 51 80 00       	mov    0x805140,%eax
  80279d:	85 c0                	test   %eax,%eax
  80279f:	0f 85 71 fd ff ff    	jne    802516 <alloc_block_FF+0x13>
  8027a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a9:	0f 85 67 fd ff ff    	jne    802516 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8027bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8027c3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8027ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8027cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027d2:	e9 d3 00 00 00       	jmp    8028aa <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8027d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027da:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e0:	0f 85 90 00 00 00    	jne    802876 <alloc_block_BF+0xc0>
	   temp = element;
  8027e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e9:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8027ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027f0:	75 17                	jne    802809 <alloc_block_BF+0x53>
  8027f2:	83 ec 04             	sub    $0x4,%esp
  8027f5:	68 88 40 80 00       	push   $0x804088
  8027fa:	68 bd 00 00 00       	push   $0xbd
  8027ff:	68 17 40 80 00       	push   $0x804017
  802804:	e8 f3 db ff ff       	call   8003fc <_panic>
  802809:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280c:	8b 00                	mov    (%eax),%eax
  80280e:	85 c0                	test   %eax,%eax
  802810:	74 10                	je     802822 <alloc_block_BF+0x6c>
  802812:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80281a:	8b 52 04             	mov    0x4(%edx),%edx
  80281d:	89 50 04             	mov    %edx,0x4(%eax)
  802820:	eb 0b                	jmp    80282d <alloc_block_BF+0x77>
  802822:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802825:	8b 40 04             	mov    0x4(%eax),%eax
  802828:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80282d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802830:	8b 40 04             	mov    0x4(%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 0f                	je     802846 <alloc_block_BF+0x90>
  802837:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80283a:	8b 40 04             	mov    0x4(%eax),%eax
  80283d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802840:	8b 12                	mov    (%edx),%edx
  802842:	89 10                	mov    %edx,(%eax)
  802844:	eb 0a                	jmp    802850 <alloc_block_BF+0x9a>
  802846:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	a3 38 51 80 00       	mov    %eax,0x805138
  802850:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802853:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802859:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80285c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802863:	a1 44 51 80 00       	mov    0x805144,%eax
  802868:	48                   	dec    %eax
  802869:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  80286e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802871:	e9 41 01 00 00       	jmp    8029b7 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802879:	8b 40 0c             	mov    0xc(%eax),%eax
  80287c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287f:	76 21                	jbe    8028a2 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802881:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802884:	8b 40 0c             	mov    0xc(%eax),%eax
  802887:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80288a:	73 16                	jae    8028a2 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  80288c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80288f:	8b 40 0c             	mov    0xc(%eax),%eax
  802892:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802898:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80289b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8028a2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ae:	74 07                	je     8028b7 <alloc_block_BF+0x101>
  8028b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b3:	8b 00                	mov    (%eax),%eax
  8028b5:	eb 05                	jmp    8028bc <alloc_block_BF+0x106>
  8028b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bc:	a3 40 51 80 00       	mov    %eax,0x805140
  8028c1:	a1 40 51 80 00       	mov    0x805140,%eax
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	0f 85 09 ff ff ff    	jne    8027d7 <alloc_block_BF+0x21>
  8028ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028d2:	0f 85 ff fe ff ff    	jne    8027d7 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8028d8:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8028dc:	0f 85 d0 00 00 00    	jne    8029b2 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8028e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e8:	2b 45 08             	sub    0x8(%ebp),%eax
  8028eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8028ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8028f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8028f6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028fa:	75 17                	jne    802913 <alloc_block_BF+0x15d>
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	68 88 40 80 00       	push   $0x804088
  802904:	68 d1 00 00 00       	push   $0xd1
  802909:	68 17 40 80 00       	push   $0x804017
  80290e:	e8 e9 da ff ff       	call   8003fc <_panic>
  802913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	85 c0                	test   %eax,%eax
  80291a:	74 10                	je     80292c <alloc_block_BF+0x176>
  80291c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802924:	8b 52 04             	mov    0x4(%edx),%edx
  802927:	89 50 04             	mov    %edx,0x4(%eax)
  80292a:	eb 0b                	jmp    802937 <alloc_block_BF+0x181>
  80292c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292f:	8b 40 04             	mov    0x4(%eax),%eax
  802932:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802937:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 0f                	je     802950 <alloc_block_BF+0x19a>
  802941:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802944:	8b 40 04             	mov    0x4(%eax),%eax
  802947:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80294a:	8b 12                	mov    (%edx),%edx
  80294c:	89 10                	mov    %edx,(%eax)
  80294e:	eb 0a                	jmp    80295a <alloc_block_BF+0x1a4>
  802950:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	a3 48 51 80 00       	mov    %eax,0x805148
  80295a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802963:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802966:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296d:	a1 54 51 80 00       	mov    0x805154,%eax
  802972:	48                   	dec    %eax
  802973:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802978:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297b:	8b 55 08             	mov    0x8(%ebp),%edx
  80297e:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802981:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802984:	8b 50 08             	mov    0x8(%eax),%edx
  802987:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298a:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  80298d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802990:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802993:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802996:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802999:	8b 50 08             	mov    0x8(%eax),%edx
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	01 c2                	add    %eax,%edx
  8029a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a4:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  8029a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8029ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029b0:	eb 05                	jmp    8029b7 <alloc_block_BF+0x201>
	 }
	 return NULL;
  8029b2:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8029b7:	c9                   	leave  
  8029b8:	c3                   	ret    

008029b9 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029b9:	55                   	push   %ebp
  8029ba:	89 e5                	mov    %esp,%ebp
  8029bc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8029bf:	83 ec 04             	sub    $0x4,%esp
  8029c2:	68 a8 40 80 00       	push   $0x8040a8
  8029c7:	68 e8 00 00 00       	push   $0xe8
  8029cc:	68 17 40 80 00       	push   $0x804017
  8029d1:	e8 26 da ff ff       	call   8003fc <_panic>

008029d6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
  8029d9:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8029dc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8029e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8029e4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8029ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8029f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8029f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f8:	75 68                	jne    802a62 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fe:	75 17                	jne    802a17 <insert_sorted_with_merge_freeList+0x41>
  802a00:	83 ec 04             	sub    $0x4,%esp
  802a03:	68 f4 3f 80 00       	push   $0x803ff4
  802a08:	68 36 01 00 00       	push   $0x136
  802a0d:	68 17 40 80 00       	push   $0x804017
  802a12:	e8 e5 d9 ff ff       	call   8003fc <_panic>
  802a17:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	89 10                	mov    %edx,(%eax)
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	74 0d                	je     802a38 <insert_sorted_with_merge_freeList+0x62>
  802a2b:	a1 38 51 80 00       	mov    0x805138,%eax
  802a30:	8b 55 08             	mov    0x8(%ebp),%edx
  802a33:	89 50 04             	mov    %edx,0x4(%eax)
  802a36:	eb 08                	jmp    802a40 <insert_sorted_with_merge_freeList+0x6a>
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	a3 38 51 80 00       	mov    %eax,0x805138
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a52:	a1 44 51 80 00       	mov    0x805144,%eax
  802a57:	40                   	inc    %eax
  802a58:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802a5d:	e9 ba 06 00 00       	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a65:	8b 50 08             	mov    0x8(%eax),%edx
  802a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6e:	01 c2                	add    %eax,%edx
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	8b 40 08             	mov    0x8(%eax),%eax
  802a76:	39 c2                	cmp    %eax,%edx
  802a78:	73 68                	jae    802ae2 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7e:	75 17                	jne    802a97 <insert_sorted_with_merge_freeList+0xc1>
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	68 30 40 80 00       	push   $0x804030
  802a88:	68 3a 01 00 00       	push   $0x13a
  802a8d:	68 17 40 80 00       	push   $0x804017
  802a92:	e8 65 d9 ff ff       	call   8003fc <_panic>
  802a97:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	89 50 04             	mov    %edx,0x4(%eax)
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	8b 40 04             	mov    0x4(%eax),%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	74 0c                	je     802ab9 <insert_sorted_with_merge_freeList+0xe3>
  802aad:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab5:	89 10                	mov    %edx,(%eax)
  802ab7:	eb 08                	jmp    802ac1 <insert_sorted_with_merge_freeList+0xeb>
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	a3 38 51 80 00       	mov    %eax,0x805138
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ad7:	40                   	inc    %eax
  802ad8:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802add:	e9 3a 06 00 00       	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae5:	8b 50 08             	mov    0x8(%eax),%edx
  802ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802aee:	01 c2                	add    %eax,%edx
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	8b 40 08             	mov    0x8(%eax),%eax
  802af6:	39 c2                	cmp    %eax,%edx
  802af8:	0f 85 90 00 00 00    	jne    802b8e <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b01:	8b 50 0c             	mov    0xc(%eax),%edx
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0a:	01 c2                	add    %eax,%edx
  802b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0f:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2a:	75 17                	jne    802b43 <insert_sorted_with_merge_freeList+0x16d>
  802b2c:	83 ec 04             	sub    $0x4,%esp
  802b2f:	68 f4 3f 80 00       	push   $0x803ff4
  802b34:	68 41 01 00 00       	push   $0x141
  802b39:	68 17 40 80 00       	push   $0x804017
  802b3e:	e8 b9 d8 ff ff       	call   8003fc <_panic>
  802b43:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	89 10                	mov    %edx,(%eax)
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	74 0d                	je     802b64 <insert_sorted_with_merge_freeList+0x18e>
  802b57:	a1 48 51 80 00       	mov    0x805148,%eax
  802b5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5f:	89 50 04             	mov    %edx,0x4(%eax)
  802b62:	eb 08                	jmp    802b6c <insert_sorted_with_merge_freeList+0x196>
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	a3 48 51 80 00       	mov    %eax,0x805148
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b83:	40                   	inc    %eax
  802b84:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802b89:	e9 8e 05 00 00       	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	8b 50 08             	mov    0x8(%eax),%edx
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9a:	01 c2                	add    %eax,%edx
  802b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ba2:	39 c2                	cmp    %eax,%edx
  802ba4:	73 68                	jae    802c0e <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802baa:	75 17                	jne    802bc3 <insert_sorted_with_merge_freeList+0x1ed>
  802bac:	83 ec 04             	sub    $0x4,%esp
  802baf:	68 f4 3f 80 00       	push   $0x803ff4
  802bb4:	68 45 01 00 00       	push   $0x145
  802bb9:	68 17 40 80 00       	push   $0x804017
  802bbe:	e8 39 d8 ff ff       	call   8003fc <_panic>
  802bc3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	89 10                	mov    %edx,(%eax)
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	74 0d                	je     802be4 <insert_sorted_with_merge_freeList+0x20e>
  802bd7:	a1 38 51 80 00       	mov    0x805138,%eax
  802bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdf:	89 50 04             	mov    %edx,0x4(%eax)
  802be2:	eb 08                	jmp    802bec <insert_sorted_with_merge_freeList+0x216>
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	a3 38 51 80 00       	mov    %eax,0x805138
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bfe:	a1 44 51 80 00       	mov    0x805144,%eax
  802c03:	40                   	inc    %eax
  802c04:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802c09:	e9 0e 05 00 00       	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	8b 50 08             	mov    0x8(%eax),%edx
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1a:	01 c2                	add    %eax,%edx
  802c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1f:	8b 40 08             	mov    0x8(%eax),%eax
  802c22:	39 c2                	cmp    %eax,%edx
  802c24:	0f 85 9c 00 00 00    	jne    802cc6 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	8b 40 0c             	mov    0xc(%eax),%eax
  802c36:	01 c2                	add    %eax,%edx
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	8b 50 08             	mov    0x8(%eax),%edx
  802c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c47:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c62:	75 17                	jne    802c7b <insert_sorted_with_merge_freeList+0x2a5>
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	68 f4 3f 80 00       	push   $0x803ff4
  802c6c:	68 4d 01 00 00       	push   $0x14d
  802c71:	68 17 40 80 00       	push   $0x804017
  802c76:	e8 81 d7 ff ff       	call   8003fc <_panic>
  802c7b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	89 10                	mov    %edx,(%eax)
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	8b 00                	mov    (%eax),%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	74 0d                	je     802c9c <insert_sorted_with_merge_freeList+0x2c6>
  802c8f:	a1 48 51 80 00       	mov    0x805148,%eax
  802c94:	8b 55 08             	mov    0x8(%ebp),%edx
  802c97:	89 50 04             	mov    %edx,0x4(%eax)
  802c9a:	eb 08                	jmp    802ca4 <insert_sorted_with_merge_freeList+0x2ce>
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	a3 48 51 80 00       	mov    %eax,0x805148
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb6:	a1 54 51 80 00       	mov    0x805154,%eax
  802cbb:	40                   	inc    %eax
  802cbc:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802cc1:	e9 56 04 00 00       	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802cc6:	a1 38 51 80 00       	mov    0x805138,%eax
  802ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cce:	e9 19 04 00 00       	jmp    8030ec <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 00                	mov    (%eax),%eax
  802cd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 50 08             	mov    0x8(%eax),%edx
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce7:	01 c2                	add    %eax,%edx
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 40 08             	mov    0x8(%eax),%eax
  802cef:	39 c2                	cmp    %eax,%edx
  802cf1:	0f 85 ad 01 00 00    	jne    802ea4 <insert_sorted_with_merge_freeList+0x4ce>
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	8b 50 08             	mov    0x8(%eax),%edx
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	8b 40 0c             	mov    0xc(%eax),%eax
  802d03:	01 c2                	add    %eax,%edx
  802d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d08:	8b 40 08             	mov    0x8(%eax),%eax
  802d0b:	39 c2                	cmp    %eax,%edx
  802d0d:	0f 85 91 01 00 00    	jne    802ea4 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 50 0c             	mov    0xc(%eax),%edx
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d22:	8b 40 0c             	mov    0xc(%eax),%eax
  802d25:	01 c8                	add    %ecx,%eax
  802d27:	01 c2                	add    %eax,%edx
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d46:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802d57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d5b:	75 17                	jne    802d74 <insert_sorted_with_merge_freeList+0x39e>
  802d5d:	83 ec 04             	sub    $0x4,%esp
  802d60:	68 88 40 80 00       	push   $0x804088
  802d65:	68 5b 01 00 00       	push   $0x15b
  802d6a:	68 17 40 80 00       	push   $0x804017
  802d6f:	e8 88 d6 ff ff       	call   8003fc <_panic>
  802d74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d77:	8b 00                	mov    (%eax),%eax
  802d79:	85 c0                	test   %eax,%eax
  802d7b:	74 10                	je     802d8d <insert_sorted_with_merge_freeList+0x3b7>
  802d7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d80:	8b 00                	mov    (%eax),%eax
  802d82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d85:	8b 52 04             	mov    0x4(%edx),%edx
  802d88:	89 50 04             	mov    %edx,0x4(%eax)
  802d8b:	eb 0b                	jmp    802d98 <insert_sorted_with_merge_freeList+0x3c2>
  802d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d90:	8b 40 04             	mov    0x4(%eax),%eax
  802d93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9b:	8b 40 04             	mov    0x4(%eax),%eax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	74 0f                	je     802db1 <insert_sorted_with_merge_freeList+0x3db>
  802da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da5:	8b 40 04             	mov    0x4(%eax),%eax
  802da8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802dab:	8b 12                	mov    (%edx),%edx
  802dad:	89 10                	mov    %edx,(%eax)
  802daf:	eb 0a                	jmp    802dbb <insert_sorted_with_merge_freeList+0x3e5>
  802db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	a3 38 51 80 00       	mov    %eax,0x805138
  802dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dce:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd3:	48                   	dec    %eax
  802dd4:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ddd:	75 17                	jne    802df6 <insert_sorted_with_merge_freeList+0x420>
  802ddf:	83 ec 04             	sub    $0x4,%esp
  802de2:	68 f4 3f 80 00       	push   $0x803ff4
  802de7:	68 5c 01 00 00       	push   $0x15c
  802dec:	68 17 40 80 00       	push   $0x804017
  802df1:	e8 06 d6 ff ff       	call   8003fc <_panic>
  802df6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	89 10                	mov    %edx,(%eax)
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	74 0d                	je     802e17 <insert_sorted_with_merge_freeList+0x441>
  802e0a:	a1 48 51 80 00       	mov    0x805148,%eax
  802e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e12:	89 50 04             	mov    %edx,0x4(%eax)
  802e15:	eb 08                	jmp    802e1f <insert_sorted_with_merge_freeList+0x449>
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	a3 48 51 80 00       	mov    %eax,0x805148
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e31:	a1 54 51 80 00       	mov    0x805154,%eax
  802e36:	40                   	inc    %eax
  802e37:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802e3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e40:	75 17                	jne    802e59 <insert_sorted_with_merge_freeList+0x483>
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	68 f4 3f 80 00       	push   $0x803ff4
  802e4a:	68 5d 01 00 00       	push   $0x15d
  802e4f:	68 17 40 80 00       	push   $0x804017
  802e54:	e8 a3 d5 ff ff       	call   8003fc <_panic>
  802e59:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e62:	89 10                	mov    %edx,(%eax)
  802e64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	74 0d                	je     802e7a <insert_sorted_with_merge_freeList+0x4a4>
  802e6d:	a1 48 51 80 00       	mov    0x805148,%eax
  802e72:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e75:	89 50 04             	mov    %edx,0x4(%eax)
  802e78:	eb 08                	jmp    802e82 <insert_sorted_with_merge_freeList+0x4ac>
  802e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e85:	a3 48 51 80 00       	mov    %eax,0x805148
  802e8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e94:	a1 54 51 80 00       	mov    0x805154,%eax
  802e99:	40                   	inc    %eax
  802e9a:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  802e9f:	e9 78 02 00 00       	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 50 08             	mov    0x8(%eax),%edx
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb0:	01 c2                	add    %eax,%edx
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	8b 40 08             	mov    0x8(%eax),%eax
  802eb8:	39 c2                	cmp    %eax,%edx
  802eba:	0f 83 b8 00 00 00    	jae    802f78 <insert_sorted_with_merge_freeList+0x5a2>
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 50 08             	mov    0x8(%eax),%edx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecc:	01 c2                	add    %eax,%edx
  802ece:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed1:	8b 40 08             	mov    0x8(%eax),%eax
  802ed4:	39 c2                	cmp    %eax,%edx
  802ed6:	0f 85 9c 00 00 00    	jne    802f78 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802edc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802edf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee8:	01 c2                	add    %eax,%edx
  802eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eed:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	8b 50 08             	mov    0x8(%eax),%edx
  802ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef9:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f14:	75 17                	jne    802f2d <insert_sorted_with_merge_freeList+0x557>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 f4 3f 80 00       	push   $0x803ff4
  802f1e:	68 67 01 00 00       	push   $0x167
  802f23:	68 17 40 80 00       	push   $0x804017
  802f28:	e8 cf d4 ff ff       	call   8003fc <_panic>
  802f2d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	74 0d                	je     802f4e <insert_sorted_with_merge_freeList+0x578>
  802f41:	a1 48 51 80 00       	mov    0x805148,%eax
  802f46:	8b 55 08             	mov    0x8(%ebp),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	eb 08                	jmp    802f56 <insert_sorted_with_merge_freeList+0x580>
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	a3 48 51 80 00       	mov    %eax,0x805148
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f68:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6d:	40                   	inc    %eax
  802f6e:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  802f73:	e9 a4 01 00 00       	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 50 08             	mov    0x8(%eax),%edx
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 40 0c             	mov    0xc(%eax),%eax
  802f84:	01 c2                	add    %eax,%edx
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	8b 40 08             	mov    0x8(%eax),%eax
  802f8c:	39 c2                	cmp    %eax,%edx
  802f8e:	0f 85 ac 00 00 00    	jne    803040 <insert_sorted_with_merge_freeList+0x66a>
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	8b 50 08             	mov    0x8(%eax),%edx
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa0:	01 c2                	add    %eax,%edx
  802fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa5:	8b 40 08             	mov    0x8(%eax),%eax
  802fa8:	39 c2                	cmp    %eax,%edx
  802faa:	0f 83 90 00 00 00    	jae    803040 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbc:	01 c2                	add    %eax,%edx
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdc:	75 17                	jne    802ff5 <insert_sorted_with_merge_freeList+0x61f>
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	68 f4 3f 80 00       	push   $0x803ff4
  802fe6:	68 70 01 00 00       	push   $0x170
  802feb:	68 17 40 80 00       	push   $0x804017
  802ff0:	e8 07 d4 ff ff       	call   8003fc <_panic>
  802ff5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	89 10                	mov    %edx,(%eax)
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	74 0d                	je     803016 <insert_sorted_with_merge_freeList+0x640>
  803009:	a1 48 51 80 00       	mov    0x805148,%eax
  80300e:	8b 55 08             	mov    0x8(%ebp),%edx
  803011:	89 50 04             	mov    %edx,0x4(%eax)
  803014:	eb 08                	jmp    80301e <insert_sorted_with_merge_freeList+0x648>
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	a3 48 51 80 00       	mov    %eax,0x805148
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803030:	a1 54 51 80 00       	mov    0x805154,%eax
  803035:	40                   	inc    %eax
  803036:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  80303b:	e9 dc 00 00 00       	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 50 08             	mov    0x8(%eax),%edx
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 40 0c             	mov    0xc(%eax),%eax
  80304c:	01 c2                	add    %eax,%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	8b 40 08             	mov    0x8(%eax),%eax
  803054:	39 c2                	cmp    %eax,%edx
  803056:	0f 83 88 00 00 00    	jae    8030e4 <insert_sorted_with_merge_freeList+0x70e>
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	8b 50 08             	mov    0x8(%eax),%edx
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	8b 40 0c             	mov    0xc(%eax),%eax
  803068:	01 c2                	add    %eax,%edx
  80306a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306d:	8b 40 08             	mov    0x8(%eax),%eax
  803070:	39 c2                	cmp    %eax,%edx
  803072:	73 70                	jae    8030e4 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803074:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803078:	74 06                	je     803080 <insert_sorted_with_merge_freeList+0x6aa>
  80307a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80307e:	75 17                	jne    803097 <insert_sorted_with_merge_freeList+0x6c1>
  803080:	83 ec 04             	sub    $0x4,%esp
  803083:	68 54 40 80 00       	push   $0x804054
  803088:	68 75 01 00 00       	push   $0x175
  80308d:	68 17 40 80 00       	push   $0x804017
  803092:	e8 65 d3 ff ff       	call   8003fc <_panic>
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 10                	mov    (%eax),%edx
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	89 10                	mov    %edx,(%eax)
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	85 c0                	test   %eax,%eax
  8030a8:	74 0b                	je     8030b5 <insert_sorted_with_merge_freeList+0x6df>
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b2:	89 50 04             	mov    %edx,0x4(%eax)
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bb:	89 10                	mov    %edx,(%eax)
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c3:	89 50 04             	mov    %edx,0x4(%eax)
  8030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c9:	8b 00                	mov    (%eax),%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	75 08                	jne    8030d7 <insert_sorted_with_merge_freeList+0x701>
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030d7:	a1 44 51 80 00       	mov    0x805144,%eax
  8030dc:	40                   	inc    %eax
  8030dd:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  8030e2:	eb 38                	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8030e4:	a1 40 51 80 00       	mov    0x805140,%eax
  8030e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f0:	74 07                	je     8030f9 <insert_sorted_with_merge_freeList+0x723>
  8030f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f5:	8b 00                	mov    (%eax),%eax
  8030f7:	eb 05                	jmp    8030fe <insert_sorted_with_merge_freeList+0x728>
  8030f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fe:	a3 40 51 80 00       	mov    %eax,0x805140
  803103:	a1 40 51 80 00       	mov    0x805140,%eax
  803108:	85 c0                	test   %eax,%eax
  80310a:	0f 85 c3 fb ff ff    	jne    802cd3 <insert_sorted_with_merge_freeList+0x2fd>
  803110:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803114:	0f 85 b9 fb ff ff    	jne    802cd3 <insert_sorted_with_merge_freeList+0x2fd>





}
  80311a:	eb 00                	jmp    80311c <insert_sorted_with_merge_freeList+0x746>
  80311c:	90                   	nop
  80311d:	c9                   	leave  
  80311e:	c3                   	ret    
  80311f:	90                   	nop

00803120 <__udivdi3>:
  803120:	55                   	push   %ebp
  803121:	57                   	push   %edi
  803122:	56                   	push   %esi
  803123:	53                   	push   %ebx
  803124:	83 ec 1c             	sub    $0x1c,%esp
  803127:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80312b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80312f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803133:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803137:	89 ca                	mov    %ecx,%edx
  803139:	89 f8                	mov    %edi,%eax
  80313b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80313f:	85 f6                	test   %esi,%esi
  803141:	75 2d                	jne    803170 <__udivdi3+0x50>
  803143:	39 cf                	cmp    %ecx,%edi
  803145:	77 65                	ja     8031ac <__udivdi3+0x8c>
  803147:	89 fd                	mov    %edi,%ebp
  803149:	85 ff                	test   %edi,%edi
  80314b:	75 0b                	jne    803158 <__udivdi3+0x38>
  80314d:	b8 01 00 00 00       	mov    $0x1,%eax
  803152:	31 d2                	xor    %edx,%edx
  803154:	f7 f7                	div    %edi
  803156:	89 c5                	mov    %eax,%ebp
  803158:	31 d2                	xor    %edx,%edx
  80315a:	89 c8                	mov    %ecx,%eax
  80315c:	f7 f5                	div    %ebp
  80315e:	89 c1                	mov    %eax,%ecx
  803160:	89 d8                	mov    %ebx,%eax
  803162:	f7 f5                	div    %ebp
  803164:	89 cf                	mov    %ecx,%edi
  803166:	89 fa                	mov    %edi,%edx
  803168:	83 c4 1c             	add    $0x1c,%esp
  80316b:	5b                   	pop    %ebx
  80316c:	5e                   	pop    %esi
  80316d:	5f                   	pop    %edi
  80316e:	5d                   	pop    %ebp
  80316f:	c3                   	ret    
  803170:	39 ce                	cmp    %ecx,%esi
  803172:	77 28                	ja     80319c <__udivdi3+0x7c>
  803174:	0f bd fe             	bsr    %esi,%edi
  803177:	83 f7 1f             	xor    $0x1f,%edi
  80317a:	75 40                	jne    8031bc <__udivdi3+0x9c>
  80317c:	39 ce                	cmp    %ecx,%esi
  80317e:	72 0a                	jb     80318a <__udivdi3+0x6a>
  803180:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803184:	0f 87 9e 00 00 00    	ja     803228 <__udivdi3+0x108>
  80318a:	b8 01 00 00 00       	mov    $0x1,%eax
  80318f:	89 fa                	mov    %edi,%edx
  803191:	83 c4 1c             	add    $0x1c,%esp
  803194:	5b                   	pop    %ebx
  803195:	5e                   	pop    %esi
  803196:	5f                   	pop    %edi
  803197:	5d                   	pop    %ebp
  803198:	c3                   	ret    
  803199:	8d 76 00             	lea    0x0(%esi),%esi
  80319c:	31 ff                	xor    %edi,%edi
  80319e:	31 c0                	xor    %eax,%eax
  8031a0:	89 fa                	mov    %edi,%edx
  8031a2:	83 c4 1c             	add    $0x1c,%esp
  8031a5:	5b                   	pop    %ebx
  8031a6:	5e                   	pop    %esi
  8031a7:	5f                   	pop    %edi
  8031a8:	5d                   	pop    %ebp
  8031a9:	c3                   	ret    
  8031aa:	66 90                	xchg   %ax,%ax
  8031ac:	89 d8                	mov    %ebx,%eax
  8031ae:	f7 f7                	div    %edi
  8031b0:	31 ff                	xor    %edi,%edi
  8031b2:	89 fa                	mov    %edi,%edx
  8031b4:	83 c4 1c             	add    $0x1c,%esp
  8031b7:	5b                   	pop    %ebx
  8031b8:	5e                   	pop    %esi
  8031b9:	5f                   	pop    %edi
  8031ba:	5d                   	pop    %ebp
  8031bb:	c3                   	ret    
  8031bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031c1:	89 eb                	mov    %ebp,%ebx
  8031c3:	29 fb                	sub    %edi,%ebx
  8031c5:	89 f9                	mov    %edi,%ecx
  8031c7:	d3 e6                	shl    %cl,%esi
  8031c9:	89 c5                	mov    %eax,%ebp
  8031cb:	88 d9                	mov    %bl,%cl
  8031cd:	d3 ed                	shr    %cl,%ebp
  8031cf:	89 e9                	mov    %ebp,%ecx
  8031d1:	09 f1                	or     %esi,%ecx
  8031d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031d7:	89 f9                	mov    %edi,%ecx
  8031d9:	d3 e0                	shl    %cl,%eax
  8031db:	89 c5                	mov    %eax,%ebp
  8031dd:	89 d6                	mov    %edx,%esi
  8031df:	88 d9                	mov    %bl,%cl
  8031e1:	d3 ee                	shr    %cl,%esi
  8031e3:	89 f9                	mov    %edi,%ecx
  8031e5:	d3 e2                	shl    %cl,%edx
  8031e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031eb:	88 d9                	mov    %bl,%cl
  8031ed:	d3 e8                	shr    %cl,%eax
  8031ef:	09 c2                	or     %eax,%edx
  8031f1:	89 d0                	mov    %edx,%eax
  8031f3:	89 f2                	mov    %esi,%edx
  8031f5:	f7 74 24 0c          	divl   0xc(%esp)
  8031f9:	89 d6                	mov    %edx,%esi
  8031fb:	89 c3                	mov    %eax,%ebx
  8031fd:	f7 e5                	mul    %ebp
  8031ff:	39 d6                	cmp    %edx,%esi
  803201:	72 19                	jb     80321c <__udivdi3+0xfc>
  803203:	74 0b                	je     803210 <__udivdi3+0xf0>
  803205:	89 d8                	mov    %ebx,%eax
  803207:	31 ff                	xor    %edi,%edi
  803209:	e9 58 ff ff ff       	jmp    803166 <__udivdi3+0x46>
  80320e:	66 90                	xchg   %ax,%ax
  803210:	8b 54 24 08          	mov    0x8(%esp),%edx
  803214:	89 f9                	mov    %edi,%ecx
  803216:	d3 e2                	shl    %cl,%edx
  803218:	39 c2                	cmp    %eax,%edx
  80321a:	73 e9                	jae    803205 <__udivdi3+0xe5>
  80321c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80321f:	31 ff                	xor    %edi,%edi
  803221:	e9 40 ff ff ff       	jmp    803166 <__udivdi3+0x46>
  803226:	66 90                	xchg   %ax,%ax
  803228:	31 c0                	xor    %eax,%eax
  80322a:	e9 37 ff ff ff       	jmp    803166 <__udivdi3+0x46>
  80322f:	90                   	nop

00803230 <__umoddi3>:
  803230:	55                   	push   %ebp
  803231:	57                   	push   %edi
  803232:	56                   	push   %esi
  803233:	53                   	push   %ebx
  803234:	83 ec 1c             	sub    $0x1c,%esp
  803237:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80323b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80323f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803243:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803247:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80324b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80324f:	89 f3                	mov    %esi,%ebx
  803251:	89 fa                	mov    %edi,%edx
  803253:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803257:	89 34 24             	mov    %esi,(%esp)
  80325a:	85 c0                	test   %eax,%eax
  80325c:	75 1a                	jne    803278 <__umoddi3+0x48>
  80325e:	39 f7                	cmp    %esi,%edi
  803260:	0f 86 a2 00 00 00    	jbe    803308 <__umoddi3+0xd8>
  803266:	89 c8                	mov    %ecx,%eax
  803268:	89 f2                	mov    %esi,%edx
  80326a:	f7 f7                	div    %edi
  80326c:	89 d0                	mov    %edx,%eax
  80326e:	31 d2                	xor    %edx,%edx
  803270:	83 c4 1c             	add    $0x1c,%esp
  803273:	5b                   	pop    %ebx
  803274:	5e                   	pop    %esi
  803275:	5f                   	pop    %edi
  803276:	5d                   	pop    %ebp
  803277:	c3                   	ret    
  803278:	39 f0                	cmp    %esi,%eax
  80327a:	0f 87 ac 00 00 00    	ja     80332c <__umoddi3+0xfc>
  803280:	0f bd e8             	bsr    %eax,%ebp
  803283:	83 f5 1f             	xor    $0x1f,%ebp
  803286:	0f 84 ac 00 00 00    	je     803338 <__umoddi3+0x108>
  80328c:	bf 20 00 00 00       	mov    $0x20,%edi
  803291:	29 ef                	sub    %ebp,%edi
  803293:	89 fe                	mov    %edi,%esi
  803295:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803299:	89 e9                	mov    %ebp,%ecx
  80329b:	d3 e0                	shl    %cl,%eax
  80329d:	89 d7                	mov    %edx,%edi
  80329f:	89 f1                	mov    %esi,%ecx
  8032a1:	d3 ef                	shr    %cl,%edi
  8032a3:	09 c7                	or     %eax,%edi
  8032a5:	89 e9                	mov    %ebp,%ecx
  8032a7:	d3 e2                	shl    %cl,%edx
  8032a9:	89 14 24             	mov    %edx,(%esp)
  8032ac:	89 d8                	mov    %ebx,%eax
  8032ae:	d3 e0                	shl    %cl,%eax
  8032b0:	89 c2                	mov    %eax,%edx
  8032b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032b6:	d3 e0                	shl    %cl,%eax
  8032b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c0:	89 f1                	mov    %esi,%ecx
  8032c2:	d3 e8                	shr    %cl,%eax
  8032c4:	09 d0                	or     %edx,%eax
  8032c6:	d3 eb                	shr    %cl,%ebx
  8032c8:	89 da                	mov    %ebx,%edx
  8032ca:	f7 f7                	div    %edi
  8032cc:	89 d3                	mov    %edx,%ebx
  8032ce:	f7 24 24             	mull   (%esp)
  8032d1:	89 c6                	mov    %eax,%esi
  8032d3:	89 d1                	mov    %edx,%ecx
  8032d5:	39 d3                	cmp    %edx,%ebx
  8032d7:	0f 82 87 00 00 00    	jb     803364 <__umoddi3+0x134>
  8032dd:	0f 84 91 00 00 00    	je     803374 <__umoddi3+0x144>
  8032e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032e7:	29 f2                	sub    %esi,%edx
  8032e9:	19 cb                	sbb    %ecx,%ebx
  8032eb:	89 d8                	mov    %ebx,%eax
  8032ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032f1:	d3 e0                	shl    %cl,%eax
  8032f3:	89 e9                	mov    %ebp,%ecx
  8032f5:	d3 ea                	shr    %cl,%edx
  8032f7:	09 d0                	or     %edx,%eax
  8032f9:	89 e9                	mov    %ebp,%ecx
  8032fb:	d3 eb                	shr    %cl,%ebx
  8032fd:	89 da                	mov    %ebx,%edx
  8032ff:	83 c4 1c             	add    $0x1c,%esp
  803302:	5b                   	pop    %ebx
  803303:	5e                   	pop    %esi
  803304:	5f                   	pop    %edi
  803305:	5d                   	pop    %ebp
  803306:	c3                   	ret    
  803307:	90                   	nop
  803308:	89 fd                	mov    %edi,%ebp
  80330a:	85 ff                	test   %edi,%edi
  80330c:	75 0b                	jne    803319 <__umoddi3+0xe9>
  80330e:	b8 01 00 00 00       	mov    $0x1,%eax
  803313:	31 d2                	xor    %edx,%edx
  803315:	f7 f7                	div    %edi
  803317:	89 c5                	mov    %eax,%ebp
  803319:	89 f0                	mov    %esi,%eax
  80331b:	31 d2                	xor    %edx,%edx
  80331d:	f7 f5                	div    %ebp
  80331f:	89 c8                	mov    %ecx,%eax
  803321:	f7 f5                	div    %ebp
  803323:	89 d0                	mov    %edx,%eax
  803325:	e9 44 ff ff ff       	jmp    80326e <__umoddi3+0x3e>
  80332a:	66 90                	xchg   %ax,%ax
  80332c:	89 c8                	mov    %ecx,%eax
  80332e:	89 f2                	mov    %esi,%edx
  803330:	83 c4 1c             	add    $0x1c,%esp
  803333:	5b                   	pop    %ebx
  803334:	5e                   	pop    %esi
  803335:	5f                   	pop    %edi
  803336:	5d                   	pop    %ebp
  803337:	c3                   	ret    
  803338:	3b 04 24             	cmp    (%esp),%eax
  80333b:	72 06                	jb     803343 <__umoddi3+0x113>
  80333d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803341:	77 0f                	ja     803352 <__umoddi3+0x122>
  803343:	89 f2                	mov    %esi,%edx
  803345:	29 f9                	sub    %edi,%ecx
  803347:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80334b:	89 14 24             	mov    %edx,(%esp)
  80334e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803352:	8b 44 24 04          	mov    0x4(%esp),%eax
  803356:	8b 14 24             	mov    (%esp),%edx
  803359:	83 c4 1c             	add    $0x1c,%esp
  80335c:	5b                   	pop    %ebx
  80335d:	5e                   	pop    %esi
  80335e:	5f                   	pop    %edi
  80335f:	5d                   	pop    %ebp
  803360:	c3                   	ret    
  803361:	8d 76 00             	lea    0x0(%esi),%esi
  803364:	2b 04 24             	sub    (%esp),%eax
  803367:	19 fa                	sbb    %edi,%edx
  803369:	89 d1                	mov    %edx,%ecx
  80336b:	89 c6                	mov    %eax,%esi
  80336d:	e9 71 ff ff ff       	jmp    8032e3 <__umoddi3+0xb3>
  803372:	66 90                	xchg   %ax,%ax
  803374:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803378:	72 ea                	jb     803364 <__umoddi3+0x134>
  80337a:	89 d9                	mov    %ebx,%ecx
  80337c:	e9 62 ff ff ff       	jmp    8032e3 <__umoddi3+0xb3>
