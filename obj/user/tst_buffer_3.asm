
obj/user/tst_buffer_3:     file format elf32-i386


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
  800031:	e8 82 02 00 00       	call   8002b8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
//		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}
	int kilo = 1024;
  80003f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int Mega = 1024*1024;
  800046:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)

	{
		int freeFrames = sys_calculate_free_frames() ;
  80004d:	e8 0e 1a 00 00       	call   801a60 <sys_calculate_free_frames>
  800052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int origFreeFrames = freeFrames ;
  800055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800058:	89 45 e0             	mov    %eax,-0x20(%ebp)

		uint32 size = 10*Mega;
  80005b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	c1 e0 02             	shl    $0x2,%eax
  800063:	01 d0                	add    %edx,%eax
  800065:	01 c0                	add    %eax,%eax
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	ff 75 dc             	pushl  -0x24(%ebp)
  800070:	e8 ac 15 00 00       	call   801621 <malloc>
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	89 45 d8             	mov    %eax,-0x28(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80007b:	e8 e0 19 00 00       	call   801a60 <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 f1 19 00 00       	call   801a79 <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 80 33 80 00       	push   $0x803380
  80009c:	e8 07 06 00 00       	call   8006a8 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp
		x[1]=-1;
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	40                   	inc    %eax
  8000a8:	c6 00 ff             	movb   $0xff,(%eax)

		x[1*Mega] = -1;
  8000ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	c6 00 ff             	movb   $0xff,(%eax)

		int i = x[2*Mega];
  8000b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b9:	01 c0                	add    %eax,%eax
  8000bb:	89 c2                	mov    %eax,%edx
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	01 d0                	add    %edx,%eax
  8000c2:	8a 00                	mov    (%eax),%al
  8000c4:	0f b6 c0             	movzbl %al,%eax
  8000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		int j = x[3*Mega];
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	89 c2                	mov    %eax,%edx
  8000cf:	01 d2                	add    %edx,%edx
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	8a 00                	mov    (%eax),%al
  8000dc:	0f b6 c0             	movzbl %al,%eax
  8000df:	89 45 d0             	mov    %eax,-0x30(%ebp)

		x[4*Mega] = -1;
  8000e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e5:	c1 e0 02             	shl    $0x2,%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega] = -1;
  8000f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000f5:	89 d0                	mov    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	89 c2                	mov    %eax,%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c6 00 ff             	movb   $0xff,(%eax)

		x[6*Mega] = -1;
  800106:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800109:	89 d0                	mov    %edx,%eax
  80010b:	01 c0                	add    %eax,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	01 c0                	add    %eax,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 ff             	movb   $0xff,(%eax)

		x[7*Mega] = -1;
  80011b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80011e:	89 d0                	mov    %edx,%eax
  800120:	01 c0                	add    %eax,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	01 c0                	add    %eax,%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	c1 e0 03             	shl    $0x3,%eax
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013d:	01 d0                	add    %edx,%eax
  80013f:	c6 00 ff             	movb   $0xff,(%eax)

		x[9*Mega] = -1;
  800142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800145:	89 d0                	mov    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c6 00 ff             	movb   $0xff,(%eax)

		free(x);
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	ff 75 d8             	pushl  -0x28(%ebp)
  80015c:	e8 57 15 00 00       	call   8016b8 <free>
  800161:	83 c4 10             	add    $0x10,%esp

		int numOFEmptyLocInWS = 0;
  800164:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80016b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800172:	eb 79                	jmp    8001ed <_main+0x1b5>
		{
			if (myEnv->__uptr_pws[i].empty)
  800174:	a1 20 40 80 00       	mov    0x804020,%eax
  800179:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80017f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800182:	89 d0                	mov    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	c1 e0 03             	shl    $0x3,%eax
  80018b:	01 c8                	add    %ecx,%eax
  80018d:	8a 40 04             	mov    0x4(%eax),%al
  800190:	84 c0                	test   %al,%al
  800192:	74 05                	je     800199 <_main+0x161>
			{
				numOFEmptyLocInWS++;
  800194:	ff 45 f0             	incl   -0x10(%ebp)
  800197:	eb 51                	jmp    8001ea <_main+0x1b2>
			}
			else
			{
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800199:	a1 20 40 80 00       	mov    0x804020,%eax
  80019e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a7:	89 d0                	mov    %edx,%eax
  8001a9:	01 c0                	add    %eax,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	c1 e0 03             	shl    $0x3,%eax
  8001b0:	01 c8                	add    %ecx,%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
  8001c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	79 21                	jns    8001ea <_main+0x1b2>
  8001c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cc:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001d4:	76 14                	jbe    8001ea <_main+0x1b2>
					panic("freeMem didn't remove its page(s) from the WS");
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 a0 33 80 00       	push   $0x8033a0
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 ce 33 80 00       	push   $0x8033ce
  8001e5:	e8 0a 02 00 00       	call   8003f4 <_panic>
		x[9*Mega] = -1;

		free(x);

		int numOFEmptyLocInWS = 0;
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8001ea:	ff 45 f4             	incl   -0xc(%ebp)
  8001ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f2:	8b 50 74             	mov    0x74(%eax),%edx
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	39 c2                	cmp    %eax,%edx
  8001fa:	0f 87 74 ff ff ff    	ja     800174 <_main+0x13c>
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
					panic("freeMem didn't remove its page(s) from the WS");
			}
		}
		int free_frames = sys_calculate_free_frames();
  800200:	e8 5b 18 00 00       	call   801a60 <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 6c 18 00 00       	call   801a79 <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 64 18 00 00       	call   801a79 <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 44 18 00 00       	call   801a60 <sys_calculate_free_frames>
  80021c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80021f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800222:	89 d1                	mov    %edx,%ecx
  800224:	29 c1                	sub    %eax,%ecx
  800226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022c:	01 d0                	add    %edx,%eax
  80022e:	39 c1                	cmp    %eax,%ecx
  800230:	74 14                	je     800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 e4 33 80 00       	push   $0x8033e4
  80023a:	6a 53                	push   $0x53
  80023c:	68 ce 33 80 00       	push   $0x8033ce
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 38 34 80 00       	push   $0x803438
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 94 34 80 00       	push   $0x803494
  80025e:	e8 45 04 00 00       	call   8006a8 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800266:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	c6 00 ff             	movb   $0xff,(%eax)

			x[1*Mega] = -1;
  80026d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800273:	01 d0                	add    %edx,%eax
  800275:	c6 00 ff             	movb   $0xff,(%eax)

			int i = x[2*Mega];
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	01 c0                	add    %eax,%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800282:	01 d0                	add    %edx,%eax
  800284:	8a 00                	mov    (%eax),%al
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	89 45 bc             	mov    %eax,-0x44(%ebp)

			int j = x[3*Mega];
  80028c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028f:	89 c2                	mov    %eax,%edx
  800291:	01 d2                	add    %edx,%edx
  800293:	01 d0                	add    %edx,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8a 00                	mov    (%eax),%al
  80029e:	0f b6 c0             	movzbl %al,%eax
  8002a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for stack pages\n");
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 78 35 80 00       	push   $0x803578
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 ce 33 80 00       	push   $0x8033ce
  8002b3:	e8 3c 01 00 00       	call   8003f4 <_panic>

008002b8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002be:	e8 7d 1a 00 00       	call   801d40 <sys_getenvindex>
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c9:	89 d0                	mov    %edx,%eax
  8002cb:	c1 e0 03             	shl    $0x3,%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	01 c0                	add    %eax,%eax
  8002d2:	01 d0                	add    %edx,%eax
  8002d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002db:	01 d0                	add    %edx,%eax
  8002dd:	c1 e0 04             	shl    $0x4,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ef:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002f5:	84 c0                	test   %al,%al
  8002f7:	74 0f                	je     800308 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fe:	05 5c 05 00 00       	add    $0x55c,%eax
  800303:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030c:	7e 0a                	jle    800318 <libmain+0x60>
		binaryname = argv[0];
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	8b 00                	mov    (%eax),%eax
  800313:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 12 fd ff ff       	call   800038 <_main>
  800326:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800329:	e8 1f 18 00 00       	call   801b4d <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 98 36 80 00       	push   $0x803698
  800336:	e8 6d 03 00 00       	call   8006a8 <cprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033e:	a1 20 40 80 00       	mov    0x804020,%eax
  800343:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800354:	83 ec 04             	sub    $0x4,%esp
  800357:	52                   	push   %edx
  800358:	50                   	push   %eax
  800359:	68 c0 36 80 00       	push   $0x8036c0
  80035e:	e8 45 03 00 00       	call   8006a8 <cprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800366:	a1 20 40 80 00       	mov    0x804020,%eax
  80036b:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800371:	a1 20 40 80 00       	mov    0x804020,%eax
  800376:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80037c:	a1 20 40 80 00       	mov    0x804020,%eax
  800381:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800387:	51                   	push   %ecx
  800388:	52                   	push   %edx
  800389:	50                   	push   %eax
  80038a:	68 e8 36 80 00       	push   $0x8036e8
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 40 37 80 00       	push   $0x803740
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 98 36 80 00       	push   $0x803698
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 9f 17 00 00       	call   801b67 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003c8:	e8 19 00 00 00       	call   8003e6 <exit>
}
  8003cd:	90                   	nop
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d6:	83 ec 0c             	sub    $0xc,%esp
  8003d9:	6a 00                	push   $0x0
  8003db:	e8 2c 19 00 00       	call   801d0c <sys_destroy_env>
  8003e0:	83 c4 10             	add    $0x10,%esp
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <exit>:

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ec:	e8 81 19 00 00       	call   801d72 <sys_exit_env>
}
  8003f1:	90                   	nop
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800403:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800408:	85 c0                	test   %eax,%eax
  80040a:	74 16                	je     800422 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040c:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	50                   	push   %eax
  800415:	68 54 37 80 00       	push   $0x803754
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 40 80 00       	mov    0x804000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 59 37 80 00       	push   $0x803759
  800433:	e8 70 02 00 00       	call   8006a8 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 f4             	pushl  -0xc(%ebp)
  800444:	50                   	push   %eax
  800445:	e8 f3 01 00 00       	call   80063d <vcprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	6a 00                	push   $0x0
  800452:	68 75 37 80 00       	push   $0x803775
  800457:	e8 e1 01 00 00       	call   80063d <vcprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80045f:	e8 82 ff ff ff       	call   8003e6 <exit>

	// should not return here
	while (1) ;
  800464:	eb fe                	jmp    800464 <_panic+0x70>

00800466 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046c:	a1 20 40 80 00       	mov    0x804020,%eax
  800471:	8b 50 74             	mov    0x74(%eax),%edx
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 78 37 80 00       	push   $0x803778
  800483:	6a 26                	push   $0x26
  800485:	68 c4 37 80 00       	push   $0x8037c4
  80048a:	e8 65 ff ff ff       	call   8003f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80048f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049d:	e9 c2 00 00 00       	jmp    800564 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	75 08                	jne    8004bf <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ba:	e9 a2 00 00 00       	jmp    800561 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004cd:	eb 69                	jmp    800538 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8a 40 04             	mov    0x4(%eax),%al
  8004eb:	84 c0                	test   %al,%al
  8004ed:	75 46                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 c8                	add    %ecx,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 c8                	add    %ecx,%eax
  800526:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	75 09                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80052c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800533:	eb 12                	jmp    800547 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800535:	ff 45 e8             	incl   -0x18(%ebp)
  800538:	a1 20 40 80 00       	mov    0x804020,%eax
  80053d:	8b 50 74             	mov    0x74(%eax),%edx
  800540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800543:	39 c2                	cmp    %eax,%edx
  800545:	77 88                	ja     8004cf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80054b:	75 14                	jne    800561 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 d0 37 80 00       	push   $0x8037d0
  800555:	6a 3a                	push   $0x3a
  800557:	68 c4 37 80 00       	push   $0x8037c4
  80055c:	e8 93 fe ff ff       	call   8003f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800561:	ff 45 f0             	incl   -0x10(%ebp)
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80056a:	0f 8c 32 ff ff ff    	jl     8004a2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800577:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057e:	eb 26                	jmp    8005a6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800580:	a1 20 40 80 00       	mov    0x804020,%eax
  800585:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8a 40 04             	mov    0x4(%eax),%al
  80059c:	3c 01                	cmp    $0x1,%al
  80059e:	75 03                	jne    8005a3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a3:	ff 45 e0             	incl   -0x20(%ebp)
  8005a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ab:	8b 50 74             	mov    0x74(%eax),%edx
  8005ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b1:	39 c2                	cmp    %eax,%edx
  8005b3:	77 cb                	ja     800580 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005bb:	74 14                	je     8005d1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 24 38 80 00       	push   $0x803824
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 c4 37 80 00       	push   $0x8037c4
  8005cc:	e8 23 fe ff ff       	call   8003f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	89 0a                	mov    %ecx,(%edx)
  8005e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ea:	88 d1                	mov    %dl,%cl
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fd:	75 2c                	jne    80062b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ff:	a0 24 40 80 00       	mov    0x804024,%al
  800604:	0f b6 c0             	movzbl %al,%eax
  800607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060a:	8b 12                	mov    (%edx),%edx
  80060c:	89 d1                	mov    %edx,%ecx
  80060e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800611:	83 c2 08             	add    $0x8,%edx
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	50                   	push   %eax
  800618:	51                   	push   %ecx
  800619:	52                   	push   %edx
  80061a:	e8 80 13 00 00       	call   80199f <sys_cputs>
  80061f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	8b 40 04             	mov    0x4(%eax),%eax
  800631:	8d 50 01             	lea    0x1(%eax),%edx
  800634:	8b 45 0c             	mov    0xc(%ebp),%eax
  800637:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063a:	90                   	nop
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800646:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064d:	00 00 00 
	b.cnt = 0;
  800650:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800657:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	ff 75 08             	pushl  0x8(%ebp)
  800660:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800666:	50                   	push   %eax
  800667:	68 d4 05 80 00       	push   $0x8005d4
  80066c:	e8 11 02 00 00       	call   800882 <vprintfmt>
  800671:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800674:	a0 24 40 80 00       	mov    0x804024,%al
  800679:	0f b6 c0             	movzbl %al,%eax
  80067c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	50                   	push   %eax
  800686:	52                   	push   %edx
  800687:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068d:	83 c0 08             	add    $0x8,%eax
  800690:	50                   	push   %eax
  800691:	e8 09 13 00 00       	call   80199f <sys_cputs>
  800696:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800699:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ae:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	e8 73 ff ff ff       	call   80063d <vcprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006db:	e8 6d 14 00 00       	call   801b4d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	e8 48 ff ff ff       	call   80063d <vcprintf>
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006fb:	e8 67 14 00 00       	call   801b67 <sys_enable_interrupt>
	return cnt;
  800700:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800703:	c9                   	leave  
  800704:	c3                   	ret    

