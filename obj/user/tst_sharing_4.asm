
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 41 05 00 00       	call   800577 <libmain>
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
  80008d:	68 40 36 80 00       	push   $0x803640
  800092:	6a 12                	push   $0x12
  800094:	68 5c 36 80 00       	push   $0x80365c
  800099:	e8 15 06 00 00       	call   8006b3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 38 18 00 00       	call   8018e0 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 74 36 80 00       	push   $0x803674
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 a8 36 80 00       	push   $0x8036a8
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 04 37 80 00       	push   $0x803704
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 f8 1e 00 00       	call   801fe6 <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 38 37 80 00       	push   $0x803738
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 19 1c 00 00       	call   801d1f <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 67 37 80 00       	push   $0x803767
  800118:	e8 3f 19 00 00       	call   801a5c <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 6c 37 80 00       	push   $0x80376c
  800134:	6a 24                	push   $0x24
  800136:	68 5c 36 80 00       	push   $0x80365c
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 d7 1b 00 00       	call   801d1f <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 d8 37 80 00       	push   $0x8037d8
  800159:	6a 25                	push   $0x25
  80015b:	68 5c 36 80 00       	push   $0x80365c
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 4f 1a 00 00       	call   801bbf <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 a4 1b 00 00       	call   801d1f <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 58 38 80 00       	push   $0x803858
  80018c:	6a 28                	push   $0x28
  80018e:	68 5c 36 80 00       	push   $0x80365c
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 82 1b 00 00       	call   801d1f <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 b0 38 80 00       	push   $0x8038b0
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 5c 36 80 00       	push   $0x80365c
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 e0 38 80 00       	push   $0x8038e0
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 04 39 80 00       	push   $0x803904
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 40 1b 00 00       	call   801d1f <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 34 39 80 00       	push   $0x803934
  8001f1:	e8 66 18 00 00       	call   801a5c <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 67 37 80 00       	push   $0x803767
  80020b:	e8 4c 18 00 00       	call   801a5c <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 58 38 80 00       	push   $0x803858
  800224:	6a 35                	push   $0x35
  800226:	68 5c 36 80 00       	push   $0x80365c
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 e7 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 38 39 80 00       	push   $0x803938
  800249:	6a 37                	push   $0x37
  80024b:	68 5c 36 80 00       	push   $0x80365c
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 5f 19 00 00       	call   801bbf <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 b4 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 8d 39 80 00       	push   $0x80398d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 5c 36 80 00       	push   $0x80365c
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 2c 19 00 00       	call   801bbf <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 84 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 8d 39 80 00       	push   $0x80398d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 5c 36 80 00       	push   $0x80365c
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 ac 39 80 00       	push   $0x8039ac
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 d0 39 80 00       	push   $0x8039d0
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 42 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 00 3a 80 00       	push   $0x803a00
  8002ef:	e8 68 17 00 00       	call   801a5c <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 02 3a 80 00       	push   $0x803a02
  800309:	e8 4e 17 00 00       	call   801a5c <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 03 1a 00 00       	call   801d1f <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 d8 37 80 00       	push   $0x8037d8
  80032d:	6a 48                	push   $0x48
  80032f:	68 5c 36 80 00       	push   $0x80365c
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 7b 18 00 00       	call   801bbf <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 d0 19 00 00       	call   801d1f <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 8d 39 80 00       	push   $0x80398d
  800360:	6a 4b                	push   $0x4b
  800362:	68 5c 36 80 00       	push   $0x80365c
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 04 3a 80 00       	push   $0x803a04
  80037b:	e8 dc 16 00 00       	call   801a5c <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 06 3a 80 00       	push   $0x803a06
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 81 19 00 00       	call   801d1f <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 d8 37 80 00       	push   $0x8037d8
  8003af:	6a 52                	push   $0x52
  8003b1:	68 5c 36 80 00       	push   $0x80365c
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 f9 17 00 00       	call   801bbf <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 4e 19 00 00       	call   801d1f <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 8d 39 80 00       	push   $0x80398d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 5c 36 80 00       	push   $0x80365c
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 c6 17 00 00       	call   801bbf <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 1e 19 00 00       	call   801d1f <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 8d 39 80 00       	push   $0x80398d
  800412:	6a 58                	push   $0x58
  800414:	68 5c 36 80 00       	push   $0x80365c
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 fc 18 00 00       	call   801d1f <sys_calculate_free_frames>
  800423:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800429:	89 c2                	mov    %eax,%edx
  80042b:	01 d2                	add    %edx,%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800432:	83 ec 04             	sub    $0x4,%esp
  800435:	6a 01                	push   $0x1
  800437:	50                   	push   %eax
  800438:	68 00 3a 80 00       	push   $0x803a00
  80043d:	e8 1a 16 00 00       	call   801a5c <smalloc>
  800442:	83 c4 10             	add    $0x10,%esp
  800445:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800448:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	6a 01                	push   $0x1
  80045d:	50                   	push   %eax
  80045e:	68 02 3a 80 00       	push   $0x803a02
  800463:	e8 f4 15 00 00       	call   801a5c <smalloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 c0                	add    %eax,%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	6a 01                	push   $0x1
  80047f:	50                   	push   %eax
  800480:	68 04 3a 80 00       	push   $0x803a04
  800485:	e8 d2 15 00 00       	call   801a5c <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 87 18 00 00       	call   801d1f <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 d8 37 80 00       	push   $0x8037d8
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 5c 36 80 00       	push   $0x80365c
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 fd 16 00 00       	call   801bbf <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 52 18 00 00       	call   801d1f <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 8d 39 80 00       	push   $0x80398d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 5c 36 80 00       	push   $0x80365c
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 c8 16 00 00       	call   801bbf <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 1d 18 00 00       	call   801d1f <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 8d 39 80 00       	push   $0x80398d
  800515:	6a 67                	push   $0x67
  800517:	68 5c 36 80 00       	push   $0x80365c
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 93 16 00 00       	call   801bbf <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 eb 17 00 00       	call   801d1f <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 8d 39 80 00       	push   $0x80398d
  800545:	6a 6a                	push   $0x6a
  800547:	68 5c 36 80 00       	push   $0x80365c
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 0c 3a 80 00       	push   $0x803a0c
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 30 3a 80 00       	push   $0x803a30
  800569:	e8 f9 03 00 00       	call   800967 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp

	return;
  800571:	90                   	nop
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80057d:	e8 7d 1a 00 00       	call   801fff <sys_getenvindex>
  800582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	c1 e0 03             	shl    $0x3,%eax
  80058d:	01 d0                	add    %edx,%eax
  80058f:	01 c0                	add    %eax,%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 04             	shl    $0x4,%eax
  80059f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005a4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ae:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005b4:	84 c0                	test   %al,%al
  8005b6:	74 0f                	je     8005c7 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bd:	05 5c 05 00 00       	add    $0x55c,%eax
  8005c2:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cb:	7e 0a                	jle    8005d7 <libmain+0x60>
		binaryname = argv[0];
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	ff 75 0c             	pushl  0xc(%ebp)
  8005dd:	ff 75 08             	pushl  0x8(%ebp)
  8005e0:	e8 53 fa ff ff       	call   800038 <_main>
  8005e5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005e8:	e8 1f 18 00 00       	call   801e0c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 94 3a 80 00       	push   $0x803a94
  8005f5:	e8 6d 03 00 00       	call   800967 <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800602:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800608:	a1 20 50 80 00       	mov    0x805020,%eax
  80060d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	68 bc 3a 80 00       	push   $0x803abc
  80061d:	e8 45 03 00 00       	call   800967 <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800630:	a1 20 50 80 00       	mov    0x805020,%eax
  800635:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80063b:	a1 20 50 80 00       	mov    0x805020,%eax
  800640:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800646:	51                   	push   %ecx
  800647:	52                   	push   %edx
  800648:	50                   	push   %eax
  800649:	68 e4 3a 80 00       	push   $0x803ae4
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 3c 3b 80 00       	push   $0x803b3c
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 94 3a 80 00       	push   $0x803a94
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 9f 17 00 00       	call   801e26 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800687:	e8 19 00 00 00       	call   8006a5 <exit>
}
  80068c:	90                   	nop
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	6a 00                	push   $0x0
  80069a:	e8 2c 19 00 00       	call   801fcb <sys_destroy_env>
  80069f:	83 c4 10             	add    $0x10,%esp
}
  8006a2:	90                   	nop
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <exit>:

void
exit(void)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006ab:	e8 81 19 00 00       	call   802031 <sys_exit_env>
}
  8006b0:	90                   	nop
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8006bc:	83 c0 04             	add    $0x4,%eax
  8006bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	74 16                	je     8006e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	50                   	push   %eax
  8006d4:	68 50 3b 80 00       	push   $0x803b50
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 55 3b 80 00       	push   $0x803b55
  8006f2:	e8 70 02 00 00       	call   800967 <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 f3 01 00 00       	call   8008fc <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	6a 00                	push   $0x0
  800711:	68 71 3b 80 00       	push   $0x803b71
  800716:	e8 e1 01 00 00       	call   8008fc <vcprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80071e:	e8 82 ff ff ff       	call   8006a5 <exit>

	// should not return here
	while (1) ;
  800723:	eb fe                	jmp    800723 <_panic+0x70>

00800725 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80072b:	a1 20 50 80 00       	mov    0x805020,%eax
  800730:	8b 50 74             	mov    0x74(%eax),%edx
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	39 c2                	cmp    %eax,%edx
  800738:	74 14                	je     80074e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	68 74 3b 80 00       	push   $0x803b74
  800742:	6a 26                	push   $0x26
  800744:	68 c0 3b 80 00       	push   $0x803bc0
  800749:	e8 65 ff ff ff       	call   8006b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80074e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80075c:	e9 c2 00 00 00       	jmp    800823 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	01 d0                	add    %edx,%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	85 c0                	test   %eax,%eax
  800774:	75 08                	jne    80077e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800776:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800779:	e9 a2 00 00 00       	jmp    800820 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80077e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800785:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80078c:	eb 69                	jmp    8007f7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80078e:	a1 20 50 80 00       	mov    0x805020,%eax
  800793:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80079c:	89 d0                	mov    %edx,%eax
  80079e:	01 c0                	add    %eax,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	c1 e0 03             	shl    $0x3,%eax
  8007a5:	01 c8                	add    %ecx,%eax
  8007a7:	8a 40 04             	mov    0x4(%eax),%al
  8007aa:	84 c0                	test   %al,%al
  8007ac:	75 46                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8007b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	01 c0                	add    %eax,%eax
  8007c0:	01 d0                	add    %edx,%eax
  8007c2:	c1 e0 03             	shl    $0x3,%eax
  8007c5:	01 c8                	add    %ecx,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	01 c8                	add    %ecx,%eax
  8007e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007e7:	39 c2                	cmp    %eax,%edx
  8007e9:	75 09                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8007eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007f2:	eb 12                	jmp    800806 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f4:	ff 45 e8             	incl   -0x18(%ebp)
  8007f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fc:	8b 50 74             	mov    0x74(%eax),%edx
  8007ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800802:	39 c2                	cmp    %eax,%edx
  800804:	77 88                	ja     80078e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800806:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80080a:	75 14                	jne    800820 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 cc 3b 80 00       	push   $0x803bcc
  800814:	6a 3a                	push   $0x3a
  800816:	68 c0 3b 80 00       	push   $0x803bc0
  80081b:	e8 93 fe ff ff       	call   8006b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800820:	ff 45 f0             	incl   -0x10(%ebp)
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800829:	0f 8c 32 ff ff ff    	jl     800761 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80082f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80083d:	eb 26                	jmp    800865 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80083f:	a1 20 50 80 00       	mov    0x805020,%eax
  800844:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80084a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084d:	89 d0                	mov    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c1 e0 03             	shl    $0x3,%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8a 40 04             	mov    0x4(%eax),%al
  80085b:	3c 01                	cmp    $0x1,%al
  80085d:	75 03                	jne    800862 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80085f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800862:	ff 45 e0             	incl   -0x20(%ebp)
  800865:	a1 20 50 80 00       	mov    0x805020,%eax
  80086a:	8b 50 74             	mov    0x74(%eax),%edx
  80086d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800870:	39 c2                	cmp    %eax,%edx
  800872:	77 cb                	ja     80083f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80087a:	74 14                	je     800890 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80087c:	83 ec 04             	sub    $0x4,%esp
  80087f:	68 20 3c 80 00       	push   $0x803c20
  800884:	6a 44                	push   $0x44
  800886:	68 c0 3b 80 00       	push   $0x803bc0
  80088b:	e8 23 fe ff ff       	call   8006b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800890:	90                   	nop
  800891:	c9                   	leave  
  800892:	c3                   	ret    

00800893 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 0a                	mov    %ecx,(%edx)
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a9:	88 d1                	mov    %dl,%cl
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008bc:	75 2c                	jne    8008ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008be:	a0 24 50 80 00       	mov    0x805024,%al
  8008c3:	0f b6 c0             	movzbl %al,%eax
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c9:	8b 12                	mov    (%edx),%edx
  8008cb:	89 d1                	mov    %edx,%ecx
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	83 c2 08             	add    $0x8,%edx
  8008d3:	83 ec 04             	sub    $0x4,%esp
  8008d6:	50                   	push   %eax
  8008d7:	51                   	push   %ecx
  8008d8:	52                   	push   %edx
  8008d9:	e8 80 13 00 00       	call   801c5e <sys_cputs>
  8008de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8b 40 04             	mov    0x4(%eax),%eax
  8008f0:	8d 50 01             	lea    0x1(%eax),%edx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800905:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80090c:	00 00 00 
	b.cnt = 0;
  80090f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800916:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800925:	50                   	push   %eax
  800926:	68 93 08 80 00       	push   $0x800893
  80092b:	e8 11 02 00 00       	call   800b41 <vprintfmt>
  800930:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800933:	a0 24 50 80 00       	mov    0x805024,%al
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800941:	83 ec 04             	sub    $0x4,%esp
  800944:	50                   	push   %eax
  800945:	52                   	push   %edx
  800946:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80094c:	83 c0 08             	add    $0x8,%eax
  80094f:	50                   	push   %eax
  800950:	e8 09 13 00 00       	call   801c5e <sys_cputs>
  800955:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800958:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80095f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <cprintf>:

