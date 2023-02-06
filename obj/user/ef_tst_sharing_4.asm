
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 60 36 80 00       	push   $0x803660
  800092:	6a 12                	push   $0x12
  800094:	68 7c 36 80 00       	push   $0x80367c
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 94 36 80 00       	push   $0x803694
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 c8 36 80 00       	push   $0x8036c8
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 24 37 80 00       	push   $0x803724
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 21 1f 00 00       	call   802002 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 58 37 80 00       	push   $0x803758
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 42 1c 00 00       	call   801d3b <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 87 37 80 00       	push   $0x803787
  80010b:	e8 68 19 00 00       	call   801a78 <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 8c 37 80 00       	push   $0x80378c
  800127:	6a 21                	push   $0x21
  800129:	68 7c 36 80 00       	push   $0x80367c
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 00 1c 00 00       	call   801d3b <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 f8 37 80 00       	push   $0x8037f8
  80014c:	6a 22                	push   $0x22
  80014e:	68 7c 36 80 00       	push   $0x80367c
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 78 1a 00 00       	call   801bdb <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 cd 1b 00 00       	call   801d3b <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 78 38 80 00       	push   $0x803878
  80017f:	6a 25                	push   $0x25
  800181:	68 7c 36 80 00       	push   $0x80367c
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 ab 1b 00 00       	call   801d3b <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 d0 38 80 00       	push   $0x8038d0
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 7c 36 80 00       	push   $0x80367c
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 00 39 80 00       	push   $0x803900
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 24 39 80 00       	push   $0x803924
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 69 1b 00 00       	call   801d3b <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 54 39 80 00       	push   $0x803954
  8001e4:	e8 8f 18 00 00       	call   801a78 <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 87 37 80 00       	push   $0x803787
  8001fe:	e8 75 18 00 00       	call   801a78 <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 78 38 80 00       	push   $0x803878
  800217:	6a 32                	push   $0x32
  800219:	68 7c 36 80 00       	push   $0x80367c
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 10 1b 00 00       	call   801d3b <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 58 39 80 00       	push   $0x803958
  80023c:	6a 34                	push   $0x34
  80023e:	68 7c 36 80 00       	push   $0x80367c
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 88 19 00 00       	call   801bdb <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 dd 1a 00 00       	call   801d3b <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 ad 39 80 00       	push   $0x8039ad
  80026f:	6a 37                	push   $0x37
  800271:	68 7c 36 80 00       	push   $0x80367c
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 55 19 00 00       	call   801bdb <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 ad 1a 00 00       	call   801d3b <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 ad 39 80 00       	push   $0x8039ad
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 7c 36 80 00       	push   $0x80367c
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 cc 39 80 00       	push   $0x8039cc
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 f0 39 80 00       	push   $0x8039f0
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 6b 1a 00 00       	call   801d3b <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 20 3a 80 00       	push   $0x803a20
  8002e2:	e8 91 17 00 00       	call   801a78 <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 22 3a 80 00       	push   $0x803a22
  8002fc:	e8 77 17 00 00       	call   801a78 <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 2c 1a 00 00       	call   801d3b <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 f8 37 80 00       	push   $0x8037f8
  800320:	6a 46                	push   $0x46
  800322:	68 7c 36 80 00       	push   $0x80367c
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 a4 18 00 00       	call   801bdb <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 f9 19 00 00       	call   801d3b <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 ad 39 80 00       	push   $0x8039ad
  800353:	6a 49                	push   $0x49
  800355:	68 7c 36 80 00       	push   $0x80367c
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 24 3a 80 00       	push   $0x803a24
  80036e:	e8 05 17 00 00       	call   801a78 <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 ba 19 00 00       	call   801d3b <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 f8 37 80 00       	push   $0x8037f8
  800392:	6a 4e                	push   $0x4e
  800394:	68 7c 36 80 00       	push   $0x80367c
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 32 18 00 00       	call   801bdb <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 87 19 00 00       	call   801d3b <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 ad 39 80 00       	push   $0x8039ad
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 7c 36 80 00       	push   $0x80367c
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 ff 17 00 00       	call   801bdb <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 57 19 00 00       	call   801d3b <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 ad 39 80 00       	push   $0x8039ad
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 7c 36 80 00       	push   $0x80367c
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 35 19 00 00       	call   801d3b <sys_calculate_free_frames>
  800406:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	01 d2                	add    %edx,%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	6a 01                	push   $0x1
  80041a:	50                   	push   %eax
  80041b:	68 20 3a 80 00       	push   $0x803a20
  800420:	e8 53 16 00 00       	call   801a78 <smalloc>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80042b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	6a 01                	push   $0x1
  800440:	50                   	push   %eax
  800441:	68 22 3a 80 00       	push   $0x803a22
  800446:	e8 2d 16 00 00       	call   801a78 <smalloc>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800454:	01 c0                	add    %eax,%eax
  800456:	89 c2                	mov    %eax,%edx
  800458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	6a 01                	push   $0x1
  800462:	50                   	push   %eax
  800463:	68 24 3a 80 00       	push   $0x803a24
  800468:	e8 0b 16 00 00       	call   801a78 <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 c0 18 00 00       	call   801d3b <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 f8 37 80 00       	push   $0x8037f8
  80048e:	6a 5d                	push   $0x5d
  800490:	68 7c 36 80 00       	push   $0x80367c
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 36 17 00 00       	call   801bdb <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 8b 18 00 00       	call   801d3b <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 ad 39 80 00       	push   $0x8039ad
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 7c 36 80 00       	push   $0x80367c
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 01 17 00 00       	call   801bdb <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 56 18 00 00       	call   801d3b <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 ad 39 80 00       	push   $0x8039ad
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 7c 36 80 00       	push   $0x80367c
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 cc 16 00 00       	call   801bdb <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 24 18 00 00       	call   801d3b <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 ad 39 80 00       	push   $0x8039ad
  800528:	6a 66                	push   $0x66
  80052a:	68 7c 36 80 00       	push   $0x80367c
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 28 3a 80 00       	push   $0x803a28
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 4c 3a 80 00       	push   $0x803a4c
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 db 1a 00 00       	call   802034 <sys_getparentenvid>
  800559:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  80055c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  800560:	7e 2b                	jle    80058d <_main+0x555>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800562:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	68 98 3a 80 00       	push   $0x803a98
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 9d 15 00 00       	call   801b16 <sget>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  80057f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 01             	lea    0x1(%eax),%edx
  800587:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
	}
	return;
  80058c:	90                   	nop
  80058d:	90                   	nop
}
  80058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800599:	e8 7d 1a 00 00       	call   80201b <sys_getenvindex>
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	c1 e0 03             	shl    $0x3,%eax
  8005a9:	01 d0                	add    %edx,%eax
  8005ab:	01 c0                	add    %eax,%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	c1 e0 04             	shl    $0x4,%eax
  8005bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ca:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005d0:	84 c0                	test   %al,%al
  8005d2:	74 0f                	je     8005e3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d9:	05 5c 05 00 00       	add    $0x55c,%eax
  8005de:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e7:	7e 0a                	jle    8005f3 <libmain+0x60>
		binaryname = argv[0];
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 37 fa ff ff       	call   800038 <_main>
  800601:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800604:	e8 1f 18 00 00       	call   801e28 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 c0 3a 80 00       	push   $0x803ac0
  800611:	e8 6d 03 00 00       	call   800983 <cprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800619:	a1 20 50 80 00       	mov    0x805020,%eax
  80061e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800624:	a1 20 50 80 00       	mov    0x805020,%eax
  800629:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	68 e8 3a 80 00       	push   $0x803ae8
  800639:	e8 45 03 00 00       	call   800983 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80064c:	a1 20 50 80 00       	mov    0x805020,%eax
  800651:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800657:	a1 20 50 80 00       	mov    0x805020,%eax
  80065c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800662:	51                   	push   %ecx
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	68 10 3b 80 00       	push   $0x803b10
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 68 3b 80 00       	push   $0x803b68
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 c0 3a 80 00       	push   $0x803ac0
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 9f 17 00 00       	call   801e42 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006a3:	e8 19 00 00 00       	call   8006c1 <exit>
}
  8006a8:	90                   	nop
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	6a 00                	push   $0x0
  8006b6:	e8 2c 19 00 00       	call   801fe7 <sys_destroy_env>
  8006bb:	83 c4 10             	add    $0x10,%esp
}
  8006be:	90                   	nop
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <exit>:

void
exit(void)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006c7:	e8 81 19 00 00       	call   80204d <sys_exit_env>
}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8006d8:	83 c0 04             	add    $0x4,%eax
  8006db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006de:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 16                	je     8006fd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006e7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	68 7c 3b 80 00       	push   $0x803b7c
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 81 3b 80 00       	push   $0x803b81
  80070e:	e8 70 02 00 00       	call   800983 <cprintf>
  800713:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800716:	8b 45 10             	mov    0x10(%ebp),%eax
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 f4             	pushl  -0xc(%ebp)
  80071f:	50                   	push   %eax
  800720:	e8 f3 01 00 00       	call   800918 <vcprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	6a 00                	push   $0x0
  80072d:	68 9d 3b 80 00       	push   $0x803b9d
  800732:	e8 e1 01 00 00       	call   800918 <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80073a:	e8 82 ff ff ff       	call   8006c1 <exit>

	// should not return here
	while (1) ;
  80073f:	eb fe                	jmp    80073f <_panic+0x70>

00800741 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800747:	a1 20 50 80 00       	mov    0x805020,%eax
  80074c:	8b 50 74             	mov    0x74(%eax),%edx
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	39 c2                	cmp    %eax,%edx
  800754:	74 14                	je     80076a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	68 a0 3b 80 00       	push   $0x803ba0
  80075e:	6a 26                	push   $0x26
  800760:	68 ec 3b 80 00       	push   $0x803bec
  800765:	e8 65 ff ff ff       	call   8006cf <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800771:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800778:	e9 c2 00 00 00       	jmp    80083f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	85 c0                	test   %eax,%eax
  800790:	75 08                	jne    80079a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800792:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800795:	e9 a2 00 00 00       	jmp    80083c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80079a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007a8:	eb 69                	jmp    800813 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8007af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b8:	89 d0                	mov    %edx,%eax
  8007ba:	01 c0                	add    %eax,%eax
  8007bc:	01 d0                	add    %edx,%eax
  8007be:	c1 e0 03             	shl    $0x3,%eax
  8007c1:	01 c8                	add    %ecx,%eax
  8007c3:	8a 40 04             	mov    0x4(%eax),%al
  8007c6:	84 c0                	test   %al,%al
  8007c8:	75 46                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8007cf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	01 c0                	add    %eax,%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	c1 e0 03             	shl    $0x3,%eax
  8007e1:	01 c8                	add    %ecx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007f0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	01 c8                	add    %ecx,%eax
  800801:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800803:	39 c2                	cmp    %eax,%edx
  800805:	75 09                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800807:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80080e:	eb 12                	jmp    800822 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800810:	ff 45 e8             	incl   -0x18(%ebp)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	77 88                	ja     8007aa <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800826:	75 14                	jne    80083c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 f8 3b 80 00       	push   $0x803bf8
  800830:	6a 3a                	push   $0x3a
  800832:	68 ec 3b 80 00       	push   $0x803bec
  800837:	e8 93 fe ff ff       	call   8006cf <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80083c:	ff 45 f0             	incl   -0x10(%ebp)
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800845:	0f 8c 32 ff ff ff    	jl     80077d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80084b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800859:	eb 26                	jmp    800881 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80085b:	a1 20 50 80 00       	mov    0x805020,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	3c 01                	cmp    $0x1,%al
  800879:	75 03                	jne    80087e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80087b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087e:	ff 45 e0             	incl   -0x20(%ebp)
  800881:	a1 20 50 80 00       	mov    0x805020,%eax
  800886:	8b 50 74             	mov    0x74(%eax),%edx
  800889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088c:	39 c2                	cmp    %eax,%edx
  80088e:	77 cb                	ja     80085b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800893:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800896:	74 14                	je     8008ac <CheckWSWithoutLastIndex+0x16b>
		panic(
  800898:	83 ec 04             	sub    $0x4,%esp
  80089b:	68 4c 3c 80 00       	push   $0x803c4c
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 ec 3b 80 00       	push   $0x803bec
  8008a7:	e8 23 fe ff ff       	call   8006cf <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008ac:	90                   	nop
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 0a                	mov    %ecx,(%edx)
  8008c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c5:	88 d1                	mov    %dl,%cl
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d8:	75 2c                	jne    800906 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008da:	a0 24 50 80 00       	mov    0x805024,%al
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e5:	8b 12                	mov    (%edx),%edx
  8008e7:	89 d1                	mov    %edx,%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	83 c2 08             	add    $0x8,%edx
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	50                   	push   %eax
  8008f3:	51                   	push   %ecx
  8008f4:	52                   	push   %edx
  8008f5:	e8 80 13 00 00       	call   801c7a <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8b 40 04             	mov    0x4(%eax),%eax
  80090c:	8d 50 01             	lea    0x1(%eax),%edx
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	89 50 04             	mov    %edx,0x4(%eax)
}
  800915:	90                   	nop
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800921:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800928:	00 00 00 
	b.cnt = 0;
  80092b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800932:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 af 08 80 00       	push   $0x8008af
  800947:	e8 11 02 00 00       	call   800b5d <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80094f:	a0 24 50 80 00       	mov    0x805024,%al
  800954:	0f b6 c0             	movzbl %al,%eax
  800957:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80095d:	83 ec 04             	sub    $0x4,%esp
  800960:	50                   	push   %eax
  800961:	52                   	push   %edx
  800962:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800968:	83 c0 08             	add    $0x8,%eax
  80096b:	50                   	push   %eax
  80096c:	e8 09 13 00 00       	call   801c7a <sys_cputs>
  800971:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800974:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80097b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <cprintf>:

int cprintf(const char *fmt, ...) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800989:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800990:	8d 45 0c             	lea    0xc(%ebp),%eax
  800993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 f4             	pushl  -0xc(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	e8 73 ff ff ff       	call   800918 <vcprintf>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009b6:	e8 6d 14 00 00       	call   801e28 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ca:	50                   	push   %eax
  8009cb:	e8 48 ff ff ff       	call   800918 <vcprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009d6:	e8 67 14 00 00       	call   801e42 <sys_enable_interrupt>
	return cnt;
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 14             	sub    $0x14,%esp
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009fe:	77 55                	ja     800a55 <printnum+0x75>
  800a00:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a03:	72 05                	jb     800a0a <printnum+0x2a>
  800a05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a08:	77 4b                	ja     800a55 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a0a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a0d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a10:	8b 45 18             	mov    0x18(%ebp),%eax
  800a13:	ba 00 00 00 00       	mov    $0x0,%edx
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a20:	e8 cf 29 00 00       	call   8033f4 <__udivdi3>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	83 ec 04             	sub    $0x4,%esp
  800a2b:	ff 75 20             	pushl  0x20(%ebp)
  800a2e:	53                   	push   %ebx
  800a2f:	ff 75 18             	pushl  0x18(%ebp)
  800a32:	52                   	push   %edx
  800a33:	50                   	push   %eax
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 a1 ff ff ff       	call   8009e0 <printnum>
  800a3f:	83 c4 20             	add    $0x20,%esp
  800a42:	eb 1a                	jmp    800a5e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 20             	pushl  0x20(%ebp)
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a55:	ff 4d 1c             	decl   0x1c(%ebp)
  800a58:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a5c:	7f e6                	jg     800a44 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a5e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	53                   	push   %ebx
  800a6d:	51                   	push   %ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	e8 8f 2a 00 00       	call   803504 <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 b4 3e 80 00       	add    $0x803eb4,%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f be c0             	movsbl %al,%eax
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	50                   	push   %eax
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
}
  800a91:	90                   	nop
  800a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a9a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a9e:	7e 1c                	jle    800abc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	8d 50 08             	lea    0x8(%eax),%edx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 10                	mov    %edx,(%eax)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 e8 08             	sub    $0x8,%eax
  800ab5:	8b 50 04             	mov    0x4(%eax),%edx
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	eb 40                	jmp    800afc <getuint+0x65>
	else if (lflag)
  800abc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac0:	74 1e                	je     800ae0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 00                	mov    (%eax),%eax
  800ac7:	8d 50 04             	lea    0x4(%eax),%edx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	89 10                	mov    %edx,(%eax)
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 00                	mov    (%eax),%eax
  800ad4:	83 e8 04             	sub    $0x4,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	eb 1c                	jmp    800afc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	8d 50 04             	lea    0x4(%eax),%edx
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 10                	mov    %edx,(%eax)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b01:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b05:	7e 1c                	jle    800b23 <getint+0x25>
		return va_arg(*ap, long long);
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	8d 50 08             	lea    0x8(%eax),%edx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 10                	mov    %edx,(%eax)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	83 e8 08             	sub    $0x8,%eax
  800b1c:	8b 50 04             	mov    0x4(%eax),%edx
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	eb 38                	jmp    800b5b <getint+0x5d>
	else if (lflag)
  800b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b27:	74 1a                	je     800b43 <getint+0x45>
		return va_arg(*ap, long);
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	8d 50 04             	lea    0x4(%eax),%edx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 10                	mov    %edx,(%eax)
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	99                   	cltd   
  800b41:	eb 18                	jmp    800b5b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 10                	mov    %edx,(%eax)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	83 e8 04             	sub    $0x4,%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	99                   	cltd   
}
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b65:	eb 17                	jmp    800b7e <vprintfmt+0x21>
			if (ch == '\0')
  800b67:	85 db                	test   %ebx,%ebx
  800b69:	0f 84 af 03 00 00    	je     800f1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 10             	mov    %edx,0x10(%ebp)
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	83 fb 25             	cmp    $0x25,%ebx
  800b8f:	75 d6                	jne    800b67 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b91:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b95:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ba3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800baa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bc2:	83 f8 55             	cmp    $0x55,%eax
  800bc5:	0f 87 2b 03 00 00    	ja     800ef6 <vprintfmt+0x399>
  800bcb:	8b 04 85 d8 3e 80 00 	mov    0x803ed8(,%eax,4),%eax
  800bd2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bd8:	eb d7                	jmp    800bb1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bda:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bde:	eb d1                	jmp    800bb1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bea:	89 d0                	mov    %edx,%eax
  800bec:	c1 e0 02             	shl    $0x2,%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	01 c0                	add    %eax,%eax
  800bf3:	01 d8                	add    %ebx,%eax
  800bf5:	83 e8 30             	sub    $0x30,%eax
  800bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 3e                	jle    800c46 <vprintfmt+0xe9>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 39                	jg     800c46 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c10:	eb d5                	jmp    800be7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	83 c0 04             	add    $0x4,%eax
  800c18:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	83 e8 04             	sub    $0x4,%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c26:	eb 1f                	jmp    800c47 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2c:	79 83                	jns    800bb1 <vprintfmt+0x54>
				width = 0;
  800c2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c35:	e9 77 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c3a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c41:	e9 6b ff ff ff       	jmp    800bb1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c46:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4b:	0f 89 60 ff ff ff    	jns    800bb1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c57:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c5e:	e9 4e ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c63:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c66:	e9 46 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	83 c0 04             	add    $0x4,%eax
  800c71:	89 45 14             	mov    %eax,0x14(%ebp)
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 e8 04             	sub    $0x4,%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			break;
  800c8b:	e9 89 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c90:	8b 45 14             	mov    0x14(%ebp),%eax
  800c93:	83 c0 04             	add    $0x4,%eax
  800c96:	89 45 14             	mov    %eax,0x14(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ca1:	85 db                	test   %ebx,%ebx
  800ca3:	79 02                	jns    800ca7 <vprintfmt+0x14a>
				err = -err;
  800ca5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ca7:	83 fb 64             	cmp    $0x64,%ebx
  800caa:	7f 0b                	jg     800cb7 <vprintfmt+0x15a>
  800cac:	8b 34 9d 20 3d 80 00 	mov    0x803d20(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 c5 3e 80 00       	push   $0x803ec5
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 5e 02 00 00       	call   800f26 <printfmt>
  800cc8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ccb:	e9 49 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cd0:	56                   	push   %esi
  800cd1:	68 ce 3e 80 00       	push   $0x803ece
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 45 02 00 00       	call   800f26 <printfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
			break;
  800ce4:	e9 30 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 e8 04             	sub    $0x4,%eax
  800cf8:	8b 30                	mov    (%eax),%esi
  800cfa:	85 f6                	test   %esi,%esi
  800cfc:	75 05                	jne    800d03 <vprintfmt+0x1a6>
				p = "(null)";
  800cfe:	be d1 3e 80 00       	mov    $0x803ed1,%esi
			if (width > 0 && padc != '-')
  800d03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d07:	7e 6d                	jle    800d76 <vprintfmt+0x219>
  800d09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d0d:	74 67                	je     800d76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	50                   	push   %eax
  800d16:	56                   	push   %esi
  800d17:	e8 0c 03 00 00       	call   801028 <strnlen>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d22:	eb 16                	jmp    800d3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	50                   	push   %eax
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	ff d0                	call   *%eax
  800d34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d37:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3e:	7f e4                	jg     800d24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d40:	eb 34                	jmp    800d76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d46:	74 1c                	je     800d64 <vprintfmt+0x207>
  800d48:	83 fb 1f             	cmp    $0x1f,%ebx
  800d4b:	7e 05                	jle    800d52 <vprintfmt+0x1f5>
  800d4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d50:	7e 12                	jle    800d64 <vprintfmt+0x207>
					putch('?', putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	6a 3f                	push   $0x3f
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	eb 0f                	jmp    800d73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	53                   	push   %ebx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d73:	ff 4d e4             	decl   -0x1c(%ebp)
  800d76:	89 f0                	mov    %esi,%eax
  800d78:	8d 70 01             	lea    0x1(%eax),%esi
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f be d8             	movsbl %al,%ebx
  800d80:	85 db                	test   %ebx,%ebx
  800d82:	74 24                	je     800da8 <vprintfmt+0x24b>
  800d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d88:	78 b8                	js     800d42 <vprintfmt+0x1e5>
  800d8a:	ff 4d e0             	decl   -0x20(%ebp)
  800d8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d91:	79 af                	jns    800d42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d93:	eb 13                	jmp    800da8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 20                	push   $0x20
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	ff 4d e4             	decl   -0x1c(%ebp)
  800da8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dac:	7f e7                	jg     800d95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dae:	e9 66 01 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 e8             	pushl  -0x18(%ebp)
  800db9:	8d 45 14             	lea    0x14(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	e8 3c fd ff ff       	call   800afe <getint>
  800dc2:	83 c4 10             	add    $0x10,%esp
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd1:	85 d2                	test   %edx,%edx
  800dd3:	79 23                	jns    800df8 <vprintfmt+0x29b>
				putch('-', putdat);
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 0c             	pushl  0xc(%ebp)
  800ddb:	6a 2d                	push   $0x2d
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	ff d0                	call   *%eax
  800de2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800deb:	f7 d8                	neg    %eax
  800ded:	83 d2 00             	adc    $0x0,%edx
  800df0:	f7 da                	neg    %edx
  800df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800df8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dff:	e9 bc 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	ff 75 e8             	pushl  -0x18(%ebp)
  800e0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 84 fc ff ff       	call   800a97 <getuint>
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e23:	e9 98 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	6a 58                	push   $0x58
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 58                	push   $0x58
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e48:	83 ec 08             	sub    $0x8,%esp
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	6a 58                	push   $0x58
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
			break;
  800e58:	e9 bc 00 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	6a 30                	push   $0x30
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	ff d0                	call   *%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	6a 78                	push   $0x78
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	ff d0                	call   *%eax
  800e7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e80:	83 c0 04             	add    $0x4,%eax
  800e83:	89 45 14             	mov    %eax,0x14(%ebp)
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	83 e8 04             	sub    $0x4,%eax
  800e8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e9f:	eb 1f                	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	e8 e7 fb ff ff       	call   800a97 <getuint>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	52                   	push   %edx
  800ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	ff 75 08             	pushl  0x8(%ebp)
  800edb:	e8 00 fb ff ff       	call   8009e0 <printnum>
  800ee0:	83 c4 20             	add    $0x20,%esp
			break;
  800ee3:	eb 34                	jmp    800f19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	53                   	push   %ebx
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			break;
  800ef4:	eb 23                	jmp    800f19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	6a 25                	push   $0x25
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f06:	ff 4d 10             	decl   0x10(%ebp)
  800f09:	eb 03                	jmp    800f0e <vprintfmt+0x3b1>
  800f0b:	ff 4d 10             	decl   0x10(%ebp)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	48                   	dec    %eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 25                	cmp    $0x25,%al
  800f16:	75 f3                	jne    800f0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f18:	90                   	nop
		}
	}
  800f19:	e9 47 fc ff ff       	jmp    800b65 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f2f:	83 c0 04             	add    $0x4,%eax
  800f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3b:	50                   	push   %eax
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	ff 75 08             	pushl  0x8(%ebp)
  800f42:	e8 16 fc ff ff       	call   800b5d <vprintfmt>
  800f47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f4a:	90                   	nop
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 40 08             	mov    0x8(%eax),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 10                	mov    (%eax),%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8b 40 04             	mov    0x4(%eax),%eax
  800f6a:	39 c2                	cmp    %eax,%edx
  800f6c:	73 12                	jae    800f80 <sprintputch+0x33>
		*b->buf++ = ch;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8b 00                	mov    (%eax),%eax
  800f73:	8d 48 01             	lea    0x1(%eax),%ecx
  800f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f79:	89 0a                	mov    %ecx,(%edx)
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	88 10                	mov    %dl,(%eax)
}
  800f80:	90                   	nop
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	01 d0                	add    %edx,%eax
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa8:	74 06                	je     800fb0 <vsnprintf+0x2d>
  800faa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fae:	7f 07                	jg     800fb7 <vsnprintf+0x34>
		return -E_INVAL;
  800fb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb5:	eb 20                	jmp    800fd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fb7:	ff 75 14             	pushl  0x14(%ebp)
  800fba:	ff 75 10             	pushl  0x10(%ebp)
  800fbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fc0:	50                   	push   %eax
  800fc1:	68 4d 0f 80 00       	push   $0x800f4d
  800fc6:	e8 92 fb ff ff       	call   800b5d <vprintfmt>
  800fcb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe2:	83 c0 04             	add    $0x4,%eax
  800fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fee:	50                   	push   %eax
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	e8 89 ff ff ff       	call   800f83 <vsnprintf>
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801000:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80100b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801012:	eb 06                	jmp    80101a <strlen+0x15>
		n++;
  801014:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	ff 45 08             	incl   0x8(%ebp)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 f1                	jne    801014 <strlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801035:	eb 09                	jmp    801040 <strnlen+0x18>
		n++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	ff 4d 0c             	decl   0xc(%ebp)
  801040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801044:	74 09                	je     80104f <strnlen+0x27>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	75 e8                	jne    801037 <strnlen+0xf>
		n++;
	return n;
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801060:	90                   	nop
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8d 50 01             	lea    0x1(%eax),%edx
  801067:	89 55 08             	mov    %edx,0x8(%ebp)
  80106a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801070:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801073:	8a 12                	mov    (%edx),%dl
  801075:	88 10                	mov    %dl,(%eax)
  801077:	8a 00                	mov    (%eax),%al
  801079:	84 c0                	test   %al,%al
  80107b:	75 e4                	jne    801061 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80108e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801095:	eb 1f                	jmp    8010b6 <strncpy+0x34>
		*dst++ = *src;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	74 03                	je     8010b3 <strncpy+0x31>
			src++;
  8010b0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010b3:	ff 45 fc             	incl   -0x4(%ebp)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bc:	72 d9                	jb     801097 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d3:	74 30                	je     801105 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010d5:	eb 16                	jmp    8010ed <strlcpy+0x2a>
			*dst++ = *src++;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010e9:	8a 12                	mov    (%edx),%dl
  8010eb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ed:	ff 4d 10             	decl   0x10(%ebp)
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	74 09                	je     8010ff <strlcpy+0x3c>
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	75 d8                	jne    8010d7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	29 c2                	sub    %eax,%edx
  80110d:	89 d0                	mov    %edx,%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801114:	eb 06                	jmp    80111c <strcmp+0xb>
		p++, q++;
  801116:	ff 45 08             	incl   0x8(%ebp)
  801119:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	84 c0                	test   %al,%al
  801123:	74 0e                	je     801133 <strcmp+0x22>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 10                	mov    (%eax),%dl
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	38 c2                	cmp    %al,%dl
  801131:	74 e3                	je     801116 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d0             	movzbl %al,%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
}
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80114c:	eb 09                	jmp    801157 <strncmp+0xe>
		n--, p++, q++;
  80114e:	ff 4d 10             	decl   0x10(%ebp)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 17                	je     801174 <strncmp+0x2b>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 0e                	je     801174 <strncmp+0x2b>
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 10                	mov    (%eax),%dl
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	38 c2                	cmp    %al,%dl
  801172:	74 da                	je     80114e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 07                	jne    801181 <strncmp+0x38>
		return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	eb 14                	jmp    801195 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 d0             	movzbl %al,%edx
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f b6 c0             	movzbl %al,%eax
  801191:	29 c2                	sub    %eax,%edx
  801193:	89 d0                	mov    %edx,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a3:	eb 12                	jmp    8011b7 <strchr+0x20>
		if (*s == c)
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ad:	75 05                	jne    8011b4 <strchr+0x1d>
			return (char *) s;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	eb 11                	jmp    8011c5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	75 e5                	jne    8011a5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d3:	eb 0d                	jmp    8011e2 <strfind+0x1b>
		if (*s == c)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011dd:	74 0e                	je     8011ed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 ea                	jne    8011d5 <strfind+0xe>
  8011eb:	eb 01                	jmp    8011ee <strfind+0x27>
		if (*s == c)
			break;
  8011ed:	90                   	nop
	return (char *) s;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801205:	eb 0e                	jmp    801215 <memset+0x22>
		*p++ = c;
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120a:	8d 50 01             	lea    0x1(%eax),%edx
  80120d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801210:	8b 55 0c             	mov    0xc(%ebp),%edx
  801213:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801215:	ff 4d f8             	decl   -0x8(%ebp)
  801218:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80121c:	79 e9                	jns    801207 <memset+0x14>
		*p++ = c;

	return v;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801235:	eb 16                	jmp    80124d <memcpy+0x2a>
		*d++ = *s++;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801240:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801243:	8d 4a 01             	lea    0x1(%edx),%ecx
  801246:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801249:	8a 12                	mov    (%edx),%dl
  80124b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80124d:	8b 45 10             	mov    0x10(%ebp),%eax
  801250:	8d 50 ff             	lea    -0x1(%eax),%edx
  801253:	89 55 10             	mov    %edx,0x10(%ebp)
  801256:	85 c0                	test   %eax,%eax
  801258:	75 dd                	jne    801237 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801277:	73 50                	jae    8012c9 <memmove+0x6a>
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801284:	76 43                	jbe    8012c9 <memmove+0x6a>
		s += n;
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801292:	eb 10                	jmp    8012a4 <memmove+0x45>
			*--d = *--s;
  801294:	ff 4d f8             	decl   -0x8(%ebp)
  801297:	ff 4d fc             	decl   -0x4(%ebp)
  80129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	75 e3                	jne    801294 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012b1:	eb 23                	jmp    8012d6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012c5:	8a 12                	mov    (%edx),%dl
  8012c7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	75 dd                	jne    8012b3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ed:	eb 2a                	jmp    801319 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f2:	8a 10                	mov    (%eax),%dl
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	38 c2                	cmp    %al,%dl
  8012fb:	74 16                	je     801313 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	0f b6 d0             	movzbl %al,%edx
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f b6 c0             	movzbl %al,%eax
  80130d:	29 c2                	sub    %eax,%edx
  80130f:	89 d0                	mov    %edx,%eax
  801311:	eb 18                	jmp    80132b <memcmp+0x50>
		s1++, s2++;
  801313:	ff 45 fc             	incl   -0x4(%ebp)
  801316:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 c9                	jne    8012ef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 d0                	add    %edx,%eax
  80133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80133e:	eb 15                	jmp    801355 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	0f b6 d0             	movzbl %al,%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	0f b6 c0             	movzbl %al,%eax
  80134e:	39 c2                	cmp    %eax,%edx
  801350:	74 0d                	je     80135f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801352:	ff 45 08             	incl   0x8(%ebp)
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80135b:	72 e3                	jb     801340 <memfind+0x13>
  80135d:	eb 01                	jmp    801360 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80135f:	90                   	nop
	return (void *) s;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801372:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801379:	eb 03                	jmp    80137e <strtol+0x19>
		s++;
  80137b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	3c 20                	cmp    $0x20,%al
  801385:	74 f4                	je     80137b <strtol+0x16>
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 09                	cmp    $0x9,%al
  80138e:	74 eb                	je     80137b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 2b                	cmp    $0x2b,%al
  801397:	75 05                	jne    80139e <strtol+0x39>
		s++;
  801399:	ff 45 08             	incl   0x8(%ebp)
  80139c:	eb 13                	jmp    8013b1 <strtol+0x4c>
	else if (*s == '-')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 2d                	cmp    $0x2d,%al
  8013a5:	75 0a                	jne    8013b1 <strtol+0x4c>
		s++, neg = 1;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	74 06                	je     8013bd <strtol+0x58>
  8013b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013bb:	75 20                	jne    8013dd <strtol+0x78>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 30                	cmp    $0x30,%al
  8013c4:	75 17                	jne    8013dd <strtol+0x78>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	40                   	inc    %eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 78                	cmp    $0x78,%al
  8013ce:	75 0d                	jne    8013dd <strtol+0x78>
		s += 2, base = 16;
  8013d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013db:	eb 28                	jmp    801405 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	75 15                	jne    8013f8 <strtol+0x93>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 30                	cmp    $0x30,%al
  8013ea:	75 0c                	jne    8013f8 <strtol+0x93>
		s++, base = 8;
  8013ec:	ff 45 08             	incl   0x8(%ebp)
  8013ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013f6:	eb 0d                	jmp    801405 <strtol+0xa0>
	else if (base == 0)
  8013f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fc:	75 07                	jne    801405 <strtol+0xa0>
		base = 10;
  8013fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 2f                	cmp    $0x2f,%al
  80140c:	7e 19                	jle    801427 <strtol+0xc2>
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 39                	cmp    $0x39,%al
  801415:	7f 10                	jg     801427 <strtol+0xc2>
			dig = *s - '0';
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	0f be c0             	movsbl %al,%eax
  80141f:	83 e8 30             	sub    $0x30,%eax
  801422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801425:	eb 42                	jmp    801469 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 60                	cmp    $0x60,%al
  80142e:	7e 19                	jle    801449 <strtol+0xe4>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	3c 7a                	cmp    $0x7a,%al
  801437:	7f 10                	jg     801449 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	0f be c0             	movsbl %al,%eax
  801441:	83 e8 57             	sub    $0x57,%eax
  801444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801447:	eb 20                	jmp    801469 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 40                	cmp    $0x40,%al
  801450:	7e 39                	jle    80148b <strtol+0x126>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3c 5a                	cmp    $0x5a,%al
  801459:	7f 30                	jg     80148b <strtol+0x126>
			dig = *s - 'A' + 10;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 37             	sub    $0x37,%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80146f:	7d 19                	jge    80148a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801471:	ff 45 08             	incl   0x8(%ebp)
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	0f af 45 10          	imul   0x10(%ebp),%eax
  80147b:	89 c2                	mov    %eax,%edx
  80147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801485:	e9 7b ff ff ff       	jmp    801405 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80148a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80148b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148f:	74 08                	je     801499 <strtol+0x134>
		*endptr = (char *) s;
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	8b 55 08             	mov    0x8(%ebp),%edx
  801497:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801499:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80149d:	74 07                	je     8014a6 <strtol+0x141>
  80149f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a2:	f7 d8                	neg    %eax
  8014a4:	eb 03                	jmp    8014a9 <strtol+0x144>
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <ltostr>:

void
ltostr(long value, char *str)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c3:	79 13                	jns    8014d8 <ltostr+0x2d>
	{
		neg = 1;
  8014c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014e0:	99                   	cltd   
  8014e1:	f7 f9                	idiv   %ecx
  8014e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ef:	89 c2                	mov    %eax,%edx
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f9:	83 c2 30             	add    $0x30,%edx
  8014fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801501:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801506:	f7 e9                	imul   %ecx
  801508:	c1 fa 02             	sar    $0x2,%edx
  80150b:	89 c8                	mov    %ecx,%eax
  80150d:	c1 f8 1f             	sar    $0x1f,%eax
  801510:	29 c2                	sub    %eax,%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801517:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80151f:	f7 e9                	imul   %ecx
  801521:	c1 fa 02             	sar    $0x2,%edx
  801524:	89 c8                	mov    %ecx,%eax
  801526:	c1 f8 1f             	sar    $0x1f,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	c1 e0 02             	shl    $0x2,%eax
  801530:	01 d0                	add    %edx,%eax
  801532:	01 c0                	add    %eax,%eax
  801534:	29 c1                	sub    %eax,%ecx
  801536:	89 ca                	mov    %ecx,%edx
  801538:	85 d2                	test   %edx,%edx
  80153a:	75 9c                	jne    8014d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80153c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801543:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801546:	48                   	dec    %eax
  801547:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80154a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80154e:	74 3d                	je     80158d <ltostr+0xe2>
		start = 1 ;
  801550:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801557:	eb 34                	jmp    80158d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	01 c2                	add    %eax,%edx
  80156e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	01 c8                	add    %ecx,%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80157a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	01 c2                	add    %eax,%edx
  801582:	8a 45 eb             	mov    -0x15(%ebp),%al
  801585:	88 02                	mov    %al,(%edx)
		start++ ;
  801587:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80158a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801593:	7c c4                	jl     801559 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801595:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	01 d0                	add    %edx,%eax
  80159d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015a0:	90                   	nop
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 54 fa ff ff       	call   801005 <strlen>
  8015b1:	83 c4 04             	add    $0x4,%esp
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	e8 46 fa ff ff       	call   801005 <strlen>
  8015bf:	83 c4 04             	add    $0x4,%esp
  8015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d3:	eb 17                	jmp    8015ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8015d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c8                	add    %ecx,%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015e9:	ff 45 fc             	incl   -0x4(%ebp)
  8015ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015f2:	7c e1                	jl     8015d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801602:	eb 1f                	jmp    801623 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801604:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801607:	8d 50 01             	lea    0x1(%eax),%edx
  80160a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	01 c2                	add    %eax,%edx
  801614:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 c8                	add    %ecx,%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801620:	ff 45 f8             	incl   -0x8(%ebp)
  801623:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801626:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801629:	7c d9                	jl     801604 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	c6 00 00             	movb   $0x0,(%eax)
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80163c:	8b 45 14             	mov    0x14(%ebp),%eax
  80163f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801645:	8b 45 14             	mov    0x14(%ebp),%eax
  801648:	8b 00                	mov    (%eax),%eax
  80164a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165c:	eb 0c                	jmp    80166a <strsplit+0x31>
			*string++ = 0;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8d 50 01             	lea    0x1(%eax),%edx
  801664:	89 55 08             	mov    %edx,0x8(%ebp)
  801667:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	84 c0                	test   %al,%al
  801671:	74 18                	je     80168b <strsplit+0x52>
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	0f be c0             	movsbl %al,%eax
  80167b:	50                   	push   %eax
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	e8 13 fb ff ff       	call   801197 <strchr>
  801684:	83 c4 08             	add    $0x8,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	75 d3                	jne    80165e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	84 c0                	test   %al,%al
  801692:	74 5a                	je     8016ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	83 f8 0f             	cmp    $0xf,%eax
  80169c:	75 07                	jne    8016a5 <strsplit+0x6c>
		{
			return 0;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 66                	jmp    80170b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8016b0:	89 0a                	mov    %ecx,(%edx)
  8016b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	01 c2                	add    %eax,%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c3:	eb 03                	jmp    8016c8 <strsplit+0x8f>
			string++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	84 c0                	test   %al,%al
  8016cf:	74 8b                	je     80165c <strsplit+0x23>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f be c0             	movsbl %al,%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	e8 b5 fa ff ff       	call   801197 <strchr>
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 dc                	je     8016c5 <strsplit+0x8c>
			string++;
	}
  8016e9:	e9 6e ff ff ff       	jmp    80165c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	01 d0                	add    %edx,%eax
  801700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801706:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801713:	a1 04 50 80 00       	mov    0x805004,%eax
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 1f                	je     80173b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80171c:	e8 1d 00 00 00       	call   80173e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	68 30 40 80 00       	push   $0x804030
  801729:	e8 55 f2 ff ff       	call   800983 <cprintf>
  80172e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801731:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801738:	00 00 00 
	}
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801744:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80174b:	00 00 00 
  80174e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801755:	00 00 00 
  801758:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80175f:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801762:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801769:	00 00 00 
  80176c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801773:	00 00 00 
  801776:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80177d:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801780:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80178f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801794:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801799:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8017a0:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8017a3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ad:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  8017b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bd:	f7 75 f0             	divl   -0x10(%ebp)
  8017c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c3:	29 d0                	sub    %edx,%eax
  8017c5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8017c8:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8017cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	6a 06                	push   $0x6
  8017e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8017e4:	50                   	push   %eax
  8017e5:	e8 d4 05 00 00       	call   801dbe <sys_allocate_chunk>
  8017ea:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017ed:	a1 20 51 80 00       	mov    0x805120,%eax
  8017f2:	83 ec 0c             	sub    $0xc,%esp
  8017f5:	50                   	push   %eax
  8017f6:	e8 49 0c 00 00       	call   802444 <initialize_MemBlocksList>
  8017fb:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8017fe:	a1 48 51 80 00       	mov    0x805148,%eax
  801803:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801806:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80180a:	75 14                	jne    801820 <initialize_dyn_block_system+0xe2>
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	68 55 40 80 00       	push   $0x804055
  801814:	6a 39                	push   $0x39
  801816:	68 73 40 80 00       	push   $0x804073
  80181b:	e8 af ee ff ff       	call   8006cf <_panic>
  801820:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801823:	8b 00                	mov    (%eax),%eax
  801825:	85 c0                	test   %eax,%eax
  801827:	74 10                	je     801839 <initialize_dyn_block_system+0xfb>
  801829:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801831:	8b 52 04             	mov    0x4(%edx),%edx
  801834:	89 50 04             	mov    %edx,0x4(%eax)
  801837:	eb 0b                	jmp    801844 <initialize_dyn_block_system+0x106>
  801839:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80183c:	8b 40 04             	mov    0x4(%eax),%eax
  80183f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801844:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801847:	8b 40 04             	mov    0x4(%eax),%eax
  80184a:	85 c0                	test   %eax,%eax
  80184c:	74 0f                	je     80185d <initialize_dyn_block_system+0x11f>
  80184e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801851:	8b 40 04             	mov    0x4(%eax),%eax
  801854:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801857:	8b 12                	mov    (%edx),%edx
  801859:	89 10                	mov    %edx,(%eax)
  80185b:	eb 0a                	jmp    801867 <initialize_dyn_block_system+0x129>
  80185d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801860:	8b 00                	mov    (%eax),%eax
  801862:	a3 48 51 80 00       	mov    %eax,0x805148
  801867:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80186a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801870:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801873:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80187a:	a1 54 51 80 00       	mov    0x805154,%eax
  80187f:	48                   	dec    %eax
  801880:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801885:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801888:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80188f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801892:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801899:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80189d:	75 14                	jne    8018b3 <initialize_dyn_block_system+0x175>
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	68 80 40 80 00       	push   $0x804080
  8018a7:	6a 3f                	push   $0x3f
  8018a9:	68 73 40 80 00       	push   $0x804073
  8018ae:	e8 1c ee ff ff       	call   8006cf <_panic>
  8018b3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8018b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018bc:	89 10                	mov    %edx,(%eax)
  8018be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c1:	8b 00                	mov    (%eax),%eax
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	74 0d                	je     8018d4 <initialize_dyn_block_system+0x196>
  8018c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8018cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018cf:	89 50 04             	mov    %edx,0x4(%eax)
  8018d2:	eb 08                	jmp    8018dc <initialize_dyn_block_system+0x19e>
  8018d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8018dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018df:	a3 38 51 80 00       	mov    %eax,0x805138
  8018e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8018f3:	40                   	inc    %eax
  8018f4:	a3 44 51 80 00       	mov    %eax,0x805144

}
  8018f9:	90                   	nop
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801902:	e8 06 fe ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801907:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80190b:	75 07                	jne    801914 <malloc+0x18>
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
  801912:	eb 7d                	jmp    801991 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801914:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80191b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801922:	8b 55 08             	mov    0x8(%ebp),%edx
  801925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801928:	01 d0                	add    %edx,%eax
  80192a:	48                   	dec    %eax
  80192b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80192e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801931:	ba 00 00 00 00       	mov    $0x0,%edx
  801936:	f7 75 f0             	divl   -0x10(%ebp)
  801939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193c:	29 d0                	sub    %edx,%eax
  80193e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801941:	e8 46 08 00 00       	call   80218c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801946:	83 f8 01             	cmp    $0x1,%eax
  801949:	75 07                	jne    801952 <malloc+0x56>
  80194b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801952:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801956:	75 34                	jne    80198c <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801958:	83 ec 0c             	sub    $0xc,%esp
  80195b:	ff 75 e8             	pushl  -0x18(%ebp)
  80195e:	e8 73 0e 00 00       	call   8027d6 <alloc_block_FF>
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80196d:	74 16                	je     801985 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80196f:	83 ec 0c             	sub    $0xc,%esp
  801972:	ff 75 e4             	pushl  -0x1c(%ebp)
  801975:	e8 ff 0b 00 00       	call   802579 <insert_sorted_allocList>
  80197a:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80197d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801980:	8b 40 08             	mov    0x8(%eax),%eax
  801983:	eb 0c                	jmp    801991 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
  80198a:	eb 05                	jmp    801991 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80198c:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80199f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8019b0:	83 ec 08             	sub    $0x8,%esp
  8019b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b6:	68 40 50 80 00       	push   $0x805040
  8019bb:	e8 61 0b 00 00       	call   802521 <find_block>
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8019c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019ca:	0f 84 a5 00 00 00    	je     801a75 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8019d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	50                   	push   %eax
  8019da:	ff 75 f4             	pushl  -0xc(%ebp)
  8019dd:	e8 a4 03 00 00       	call   801d86 <sys_free_user_mem>
  8019e2:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8019e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019e9:	75 17                	jne    801a02 <free+0x6f>
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	68 55 40 80 00       	push   $0x804055
  8019f3:	68 87 00 00 00       	push   $0x87
  8019f8:	68 73 40 80 00       	push   $0x804073
  8019fd:	e8 cd ec ff ff       	call   8006cf <_panic>
  801a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a05:	8b 00                	mov    (%eax),%eax
  801a07:	85 c0                	test   %eax,%eax
  801a09:	74 10                	je     801a1b <free+0x88>
  801a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a0e:	8b 00                	mov    (%eax),%eax
  801a10:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a13:	8b 52 04             	mov    0x4(%edx),%edx
  801a16:	89 50 04             	mov    %edx,0x4(%eax)
  801a19:	eb 0b                	jmp    801a26 <free+0x93>
  801a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1e:	8b 40 04             	mov    0x4(%eax),%eax
  801a21:	a3 44 50 80 00       	mov    %eax,0x805044
  801a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a29:	8b 40 04             	mov    0x4(%eax),%eax
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	74 0f                	je     801a3f <free+0xac>
  801a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a33:	8b 40 04             	mov    0x4(%eax),%eax
  801a36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a39:	8b 12                	mov    (%edx),%edx
  801a3b:	89 10                	mov    %edx,(%eax)
  801a3d:	eb 0a                	jmp    801a49 <free+0xb6>
  801a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a42:	8b 00                	mov    (%eax),%eax
  801a44:	a3 40 50 80 00       	mov    %eax,0x805040
  801a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a5c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a61:	48                   	dec    %eax
  801a62:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801a67:	83 ec 0c             	sub    $0xc,%esp
  801a6a:	ff 75 ec             	pushl  -0x14(%ebp)
  801a6d:	e8 37 12 00 00       	call   802ca9 <insert_sorted_with_merge_freeList>
  801a72:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801a75:	90                   	nop
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	83 ec 38             	sub    $0x38,%esp
  801a7e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a81:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a84:	e8 84 fc ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801a89:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a8d:	75 07                	jne    801a96 <smalloc+0x1e>
  801a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a94:	eb 7e                	jmp    801b14 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801a96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801a9d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aaa:	01 d0                	add    %edx,%eax
  801aac:	48                   	dec    %eax
  801aad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ab3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab8:	f7 75 f0             	divl   -0x10(%ebp)
  801abb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801abe:	29 d0                	sub    %edx,%eax
  801ac0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801ac3:	e8 c4 06 00 00       	call   80218c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ac8:	83 f8 01             	cmp    $0x1,%eax
  801acb:	75 42                	jne    801b0f <smalloc+0x97>

		  va = malloc(newsize) ;
  801acd:	83 ec 0c             	sub    $0xc,%esp
  801ad0:	ff 75 e8             	pushl  -0x18(%ebp)
  801ad3:	e8 24 fe ff ff       	call   8018fc <malloc>
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801ade:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ae2:	74 24                	je     801b08 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801ae4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801ae8:	ff 75 e4             	pushl  -0x1c(%ebp)
  801aeb:	50                   	push   %eax
  801aec:	ff 75 e8             	pushl  -0x18(%ebp)
  801aef:	ff 75 08             	pushl  0x8(%ebp)
  801af2:	e8 1a 04 00 00       	call   801f11 <sys_createSharedObject>
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801afd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b01:	78 0c                	js     801b0f <smalloc+0x97>
					  return va ;
  801b03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b06:	eb 0c                	jmp    801b14 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801b08:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0d:	eb 05                	jmp    801b14 <smalloc+0x9c>
	  }
		  return NULL ;
  801b0f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b1c:	e8 ec fb ff ff       	call   80170d <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801b21:	83 ec 08             	sub    $0x8,%esp
  801b24:	ff 75 0c             	pushl  0xc(%ebp)
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	e8 0c 04 00 00       	call   801f3b <sys_getSizeOfSharedObject>
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801b35:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b39:	75 07                	jne    801b42 <sget+0x2c>
  801b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b40:	eb 75                	jmp    801bb7 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b42:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4f:	01 d0                	add    %edx,%eax
  801b51:	48                   	dec    %eax
  801b52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b58:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5d:	f7 75 f0             	divl   -0x10(%ebp)
  801b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b63:	29 d0                	sub    %edx,%eax
  801b65:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801b68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801b6f:	e8 18 06 00 00       	call   80218c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b74:	83 f8 01             	cmp    $0x1,%eax
  801b77:	75 39                	jne    801bb2 <sget+0x9c>

		  va = malloc(newsize) ;
  801b79:	83 ec 0c             	sub    $0xc,%esp
  801b7c:	ff 75 e8             	pushl  -0x18(%ebp)
  801b7f:	e8 78 fd ff ff       	call   8018fc <malloc>
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801b8a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b8e:	74 22                	je     801bb2 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801b90:	83 ec 04             	sub    $0x4,%esp
  801b93:	ff 75 e0             	pushl  -0x20(%ebp)
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	e8 b7 03 00 00       	call   801f58 <sys_getSharedObject>
  801ba1:	83 c4 10             	add    $0x10,%esp
  801ba4:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801ba7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bab:	78 05                	js     801bb2 <sget+0x9c>
					  return va;
  801bad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb0:	eb 05                	jmp    801bb7 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801bb2:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bbf:	e8 49 fb ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	68 a4 40 80 00       	push   $0x8040a4
  801bcc:	68 1e 01 00 00       	push   $0x11e
  801bd1:	68 73 40 80 00       	push   $0x804073
  801bd6:	e8 f4 ea ff ff       	call   8006cf <_panic>