00800705 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	53                   	push   %ebx
  800709:	83 ec 14             	sub    $0x14,%esp
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800718:	8b 45 18             	mov    0x18(%ebp),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800723:	77 55                	ja     80077a <printnum+0x75>
  800725:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800728:	72 05                	jb     80072f <printnum+0x2a>
  80072a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072d:	77 4b                	ja     80077a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800732:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800735:	8b 45 18             	mov    0x18(%ebp),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	ff 75 f4             	pushl  -0xc(%ebp)
  800742:	ff 75 f0             	pushl  -0x10(%ebp)
  800745:	e8 ce 29 00 00       	call   803118 <__udivdi3>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	ff 75 20             	pushl  0x20(%ebp)
  800753:	53                   	push   %ebx
  800754:	ff 75 18             	pushl  0x18(%ebp)
  800757:	52                   	push   %edx
  800758:	50                   	push   %eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	e8 a1 ff ff ff       	call   800705 <printnum>
  800764:	83 c4 20             	add    $0x20,%esp
  800767:	eb 1a                	jmp    800783 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 20             	pushl  0x20(%ebp)
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077a:	ff 4d 1c             	decl   0x1c(%ebp)
  80077d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800781:	7f e6                	jg     800769 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800783:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800786:	bb 00 00 00 00       	mov    $0x0,%ebx
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	53                   	push   %ebx
  800792:	51                   	push   %ecx
  800793:	52                   	push   %edx
  800794:	50                   	push   %eax
  800795:	e8 8e 2a 00 00       	call   803228 <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 94 3a 80 00       	add    $0x803a94,%eax
  8007a2:	8a 00                	mov    (%eax),%al
  8007a4:	0f be c0             	movsbl %al,%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
}
  8007b6:	90                   	nop
  8007b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c3:	7e 1c                	jle    8007e1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 08             	lea    0x8(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 08             	sub    $0x8,%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	eb 40                	jmp    800821 <getuint+0x65>
	else if (lflag)
  8007e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e5:	74 1e                	je     800805 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	8d 50 04             	lea    0x4(%eax),%edx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	89 10                	mov    %edx,(%eax)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	eb 1c                	jmp    800821 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	89 10                	mov    %edx,(%eax)
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800826:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082a:	7e 1c                	jle    800848 <getint+0x25>
		return va_arg(*ap, long long);
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	8d 50 08             	lea    0x8(%eax),%edx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	89 10                	mov    %edx,(%eax)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 e8 08             	sub    $0x8,%eax
  800841:	8b 50 04             	mov    0x4(%eax),%edx
  800844:	8b 00                	mov    (%eax),%eax
  800846:	eb 38                	jmp    800880 <getint+0x5d>
	else if (lflag)
  800848:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084c:	74 1a                	je     800868 <getint+0x45>
		return va_arg(*ap, long);
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	8d 50 04             	lea    0x4(%eax),%edx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	89 10                	mov    %edx,(%eax)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	83 e8 04             	sub    $0x4,%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	99                   	cltd   
  800866:	eb 18                	jmp    800880 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	99                   	cltd   
}
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088a:	eb 17                	jmp    8008a3 <vprintfmt+0x21>
			if (ch == '\0')
  80088c:	85 db                	test   %ebx,%ebx
  80088e:	0f 84 af 03 00 00    	je     800c43 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	8d 50 01             	lea    0x1(%eax),%edx
  8008a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f b6 d8             	movzbl %al,%ebx
  8008b1:	83 fb 25             	cmp    $0x25,%ebx
  8008b4:	75 d6                	jne    80088c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d9:	8d 50 01             	lea    0x1(%eax),%edx
  8008dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	0f b6 d8             	movzbl %al,%ebx
  8008e4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e7:	83 f8 55             	cmp    $0x55,%eax
  8008ea:	0f 87 2b 03 00 00    	ja     800c1b <vprintfmt+0x399>
  8008f0:	8b 04 85 b8 3a 80 00 	mov    0x803ab8(,%eax,4),%eax
  8008f7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fd:	eb d7                	jmp    8008d6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ff:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800903:	eb d1                	jmp    8008d6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800905:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090f:	89 d0                	mov    %edx,%eax
  800911:	c1 e0 02             	shl    $0x2,%eax
  800914:	01 d0                	add    %edx,%eax
  800916:	01 c0                	add    %eax,%eax
  800918:	01 d8                	add    %ebx,%eax
  80091a:	83 e8 30             	sub    $0x30,%eax
  80091d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800920:	8b 45 10             	mov    0x10(%ebp),%eax
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800928:	83 fb 2f             	cmp    $0x2f,%ebx
  80092b:	7e 3e                	jle    80096b <vprintfmt+0xe9>
  80092d:	83 fb 39             	cmp    $0x39,%ebx
  800930:	7f 39                	jg     80096b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800932:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800935:	eb d5                	jmp    80090c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80094b:	eb 1f                	jmp    80096c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800951:	79 83                	jns    8008d6 <vprintfmt+0x54>
				width = 0;
  800953:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80095a:	e9 77 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800966:	e9 6b ff ff ff       	jmp    8008d6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80096b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800970:	0f 89 60 ff ff ff    	jns    8008d6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800983:	e9 4e ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800988:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80098b:	e9 46 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			break;
  8009b0:	e9 89 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	83 c0 04             	add    $0x4,%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	83 e8 04             	sub    $0x4,%eax
  8009c4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	79 02                	jns    8009cc <vprintfmt+0x14a>
				err = -err;
  8009ca:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009cc:	83 fb 64             	cmp    $0x64,%ebx
  8009cf:	7f 0b                	jg     8009dc <vprintfmt+0x15a>
  8009d1:	8b 34 9d 00 39 80 00 	mov    0x803900(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 a5 3a 80 00       	push   $0x803aa5
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 5e 02 00 00       	call   800c4b <printfmt>
  8009ed:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f0:	e9 49 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f5:	56                   	push   %esi
  8009f6:	68 ae 3a 80 00       	push   $0x803aae
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	ff 75 08             	pushl  0x8(%ebp)
  800a01:	e8 45 02 00 00       	call   800c4b <printfmt>
  800a06:	83 c4 10             	add    $0x10,%esp
			break;
  800a09:	e9 30 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	83 c0 04             	add    $0x4,%eax
  800a14:	89 45 14             	mov    %eax,0x14(%ebp)
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 e8 04             	sub    $0x4,%eax
  800a1d:	8b 30                	mov    (%eax),%esi
  800a1f:	85 f6                	test   %esi,%esi
  800a21:	75 05                	jne    800a28 <vprintfmt+0x1a6>
				p = "(null)";
  800a23:	be b1 3a 80 00       	mov    $0x803ab1,%esi
			if (width > 0 && padc != '-')
  800a28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2c:	7e 6d                	jle    800a9b <vprintfmt+0x219>
  800a2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a32:	74 67                	je     800a9b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	50                   	push   %eax
  800a3b:	56                   	push   %esi
  800a3c:	e8 0c 03 00 00       	call   800d4d <strnlen>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a47:	eb 16                	jmp    800a5f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a49:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	7f e4                	jg     800a49 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a65:	eb 34                	jmp    800a9b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a6b:	74 1c                	je     800a89 <vprintfmt+0x207>
  800a6d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a70:	7e 05                	jle    800a77 <vprintfmt+0x1f5>
  800a72:	83 fb 7e             	cmp    $0x7e,%ebx
  800a75:	7e 12                	jle    800a89 <vprintfmt+0x207>
					putch('?', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 3f                	push   $0x3f
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	eb 0f                	jmp    800a98 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	53                   	push   %ebx
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a98:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9b:	89 f0                	mov    %esi,%eax
  800a9d:	8d 70 01             	lea    0x1(%eax),%esi
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f be d8             	movsbl %al,%ebx
  800aa5:	85 db                	test   %ebx,%ebx
  800aa7:	74 24                	je     800acd <vprintfmt+0x24b>
  800aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aad:	78 b8                	js     800a67 <vprintfmt+0x1e5>
  800aaf:	ff 4d e0             	decl   -0x20(%ebp)
  800ab2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab6:	79 af                	jns    800a67 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab8:	eb 13                	jmp    800acd <vprintfmt+0x24b>
				putch(' ', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 20                	push   $0x20
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aca:	ff 4d e4             	decl   -0x1c(%ebp)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7f e7                	jg     800aba <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad3:	e9 66 01 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ade:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	e8 3c fd ff ff       	call   800823 <getint>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	85 d2                	test   %edx,%edx
  800af8:	79 23                	jns    800b1d <vprintfmt+0x29b>
				putch('-', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 2d                	push   $0x2d
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b10:	f7 d8                	neg    %eax
  800b12:	83 d2 00             	adc    $0x0,%edx
  800b15:	f7 da                	neg    %edx
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b24:	e9 bc 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 84 fc ff ff       	call   8007bc <getuint>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b41:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b48:	e9 98 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 58                	push   $0x58
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 58                	push   $0x58
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 58                	push   $0x58
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			break;
  800b7d:	e9 bc 00 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	6a 30                	push   $0x30
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 78                	push   $0x78
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	83 e8 04             	sub    $0x4,%eax
  800bb1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc4:	eb 1f                	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcf:	50                   	push   %eax
  800bd0:	e8 e7 fb ff ff       	call   8007bc <getuint>
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	52                   	push   %edx
  800bf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 00 fb ff ff       	call   800705 <printnum>
  800c05:	83 c4 20             	add    $0x20,%esp
			break;
  800c08:	eb 34                	jmp    800c3e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	ff d0                	call   *%eax
  800c16:	83 c4 10             	add    $0x10,%esp
			break;
  800c19:	eb 23                	jmp    800c3e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 25                	push   $0x25
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	eb 03                	jmp    800c33 <vprintfmt+0x3b1>
  800c30:	ff 4d 10             	decl   0x10(%ebp)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	48                   	dec    %eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	3c 25                	cmp    $0x25,%al
  800c3b:	75 f3                	jne    800c30 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c3d:	90                   	nop
		}
	}
  800c3e:	e9 47 fc ff ff       	jmp    80088a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c43:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c51:	8d 45 10             	lea    0x10(%ebp),%eax
  800c54:	83 c0 04             	add    $0x4,%eax
  800c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c60:	50                   	push   %eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 16 fc ff ff       	call   800882 <vprintfmt>
  800c6c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6f:	90                   	nop
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8b 40 08             	mov    0x8(%eax),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8b 10                	mov    (%eax),%edx
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 40 04             	mov    0x4(%eax),%eax
  800c8f:	39 c2                	cmp    %eax,%edx
  800c91:	73 12                	jae    800ca5 <sprintputch+0x33>
		*b->buf++ = ch;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	89 0a                	mov    %ecx,(%edx)
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	88 10                	mov    %dl,(%eax)
}
  800ca5:	90                   	nop
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ccd:	74 06                	je     800cd5 <vsnprintf+0x2d>
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	7f 07                	jg     800cdc <vsnprintf+0x34>
		return -E_INVAL;
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	eb 20                	jmp    800cfc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdc:	ff 75 14             	pushl  0x14(%ebp)
  800cdf:	ff 75 10             	pushl  0x10(%ebp)
  800ce2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	68 72 0c 80 00       	push   $0x800c72
  800ceb:	e8 92 fb ff ff       	call   800882 <vprintfmt>
  800cf0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 89 ff ff ff       	call   800ca8 <vsnprintf>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d37:	eb 06                	jmp    800d3f <strlen+0x15>
		n++;
  800d39:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3c:	ff 45 08             	incl   0x8(%ebp)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	84 c0                	test   %al,%al
  800d46:	75 f1                	jne    800d39 <strlen+0xf>
		n++;
	return n;
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5a:	eb 09                	jmp    800d65 <strnlen+0x18>
		n++;
  800d5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	ff 4d 0c             	decl   0xc(%ebp)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 09                	je     800d74 <strnlen+0x27>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	75 e8                	jne    800d5c <strnlen+0xf>
		n++;
	return n;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d85:	90                   	nop
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	84 c0                	test   %al,%al
  800da0:	75 e4                	jne    800d86 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dba:	eb 1f                	jmp    800ddb <strncpy+0x34>
		*dst++ = *src;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc8:	8a 12                	mov    (%edx),%dl
  800dca:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	74 03                	je     800dd8 <strncpy+0x31>
			src++;
  800dd5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd8:	ff 45 fc             	incl   -0x4(%ebp)
  800ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dde:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de1:	72 d9                	jb     800dbc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df8:	74 30                	je     800e2a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfa:	eb 16                	jmp    800e12 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 08             	mov    %edx,0x8(%ebp)
  800e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0e:	8a 12                	mov    (%edx),%dl
  800e10:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e12:	ff 4d 10             	decl   0x10(%ebp)
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 09                	je     800e24 <strlcpy+0x3c>
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 d8                	jne    800dfc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e39:	eb 06                	jmp    800e41 <strcmp+0xb>
		p++, q++;
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 0e                	je     800e58 <strcmp+0x22>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	38 c2                	cmp    %al,%dl
  800e56:	74 e3                	je     800e3b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	0f b6 d0             	movzbl %al,%edx
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 c0             	movzbl %al,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 d0                	mov    %edx,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e71:	eb 09                	jmp    800e7c <strncmp+0xe>
		n--, p++, q++;
  800e73:	ff 4d 10             	decl   0x10(%ebp)
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e80:	74 17                	je     800e99 <strncmp+0x2b>
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	74 0e                	je     800e99 <strncmp+0x2b>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 da                	je     800e73 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	75 07                	jne    800ea6 <strncmp+0x38>
		return 0;
  800e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea4:	eb 14                	jmp    800eba <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 d0             	movzbl %al,%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 c0             	movzbl %al,%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec8:	eb 12                	jmp    800edc <strchr+0x20>
		if (*s == c)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed2:	75 05                	jne    800ed9 <strchr+0x1d>
			return (char *) s;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	eb 11                	jmp    800eea <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	75 e5                	jne    800eca <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 04             	sub    $0x4,%esp
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef8:	eb 0d                	jmp    800f07 <strfind+0x1b>
		if (*s == c)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f02:	74 0e                	je     800f12 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f04:	ff 45 08             	incl   0x8(%ebp)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	84 c0                	test   %al,%al
  800f0e:	75 ea                	jne    800efa <strfind+0xe>
  800f10:	eb 01                	jmp    800f13 <strfind+0x27>
		if (*s == c)
			break;
  800f12:	90                   	nop
	return (char *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f2a:	eb 0e                	jmp    800f3a <memset+0x22>
		*p++ = c;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	8d 50 01             	lea    0x1(%eax),%edx
  800f32:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f38:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f41:	79 e9                	jns    800f2c <memset+0x14>
		*p++ = c;

	return v;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x2a>
		*d++ = *s++;
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80123c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801244:	f7 e9                	imul   %ecx
  801246:	c1 fa 02             	sar    $0x2,%edx
  801249:	89 c8                	mov    %ecx,%eax
  80124b:	c1 f8 1f             	sar    $0x1f,%eax
  80124e:	29 c2                	sub    %eax,%edx
  801250:	89 d0                	mov    %edx,%eax
  801252:	c1 e0 02             	shl    $0x2,%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	01 c0                	add    %eax,%eax
  801259:	29 c1                	sub    %eax,%ecx
  80125b:	89 ca                	mov    %ecx,%edx
  80125d:	85 d2                	test   %edx,%edx
  80125f:	75 9c                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801268:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126b:	48                   	dec    %eax
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801273:	74 3d                	je     8012b2 <ltostr+0xe2>
		start = 1 ;
  801275:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127c:	eb 34                	jmp    8012b2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80127e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c2                	add    %eax,%edx
  801293:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c8                	add    %ecx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012aa:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ac:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012af:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b8:	7c c4                	jl     80127e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c5:	90                   	nop
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ce:	ff 75 08             	pushl  0x8(%ebp)
  8012d1:	e8 54 fa ff ff       	call   800d2a <strlen>
  8012d6:	83 c4 04             	add    $0x4,%esp
  8012d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 46 fa ff ff       	call   800d2a <strlen>
  8012e4:	83 c4 04             	add    $0x4,%esp
  8012e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f8:	eb 17                	jmp    801311 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 c2                	add    %eax,%edx
  801302:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	01 c8                	add    %ecx,%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130e:	ff 45 fc             	incl   -0x4(%ebp)
  801311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801314:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801317:	7c e1                	jl     8012fa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801327:	eb 1f                	jmp    801348 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801332:	89 c2                	mov    %eax,%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 c2                	add    %eax,%edx
  801339:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 c8                	add    %ecx,%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801345:	ff 45 f8             	incl   -0x8(%ebp)
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134e:	7c d9                	jl     801329 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801350:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c6 00 00             	movb   $0x0,(%eax)
}
  80135b:	90                   	nop
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	8b 00                	mov    (%eax),%eax
  80136f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801381:	eb 0c                	jmp    80138f <strsplit+0x31>
			*string++ = 0;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8d 50 01             	lea    0x1(%eax),%edx
  801389:	89 55 08             	mov    %edx,0x8(%ebp)
  80138c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	84 c0                	test   %al,%al
  801396:	74 18                	je     8013b0 <strsplit+0x52>
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f be c0             	movsbl %al,%eax
  8013a0:	50                   	push   %eax
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 13 fb ff ff       	call   800ebc <strchr>
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 d3                	jne    801383 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	84 c0                	test   %al,%al
  8013b7:	74 5a                	je     801413 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	83 f8 0f             	cmp    $0xf,%eax
  8013c1:	75 07                	jne    8013ca <strsplit+0x6c>
		{
			return 0;
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c8:	eb 66                	jmp    801430 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d5:	89 0a                	mov    %ecx,(%edx)
  8013d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013de:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e1:	01 c2                	add    %eax,%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e8:	eb 03                	jmp    8013ed <strsplit+0x8f>
			string++;
  8013ea:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	84 c0                	test   %al,%al
  8013f4:	74 8b                	je     801381 <strsplit+0x23>
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f be c0             	movsbl %al,%eax
  8013fe:	50                   	push   %eax
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	e8 b5 fa ff ff       	call   800ebc <strchr>
  801407:	83 c4 08             	add    $0x8,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 dc                	je     8013ea <strsplit+0x8c>
			string++;
	}
  80140e:	e9 6e ff ff ff       	jmp    801381 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801413:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801438:	a1 04 40 80 00       	mov    0x804004,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 1f                	je     801460 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801441:	e8 1d 00 00 00       	call   801463 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	68 10 3c 80 00       	push   $0x803c10
  80144e:	e8 55 f2 ff ff       	call   8006a8 <cprintf>
  801453:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801456:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80145d:	00 00 00 
	}
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801469:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801470:	00 00 00 
  801473:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80147a:	00 00 00 
  80147d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801484:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801487:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80148e:	00 00 00 
  801491:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801498:	00 00 00 
  80149b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8014a2:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8014a5:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8014ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014b9:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8014be:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8014c5:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8014c8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d2:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8014d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e2:	f7 75 f0             	divl   -0x10(%ebp)
  8014e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e8:	29 d0                	sub    %edx,%eax
  8014ea:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8014ed:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014fc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801501:	83 ec 04             	sub    $0x4,%esp
  801504:	6a 06                	push   $0x6
  801506:	ff 75 e8             	pushl  -0x18(%ebp)
  801509:	50                   	push   %eax
  80150a:	e8 d4 05 00 00       	call   801ae3 <sys_allocate_chunk>
  80150f:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801512:	a1 20 41 80 00       	mov    0x804120,%eax
  801517:	83 ec 0c             	sub    $0xc,%esp
  80151a:	50                   	push   %eax
  80151b:	e8 49 0c 00 00       	call   802169 <initialize_MemBlocksList>
  801520:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801523:	a1 48 41 80 00       	mov    0x804148,%eax
  801528:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  80152b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80152f:	75 14                	jne    801545 <initialize_dyn_block_system+0xe2>
  801531:	83 ec 04             	sub    $0x4,%esp
  801534:	68 35 3c 80 00       	push   $0x803c35
  801539:	6a 39                	push   $0x39
  80153b:	68 53 3c 80 00       	push   $0x803c53
  801540:	e8 af ee ff ff       	call   8003f4 <_panic>
  801545:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801548:	8b 00                	mov    (%eax),%eax
  80154a:	85 c0                	test   %eax,%eax
  80154c:	74 10                	je     80155e <initialize_dyn_block_system+0xfb>
  80154e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801551:	8b 00                	mov    (%eax),%eax
  801553:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801556:	8b 52 04             	mov    0x4(%edx),%edx
  801559:	89 50 04             	mov    %edx,0x4(%eax)
  80155c:	eb 0b                	jmp    801569 <initialize_dyn_block_system+0x106>
  80155e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801561:	8b 40 04             	mov    0x4(%eax),%eax
  801564:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801569:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156c:	8b 40 04             	mov    0x4(%eax),%eax
  80156f:	85 c0                	test   %eax,%eax
  801571:	74 0f                	je     801582 <initialize_dyn_block_system+0x11f>
  801573:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801576:	8b 40 04             	mov    0x4(%eax),%eax
  801579:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80157c:	8b 12                	mov    (%edx),%edx
  80157e:	89 10                	mov    %edx,(%eax)
  801580:	eb 0a                	jmp    80158c <initialize_dyn_block_system+0x129>
  801582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	a3 48 41 80 00       	mov    %eax,0x804148
  80158c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801595:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801598:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80159f:	a1 54 41 80 00       	mov    0x804154,%eax
  8015a4:	48                   	dec    %eax
  8015a5:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  8015aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ad:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8015b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8015be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015c2:	75 14                	jne    8015d8 <initialize_dyn_block_system+0x175>
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	68 60 3c 80 00       	push   $0x803c60
  8015cc:	6a 3f                	push   $0x3f
  8015ce:	68 53 3c 80 00       	push   $0x803c53
  8015d3:	e8 1c ee ff ff       	call   8003f4 <_panic>
  8015d8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8015de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e1:	89 10                	mov    %edx,(%eax)
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	8b 00                	mov    (%eax),%eax
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	74 0d                	je     8015f9 <initialize_dyn_block_system+0x196>
  8015ec:	a1 38 41 80 00       	mov    0x804138,%eax
  8015f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015f4:	89 50 04             	mov    %edx,0x4(%eax)
  8015f7:	eb 08                	jmp    801601 <initialize_dyn_block_system+0x19e>
  8015f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015fc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801604:	a3 38 41 80 00       	mov    %eax,0x804138
  801609:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801613:	a1 44 41 80 00       	mov    0x804144,%eax
  801618:	40                   	inc    %eax
  801619:	a3 44 41 80 00       	mov    %eax,0x804144

}
  80161e:	90                   	nop
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801627:	e8 06 fe ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  80162c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801630:	75 07                	jne    801639 <malloc+0x18>
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
  801637:	eb 7d                	jmp    8016b6 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801639:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801640:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801647:	8b 55 08             	mov    0x8(%ebp),%edx
  80164a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164d:	01 d0                	add    %edx,%eax
  80164f:	48                   	dec    %eax
  801650:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801656:	ba 00 00 00 00       	mov    $0x0,%edx
  80165b:	f7 75 f0             	divl   -0x10(%ebp)
  80165e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801661:	29 d0                	sub    %edx,%eax
  801663:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801666:	e8 46 08 00 00       	call   801eb1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80166b:	83 f8 01             	cmp    $0x1,%eax
  80166e:	75 07                	jne    801677 <malloc+0x56>
  801670:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801677:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80167b:	75 34                	jne    8016b1 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80167d:	83 ec 0c             	sub    $0xc,%esp
  801680:	ff 75 e8             	pushl  -0x18(%ebp)
  801683:	e8 73 0e 00 00       	call   8024fb <alloc_block_FF>
  801688:	83 c4 10             	add    $0x10,%esp
  80168b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80168e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801692:	74 16                	je     8016aa <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	ff 75 e4             	pushl  -0x1c(%ebp)
  80169a:	e8 ff 0b 00 00       	call   80229e <insert_sorted_allocList>
  80169f:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8016a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a5:	8b 40 08             	mov    0x8(%eax),%eax
  8016a8:	eb 0c                	jmp    8016b6 <malloc+0x95>
	             }
	             else
	             	return NULL;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	eb 05                	jmp    8016b6 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8016b1:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
  8016bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8016c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016d2:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8016d5:	83 ec 08             	sub    $0x8,%esp
  8016d8:	ff 75 f4             	pushl  -0xc(%ebp)
  8016db:	68 40 40 80 00       	push   $0x804040
  8016e0:	e8 61 0b 00 00       	call   802246 <find_block>
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8016eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ef:	0f 84 a5 00 00 00    	je     80179a <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8016f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016fb:	83 ec 08             	sub    $0x8,%esp
  8016fe:	50                   	push   %eax
  8016ff:	ff 75 f4             	pushl  -0xc(%ebp)
  801702:	e8 a4 03 00 00       	call   801aab <sys_free_user_mem>
  801707:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  80170a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80170e:	75 17                	jne    801727 <free+0x6f>
  801710:	83 ec 04             	sub    $0x4,%esp
  801713:	68 35 3c 80 00       	push   $0x803c35
  801718:	68 87 00 00 00       	push   $0x87
  80171d:	68 53 3c 80 00       	push   $0x803c53
  801722:	e8 cd ec ff ff       	call   8003f4 <_panic>
  801727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172a:	8b 00                	mov    (%eax),%eax
  80172c:	85 c0                	test   %eax,%eax
  80172e:	74 10                	je     801740 <free+0x88>
  801730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801738:	8b 52 04             	mov    0x4(%edx),%edx
  80173b:	89 50 04             	mov    %edx,0x4(%eax)
  80173e:	eb 0b                	jmp    80174b <free+0x93>
  801740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801743:	8b 40 04             	mov    0x4(%eax),%eax
  801746:	a3 44 40 80 00       	mov    %eax,0x804044
  80174b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174e:	8b 40 04             	mov    0x4(%eax),%eax
  801751:	85 c0                	test   %eax,%eax
  801753:	74 0f                	je     801764 <free+0xac>
  801755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801758:	8b 40 04             	mov    0x4(%eax),%eax
  80175b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80175e:	8b 12                	mov    (%edx),%edx
  801760:	89 10                	mov    %edx,(%eax)
  801762:	eb 0a                	jmp    80176e <free+0xb6>
  801764:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801767:	8b 00                	mov    (%eax),%eax
  801769:	a3 40 40 80 00       	mov    %eax,0x804040
  80176e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801771:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801777:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801781:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801786:	48                   	dec    %eax
  801787:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80178c:	83 ec 0c             	sub    $0xc,%esp
  80178f:	ff 75 ec             	pushl  -0x14(%ebp)
  801792:	e8 37 12 00 00       	call   8029ce <insert_sorted_with_merge_freeList>
  801797:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80179a:	90                   	nop
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 38             	sub    $0x38,%esp
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a9:	e8 84 fc ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017b2:	75 07                	jne    8017bb <smalloc+0x1e>
  8017b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b9:	eb 7e                	jmp    801839 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  8017bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8017c2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cf:	01 d0                	add    %edx,%eax
  8017d1:	48                   	dec    %eax
  8017d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017dd:	f7 75 f0             	divl   -0x10(%ebp)
  8017e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e3:	29 d0                	sub    %edx,%eax
  8017e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8017e8:	e8 c4 06 00 00       	call   801eb1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ed:	83 f8 01             	cmp    $0x1,%eax
  8017f0:	75 42                	jne    801834 <smalloc+0x97>

		  va = malloc(newsize) ;
  8017f2:	83 ec 0c             	sub    $0xc,%esp
  8017f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8017f8:	e8 24 fe ff ff       	call   801621 <malloc>
  8017fd:	83 c4 10             	add    $0x10,%esp
  801800:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801803:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801807:	74 24                	je     80182d <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801809:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80180d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801810:	50                   	push   %eax
  801811:	ff 75 e8             	pushl  -0x18(%ebp)
  801814:	ff 75 08             	pushl  0x8(%ebp)
  801817:	e8 1a 04 00 00       	call   801c36 <sys_createSharedObject>
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801822:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801826:	78 0c                	js     801834 <smalloc+0x97>
					  return va ;
  801828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80182b:	eb 0c                	jmp    801839 <smalloc+0x9c>
				 }
				 else
					return NULL;
  80182d:	b8 00 00 00 00       	mov    $0x0,%eax
  801832:	eb 05                	jmp    801839 <smalloc+0x9c>
	  }
		  return NULL ;
  801834:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801841:	e8 ec fb ff ff       	call   801432 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801846:	83 ec 08             	sub    $0x8,%esp
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	ff 75 08             	pushl  0x8(%ebp)
  80184f:	e8 0c 04 00 00       	call   801c60 <sys_getSizeOfSharedObject>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80185a:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80185e:	75 07                	jne    801867 <sget+0x2c>
  801860:	b8 00 00 00 00       	mov    $0x0,%eax
  801865:	eb 75                	jmp    8018dc <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801867:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80186e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801874:	01 d0                	add    %edx,%eax
  801876:	48                   	dec    %eax
  801877:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80187a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80187d:	ba 00 00 00 00       	mov    $0x0,%edx
  801882:	f7 75 f0             	divl   -0x10(%ebp)
  801885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801888:	29 d0                	sub    %edx,%eax
  80188a:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  80188d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801894:	e8 18 06 00 00       	call   801eb1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801899:	83 f8 01             	cmp    $0x1,%eax
  80189c:	75 39                	jne    8018d7 <sget+0x9c>

		  va = malloc(newsize) ;
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8018a4:	e8 78 fd ff ff       	call   801621 <malloc>
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  8018af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018b3:	74 22                	je     8018d7 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	ff 75 e0             	pushl  -0x20(%ebp)
  8018bb:	ff 75 0c             	pushl  0xc(%ebp)
  8018be:	ff 75 08             	pushl  0x8(%ebp)
  8018c1:	e8 b7 03 00 00       	call   801c7d <sys_getSharedObject>
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  8018cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018d0:	78 05                	js     8018d7 <sget+0x9c>
					  return va;
  8018d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d5:	eb 05                	jmp    8018dc <sget+0xa1>
				  }
			  }
     }
         return NULL;
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e4:	e8 49 fb ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	68 84 3c 80 00       	push   $0x803c84
  8018f1:	68 1e 01 00 00       	push   $0x11e
  8018f6:	68 53 3c 80 00       	push   $0x803c53
  8018fb:	e8 f4 ea ff ff       	call   8003f4 <_panic>