int cprintf(const char *fmt, ...) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80096d:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800974:	8d 45 0c             	lea    0xc(%ebp),%eax
  800977:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 73 ff ff ff       	call   8008fc <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80099a:	e8 6d 14 00 00       	call   801e0c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80099f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	e8 48 ff ff ff       	call   8008fc <vcprintf>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009ba:	e8 67 14 00 00       	call   801e26 <sys_enable_interrupt>
	return cnt;
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	83 ec 14             	sub    $0x14,%esp
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e2:	77 55                	ja     800a39 <printnum+0x75>
  8009e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e7:	72 05                	jb     8009ee <printnum+0x2a>
  8009e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ec:	77 4b                	ja     800a39 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fc:	52                   	push   %edx
  8009fd:	50                   	push   %eax
  8009fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800a01:	ff 75 f0             	pushl  -0x10(%ebp)
  800a04:	e8 cf 29 00 00       	call   8033d8 <__udivdi3>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	ff 75 20             	pushl  0x20(%ebp)
  800a12:	53                   	push   %ebx
  800a13:	ff 75 18             	pushl  0x18(%ebp)
  800a16:	52                   	push   %edx
  800a17:	50                   	push   %eax
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	ff 75 08             	pushl  0x8(%ebp)
  800a1e:	e8 a1 ff ff ff       	call   8009c4 <printnum>
  800a23:	83 c4 20             	add    $0x20,%esp
  800a26:	eb 1a                	jmp    800a42 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	ff 75 20             	pushl  0x20(%ebp)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a39:	ff 4d 1c             	decl   0x1c(%ebp)
  800a3c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a40:	7f e6                	jg     800a28 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a42:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a50:	53                   	push   %ebx
  800a51:	51                   	push   %ecx
  800a52:	52                   	push   %edx
  800a53:	50                   	push   %eax
  800a54:	e8 8f 2a 00 00       	call   8034e8 <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 94 3e 80 00       	add    $0x803e94,%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	0f be c0             	movsbl %al,%eax
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	50                   	push   %eax
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
}
  800a75:	90                   	nop
  800a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a82:	7e 1c                	jle    800aa0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 08             	lea    0x8(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 08             	sub    $0x8,%eax
  800a99:	8b 50 04             	mov    0x4(%eax),%edx
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	eb 40                	jmp    800ae0 <getuint+0x65>
	else if (lflag)
  800aa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa4:	74 1e                	je     800ac4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	8d 50 04             	lea    0x4(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	89 10                	mov    %edx,(%eax)
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	eb 1c                	jmp    800ae0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	8d 50 04             	lea    0x4(%eax),%edx
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 10                	mov    %edx,(%eax)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	83 e8 04             	sub    $0x4,%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ae9:	7e 1c                	jle    800b07 <getint+0x25>
		return va_arg(*ap, long long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 08             	lea    0x8(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 08             	sub    $0x8,%eax
  800b00:	8b 50 04             	mov    0x4(%eax),%edx
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	eb 38                	jmp    800b3f <getint+0x5d>
	else if (lflag)
  800b07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0b:	74 1a                	je     800b27 <getint+0x45>
		return va_arg(*ap, long);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	8d 50 04             	lea    0x4(%eax),%edx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 10                	mov    %edx,(%eax)
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	99                   	cltd   
  800b25:	eb 18                	jmp    800b3f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	8d 50 04             	lea    0x4(%eax),%edx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 10                	mov    %edx,(%eax)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	83 e8 04             	sub    $0x4,%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	99                   	cltd   
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
  800b46:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b49:	eb 17                	jmp    800b62 <vprintfmt+0x21>
			if (ch == '\0')
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	0f 84 af 03 00 00    	je     800f02 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	53                   	push   %ebx
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	8d 50 01             	lea    0x1(%eax),%edx
  800b68:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	0f b6 d8             	movzbl %al,%ebx
  800b70:	83 fb 25             	cmp    $0x25,%ebx
  800b73:	75 d6                	jne    800b4b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b75:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b79:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b8e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	8d 50 01             	lea    0x1(%eax),%edx
  800b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f b6 d8             	movzbl %al,%ebx
  800ba3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ba6:	83 f8 55             	cmp    $0x55,%eax
  800ba9:	0f 87 2b 03 00 00    	ja     800eda <vprintfmt+0x399>
  800baf:	8b 04 85 b8 3e 80 00 	mov    0x803eb8(,%eax,4),%eax
  800bb6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bb8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bbc:	eb d7                	jmp    800b95 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bbe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bc2:	eb d1                	jmp    800b95 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	c1 e0 02             	shl    $0x2,%eax
  800bd3:	01 d0                	add    %edx,%eax
  800bd5:	01 c0                	add    %eax,%eax
  800bd7:	01 d8                	add    %ebx,%eax
  800bd9:	83 e8 30             	sub    $0x30,%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800be7:	83 fb 2f             	cmp    $0x2f,%ebx
  800bea:	7e 3e                	jle    800c2a <vprintfmt+0xe9>
  800bec:	83 fb 39             	cmp    $0x39,%ebx
  800bef:	7f 39                	jg     800c2a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf4:	eb d5                	jmp    800bcb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf9:	83 c0 04             	add    $0x4,%eax
  800bfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bff:	8b 45 14             	mov    0x14(%ebp),%eax
  800c02:	83 e8 04             	sub    $0x4,%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c0a:	eb 1f                	jmp    800c2b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	79 83                	jns    800b95 <vprintfmt+0x54>
				width = 0;
  800c12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c19:	e9 77 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c1e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c25:	e9 6b ff ff ff       	jmp    800b95 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c2a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2f:	0f 89 60 ff ff ff    	jns    800b95 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c42:	e9 4e ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c47:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c4a:	e9 46 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	83 e8 04             	sub    $0x4,%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			break;
  800c6f:	e9 89 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 e8 04             	sub    $0x4,%eax
  800c83:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c85:	85 db                	test   %ebx,%ebx
  800c87:	79 02                	jns    800c8b <vprintfmt+0x14a>
				err = -err;
  800c89:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c8b:	83 fb 64             	cmp    $0x64,%ebx
  800c8e:	7f 0b                	jg     800c9b <vprintfmt+0x15a>
  800c90:	8b 34 9d 00 3d 80 00 	mov    0x803d00(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 a5 3e 80 00       	push   $0x803ea5
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 5e 02 00 00       	call   800f0a <printfmt>
  800cac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800caf:	e9 49 02 00 00       	jmp    800efd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cb4:	56                   	push   %esi
  800cb5:	68 ae 3e 80 00       	push   $0x803eae
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	e8 45 02 00 00       	call   800f0a <printfmt>
  800cc5:	83 c4 10             	add    $0x10,%esp
			break;
  800cc8:	e9 30 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 c0 04             	add    $0x4,%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 e8 04             	sub    $0x4,%eax
  800cdc:	8b 30                	mov    (%eax),%esi
  800cde:	85 f6                	test   %esi,%esi
  800ce0:	75 05                	jne    800ce7 <vprintfmt+0x1a6>
				p = "(null)";
  800ce2:	be b1 3e 80 00       	mov    $0x803eb1,%esi
			if (width > 0 && padc != '-')
  800ce7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ceb:	7e 6d                	jle    800d5a <vprintfmt+0x219>
  800ced:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cf1:	74 67                	je     800d5a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	50                   	push   %eax
  800cfa:	56                   	push   %esi
  800cfb:	e8 0c 03 00 00       	call   80100c <strnlen>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d06:	eb 16                	jmp    800d1e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d08:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	50                   	push   %eax
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d22:	7f e4                	jg     800d08 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d24:	eb 34                	jmp    800d5a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d26:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d2a:	74 1c                	je     800d48 <vprintfmt+0x207>
  800d2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2f:	7e 05                	jle    800d36 <vprintfmt+0x1f5>
  800d31:	83 fb 7e             	cmp    $0x7e,%ebx
  800d34:	7e 12                	jle    800d48 <vprintfmt+0x207>
					putch('?', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 3f                	push   $0x3f
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	eb 0f                	jmp    800d57 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	53                   	push   %ebx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d57:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5a:	89 f0                	mov    %esi,%eax
  800d5c:	8d 70 01             	lea    0x1(%eax),%esi
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be d8             	movsbl %al,%ebx
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	74 24                	je     800d8c <vprintfmt+0x24b>
  800d68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d6c:	78 b8                	js     800d26 <vprintfmt+0x1e5>
  800d6e:	ff 4d e0             	decl   -0x20(%ebp)
  800d71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d75:	79 af                	jns    800d26 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d77:	eb 13                	jmp    800d8c <vprintfmt+0x24b>
				putch(' ', putdat);
  800d79:	83 ec 08             	sub    $0x8,%esp
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	6a 20                	push   $0x20
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	ff d0                	call   *%eax
  800d86:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d89:	ff 4d e4             	decl   -0x1c(%ebp)
  800d8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d90:	7f e7                	jg     800d79 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d92:	e9 66 01 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	e8 3c fd ff ff       	call   800ae2 <getint>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db5:	85 d2                	test   %edx,%edx
  800db7:	79 23                	jns    800ddc <vprintfmt+0x29b>
				putch('-', putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	6a 2d                	push   $0x2d
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcf:	f7 d8                	neg    %eax
  800dd1:	83 d2 00             	adc    $0x0,%edx
  800dd4:	f7 da                	neg    %edx
  800dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ddc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de3:	e9 bc 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 e8             	pushl  -0x18(%ebp)
  800dee:	8d 45 14             	lea    0x14(%ebp),%eax
  800df1:	50                   	push   %eax
  800df2:	e8 84 fc ff ff       	call   800a7b <getuint>
  800df7:	83 c4 10             	add    $0x10,%esp
  800dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e00:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e07:	e9 98 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	6a 58                	push   $0x58
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	ff d0                	call   *%eax
  800e19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	6a 58                	push   $0x58
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 58                	push   $0x58
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
			break;
  800e3c:	e9 bc 00 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 30                	push   $0x30
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	6a 78                	push   $0x78
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	83 c0 04             	add    $0x4,%eax
  800e67:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6d:	83 e8 04             	sub    $0x4,%eax
  800e70:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e83:	eb 1f                	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8e:	50                   	push   %eax
  800e8f:	e8 e7 fb ff ff       	call   800a7b <getuint>
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	52                   	push   %edx
  800eaf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eb2:	50                   	push   %eax
  800eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 00 fb ff ff       	call   8009c4 <printnum>
  800ec4:	83 c4 20             	add    $0x20,%esp
			break;
  800ec7:	eb 34                	jmp    800efd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	53                   	push   %ebx
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
			break;
  800ed8:	eb 23                	jmp    800efd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 25                	push   $0x25
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eea:	ff 4d 10             	decl   0x10(%ebp)
  800eed:	eb 03                	jmp    800ef2 <vprintfmt+0x3b1>
  800eef:	ff 4d 10             	decl   0x10(%ebp)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	48                   	dec    %eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 25                	cmp    $0x25,%al
  800efa:	75 f3                	jne    800eef <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800efc:	90                   	nop
		}
	}
  800efd:	e9 47 fc ff ff       	jmp    800b49 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f10:	8d 45 10             	lea    0x10(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1f:	50                   	push   %eax
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	ff 75 08             	pushl  0x8(%ebp)
  800f26:	e8 16 fc ff ff       	call   800b41 <vprintfmt>
  800f2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f2e:	90                   	nop
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8b 40 08             	mov    0x8(%eax),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8b 10                	mov    (%eax),%edx
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 40 04             	mov    0x4(%eax),%eax
  800f4e:	39 c2                	cmp    %eax,%edx
  800f50:	73 12                	jae    800f64 <sprintputch+0x33>
		*b->buf++ = ch;
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	8d 48 01             	lea    0x1(%eax),%ecx
  800f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5d:	89 0a                	mov    %ecx,(%edx)
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	88 10                	mov    %dl,(%eax)
}
  800f64:	90                   	nop
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	01 d0                	add    %edx,%eax
  800f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8c:	74 06                	je     800f94 <vsnprintf+0x2d>
  800f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f92:	7f 07                	jg     800f9b <vsnprintf+0x34>
		return -E_INVAL;
  800f94:	b8 03 00 00 00       	mov    $0x3,%eax
  800f99:	eb 20                	jmp    800fbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9b:	ff 75 14             	pushl  0x14(%ebp)
  800f9e:	ff 75 10             	pushl  0x10(%ebp)
  800fa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa4:	50                   	push   %eax
  800fa5:	68 31 0f 80 00       	push   $0x800f31
  800faa:	e8 92 fb ff ff       	call   800b41 <vprintfmt>
  800faf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd2:	50                   	push   %eax
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 89 ff ff ff       	call   800f67 <vsnprintf>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff6:	eb 06                	jmp    800ffe <strlen+0x15>
		n++;
  800ff8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffb:	ff 45 08             	incl   0x8(%ebp)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	75 f1                	jne    800ff8 <strlen+0xf>
		n++;
	return n;
  801007:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801019:	eb 09                	jmp    801024 <strnlen+0x18>
		n++;
  80101b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	ff 4d 0c             	decl   0xc(%ebp)
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	74 09                	je     801033 <strnlen+0x27>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 e8                	jne    80101b <strnlen+0xf>
		n++;
	return n;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801044:	90                   	nop
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 08             	mov    %edx,0x8(%ebp)
  80104e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e4                	jne    801045 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 1f                	jmp    80109a <strncpy+0x34>
		*dst++ = *src;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8d 50 01             	lea    0x1(%eax),%edx
  801081:	89 55 08             	mov    %edx,0x8(%ebp)
  801084:	8b 55 0c             	mov    0xc(%ebp),%edx
  801087:	8a 12                	mov    (%edx),%dl
  801089:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	84 c0                	test   %al,%al
  801092:	74 03                	je     801097 <strncpy+0x31>
			src++;
  801094:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801097:	ff 45 fc             	incl   -0x4(%ebp)
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a0:	72 d9                	jb     80107b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	74 30                	je     8010e9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010b9:	eb 16                	jmp    8010d1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8d 50 01             	lea    0x1(%eax),%edx
  8010c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cd:	8a 12                	mov    (%edx),%dl
  8010cf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d1:	ff 4d 10             	decl   0x10(%ebp)
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	74 09                	je     8010e3 <strlcpy+0x3c>
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	75 d8                	jne    8010bb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f8:	eb 06                	jmp    801100 <strcmp+0xb>
		p++, q++;
  8010fa:	ff 45 08             	incl   0x8(%ebp)
  8010fd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	74 0e                	je     801117 <strcmp+0x22>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 10                	mov    (%eax),%dl
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	38 c2                	cmp    %al,%dl
  801115:	74 e3                	je     8010fa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f b6 d0             	movzbl %al,%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 c0             	movzbl %al,%eax
  801127:	29 c2                	sub    %eax,%edx
  801129:	89 d0                	mov    %edx,%eax
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801130:	eb 09                	jmp    80113b <strncmp+0xe>
		n--, p++, q++;
  801132:	ff 4d 10             	decl   0x10(%ebp)
  801135:	ff 45 08             	incl   0x8(%ebp)
  801138:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	74 17                	je     801158 <strncmp+0x2b>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 0e                	je     801158 <strncmp+0x2b>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 10                	mov    (%eax),%dl
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	38 c2                	cmp    %al,%dl
  801156:	74 da                	je     801132 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115c:	75 07                	jne    801165 <strncmp+0x38>
		return 0;
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	eb 14                	jmp    801179 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f b6 d0             	movzbl %al,%edx
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 c0             	movzbl %al,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
}
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801187:	eb 12                	jmp    80119b <strchr+0x20>
		if (*s == c)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801191:	75 05                	jne    801198 <strchr+0x1d>
			return (char *) s;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	eb 11                	jmp    8011a9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	75 e5                	jne    801189 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b7:	eb 0d                	jmp    8011c6 <strfind+0x1b>
		if (*s == c)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c1:	74 0e                	je     8011d1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c3:	ff 45 08             	incl   0x8(%ebp)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	84 c0                	test   %al,%al
  8011cd:	75 ea                	jne    8011b9 <strfind+0xe>
  8011cf:	eb 01                	jmp    8011d2 <strfind+0x27>
		if (*s == c)
			break;
  8011d1:	90                   	nop
	return (char *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011e9:	eb 0e                	jmp    8011f9 <memset+0x22>
		*p++ = c;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011f9:	ff 4d f8             	decl   -0x8(%ebp)
  8011fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801200:	79 e9                	jns    8011eb <memset+0x14>
		*p++ = c;

	return v;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801219:	eb 16                	jmp    801231 <memcpy+0x2a>
		*d++ = *s++;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80122a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80122d:	8a 12                	mov    (%edx),%dl
  80122f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	8d 50 ff             	lea    -0x1(%eax),%edx
  801237:	89 55 10             	mov    %edx,0x10(%ebp)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 dd                	jne    80121b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125b:	73 50                	jae    8012ad <memmove+0x6a>
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801268:	76 43                	jbe    8012ad <memmove+0x6a>
		s += n;
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801276:	eb 10                	jmp    801288 <memmove+0x45>
			*--d = *--s;
  801278:	ff 4d f8             	decl   -0x8(%ebp)
  80127b:	ff 4d fc             	decl   -0x4(%ebp)
  80127e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801281:	8a 10                	mov    (%eax),%dl
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128e:	89 55 10             	mov    %edx,0x10(%ebp)
  801291:	85 c0                	test   %eax,%eax
  801293:	75 e3                	jne    801278 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801295:	eb 23                	jmp    8012ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a9:	8a 12                	mov    (%edx),%dl
  8012ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	75 dd                	jne    801297 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d1:	eb 2a                	jmp    8012fd <memcmp+0x3e>
		if (*s1 != *s2)
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8a 10                	mov    (%eax),%dl
  8012d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 16                	je     8012f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f b6 d0             	movzbl %al,%edx
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	0f b6 c0             	movzbl %al,%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	eb 18                	jmp    80130f <memcmp+0x50>
		s1++, s2++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
  8012fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	8d 50 ff             	lea    -0x1(%eax),%edx
  801303:	89 55 10             	mov    %edx,0x10(%ebp)
  801306:	85 c0                	test   %eax,%eax
  801308:	75 c9                	jne    8012d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801317:	8b 55 08             	mov    0x8(%ebp),%edx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801322:	eb 15                	jmp    801339 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f b6 d0             	movzbl %al,%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	0f b6 c0             	movzbl %al,%eax
  801332:	39 c2                	cmp    %eax,%edx
  801334:	74 0d                	je     801343 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80133f:	72 e3                	jb     801324 <memfind+0x13>
  801341:	eb 01                	jmp    801344 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801343:	90                   	nop
	return (void *) s;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80134f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801356:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135d:	eb 03                	jmp    801362 <strtol+0x19>
		s++;
  80135f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 20                	cmp    $0x20,%al
  801369:	74 f4                	je     80135f <strtol+0x16>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	3c 09                	cmp    $0x9,%al
  801372:	74 eb                	je     80135f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	3c 2b                	cmp    $0x2b,%al
  80137b:	75 05                	jne    801382 <strtol+0x39>
		s++;
  80137d:	ff 45 08             	incl   0x8(%ebp)
  801380:	eb 13                	jmp    801395 <strtol+0x4c>
	else if (*s == '-')
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	3c 2d                	cmp    $0x2d,%al
  801389:	75 0a                	jne    801395 <strtol+0x4c>
		s++, neg = 1;
  80138b:	ff 45 08             	incl   0x8(%ebp)
  80138e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801399:	74 06                	je     8013a1 <strtol+0x58>
  80139b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80139f:	75 20                	jne    8013c1 <strtol+0x78>
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	3c 30                	cmp    $0x30,%al
  8013a8:	75 17                	jne    8013c1 <strtol+0x78>
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	40                   	inc    %eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3c 78                	cmp    $0x78,%al
  8013b2:	75 0d                	jne    8013c1 <strtol+0x78>
		s += 2, base = 16;
  8013b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013bf:	eb 28                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c5:	75 15                	jne    8013dc <strtol+0x93>
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 30                	cmp    $0x30,%al
  8013ce:	75 0c                	jne    8013dc <strtol+0x93>
		s++, base = 8;
  8013d0:	ff 45 08             	incl   0x8(%ebp)
  8013d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013da:	eb 0d                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0)
  8013dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e0:	75 07                	jne    8013e9 <strtol+0xa0>
		base = 10;
  8013e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 2f                	cmp    $0x2f,%al
  8013f0:	7e 19                	jle    80140b <strtol+0xc2>
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 39                	cmp    $0x39,%al
  8013f9:	7f 10                	jg     80140b <strtol+0xc2>
			dig = *s - '0';
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	83 e8 30             	sub    $0x30,%eax
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801409:	eb 42                	jmp    80144d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	3c 60                	cmp    $0x60,%al
  801412:	7e 19                	jle    80142d <strtol+0xe4>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	3c 7a                	cmp    $0x7a,%al
  80141b:	7f 10                	jg     80142d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f be c0             	movsbl %al,%eax
  801425:	83 e8 57             	sub    $0x57,%eax
  801428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80142b:	eb 20                	jmp    80144d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	3c 40                	cmp    $0x40,%al
  801434:	7e 39                	jle    80146f <strtol+0x126>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3c 5a                	cmp    $0x5a,%al
  80143d:	7f 30                	jg     80146f <strtol+0x126>
			dig = *s - 'A' + 10;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	0f be c0             	movsbl %al,%eax
  801447:	83 e8 37             	sub    $0x37,%eax
  80144a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	3b 45 10             	cmp    0x10(%ebp),%eax
  801453:	7d 19                	jge    80146e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801455:	ff 45 08             	incl   0x8(%ebp)
  801458:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80145f:	89 c2                	mov    %eax,%edx
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801469:	e9 7b ff ff ff       	jmp    8013e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80146e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80146f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801473:	74 08                	je     80147d <strtol+0x134>
		*endptr = (char *) s;
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80147d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801481:	74 07                	je     80148a <strtol+0x141>
  801483:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801486:	f7 d8                	neg    %eax
  801488:	eb 03                	jmp    80148d <strtol+0x144>
  80148a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <ltostr>:

void
ltostr(long value, char *str)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80149c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	79 13                	jns    8014bc <ltostr+0x2d>
	{
		neg = 1;
  8014a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c4:	99                   	cltd   
  8014c5:	f7 f9                	idiv   %ecx
  8014c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d3:	89 c2                	mov    %eax,%edx
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	01 d0                	add    %edx,%eax
  8014da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014dd:	83 c2 30             	add    $0x30,%edx
  8014e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014ea:	f7 e9                	imul   %ecx
  8014ec:	c1 fa 02             	sar    $0x2,%edx
  8014ef:	89 c8                	mov    %ecx,%eax
  8014f1:	c1 f8 1f             	sar    $0x1f,%eax
  8014f4:	29 c2                	sub    %eax,%edx
  8014f6:	89 d0                	mov    %edx,%eax
  8014f8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801503:	f7 e9                	imul   %ecx
  801505:	c1 fa 02             	sar    $0x2,%edx
  801508:	89 c8                	mov    %ecx,%eax
  80150a:	c1 f8 1f             	sar    $0x1f,%eax
  80150d:	29 c2                	sub    %eax,%edx
  80150f:	89 d0                	mov    %edx,%eax
  801511:	c1 e0 02             	shl    $0x2,%eax
  801514:	01 d0                	add    %edx,%eax
  801516:	01 c0                	add    %eax,%eax
  801518:	29 c1                	sub    %eax,%ecx
  80151a:	89 ca                	mov    %ecx,%edx
  80151c:	85 d2                	test   %edx,%edx
  80151e:	75 9c                	jne    8014bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801527:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152a:	48                   	dec    %eax
  80152b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80152e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801532:	74 3d                	je     801571 <ltostr+0xe2>
		start = 1 ;
  801534:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80153b:	eb 34                	jmp    801571 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80153d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 c2                	add    %eax,%edx
  801552:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	01 c8                	add    %ecx,%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80155e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	01 c2                	add    %eax,%edx
  801566:	8a 45 eb             	mov    -0x15(%ebp),%al
  801569:	88 02                	mov    %al,(%edx)
		start++ ;
  80156b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80156e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801577:	7c c4                	jl     80153d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801579:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801584:	90                   	nop
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 54 fa ff ff       	call   800fe9 <strlen>
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	e8 46 fa ff ff       	call   800fe9 <strlen>
  8015a3:	83 c4 04             	add    $0x4,%esp
  8015a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b7:	eb 17                	jmp    8015d0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	01 c2                	add    %eax,%edx
  8015c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	01 c8                	add    %ecx,%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015cd:	ff 45 fc             	incl   -0x4(%ebp)
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015d6:	7c e1                	jl     8015b9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015e6:	eb 1f                	jmp    801607 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015eb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f1:	89 c2                	mov    %eax,%edx
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801604:	ff 45 f8             	incl   -0x8(%ebp)
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80160d:	7c d9                	jl     8015e8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	c6 00 00             	movb   $0x0,(%eax)
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801620:	8b 45 14             	mov    0x14(%ebp),%eax
  801623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	8b 00                	mov    (%eax),%eax
  80162e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801640:	eb 0c                	jmp    80164e <strsplit+0x31>
			*string++ = 0;
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8d 50 01             	lea    0x1(%eax),%edx
  801648:	89 55 08             	mov    %edx,0x8(%ebp)
  80164b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	84 c0                	test   %al,%al
  801655:	74 18                	je     80166f <strsplit+0x52>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	0f be c0             	movsbl %al,%eax
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	e8 13 fb ff ff       	call   80117b <strchr>
  801668:	83 c4 08             	add    $0x8,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 d3                	jne    801642 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	84 c0                	test   %al,%al
  801676:	74 5a                	je     8016d2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	83 f8 0f             	cmp    $0xf,%eax
  801680:	75 07                	jne    801689 <strsplit+0x6c>
		{
			return 0;
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
  801687:	eb 66                	jmp    8016ef <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801689:	8b 45 14             	mov    0x14(%ebp),%eax
  80168c:	8b 00                	mov    (%eax),%eax
  80168e:	8d 48 01             	lea    0x1(%eax),%ecx
  801691:	8b 55 14             	mov    0x14(%ebp),%edx
  801694:	89 0a                	mov    %ecx,(%edx)
  801696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	01 c2                	add    %eax,%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016a7:	eb 03                	jmp    8016ac <strsplit+0x8f>
			string++;
  8016a9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	84 c0                	test   %al,%al
  8016b3:	74 8b                	je     801640 <strsplit+0x23>
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	0f be c0             	movsbl %al,%eax
  8016bd:	50                   	push   %eax
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	e8 b5 fa ff ff       	call   80117b <strchr>
  8016c6:	83 c4 08             	add    $0x8,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	74 dc                	je     8016a9 <strsplit+0x8c>
			string++;
	}
  8016cd:	e9 6e ff ff ff       	jmp    801640 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016d2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016df:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8016f7:	a1 04 50 80 00       	mov    0x805004,%eax
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	74 1f                	je     80171f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801700:	e8 1d 00 00 00       	call   801722 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	68 10 40 80 00       	push   $0x804010
  80170d:	e8 55 f2 ff ff       	call   800967 <cprintf>
  801712:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801715:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80171c:	00 00 00 
	}
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801728:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80172f:	00 00 00 
  801732:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801739:	00 00 00 
  80173c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801743:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801746:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80174d:	00 00 00 
  801750:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801757:	00 00 00 
  80175a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801761:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801764:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80176b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801773:	2d 00 10 00 00       	sub    $0x1000,%eax
  801778:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  80177d:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801784:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801787:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801791:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801796:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179c:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a1:	f7 75 f0             	divl   -0x10(%ebp)
  8017a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a7:	29 d0                	sub    %edx,%eax
  8017a9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8017ac:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8017b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017bb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	6a 06                	push   $0x6
  8017c5:	ff 75 e8             	pushl  -0x18(%ebp)
  8017c8:	50                   	push   %eax
  8017c9:	e8 d4 05 00 00       	call   801da2 <sys_allocate_chunk>
  8017ce:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017d1:	a1 20 51 80 00       	mov    0x805120,%eax
  8017d6:	83 ec 0c             	sub    $0xc,%esp
  8017d9:	50                   	push   %eax
  8017da:	e8 49 0c 00 00       	call   802428 <initialize_MemBlocksList>
  8017df:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8017e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8017e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8017ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017ee:	75 14                	jne    801804 <initialize_dyn_block_system+0xe2>
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	68 35 40 80 00       	push   $0x804035
  8017f8:	6a 39                	push   $0x39
  8017fa:	68 53 40 80 00       	push   $0x804053
  8017ff:	e8 af ee ff ff       	call   8006b3 <_panic>
  801804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801807:	8b 00                	mov    (%eax),%eax
  801809:	85 c0                	test   %eax,%eax
  80180b:	74 10                	je     80181d <initialize_dyn_block_system+0xfb>
  80180d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801810:	8b 00                	mov    (%eax),%eax
  801812:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801815:	8b 52 04             	mov    0x4(%edx),%edx
  801818:	89 50 04             	mov    %edx,0x4(%eax)
  80181b:	eb 0b                	jmp    801828 <initialize_dyn_block_system+0x106>
  80181d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801820:	8b 40 04             	mov    0x4(%eax),%eax
  801823:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801828:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182b:	8b 40 04             	mov    0x4(%eax),%eax
  80182e:	85 c0                	test   %eax,%eax
  801830:	74 0f                	je     801841 <initialize_dyn_block_system+0x11f>
  801832:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801835:	8b 40 04             	mov    0x4(%eax),%eax
  801838:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80183b:	8b 12                	mov    (%edx),%edx
  80183d:	89 10                	mov    %edx,(%eax)
  80183f:	eb 0a                	jmp    80184b <initialize_dyn_block_system+0x129>
  801841:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801844:	8b 00                	mov    (%eax),%eax
  801846:	a3 48 51 80 00       	mov    %eax,0x805148
  80184b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80184e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801854:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801857:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80185e:	a1 54 51 80 00       	mov    0x805154,%eax
  801863:	48                   	dec    %eax
  801864:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801869:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80186c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801873:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801876:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  80187d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801881:	75 14                	jne    801897 <initialize_dyn_block_system+0x175>
  801883:	83 ec 04             	sub    $0x4,%esp
  801886:	68 60 40 80 00       	push   $0x804060
  80188b:	6a 3f                	push   $0x3f
  80188d:	68 53 40 80 00       	push   $0x804053
  801892:	e8 1c ee ff ff       	call   8006b3 <_panic>
  801897:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80189d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a0:	89 10                	mov    %edx,(%eax)
  8018a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a5:	8b 00                	mov    (%eax),%eax
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	74 0d                	je     8018b8 <initialize_dyn_block_system+0x196>
  8018ab:	a1 38 51 80 00       	mov    0x805138,%eax
  8018b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b3:	89 50 04             	mov    %edx,0x4(%eax)
  8018b6:	eb 08                	jmp    8018c0 <initialize_dyn_block_system+0x19e>
  8018b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8018c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8018c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8018d7:	40                   	inc    %eax
  8018d8:	a3 44 51 80 00       	mov    %eax,0x805144

}
  8018dd:	90                   	nop
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e6:	e8 06 fe ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018ef:	75 07                	jne    8018f8 <malloc+0x18>
  8018f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f6:	eb 7d                	jmp    801975 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8018f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8018ff:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801906:	8b 55 08             	mov    0x8(%ebp),%edx
  801909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190c:	01 d0                	add    %edx,%eax
  80190e:	48                   	dec    %eax
  80190f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801915:	ba 00 00 00 00       	mov    $0x0,%edx
  80191a:	f7 75 f0             	divl   -0x10(%ebp)
  80191d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801920:	29 d0                	sub    %edx,%eax
  801922:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801925:	e8 46 08 00 00       	call   802170 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80192a:	83 f8 01             	cmp    $0x1,%eax
  80192d:	75 07                	jne    801936 <malloc+0x56>
  80192f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801936:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80193a:	75 34                	jne    801970 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	ff 75 e8             	pushl  -0x18(%ebp)
  801942:	e8 73 0e 00 00       	call   8027ba <alloc_block_FF>
  801947:	83 c4 10             	add    $0x10,%esp
  80194a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  80194d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801951:	74 16                	je     801969 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801953:	83 ec 0c             	sub    $0xc,%esp
  801956:	ff 75 e4             	pushl  -0x1c(%ebp)
  801959:	e8 ff 0b 00 00       	call   80255d <insert_sorted_allocList>
  80195e:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801964:	8b 40 08             	mov    0x8(%eax),%eax
  801967:	eb 0c                	jmp    801975 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
  80196e:	eb 05                	jmp    801975 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801970:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801991:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801994:	83 ec 08             	sub    $0x8,%esp
  801997:	ff 75 f4             	pushl  -0xc(%ebp)
  80199a:	68 40 50 80 00       	push   $0x805040
  80199f:	e8 61 0b 00 00       	call   802505 <find_block>
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8019aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019ae:	0f 84 a5 00 00 00    	je     801a59 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8019b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ba:	83 ec 08             	sub    $0x8,%esp
  8019bd:	50                   	push   %eax
  8019be:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c1:	e8 a4 03 00 00       	call   801d6a <sys_free_user_mem>
  8019c6:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8019c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019cd:	75 17                	jne    8019e6 <free+0x6f>
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	68 35 40 80 00       	push   $0x804035
  8019d7:	68 87 00 00 00       	push   $0x87
  8019dc:	68 53 40 80 00       	push   $0x804053
  8019e1:	e8 cd ec ff ff       	call   8006b3 <_panic>
  8019e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e9:	8b 00                	mov    (%eax),%eax
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	74 10                	je     8019ff <free+0x88>
  8019ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f2:	8b 00                	mov    (%eax),%eax
  8019f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019f7:	8b 52 04             	mov    0x4(%edx),%edx
  8019fa:	89 50 04             	mov    %edx,0x4(%eax)
  8019fd:	eb 0b                	jmp    801a0a <free+0x93>
  8019ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a02:	8b 40 04             	mov    0x4(%eax),%eax
  801a05:	a3 44 50 80 00       	mov    %eax,0x805044
  801a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a0d:	8b 40 04             	mov    0x4(%eax),%eax
  801a10:	85 c0                	test   %eax,%eax
  801a12:	74 0f                	je     801a23 <free+0xac>
  801a14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a17:	8b 40 04             	mov    0x4(%eax),%eax
  801a1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a1d:	8b 12                	mov    (%edx),%edx
  801a1f:	89 10                	mov    %edx,(%eax)
  801a21:	eb 0a                	jmp    801a2d <free+0xb6>
  801a23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a26:	8b 00                	mov    (%eax),%eax
  801a28:	a3 40 50 80 00       	mov    %eax,0x805040
  801a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a40:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a45:	48                   	dec    %eax
  801a46:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801a4b:	83 ec 0c             	sub    $0xc,%esp
  801a4e:	ff 75 ec             	pushl  -0x14(%ebp)
  801a51:	e8 37 12 00 00       	call   802c8d <insert_sorted_with_merge_freeList>
  801a56:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801a59:	90                   	nop
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 38             	sub    $0x38,%esp
  801a62:	8b 45 10             	mov    0x10(%ebp),%eax
  801a65:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a68:	e8 84 fc ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a71:	75 07                	jne    801a7a <smalloc+0x1e>
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
  801a78:	eb 7e                	jmp    801af8 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801a7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801a81:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8e:	01 d0                	add    %edx,%eax
  801a90:	48                   	dec    %eax
  801a91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a97:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9c:	f7 75 f0             	divl   -0x10(%ebp)
  801a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa2:	29 d0                	sub    %edx,%eax
  801aa4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801aa7:	e8 c4 06 00 00       	call   802170 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801aac:	83 f8 01             	cmp    $0x1,%eax
  801aaf:	75 42                	jne    801af3 <smalloc+0x97>

		  va = malloc(newsize) ;
  801ab1:	83 ec 0c             	sub    $0xc,%esp
  801ab4:	ff 75 e8             	pushl  -0x18(%ebp)
  801ab7:	e8 24 fe ff ff       	call   8018e0 <malloc>
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ac6:	74 24                	je     801aec <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801ac8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801acc:	ff 75 e4             	pushl  -0x1c(%ebp)
  801acf:	50                   	push   %eax
  801ad0:	ff 75 e8             	pushl  -0x18(%ebp)
  801ad3:	ff 75 08             	pushl  0x8(%ebp)
  801ad6:	e8 1a 04 00 00       	call   801ef5 <sys_createSharedObject>
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801ae1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae5:	78 0c                	js     801af3 <smalloc+0x97>
					  return va ;
  801ae7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aea:	eb 0c                	jmp    801af8 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801aec:	b8 00 00 00 00       	mov    $0x0,%eax
  801af1:	eb 05                	jmp    801af8 <smalloc+0x9c>
	  }
		  return NULL ;
  801af3:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b00:	e8 ec fb ff ff       	call   8016f1 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801b05:	83 ec 08             	sub    $0x8,%esp
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	ff 75 08             	pushl  0x8(%ebp)
  801b0e:	e8 0c 04 00 00       	call   801f1f <sys_getSizeOfSharedObject>
  801b13:	83 c4 10             	add    $0x10,%esp
  801b16:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801b19:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b1d:	75 07                	jne    801b26 <sget+0x2c>
  801b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b24:	eb 75                	jmp    801b9b <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b26:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b33:	01 d0                	add    %edx,%eax
  801b35:	48                   	dec    %eax
  801b36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b41:	f7 75 f0             	divl   -0x10(%ebp)
  801b44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b47:	29 d0                	sub    %edx,%eax
  801b49:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801b4c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801b53:	e8 18 06 00 00       	call   802170 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b58:	83 f8 01             	cmp    $0x1,%eax
  801b5b:	75 39                	jne    801b96 <sget+0x9c>

		  va = malloc(newsize) ;
  801b5d:	83 ec 0c             	sub    $0xc,%esp
  801b60:	ff 75 e8             	pushl  -0x18(%ebp)
  801b63:	e8 78 fd ff ff       	call   8018e0 <malloc>
  801b68:	83 c4 10             	add    $0x10,%esp
  801b6b:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801b6e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b72:	74 22                	je     801b96 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801b74:	83 ec 04             	sub    $0x4,%esp
  801b77:	ff 75 e0             	pushl  -0x20(%ebp)
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	ff 75 08             	pushl  0x8(%ebp)
  801b80:	e8 b7 03 00 00       	call   801f3c <sys_getSharedObject>
  801b85:	83 c4 10             	add    $0x10,%esp
  801b88:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801b8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b8f:	78 05                	js     801b96 <sget+0x9c>
					  return va;
  801b91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b94:	eb 05                	jmp    801b9b <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801b96:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ba3:	e8 49 fb ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ba8:	83 ec 04             	sub    $0x4,%esp
  801bab:	68 84 40 80 00       	push   $0x804084
  801bb0:	68 1e 01 00 00       	push   $0x11e
  801bb5:	68 53 40 80 00       	push   $0x804053
  801bba:	e8 f4 ea ff ff       	call   8006b3 <_panic>

00801bbf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	68 ac 40 80 00       	push   $0x8040ac
  801bcd:	68 32 01 00 00       	push   $0x132
  801bd2:	68 53 40 80 00       	push   $0x804053
  801bd7:	e8 d7 ea ff ff       	call   8006b3 <_panic>

00801bdc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801be2:	83 ec 04             	sub    $0x4,%esp
  801be5:	68 d0 40 80 00       	push   $0x8040d0
  801bea:	68 3d 01 00 00       	push   $0x13d
  801bef:	68 53 40 80 00       	push   $0x804053
  801bf4:	e8 ba ea ff ff       	call   8006b3 <_panic>

00801bf9 <shrink>:

}
void shrink(uint32 newSize)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801bff:	83 ec 04             	sub    $0x4,%esp
  801c02:	68 d0 40 80 00       	push   $0x8040d0
  801c07:	68 42 01 00 00       	push   $0x142
  801c0c:	68 53 40 80 00       	push   $0x804053
  801c11:	e8 9d ea ff ff       	call   8006b3 <_panic>

00801c16 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c1c:	83 ec 04             	sub    $0x4,%esp
  801c1f:	68 d0 40 80 00       	push   $0x8040d0
  801c24:	68 47 01 00 00       	push   $0x147
  801c29:	68 53 40 80 00       	push   $0x804053
  801c2e:	e8 80 ea ff ff       	call   8006b3 <_panic>

00801c33 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	57                   	push   %edi
  801c37:	56                   	push   %esi
  801c38:	53                   	push   %ebx
  801c39:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c45:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c48:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c4b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c4e:	cd 30                	int    $0x30
  801c50:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801c56:	83 c4 10             	add    $0x10,%esp
  801c59:	5b                   	pop    %ebx
  801c5a:	5e                   	pop    %esi
  801c5b:	5f                   	pop    %edi
  801c5c:	5d                   	pop    %ebp
  801c5d:	c3                   	ret    

00801c5e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	8b 45 10             	mov    0x10(%ebp),%eax
  801c67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801c6a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	52                   	push   %edx
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	50                   	push   %eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	e8 b2 ff ff ff       	call   801c33 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	90                   	nop
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 01                	push   $0x1
  801c96:	e8 98 ff ff ff       	call   801c33 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	6a 05                	push   $0x5
  801cb3:	e8 7b ff ff ff       	call   801c33 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	56                   	push   %esi
  801cc1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801cc2:	8b 75 18             	mov    0x18(%ebp),%esi
  801cc5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	56                   	push   %esi
  801cd2:	53                   	push   %ebx
  801cd3:	51                   	push   %ecx
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	6a 06                	push   $0x6
  801cd8:	e8 56 ff ff ff       	call   801c33 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ced:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	52                   	push   %edx
  801cf7:	50                   	push   %eax
  801cf8:	6a 07                	push   $0x7
  801cfa:	e8 34 ff ff ff       	call   801c33 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	ff 75 0c             	pushl  0xc(%ebp)
  801d10:	ff 75 08             	pushl  0x8(%ebp)
  801d13:	6a 08                	push   $0x8
  801d15:	e8 19 ff ff ff       	call   801c33 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 09                	push   $0x9
  801d2e:	e8 00 ff ff ff       	call   801c33 <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 0a                	push   $0xa
  801d47:	e8 e7 fe ff ff       	call   801c33 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 0b                	push   $0xb
  801d60:	e8 ce fe ff ff       	call   801c33 <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	ff 75 0c             	pushl  0xc(%ebp)
  801d76:	ff 75 08             	pushl  0x8(%ebp)
  801d79:	6a 0f                	push   $0xf
  801d7b:	e8 b3 fe ff ff       	call   801c33 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	ff 75 0c             	pushl  0xc(%ebp)
  801d92:	ff 75 08             	pushl  0x8(%ebp)
  801d95:	6a 10                	push   $0x10
  801d97:	e8 97 fe ff ff       	call   801c33 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9f:	90                   	nop
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	ff 75 10             	pushl  0x10(%ebp)
  801dac:	ff 75 0c             	pushl  0xc(%ebp)
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	6a 11                	push   $0x11
  801db4:	e8 7a fe ff ff       	call   801c33 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbc:	90                   	nop
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 0c                	push   $0xc
  801dce:	e8 60 fe ff ff       	call   801c33 <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	ff 75 08             	pushl  0x8(%ebp)
  801de6:	6a 0d                	push   $0xd
  801de8:	e8 46 fe ff ff       	call   801c33 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 0e                	push   $0xe
  801e01:	e8 2d fe ff ff       	call   801c33 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	90                   	nop
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 13                	push   $0x13
  801e1b:	e8 13 fe ff ff       	call   801c33 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	90                   	nop
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 14                	push   $0x14
  801e35:	e8 f9 fd ff ff       	call   801c33 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
}
  801e3d:	90                   	nop
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_cputc>:


void
sys_cputc(const char c)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e4c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	50                   	push   %eax
  801e59:	6a 15                	push   $0x15
  801e5b:	e8 d3 fd ff ff       	call   801c33 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	90                   	nop
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 16                	push   $0x16
  801e75:	e8 b9 fd ff ff       	call   801c33 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	90                   	nop
  801e7e:	c9                   	leave  
  801e7f:	c3                   	ret    

00801e80 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	ff 75 0c             	pushl  0xc(%ebp)
  801e8f:	50                   	push   %eax
  801e90:	6a 17                	push   $0x17
  801e92:	e8 9c fd ff ff       	call   801c33 <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	52                   	push   %edx
  801eac:	50                   	push   %eax
  801ead:	6a 1a                	push   $0x1a
  801eaf:	e8 7f fd ff ff       	call   801c33 <syscall>
  801eb4:	83 c4 18             	add    $0x18,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	52                   	push   %edx
  801ec9:	50                   	push   %eax
  801eca:	6a 18                	push   $0x18
  801ecc:	e8 62 fd ff ff       	call   801c33 <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
}
  801ed4:	90                   	nop
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	52                   	push   %edx
  801ee7:	50                   	push   %eax
  801ee8:	6a 19                	push   $0x19
  801eea:	e8 44 fd ff ff       	call   801c33 <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
}
  801ef2:	90                   	nop
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 04             	sub    $0x4,%esp
  801efb:	8b 45 10             	mov    0x10(%ebp),%eax
  801efe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f04:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	51                   	push   %ecx
  801f0e:	52                   	push   %edx
  801f0f:	ff 75 0c             	pushl  0xc(%ebp)
  801f12:	50                   	push   %eax
  801f13:	6a 1b                	push   $0x1b
  801f15:	e8 19 fd ff ff       	call   801c33 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	52                   	push   %edx
  801f2f:	50                   	push   %eax
  801f30:	6a 1c                	push   $0x1c
  801f32:	e8 fc fc ff ff       	call   801c33 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	51                   	push   %ecx
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	6a 1d                	push   $0x1d
  801f51:	e8 dd fc ff ff       	call   801c33 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	52                   	push   %edx
  801f6b:	50                   	push   %eax
  801f6c:	6a 1e                	push   $0x1e
  801f6e:	e8 c0 fc ff ff       	call   801c33 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 1f                	push   $0x1f
  801f87:	e8 a7 fc ff ff       	call   801c33 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	6a 00                	push   $0x0
  801f99:	ff 75 14             	pushl  0x14(%ebp)
  801f9c:	ff 75 10             	pushl  0x10(%ebp)
  801f9f:	ff 75 0c             	pushl  0xc(%ebp)
  801fa2:	50                   	push   %eax
  801fa3:	6a 20                	push   $0x20
  801fa5:	e8 89 fc ff ff       	call   801c33 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
}
  801fad:	c9                   	leave  
  801fae:	c3                   	ret    