00801bdb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801be1:	83 ec 04             	sub    $0x4,%esp
  801be4:	68 cc 40 80 00       	push   $0x8040cc
  801be9:	68 32 01 00 00       	push   $0x132
  801bee:	68 73 40 80 00       	push   $0x804073
  801bf3:	e8 d7 ea ff ff       	call   8006cf <_panic>

00801bf8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bfe:	83 ec 04             	sub    $0x4,%esp
  801c01:	68 f0 40 80 00       	push   $0x8040f0
  801c06:	68 3d 01 00 00       	push   $0x13d
  801c0b:	68 73 40 80 00       	push   $0x804073
  801c10:	e8 ba ea ff ff       	call   8006cf <_panic>

00801c15 <shrink>:

}
void shrink(uint32 newSize)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c1b:	83 ec 04             	sub    $0x4,%esp
  801c1e:	68 f0 40 80 00       	push   $0x8040f0
  801c23:	68 42 01 00 00       	push   $0x142
  801c28:	68 73 40 80 00       	push   $0x804073
  801c2d:	e8 9d ea ff ff       	call   8006cf <_panic>

00801c32 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	68 f0 40 80 00       	push   $0x8040f0
  801c40:	68 47 01 00 00       	push   $0x147
  801c45:	68 73 40 80 00       	push   $0x804073
  801c4a:	e8 80 ea ff ff       	call   8006cf <_panic>

00801c4f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	57                   	push   %edi
  801c53:	56                   	push   %esi
  801c54:	53                   	push   %ebx
  801c55:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c64:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c67:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c6a:	cd 30                	int    $0x30
  801c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c72:	83 c4 10             	add    $0x10,%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5f                   	pop    %edi
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    

00801c7a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 04             	sub    $0x4,%esp
  801c80:	8b 45 10             	mov    0x10(%ebp),%eax
  801c83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c86:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	52                   	push   %edx
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	50                   	push   %eax
  801c96:	6a 00                	push   $0x0
  801c98:	e8 b2 ff ff ff       	call   801c4f <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	90                   	nop
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 01                	push   $0x1
  801cb2:	e8 98 ff ff ff       	call   801c4f <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	52                   	push   %edx
  801ccc:	50                   	push   %eax
  801ccd:	6a 05                	push   $0x5
  801ccf:	e8 7b ff ff ff       	call   801c4f <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	56                   	push   %esi
  801cdd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cde:	8b 75 18             	mov    0x18(%ebp),%esi
  801ce1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	56                   	push   %esi
  801cee:	53                   	push   %ebx
  801cef:	51                   	push   %ecx
  801cf0:	52                   	push   %edx
  801cf1:	50                   	push   %eax
  801cf2:	6a 06                	push   $0x6
  801cf4:	e8 56 ff ff ff       	call   801c4f <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
}
  801cfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cff:	5b                   	pop    %ebx
  801d00:	5e                   	pop    %esi
  801d01:	5d                   	pop    %ebp
  801d02:	c3                   	ret    

00801d03 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	52                   	push   %edx
  801d13:	50                   	push   %eax
  801d14:	6a 07                	push   $0x7
  801d16:	e8 34 ff ff ff       	call   801c4f <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	6a 08                	push   $0x8
  801d31:	e8 19 ff ff ff       	call   801c4f <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 09                	push   $0x9
  801d4a:	e8 00 ff ff ff       	call   801c4f <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 0a                	push   $0xa
  801d63:	e8 e7 fe ff ff       	call   801c4f <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 0b                	push   $0xb
  801d7c:	e8 ce fe ff ff       	call   801c4f <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	ff 75 0c             	pushl  0xc(%ebp)
  801d92:	ff 75 08             	pushl  0x8(%ebp)
  801d95:	6a 0f                	push   $0xf
  801d97:	e8 b3 fe ff ff       	call   801c4f <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
	return;
  801d9f:	90                   	nop
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	ff 75 0c             	pushl  0xc(%ebp)
  801dae:	ff 75 08             	pushl  0x8(%ebp)
  801db1:	6a 10                	push   $0x10
  801db3:	e8 97 fe ff ff       	call   801c4f <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbb:	90                   	nop
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	ff 75 10             	pushl  0x10(%ebp)
  801dc8:	ff 75 0c             	pushl  0xc(%ebp)
  801dcb:	ff 75 08             	pushl  0x8(%ebp)
  801dce:	6a 11                	push   $0x11
  801dd0:	e8 7a fe ff ff       	call   801c4f <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd8:	90                   	nop
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 0c                	push   $0xc
  801dea:	e8 60 fe ff ff       	call   801c4f <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	6a 0d                	push   $0xd
  801e04:	e8 46 fe ff ff       	call   801c4f <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 0e                	push   $0xe
  801e1d:	e8 2d fe ff ff       	call   801c4f <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	90                   	nop
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 13                	push   $0x13
  801e37:	e8 13 fe ff ff       	call   801c4f <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	90                   	nop
  801e40:	c9                   	leave  
  801e41:	c3                   	ret    

00801e42 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 14                	push   $0x14
  801e51:	e8 f9 fd ff ff       	call   801c4f <syscall>
  801e56:	83 c4 18             	add    $0x18,%esp
}
  801e59:	90                   	nop
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_cputc>:


void
sys_cputc(const char c)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 04             	sub    $0x4,%esp
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	50                   	push   %eax
  801e75:	6a 15                	push   $0x15
  801e77:	e8 d3 fd ff ff       	call   801c4f <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	90                   	nop
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 16                	push   $0x16
  801e91:	e8 b9 fd ff ff       	call   801c4f <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	90                   	nop
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	ff 75 0c             	pushl  0xc(%ebp)
  801eab:	50                   	push   %eax
  801eac:	6a 17                	push   $0x17
  801eae:	e8 9c fd ff ff       	call   801c4f <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	52                   	push   %edx
  801ec8:	50                   	push   %eax
  801ec9:	6a 1a                	push   $0x1a
  801ecb:	e8 7f fd ff ff       	call   801c4f <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
}
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ed8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	52                   	push   %edx
  801ee5:	50                   	push   %eax
  801ee6:	6a 18                	push   $0x18
  801ee8:	e8 62 fd ff ff       	call   801c4f <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	90                   	nop
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	52                   	push   %edx
  801f03:	50                   	push   %eax
  801f04:	6a 19                	push   $0x19
  801f06:	e8 44 fd ff ff       	call   801c4f <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	90                   	nop
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f1d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f20:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	6a 00                	push   $0x0
  801f29:	51                   	push   %ecx
  801f2a:	52                   	push   %edx
  801f2b:	ff 75 0c             	pushl  0xc(%ebp)
  801f2e:	50                   	push   %eax
  801f2f:	6a 1b                	push   $0x1b
  801f31:	e8 19 fd ff ff       	call   801c4f <syscall>
  801f36:	83 c4 18             	add    $0x18,%esp
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	6a 1c                	push   $0x1c
  801f4e:	e8 fc fc ff ff       	call   801c4f <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
}
  801f56:	c9                   	leave  
  801f57:	c3                   	ret    

00801f58 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f58:	55                   	push   %ebp
  801f59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	51                   	push   %ecx
  801f69:	52                   	push   %edx
  801f6a:	50                   	push   %eax
  801f6b:	6a 1d                	push   $0x1d
  801f6d:	e8 dd fc ff ff       	call   801c4f <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	52                   	push   %edx
  801f87:	50                   	push   %eax
  801f88:	6a 1e                	push   $0x1e
  801f8a:	e8 c0 fc ff ff       	call   801c4f <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 1f                	push   $0x1f
  801fa3:	e8 a7 fc ff ff       	call   801c4f <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	ff 75 14             	pushl  0x14(%ebp)
  801fb8:	ff 75 10             	pushl  0x10(%ebp)
  801fbb:	ff 75 0c             	pushl  0xc(%ebp)
  801fbe:	50                   	push   %eax
  801fbf:	6a 20                	push   $0x20
  801fc1:	e8 89 fc ff ff       	call   801c4f <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	50                   	push   %eax
  801fda:	6a 21                	push   $0x21
  801fdc:	e8 6e fc ff ff       	call   801c4f <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
}
  801fe4:	90                   	nop
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	50                   	push   %eax
  801ff6:	6a 22                	push   $0x22
  801ff8:	e8 52 fc ff ff       	call   801c4f <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 02                	push   $0x2
  802011:	e8 39 fc ff ff       	call   801c4f <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 03                	push   $0x3
  80202a:	e8 20 fc ff ff       	call   801c4f <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 04                	push   $0x4
  802043:	e8 07 fc ff ff       	call   801c4f <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_exit_env>:


void sys_exit_env(void)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 23                	push   $0x23
  80205c:	e8 ee fb ff ff       	call   801c4f <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
}
  802064:	90                   	nop
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80206d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802070:	8d 50 04             	lea    0x4(%eax),%edx
  802073:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	52                   	push   %edx
  80207d:	50                   	push   %eax
  80207e:	6a 24                	push   $0x24
  802080:	e8 ca fb ff ff       	call   801c4f <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
	return result;
  802088:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80208b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80208e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802091:	89 01                	mov    %eax,(%ecx)
  802093:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	c9                   	leave  
  80209a:	c2 04 00             	ret    $0x4

0080209d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	ff 75 10             	pushl  0x10(%ebp)
  8020a7:	ff 75 0c             	pushl  0xc(%ebp)
  8020aa:	ff 75 08             	pushl  0x8(%ebp)
  8020ad:	6a 12                	push   $0x12
  8020af:	e8 9b fb ff ff       	call   801c4f <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b7:	90                   	nop
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_rcr2>:
uint32 sys_rcr2()
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 25                	push   $0x25
  8020c9:	e8 81 fb ff ff       	call   801c4f <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020df:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	50                   	push   %eax
  8020ec:	6a 26                	push   $0x26
  8020ee:	e8 5c fb ff ff       	call   801c4f <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f6:	90                   	nop
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <rsttst>:
void rsttst()
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 28                	push   $0x28
  802108:	e8 42 fb ff ff       	call   801c4f <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
	return ;
  802110:	90                   	nop
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	8b 45 14             	mov    0x14(%ebp),%eax
  80211c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80211f:	8b 55 18             	mov    0x18(%ebp),%edx
  802122:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802126:	52                   	push   %edx
  802127:	50                   	push   %eax
  802128:	ff 75 10             	pushl  0x10(%ebp)
  80212b:	ff 75 0c             	pushl  0xc(%ebp)
  80212e:	ff 75 08             	pushl  0x8(%ebp)
  802131:	6a 27                	push   $0x27
  802133:	e8 17 fb ff ff       	call   801c4f <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
	return ;
  80213b:	90                   	nop
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <chktst>:
void chktst(uint32 n)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	ff 75 08             	pushl  0x8(%ebp)
  80214c:	6a 29                	push   $0x29
  80214e:	e8 fc fa ff ff       	call   801c4f <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
	return ;
  802156:	90                   	nop
}
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <inctst>:

void inctst()
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 2a                	push   $0x2a
  802168:	e8 e2 fa ff ff       	call   801c4f <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
	return ;
  802170:	90                   	nop
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <gettst>:
uint32 gettst()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 2b                	push   $0x2b
  802182:	e8 c8 fa ff ff       	call   801c4f <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 2c                	push   $0x2c
  80219e:	e8 ac fa ff ff       	call   801c4f <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
  8021a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021a9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021ad:	75 07                	jne    8021b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021af:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b4:	eb 05                	jmp    8021bb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 2c                	push   $0x2c
  8021cf:	e8 7b fa ff ff       	call   801c4f <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
  8021d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021da:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021de:	75 07                	jne    8021e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e5:	eb 05                	jmp    8021ec <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 2c                	push   $0x2c
  802200:	e8 4a fa ff ff       	call   801c4f <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
  802208:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80220b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80220f:	75 07                	jne    802218 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802211:	b8 01 00 00 00       	mov    $0x1,%eax
  802216:	eb 05                	jmp    80221d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802218:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 2c                	push   $0x2c
  802231:	e8 19 fa ff ff       	call   801c4f <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
  802239:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80223c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802240:	75 07                	jne    802249 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802242:	b8 01 00 00 00       	mov    $0x1,%eax
  802247:	eb 05                	jmp    80224e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	ff 75 08             	pushl  0x8(%ebp)
  80225e:	6a 2d                	push   $0x2d
  802260:	e8 ea f9 ff ff       	call   801c4f <syscall>
  802265:	83 c4 18             	add    $0x18,%esp
	return ;
  802268:	90                   	nop
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80226f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802272:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802275:	8b 55 0c             	mov    0xc(%ebp),%edx
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	6a 00                	push   $0x0
  80227d:	53                   	push   %ebx
  80227e:	51                   	push   %ecx
  80227f:	52                   	push   %edx
  802280:	50                   	push   %eax
  802281:	6a 2e                	push   $0x2e
  802283:	e8 c7 f9 ff ff       	call   801c4f <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802293:	8b 55 0c             	mov    0xc(%ebp),%edx
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	52                   	push   %edx
  8022a0:	50                   	push   %eax
  8022a1:	6a 2f                	push   $0x2f
  8022a3:	e8 a7 f9 ff ff       	call   801c4f <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022b3:	83 ec 0c             	sub    $0xc,%esp
  8022b6:	68 00 41 80 00       	push   $0x804100
  8022bb:	e8 c3 e6 ff ff       	call   800983 <cprintf>
  8022c0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022ca:	83 ec 0c             	sub    $0xc,%esp
  8022cd:	68 2c 41 80 00       	push   $0x80412c
  8022d2:	e8 ac e6 ff ff       	call   800983 <cprintf>
  8022d7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022da:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022de:	a1 38 51 80 00       	mov    0x805138,%eax
  8022e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e6:	eb 56                	jmp    80233e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022ec:	74 1c                	je     80230a <print_mem_block_lists+0x5d>
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 50 08             	mov    0x8(%eax),%edx
  8022f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f7:	8b 48 08             	mov    0x8(%eax),%ecx
  8022fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802300:	01 c8                	add    %ecx,%eax
  802302:	39 c2                	cmp    %eax,%edx
  802304:	73 04                	jae    80230a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802306:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 50 08             	mov    0x8(%eax),%edx
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 40 0c             	mov    0xc(%eax),%eax
  802316:	01 c2                	add    %eax,%edx
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 40 08             	mov    0x8(%eax),%eax
  80231e:	83 ec 04             	sub    $0x4,%esp
  802321:	52                   	push   %edx
  802322:	50                   	push   %eax
  802323:	68 41 41 80 00       	push   $0x804141
  802328:	e8 56 e6 ff ff       	call   800983 <cprintf>
  80232d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802336:	a1 40 51 80 00       	mov    0x805140,%eax
  80233b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802342:	74 07                	je     80234b <print_mem_block_lists+0x9e>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	eb 05                	jmp    802350 <print_mem_block_lists+0xa3>
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
  802350:	a3 40 51 80 00       	mov    %eax,0x805140
  802355:	a1 40 51 80 00       	mov    0x805140,%eax
  80235a:	85 c0                	test   %eax,%eax
  80235c:	75 8a                	jne    8022e8 <print_mem_block_lists+0x3b>
  80235e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802362:	75 84                	jne    8022e8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802364:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802368:	75 10                	jne    80237a <print_mem_block_lists+0xcd>
  80236a:	83 ec 0c             	sub    $0xc,%esp
  80236d:	68 50 41 80 00       	push   $0x804150
  802372:	e8 0c e6 ff ff       	call   800983 <cprintf>
  802377:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80237a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802381:	83 ec 0c             	sub    $0xc,%esp
  802384:	68 74 41 80 00       	push   $0x804174
  802389:	e8 f5 e5 ff ff       	call   800983 <cprintf>
  80238e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802391:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802395:	a1 40 50 80 00       	mov    0x805040,%eax
  80239a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239d:	eb 56                	jmp    8023f5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80239f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a3:	74 1c                	je     8023c1 <print_mem_block_lists+0x114>
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 50 08             	mov    0x8(%eax),%edx
  8023ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ae:	8b 48 08             	mov    0x8(%eax),%ecx
  8023b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b7:	01 c8                	add    %ecx,%eax
  8023b9:	39 c2                	cmp    %eax,%edx
  8023bb:	73 04                	jae    8023c1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023bd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 50 08             	mov    0x8(%eax),%edx
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cd:	01 c2                	add    %eax,%edx
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 40 08             	mov    0x8(%eax),%eax
  8023d5:	83 ec 04             	sub    $0x4,%esp
  8023d8:	52                   	push   %edx
  8023d9:	50                   	push   %eax
  8023da:	68 41 41 80 00       	push   $0x804141
  8023df:	e8 9f e5 ff ff       	call   800983 <cprintf>
  8023e4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023ed:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f9:	74 07                	je     802402 <print_mem_block_lists+0x155>
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	eb 05                	jmp    802407 <print_mem_block_lists+0x15a>
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	a3 48 50 80 00       	mov    %eax,0x805048
  80240c:	a1 48 50 80 00       	mov    0x805048,%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	75 8a                	jne    80239f <print_mem_block_lists+0xf2>
  802415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802419:	75 84                	jne    80239f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80241b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80241f:	75 10                	jne    802431 <print_mem_block_lists+0x184>
  802421:	83 ec 0c             	sub    $0xc,%esp
  802424:	68 8c 41 80 00       	push   $0x80418c
  802429:	e8 55 e5 ff ff       	call   800983 <cprintf>
  80242e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802431:	83 ec 0c             	sub    $0xc,%esp
  802434:	68 00 41 80 00       	push   $0x804100
  802439:	e8 45 e5 ff ff       	call   800983 <cprintf>
  80243e:	83 c4 10             	add    $0x10,%esp

}
  802441:	90                   	nop
  802442:	c9                   	leave  
  802443:	c3                   	ret    