00801900 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	68 ac 3c 80 00       	push   $0x803cac
  80190e:	68 32 01 00 00       	push   $0x132
  801913:	68 53 3c 80 00       	push   $0x803c53
  801918:	e8 d7 ea ff ff       	call   8003f4 <_panic>

0080191d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	68 d0 3c 80 00       	push   $0x803cd0
  80192b:	68 3d 01 00 00       	push   $0x13d
  801930:	68 53 3c 80 00       	push   $0x803c53
  801935:	e8 ba ea ff ff       	call   8003f4 <_panic>

0080193a <shrink>:

}
void shrink(uint32 newSize)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801940:	83 ec 04             	sub    $0x4,%esp
  801943:	68 d0 3c 80 00       	push   $0x803cd0
  801948:	68 42 01 00 00       	push   $0x142
  80194d:	68 53 3c 80 00       	push   $0x803c53
  801952:	e8 9d ea ff ff       	call   8003f4 <_panic>

00801957 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80195d:	83 ec 04             	sub    $0x4,%esp
  801960:	68 d0 3c 80 00       	push   $0x803cd0
  801965:	68 47 01 00 00       	push   $0x147
  80196a:	68 53 3c 80 00       	push   $0x803c53
  80196f:	e8 80 ea ff ff       	call   8003f4 <_panic>