00801faf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	50                   	push   %eax
  801fbe:	6a 21                	push   $0x21
  801fc0:	e8 6e fc ff ff       	call   801c33 <syscall>
  801fc5:	83 c4 18             	add    $0x18,%esp
}
  801fc8:	90                   	nop
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	50                   	push   %eax
  801fda:	6a 22                	push   $0x22
  801fdc:	e8 52 fc ff ff       	call   801c33 <syscall>
  801fe1:	83 c4 18             	add    $0x18,%esp
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 02                	push   $0x2
  801ff5:	e8 39 fc ff ff       	call   801c33 <syscall>
  801ffa:	83 c4 18             	add    $0x18,%esp
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 03                	push   $0x3
  80200e:	e8 20 fc ff ff       	call   801c33 <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 04                	push   $0x4
  802027:	e8 07 fc ff ff       	call   801c33 <syscall>
  80202c:	83 c4 18             	add    $0x18,%esp
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <sys_exit_env>:


void sys_exit_env(void)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 23                	push   $0x23
  802040:	e8 ee fb ff ff       	call   801c33 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	90                   	nop
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802051:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802054:	8d 50 04             	lea    0x4(%eax),%edx
  802057:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	52                   	push   %edx
  802061:	50                   	push   %eax
  802062:	6a 24                	push   $0x24
  802064:	e8 ca fb ff ff       	call   801c33 <syscall>
  802069:	83 c4 18             	add    $0x18,%esp
	return result;
  80206c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802072:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802075:	89 01                	mov    %eax,(%ecx)
  802077:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	c9                   	leave  
  80207e:	c2 04 00             	ret    $0x4

00802081 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	ff 75 10             	pushl  0x10(%ebp)
  80208b:	ff 75 0c             	pushl  0xc(%ebp)
  80208e:	ff 75 08             	pushl  0x8(%ebp)
  802091:	6a 12                	push   $0x12
  802093:	e8 9b fb ff ff       	call   801c33 <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
	return ;
  80209b:	90                   	nop
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    

0080209e <sys_rcr2>:
uint32 sys_rcr2()
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 25                	push   $0x25
  8020ad:	e8 81 fb ff ff       	call   801c33 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 04             	sub    $0x4,%esp
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8020c3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	50                   	push   %eax
  8020d0:	6a 26                	push   $0x26
  8020d2:	e8 5c fb ff ff       	call   801c33 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020da:	90                   	nop
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <rsttst>:
void rsttst()
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 28                	push   $0x28
  8020ec:	e8 42 fb ff ff       	call   801c33 <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f4:	90                   	nop
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	8b 45 14             	mov    0x14(%ebp),%eax
  802100:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802103:	8b 55 18             	mov    0x18(%ebp),%edx
  802106:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80210a:	52                   	push   %edx
  80210b:	50                   	push   %eax
  80210c:	ff 75 10             	pushl  0x10(%ebp)
  80210f:	ff 75 0c             	pushl  0xc(%ebp)
  802112:	ff 75 08             	pushl  0x8(%ebp)
  802115:	6a 27                	push   $0x27
  802117:	e8 17 fb ff ff       	call   801c33 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
	return ;
  80211f:	90                   	nop
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <chktst>:
void chktst(uint32 n)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	ff 75 08             	pushl  0x8(%ebp)
  802130:	6a 29                	push   $0x29
  802132:	e8 fc fa ff ff       	call   801c33 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
	return ;
  80213a:	90                   	nop
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <inctst>:

void inctst()
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 2a                	push   $0x2a
  80214c:	e8 e2 fa ff ff       	call   801c33 <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
	return ;
  802154:	90                   	nop
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <gettst>:
uint32 gettst()
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 2b                	push   $0x2b
  802166:	e8 c8 fa ff ff       	call   801c33 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 2c                	push   $0x2c
  802182:	e8 ac fa ff ff       	call   801c33 <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
  80218a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80218d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802191:	75 07                	jne    80219a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802193:	b8 01 00 00 00       	mov    $0x1,%eax
  802198:	eb 05                	jmp    80219f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 2c                	push   $0x2c
  8021b3:	e8 7b fa ff ff       	call   801c33 <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
  8021bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8021be:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8021c2:	75 07                	jne    8021cb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8021c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c9:	eb 05                	jmp    8021d0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8021cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 2c                	push   $0x2c
  8021e4:	e8 4a fa ff ff       	call   801c33 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
  8021ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8021ef:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8021f3:	75 07                	jne    8021fc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8021f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8021fa:	eb 05                	jmp    802201 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802201:	c9                   	leave  
  802202:	c3                   	ret    

00802203 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 2c                	push   $0x2c
  802215:	e8 19 fa ff ff       	call   801c33 <syscall>
  80221a:	83 c4 18             	add    $0x18,%esp
  80221d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802220:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802224:	75 07                	jne    80222d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802226:	b8 01 00 00 00       	mov    $0x1,%eax
  80222b:	eb 05                	jmp    802232 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	ff 75 08             	pushl  0x8(%ebp)
  802242:	6a 2d                	push   $0x2d
  802244:	e8 ea f9 ff ff       	call   801c33 <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
	return ;
  80224c:	90                   	nop
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802253:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802256:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	6a 00                	push   $0x0
  802261:	53                   	push   %ebx
  802262:	51                   	push   %ecx
  802263:	52                   	push   %edx
  802264:	50                   	push   %eax
  802265:	6a 2e                	push   $0x2e
  802267:	e8 c7 f9 ff ff       	call   801c33 <syscall>
  80226c:	83 c4 18             	add    $0x18,%esp
}
  80226f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802277:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	52                   	push   %edx
  802284:	50                   	push   %eax
  802285:	6a 2f                	push   $0x2f
  802287:	e8 a7 f9 ff ff       	call   801c33 <syscall>
  80228c:	83 c4 18             	add    $0x18,%esp
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802297:	83 ec 0c             	sub    $0xc,%esp
  80229a:	68 e0 40 80 00       	push   $0x8040e0
  80229f:	e8 c3 e6 ff ff       	call   800967 <cprintf>
  8022a4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022ae:	83 ec 0c             	sub    $0xc,%esp
  8022b1:	68 0c 41 80 00       	push   $0x80410c
  8022b6:	e8 ac e6 ff ff       	call   800967 <cprintf>
  8022bb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8022be:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8022c2:	a1 38 51 80 00       	mov    0x805138,%eax
  8022c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ca:	eb 56                	jmp    802322 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8022cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d0:	74 1c                	je     8022ee <print_mem_block_lists+0x5d>
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 50 08             	mov    0x8(%eax),%edx
  8022d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022db:	8b 48 08             	mov    0x8(%eax),%ecx
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e4:	01 c8                	add    %ecx,%eax
  8022e6:	39 c2                	cmp    %eax,%edx
  8022e8:	73 04                	jae    8022ee <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8022ea:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	8b 50 08             	mov    0x8(%eax),%edx
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fa:	01 c2                	add    %eax,%edx
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 40 08             	mov    0x8(%eax),%eax
  802302:	83 ec 04             	sub    $0x4,%esp
  802305:	52                   	push   %edx
  802306:	50                   	push   %eax
  802307:	68 21 41 80 00       	push   $0x804121
  80230c:	e8 56 e6 ff ff       	call   800967 <cprintf>
  802311:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80231a:	a1 40 51 80 00       	mov    0x805140,%eax
  80231f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802326:	74 07                	je     80232f <print_mem_block_lists+0x9e>
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 00                	mov    (%eax),%eax
  80232d:	eb 05                	jmp    802334 <print_mem_block_lists+0xa3>
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
  802334:	a3 40 51 80 00       	mov    %eax,0x805140
  802339:	a1 40 51 80 00       	mov    0x805140,%eax
  80233e:	85 c0                	test   %eax,%eax
  802340:	75 8a                	jne    8022cc <print_mem_block_lists+0x3b>
  802342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802346:	75 84                	jne    8022cc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802348:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80234c:	75 10                	jne    80235e <print_mem_block_lists+0xcd>
  80234e:	83 ec 0c             	sub    $0xc,%esp
  802351:	68 30 41 80 00       	push   $0x804130
  802356:	e8 0c e6 ff ff       	call   800967 <cprintf>
  80235b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80235e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802365:	83 ec 0c             	sub    $0xc,%esp
  802368:	68 54 41 80 00       	push   $0x804154
  80236d:	e8 f5 e5 ff ff       	call   800967 <cprintf>
  802372:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802375:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802379:	a1 40 50 80 00       	mov    0x805040,%eax
  80237e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802381:	eb 56                	jmp    8023d9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802387:	74 1c                	je     8023a5 <print_mem_block_lists+0x114>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 50 08             	mov    0x8(%eax),%edx
  80238f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802392:	8b 48 08             	mov    0x8(%eax),%ecx
  802395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802398:	8b 40 0c             	mov    0xc(%eax),%eax
  80239b:	01 c8                	add    %ecx,%eax
  80239d:	39 c2                	cmp    %eax,%edx
  80239f:	73 04                	jae    8023a5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023a1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 50 08             	mov    0x8(%eax),%edx
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b1:	01 c2                	add    %eax,%edx
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	8b 40 08             	mov    0x8(%eax),%eax
  8023b9:	83 ec 04             	sub    $0x4,%esp
  8023bc:	52                   	push   %edx
  8023bd:	50                   	push   %eax
  8023be:	68 21 41 80 00       	push   $0x804121
  8023c3:	e8 9f e5 ff ff       	call   800967 <cprintf>
  8023c8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023d1:	a1 48 50 80 00       	mov    0x805048,%eax
  8023d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023dd:	74 07                	je     8023e6 <print_mem_block_lists+0x155>
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	eb 05                	jmp    8023eb <print_mem_block_lists+0x15a>
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023eb:	a3 48 50 80 00       	mov    %eax,0x805048
  8023f0:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	75 8a                	jne    802383 <print_mem_block_lists+0xf2>
  8023f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023fd:	75 84                	jne    802383 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8023ff:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802403:	75 10                	jne    802415 <print_mem_block_lists+0x184>
  802405:	83 ec 0c             	sub    $0xc,%esp
  802408:	68 6c 41 80 00       	push   $0x80416c
  80240d:	e8 55 e5 ff ff       	call   800967 <cprintf>
  802412:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802415:	83 ec 0c             	sub    $0xc,%esp
  802418:	68 e0 40 80 00       	push   $0x8040e0
  80241d:	e8 45 e5 ff ff       	call   800967 <cprintf>
  802422:	83 c4 10             	add    $0x10,%esp

}
  802425:	90                   	nop
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80242e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802435:	00 00 00 
  802438:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80243f:	00 00 00 
  802442:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802449:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80244c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802453:	e9 9e 00 00 00       	jmp    8024f6 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802458:	a1 50 50 80 00       	mov    0x805050,%eax
  80245d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802460:	c1 e2 04             	shl    $0x4,%edx
  802463:	01 d0                	add    %edx,%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	75 14                	jne    80247d <initialize_MemBlocksList+0x55>
  802469:	83 ec 04             	sub    $0x4,%esp
  80246c:	68 94 41 80 00       	push   $0x804194
  802471:	6a 47                	push   $0x47
  802473:	68 b7 41 80 00       	push   $0x8041b7
  802478:	e8 36 e2 ff ff       	call   8006b3 <_panic>
  80247d:	a1 50 50 80 00       	mov    0x805050,%eax
  802482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802485:	c1 e2 04             	shl    $0x4,%edx
  802488:	01 d0                	add    %edx,%eax
  80248a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802490:	89 10                	mov    %edx,(%eax)
  802492:	8b 00                	mov    (%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 18                	je     8024b0 <initialize_MemBlocksList+0x88>
  802498:	a1 48 51 80 00       	mov    0x805148,%eax
  80249d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024a6:	c1 e1 04             	shl    $0x4,%ecx
  8024a9:	01 ca                	add    %ecx,%edx
  8024ab:	89 50 04             	mov    %edx,0x4(%eax)
  8024ae:	eb 12                	jmp    8024c2 <initialize_MemBlocksList+0x9a>
  8024b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	c1 e2 04             	shl    $0x4,%edx
  8024bb:	01 d0                	add    %edx,%eax
  8024bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024c2:	a1 50 50 80 00       	mov    0x805050,%eax
  8024c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ca:	c1 e2 04             	shl    $0x4,%edx
  8024cd:	01 d0                	add    %edx,%eax
  8024cf:	a3 48 51 80 00       	mov    %eax,0x805148
  8024d4:	a1 50 50 80 00       	mov    0x805050,%eax
  8024d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024dc:	c1 e2 04             	shl    $0x4,%edx
  8024df:	01 d0                	add    %edx,%eax
  8024e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8024ed:	40                   	inc    %eax
  8024ee:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8024f3:	ff 45 f4             	incl   -0xc(%ebp)
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fc:	0f 82 56 ff ff ff    	jb     802458 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802502:	90                   	nop
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	8b 00                	mov    (%eax),%eax
  802510:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802513:	eb 19                	jmp    80252e <find_block+0x29>
	{
		if(element->sva == va){
  802515:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802518:	8b 40 08             	mov    0x8(%eax),%eax
  80251b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80251e:	75 05                	jne    802525 <find_block+0x20>
			 		return element;
  802520:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802523:	eb 36                	jmp    80255b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802525:	8b 45 08             	mov    0x8(%ebp),%eax
  802528:	8b 40 08             	mov    0x8(%eax),%eax
  80252b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80252e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802532:	74 07                	je     80253b <find_block+0x36>
  802534:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802537:	8b 00                	mov    (%eax),%eax
  802539:	eb 05                	jmp    802540 <find_block+0x3b>
  80253b:	b8 00 00 00 00       	mov    $0x0,%eax
  802540:	8b 55 08             	mov    0x8(%ebp),%edx
  802543:	89 42 08             	mov    %eax,0x8(%edx)
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	8b 40 08             	mov    0x8(%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	75 c5                	jne    802515 <find_block+0x10>
  802550:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802554:	75 bf                	jne    802515 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255b:	c9                   	leave  
  80255c:	c3                   	ret    

0080255d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80255d:	55                   	push   %ebp
  80255e:	89 e5                	mov    %esp,%ebp
  802560:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802563:	a1 44 50 80 00       	mov    0x805044,%eax
  802568:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80256b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802570:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802573:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802577:	74 0a                	je     802583 <insert_sorted_allocList+0x26>
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	8b 40 08             	mov    0x8(%eax),%eax
  80257f:	85 c0                	test   %eax,%eax
  802581:	75 65                	jne    8025e8 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802583:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802587:	75 14                	jne    80259d <insert_sorted_allocList+0x40>
  802589:	83 ec 04             	sub    $0x4,%esp
  80258c:	68 94 41 80 00       	push   $0x804194
  802591:	6a 6e                	push   $0x6e
  802593:	68 b7 41 80 00       	push   $0x8041b7
  802598:	e8 16 e1 ff ff       	call   8006b3 <_panic>
  80259d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	89 10                	mov    %edx,(%eax)
  8025a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ab:	8b 00                	mov    (%eax),%eax
  8025ad:	85 c0                	test   %eax,%eax
  8025af:	74 0d                	je     8025be <insert_sorted_allocList+0x61>
  8025b1:	a1 40 50 80 00       	mov    0x805040,%eax
  8025b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025b9:	89 50 04             	mov    %edx,0x4(%eax)
  8025bc:	eb 08                	jmp    8025c6 <insert_sorted_allocList+0x69>
  8025be:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c1:	a3 44 50 80 00       	mov    %eax,0x805044
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	a3 40 50 80 00       	mov    %eax,0x805040
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025dd:	40                   	inc    %eax
  8025de:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8025e3:	e9 cf 01 00 00       	jmp    8027b7 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8025e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025eb:	8b 50 08             	mov    0x8(%eax),%edx
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	8b 40 08             	mov    0x8(%eax),%eax
  8025f4:	39 c2                	cmp    %eax,%edx
  8025f6:	73 65                	jae    80265d <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8025f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025fc:	75 14                	jne    802612 <insert_sorted_allocList+0xb5>
  8025fe:	83 ec 04             	sub    $0x4,%esp
  802601:	68 d0 41 80 00       	push   $0x8041d0
  802606:	6a 72                	push   $0x72
  802608:	68 b7 41 80 00       	push   $0x8041b7
  80260d:	e8 a1 e0 ff ff       	call   8006b3 <_panic>
  802612:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	89 50 04             	mov    %edx,0x4(%eax)
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 0c                	je     802634 <insert_sorted_allocList+0xd7>
  802628:	a1 44 50 80 00       	mov    0x805044,%eax
  80262d:	8b 55 08             	mov    0x8(%ebp),%edx
  802630:	89 10                	mov    %edx,(%eax)
  802632:	eb 08                	jmp    80263c <insert_sorted_allocList+0xdf>
  802634:	8b 45 08             	mov    0x8(%ebp),%eax
  802637:	a3 40 50 80 00       	mov    %eax,0x805040
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	a3 44 50 80 00       	mov    %eax,0x805044
  802644:	8b 45 08             	mov    0x8(%ebp),%eax
  802647:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802652:	40                   	inc    %eax
  802653:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802658:	e9 5a 01 00 00       	jmp    8027b7 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  80265d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802660:	8b 50 08             	mov    0x8(%eax),%edx
  802663:	8b 45 08             	mov    0x8(%ebp),%eax
  802666:	8b 40 08             	mov    0x8(%eax),%eax
  802669:	39 c2                	cmp    %eax,%edx
  80266b:	75 70                	jne    8026dd <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  80266d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802671:	74 06                	je     802679 <insert_sorted_allocList+0x11c>
  802673:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802677:	75 14                	jne    80268d <insert_sorted_allocList+0x130>
  802679:	83 ec 04             	sub    $0x4,%esp
  80267c:	68 f4 41 80 00       	push   $0x8041f4
  802681:	6a 75                	push   $0x75
  802683:	68 b7 41 80 00       	push   $0x8041b7
  802688:	e8 26 e0 ff ff       	call   8006b3 <_panic>
  80268d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802690:	8b 10                	mov    (%eax),%edx
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	89 10                	mov    %edx,(%eax)
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	8b 00                	mov    (%eax),%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	74 0b                	je     8026ab <insert_sorted_allocList+0x14e>
  8026a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a8:	89 50 04             	mov    %edx,0x4(%eax)
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b1:	89 10                	mov    %edx,(%eax)
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026b9:	89 50 04             	mov    %edx,0x4(%eax)
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	75 08                	jne    8026cd <insert_sorted_allocList+0x170>
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	a3 44 50 80 00       	mov    %eax,0x805044
  8026cd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d2:	40                   	inc    %eax
  8026d3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8026d8:	e9 da 00 00 00       	jmp    8027b7 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8026dd:	a1 40 50 80 00       	mov    0x805040,%eax
  8026e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e5:	e9 9d 00 00 00       	jmp    802787 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 00                	mov    (%eax),%eax
  8026ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	8b 50 08             	mov    0x8(%eax),%edx
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 40 08             	mov    0x8(%eax),%eax
  8026fe:	39 c2                	cmp    %eax,%edx
  802700:	76 7d                	jbe    80277f <insert_sorted_allocList+0x222>
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	8b 50 08             	mov    0x8(%eax),%edx
  802708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270b:	8b 40 08             	mov    0x8(%eax),%eax
  80270e:	39 c2                	cmp    %eax,%edx
  802710:	73 6d                	jae    80277f <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802716:	74 06                	je     80271e <insert_sorted_allocList+0x1c1>
  802718:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80271c:	75 14                	jne    802732 <insert_sorted_allocList+0x1d5>
  80271e:	83 ec 04             	sub    $0x4,%esp
  802721:	68 f4 41 80 00       	push   $0x8041f4
  802726:	6a 7c                	push   $0x7c
  802728:	68 b7 41 80 00       	push   $0x8041b7
  80272d:	e8 81 df ff ff       	call   8006b3 <_panic>
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 10                	mov    (%eax),%edx
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	89 10                	mov    %edx,(%eax)
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	85 c0                	test   %eax,%eax
  802743:	74 0b                	je     802750 <insert_sorted_allocList+0x1f3>
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 00                	mov    (%eax),%eax
  80274a:	8b 55 08             	mov    0x8(%ebp),%edx
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 55 08             	mov    0x8(%ebp),%edx
  802756:	89 10                	mov    %edx,(%eax)
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275e:	89 50 04             	mov    %edx,0x4(%eax)
  802761:	8b 45 08             	mov    0x8(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	85 c0                	test   %eax,%eax
  802768:	75 08                	jne    802772 <insert_sorted_allocList+0x215>
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	a3 44 50 80 00       	mov    %eax,0x805044
  802772:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802777:	40                   	inc    %eax
  802778:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80277d:	eb 38                	jmp    8027b7 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80277f:	a1 48 50 80 00       	mov    0x805048,%eax
  802784:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278b:	74 07                	je     802794 <insert_sorted_allocList+0x237>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	eb 05                	jmp    802799 <insert_sorted_allocList+0x23c>
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
  802799:	a3 48 50 80 00       	mov    %eax,0x805048
  80279e:	a1 48 50 80 00       	mov    0x805048,%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	0f 85 3f ff ff ff    	jne    8026ea <insert_sorted_allocList+0x18d>
  8027ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027af:	0f 85 35 ff ff ff    	jne    8026ea <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8027b5:	eb 00                	jmp    8027b7 <insert_sorted_allocList+0x25a>
  8027b7:	90                   	nop
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
  8027bd:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8027c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8027c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c8:	e9 6b 02 00 00       	jmp    802a38 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d6:	0f 85 90 00 00 00    	jne    80286c <alloc_block_FF+0xb2>
			  temp=element;
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e6:	75 17                	jne    8027ff <alloc_block_FF+0x45>
  8027e8:	83 ec 04             	sub    $0x4,%esp
  8027eb:	68 28 42 80 00       	push   $0x804228
  8027f0:	68 92 00 00 00       	push   $0x92
  8027f5:	68 b7 41 80 00       	push   $0x8041b7
  8027fa:	e8 b4 de ff ff       	call   8006b3 <_panic>
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 00                	mov    (%eax),%eax
  802804:	85 c0                	test   %eax,%eax
  802806:	74 10                	je     802818 <alloc_block_FF+0x5e>
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 00                	mov    (%eax),%eax
  80280d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802810:	8b 52 04             	mov    0x4(%edx),%edx
  802813:	89 50 04             	mov    %edx,0x4(%eax)
  802816:	eb 0b                	jmp    802823 <alloc_block_FF+0x69>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 40 04             	mov    0x4(%eax),%eax
  80281e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 40 04             	mov    0x4(%eax),%eax
  802829:	85 c0                	test   %eax,%eax
  80282b:	74 0f                	je     80283c <alloc_block_FF+0x82>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 40 04             	mov    0x4(%eax),%eax
  802833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802836:	8b 12                	mov    (%edx),%edx
  802838:	89 10                	mov    %edx,(%eax)
  80283a:	eb 0a                	jmp    802846 <alloc_block_FF+0x8c>
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 00                	mov    (%eax),%eax
  802841:	a3 38 51 80 00       	mov    %eax,0x805138
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802859:	a1 44 51 80 00       	mov    0x805144,%eax
  80285e:	48                   	dec    %eax
  80285f:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802864:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802867:	e9 ff 01 00 00       	jmp    802a6b <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 40 0c             	mov    0xc(%eax),%eax
  802872:	3b 45 08             	cmp    0x8(%ebp),%eax
  802875:	0f 86 b5 01 00 00    	jbe    802a30 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 40 0c             	mov    0xc(%eax),%eax
  802881:	2b 45 08             	sub    0x8(%ebp),%eax
  802884:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802887:	a1 48 51 80 00       	mov    0x805148,%eax
  80288c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80288f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802893:	75 17                	jne    8028ac <alloc_block_FF+0xf2>
  802895:	83 ec 04             	sub    $0x4,%esp
  802898:	68 28 42 80 00       	push   $0x804228
  80289d:	68 99 00 00 00       	push   $0x99
  8028a2:	68 b7 41 80 00       	push   $0x8041b7
  8028a7:	e8 07 de ff ff       	call   8006b3 <_panic>
  8028ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 10                	je     8028c5 <alloc_block_FF+0x10b>
  8028b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b8:	8b 00                	mov    (%eax),%eax
  8028ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028bd:	8b 52 04             	mov    0x4(%edx),%edx
  8028c0:	89 50 04             	mov    %edx,0x4(%eax)
  8028c3:	eb 0b                	jmp    8028d0 <alloc_block_FF+0x116>
  8028c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c8:	8b 40 04             	mov    0x4(%eax),%eax
  8028cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 0f                	je     8028e9 <alloc_block_FF+0x12f>
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028e3:	8b 12                	mov    (%edx),%edx
  8028e5:	89 10                	mov    %edx,(%eax)
  8028e7:	eb 0a                	jmp    8028f3 <alloc_block_FF+0x139>
  8028e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	a3 48 51 80 00       	mov    %eax,0x805148
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802906:	a1 54 51 80 00       	mov    0x805154,%eax
  80290b:	48                   	dec    %eax
  80290c:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802911:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802915:	75 17                	jne    80292e <alloc_block_FF+0x174>
  802917:	83 ec 04             	sub    $0x4,%esp
  80291a:	68 d0 41 80 00       	push   $0x8041d0
  80291f:	68 9a 00 00 00       	push   $0x9a
  802924:	68 b7 41 80 00       	push   $0x8041b7
  802929:	e8 85 dd ff ff       	call   8006b3 <_panic>
  80292e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802937:	89 50 04             	mov    %edx,0x4(%eax)
  80293a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293d:	8b 40 04             	mov    0x4(%eax),%eax
  802940:	85 c0                	test   %eax,%eax
  802942:	74 0c                	je     802950 <alloc_block_FF+0x196>
  802944:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802949:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80294c:	89 10                	mov    %edx,(%eax)
  80294e:	eb 08                	jmp    802958 <alloc_block_FF+0x19e>
  802950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802953:	a3 38 51 80 00       	mov    %eax,0x805138
  802958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802963:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802969:	a1 44 51 80 00       	mov    0x805144,%eax
  80296e:	40                   	inc    %eax
  80296f:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802977:	8b 55 08             	mov    0x8(%ebp),%edx
  80297a:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 50 08             	mov    0x8(%eax),%edx
  802983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802986:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298f:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 50 08             	mov    0x8(%eax),%edx
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	01 c2                	add    %eax,%edx
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8029a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8029a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ad:	75 17                	jne    8029c6 <alloc_block_FF+0x20c>
  8029af:	83 ec 04             	sub    $0x4,%esp
  8029b2:	68 28 42 80 00       	push   $0x804228
  8029b7:	68 a2 00 00 00       	push   $0xa2
  8029bc:	68 b7 41 80 00       	push   $0x8041b7
  8029c1:	e8 ed dc ff ff       	call   8006b3 <_panic>
  8029c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	74 10                	je     8029df <alloc_block_FF+0x225>
  8029cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d2:	8b 00                	mov    (%eax),%eax
  8029d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d7:	8b 52 04             	mov    0x4(%edx),%edx
  8029da:	89 50 04             	mov    %edx,0x4(%eax)
  8029dd:	eb 0b                	jmp    8029ea <alloc_block_FF+0x230>
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	8b 40 04             	mov    0x4(%eax),%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 0f                	je     802a03 <alloc_block_FF+0x249>
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	8b 40 04             	mov    0x4(%eax),%eax
  8029fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029fd:	8b 12                	mov    (%edx),%edx
  8029ff:	89 10                	mov    %edx,(%eax)
  802a01:	eb 0a                	jmp    802a0d <alloc_block_FF+0x253>
  802a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a06:	8b 00                	mov    (%eax),%eax
  802a08:	a3 38 51 80 00       	mov    %eax,0x805138
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a20:	a1 44 51 80 00       	mov    0x805144,%eax
  802a25:	48                   	dec    %eax
  802a26:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802a2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2e:	eb 3b                	jmp    802a6b <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802a30:	a1 40 51 80 00       	mov    0x805140,%eax
  802a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3c:	74 07                	je     802a45 <alloc_block_FF+0x28b>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	eb 05                	jmp    802a4a <alloc_block_FF+0x290>
  802a45:	b8 00 00 00 00       	mov    $0x0,%eax
  802a4a:	a3 40 51 80 00       	mov    %eax,0x805140
  802a4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	0f 85 71 fd ff ff    	jne    8027cd <alloc_block_FF+0x13>
  802a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a60:	0f 85 67 fd ff ff    	jne    8027cd <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a6b:	c9                   	leave  
  802a6c:	c3                   	ret    

00802a6d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802a6d:	55                   	push   %ebp
  802a6e:	89 e5                	mov    %esp,%ebp
  802a70:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802a73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802a7a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802a81:	a1 38 51 80 00       	mov    0x805138,%eax
  802a86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a89:	e9 d3 00 00 00       	jmp    802b61 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802a8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a97:	0f 85 90 00 00 00    	jne    802b2d <alloc_block_BF+0xc0>
	   temp = element;
  802a9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802aa3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aa7:	75 17                	jne    802ac0 <alloc_block_BF+0x53>
  802aa9:	83 ec 04             	sub    $0x4,%esp
  802aac:	68 28 42 80 00       	push   $0x804228
  802ab1:	68 bd 00 00 00       	push   $0xbd
  802ab6:	68 b7 41 80 00       	push   $0x8041b7
  802abb:	e8 f3 db ff ff       	call   8006b3 <_panic>
  802ac0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	74 10                	je     802ad9 <alloc_block_BF+0x6c>
  802ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad1:	8b 52 04             	mov    0x4(%edx),%edx
  802ad4:	89 50 04             	mov    %edx,0x4(%eax)
  802ad7:	eb 0b                	jmp    802ae4 <alloc_block_BF+0x77>
  802ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae7:	8b 40 04             	mov    0x4(%eax),%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	74 0f                	je     802afd <alloc_block_BF+0x90>
  802aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af1:	8b 40 04             	mov    0x4(%eax),%eax
  802af4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802af7:	8b 12                	mov    (%edx),%edx
  802af9:	89 10                	mov    %edx,(%eax)
  802afb:	eb 0a                	jmp    802b07 <alloc_block_BF+0x9a>
  802afd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	a3 38 51 80 00       	mov    %eax,0x805138
  802b07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1a:	a1 44 51 80 00       	mov    0x805144,%eax
  802b1f:	48                   	dec    %eax
  802b20:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802b25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b28:	e9 41 01 00 00       	jmp    802c6e <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802b2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b30:	8b 40 0c             	mov    0xc(%eax),%eax
  802b33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b36:	76 21                	jbe    802b59 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802b38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b41:	73 16                	jae    802b59 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802b43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b46:	8b 40 0c             	mov    0xc(%eax),%eax
  802b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802b52:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802b59:	a1 40 51 80 00       	mov    0x805140,%eax
  802b5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802b61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b65:	74 07                	je     802b6e <alloc_block_BF+0x101>
  802b67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	eb 05                	jmp    802b73 <alloc_block_BF+0x106>
  802b6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b73:	a3 40 51 80 00       	mov    %eax,0x805140
  802b78:	a1 40 51 80 00       	mov    0x805140,%eax
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	0f 85 09 ff ff ff    	jne    802a8e <alloc_block_BF+0x21>
  802b85:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b89:	0f 85 ff fe ff ff    	jne    802a8e <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802b8f:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802b93:	0f 85 d0 00 00 00    	jne    802c69 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9f:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802ba5:	a1 48 51 80 00       	mov    0x805148,%eax
  802baa:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802bad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802bb1:	75 17                	jne    802bca <alloc_block_BF+0x15d>
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	68 28 42 80 00       	push   $0x804228
  802bbb:	68 d1 00 00 00       	push   $0xd1
  802bc0:	68 b7 41 80 00       	push   $0x8041b7
  802bc5:	e8 e9 da ff ff       	call   8006b3 <_panic>
  802bca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bcd:	8b 00                	mov    (%eax),%eax
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	74 10                	je     802be3 <alloc_block_BF+0x176>
  802bd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bdb:	8b 52 04             	mov    0x4(%edx),%edx
  802bde:	89 50 04             	mov    %edx,0x4(%eax)
  802be1:	eb 0b                	jmp    802bee <alloc_block_BF+0x181>
  802be3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be6:	8b 40 04             	mov    0x4(%eax),%eax
  802be9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	74 0f                	je     802c07 <alloc_block_BF+0x19a>
  802bf8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfb:	8b 40 04             	mov    0x4(%eax),%eax
  802bfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c01:	8b 12                	mov    (%edx),%edx
  802c03:	89 10                	mov    %edx,(%eax)
  802c05:	eb 0a                	jmp    802c11 <alloc_block_BF+0x1a4>
  802c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	a3 48 51 80 00       	mov    %eax,0x805148
  802c11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c24:	a1 54 51 80 00       	mov    0x805154,%eax
  802c29:	48                   	dec    %eax
  802c2a:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802c2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c32:	8b 55 08             	mov    0x8(%ebp),%edx
  802c35:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	8b 50 08             	mov    0x8(%eax),%edx
  802c3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c41:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802c44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c4a:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 50 08             	mov    0x8(%eax),%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	01 c2                	add    %eax,%edx
  802c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5b:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802c5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c61:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802c64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c67:	eb 05                	jmp    802c6e <alloc_block_BF+0x201>
	 }
	 return NULL;
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802c6e:	c9                   	leave  
  802c6f:	c3                   	ret    

00802c70 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
  802c73:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802c76:	83 ec 04             	sub    $0x4,%esp
  802c79:	68 48 42 80 00       	push   $0x804248
  802c7e:	68 e8 00 00 00       	push   $0xe8
  802c83:	68 b7 41 80 00       	push   $0x8041b7
  802c88:	e8 26 da ff ff       	call   8006b3 <_panic>

00802c8d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c8d:	55                   	push   %ebp
  802c8e:	89 e5                	mov    %esp,%ebp
  802c90:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802c93:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802c9b:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802ca3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ca8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802cab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802caf:	75 68                	jne    802d19 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802cb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb5:	75 17                	jne    802cce <insert_sorted_with_merge_freeList+0x41>
  802cb7:	83 ec 04             	sub    $0x4,%esp
  802cba:	68 94 41 80 00       	push   $0x804194
  802cbf:	68 36 01 00 00       	push   $0x136
  802cc4:	68 b7 41 80 00       	push   $0x8041b7
  802cc9:	e8 e5 d9 ff ff       	call   8006b3 <_panic>
  802cce:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	89 10                	mov    %edx,(%eax)
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	8b 00                	mov    (%eax),%eax
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	74 0d                	je     802cef <insert_sorted_with_merge_freeList+0x62>
  802ce2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cea:	89 50 04             	mov    %edx,0x4(%eax)
  802ced:	eb 08                	jmp    802cf7 <insert_sorted_with_merge_freeList+0x6a>
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	a3 38 51 80 00       	mov    %eax,0x805138
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d09:	a1 44 51 80 00       	mov    0x805144,%eax
  802d0e:	40                   	inc    %eax
  802d0f:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802d14:	e9 ba 06 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1c:	8b 50 08             	mov    0x8(%eax),%edx
  802d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d22:	8b 40 0c             	mov    0xc(%eax),%eax
  802d25:	01 c2                	add    %eax,%edx
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	8b 40 08             	mov    0x8(%eax),%eax
  802d2d:	39 c2                	cmp    %eax,%edx
  802d2f:	73 68                	jae    802d99 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d35:	75 17                	jne    802d4e <insert_sorted_with_merge_freeList+0xc1>
  802d37:	83 ec 04             	sub    $0x4,%esp
  802d3a:	68 d0 41 80 00       	push   $0x8041d0
  802d3f:	68 3a 01 00 00       	push   $0x13a
  802d44:	68 b7 41 80 00       	push   $0x8041b7
  802d49:	e8 65 d9 ff ff       	call   8006b3 <_panic>
  802d4e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	89 50 04             	mov    %edx,0x4(%eax)
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	8b 40 04             	mov    0x4(%eax),%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	74 0c                	je     802d70 <insert_sorted_with_merge_freeList+0xe3>
  802d64:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d69:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6c:	89 10                	mov    %edx,(%eax)
  802d6e:	eb 08                	jmp    802d78 <insert_sorted_with_merge_freeList+0xeb>
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	a3 38 51 80 00       	mov    %eax,0x805138
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d89:	a1 44 51 80 00       	mov    0x805144,%eax
  802d8e:	40                   	inc    %eax
  802d8f:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802d94:	e9 3a 06 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9c:	8b 50 08             	mov    0x8(%eax),%edx
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	8b 40 0c             	mov    0xc(%eax),%eax
  802da5:	01 c2                	add    %eax,%edx
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	8b 40 08             	mov    0x8(%eax),%eax
  802dad:	39 c2                	cmp    %eax,%edx
  802daf:	0f 85 90 00 00 00    	jne    802e45 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc1:	01 c2                	add    %eax,%edx
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de1:	75 17                	jne    802dfa <insert_sorted_with_merge_freeList+0x16d>
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	68 94 41 80 00       	push   $0x804194
  802deb:	68 41 01 00 00       	push   $0x141
  802df0:	68 b7 41 80 00       	push   $0x8041b7
  802df5:	e8 b9 d8 ff ff       	call   8006b3 <_panic>
  802dfa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	89 10                	mov    %edx,(%eax)
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	8b 00                	mov    (%eax),%eax
  802e0a:	85 c0                	test   %eax,%eax
  802e0c:	74 0d                	je     802e1b <insert_sorted_with_merge_freeList+0x18e>
  802e0e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e13:	8b 55 08             	mov    0x8(%ebp),%edx
  802e16:	89 50 04             	mov    %edx,0x4(%eax)
  802e19:	eb 08                	jmp    802e23 <insert_sorted_with_merge_freeList+0x196>
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	a3 48 51 80 00       	mov    %eax,0x805148
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e35:	a1 54 51 80 00       	mov    0x805154,%eax
  802e3a:	40                   	inc    %eax
  802e3b:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802e40:	e9 8e 05 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e51:	01 c2                	add    %eax,%edx
  802e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e56:	8b 40 08             	mov    0x8(%eax),%eax
  802e59:	39 c2                	cmp    %eax,%edx
  802e5b:	73 68                	jae    802ec5 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802e5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e61:	75 17                	jne    802e7a <insert_sorted_with_merge_freeList+0x1ed>
  802e63:	83 ec 04             	sub    $0x4,%esp
  802e66:	68 94 41 80 00       	push   $0x804194
  802e6b:	68 45 01 00 00       	push   $0x145
  802e70:	68 b7 41 80 00       	push   $0x8041b7
  802e75:	e8 39 d8 ff ff       	call   8006b3 <_panic>
  802e7a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	89 10                	mov    %edx,(%eax)
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	85 c0                	test   %eax,%eax
  802e8c:	74 0d                	je     802e9b <insert_sorted_with_merge_freeList+0x20e>
  802e8e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e93:	8b 55 08             	mov    0x8(%ebp),%edx
  802e96:	89 50 04             	mov    %edx,0x4(%eax)
  802e99:	eb 08                	jmp    802ea3 <insert_sorted_with_merge_freeList+0x216>
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	a3 38 51 80 00       	mov    %eax,0x805138
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb5:	a1 44 51 80 00       	mov    0x805144,%eax
  802eba:	40                   	inc    %eax
  802ebb:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802ec0:	e9 0e 05 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	8b 50 08             	mov    0x8(%eax),%edx
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed1:	01 c2                	add    %eax,%edx
  802ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed6:	8b 40 08             	mov    0x8(%eax),%eax
  802ed9:	39 c2                	cmp    %eax,%edx
  802edb:	0f 85 9c 00 00 00    	jne    802f7d <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	8b 40 0c             	mov    0xc(%eax),%eax
  802eed:	01 c2                	add    %eax,%edx
  802eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef2:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	8b 50 08             	mov    0x8(%eax),%edx
  802efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efe:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f19:	75 17                	jne    802f32 <insert_sorted_with_merge_freeList+0x2a5>
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	68 94 41 80 00       	push   $0x804194
  802f23:	68 4d 01 00 00       	push   $0x14d
  802f28:	68 b7 41 80 00       	push   $0x8041b7
  802f2d:	e8 81 d7 ff ff       	call   8006b3 <_panic>
  802f32:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	89 10                	mov    %edx,(%eax)
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	8b 00                	mov    (%eax),%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	74 0d                	je     802f53 <insert_sorted_with_merge_freeList+0x2c6>
  802f46:	a1 48 51 80 00       	mov    0x805148,%eax
  802f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4e:	89 50 04             	mov    %edx,0x4(%eax)
  802f51:	eb 08                	jmp    802f5b <insert_sorted_with_merge_freeList+0x2ce>
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	a3 48 51 80 00       	mov    %eax,0x805148
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6d:	a1 54 51 80 00       	mov    0x805154,%eax
  802f72:	40                   	inc    %eax
  802f73:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802f78:	e9 56 04 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802f7d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f85:	e9 19 04 00 00       	jmp    8033a3 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f95:	8b 50 08             	mov    0x8(%eax),%edx
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9e:	01 c2                	add    %eax,%edx
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	8b 40 08             	mov    0x8(%eax),%eax
  802fa6:	39 c2                	cmp    %eax,%edx
  802fa8:	0f 85 ad 01 00 00    	jne    80315b <insert_sorted_with_merge_freeList+0x4ce>
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	8b 50 08             	mov    0x8(%eax),%edx
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fba:	01 c2                	add    %eax,%edx
  802fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbf:	8b 40 08             	mov    0x8(%eax),%eax
  802fc2:	39 c2                	cmp    %eax,%edx
  802fc4:	0f 85 91 01 00 00    	jne    80315b <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8b 50 0c             	mov    0xc(%eax),%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	8b 48 0c             	mov    0xc(%eax),%ecx
  802fd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdc:	01 c8                	add    %ecx,%eax
  802fde:	01 c2                	add    %eax,%edx
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802ffa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ffd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  803004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803007:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  80300e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803012:	75 17                	jne    80302b <insert_sorted_with_merge_freeList+0x39e>
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	68 28 42 80 00       	push   $0x804228
  80301c:	68 5b 01 00 00       	push   $0x15b
  803021:	68 b7 41 80 00       	push   $0x8041b7
  803026:	e8 88 d6 ff ff       	call   8006b3 <_panic>
  80302b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 10                	je     803044 <insert_sorted_with_merge_freeList+0x3b7>
  803034:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803037:	8b 00                	mov    (%eax),%eax
  803039:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80303c:	8b 52 04             	mov    0x4(%edx),%edx
  80303f:	89 50 04             	mov    %edx,0x4(%eax)
  803042:	eb 0b                	jmp    80304f <insert_sorted_with_merge_freeList+0x3c2>
  803044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803047:	8b 40 04             	mov    0x4(%eax),%eax
  80304a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80304f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803052:	8b 40 04             	mov    0x4(%eax),%eax
  803055:	85 c0                	test   %eax,%eax
  803057:	74 0f                	je     803068 <insert_sorted_with_merge_freeList+0x3db>
  803059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305c:	8b 40 04             	mov    0x4(%eax),%eax
  80305f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803062:	8b 12                	mov    (%edx),%edx
  803064:	89 10                	mov    %edx,(%eax)
  803066:	eb 0a                	jmp    803072 <insert_sorted_with_merge_freeList+0x3e5>
  803068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	a3 38 51 80 00       	mov    %eax,0x805138
  803072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803075:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803085:	a1 44 51 80 00       	mov    0x805144,%eax
  80308a:	48                   	dec    %eax
  80308b:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803090:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803094:	75 17                	jne    8030ad <insert_sorted_with_merge_freeList+0x420>
  803096:	83 ec 04             	sub    $0x4,%esp
  803099:	68 94 41 80 00       	push   $0x804194
  80309e:	68 5c 01 00 00       	push   $0x15c
  8030a3:	68 b7 41 80 00       	push   $0x8041b7
  8030a8:	e8 06 d6 ff ff       	call   8006b3 <_panic>
  8030ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	89 10                	mov    %edx,(%eax)
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	85 c0                	test   %eax,%eax
  8030bf:	74 0d                	je     8030ce <insert_sorted_with_merge_freeList+0x441>
  8030c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8030c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c9:	89 50 04             	mov    %edx,0x4(%eax)
  8030cc:	eb 08                	jmp    8030d6 <insert_sorted_with_merge_freeList+0x449>
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ed:	40                   	inc    %eax
  8030ee:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  8030f3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030f7:	75 17                	jne    803110 <insert_sorted_with_merge_freeList+0x483>
  8030f9:	83 ec 04             	sub    $0x4,%esp
  8030fc:	68 94 41 80 00       	push   $0x804194
  803101:	68 5d 01 00 00       	push   $0x15d
  803106:	68 b7 41 80 00       	push   $0x8041b7
  80310b:	e8 a3 d5 ff ff       	call   8006b3 <_panic>
  803110:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803119:	89 10                	mov    %edx,(%eax)
  80311b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0d                	je     803131 <insert_sorted_with_merge_freeList+0x4a4>
  803124:	a1 48 51 80 00       	mov    0x805148,%eax
  803129:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80312c:	89 50 04             	mov    %edx,0x4(%eax)
  80312f:	eb 08                	jmp    803139 <insert_sorted_with_merge_freeList+0x4ac>
  803131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803134:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313c:	a3 48 51 80 00       	mov    %eax,0x805148
  803141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314b:	a1 54 51 80 00       	mov    0x805154,%eax
  803150:	40                   	inc    %eax
  803151:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803156:	e9 78 02 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  80315b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315e:	8b 50 08             	mov    0x8(%eax),%edx
  803161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803164:	8b 40 0c             	mov    0xc(%eax),%eax
  803167:	01 c2                	add    %eax,%edx
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	8b 40 08             	mov    0x8(%eax),%eax
  80316f:	39 c2                	cmp    %eax,%edx
  803171:	0f 83 b8 00 00 00    	jae    80322f <insert_sorted_with_merge_freeList+0x5a2>
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	8b 50 08             	mov    0x8(%eax),%edx
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 40 0c             	mov    0xc(%eax),%eax
  803183:	01 c2                	add    %eax,%edx
  803185:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803188:	8b 40 08             	mov    0x8(%eax),%eax
  80318b:	39 c2                	cmp    %eax,%edx
  80318d:	0f 85 9c 00 00 00    	jne    80322f <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  803193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803196:	8b 50 0c             	mov    0xc(%eax),%edx
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	8b 40 0c             	mov    0xc(%eax),%eax
  80319f:	01 c2                	add    %eax,%edx
  8031a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a4:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	8b 50 08             	mov    0x8(%eax),%edx
  8031ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b0:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031cb:	75 17                	jne    8031e4 <insert_sorted_with_merge_freeList+0x557>
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	68 94 41 80 00       	push   $0x804194
  8031d5:	68 67 01 00 00       	push   $0x167
  8031da:	68 b7 41 80 00       	push   $0x8041b7
  8031df:	e8 cf d4 ff ff       	call   8006b3 <_panic>
  8031e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	89 10                	mov    %edx,(%eax)
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 0d                	je     803205 <insert_sorted_with_merge_freeList+0x578>
  8031f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8031fd:	8b 55 08             	mov    0x8(%ebp),%edx
  803200:	89 50 04             	mov    %edx,0x4(%eax)
  803203:	eb 08                	jmp    80320d <insert_sorted_with_merge_freeList+0x580>
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	a3 48 51 80 00       	mov    %eax,0x805148
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321f:	a1 54 51 80 00       	mov    0x805154,%eax
  803224:	40                   	inc    %eax
  803225:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  80322a:	e9 a4 01 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	8b 50 08             	mov    0x8(%eax),%edx
  803235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803238:	8b 40 0c             	mov    0xc(%eax),%eax
  80323b:	01 c2                	add    %eax,%edx
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	8b 40 08             	mov    0x8(%eax),%eax
  803243:	39 c2                	cmp    %eax,%edx
  803245:	0f 85 ac 00 00 00    	jne    8032f7 <insert_sorted_with_merge_freeList+0x66a>
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	8b 50 08             	mov    0x8(%eax),%edx
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	8b 40 0c             	mov    0xc(%eax),%eax
  803257:	01 c2                	add    %eax,%edx
  803259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325c:	8b 40 08             	mov    0x8(%eax),%eax
  80325f:	39 c2                	cmp    %eax,%edx
  803261:	0f 83 90 00 00 00    	jae    8032f7 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326a:	8b 50 0c             	mov    0xc(%eax),%edx
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	8b 40 0c             	mov    0xc(%eax),%eax
  803273:	01 c2                	add    %eax,%edx
  803275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803278:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80328f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803293:	75 17                	jne    8032ac <insert_sorted_with_merge_freeList+0x61f>
  803295:	83 ec 04             	sub    $0x4,%esp
  803298:	68 94 41 80 00       	push   $0x804194
  80329d:	68 70 01 00 00       	push   $0x170
  8032a2:	68 b7 41 80 00       	push   $0x8041b7
  8032a7:	e8 07 d4 ff ff       	call   8006b3 <_panic>
  8032ac:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	89 10                	mov    %edx,(%eax)
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	8b 00                	mov    (%eax),%eax
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	74 0d                	je     8032cd <insert_sorted_with_merge_freeList+0x640>
  8032c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c8:	89 50 04             	mov    %edx,0x4(%eax)
  8032cb:	eb 08                	jmp    8032d5 <insert_sorted_with_merge_freeList+0x648>
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e7:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ec:	40                   	inc    %eax
  8032ed:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8032f2:	e9 dc 00 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	8b 50 08             	mov    0x8(%eax),%edx
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	8b 40 0c             	mov    0xc(%eax),%eax
  803303:	01 c2                	add    %eax,%edx
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	8b 40 08             	mov    0x8(%eax),%eax
  80330b:	39 c2                	cmp    %eax,%edx
  80330d:	0f 83 88 00 00 00    	jae    80339b <insert_sorted_with_merge_freeList+0x70e>
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	8b 50 08             	mov    0x8(%eax),%edx
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	8b 40 0c             	mov    0xc(%eax),%eax
  80331f:	01 c2                	add    %eax,%edx
  803321:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803324:	8b 40 08             	mov    0x8(%eax),%eax
  803327:	39 c2                	cmp    %eax,%edx
  803329:	73 70                	jae    80339b <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80332b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332f:	74 06                	je     803337 <insert_sorted_with_merge_freeList+0x6aa>
  803331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803335:	75 17                	jne    80334e <insert_sorted_with_merge_freeList+0x6c1>
  803337:	83 ec 04             	sub    $0x4,%esp
  80333a:	68 f4 41 80 00       	push   $0x8041f4
  80333f:	68 75 01 00 00       	push   $0x175
  803344:	68 b7 41 80 00       	push   $0x8041b7
  803349:	e8 65 d3 ff ff       	call   8006b3 <_panic>
  80334e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803351:	8b 10                	mov    (%eax),%edx
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	89 10                	mov    %edx,(%eax)
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	8b 00                	mov    (%eax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	74 0b                	je     80336c <insert_sorted_with_merge_freeList+0x6df>
  803361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803364:	8b 00                	mov    (%eax),%eax
  803366:	8b 55 08             	mov    0x8(%ebp),%edx
  803369:	89 50 04             	mov    %edx,0x4(%eax)
  80336c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336f:	8b 55 08             	mov    0x8(%ebp),%edx
  803372:	89 10                	mov    %edx,(%eax)
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80337a:	89 50 04             	mov    %edx,0x4(%eax)
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	8b 00                	mov    (%eax),%eax
  803382:	85 c0                	test   %eax,%eax
  803384:	75 08                	jne    80338e <insert_sorted_with_merge_freeList+0x701>
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80338e:	a1 44 51 80 00       	mov    0x805144,%eax
  803393:	40                   	inc    %eax
  803394:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803399:	eb 38                	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80339b:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a7:	74 07                	je     8033b0 <insert_sorted_with_merge_freeList+0x723>
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 00                	mov    (%eax),%eax
  8033ae:	eb 05                	jmp    8033b5 <insert_sorted_with_merge_freeList+0x728>
  8033b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8033ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8033bf:	85 c0                	test   %eax,%eax
  8033c1:	0f 85 c3 fb ff ff    	jne    802f8a <insert_sorted_with_merge_freeList+0x2fd>
  8033c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033cb:	0f 85 b9 fb ff ff    	jne    802f8a <insert_sorted_with_merge_freeList+0x2fd>





}
  8033d1:	eb 00                	jmp    8033d3 <insert_sorted_with_merge_freeList+0x746>
  8033d3:	90                   	nop
  8033d4:	c9                   	leave  
  8033d5:	c3                   	ret    
  8033d6:	66 90                	xchg   %ax,%ax

008033d8 <__udivdi3>:
  8033d8:	55                   	push   %ebp
  8033d9:	57                   	push   %edi
  8033da:	56                   	push   %esi
  8033db:	53                   	push   %ebx
  8033dc:	83 ec 1c             	sub    $0x1c,%esp
  8033df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033ef:	89 ca                	mov    %ecx,%edx
  8033f1:	89 f8                	mov    %edi,%eax
  8033f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033f7:	85 f6                	test   %esi,%esi
  8033f9:	75 2d                	jne    803428 <__udivdi3+0x50>
  8033fb:	39 cf                	cmp    %ecx,%edi
  8033fd:	77 65                	ja     803464 <__udivdi3+0x8c>
  8033ff:	89 fd                	mov    %edi,%ebp
  803401:	85 ff                	test   %edi,%edi
  803403:	75 0b                	jne    803410 <__udivdi3+0x38>
  803405:	b8 01 00 00 00       	mov    $0x1,%eax
  80340a:	31 d2                	xor    %edx,%edx
  80340c:	f7 f7                	div    %edi
  80340e:	89 c5                	mov    %eax,%ebp
  803410:	31 d2                	xor    %edx,%edx
  803412:	89 c8                	mov    %ecx,%eax
  803414:	f7 f5                	div    %ebp
  803416:	89 c1                	mov    %eax,%ecx
  803418:	89 d8                	mov    %ebx,%eax
  80341a:	f7 f5                	div    %ebp
  80341c:	89 cf                	mov    %ecx,%edi
  80341e:	89 fa                	mov    %edi,%edx
  803420:	83 c4 1c             	add    $0x1c,%esp
  803423:	5b                   	pop    %ebx
  803424:	5e                   	pop    %esi
  803425:	5f                   	pop    %edi
  803426:	5d                   	pop    %ebp
  803427:	c3                   	ret    
  803428:	39 ce                	cmp    %ecx,%esi
  80342a:	77 28                	ja     803454 <__udivdi3+0x7c>
  80342c:	0f bd fe             	bsr    %esi,%edi
  80342f:	83 f7 1f             	xor    $0x1f,%edi
  803432:	75 40                	jne    803474 <__udivdi3+0x9c>
  803434:	39 ce                	cmp    %ecx,%esi
  803436:	72 0a                	jb     803442 <__udivdi3+0x6a>
  803438:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80343c:	0f 87 9e 00 00 00    	ja     8034e0 <__udivdi3+0x108>
  803442:	b8 01 00 00 00       	mov    $0x1,%eax
  803447:	89 fa                	mov    %edi,%edx
  803449:	83 c4 1c             	add    $0x1c,%esp
  80344c:	5b                   	pop    %ebx
  80344d:	5e                   	pop    %esi
  80344e:	5f                   	pop    %edi
  80344f:	5d                   	pop    %ebp
  803450:	c3                   	ret    
  803451:	8d 76 00             	lea    0x0(%esi),%esi
  803454:	31 ff                	xor    %edi,%edi
  803456:	31 c0                	xor    %eax,%eax
  803458:	89 fa                	mov    %edi,%edx
  80345a:	83 c4 1c             	add    $0x1c,%esp
  80345d:	5b                   	pop    %ebx
  80345e:	5e                   	pop    %esi
  80345f:	5f                   	pop    %edi
  803460:	5d                   	pop    %ebp
  803461:	c3                   	ret    
  803462:	66 90                	xchg   %ax,%ax
  803464:	89 d8                	mov    %ebx,%eax
  803466:	f7 f7                	div    %edi
  803468:	31 ff                	xor    %edi,%edi
  80346a:	89 fa                	mov    %edi,%edx
  80346c:	83 c4 1c             	add    $0x1c,%esp
  80346f:	5b                   	pop    %ebx
  803470:	5e                   	pop    %esi
  803471:	5f                   	pop    %edi
  803472:	5d                   	pop    %ebp
  803473:	c3                   	ret    
  803474:	bd 20 00 00 00       	mov    $0x20,%ebp
  803479:	89 eb                	mov    %ebp,%ebx
  80347b:	29 fb                	sub    %edi,%ebx
  80347d:	89 f9                	mov    %edi,%ecx
  80347f:	d3 e6                	shl    %cl,%esi
  803481:	89 c5                	mov    %eax,%ebp
  803483:	88 d9                	mov    %bl,%cl
  803485:	d3 ed                	shr    %cl,%ebp
  803487:	89 e9                	mov    %ebp,%ecx
  803489:	09 f1                	or     %esi,%ecx
  80348b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80348f:	89 f9                	mov    %edi,%ecx
  803491:	d3 e0                	shl    %cl,%eax
  803493:	89 c5                	mov    %eax,%ebp
  803495:	89 d6                	mov    %edx,%esi
  803497:	88 d9                	mov    %bl,%cl
  803499:	d3 ee                	shr    %cl,%esi
  80349b:	89 f9                	mov    %edi,%ecx
  80349d:	d3 e2                	shl    %cl,%edx
  80349f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a3:	88 d9                	mov    %bl,%cl
  8034a5:	d3 e8                	shr    %cl,%eax
  8034a7:	09 c2                	or     %eax,%edx
  8034a9:	89 d0                	mov    %edx,%eax
  8034ab:	89 f2                	mov    %esi,%edx
  8034ad:	f7 74 24 0c          	divl   0xc(%esp)
  8034b1:	89 d6                	mov    %edx,%esi
  8034b3:	89 c3                	mov    %eax,%ebx
  8034b5:	f7 e5                	mul    %ebp
  8034b7:	39 d6                	cmp    %edx,%esi
  8034b9:	72 19                	jb     8034d4 <__udivdi3+0xfc>
  8034bb:	74 0b                	je     8034c8 <__udivdi3+0xf0>
  8034bd:	89 d8                	mov    %ebx,%eax
  8034bf:	31 ff                	xor    %edi,%edi
  8034c1:	e9 58 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034cc:	89 f9                	mov    %edi,%ecx
  8034ce:	d3 e2                	shl    %cl,%edx
  8034d0:	39 c2                	cmp    %eax,%edx
  8034d2:	73 e9                	jae    8034bd <__udivdi3+0xe5>
  8034d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034d7:	31 ff                	xor    %edi,%edi
  8034d9:	e9 40 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034de:	66 90                	xchg   %ax,%ax
  8034e0:	31 c0                	xor    %eax,%eax
  8034e2:	e9 37 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034e7:	90                   	nop

008034e8 <__umoddi3>:
  8034e8:	55                   	push   %ebp
  8034e9:	57                   	push   %edi
  8034ea:	56                   	push   %esi
  8034eb:	53                   	push   %ebx
  8034ec:	83 ec 1c             	sub    $0x1c,%esp
  8034ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803503:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803507:	89 f3                	mov    %esi,%ebx
  803509:	89 fa                	mov    %edi,%edx
  80350b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80350f:	89 34 24             	mov    %esi,(%esp)
  803512:	85 c0                	test   %eax,%eax
  803514:	75 1a                	jne    803530 <__umoddi3+0x48>
  803516:	39 f7                	cmp    %esi,%edi
  803518:	0f 86 a2 00 00 00    	jbe    8035c0 <__umoddi3+0xd8>
  80351e:	89 c8                	mov    %ecx,%eax
  803520:	89 f2                	mov    %esi,%edx
  803522:	f7 f7                	div    %edi
  803524:	89 d0                	mov    %edx,%eax
  803526:	31 d2                	xor    %edx,%edx
  803528:	83 c4 1c             	add    $0x1c,%esp
  80352b:	5b                   	pop    %ebx
  80352c:	5e                   	pop    %esi
  80352d:	5f                   	pop    %edi
  80352e:	5d                   	pop    %ebp
  80352f:	c3                   	ret    
  803530:	39 f0                	cmp    %esi,%eax
  803532:	0f 87 ac 00 00 00    	ja     8035e4 <__umoddi3+0xfc>
  803538:	0f bd e8             	bsr    %eax,%ebp
  80353b:	83 f5 1f             	xor    $0x1f,%ebp
  80353e:	0f 84 ac 00 00 00    	je     8035f0 <__umoddi3+0x108>
  803544:	bf 20 00 00 00       	mov    $0x20,%edi
  803549:	29 ef                	sub    %ebp,%edi
  80354b:	89 fe                	mov    %edi,%esi
  80354d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803551:	89 e9                	mov    %ebp,%ecx
  803553:	d3 e0                	shl    %cl,%eax
  803555:	89 d7                	mov    %edx,%edi
  803557:	89 f1                	mov    %esi,%ecx
  803559:	d3 ef                	shr    %cl,%edi
  80355b:	09 c7                	or     %eax,%edi
  80355d:	89 e9                	mov    %ebp,%ecx
  80355f:	d3 e2                	shl    %cl,%edx
  803561:	89 14 24             	mov    %edx,(%esp)
  803564:	89 d8                	mov    %ebx,%eax
  803566:	d3 e0                	shl    %cl,%eax
  803568:	89 c2                	mov    %eax,%edx
  80356a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356e:	d3 e0                	shl    %cl,%eax
  803570:	89 44 24 04          	mov    %eax,0x4(%esp)
  803574:	8b 44 24 08          	mov    0x8(%esp),%eax
  803578:	89 f1                	mov    %esi,%ecx
  80357a:	d3 e8                	shr    %cl,%eax
  80357c:	09 d0                	or     %edx,%eax
  80357e:	d3 eb                	shr    %cl,%ebx
  803580:	89 da                	mov    %ebx,%edx
  803582:	f7 f7                	div    %edi
  803584:	89 d3                	mov    %edx,%ebx
  803586:	f7 24 24             	mull   (%esp)
  803589:	89 c6                	mov    %eax,%esi
  80358b:	89 d1                	mov    %edx,%ecx
  80358d:	39 d3                	cmp    %edx,%ebx
  80358f:	0f 82 87 00 00 00    	jb     80361c <__umoddi3+0x134>
  803595:	0f 84 91 00 00 00    	je     80362c <__umoddi3+0x144>
  80359b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80359f:	29 f2                	sub    %esi,%edx
  8035a1:	19 cb                	sbb    %ecx,%ebx
  8035a3:	89 d8                	mov    %ebx,%eax
  8035a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035a9:	d3 e0                	shl    %cl,%eax
  8035ab:	89 e9                	mov    %ebp,%ecx
  8035ad:	d3 ea                	shr    %cl,%edx
  8035af:	09 d0                	or     %edx,%eax
  8035b1:	89 e9                	mov    %ebp,%ecx
  8035b3:	d3 eb                	shr    %cl,%ebx
  8035b5:	89 da                	mov    %ebx,%edx
  8035b7:	83 c4 1c             	add    $0x1c,%esp
  8035ba:	5b                   	pop    %ebx
  8035bb:	5e                   	pop    %esi
  8035bc:	5f                   	pop    %edi
  8035bd:	5d                   	pop    %ebp
  8035be:	c3                   	ret    
  8035bf:	90                   	nop
  8035c0:	89 fd                	mov    %edi,%ebp
  8035c2:	85 ff                	test   %edi,%edi
  8035c4:	75 0b                	jne    8035d1 <__umoddi3+0xe9>
  8035c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035cb:	31 d2                	xor    %edx,%edx
  8035cd:	f7 f7                	div    %edi
  8035cf:	89 c5                	mov    %eax,%ebp
  8035d1:	89 f0                	mov    %esi,%eax
  8035d3:	31 d2                	xor    %edx,%edx
  8035d5:	f7 f5                	div    %ebp
  8035d7:	89 c8                	mov    %ecx,%eax
  8035d9:	f7 f5                	div    %ebp
  8035db:	89 d0                	mov    %edx,%eax
  8035dd:	e9 44 ff ff ff       	jmp    803526 <__umoddi3+0x3e>
  8035e2:	66 90                	xchg   %ax,%ax
  8035e4:	89 c8                	mov    %ecx,%eax
  8035e6:	89 f2                	mov    %esi,%edx
  8035e8:	83 c4 1c             	add    $0x1c,%esp
  8035eb:	5b                   	pop    %ebx
  8035ec:	5e                   	pop    %esi
  8035ed:	5f                   	pop    %edi
  8035ee:	5d                   	pop    %ebp
  8035ef:	c3                   	ret    
  8035f0:	3b 04 24             	cmp    (%esp),%eax
  8035f3:	72 06                	jb     8035fb <__umoddi3+0x113>
  8035f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035f9:	77 0f                	ja     80360a <__umoddi3+0x122>
  8035fb:	89 f2                	mov    %esi,%edx
  8035fd:	29 f9                	sub    %edi,%ecx
  8035ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803603:	89 14 24             	mov    %edx,(%esp)
  803606:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80360a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80360e:	8b 14 24             	mov    (%esp),%edx
  803611:	83 c4 1c             	add    $0x1c,%esp
  803614:	5b                   	pop    %ebx
  803615:	5e                   	pop    %esi
  803616:	5f                   	pop    %edi
  803617:	5d                   	pop    %ebp
  803618:	c3                   	ret    
  803619:	8d 76 00             	lea    0x0(%esi),%esi
  80361c:	2b 04 24             	sub    (%esp),%eax
  80361f:	19 fa                	sbb    %edi,%edx
  803621:	89 d1                	mov    %edx,%ecx
  803623:	89 c6                	mov    %eax,%esi
  803625:	e9 71 ff ff ff       	jmp    80359b <__umoddi3+0xb3>
  80362a:	66 90                	xchg   %ax,%ax
  80362c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803630:	72 ea                	jb     80361c <__umoddi3+0x134>
  803632:	89 d9                	mov    %ebx,%ecx
  803634:	e9 62 ff ff ff       	jmp    80359b <__umoddi3+0xb3>