00802444 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80244a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802451:	00 00 00 
  802454:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80245b:	00 00 00 
  80245e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802465:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802468:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80246f:	e9 9e 00 00 00       	jmp    802512 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802474:	a1 50 50 80 00       	mov    0x805050,%eax
  802479:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247c:	c1 e2 04             	shl    $0x4,%edx
  80247f:	01 d0                	add    %edx,%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	75 14                	jne    802499 <initialize_MemBlocksList+0x55>
  802485:	83 ec 04             	sub    $0x4,%esp
  802488:	68 b4 41 80 00       	push   $0x8041b4
  80248d:	6a 47                	push   $0x47
  80248f:	68 d7 41 80 00       	push   $0x8041d7
  802494:	e8 36 e2 ff ff       	call   8006cf <_panic>
  802499:	a1 50 50 80 00       	mov    0x805050,%eax
  80249e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a1:	c1 e2 04             	shl    $0x4,%edx
  8024a4:	01 d0                	add    %edx,%eax
  8024a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024ac:	89 10                	mov    %edx,(%eax)
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	74 18                	je     8024cc <initialize_MemBlocksList+0x88>
  8024b4:	a1 48 51 80 00       	mov    0x805148,%eax
  8024b9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024bf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024c2:	c1 e1 04             	shl    $0x4,%ecx
  8024c5:	01 ca                	add    %ecx,%edx
  8024c7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ca:	eb 12                	jmp    8024de <initialize_MemBlocksList+0x9a>
  8024cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8024d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d4:	c1 e2 04             	shl    $0x4,%edx
  8024d7:	01 d0                	add    %edx,%eax
  8024d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024de:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e6:	c1 e2 04             	shl    $0x4,%edx
  8024e9:	01 d0                	add    %edx,%eax
  8024eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8024f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f8:	c1 e2 04             	shl    $0x4,%edx
  8024fb:	01 d0                	add    %edx,%eax
  8024fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802504:	a1 54 51 80 00       	mov    0x805154,%eax
  802509:	40                   	inc    %eax
  80250a:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80250f:	ff 45 f4             	incl   -0xc(%ebp)
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	3b 45 08             	cmp    0x8(%ebp),%eax
  802518:	0f 82 56 ff ff ff    	jb     802474 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80251e:	90                   	nop
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
  802524:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80252f:	eb 19                	jmp    80254a <find_block+0x29>
	{
		if(element->sva == va){
  802531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802534:	8b 40 08             	mov    0x8(%eax),%eax
  802537:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80253a:	75 05                	jne    802541 <find_block+0x20>
			 		return element;
  80253c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80253f:	eb 36                	jmp    802577 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802541:	8b 45 08             	mov    0x8(%ebp),%eax
  802544:	8b 40 08             	mov    0x8(%eax),%eax
  802547:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80254a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80254e:	74 07                	je     802557 <find_block+0x36>
  802550:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	eb 05                	jmp    80255c <find_block+0x3b>
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
  80255c:	8b 55 08             	mov    0x8(%ebp),%edx
  80255f:	89 42 08             	mov    %eax,0x8(%edx)
  802562:	8b 45 08             	mov    0x8(%ebp),%eax
  802565:	8b 40 08             	mov    0x8(%eax),%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	75 c5                	jne    802531 <find_block+0x10>
  80256c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802570:	75 bf                	jne    802531 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802572:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
  80257c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80257f:	a1 44 50 80 00       	mov    0x805044,%eax
  802584:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802587:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80258c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80258f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802593:	74 0a                	je     80259f <insert_sorted_allocList+0x26>
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8b 40 08             	mov    0x8(%eax),%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	75 65                	jne    802604 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80259f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025a3:	75 14                	jne    8025b9 <insert_sorted_allocList+0x40>
  8025a5:	83 ec 04             	sub    $0x4,%esp
  8025a8:	68 b4 41 80 00       	push   $0x8041b4
  8025ad:	6a 6e                	push   $0x6e
  8025af:	68 d7 41 80 00       	push   $0x8041d7
  8025b4:	e8 16 e1 ff ff       	call   8006cf <_panic>
  8025b9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	89 10                	mov    %edx,(%eax)
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	74 0d                	je     8025da <insert_sorted_allocList+0x61>
  8025cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8025d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d5:	89 50 04             	mov    %edx,0x4(%eax)
  8025d8:	eb 08                	jmp    8025e2 <insert_sorted_allocList+0x69>
  8025da:	8b 45 08             	mov    0x8(%ebp),%eax
  8025dd:	a3 44 50 80 00       	mov    %eax,0x805044
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	a3 40 50 80 00       	mov    %eax,0x805040
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025f9:	40                   	inc    %eax
  8025fa:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8025ff:	e9 cf 01 00 00       	jmp    8027d3 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	8b 50 08             	mov    0x8(%eax),%edx
  80260a:	8b 45 08             	mov    0x8(%ebp),%eax
  80260d:	8b 40 08             	mov    0x8(%eax),%eax
  802610:	39 c2                	cmp    %eax,%edx
  802612:	73 65                	jae    802679 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802618:	75 14                	jne    80262e <insert_sorted_allocList+0xb5>
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	68 f0 41 80 00       	push   $0x8041f0
  802622:	6a 72                	push   $0x72
  802624:	68 d7 41 80 00       	push   $0x8041d7
  802629:	e8 a1 e0 ff ff       	call   8006cf <_panic>
  80262e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	89 50 04             	mov    %edx,0x4(%eax)
  80263a:	8b 45 08             	mov    0x8(%ebp),%eax
  80263d:	8b 40 04             	mov    0x4(%eax),%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	74 0c                	je     802650 <insert_sorted_allocList+0xd7>
  802644:	a1 44 50 80 00       	mov    0x805044,%eax
  802649:	8b 55 08             	mov    0x8(%ebp),%edx
  80264c:	89 10                	mov    %edx,(%eax)
  80264e:	eb 08                	jmp    802658 <insert_sorted_allocList+0xdf>
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	a3 40 50 80 00       	mov    %eax,0x805040
  802658:	8b 45 08             	mov    0x8(%ebp),%eax
  80265b:	a3 44 50 80 00       	mov    %eax,0x805044
  802660:	8b 45 08             	mov    0x8(%ebp),%eax
  802663:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802669:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80266e:	40                   	inc    %eax
  80266f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802674:	e9 5a 01 00 00       	jmp    8027d3 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267c:	8b 50 08             	mov    0x8(%eax),%edx
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
  802682:	8b 40 08             	mov    0x8(%eax),%eax
  802685:	39 c2                	cmp    %eax,%edx
  802687:	75 70                	jne    8026f9 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802689:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80268d:	74 06                	je     802695 <insert_sorted_allocList+0x11c>
  80268f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802693:	75 14                	jne    8026a9 <insert_sorted_allocList+0x130>
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	68 14 42 80 00       	push   $0x804214
  80269d:	6a 75                	push   $0x75
  80269f:	68 d7 41 80 00       	push   $0x8041d7
  8026a4:	e8 26 e0 ff ff       	call   8006cf <_panic>
  8026a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ac:	8b 10                	mov    (%eax),%edx
  8026ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b1:	89 10                	mov    %edx,(%eax)
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	74 0b                	je     8026c7 <insert_sorted_allocList+0x14e>
  8026bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c4:	89 50 04             	mov    %edx,0x4(%eax)
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cd:	89 10                	mov    %edx,(%eax)
  8026cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d5:	89 50 04             	mov    %edx,0x4(%eax)
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	8b 00                	mov    (%eax),%eax
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	75 08                	jne    8026e9 <insert_sorted_allocList+0x170>
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	a3 44 50 80 00       	mov    %eax,0x805044
  8026e9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026ee:	40                   	inc    %eax
  8026ef:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8026f4:	e9 da 00 00 00       	jmp    8027d3 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8026f9:	a1 40 50 80 00       	mov    0x805040,%eax
  8026fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802701:	e9 9d 00 00 00       	jmp    8027a3 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	8b 50 08             	mov    0x8(%eax),%edx
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 08             	mov    0x8(%eax),%eax
  80271a:	39 c2                	cmp    %eax,%edx
  80271c:	76 7d                	jbe    80279b <insert_sorted_allocList+0x222>
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	8b 50 08             	mov    0x8(%eax),%edx
  802724:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802727:	8b 40 08             	mov    0x8(%eax),%eax
  80272a:	39 c2                	cmp    %eax,%edx
  80272c:	73 6d                	jae    80279b <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80272e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802732:	74 06                	je     80273a <insert_sorted_allocList+0x1c1>
  802734:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802738:	75 14                	jne    80274e <insert_sorted_allocList+0x1d5>
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	68 14 42 80 00       	push   $0x804214
  802742:	6a 7c                	push   $0x7c
  802744:	68 d7 41 80 00       	push   $0x8041d7
  802749:	e8 81 df ff ff       	call   8006cf <_panic>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 10                	mov    (%eax),%edx
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	89 10                	mov    %edx,(%eax)
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	8b 00                	mov    (%eax),%eax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	74 0b                	je     80276c <insert_sorted_allocList+0x1f3>
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	8b 55 08             	mov    0x8(%ebp),%edx
  802769:	89 50 04             	mov    %edx,0x4(%eax)
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 55 08             	mov    0x8(%ebp),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277a:	89 50 04             	mov    %edx,0x4(%eax)
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	75 08                	jne    80278e <insert_sorted_allocList+0x215>
  802786:	8b 45 08             	mov    0x8(%ebp),%eax
  802789:	a3 44 50 80 00       	mov    %eax,0x805044
  80278e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802793:	40                   	inc    %eax
  802794:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802799:	eb 38                	jmp    8027d3 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80279b:	a1 48 50 80 00       	mov    0x805048,%eax
  8027a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a7:	74 07                	je     8027b0 <insert_sorted_allocList+0x237>
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	eb 05                	jmp    8027b5 <insert_sorted_allocList+0x23c>
  8027b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b5:	a3 48 50 80 00       	mov    %eax,0x805048
  8027ba:	a1 48 50 80 00       	mov    0x805048,%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	0f 85 3f ff ff ff    	jne    802706 <insert_sorted_allocList+0x18d>
  8027c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cb:	0f 85 35 ff ff ff    	jne    802706 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8027d1:	eb 00                	jmp    8027d3 <insert_sorted_allocList+0x25a>
  8027d3:	90                   	nop
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8027dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8027e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e4:	e9 6b 02 00 00       	jmp    802a54 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f2:	0f 85 90 00 00 00    	jne    802888 <alloc_block_FF+0xb2>
			  temp=element;
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8027fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802802:	75 17                	jne    80281b <alloc_block_FF+0x45>
  802804:	83 ec 04             	sub    $0x4,%esp
  802807:	68 48 42 80 00       	push   $0x804248
  80280c:	68 92 00 00 00       	push   $0x92
  802811:	68 d7 41 80 00       	push   $0x8041d7
  802816:	e8 b4 de ff ff       	call   8006cf <_panic>
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	74 10                	je     802834 <alloc_block_FF+0x5e>
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282c:	8b 52 04             	mov    0x4(%edx),%edx
  80282f:	89 50 04             	mov    %edx,0x4(%eax)
  802832:	eb 0b                	jmp    80283f <alloc_block_FF+0x69>
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 40 04             	mov    0x4(%eax),%eax
  80283a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	74 0f                	je     802858 <alloc_block_FF+0x82>
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802852:	8b 12                	mov    (%edx),%edx
  802854:	89 10                	mov    %edx,(%eax)
  802856:	eb 0a                	jmp    802862 <alloc_block_FF+0x8c>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	a3 38 51 80 00       	mov    %eax,0x805138
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802875:	a1 44 51 80 00       	mov    0x805144,%eax
  80287a:	48                   	dec    %eax
  80287b:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802880:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802883:	e9 ff 01 00 00       	jmp    802a87 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 0c             	mov    0xc(%eax),%eax
  80288e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802891:	0f 86 b5 01 00 00    	jbe    802a4c <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 40 0c             	mov    0xc(%eax),%eax
  80289d:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8028a3:	a1 48 51 80 00       	mov    0x805148,%eax
  8028a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8028ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028af:	75 17                	jne    8028c8 <alloc_block_FF+0xf2>
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 48 42 80 00       	push   $0x804248
  8028b9:	68 99 00 00 00       	push   $0x99
  8028be:	68 d7 41 80 00       	push   $0x8041d7
  8028c3:	e8 07 de ff ff       	call   8006cf <_panic>
  8028c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 10                	je     8028e1 <alloc_block_FF+0x10b>
  8028d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d9:	8b 52 04             	mov    0x4(%edx),%edx
  8028dc:	89 50 04             	mov    %edx,0x4(%eax)
  8028df:	eb 0b                	jmp    8028ec <alloc_block_FF+0x116>
  8028e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e4:	8b 40 04             	mov    0x4(%eax),%eax
  8028e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ef:	8b 40 04             	mov    0x4(%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 0f                	je     802905 <alloc_block_FF+0x12f>
  8028f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ff:	8b 12                	mov    (%edx),%edx
  802901:	89 10                	mov    %edx,(%eax)
  802903:	eb 0a                	jmp    80290f <alloc_block_FF+0x139>
  802905:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	a3 48 51 80 00       	mov    %eax,0x805148
  80290f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802922:	a1 54 51 80 00       	mov    0x805154,%eax
  802927:	48                   	dec    %eax
  802928:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80292d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802931:	75 17                	jne    80294a <alloc_block_FF+0x174>
  802933:	83 ec 04             	sub    $0x4,%esp
  802936:	68 f0 41 80 00       	push   $0x8041f0
  80293b:	68 9a 00 00 00       	push   $0x9a
  802940:	68 d7 41 80 00       	push   $0x8041d7
  802945:	e8 85 dd ff ff       	call   8006cf <_panic>
  80294a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802953:	89 50 04             	mov    %edx,0x4(%eax)
  802956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802959:	8b 40 04             	mov    0x4(%eax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	74 0c                	je     80296c <alloc_block_FF+0x196>
  802960:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802965:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802968:	89 10                	mov    %edx,(%eax)
  80296a:	eb 08                	jmp    802974 <alloc_block_FF+0x19e>
  80296c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296f:	a3 38 51 80 00       	mov    %eax,0x805138
  802974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802977:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80297c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802985:	a1 44 51 80 00       	mov    0x805144,%eax
  80298a:	40                   	inc    %eax
  80298b:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802990:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802993:	8b 55 08             	mov    0x8(%ebp),%edx
  802996:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 50 08             	mov    0x8(%eax),%edx
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029ab:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 50 08             	mov    0x8(%eax),%edx
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	01 c2                	add    %eax,%edx
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8029c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c9:	75 17                	jne    8029e2 <alloc_block_FF+0x20c>
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	68 48 42 80 00       	push   $0x804248
  8029d3:	68 a2 00 00 00       	push   $0xa2
  8029d8:	68 d7 41 80 00       	push   $0x8041d7
  8029dd:	e8 ed dc ff ff       	call   8006cf <_panic>
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	74 10                	je     8029fb <alloc_block_FF+0x225>
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029f3:	8b 52 04             	mov    0x4(%edx),%edx
  8029f6:	89 50 04             	mov    %edx,0x4(%eax)
  8029f9:	eb 0b                	jmp    802a06 <alloc_block_FF+0x230>
  8029fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fe:	8b 40 04             	mov    0x4(%eax),%eax
  802a01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a09:	8b 40 04             	mov    0x4(%eax),%eax
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	74 0f                	je     802a1f <alloc_block_FF+0x249>
  802a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a13:	8b 40 04             	mov    0x4(%eax),%eax
  802a16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a19:	8b 12                	mov    (%edx),%edx
  802a1b:	89 10                	mov    %edx,(%eax)
  802a1d:	eb 0a                	jmp    802a29 <alloc_block_FF+0x253>
  802a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	a3 38 51 80 00       	mov    %eax,0x805138
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3c:	a1 44 51 80 00       	mov    0x805144,%eax
  802a41:	48                   	dec    %eax
  802a42:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4a:	eb 3b                	jmp    802a87 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802a4c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a58:	74 07                	je     802a61 <alloc_block_FF+0x28b>
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	eb 05                	jmp    802a66 <alloc_block_FF+0x290>
  802a61:	b8 00 00 00 00       	mov    $0x0,%eax
  802a66:	a3 40 51 80 00       	mov    %eax,0x805140
  802a6b:	a1 40 51 80 00       	mov    0x805140,%eax
  802a70:	85 c0                	test   %eax,%eax
  802a72:	0f 85 71 fd ff ff    	jne    8027e9 <alloc_block_FF+0x13>
  802a78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7c:	0f 85 67 fd ff ff    	jne    8027e9 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
  802a8c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802a8f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802a96:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802a9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802aa5:	e9 d3 00 00 00       	jmp    802b7d <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aad:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab3:	0f 85 90 00 00 00    	jne    802b49 <alloc_block_BF+0xc0>
	   temp = element;
  802ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802abf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ac3:	75 17                	jne    802adc <alloc_block_BF+0x53>
  802ac5:	83 ec 04             	sub    $0x4,%esp
  802ac8:	68 48 42 80 00       	push   $0x804248
  802acd:	68 bd 00 00 00       	push   $0xbd
  802ad2:	68 d7 41 80 00       	push   $0x8041d7
  802ad7:	e8 f3 db ff ff       	call   8006cf <_panic>
  802adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 10                	je     802af5 <alloc_block_BF+0x6c>
  802ae5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aed:	8b 52 04             	mov    0x4(%edx),%edx
  802af0:	89 50 04             	mov    %edx,0x4(%eax)
  802af3:	eb 0b                	jmp    802b00 <alloc_block_BF+0x77>
  802af5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b03:	8b 40 04             	mov    0x4(%eax),%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	74 0f                	je     802b19 <alloc_block_BF+0x90>
  802b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0d:	8b 40 04             	mov    0x4(%eax),%eax
  802b10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b13:	8b 12                	mov    (%edx),%edx
  802b15:	89 10                	mov    %edx,(%eax)
  802b17:	eb 0a                	jmp    802b23 <alloc_block_BF+0x9a>
  802b19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1c:	8b 00                	mov    (%eax),%eax
  802b1e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b36:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3b:	48                   	dec    %eax
  802b3c:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802b41:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b44:	e9 41 01 00 00       	jmp    802c8a <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b52:	76 21                	jbe    802b75 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802b54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b57:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b5d:	73 16                	jae    802b75 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b62:	8b 40 0c             	mov    0xc(%eax),%eax
  802b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802b68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802b6e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802b75:	a1 40 51 80 00       	mov    0x805140,%eax
  802b7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b7d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b81:	74 07                	je     802b8a <alloc_block_BF+0x101>
  802b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b86:	8b 00                	mov    (%eax),%eax
  802b88:	eb 05                	jmp    802b8f <alloc_block_BF+0x106>
  802b8a:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8f:	a3 40 51 80 00       	mov    %eax,0x805140
  802b94:	a1 40 51 80 00       	mov    0x805140,%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	0f 85 09 ff ff ff    	jne    802aaa <alloc_block_BF+0x21>
  802ba1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ba5:	0f 85 ff fe ff ff    	jne    802aaa <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802bab:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802baf:	0f 85 d0 00 00 00    	jne    802c85 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbb:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802bc1:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802bc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bcd:	75 17                	jne    802be6 <alloc_block_BF+0x15d>
  802bcf:	83 ec 04             	sub    $0x4,%esp
  802bd2:	68 48 42 80 00       	push   $0x804248
  802bd7:	68 d1 00 00 00       	push   $0xd1
  802bdc:	68 d7 41 80 00       	push   $0x8041d7
  802be1:	e8 e9 da ff ff       	call   8006cf <_panic>
  802be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 10                	je     802bff <alloc_block_BF+0x176>
  802bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bf7:	8b 52 04             	mov    0x4(%edx),%edx
  802bfa:	89 50 04             	mov    %edx,0x4(%eax)
  802bfd:	eb 0b                	jmp    802c0a <alloc_block_BF+0x181>
  802bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0d:	8b 40 04             	mov    0x4(%eax),%eax
  802c10:	85 c0                	test   %eax,%eax
  802c12:	74 0f                	je     802c23 <alloc_block_BF+0x19a>
  802c14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c17:	8b 40 04             	mov    0x4(%eax),%eax
  802c1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c1d:	8b 12                	mov    (%edx),%edx
  802c1f:	89 10                	mov    %edx,(%eax)
  802c21:	eb 0a                	jmp    802c2d <alloc_block_BF+0x1a4>
  802c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c26:	8b 00                	mov    (%eax),%eax
  802c28:	a3 48 51 80 00       	mov    %eax,0x805148
  802c2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c40:	a1 54 51 80 00       	mov    0x805154,%eax
  802c45:	48                   	dec    %eax
  802c46:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802c4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c51:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802c54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c57:	8b 50 08             	mov    0x8(%eax),%edx
  802c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5d:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c66:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6c:	8b 50 08             	mov    0x8(%eax),%edx
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	01 c2                	add    %eax,%edx
  802c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c77:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802c7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802c80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c83:	eb 05                	jmp    802c8a <alloc_block_BF+0x201>
	 }
	 return NULL;
  802c85:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802c8a:	c9                   	leave  
  802c8b:	c3                   	ret    

00802c8c <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c8c:	55                   	push   %ebp
  802c8d:	89 e5                	mov    %esp,%ebp
  802c8f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802c92:	83 ec 04             	sub    $0x4,%esp
  802c95:	68 68 42 80 00       	push   $0x804268
  802c9a:	68 e8 00 00 00       	push   $0xe8
  802c9f:	68 d7 41 80 00       	push   $0x8041d7
  802ca4:	e8 26 da ff ff       	call   8006cf <_panic>

00802ca9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ca9:	55                   	push   %ebp
  802caa:	89 e5                	mov    %esp,%ebp
  802cac:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802caf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802cb7:	a1 38 51 80 00       	mov    0x805138,%eax
  802cbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802cbf:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802cc7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ccb:	75 68                	jne    802d35 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ccd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd1:	75 17                	jne    802cea <insert_sorted_with_merge_freeList+0x41>
  802cd3:	83 ec 04             	sub    $0x4,%esp
  802cd6:	68 b4 41 80 00       	push   $0x8041b4
  802cdb:	68 36 01 00 00       	push   $0x136
  802ce0:	68 d7 41 80 00       	push   $0x8041d7
  802ce5:	e8 e5 d9 ff ff       	call   8006cf <_panic>
  802cea:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	89 10                	mov    %edx,(%eax)
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	85 c0                	test   %eax,%eax
  802cfc:	74 0d                	je     802d0b <insert_sorted_with_merge_freeList+0x62>
  802cfe:	a1 38 51 80 00       	mov    0x805138,%eax
  802d03:	8b 55 08             	mov    0x8(%ebp),%edx
  802d06:	89 50 04             	mov    %edx,0x4(%eax)
  802d09:	eb 08                	jmp    802d13 <insert_sorted_with_merge_freeList+0x6a>
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	a3 38 51 80 00       	mov    %eax,0x805138
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d25:	a1 44 51 80 00       	mov    0x805144,%eax
  802d2a:	40                   	inc    %eax
  802d2b:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802d30:	e9 ba 06 00 00       	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	8b 50 08             	mov    0x8(%eax),%edx
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d41:	01 c2                	add    %eax,%edx
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	8b 40 08             	mov    0x8(%eax),%eax
  802d49:	39 c2                	cmp    %eax,%edx
  802d4b:	73 68                	jae    802db5 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d51:	75 17                	jne    802d6a <insert_sorted_with_merge_freeList+0xc1>
  802d53:	83 ec 04             	sub    $0x4,%esp
  802d56:	68 f0 41 80 00       	push   $0x8041f0
  802d5b:	68 3a 01 00 00       	push   $0x13a
  802d60:	68 d7 41 80 00       	push   $0x8041d7
  802d65:	e8 65 d9 ff ff       	call   8006cf <_panic>
  802d6a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	89 50 04             	mov    %edx,0x4(%eax)
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	8b 40 04             	mov    0x4(%eax),%eax
  802d7c:	85 c0                	test   %eax,%eax
  802d7e:	74 0c                	je     802d8c <insert_sorted_with_merge_freeList+0xe3>
  802d80:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d85:	8b 55 08             	mov    0x8(%ebp),%edx
  802d88:	89 10                	mov    %edx,(%eax)
  802d8a:	eb 08                	jmp    802d94 <insert_sorted_with_merge_freeList+0xeb>
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	a3 38 51 80 00       	mov    %eax,0x805138
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da5:	a1 44 51 80 00       	mov    0x805144,%eax
  802daa:	40                   	inc    %eax
  802dab:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802db0:	e9 3a 06 00 00       	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db8:	8b 50 08             	mov    0x8(%eax),%edx
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc1:	01 c2                	add    %eax,%edx
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	8b 40 08             	mov    0x8(%eax),%eax
  802dc9:	39 c2                	cmp    %eax,%edx
  802dcb:	0f 85 90 00 00 00    	jne    802e61 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd4:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddd:	01 c2                	add    %eax,%edx
  802ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de2:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802def:	8b 45 08             	mov    0x8(%ebp),%eax
  802df2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802df9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfd:	75 17                	jne    802e16 <insert_sorted_with_merge_freeList+0x16d>
  802dff:	83 ec 04             	sub    $0x4,%esp
  802e02:	68 b4 41 80 00       	push   $0x8041b4
  802e07:	68 41 01 00 00       	push   $0x141
  802e0c:	68 d7 41 80 00       	push   $0x8041d7
  802e11:	e8 b9 d8 ff ff       	call   8006cf <_panic>
  802e16:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	89 10                	mov    %edx,(%eax)
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	85 c0                	test   %eax,%eax
  802e28:	74 0d                	je     802e37 <insert_sorted_with_merge_freeList+0x18e>
  802e2a:	a1 48 51 80 00       	mov    0x805148,%eax
  802e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e32:	89 50 04             	mov    %edx,0x4(%eax)
  802e35:	eb 08                	jmp    802e3f <insert_sorted_with_merge_freeList+0x196>
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	a3 48 51 80 00       	mov    %eax,0x805148
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e51:	a1 54 51 80 00       	mov    0x805154,%eax
  802e56:	40                   	inc    %eax
  802e57:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802e5c:	e9 8e 05 00 00       	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	8b 50 08             	mov    0x8(%eax),%edx
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6d:	01 c2                	add    %eax,%edx
  802e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e72:	8b 40 08             	mov    0x8(%eax),%eax
  802e75:	39 c2                	cmp    %eax,%edx
  802e77:	73 68                	jae    802ee1 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802e79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7d:	75 17                	jne    802e96 <insert_sorted_with_merge_freeList+0x1ed>
  802e7f:	83 ec 04             	sub    $0x4,%esp
  802e82:	68 b4 41 80 00       	push   $0x8041b4
  802e87:	68 45 01 00 00       	push   $0x145
  802e8c:	68 d7 41 80 00       	push   $0x8041d7
  802e91:	e8 39 d8 ff ff       	call   8006cf <_panic>
  802e96:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	89 10                	mov    %edx,(%eax)
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	85 c0                	test   %eax,%eax
  802ea8:	74 0d                	je     802eb7 <insert_sorted_with_merge_freeList+0x20e>
  802eaa:	a1 38 51 80 00       	mov    0x805138,%eax
  802eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb2:	89 50 04             	mov    %edx,0x4(%eax)
  802eb5:	eb 08                	jmp    802ebf <insert_sorted_with_merge_freeList+0x216>
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed1:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed6:	40                   	inc    %eax
  802ed7:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802edc:	e9 0e 05 00 00       	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	8b 50 08             	mov    0x8(%eax),%edx
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	8b 40 0c             	mov    0xc(%eax),%eax
  802eed:	01 c2                	add    %eax,%edx
  802eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef2:	8b 40 08             	mov    0x8(%eax),%eax
  802ef5:	39 c2                	cmp    %eax,%edx
  802ef7:	0f 85 9c 00 00 00    	jne    802f99 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f00:	8b 50 0c             	mov    0xc(%eax),%edx
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	8b 40 0c             	mov    0xc(%eax),%eax
  802f09:	01 c2                	add    %eax,%edx
  802f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0e:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	8b 50 08             	mov    0x8(%eax),%edx
  802f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1a:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f35:	75 17                	jne    802f4e <insert_sorted_with_merge_freeList+0x2a5>
  802f37:	83 ec 04             	sub    $0x4,%esp
  802f3a:	68 b4 41 80 00       	push   $0x8041b4
  802f3f:	68 4d 01 00 00       	push   $0x14d
  802f44:	68 d7 41 80 00       	push   $0x8041d7
  802f49:	e8 81 d7 ff ff       	call   8006cf <_panic>
  802f4e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 0d                	je     802f6f <insert_sorted_with_merge_freeList+0x2c6>
  802f62:	a1 48 51 80 00       	mov    0x805148,%eax
  802f67:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6a:	89 50 04             	mov    %edx,0x4(%eax)
  802f6d:	eb 08                	jmp    802f77 <insert_sorted_with_merge_freeList+0x2ce>
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f89:	a1 54 51 80 00       	mov    0x805154,%eax
  802f8e:	40                   	inc    %eax
  802f8f:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802f94:	e9 56 04 00 00       	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f99:	a1 38 51 80 00       	mov    0x805138,%eax
  802f9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa1:	e9 19 04 00 00       	jmp    8033bf <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 00                	mov    (%eax),%eax
  802fab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 50 08             	mov    0x8(%eax),%edx
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fba:	01 c2                	add    %eax,%edx
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	8b 40 08             	mov    0x8(%eax),%eax
  802fc2:	39 c2                	cmp    %eax,%edx
  802fc4:	0f 85 ad 01 00 00    	jne    803177 <insert_sorted_with_merge_freeList+0x4ce>
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	8b 50 08             	mov    0x8(%eax),%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd6:	01 c2                	add    %eax,%edx
  802fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fdb:	8b 40 08             	mov    0x8(%eax),%eax
  802fde:	39 c2                	cmp    %eax,%edx
  802fe0:	0f 85 91 01 00 00    	jne    803177 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 50 0c             	mov    0xc(%eax),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff8:	01 c8                	add    %ecx,%eax
  802ffa:	01 c2                	add    %eax,%edx
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803019:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803023:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  80302a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80302e:	75 17                	jne    803047 <insert_sorted_with_merge_freeList+0x39e>
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 48 42 80 00       	push   $0x804248
  803038:	68 5b 01 00 00       	push   $0x15b
  80303d:	68 d7 41 80 00       	push   $0x8041d7
  803042:	e8 88 d6 ff ff       	call   8006cf <_panic>
  803047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	85 c0                	test   %eax,%eax
  80304e:	74 10                	je     803060 <insert_sorted_with_merge_freeList+0x3b7>
  803050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803058:	8b 52 04             	mov    0x4(%edx),%edx
  80305b:	89 50 04             	mov    %edx,0x4(%eax)
  80305e:	eb 0b                	jmp    80306b <insert_sorted_with_merge_freeList+0x3c2>
  803060:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803063:	8b 40 04             	mov    0x4(%eax),%eax
  803066:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80306b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306e:	8b 40 04             	mov    0x4(%eax),%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	74 0f                	je     803084 <insert_sorted_with_merge_freeList+0x3db>
  803075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803078:	8b 40 04             	mov    0x4(%eax),%eax
  80307b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80307e:	8b 12                	mov    (%edx),%edx
  803080:	89 10                	mov    %edx,(%eax)
  803082:	eb 0a                	jmp    80308e <insert_sorted_with_merge_freeList+0x3e5>
  803084:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	a3 38 51 80 00       	mov    %eax,0x805138
  80308e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803091:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a1:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a6:	48                   	dec    %eax
  8030a7:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b0:	75 17                	jne    8030c9 <insert_sorted_with_merge_freeList+0x420>
  8030b2:	83 ec 04             	sub    $0x4,%esp
  8030b5:	68 b4 41 80 00       	push   $0x8041b4
  8030ba:	68 5c 01 00 00       	push   $0x15c
  8030bf:	68 d7 41 80 00       	push   $0x8041d7
  8030c4:	e8 06 d6 ff ff       	call   8006cf <_panic>
  8030c9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	89 10                	mov    %edx,(%eax)
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	74 0d                	je     8030ea <insert_sorted_with_merge_freeList+0x441>
  8030dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8030e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e5:	89 50 04             	mov    %edx,0x4(%eax)
  8030e8:	eb 08                	jmp    8030f2 <insert_sorted_with_merge_freeList+0x449>
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803104:	a1 54 51 80 00       	mov    0x805154,%eax
  803109:	40                   	inc    %eax
  80310a:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  80310f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803113:	75 17                	jne    80312c <insert_sorted_with_merge_freeList+0x483>
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	68 b4 41 80 00       	push   $0x8041b4
  80311d:	68 5d 01 00 00       	push   $0x15d
  803122:	68 d7 41 80 00       	push   $0x8041d7
  803127:	e8 a3 d5 ff ff       	call   8006cf <_panic>
  80312c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803132:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803135:	89 10                	mov    %edx,(%eax)
  803137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313a:	8b 00                	mov    (%eax),%eax
  80313c:	85 c0                	test   %eax,%eax
  80313e:	74 0d                	je     80314d <insert_sorted_with_merge_freeList+0x4a4>
  803140:	a1 48 51 80 00       	mov    0x805148,%eax
  803145:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803148:	89 50 04             	mov    %edx,0x4(%eax)
  80314b:	eb 08                	jmp    803155 <insert_sorted_with_merge_freeList+0x4ac>
  80314d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803150:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803158:	a3 48 51 80 00       	mov    %eax,0x805148
  80315d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803167:	a1 54 51 80 00       	mov    0x805154,%eax
  80316c:	40                   	inc    %eax
  80316d:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803172:	e9 78 02 00 00       	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 50 08             	mov    0x8(%eax),%edx
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	8b 40 0c             	mov    0xc(%eax),%eax
  803183:	01 c2                	add    %eax,%edx
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	8b 40 08             	mov    0x8(%eax),%eax
  80318b:	39 c2                	cmp    %eax,%edx
  80318d:	0f 83 b8 00 00 00    	jae    80324b <insert_sorted_with_merge_freeList+0x5a2>
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	8b 50 08             	mov    0x8(%eax),%edx
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	8b 40 0c             	mov    0xc(%eax),%eax
  80319f:	01 c2                	add    %eax,%edx
  8031a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a4:	8b 40 08             	mov    0x8(%eax),%eax
  8031a7:	39 c2                	cmp    %eax,%edx
  8031a9:	0f 85 9c 00 00 00    	jne    80324b <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  8031af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b2:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bb:	01 c2                	add    %eax,%edx
  8031bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c0:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	8b 50 08             	mov    0x8(%eax),%edx
  8031c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cc:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e7:	75 17                	jne    803200 <insert_sorted_with_merge_freeList+0x557>
  8031e9:	83 ec 04             	sub    $0x4,%esp
  8031ec:	68 b4 41 80 00       	push   $0x8041b4
  8031f1:	68 67 01 00 00       	push   $0x167
  8031f6:	68 d7 41 80 00       	push   $0x8041d7
  8031fb:	e8 cf d4 ff ff       	call   8006cf <_panic>
  803200:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	89 10                	mov    %edx,(%eax)
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	85 c0                	test   %eax,%eax
  803212:	74 0d                	je     803221 <insert_sorted_with_merge_freeList+0x578>
  803214:	a1 48 51 80 00       	mov    0x805148,%eax
  803219:	8b 55 08             	mov    0x8(%ebp),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	eb 08                	jmp    803229 <insert_sorted_with_merge_freeList+0x580>
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	a3 48 51 80 00       	mov    %eax,0x805148
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323b:	a1 54 51 80 00       	mov    0x805154,%eax
  803240:	40                   	inc    %eax
  803241:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803246:	e9 a4 01 00 00       	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	8b 50 08             	mov    0x8(%eax),%edx
  803251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803254:	8b 40 0c             	mov    0xc(%eax),%eax
  803257:	01 c2                	add    %eax,%edx
  803259:	8b 45 08             	mov    0x8(%ebp),%eax
  80325c:	8b 40 08             	mov    0x8(%eax),%eax
  80325f:	39 c2                	cmp    %eax,%edx
  803261:	0f 85 ac 00 00 00    	jne    803313 <insert_sorted_with_merge_freeList+0x66a>
  803267:	8b 45 08             	mov    0x8(%ebp),%eax
  80326a:	8b 50 08             	mov    0x8(%eax),%edx
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	8b 40 0c             	mov    0xc(%eax),%eax
  803273:	01 c2                	add    %eax,%edx
  803275:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803278:	8b 40 08             	mov    0x8(%eax),%eax
  80327b:	39 c2                	cmp    %eax,%edx
  80327d:	0f 83 90 00 00 00    	jae    803313 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 50 0c             	mov    0xc(%eax),%edx
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	8b 40 0c             	mov    0xc(%eax),%eax
  80328f:	01 c2                	add    %eax,%edx
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032af:	75 17                	jne    8032c8 <insert_sorted_with_merge_freeList+0x61f>
  8032b1:	83 ec 04             	sub    $0x4,%esp
  8032b4:	68 b4 41 80 00       	push   $0x8041b4
  8032b9:	68 70 01 00 00       	push   $0x170
  8032be:	68 d7 41 80 00       	push   $0x8041d7
  8032c3:	e8 07 d4 ff ff       	call   8006cf <_panic>
  8032c8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	89 10                	mov    %edx,(%eax)
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	74 0d                	je     8032e9 <insert_sorted_with_merge_freeList+0x640>
  8032dc:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e4:	89 50 04             	mov    %edx,0x4(%eax)
  8032e7:	eb 08                	jmp    8032f1 <insert_sorted_with_merge_freeList+0x648>
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803303:	a1 54 51 80 00       	mov    0x805154,%eax
  803308:	40                   	inc    %eax
  803309:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  80330e:	e9 dc 00 00 00       	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803316:	8b 50 08             	mov    0x8(%eax),%edx
  803319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331c:	8b 40 0c             	mov    0xc(%eax),%eax
  80331f:	01 c2                	add    %eax,%edx
  803321:	8b 45 08             	mov    0x8(%ebp),%eax
  803324:	8b 40 08             	mov    0x8(%eax),%eax
  803327:	39 c2                	cmp    %eax,%edx
  803329:	0f 83 88 00 00 00    	jae    8033b7 <insert_sorted_with_merge_freeList+0x70e>
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	8b 50 08             	mov    0x8(%eax),%edx
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	8b 40 0c             	mov    0xc(%eax),%eax
  80333b:	01 c2                	add    %eax,%edx
  80333d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803340:	8b 40 08             	mov    0x8(%eax),%eax
  803343:	39 c2                	cmp    %eax,%edx
  803345:	73 70                	jae    8033b7 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803347:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80334b:	74 06                	je     803353 <insert_sorted_with_merge_freeList+0x6aa>
  80334d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803351:	75 17                	jne    80336a <insert_sorted_with_merge_freeList+0x6c1>
  803353:	83 ec 04             	sub    $0x4,%esp
  803356:	68 14 42 80 00       	push   $0x804214
  80335b:	68 75 01 00 00       	push   $0x175
  803360:	68 d7 41 80 00       	push   $0x8041d7
  803365:	e8 65 d3 ff ff       	call   8006cf <_panic>
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	8b 10                	mov    (%eax),%edx
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	89 10                	mov    %edx,(%eax)
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	8b 00                	mov    (%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 0b                	je     803388 <insert_sorted_with_merge_freeList+0x6df>
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 00                	mov    (%eax),%eax
  803382:	8b 55 08             	mov    0x8(%ebp),%edx
  803385:	89 50 04             	mov    %edx,0x4(%eax)
  803388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338b:	8b 55 08             	mov    0x8(%ebp),%edx
  80338e:	89 10                	mov    %edx,(%eax)
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803396:	89 50 04             	mov    %edx,0x4(%eax)
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	8b 00                	mov    (%eax),%eax
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	75 08                	jne    8033aa <insert_sorted_with_merge_freeList+0x701>
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033aa:	a1 44 51 80 00       	mov    0x805144,%eax
  8033af:	40                   	inc    %eax
  8033b0:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  8033b5:	eb 38                	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8033b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8033bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c3:	74 07                	je     8033cc <insert_sorted_with_merge_freeList+0x723>
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	8b 00                	mov    (%eax),%eax
  8033ca:	eb 05                	jmp    8033d1 <insert_sorted_with_merge_freeList+0x728>
  8033cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d1:	a3 40 51 80 00       	mov    %eax,0x805140
  8033d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8033db:	85 c0                	test   %eax,%eax
  8033dd:	0f 85 c3 fb ff ff    	jne    802fa6 <insert_sorted_with_merge_freeList+0x2fd>
  8033e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e7:	0f 85 b9 fb ff ff    	jne    802fa6 <insert_sorted_with_merge_freeList+0x2fd>





}
  8033ed:	eb 00                	jmp    8033ef <insert_sorted_with_merge_freeList+0x746>
  8033ef:	90                   	nop
  8033f0:	c9                   	leave  
  8033f1:	c3                   	ret    
  8033f2:	66 90                	xchg   %ax,%ax

008033f4 <__udivdi3>:
  8033f4:	55                   	push   %ebp
  8033f5:	57                   	push   %edi
  8033f6:	56                   	push   %esi
  8033f7:	53                   	push   %ebx
  8033f8:	83 ec 1c             	sub    $0x1c,%esp
  8033fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803403:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803407:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80340b:	89 ca                	mov    %ecx,%edx
  80340d:	89 f8                	mov    %edi,%eax
  80340f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803413:	85 f6                	test   %esi,%esi
  803415:	75 2d                	jne    803444 <__udivdi3+0x50>
  803417:	39 cf                	cmp    %ecx,%edi
  803419:	77 65                	ja     803480 <__udivdi3+0x8c>
  80341b:	89 fd                	mov    %edi,%ebp
  80341d:	85 ff                	test   %edi,%edi
  80341f:	75 0b                	jne    80342c <__udivdi3+0x38>
  803421:	b8 01 00 00 00       	mov    $0x1,%eax
  803426:	31 d2                	xor    %edx,%edx
  803428:	f7 f7                	div    %edi
  80342a:	89 c5                	mov    %eax,%ebp
  80342c:	31 d2                	xor    %edx,%edx
  80342e:	89 c8                	mov    %ecx,%eax
  803430:	f7 f5                	div    %ebp
  803432:	89 c1                	mov    %eax,%ecx
  803434:	89 d8                	mov    %ebx,%eax
  803436:	f7 f5                	div    %ebp
  803438:	89 cf                	mov    %ecx,%edi
  80343a:	89 fa                	mov    %edi,%edx
  80343c:	83 c4 1c             	add    $0x1c,%esp
  80343f:	5b                   	pop    %ebx
  803440:	5e                   	pop    %esi
  803441:	5f                   	pop    %edi
  803442:	5d                   	pop    %ebp
  803443:	c3                   	ret    
  803444:	39 ce                	cmp    %ecx,%esi
  803446:	77 28                	ja     803470 <__udivdi3+0x7c>
  803448:	0f bd fe             	bsr    %esi,%edi
  80344b:	83 f7 1f             	xor    $0x1f,%edi
  80344e:	75 40                	jne    803490 <__udivdi3+0x9c>
  803450:	39 ce                	cmp    %ecx,%esi
  803452:	72 0a                	jb     80345e <__udivdi3+0x6a>
  803454:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803458:	0f 87 9e 00 00 00    	ja     8034fc <__udivdi3+0x108>
  80345e:	b8 01 00 00 00       	mov    $0x1,%eax
  803463:	89 fa                	mov    %edi,%edx
  803465:	83 c4 1c             	add    $0x1c,%esp
  803468:	5b                   	pop    %ebx
  803469:	5e                   	pop    %esi
  80346a:	5f                   	pop    %edi
  80346b:	5d                   	pop    %ebp
  80346c:	c3                   	ret    
  80346d:	8d 76 00             	lea    0x0(%esi),%esi
  803470:	31 ff                	xor    %edi,%edi
  803472:	31 c0                	xor    %eax,%eax
  803474:	89 fa                	mov    %edi,%edx
  803476:	83 c4 1c             	add    $0x1c,%esp
  803479:	5b                   	pop    %ebx
  80347a:	5e                   	pop    %esi
  80347b:	5f                   	pop    %edi
  80347c:	5d                   	pop    %ebp
  80347d:	c3                   	ret    
  80347e:	66 90                	xchg   %ax,%ax
  803480:	89 d8                	mov    %ebx,%eax
  803482:	f7 f7                	div    %edi
  803484:	31 ff                	xor    %edi,%edi
  803486:	89 fa                	mov    %edi,%edx
  803488:	83 c4 1c             	add    $0x1c,%esp
  80348b:	5b                   	pop    %ebx
  80348c:	5e                   	pop    %esi
  80348d:	5f                   	pop    %edi
  80348e:	5d                   	pop    %ebp
  80348f:	c3                   	ret    
  803490:	bd 20 00 00 00       	mov    $0x20,%ebp
  803495:	89 eb                	mov    %ebp,%ebx
  803497:	29 fb                	sub    %edi,%ebx
  803499:	89 f9                	mov    %edi,%ecx
  80349b:	d3 e6                	shl    %cl,%esi
  80349d:	89 c5                	mov    %eax,%ebp
  80349f:	88 d9                	mov    %bl,%cl
  8034a1:	d3 ed                	shr    %cl,%ebp
  8034a3:	89 e9                	mov    %ebp,%ecx
  8034a5:	09 f1                	or     %esi,%ecx
  8034a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034ab:	89 f9                	mov    %edi,%ecx
  8034ad:	d3 e0                	shl    %cl,%eax
  8034af:	89 c5                	mov    %eax,%ebp
  8034b1:	89 d6                	mov    %edx,%esi
  8034b3:	88 d9                	mov    %bl,%cl
  8034b5:	d3 ee                	shr    %cl,%esi
  8034b7:	89 f9                	mov    %edi,%ecx
  8034b9:	d3 e2                	shl    %cl,%edx
  8034bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034bf:	88 d9                	mov    %bl,%cl
  8034c1:	d3 e8                	shr    %cl,%eax
  8034c3:	09 c2                	or     %eax,%edx
  8034c5:	89 d0                	mov    %edx,%eax
  8034c7:	89 f2                	mov    %esi,%edx
  8034c9:	f7 74 24 0c          	divl   0xc(%esp)
  8034cd:	89 d6                	mov    %edx,%esi
  8034cf:	89 c3                	mov    %eax,%ebx
  8034d1:	f7 e5                	mul    %ebp
  8034d3:	39 d6                	cmp    %edx,%esi
  8034d5:	72 19                	jb     8034f0 <__udivdi3+0xfc>
  8034d7:	74 0b                	je     8034e4 <__udivdi3+0xf0>
  8034d9:	89 d8                	mov    %ebx,%eax
  8034db:	31 ff                	xor    %edi,%edi
  8034dd:	e9 58 ff ff ff       	jmp    80343a <__udivdi3+0x46>
  8034e2:	66 90                	xchg   %ax,%ax
  8034e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034e8:	89 f9                	mov    %edi,%ecx
  8034ea:	d3 e2                	shl    %cl,%edx
  8034ec:	39 c2                	cmp    %eax,%edx
  8034ee:	73 e9                	jae    8034d9 <__udivdi3+0xe5>
  8034f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034f3:	31 ff                	xor    %edi,%edi
  8034f5:	e9 40 ff ff ff       	jmp    80343a <__udivdi3+0x46>
  8034fa:	66 90                	xchg   %ax,%ax
  8034fc:	31 c0                	xor    %eax,%eax
  8034fe:	e9 37 ff ff ff       	jmp    80343a <__udivdi3+0x46>
  803503:	90                   	nop

00803504 <__umoddi3>:
  803504:	55                   	push   %ebp
  803505:	57                   	push   %edi
  803506:	56                   	push   %esi
  803507:	53                   	push   %ebx
  803508:	83 ec 1c             	sub    $0x1c,%esp
  80350b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80350f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803513:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803517:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80351b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80351f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803523:	89 f3                	mov    %esi,%ebx
  803525:	89 fa                	mov    %edi,%edx
  803527:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80352b:	89 34 24             	mov    %esi,(%esp)
  80352e:	85 c0                	test   %eax,%eax
  803530:	75 1a                	jne    80354c <__umoddi3+0x48>
  803532:	39 f7                	cmp    %esi,%edi
  803534:	0f 86 a2 00 00 00    	jbe    8035dc <__umoddi3+0xd8>
  80353a:	89 c8                	mov    %ecx,%eax
  80353c:	89 f2                	mov    %esi,%edx
  80353e:	f7 f7                	div    %edi
  803540:	89 d0                	mov    %edx,%eax
  803542:	31 d2                	xor    %edx,%edx
  803544:	83 c4 1c             	add    $0x1c,%esp
  803547:	5b                   	pop    %ebx
  803548:	5e                   	pop    %esi
  803549:	5f                   	pop    %edi
  80354a:	5d                   	pop    %ebp
  80354b:	c3                   	ret    
  80354c:	39 f0                	cmp    %esi,%eax
  80354e:	0f 87 ac 00 00 00    	ja     803600 <__umoddi3+0xfc>
  803554:	0f bd e8             	bsr    %eax,%ebp
  803557:	83 f5 1f             	xor    $0x1f,%ebp
  80355a:	0f 84 ac 00 00 00    	je     80360c <__umoddi3+0x108>
  803560:	bf 20 00 00 00       	mov    $0x20,%edi
  803565:	29 ef                	sub    %ebp,%edi
  803567:	89 fe                	mov    %edi,%esi
  803569:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80356d:	89 e9                	mov    %ebp,%ecx
  80356f:	d3 e0                	shl    %cl,%eax
  803571:	89 d7                	mov    %edx,%edi
  803573:	89 f1                	mov    %esi,%ecx
  803575:	d3 ef                	shr    %cl,%edi
  803577:	09 c7                	or     %eax,%edi
  803579:	89 e9                	mov    %ebp,%ecx
  80357b:	d3 e2                	shl    %cl,%edx
  80357d:	89 14 24             	mov    %edx,(%esp)
  803580:	89 d8                	mov    %ebx,%eax
  803582:	d3 e0                	shl    %cl,%eax
  803584:	89 c2                	mov    %eax,%edx
  803586:	8b 44 24 08          	mov    0x8(%esp),%eax
  80358a:	d3 e0                	shl    %cl,%eax
  80358c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803590:	8b 44 24 08          	mov    0x8(%esp),%eax
  803594:	89 f1                	mov    %esi,%ecx
  803596:	d3 e8                	shr    %cl,%eax
  803598:	09 d0                	or     %edx,%eax
  80359a:	d3 eb                	shr    %cl,%ebx
  80359c:	89 da                	mov    %ebx,%edx
  80359e:	f7 f7                	div    %edi
  8035a0:	89 d3                	mov    %edx,%ebx
  8035a2:	f7 24 24             	mull   (%esp)
  8035a5:	89 c6                	mov    %eax,%esi
  8035a7:	89 d1                	mov    %edx,%ecx
  8035a9:	39 d3                	cmp    %edx,%ebx
  8035ab:	0f 82 87 00 00 00    	jb     803638 <__umoddi3+0x134>
  8035b1:	0f 84 91 00 00 00    	je     803648 <__umoddi3+0x144>
  8035b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035bb:	29 f2                	sub    %esi,%edx
  8035bd:	19 cb                	sbb    %ecx,%ebx
  8035bf:	89 d8                	mov    %ebx,%eax
  8035c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035c5:	d3 e0                	shl    %cl,%eax
  8035c7:	89 e9                	mov    %ebp,%ecx
  8035c9:	d3 ea                	shr    %cl,%edx
  8035cb:	09 d0                	or     %edx,%eax
  8035cd:	89 e9                	mov    %ebp,%ecx
  8035cf:	d3 eb                	shr    %cl,%ebx
  8035d1:	89 da                	mov    %ebx,%edx
  8035d3:	83 c4 1c             	add    $0x1c,%esp
  8035d6:	5b                   	pop    %ebx
  8035d7:	5e                   	pop    %esi
  8035d8:	5f                   	pop    %edi
  8035d9:	5d                   	pop    %ebp
  8035da:	c3                   	ret    
  8035db:	90                   	nop
  8035dc:	89 fd                	mov    %edi,%ebp
  8035de:	85 ff                	test   %edi,%edi
  8035e0:	75 0b                	jne    8035ed <__umoddi3+0xe9>
  8035e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e7:	31 d2                	xor    %edx,%edx
  8035e9:	f7 f7                	div    %edi
  8035eb:	89 c5                	mov    %eax,%ebp
  8035ed:	89 f0                	mov    %esi,%eax
  8035ef:	31 d2                	xor    %edx,%edx
  8035f1:	f7 f5                	div    %ebp
  8035f3:	89 c8                	mov    %ecx,%eax
  8035f5:	f7 f5                	div    %ebp
  8035f7:	89 d0                	mov    %edx,%eax
  8035f9:	e9 44 ff ff ff       	jmp    803542 <__umoddi3+0x3e>
  8035fe:	66 90                	xchg   %ax,%ax
  803600:	89 c8                	mov    %ecx,%eax
  803602:	89 f2                	mov    %esi,%edx
  803604:	83 c4 1c             	add    $0x1c,%esp
  803607:	5b                   	pop    %ebx
  803608:	5e                   	pop    %esi
  803609:	5f                   	pop    %edi
  80360a:	5d                   	pop    %ebp
  80360b:	c3                   	ret    
  80360c:	3b 04 24             	cmp    (%esp),%eax
  80360f:	72 06                	jb     803617 <__umoddi3+0x113>
  803611:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803615:	77 0f                	ja     803626 <__umoddi3+0x122>
  803617:	89 f2                	mov    %esi,%edx
  803619:	29 f9                	sub    %edi,%ecx
  80361b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80361f:	89 14 24             	mov    %edx,(%esp)
  803622:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803626:	8b 44 24 04          	mov    0x4(%esp),%eax
  80362a:	8b 14 24             	mov    (%esp),%edx
  80362d:	83 c4 1c             	add    $0x1c,%esp
  803630:	5b                   	pop    %ebx
  803631:	5e                   	pop    %esi
  803632:	5f                   	pop    %edi
  803633:	5d                   	pop    %ebp
  803634:	c3                   	ret    
  803635:	8d 76 00             	lea    0x0(%esi),%esi
  803638:	2b 04 24             	sub    (%esp),%eax
  80363b:	19 fa                	sbb    %edi,%edx
  80363d:	89 d1                	mov    %edx,%ecx
  80363f:	89 c6                	mov    %eax,%esi
  803641:	e9 71 ff ff ff       	jmp    8035b7 <__umoddi3+0xb3>
  803646:	66 90                	xchg   %ax,%ax
  803648:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80364c:	72 ea                	jb     803638 <__umoddi3+0x134>
  80364e:	89 d9                	mov    %ebx,%ecx
  803650:	e9 62 ff ff ff       	jmp    8035b7 <__umoddi3+0xb3>