00801974 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	57                   	push   %edi
  801978:	56                   	push   %esi
  801979:	53                   	push   %ebx
  80197a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	8b 55 0c             	mov    0xc(%ebp),%edx
  801983:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801986:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801989:	8b 7d 18             	mov    0x18(%ebp),%edi
  80198c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80198f:	cd 30                	int    $0x30
  801991:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801994:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	5b                   	pop    %ebx
  80199b:	5e                   	pop    %esi
  80199c:	5f                   	pop    %edi
  80199d:	5d                   	pop    %ebp
  80199e:	c3                   	ret    

0080199f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 04             	sub    $0x4,%esp
  8019a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	52                   	push   %edx
  8019b7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ba:	50                   	push   %eax
  8019bb:	6a 00                	push   $0x0
  8019bd:	e8 b2 ff ff ff       	call   801974 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 01                	push   $0x1
  8019d7:	e8 98 ff ff ff       	call   801974 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	52                   	push   %edx
  8019f1:	50                   	push   %eax
  8019f2:	6a 05                	push   $0x5
  8019f4:	e8 7b ff ff ff       	call   801974 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	56                   	push   %esi
  801a02:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a03:	8b 75 18             	mov    0x18(%ebp),%esi
  801a06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
  801a14:	51                   	push   %ecx
  801a15:	52                   	push   %edx
  801a16:	50                   	push   %eax
  801a17:	6a 06                	push   $0x6
  801a19:	e8 56 ff ff ff       	call   801974 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
}
  801a21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a24:	5b                   	pop    %ebx
  801a25:	5e                   	pop    %esi
  801a26:	5d                   	pop    %ebp
  801a27:	c3                   	ret    

00801a28 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	6a 07                	push   $0x7
  801a3b:	e8 34 ff ff ff       	call   801974 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	ff 75 0c             	pushl  0xc(%ebp)
  801a51:	ff 75 08             	pushl  0x8(%ebp)
  801a54:	6a 08                	push   $0x8
  801a56:	e8 19 ff ff ff       	call   801974 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 09                	push   $0x9
  801a6f:	e8 00 ff ff ff       	call   801974 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 0a                	push   $0xa
  801a88:	e8 e7 fe ff ff       	call   801974 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 0b                	push   $0xb
  801aa1:	e8 ce fe ff ff       	call   801974 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	ff 75 08             	pushl  0x8(%ebp)
  801aba:	6a 0f                	push   $0xf
  801abc:	e8 b3 fe ff ff       	call   801974 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
	return;
  801ac4:	90                   	nop
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	ff 75 0c             	pushl  0xc(%ebp)
  801ad3:	ff 75 08             	pushl  0x8(%ebp)
  801ad6:	6a 10                	push   $0x10
  801ad8:	e8 97 fe ff ff       	call   801974 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae0:	90                   	nop
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	ff 75 10             	pushl  0x10(%ebp)
  801aed:	ff 75 0c             	pushl  0xc(%ebp)
  801af0:	ff 75 08             	pushl  0x8(%ebp)
  801af3:	6a 11                	push   $0x11
  801af5:	e8 7a fe ff ff       	call   801974 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
	return ;
  801afd:	90                   	nop
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 0c                	push   $0xc
  801b0f:	e8 60 fe ff ff       	call   801974 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	ff 75 08             	pushl  0x8(%ebp)
  801b27:	6a 0d                	push   $0xd
  801b29:	e8 46 fe ff ff       	call   801974 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 0e                	push   $0xe
  801b42:	e8 2d fe ff ff       	call   801974 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	90                   	nop
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 13                	push   $0x13
  801b5c:	e8 13 fe ff ff       	call   801974 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 14                	push   $0x14
  801b76:	e8 f9 fd ff ff       	call   801974 <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
}
  801b7e:	90                   	nop
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 04             	sub    $0x4,%esp
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b8d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	50                   	push   %eax
  801b9a:	6a 15                	push   $0x15
  801b9c:	e8 d3 fd ff ff       	call   801974 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	90                   	nop
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 16                	push   $0x16
  801bb6:	e8 b9 fd ff ff       	call   801974 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	90                   	nop
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	50                   	push   %eax
  801bd1:	6a 17                	push   $0x17
  801bd3:	e8 9c fd ff ff       	call   801974 <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	52                   	push   %edx
  801bed:	50                   	push   %eax
  801bee:	6a 1a                	push   $0x1a
  801bf0:	e8 7f fd ff ff       	call   801974 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	52                   	push   %edx
  801c0a:	50                   	push   %eax
  801c0b:	6a 18                	push   $0x18
  801c0d:	e8 62 fd ff ff       	call   801974 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	90                   	nop
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	52                   	push   %edx
  801c28:	50                   	push   %eax
  801c29:	6a 19                	push   $0x19
  801c2b:	e8 44 fd ff ff       	call   801974 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	90                   	nop
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c42:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c45:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	51                   	push   %ecx
  801c4f:	52                   	push   %edx
  801c50:	ff 75 0c             	pushl  0xc(%ebp)
  801c53:	50                   	push   %eax
  801c54:	6a 1b                	push   $0x1b
  801c56:	e8 19 fd ff ff       	call   801974 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	52                   	push   %edx
  801c70:	50                   	push   %eax
  801c71:	6a 1c                	push   $0x1c
  801c73:	e8 fc fc ff ff       	call   801974 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c80:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	51                   	push   %ecx
  801c8e:	52                   	push   %edx
  801c8f:	50                   	push   %eax
  801c90:	6a 1d                	push   $0x1d
  801c92:	e8 dd fc ff ff       	call   801974 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	52                   	push   %edx
  801cac:	50                   	push   %eax
  801cad:	6a 1e                	push   $0x1e
  801caf:	e8 c0 fc ff ff       	call   801974 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 1f                	push   $0x1f
  801cc8:	e8 a7 fc ff ff       	call   801974 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	6a 00                	push   $0x0
  801cda:	ff 75 14             	pushl  0x14(%ebp)
  801cdd:	ff 75 10             	pushl  0x10(%ebp)
  801ce0:	ff 75 0c             	pushl  0xc(%ebp)
  801ce3:	50                   	push   %eax
  801ce4:	6a 20                	push   $0x20
  801ce6:	e8 89 fc ff ff       	call   801974 <syscall>
  801ceb:	83 c4 18             	add    $0x18,%esp
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	50                   	push   %eax
  801cff:	6a 21                	push   $0x21
  801d01:	e8 6e fc ff ff       	call   801974 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	90                   	nop
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	50                   	push   %eax
  801d1b:	6a 22                	push   $0x22
  801d1d:	e8 52 fc ff ff       	call   801974 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 02                	push   $0x2
  801d36:	e8 39 fc ff ff       	call   801974 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 03                	push   $0x3
  801d4f:	e8 20 fc ff ff       	call   801974 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 04                	push   $0x4
  801d68:	e8 07 fc ff ff       	call   801974 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_exit_env>:


void sys_exit_env(void)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 23                	push   $0x23
  801d81:	e8 ee fb ff ff       	call   801974 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	90                   	nop
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d95:	8d 50 04             	lea    0x4(%eax),%edx
  801d98:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	52                   	push   %edx
  801da2:	50                   	push   %eax
  801da3:	6a 24                	push   $0x24
  801da5:	e8 ca fb ff ff       	call   801974 <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
	return result;
  801dad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801db0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801db3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801db6:	89 01                	mov    %eax,(%ecx)
  801db8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	c9                   	leave  
  801dbf:	c2 04 00             	ret    $0x4

00801dc2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	ff 75 10             	pushl  0x10(%ebp)
  801dcc:	ff 75 0c             	pushl  0xc(%ebp)
  801dcf:	ff 75 08             	pushl  0x8(%ebp)
  801dd2:	6a 12                	push   $0x12
  801dd4:	e8 9b fb ff ff       	call   801974 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddc:	90                   	nop
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_rcr2>:
uint32 sys_rcr2()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 25                	push   $0x25
  801dee:	e8 81 fb ff ff       	call   801974 <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 04             	sub    $0x4,%esp
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e04:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	50                   	push   %eax
  801e11:	6a 26                	push   $0x26
  801e13:	e8 5c fb ff ff       	call   801974 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1b:	90                   	nop
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <rsttst>:
void rsttst()
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 28                	push   $0x28
  801e2d:	e8 42 fb ff ff       	call   801974 <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
	return ;
  801e35:	90                   	nop
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 04             	sub    $0x4,%esp
  801e3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e44:	8b 55 18             	mov    0x18(%ebp),%edx
  801e47:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e4b:	52                   	push   %edx
  801e4c:	50                   	push   %eax
  801e4d:	ff 75 10             	pushl  0x10(%ebp)
  801e50:	ff 75 0c             	pushl  0xc(%ebp)
  801e53:	ff 75 08             	pushl  0x8(%ebp)
  801e56:	6a 27                	push   $0x27
  801e58:	e8 17 fb ff ff       	call   801974 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e60:	90                   	nop
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <chktst>:
void chktst(uint32 n)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	ff 75 08             	pushl  0x8(%ebp)
  801e71:	6a 29                	push   $0x29
  801e73:	e8 fc fa ff ff       	call   801974 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7b:	90                   	nop
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <inctst>:

void inctst()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 2a                	push   $0x2a
  801e8d:	e8 e2 fa ff ff       	call   801974 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return ;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <gettst>:
uint32 gettst()
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 2b                	push   $0x2b
  801ea7:	e8 c8 fa ff ff       	call   801974 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 2c                	push   $0x2c
  801ec3:	e8 ac fa ff ff       	call   801974 <syscall>
  801ec8:	83 c4 18             	add    $0x18,%esp
  801ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ece:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ed2:	75 07                	jne    801edb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ed4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed9:	eb 05                	jmp    801ee0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801edb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 2c                	push   $0x2c
  801ef4:	e8 7b fa ff ff       	call   801974 <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
  801efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eff:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f03:	75 07                	jne    801f0c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f05:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0a:	eb 05                	jmp    801f11 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 2c                	push   $0x2c
  801f25:	e8 4a fa ff ff       	call   801974 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
  801f2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f30:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f34:	75 07                	jne    801f3d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f36:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3b:	eb 05                	jmp    801f42 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 2c                	push   $0x2c
  801f56:	e8 19 fa ff ff       	call   801974 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
  801f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f61:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f65:	75 07                	jne    801f6e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f67:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6c:	eb 05                	jmp    801f73 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	6a 2d                	push   $0x2d
  801f85:	e8 ea f9 ff ff       	call   801974 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8d:	90                   	nop
}
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f94:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	6a 00                	push   $0x0
  801fa2:	53                   	push   %ebx
  801fa3:	51                   	push   %ecx
  801fa4:	52                   	push   %edx
  801fa5:	50                   	push   %eax
  801fa6:	6a 2e                	push   $0x2e
  801fa8:	e8 c7 f9 ff ff       	call   801974 <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb3:	c9                   	leave  
  801fb4:	c3                   	ret    

00801fb5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	52                   	push   %edx
  801fc5:	50                   	push   %eax
  801fc6:	6a 2f                	push   $0x2f
  801fc8:	e8 a7 f9 ff ff       	call   801974 <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fd8:	83 ec 0c             	sub    $0xc,%esp
  801fdb:	68 e0 3c 80 00       	push   $0x803ce0
  801fe0:	e8 c3 e6 ff ff       	call   8006a8 <cprintf>
  801fe5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fe8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fef:	83 ec 0c             	sub    $0xc,%esp
  801ff2:	68 0c 3d 80 00       	push   $0x803d0c
  801ff7:	e8 ac e6 ff ff       	call   8006a8 <cprintf>
  801ffc:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fff:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802003:	a1 38 41 80 00       	mov    0x804138,%eax
  802008:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200b:	eb 56                	jmp    802063 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80200d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802011:	74 1c                	je     80202f <print_mem_block_lists+0x5d>
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	8b 50 08             	mov    0x8(%eax),%edx
  802019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201c:	8b 48 08             	mov    0x8(%eax),%ecx
  80201f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802022:	8b 40 0c             	mov    0xc(%eax),%eax
  802025:	01 c8                	add    %ecx,%eax
  802027:	39 c2                	cmp    %eax,%edx
  802029:	73 04                	jae    80202f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80202b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	8b 50 08             	mov    0x8(%eax),%edx
  802035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802038:	8b 40 0c             	mov    0xc(%eax),%eax
  80203b:	01 c2                	add    %eax,%edx
  80203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802040:	8b 40 08             	mov    0x8(%eax),%eax
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	52                   	push   %edx
  802047:	50                   	push   %eax
  802048:	68 21 3d 80 00       	push   $0x803d21
  80204d:	e8 56 e6 ff ff       	call   8006a8 <cprintf>
  802052:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802058:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80205b:	a1 40 41 80 00       	mov    0x804140,%eax
  802060:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802063:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802067:	74 07                	je     802070 <print_mem_block_lists+0x9e>
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	8b 00                	mov    (%eax),%eax
  80206e:	eb 05                	jmp    802075 <print_mem_block_lists+0xa3>
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
  802075:	a3 40 41 80 00       	mov    %eax,0x804140
  80207a:	a1 40 41 80 00       	mov    0x804140,%eax
  80207f:	85 c0                	test   %eax,%eax
  802081:	75 8a                	jne    80200d <print_mem_block_lists+0x3b>
  802083:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802087:	75 84                	jne    80200d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802089:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80208d:	75 10                	jne    80209f <print_mem_block_lists+0xcd>
  80208f:	83 ec 0c             	sub    $0xc,%esp
  802092:	68 30 3d 80 00       	push   $0x803d30
  802097:	e8 0c e6 ff ff       	call   8006a8 <cprintf>
  80209c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80209f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020a6:	83 ec 0c             	sub    $0xc,%esp
  8020a9:	68 54 3d 80 00       	push   $0x803d54
  8020ae:	e8 f5 e5 ff ff       	call   8006a8 <cprintf>
  8020b3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020b6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020ba:	a1 40 40 80 00       	mov    0x804040,%eax
  8020bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c2:	eb 56                	jmp    80211a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c8:	74 1c                	je     8020e6 <print_mem_block_lists+0x114>
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 50 08             	mov    0x8(%eax),%edx
  8020d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d3:	8b 48 08             	mov    0x8(%eax),%ecx
  8020d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020dc:	01 c8                	add    %ecx,%eax
  8020de:	39 c2                	cmp    %eax,%edx
  8020e0:	73 04                	jae    8020e6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020e2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	8b 50 08             	mov    0x8(%eax),%edx
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f2:	01 c2                	add    %eax,%edx
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	8b 40 08             	mov    0x8(%eax),%eax
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	52                   	push   %edx
  8020fe:	50                   	push   %eax
  8020ff:	68 21 3d 80 00       	push   $0x803d21
  802104:	e8 9f e5 ff ff       	call   8006a8 <cprintf>
  802109:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802112:	a1 48 40 80 00       	mov    0x804048,%eax
  802117:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80211a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211e:	74 07                	je     802127 <print_mem_block_lists+0x155>
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	8b 00                	mov    (%eax),%eax
  802125:	eb 05                	jmp    80212c <print_mem_block_lists+0x15a>
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
  80212c:	a3 48 40 80 00       	mov    %eax,0x804048
  802131:	a1 48 40 80 00       	mov    0x804048,%eax
  802136:	85 c0                	test   %eax,%eax
  802138:	75 8a                	jne    8020c4 <print_mem_block_lists+0xf2>
  80213a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213e:	75 84                	jne    8020c4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802140:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802144:	75 10                	jne    802156 <print_mem_block_lists+0x184>
  802146:	83 ec 0c             	sub    $0xc,%esp
  802149:	68 6c 3d 80 00       	push   $0x803d6c
  80214e:	e8 55 e5 ff ff       	call   8006a8 <cprintf>
  802153:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	68 e0 3c 80 00       	push   $0x803ce0
  80215e:	e8 45 e5 ff ff       	call   8006a8 <cprintf>
  802163:	83 c4 10             	add    $0x10,%esp

}
  802166:	90                   	nop
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80216f:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802176:	00 00 00 
  802179:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802180:	00 00 00 
  802183:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80218a:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80218d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802194:	e9 9e 00 00 00       	jmp    802237 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802199:	a1 50 40 80 00       	mov    0x804050,%eax
  80219e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a1:	c1 e2 04             	shl    $0x4,%edx
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	75 14                	jne    8021be <initialize_MemBlocksList+0x55>
  8021aa:	83 ec 04             	sub    $0x4,%esp
  8021ad:	68 94 3d 80 00       	push   $0x803d94
  8021b2:	6a 47                	push   $0x47
  8021b4:	68 b7 3d 80 00       	push   $0x803db7
  8021b9:	e8 36 e2 ff ff       	call   8003f4 <_panic>
  8021be:	a1 50 40 80 00       	mov    0x804050,%eax
  8021c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c6:	c1 e2 04             	shl    $0x4,%edx
  8021c9:	01 d0                	add    %edx,%eax
  8021cb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021d1:	89 10                	mov    %edx,(%eax)
  8021d3:	8b 00                	mov    (%eax),%eax
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	74 18                	je     8021f1 <initialize_MemBlocksList+0x88>
  8021d9:	a1 48 41 80 00       	mov    0x804148,%eax
  8021de:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021e4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021e7:	c1 e1 04             	shl    $0x4,%ecx
  8021ea:	01 ca                	add    %ecx,%edx
  8021ec:	89 50 04             	mov    %edx,0x4(%eax)
  8021ef:	eb 12                	jmp    802203 <initialize_MemBlocksList+0x9a>
  8021f1:	a1 50 40 80 00       	mov    0x804050,%eax
  8021f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f9:	c1 e2 04             	shl    $0x4,%edx
  8021fc:	01 d0                	add    %edx,%eax
  8021fe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802203:	a1 50 40 80 00       	mov    0x804050,%eax
  802208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220b:	c1 e2 04             	shl    $0x4,%edx
  80220e:	01 d0                	add    %edx,%eax
  802210:	a3 48 41 80 00       	mov    %eax,0x804148
  802215:	a1 50 40 80 00       	mov    0x804050,%eax
  80221a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221d:	c1 e2 04             	shl    $0x4,%edx
  802220:	01 d0                	add    %edx,%eax
  802222:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802229:	a1 54 41 80 00       	mov    0x804154,%eax
  80222e:	40                   	inc    %eax
  80222f:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802234:	ff 45 f4             	incl   -0xc(%ebp)
  802237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223d:	0f 82 56 ff ff ff    	jb     802199 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802243:	90                   	nop
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	8b 00                	mov    (%eax),%eax
  802251:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802254:	eb 19                	jmp    80226f <find_block+0x29>
	{
		if(element->sva == va){
  802256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802259:	8b 40 08             	mov    0x8(%eax),%eax
  80225c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80225f:	75 05                	jne    802266 <find_block+0x20>
			 		return element;
  802261:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802264:	eb 36                	jmp    80229c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 40 08             	mov    0x8(%eax),%eax
  80226c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80226f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802273:	74 07                	je     80227c <find_block+0x36>
  802275:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802278:	8b 00                	mov    (%eax),%eax
  80227a:	eb 05                	jmp    802281 <find_block+0x3b>
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
  802281:	8b 55 08             	mov    0x8(%ebp),%edx
  802284:	89 42 08             	mov    %eax,0x8(%edx)
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	8b 40 08             	mov    0x8(%eax),%eax
  80228d:	85 c0                	test   %eax,%eax
  80228f:	75 c5                	jne    802256 <find_block+0x10>
  802291:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802295:	75 bf                	jne    802256 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8022a4:	a1 44 40 80 00       	mov    0x804044,%eax
  8022a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8022ac:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8022b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022b8:	74 0a                	je     8022c4 <insert_sorted_allocList+0x26>
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	8b 40 08             	mov    0x8(%eax),%eax
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	75 65                	jne    802329 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8022c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c8:	75 14                	jne    8022de <insert_sorted_allocList+0x40>
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	68 94 3d 80 00       	push   $0x803d94
  8022d2:	6a 6e                	push   $0x6e
  8022d4:	68 b7 3d 80 00       	push   $0x803db7
  8022d9:	e8 16 e1 ff ff       	call   8003f4 <_panic>
  8022de:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	89 10                	mov    %edx,(%eax)
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	8b 00                	mov    (%eax),%eax
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	74 0d                	je     8022ff <insert_sorted_allocList+0x61>
  8022f2:	a1 40 40 80 00       	mov    0x804040,%eax
  8022f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fa:	89 50 04             	mov    %edx,0x4(%eax)
  8022fd:	eb 08                	jmp    802307 <insert_sorted_allocList+0x69>
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	a3 44 40 80 00       	mov    %eax,0x804044
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	a3 40 40 80 00       	mov    %eax,0x804040
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802319:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231e:	40                   	inc    %eax
  80231f:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802324:	e9 cf 01 00 00       	jmp    8024f8 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232c:	8b 50 08             	mov    0x8(%eax),%edx
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	8b 40 08             	mov    0x8(%eax),%eax
  802335:	39 c2                	cmp    %eax,%edx
  802337:	73 65                	jae    80239e <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802339:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233d:	75 14                	jne    802353 <insert_sorted_allocList+0xb5>
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	68 d0 3d 80 00       	push   $0x803dd0
  802347:	6a 72                	push   $0x72
  802349:	68 b7 3d 80 00       	push   $0x803db7
  80234e:	e8 a1 e0 ff ff       	call   8003f4 <_panic>
  802353:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	89 50 04             	mov    %edx,0x4(%eax)
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	8b 40 04             	mov    0x4(%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	74 0c                	je     802375 <insert_sorted_allocList+0xd7>
  802369:	a1 44 40 80 00       	mov    0x804044,%eax
  80236e:	8b 55 08             	mov    0x8(%ebp),%edx
  802371:	89 10                	mov    %edx,(%eax)
  802373:	eb 08                	jmp    80237d <insert_sorted_allocList+0xdf>
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	a3 40 40 80 00       	mov    %eax,0x804040
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	a3 44 40 80 00       	mov    %eax,0x804044
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802393:	40                   	inc    %eax
  802394:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802399:	e9 5a 01 00 00       	jmp    8024f8 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80239e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a1:	8b 50 08             	mov    0x8(%eax),%edx
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	8b 40 08             	mov    0x8(%eax),%eax
  8023aa:	39 c2                	cmp    %eax,%edx
  8023ac:	75 70                	jne    80241e <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8023ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b2:	74 06                	je     8023ba <insert_sorted_allocList+0x11c>
  8023b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b8:	75 14                	jne    8023ce <insert_sorted_allocList+0x130>
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	68 f4 3d 80 00       	push   $0x803df4
  8023c2:	6a 75                	push   $0x75
  8023c4:	68 b7 3d 80 00       	push   $0x803db7
  8023c9:	e8 26 e0 ff ff       	call   8003f4 <_panic>
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 10                	mov    (%eax),%edx
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	89 10                	mov    %edx,(%eax)
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	8b 00                	mov    (%eax),%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	74 0b                	je     8023ec <insert_sorted_allocList+0x14e>
  8023e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e9:	89 50 04             	mov    %edx,0x4(%eax)
  8023ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f2:	89 10                	mov    %edx,(%eax)
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fa:	89 50 04             	mov    %edx,0x4(%eax)
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	75 08                	jne    80240e <insert_sorted_allocList+0x170>
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	a3 44 40 80 00       	mov    %eax,0x804044
  80240e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802413:	40                   	inc    %eax
  802414:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802419:	e9 da 00 00 00       	jmp    8024f8 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80241e:	a1 40 40 80 00       	mov    0x804040,%eax
  802423:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802426:	e9 9d 00 00 00       	jmp    8024c8 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 00                	mov    (%eax),%eax
  802430:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	8b 50 08             	mov    0x8(%eax),%edx
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 40 08             	mov    0x8(%eax),%eax
  80243f:	39 c2                	cmp    %eax,%edx
  802441:	76 7d                	jbe    8024c0 <insert_sorted_allocList+0x222>
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	8b 50 08             	mov    0x8(%eax),%edx
  802449:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80244c:	8b 40 08             	mov    0x8(%eax),%eax
  80244f:	39 c2                	cmp    %eax,%edx
  802451:	73 6d                	jae    8024c0 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802453:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802457:	74 06                	je     80245f <insert_sorted_allocList+0x1c1>
  802459:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80245d:	75 14                	jne    802473 <insert_sorted_allocList+0x1d5>
  80245f:	83 ec 04             	sub    $0x4,%esp
  802462:	68 f4 3d 80 00       	push   $0x803df4
  802467:	6a 7c                	push   $0x7c
  802469:	68 b7 3d 80 00       	push   $0x803db7
  80246e:	e8 81 df ff ff       	call   8003f4 <_panic>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 10                	mov    (%eax),%edx
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	89 10                	mov    %edx,(%eax)
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	74 0b                	je     802491 <insert_sorted_allocList+0x1f3>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	8b 55 08             	mov    0x8(%ebp),%edx
  80248e:	89 50 04             	mov    %edx,0x4(%eax)
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	8b 55 08             	mov    0x8(%ebp),%edx
  802497:	89 10                	mov    %edx,(%eax)
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249f:	89 50 04             	mov    %edx,0x4(%eax)
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	75 08                	jne    8024b3 <insert_sorted_allocList+0x215>
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	a3 44 40 80 00       	mov    %eax,0x804044
  8024b3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024b8:	40                   	inc    %eax
  8024b9:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8024be:	eb 38                	jmp    8024f8 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8024c0:	a1 48 40 80 00       	mov    0x804048,%eax
  8024c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cc:	74 07                	je     8024d5 <insert_sorted_allocList+0x237>
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 00                	mov    (%eax),%eax
  8024d3:	eb 05                	jmp    8024da <insert_sorted_allocList+0x23c>
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024da:	a3 48 40 80 00       	mov    %eax,0x804048
  8024df:	a1 48 40 80 00       	mov    0x804048,%eax
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	0f 85 3f ff ff ff    	jne    80242b <insert_sorted_allocList+0x18d>
  8024ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f0:	0f 85 35 ff ff ff    	jne    80242b <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8024f6:	eb 00                	jmp    8024f8 <insert_sorted_allocList+0x25a>
  8024f8:	90                   	nop
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802501:	a1 38 41 80 00       	mov    0x804138,%eax
  802506:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802509:	e9 6b 02 00 00       	jmp    802779 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 40 0c             	mov    0xc(%eax),%eax
  802514:	3b 45 08             	cmp    0x8(%ebp),%eax
  802517:	0f 85 90 00 00 00    	jne    8025ad <alloc_block_FF+0xb2>
			  temp=element;
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802523:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802527:	75 17                	jne    802540 <alloc_block_FF+0x45>
  802529:	83 ec 04             	sub    $0x4,%esp
  80252c:	68 28 3e 80 00       	push   $0x803e28
  802531:	68 92 00 00 00       	push   $0x92
  802536:	68 b7 3d 80 00       	push   $0x803db7
  80253b:	e8 b4 de ff ff       	call   8003f4 <_panic>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	85 c0                	test   %eax,%eax
  802547:	74 10                	je     802559 <alloc_block_FF+0x5e>
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802551:	8b 52 04             	mov    0x4(%edx),%edx
  802554:	89 50 04             	mov    %edx,0x4(%eax)
  802557:	eb 0b                	jmp    802564 <alloc_block_FF+0x69>
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 04             	mov    0x4(%eax),%eax
  80255f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 40 04             	mov    0x4(%eax),%eax
  80256a:	85 c0                	test   %eax,%eax
  80256c:	74 0f                	je     80257d <alloc_block_FF+0x82>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 40 04             	mov    0x4(%eax),%eax
  802574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802577:	8b 12                	mov    (%edx),%edx
  802579:	89 10                	mov    %edx,(%eax)
  80257b:	eb 0a                	jmp    802587 <alloc_block_FF+0x8c>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	a3 38 41 80 00       	mov    %eax,0x804138
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259a:	a1 44 41 80 00       	mov    0x804144,%eax
  80259f:	48                   	dec    %eax
  8025a0:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  8025a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025a8:	e9 ff 01 00 00       	jmp    8027ac <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b6:	0f 86 b5 01 00 00    	jbe    802771 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c2:	2b 45 08             	sub    0x8(%ebp),%eax
  8025c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8025c8:	a1 48 41 80 00       	mov    0x804148,%eax
  8025cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8025d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025d4:	75 17                	jne    8025ed <alloc_block_FF+0xf2>
  8025d6:	83 ec 04             	sub    $0x4,%esp
  8025d9:	68 28 3e 80 00       	push   $0x803e28
  8025de:	68 99 00 00 00       	push   $0x99
  8025e3:	68 b7 3d 80 00       	push   $0x803db7
  8025e8:	e8 07 de ff ff       	call   8003f4 <_panic>
  8025ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f0:	8b 00                	mov    (%eax),%eax
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	74 10                	je     802606 <alloc_block_FF+0x10b>
  8025f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f9:	8b 00                	mov    (%eax),%eax
  8025fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025fe:	8b 52 04             	mov    0x4(%edx),%edx
  802601:	89 50 04             	mov    %edx,0x4(%eax)
  802604:	eb 0b                	jmp    802611 <alloc_block_FF+0x116>
  802606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802611:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802614:	8b 40 04             	mov    0x4(%eax),%eax
  802617:	85 c0                	test   %eax,%eax
  802619:	74 0f                	je     80262a <alloc_block_FF+0x12f>
  80261b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802624:	8b 12                	mov    (%edx),%edx
  802626:	89 10                	mov    %edx,(%eax)
  802628:	eb 0a                	jmp    802634 <alloc_block_FF+0x139>
  80262a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	a3 48 41 80 00       	mov    %eax,0x804148
  802634:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802637:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802640:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802647:	a1 54 41 80 00       	mov    0x804154,%eax
  80264c:	48                   	dec    %eax
  80264d:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802652:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802656:	75 17                	jne    80266f <alloc_block_FF+0x174>
  802658:	83 ec 04             	sub    $0x4,%esp
  80265b:	68 d0 3d 80 00       	push   $0x803dd0
  802660:	68 9a 00 00 00       	push   $0x9a
  802665:	68 b7 3d 80 00       	push   $0x803db7
  80266a:	e8 85 dd ff ff       	call   8003f4 <_panic>
  80266f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802675:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802678:	89 50 04             	mov    %edx,0x4(%eax)
  80267b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267e:	8b 40 04             	mov    0x4(%eax),%eax
  802681:	85 c0                	test   %eax,%eax
  802683:	74 0c                	je     802691 <alloc_block_FF+0x196>
  802685:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80268a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80268d:	89 10                	mov    %edx,(%eax)
  80268f:	eb 08                	jmp    802699 <alloc_block_FF+0x19e>
  802691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802694:	a3 38 41 80 00       	mov    %eax,0x804138
  802699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026aa:	a1 44 41 80 00       	mov    0x804144,%eax
  8026af:	40                   	inc    %eax
  8026b0:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  8026b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026bb:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 50 08             	mov    0x8(%eax),%edx
  8026c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c7:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d0:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 50 08             	mov    0x8(%eax),%edx
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	01 c2                	add    %eax,%edx
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8026e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8026ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026ee:	75 17                	jne    802707 <alloc_block_FF+0x20c>
  8026f0:	83 ec 04             	sub    $0x4,%esp
  8026f3:	68 28 3e 80 00       	push   $0x803e28
  8026f8:	68 a2 00 00 00       	push   $0xa2
  8026fd:	68 b7 3d 80 00       	push   $0x803db7
  802702:	e8 ed dc ff ff       	call   8003f4 <_panic>
  802707:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	85 c0                	test   %eax,%eax
  80270e:	74 10                	je     802720 <alloc_block_FF+0x225>
  802710:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802718:	8b 52 04             	mov    0x4(%edx),%edx
  80271b:	89 50 04             	mov    %edx,0x4(%eax)
  80271e:	eb 0b                	jmp    80272b <alloc_block_FF+0x230>
  802720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802723:	8b 40 04             	mov    0x4(%eax),%eax
  802726:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80272b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272e:	8b 40 04             	mov    0x4(%eax),%eax
  802731:	85 c0                	test   %eax,%eax
  802733:	74 0f                	je     802744 <alloc_block_FF+0x249>
  802735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802738:	8b 40 04             	mov    0x4(%eax),%eax
  80273b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80273e:	8b 12                	mov    (%edx),%edx
  802740:	89 10                	mov    %edx,(%eax)
  802742:	eb 0a                	jmp    80274e <alloc_block_FF+0x253>
  802744:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802747:	8b 00                	mov    (%eax),%eax
  802749:	a3 38 41 80 00       	mov    %eax,0x804138
  80274e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802751:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802757:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802761:	a1 44 41 80 00       	mov    0x804144,%eax
  802766:	48                   	dec    %eax
  802767:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80276c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276f:	eb 3b                	jmp    8027ac <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802771:	a1 40 41 80 00       	mov    0x804140,%eax
  802776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277d:	74 07                	je     802786 <alloc_block_FF+0x28b>
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	eb 05                	jmp    80278b <alloc_block_FF+0x290>
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
  80278b:	a3 40 41 80 00       	mov    %eax,0x804140
  802790:	a1 40 41 80 00       	mov    0x804140,%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	0f 85 71 fd ff ff    	jne    80250e <alloc_block_FF+0x13>
  80279d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a1:	0f 85 67 fd ff ff    	jne    80250e <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  8027b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  8027bb:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8027c2:	a1 38 41 80 00       	mov    0x804138,%eax
  8027c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8027ca:	e9 d3 00 00 00       	jmp    8028a2 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  8027cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d8:	0f 85 90 00 00 00    	jne    80286e <alloc_block_BF+0xc0>
	   temp = element;
  8027de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8027e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027e8:	75 17                	jne    802801 <alloc_block_BF+0x53>
  8027ea:	83 ec 04             	sub    $0x4,%esp
  8027ed:	68 28 3e 80 00       	push   $0x803e28
  8027f2:	68 bd 00 00 00       	push   $0xbd
  8027f7:	68 b7 3d 80 00       	push   $0x803db7
  8027fc:	e8 f3 db ff ff       	call   8003f4 <_panic>
  802801:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 10                	je     80281a <alloc_block_BF+0x6c>
  80280a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802812:	8b 52 04             	mov    0x4(%edx),%edx
  802815:	89 50 04             	mov    %edx,0x4(%eax)
  802818:	eb 0b                	jmp    802825 <alloc_block_BF+0x77>
  80281a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80281d:	8b 40 04             	mov    0x4(%eax),%eax
  802820:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802825:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802828:	8b 40 04             	mov    0x4(%eax),%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	74 0f                	je     80283e <alloc_block_BF+0x90>
  80282f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802832:	8b 40 04             	mov    0x4(%eax),%eax
  802835:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802838:	8b 12                	mov    (%edx),%edx
  80283a:	89 10                	mov    %edx,(%eax)
  80283c:	eb 0a                	jmp    802848 <alloc_block_BF+0x9a>
  80283e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802841:	8b 00                	mov    (%eax),%eax
  802843:	a3 38 41 80 00       	mov    %eax,0x804138
  802848:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80284b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802854:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285b:	a1 44 41 80 00       	mov    0x804144,%eax
  802860:	48                   	dec    %eax
  802861:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802866:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802869:	e9 41 01 00 00       	jmp    8029af <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  80286e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802871:	8b 40 0c             	mov    0xc(%eax),%eax
  802874:	3b 45 08             	cmp    0x8(%ebp),%eax
  802877:	76 21                	jbe    80289a <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802879:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80287c:	8b 40 0c             	mov    0xc(%eax),%eax
  80287f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802882:	73 16                	jae    80289a <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802884:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802887:	8b 40 0c             	mov    0xc(%eax),%eax
  80288a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  80288d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802890:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802893:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80289a:	a1 40 41 80 00       	mov    0x804140,%eax
  80289f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8028a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028a6:	74 07                	je     8028af <alloc_block_BF+0x101>
  8028a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	eb 05                	jmp    8028b4 <alloc_block_BF+0x106>
  8028af:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b4:	a3 40 41 80 00       	mov    %eax,0x804140
  8028b9:	a1 40 41 80 00       	mov    0x804140,%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	0f 85 09 ff ff ff    	jne    8027cf <alloc_block_BF+0x21>
  8028c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028ca:	0f 85 ff fe ff ff    	jne    8027cf <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  8028d0:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8028d4:	0f 85 d0 00 00 00    	jne    8029aa <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8028e6:	a1 48 41 80 00       	mov    0x804148,%eax
  8028eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8028ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028f2:	75 17                	jne    80290b <alloc_block_BF+0x15d>
  8028f4:	83 ec 04             	sub    $0x4,%esp
  8028f7:	68 28 3e 80 00       	push   $0x803e28
  8028fc:	68 d1 00 00 00       	push   $0xd1
  802901:	68 b7 3d 80 00       	push   $0x803db7
  802906:	e8 e9 da ff ff       	call   8003f4 <_panic>
  80290b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290e:	8b 00                	mov    (%eax),%eax
  802910:	85 c0                	test   %eax,%eax
  802912:	74 10                	je     802924 <alloc_block_BF+0x176>
  802914:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80291c:	8b 52 04             	mov    0x4(%edx),%edx
  80291f:	89 50 04             	mov    %edx,0x4(%eax)
  802922:	eb 0b                	jmp    80292f <alloc_block_BF+0x181>
  802924:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802927:	8b 40 04             	mov    0x4(%eax),%eax
  80292a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80292f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802932:	8b 40 04             	mov    0x4(%eax),%eax
  802935:	85 c0                	test   %eax,%eax
  802937:	74 0f                	je     802948 <alloc_block_BF+0x19a>
  802939:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802942:	8b 12                	mov    (%edx),%edx
  802944:	89 10                	mov    %edx,(%eax)
  802946:	eb 0a                	jmp    802952 <alloc_block_BF+0x1a4>
  802948:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	a3 48 41 80 00       	mov    %eax,0x804148
  802952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802955:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802965:	a1 54 41 80 00       	mov    0x804154,%eax
  80296a:	48                   	dec    %eax
  80296b:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802973:	8b 55 08             	mov    0x8(%ebp),%edx
  802976:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802979:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297c:	8b 50 08             	mov    0x8(%eax),%edx
  80297f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802982:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802988:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80298b:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  80298e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802991:	8b 50 08             	mov    0x8(%eax),%edx
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	01 c2                	add    %eax,%edx
  802999:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299c:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  80299f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  8029a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029a8:	eb 05                	jmp    8029af <alloc_block_BF+0x201>
	 }
	 return NULL;
  8029aa:	b8 00 00 00 00       	mov    $0x0,%eax


}
  8029af:	c9                   	leave  
  8029b0:	c3                   	ret    

008029b1 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
  8029b4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  8029b7:	83 ec 04             	sub    $0x4,%esp
  8029ba:	68 48 3e 80 00       	push   $0x803e48
  8029bf:	68 e8 00 00 00       	push   $0xe8
  8029c4:	68 b7 3d 80 00       	push   $0x803db7
  8029c9:	e8 26 da ff ff       	call   8003f4 <_panic>

008029ce <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
  8029d1:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  8029d4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  8029dc:	a1 38 41 80 00       	mov    0x804138,%eax
  8029e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  8029e4:	a1 44 41 80 00       	mov    0x804144,%eax
  8029e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  8029ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f0:	75 68                	jne    802a5a <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f6:	75 17                	jne    802a0f <insert_sorted_with_merge_freeList+0x41>
  8029f8:	83 ec 04             	sub    $0x4,%esp
  8029fb:	68 94 3d 80 00       	push   $0x803d94
  802a00:	68 36 01 00 00       	push   $0x136
  802a05:	68 b7 3d 80 00       	push   $0x803db7
  802a0a:	e8 e5 d9 ff ff       	call   8003f4 <_panic>
  802a0f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	89 10                	mov    %edx,(%eax)
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	8b 00                	mov    (%eax),%eax
  802a1f:	85 c0                	test   %eax,%eax
  802a21:	74 0d                	je     802a30 <insert_sorted_with_merge_freeList+0x62>
  802a23:	a1 38 41 80 00       	mov    0x804138,%eax
  802a28:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2b:	89 50 04             	mov    %edx,0x4(%eax)
  802a2e:	eb 08                	jmp    802a38 <insert_sorted_with_merge_freeList+0x6a>
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	a3 38 41 80 00       	mov    %eax,0x804138
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a4f:	40                   	inc    %eax
  802a50:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802a55:	e9 ba 06 00 00       	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5d:	8b 50 08             	mov    0x8(%eax),%edx
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	8b 40 0c             	mov    0xc(%eax),%eax
  802a66:	01 c2                	add    %eax,%edx
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	8b 40 08             	mov    0x8(%eax),%eax
  802a6e:	39 c2                	cmp    %eax,%edx
  802a70:	73 68                	jae    802ada <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a76:	75 17                	jne    802a8f <insert_sorted_with_merge_freeList+0xc1>
  802a78:	83 ec 04             	sub    $0x4,%esp
  802a7b:	68 d0 3d 80 00       	push   $0x803dd0
  802a80:	68 3a 01 00 00       	push   $0x13a
  802a85:	68 b7 3d 80 00       	push   $0x803db7
  802a8a:	e8 65 d9 ff ff       	call   8003f4 <_panic>
  802a8f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	89 50 04             	mov    %edx,0x4(%eax)
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 0c                	je     802ab1 <insert_sorted_with_merge_freeList+0xe3>
  802aa5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aaa:	8b 55 08             	mov    0x8(%ebp),%edx
  802aad:	89 10                	mov    %edx,(%eax)
  802aaf:	eb 08                	jmp    802ab9 <insert_sorted_with_merge_freeList+0xeb>
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aca:	a1 44 41 80 00       	mov    0x804144,%eax
  802acf:	40                   	inc    %eax
  802ad0:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802ad5:	e9 3a 06 00 00       	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802add:	8b 50 08             	mov    0x8(%eax),%edx
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae6:	01 c2                	add    %eax,%edx
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	8b 40 08             	mov    0x8(%eax),%eax
  802aee:	39 c2                	cmp    %eax,%edx
  802af0:	0f 85 90 00 00 00    	jne    802b86 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	8b 50 0c             	mov    0xc(%eax),%edx
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	8b 40 0c             	mov    0xc(%eax),%eax
  802b02:	01 c2                	add    %eax,%edx
  802b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b07:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b22:	75 17                	jne    802b3b <insert_sorted_with_merge_freeList+0x16d>
  802b24:	83 ec 04             	sub    $0x4,%esp
  802b27:	68 94 3d 80 00       	push   $0x803d94
  802b2c:	68 41 01 00 00       	push   $0x141
  802b31:	68 b7 3d 80 00       	push   $0x803db7
  802b36:	e8 b9 d8 ff ff       	call   8003f4 <_panic>
  802b3b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	89 10                	mov    %edx,(%eax)
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 0d                	je     802b5c <insert_sorted_with_merge_freeList+0x18e>
  802b4f:	a1 48 41 80 00       	mov    0x804148,%eax
  802b54:	8b 55 08             	mov    0x8(%ebp),%edx
  802b57:	89 50 04             	mov    %edx,0x4(%eax)
  802b5a:	eb 08                	jmp    802b64 <insert_sorted_with_merge_freeList+0x196>
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	a3 48 41 80 00       	mov    %eax,0x804148
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b76:	a1 54 41 80 00       	mov    0x804154,%eax
  802b7b:	40                   	inc    %eax
  802b7c:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802b81:	e9 8e 05 00 00       	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	8b 50 08             	mov    0x8(%eax),%edx
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b92:	01 c2                	add    %eax,%edx
  802b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b97:	8b 40 08             	mov    0x8(%eax),%eax
  802b9a:	39 c2                	cmp    %eax,%edx
  802b9c:	73 68                	jae    802c06 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba2:	75 17                	jne    802bbb <insert_sorted_with_merge_freeList+0x1ed>
  802ba4:	83 ec 04             	sub    $0x4,%esp
  802ba7:	68 94 3d 80 00       	push   $0x803d94
  802bac:	68 45 01 00 00       	push   $0x145
  802bb1:	68 b7 3d 80 00       	push   $0x803db7
  802bb6:	e8 39 d8 ff ff       	call   8003f4 <_panic>
  802bbb:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	89 10                	mov    %edx,(%eax)
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	8b 00                	mov    (%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 0d                	je     802bdc <insert_sorted_with_merge_freeList+0x20e>
  802bcf:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd7:	89 50 04             	mov    %edx,0x4(%eax)
  802bda:	eb 08                	jmp    802be4 <insert_sorted_with_merge_freeList+0x216>
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	a3 38 41 80 00       	mov    %eax,0x804138
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf6:	a1 44 41 80 00       	mov    0x804144,%eax
  802bfb:	40                   	inc    %eax
  802bfc:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802c01:	e9 0e 05 00 00       	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 50 08             	mov    0x8(%eax),%edx
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c12:	01 c2                	add    %eax,%edx
  802c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c17:	8b 40 08             	mov    0x8(%eax),%eax
  802c1a:	39 c2                	cmp    %eax,%edx
  802c1c:	0f 85 9c 00 00 00    	jne    802cbe <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c25:	8b 50 0c             	mov    0xc(%eax),%edx
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2e:	01 c2                	add    %eax,%edx
  802c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c33:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	8b 50 08             	mov    0x8(%eax),%edx
  802c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3f:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5a:	75 17                	jne    802c73 <insert_sorted_with_merge_freeList+0x2a5>
  802c5c:	83 ec 04             	sub    $0x4,%esp
  802c5f:	68 94 3d 80 00       	push   $0x803d94
  802c64:	68 4d 01 00 00       	push   $0x14d
  802c69:	68 b7 3d 80 00       	push   $0x803db7
  802c6e:	e8 81 d7 ff ff       	call   8003f4 <_panic>
  802c73:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	89 10                	mov    %edx,(%eax)
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 0d                	je     802c94 <insert_sorted_with_merge_freeList+0x2c6>
  802c87:	a1 48 41 80 00       	mov    0x804148,%eax
  802c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8f:	89 50 04             	mov    %edx,0x4(%eax)
  802c92:	eb 08                	jmp    802c9c <insert_sorted_with_merge_freeList+0x2ce>
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	a3 48 41 80 00       	mov    %eax,0x804148
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cae:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb3:	40                   	inc    %eax
  802cb4:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802cb9:	e9 56 04 00 00       	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802cbe:	a1 38 41 80 00       	mov    0x804138,%eax
  802cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc6:	e9 19 04 00 00       	jmp    8030e4 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 50 08             	mov    0x8(%eax),%edx
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdf:	01 c2                	add    %eax,%edx
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	8b 40 08             	mov    0x8(%eax),%eax
  802ce7:	39 c2                	cmp    %eax,%edx
  802ce9:	0f 85 ad 01 00 00    	jne    802e9c <insert_sorted_with_merge_freeList+0x4ce>
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	8b 50 08             	mov    0x8(%eax),%edx
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfb:	01 c2                	add    %eax,%edx
  802cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d00:	8b 40 08             	mov    0x8(%eax),%eax
  802d03:	39 c2                	cmp    %eax,%edx
  802d05:	0f 85 91 01 00 00    	jne    802e9c <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1d:	01 c8                	add    %ecx,%eax
  802d1f:	01 c2                	add    %eax,%edx
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d3e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802d45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802d4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d53:	75 17                	jne    802d6c <insert_sorted_with_merge_freeList+0x39e>
  802d55:	83 ec 04             	sub    $0x4,%esp
  802d58:	68 28 3e 80 00       	push   $0x803e28
  802d5d:	68 5b 01 00 00       	push   $0x15b
  802d62:	68 b7 3d 80 00       	push   $0x803db7
  802d67:	e8 88 d6 ff ff       	call   8003f4 <_panic>
  802d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 10                	je     802d85 <insert_sorted_with_merge_freeList+0x3b7>
  802d75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d78:	8b 00                	mov    (%eax),%eax
  802d7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d7d:	8b 52 04             	mov    0x4(%edx),%edx
  802d80:	89 50 04             	mov    %edx,0x4(%eax)
  802d83:	eb 0b                	jmp    802d90 <insert_sorted_with_merge_freeList+0x3c2>
  802d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d88:	8b 40 04             	mov    0x4(%eax),%eax
  802d8b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 0f                	je     802da9 <insert_sorted_with_merge_freeList+0x3db>
  802d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802da3:	8b 12                	mov    (%edx),%edx
  802da5:	89 10                	mov    %edx,(%eax)
  802da7:	eb 0a                	jmp    802db3 <insert_sorted_with_merge_freeList+0x3e5>
  802da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	a3 38 41 80 00       	mov    %eax,0x804138
  802db3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc6:	a1 44 41 80 00       	mov    0x804144,%eax
  802dcb:	48                   	dec    %eax
  802dcc:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd5:	75 17                	jne    802dee <insert_sorted_with_merge_freeList+0x420>
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	68 94 3d 80 00       	push   $0x803d94
  802ddf:	68 5c 01 00 00       	push   $0x15c
  802de4:	68 b7 3d 80 00       	push   $0x803db7
  802de9:	e8 06 d6 ff ff       	call   8003f4 <_panic>
  802dee:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	89 10                	mov    %edx,(%eax)
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 0d                	je     802e0f <insert_sorted_with_merge_freeList+0x441>
  802e02:	a1 48 41 80 00       	mov    0x804148,%eax
  802e07:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0a:	89 50 04             	mov    %edx,0x4(%eax)
  802e0d:	eb 08                	jmp    802e17 <insert_sorted_with_merge_freeList+0x449>
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e29:	a1 54 41 80 00       	mov    0x804154,%eax
  802e2e:	40                   	inc    %eax
  802e2f:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802e34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e38:	75 17                	jne    802e51 <insert_sorted_with_merge_freeList+0x483>
  802e3a:	83 ec 04             	sub    $0x4,%esp
  802e3d:	68 94 3d 80 00       	push   $0x803d94
  802e42:	68 5d 01 00 00       	push   $0x15d
  802e47:	68 b7 3d 80 00       	push   $0x803db7
  802e4c:	e8 a3 d5 ff ff       	call   8003f4 <_panic>
  802e51:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5a:	89 10                	mov    %edx,(%eax)
  802e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	74 0d                	je     802e72 <insert_sorted_with_merge_freeList+0x4a4>
  802e65:	a1 48 41 80 00       	mov    0x804148,%eax
  802e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e6d:	89 50 04             	mov    %edx,0x4(%eax)
  802e70:	eb 08                	jmp    802e7a <insert_sorted_with_merge_freeList+0x4ac>
  802e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e75:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7d:	a3 48 41 80 00       	mov    %eax,0x804148
  802e82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8c:	a1 54 41 80 00       	mov    0x804154,%eax
  802e91:	40                   	inc    %eax
  802e92:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802e97:	e9 78 02 00 00       	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 50 08             	mov    0x8(%eax),%edx
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea8:	01 c2                	add    %eax,%edx
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	8b 40 08             	mov    0x8(%eax),%eax
  802eb0:	39 c2                	cmp    %eax,%edx
  802eb2:	0f 83 b8 00 00 00    	jae    802f70 <insert_sorted_with_merge_freeList+0x5a2>
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	8b 50 08             	mov    0x8(%eax),%edx
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec4:	01 c2                	add    %eax,%edx
  802ec6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec9:	8b 40 08             	mov    0x8(%eax),%eax
  802ecc:	39 c2                	cmp    %eax,%edx
  802ece:	0f 85 9c 00 00 00    	jne    802f70 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed7:	8b 50 0c             	mov    0xc(%eax),%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee0:	01 c2                	add    %eax,%edx
  802ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee5:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	8b 50 08             	mov    0x8(%eax),%edx
  802eee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef1:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f0c:	75 17                	jne    802f25 <insert_sorted_with_merge_freeList+0x557>
  802f0e:	83 ec 04             	sub    $0x4,%esp
  802f11:	68 94 3d 80 00       	push   $0x803d94
  802f16:	68 67 01 00 00       	push   $0x167
  802f1b:	68 b7 3d 80 00       	push   $0x803db7
  802f20:	e8 cf d4 ff ff       	call   8003f4 <_panic>
  802f25:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	89 10                	mov    %edx,(%eax)
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 0d                	je     802f46 <insert_sorted_with_merge_freeList+0x578>
  802f39:	a1 48 41 80 00       	mov    0x804148,%eax
  802f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f41:	89 50 04             	mov    %edx,0x4(%eax)
  802f44:	eb 08                	jmp    802f4e <insert_sorted_with_merge_freeList+0x580>
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	a3 48 41 80 00       	mov    %eax,0x804148
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f60:	a1 54 41 80 00       	mov    0x804154,%eax
  802f65:	40                   	inc    %eax
  802f66:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f6b:	e9 a4 01 00 00       	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 50 08             	mov    0x8(%eax),%edx
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7c:	01 c2                	add    %eax,%edx
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	8b 40 08             	mov    0x8(%eax),%eax
  802f84:	39 c2                	cmp    %eax,%edx
  802f86:	0f 85 ac 00 00 00    	jne    803038 <insert_sorted_with_merge_freeList+0x66a>
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	8b 50 08             	mov    0x8(%eax),%edx
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	8b 40 0c             	mov    0xc(%eax),%eax
  802f98:	01 c2                	add    %eax,%edx
  802f9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9d:	8b 40 08             	mov    0x8(%eax),%eax
  802fa0:	39 c2                	cmp    %eax,%edx
  802fa2:	0f 83 90 00 00 00    	jae    803038 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 50 0c             	mov    0xc(%eax),%edx
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb4:	01 c2                	add    %eax,%edx
  802fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb9:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd4:	75 17                	jne    802fed <insert_sorted_with_merge_freeList+0x61f>
  802fd6:	83 ec 04             	sub    $0x4,%esp
  802fd9:	68 94 3d 80 00       	push   $0x803d94
  802fde:	68 70 01 00 00       	push   $0x170
  802fe3:	68 b7 3d 80 00       	push   $0x803db7
  802fe8:	e8 07 d4 ff ff       	call   8003f4 <_panic>
  802fed:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	89 10                	mov    %edx,(%eax)
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 0d                	je     80300e <insert_sorted_with_merge_freeList+0x640>
  803001:	a1 48 41 80 00       	mov    0x804148,%eax
  803006:	8b 55 08             	mov    0x8(%ebp),%edx
  803009:	89 50 04             	mov    %edx,0x4(%eax)
  80300c:	eb 08                	jmp    803016 <insert_sorted_with_merge_freeList+0x648>
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	a3 48 41 80 00       	mov    %eax,0x804148
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803028:	a1 54 41 80 00       	mov    0x804154,%eax
  80302d:	40                   	inc    %eax
  80302e:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  803033:	e9 dc 00 00 00       	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 50 08             	mov    0x8(%eax),%edx
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 40 0c             	mov    0xc(%eax),%eax
  803044:	01 c2                	add    %eax,%edx
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	8b 40 08             	mov    0x8(%eax),%eax
  80304c:	39 c2                	cmp    %eax,%edx
  80304e:	0f 83 88 00 00 00    	jae    8030dc <insert_sorted_with_merge_freeList+0x70e>
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 50 08             	mov    0x8(%eax),%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	8b 40 0c             	mov    0xc(%eax),%eax
  803060:	01 c2                	add    %eax,%edx
  803062:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803065:	8b 40 08             	mov    0x8(%eax),%eax
  803068:	39 c2                	cmp    %eax,%edx
  80306a:	73 70                	jae    8030dc <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80306c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803070:	74 06                	je     803078 <insert_sorted_with_merge_freeList+0x6aa>
  803072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803076:	75 17                	jne    80308f <insert_sorted_with_merge_freeList+0x6c1>
  803078:	83 ec 04             	sub    $0x4,%esp
  80307b:	68 f4 3d 80 00       	push   $0x803df4
  803080:	68 75 01 00 00       	push   $0x175
  803085:	68 b7 3d 80 00       	push   $0x803db7
  80308a:	e8 65 d3 ff ff       	call   8003f4 <_panic>
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 10                	mov    (%eax),%edx
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	89 10                	mov    %edx,(%eax)
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 0b                	je     8030ad <insert_sorted_with_merge_freeList+0x6df>
  8030a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a5:	8b 00                	mov    (%eax),%eax
  8030a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030aa:	89 50 04             	mov    %edx,0x4(%eax)
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b3:	89 10                	mov    %edx,(%eax)
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030bb:	89 50 04             	mov    %edx,0x4(%eax)
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	75 08                	jne    8030cf <insert_sorted_with_merge_freeList+0x701>
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030cf:	a1 44 41 80 00       	mov    0x804144,%eax
  8030d4:	40                   	inc    %eax
  8030d5:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  8030da:	eb 38                	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8030dc:	a1 40 41 80 00       	mov    0x804140,%eax
  8030e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e8:	74 07                	je     8030f1 <insert_sorted_with_merge_freeList+0x723>
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	8b 00                	mov    (%eax),%eax
  8030ef:	eb 05                	jmp    8030f6 <insert_sorted_with_merge_freeList+0x728>
  8030f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f6:	a3 40 41 80 00       	mov    %eax,0x804140
  8030fb:	a1 40 41 80 00       	mov    0x804140,%eax
  803100:	85 c0                	test   %eax,%eax
  803102:	0f 85 c3 fb ff ff    	jne    802ccb <insert_sorted_with_merge_freeList+0x2fd>
  803108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310c:	0f 85 b9 fb ff ff    	jne    802ccb <insert_sorted_with_merge_freeList+0x2fd>





}
  803112:	eb 00                	jmp    803114 <insert_sorted_with_merge_freeList+0x746>
  803114:	90                   	nop
  803115:	c9                   	leave  
  803116:	c3                   	ret    
  803117:	90                   	nop

00803118 <__udivdi3>:
  803118:	55                   	push   %ebp
  803119:	57                   	push   %edi
  80311a:	56                   	push   %esi
  80311b:	53                   	push   %ebx
  80311c:	83 ec 1c             	sub    $0x1c,%esp
  80311f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803123:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803127:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80312b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80312f:	89 ca                	mov    %ecx,%edx
  803131:	89 f8                	mov    %edi,%eax
  803133:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803137:	85 f6                	test   %esi,%esi
  803139:	75 2d                	jne    803168 <__udivdi3+0x50>
  80313b:	39 cf                	cmp    %ecx,%edi
  80313d:	77 65                	ja     8031a4 <__udivdi3+0x8c>
  80313f:	89 fd                	mov    %edi,%ebp
  803141:	85 ff                	test   %edi,%edi
  803143:	75 0b                	jne    803150 <__udivdi3+0x38>
  803145:	b8 01 00 00 00       	mov    $0x1,%eax
  80314a:	31 d2                	xor    %edx,%edx
  80314c:	f7 f7                	div    %edi
  80314e:	89 c5                	mov    %eax,%ebp
  803150:	31 d2                	xor    %edx,%edx
  803152:	89 c8                	mov    %ecx,%eax
  803154:	f7 f5                	div    %ebp
  803156:	89 c1                	mov    %eax,%ecx
  803158:	89 d8                	mov    %ebx,%eax
  80315a:	f7 f5                	div    %ebp
  80315c:	89 cf                	mov    %ecx,%edi
  80315e:	89 fa                	mov    %edi,%edx
  803160:	83 c4 1c             	add    $0x1c,%esp
  803163:	5b                   	pop    %ebx
  803164:	5e                   	pop    %esi
  803165:	5f                   	pop    %edi
  803166:	5d                   	pop    %ebp
  803167:	c3                   	ret    
  803168:	39 ce                	cmp    %ecx,%esi
  80316a:	77 28                	ja     803194 <__udivdi3+0x7c>
  80316c:	0f bd fe             	bsr    %esi,%edi
  80316f:	83 f7 1f             	xor    $0x1f,%edi
  803172:	75 40                	jne    8031b4 <__udivdi3+0x9c>
  803174:	39 ce                	cmp    %ecx,%esi
  803176:	72 0a                	jb     803182 <__udivdi3+0x6a>
  803178:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80317c:	0f 87 9e 00 00 00    	ja     803220 <__udivdi3+0x108>
  803182:	b8 01 00 00 00       	mov    $0x1,%eax
  803187:	89 fa                	mov    %edi,%edx
  803189:	83 c4 1c             	add    $0x1c,%esp
  80318c:	5b                   	pop    %ebx
  80318d:	5e                   	pop    %esi
  80318e:	5f                   	pop    %edi
  80318f:	5d                   	pop    %ebp
  803190:	c3                   	ret    
  803191:	8d 76 00             	lea    0x0(%esi),%esi
  803194:	31 ff                	xor    %edi,%edi
  803196:	31 c0                	xor    %eax,%eax
  803198:	89 fa                	mov    %edi,%edx
  80319a:	83 c4 1c             	add    $0x1c,%esp
  80319d:	5b                   	pop    %ebx
  80319e:	5e                   	pop    %esi
  80319f:	5f                   	pop    %edi
  8031a0:	5d                   	pop    %ebp
  8031a1:	c3                   	ret    
  8031a2:	66 90                	xchg   %ax,%ax
  8031a4:	89 d8                	mov    %ebx,%eax
  8031a6:	f7 f7                	div    %edi
  8031a8:	31 ff                	xor    %edi,%edi
  8031aa:	89 fa                	mov    %edi,%edx
  8031ac:	83 c4 1c             	add    $0x1c,%esp
  8031af:	5b                   	pop    %ebx
  8031b0:	5e                   	pop    %esi
  8031b1:	5f                   	pop    %edi
  8031b2:	5d                   	pop    %ebp
  8031b3:	c3                   	ret    
  8031b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031b9:	89 eb                	mov    %ebp,%ebx
  8031bb:	29 fb                	sub    %edi,%ebx
  8031bd:	89 f9                	mov    %edi,%ecx
  8031bf:	d3 e6                	shl    %cl,%esi
  8031c1:	89 c5                	mov    %eax,%ebp
  8031c3:	88 d9                	mov    %bl,%cl
  8031c5:	d3 ed                	shr    %cl,%ebp
  8031c7:	89 e9                	mov    %ebp,%ecx
  8031c9:	09 f1                	or     %esi,%ecx
  8031cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031cf:	89 f9                	mov    %edi,%ecx
  8031d1:	d3 e0                	shl    %cl,%eax
  8031d3:	89 c5                	mov    %eax,%ebp
  8031d5:	89 d6                	mov    %edx,%esi
  8031d7:	88 d9                	mov    %bl,%cl
  8031d9:	d3 ee                	shr    %cl,%esi
  8031db:	89 f9                	mov    %edi,%ecx
  8031dd:	d3 e2                	shl    %cl,%edx
  8031df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e3:	88 d9                	mov    %bl,%cl
  8031e5:	d3 e8                	shr    %cl,%eax
  8031e7:	09 c2                	or     %eax,%edx
  8031e9:	89 d0                	mov    %edx,%eax
  8031eb:	89 f2                	mov    %esi,%edx
  8031ed:	f7 74 24 0c          	divl   0xc(%esp)
  8031f1:	89 d6                	mov    %edx,%esi
  8031f3:	89 c3                	mov    %eax,%ebx
  8031f5:	f7 e5                	mul    %ebp
  8031f7:	39 d6                	cmp    %edx,%esi
  8031f9:	72 19                	jb     803214 <__udivdi3+0xfc>
  8031fb:	74 0b                	je     803208 <__udivdi3+0xf0>
  8031fd:	89 d8                	mov    %ebx,%eax
  8031ff:	31 ff                	xor    %edi,%edi
  803201:	e9 58 ff ff ff       	jmp    80315e <__udivdi3+0x46>
  803206:	66 90                	xchg   %ax,%ax
  803208:	8b 54 24 08          	mov    0x8(%esp),%edx
  80320c:	89 f9                	mov    %edi,%ecx
  80320e:	d3 e2                	shl    %cl,%edx
  803210:	39 c2                	cmp    %eax,%edx
  803212:	73 e9                	jae    8031fd <__udivdi3+0xe5>
  803214:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803217:	31 ff                	xor    %edi,%edi
  803219:	e9 40 ff ff ff       	jmp    80315e <__udivdi3+0x46>
  80321e:	66 90                	xchg   %ax,%ax
  803220:	31 c0                	xor    %eax,%eax
  803222:	e9 37 ff ff ff       	jmp    80315e <__udivdi3+0x46>
  803227:	90                   	nop

00803228 <__umoddi3>:
  803228:	55                   	push   %ebp
  803229:	57                   	push   %edi
  80322a:	56                   	push   %esi
  80322b:	53                   	push   %ebx
  80322c:	83 ec 1c             	sub    $0x1c,%esp
  80322f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803233:	8b 74 24 34          	mov    0x34(%esp),%esi
  803237:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80323b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80323f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803243:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803247:	89 f3                	mov    %esi,%ebx
  803249:	89 fa                	mov    %edi,%edx
  80324b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80324f:	89 34 24             	mov    %esi,(%esp)
  803252:	85 c0                	test   %eax,%eax
  803254:	75 1a                	jne    803270 <__umoddi3+0x48>
  803256:	39 f7                	cmp    %esi,%edi
  803258:	0f 86 a2 00 00 00    	jbe    803300 <__umoddi3+0xd8>
  80325e:	89 c8                	mov    %ecx,%eax
  803260:	89 f2                	mov    %esi,%edx
  803262:	f7 f7                	div    %edi
  803264:	89 d0                	mov    %edx,%eax
  803266:	31 d2                	xor    %edx,%edx
  803268:	83 c4 1c             	add    $0x1c,%esp
  80326b:	5b                   	pop    %ebx
  80326c:	5e                   	pop    %esi
  80326d:	5f                   	pop    %edi
  80326e:	5d                   	pop    %ebp
  80326f:	c3                   	ret    
  803270:	39 f0                	cmp    %esi,%eax
  803272:	0f 87 ac 00 00 00    	ja     803324 <__umoddi3+0xfc>
  803278:	0f bd e8             	bsr    %eax,%ebp
  80327b:	83 f5 1f             	xor    $0x1f,%ebp
  80327e:	0f 84 ac 00 00 00    	je     803330 <__umoddi3+0x108>
  803284:	bf 20 00 00 00       	mov    $0x20,%edi
  803289:	29 ef                	sub    %ebp,%edi
  80328b:	89 fe                	mov    %edi,%esi
  80328d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803291:	89 e9                	mov    %ebp,%ecx
  803293:	d3 e0                	shl    %cl,%eax
  803295:	89 d7                	mov    %edx,%edi
  803297:	89 f1                	mov    %esi,%ecx
  803299:	d3 ef                	shr    %cl,%edi
  80329b:	09 c7                	or     %eax,%edi
  80329d:	89 e9                	mov    %ebp,%ecx
  80329f:	d3 e2                	shl    %cl,%edx
  8032a1:	89 14 24             	mov    %edx,(%esp)
  8032a4:	89 d8                	mov    %ebx,%eax
  8032a6:	d3 e0                	shl    %cl,%eax
  8032a8:	89 c2                	mov    %eax,%edx
  8032aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ae:	d3 e0                	shl    %cl,%eax
  8032b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032b8:	89 f1                	mov    %esi,%ecx
  8032ba:	d3 e8                	shr    %cl,%eax
  8032bc:	09 d0                	or     %edx,%eax
  8032be:	d3 eb                	shr    %cl,%ebx
  8032c0:	89 da                	mov    %ebx,%edx
  8032c2:	f7 f7                	div    %edi
  8032c4:	89 d3                	mov    %edx,%ebx
  8032c6:	f7 24 24             	mull   (%esp)
  8032c9:	89 c6                	mov    %eax,%esi
  8032cb:	89 d1                	mov    %edx,%ecx
  8032cd:	39 d3                	cmp    %edx,%ebx
  8032cf:	0f 82 87 00 00 00    	jb     80335c <__umoddi3+0x134>
  8032d5:	0f 84 91 00 00 00    	je     80336c <__umoddi3+0x144>
  8032db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032df:	29 f2                	sub    %esi,%edx
  8032e1:	19 cb                	sbb    %ecx,%ebx
  8032e3:	89 d8                	mov    %ebx,%eax
  8032e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032e9:	d3 e0                	shl    %cl,%eax
  8032eb:	89 e9                	mov    %ebp,%ecx
  8032ed:	d3 ea                	shr    %cl,%edx
  8032ef:	09 d0                	or     %edx,%eax
  8032f1:	89 e9                	mov    %ebp,%ecx
  8032f3:	d3 eb                	shr    %cl,%ebx
  8032f5:	89 da                	mov    %ebx,%edx
  8032f7:	83 c4 1c             	add    $0x1c,%esp
  8032fa:	5b                   	pop    %ebx
  8032fb:	5e                   	pop    %esi
  8032fc:	5f                   	pop    %edi
  8032fd:	5d                   	pop    %ebp
  8032fe:	c3                   	ret    
  8032ff:	90                   	nop
  803300:	89 fd                	mov    %edi,%ebp
  803302:	85 ff                	test   %edi,%edi
  803304:	75 0b                	jne    803311 <__umoddi3+0xe9>
  803306:	b8 01 00 00 00       	mov    $0x1,%eax
  80330b:	31 d2                	xor    %edx,%edx
  80330d:	f7 f7                	div    %edi
  80330f:	89 c5                	mov    %eax,%ebp
  803311:	89 f0                	mov    %esi,%eax
  803313:	31 d2                	xor    %edx,%edx
  803315:	f7 f5                	div    %ebp
  803317:	89 c8                	mov    %ecx,%eax
  803319:	f7 f5                	div    %ebp
  80331b:	89 d0                	mov    %edx,%eax
  80331d:	e9 44 ff ff ff       	jmp    803266 <__umoddi3+0x3e>
  803322:	66 90                	xchg   %ax,%ax
  803324:	89 c8                	mov    %ecx,%eax
  803326:	89 f2                	mov    %esi,%edx
  803328:	83 c4 1c             	add    $0x1c,%esp
  80332b:	5b                   	pop    %ebx
  80332c:	5e                   	pop    %esi
  80332d:	5f                   	pop    %edi
  80332e:	5d                   	pop    %ebp
  80332f:	c3                   	ret    
  803330:	3b 04 24             	cmp    (%esp),%eax
  803333:	72 06                	jb     80333b <__umoddi3+0x113>
  803335:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803339:	77 0f                	ja     80334a <__umoddi3+0x122>
  80333b:	89 f2                	mov    %esi,%edx
  80333d:	29 f9                	sub    %edi,%ecx
  80333f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803343:	89 14 24             	mov    %edx,(%esp)
  803346:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80334a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80334e:	8b 14 24             	mov    (%esp),%edx
  803351:	83 c4 1c             	add    $0x1c,%esp
  803354:	5b                   	pop    %ebx
  803355:	5e                   	pop    %esi
  803356:	5f                   	pop    %edi
  803357:	5d                   	pop    %ebp
  803358:	c3                   	ret    
  803359:	8d 76 00             	lea    0x0(%esi),%esi
  80335c:	2b 04 24             	sub    (%esp),%eax
  80335f:	19 fa                	sbb    %edi,%edx
  803361:	89 d1                	mov    %edx,%ecx
  803363:	89 c6                	mov    %eax,%esi
  803365:	e9 71 ff ff ff       	jmp    8032db <__umoddi3+0xb3>
  80336a:	66 90                	xchg   %ax,%ax
  80336c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803370:	72 ea                	jb     80335c <__umoddi3+0x134>
  803372:	89 d9                	mov    %ebx,%ecx
  803374:	e9 62 ff ff ff       	jmp    8032db <__umoddi3+0xb3>
