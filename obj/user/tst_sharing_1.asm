
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 27 03 00 00       	call   80035d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80008d:	68 20 34 80 00       	push   $0x803420
  800092:	6a 12                	push   $0x12
  800094:	68 3c 34 80 00       	push   $0x80343c
  800099:	e8 fb 03 00 00       	call   800499 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 1e 16 00 00       	call   8016c6 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 54 34 80 00       	push   $0x803454
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 45 1a 00 00       	call   801b05 <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 8b 34 80 00       	push   $0x80348b
  8000d2:	e8 6b 17 00 00       	call   801842 <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 90 34 80 00       	push   $0x803490
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 3c 34 80 00       	push   $0x80343c
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 fc 19 00 00       	call   801b05 <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 eb 19 00 00       	call   801b05 <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 fc 34 80 00       	push   $0x8034fc
  80012a:	6a 20                	push   $0x20
  80012c:	68 3c 34 80 00       	push   $0x80343c
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 ca 19 00 00       	call   801b05 <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 94 35 80 00       	push   $0x803594
  80014d:	e8 f0 16 00 00       	call   801842 <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 90 34 80 00       	push   $0x803490
  800169:	6a 24                	push   $0x24
  80016b:	68 3c 34 80 00       	push   $0x80343c
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 88 19 00 00       	call   801b05 <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 98 35 80 00       	push   $0x803598
  80018e:	6a 25                	push   $0x25
  800190:	68 3c 34 80 00       	push   $0x80343c
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 66 19 00 00       	call   801b05 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 16 36 80 00       	push   $0x803616
  8001ae:	e8 8f 16 00 00       	call   801842 <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 90 34 80 00       	push   $0x803490
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 3c 34 80 00       	push   $0x80343c
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 27 19 00 00       	call   801b05 <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 98 35 80 00       	push   $0x803598
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 3c 34 80 00       	push   $0x80343c
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 18 36 80 00       	push   $0x803618
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 40 36 80 00       	push   $0x803640
  800213:	e8 35 05 00 00       	call   80074d <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800222:	eb 2d                	jmp    800251 <_main+0x219>
		{
			x[i] = -1;
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80022e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800231:	01 d0                	add    %edx,%eax
  800233:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800243:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  80024e:	ff 45 ec             	incl   -0x14(%ebp)
  800251:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800258:	7e ca                	jle    800224 <_main+0x1ec>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800261:	eb 18                	jmp    80027b <_main+0x243>
		{
			z[i] = -1;
  800263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800270:	01 d0                	add    %edx,%eax
  800272:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800278:	ff 45 ec             	incl   -0x14(%ebp)
  80027b:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800282:	7e df                	jle    800263 <_main+0x22b>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	83 f8 ff             	cmp    $0xffffffff,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 68 36 80 00       	push   $0x803668
  800296:	6a 3e                	push   $0x3e
  800298:	68 3c 34 80 00       	push   $0x80343c
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 68 36 80 00       	push   $0x803668
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 3c 34 80 00       	push   $0x80343c
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 68 36 80 00       	push   $0x803668
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 3c 34 80 00       	push   $0x80343c
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 68 36 80 00       	push   $0x803668
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 3c 34 80 00       	push   $0x80343c
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 68 36 80 00       	push   $0x803668
  800318:	6a 44                	push   $0x44
  80031a:	68 3c 34 80 00       	push   $0x80343c
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 68 36 80 00       	push   $0x803668
  80033b:	6a 45                	push   $0x45
  80033d:	68 3c 34 80 00       	push   $0x80343c
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 94 36 80 00       	push   $0x803694
  80034f:	e8 f9 03 00 00       	call   80074d <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp

	return;
  800357:	90                   	nop
}
  800358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800363:	e8 7d 1a 00 00       	call   801de5 <sys_getenvindex>
  800368:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80036b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80036e:	89 d0                	mov    %edx,%eax
  800370:	c1 e0 03             	shl    $0x3,%eax
  800373:	01 d0                	add    %edx,%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	c1 e0 04             	shl    $0x4,%eax
  800385:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80038a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80038f:	a1 20 40 80 00       	mov    0x804020,%eax
  800394:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80039a:	84 c0                	test   %al,%al
  80039c:	74 0f                	je     8003ad <libmain+0x50>
		binaryname = myEnv->prog_name;
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b1:	7e 0a                	jle    8003bd <libmain+0x60>
		binaryname = argv[0];
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 6d fc ff ff       	call   800038 <_main>
  8003cb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003ce:	e8 1f 18 00 00       	call   801bf2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 00 37 80 00       	push   $0x803700
  8003db:	e8 6d 03 00 00       	call   80074d <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	52                   	push   %edx
  8003fd:	50                   	push   %eax
  8003fe:	68 28 37 80 00       	push   $0x803728
  800403:	e8 45 03 00 00       	call   80074d <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800416:	a1 20 40 80 00       	mov    0x804020,%eax
  80041b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80042c:	51                   	push   %ecx
  80042d:	52                   	push   %edx
  80042e:	50                   	push   %eax
  80042f:	68 50 37 80 00       	push   $0x803750
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 a8 37 80 00       	push   $0x8037a8
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 00 37 80 00       	push   $0x803700
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 9f 17 00 00       	call   801c0c <sys_enable_interrupt>

	// exit gracefully
	exit();
  80046d:	e8 19 00 00 00       	call   80048b <exit>
}
  800472:	90                   	nop
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	6a 00                	push   $0x0
  800480:	e8 2c 19 00 00       	call   801db1 <sys_destroy_env>
  800485:	83 c4 10             	add    $0x10,%esp
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <exit>:

void
exit(void)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800491:	e8 81 19 00 00       	call   801e17 <sys_exit_env>
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80049f:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a2:	83 c0 04             	add    $0x4,%eax
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	74 16                	je     8004c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b1:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	50                   	push   %eax
  8004ba:	68 bc 37 80 00       	push   $0x8037bc
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 c1 37 80 00       	push   $0x8037c1
  8004d8:	e8 70 02 00 00       	call   80074d <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e9:	50                   	push   %eax
  8004ea:	e8 f3 01 00 00       	call   8006e2 <vcprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	6a 00                	push   $0x0
  8004f7:	68 dd 37 80 00       	push   $0x8037dd
  8004fc:	e8 e1 01 00 00       	call   8006e2 <vcprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800504:	e8 82 ff ff ff       	call   80048b <exit>

	// should not return here
	while (1) ;
  800509:	eb fe                	jmp    800509 <_panic+0x70>

0080050b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800511:	a1 20 40 80 00       	mov    0x804020,%eax
  800516:	8b 50 74             	mov    0x74(%eax),%edx
  800519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 e0 37 80 00       	push   $0x8037e0
  800528:	6a 26                	push   $0x26
  80052a:	68 2c 38 80 00       	push   $0x80382c
  80052f:	e8 65 ff ff ff       	call   800499 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800542:	e9 c2 00 00 00       	jmp    800609 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	01 d0                	add    %edx,%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	85 c0                	test   %eax,%eax
  80055a:	75 08                	jne    800564 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80055c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80055f:	e9 a2 00 00 00       	jmp    800606 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800572:	eb 69                	jmp    8005dd <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800574:	a1 20 40 80 00       	mov    0x804020,%eax
  800579:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80057f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800582:	89 d0                	mov    %edx,%eax
  800584:	01 c0                	add    %eax,%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c1 e0 03             	shl    $0x3,%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8a 40 04             	mov    0x4(%eax),%al
  800590:	84 c0                	test   %al,%al
  800592:	75 46                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800594:	a1 20 40 80 00       	mov    0x804020,%eax
  800599:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80059f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a2:	89 d0                	mov    %edx,%eax
  8005a4:	01 c0                	add    %eax,%eax
  8005a6:	01 d0                	add    %edx,%eax
  8005a8:	c1 e0 03             	shl    $0x3,%eax
  8005ab:	01 c8                	add    %ecx,%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ba:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	01 c8                	add    %ecx,%eax
  8005cb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	75 09                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d8:	eb 12                	jmp    8005ec <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e2:	8b 50 74             	mov    0x74(%eax),%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	77 88                	ja     800574 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f0:	75 14                	jne    800606 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 38 38 80 00       	push   $0x803838
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 2c 38 80 00       	push   $0x80382c
  800601:	e8 93 fe ff ff       	call   800499 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800606:	ff 45 f0             	incl   -0x10(%ebp)
  800609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80060f:	0f 8c 32 ff ff ff    	jl     800547 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800615:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800623:	eb 26                	jmp    80064b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800625:	a1 20 40 80 00       	mov    0x804020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	3c 01                	cmp    $0x1,%al
  800643:	75 03                	jne    800648 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800645:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	ff 45 e0             	incl   -0x20(%ebp)
  80064b:	a1 20 40 80 00       	mov    0x804020,%eax
  800650:	8b 50 74             	mov    0x74(%eax),%edx
  800653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	77 cb                	ja     800625 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800660:	74 14                	je     800676 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 8c 38 80 00       	push   $0x80388c
  80066a:	6a 44                	push   $0x44
  80066c:	68 2c 38 80 00       	push   $0x80382c
  800671:	e8 23 fe ff ff       	call   800499 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800676:	90                   	nop
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	8d 48 01             	lea    0x1(%eax),%ecx
  800687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068a:	89 0a                	mov    %ecx,(%edx)
  80068c:	8b 55 08             	mov    0x8(%ebp),%edx
  80068f:	88 d1                	mov    %dl,%cl
  800691:	8b 55 0c             	mov    0xc(%ebp),%edx
  800694:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a2:	75 2c                	jne    8006d0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006a4:	a0 24 40 80 00       	mov    0x804024,%al
  8006a9:	0f b6 c0             	movzbl %al,%eax
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	8b 12                	mov    (%edx),%edx
  8006b1:	89 d1                	mov    %edx,%ecx
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	83 c2 08             	add    $0x8,%edx
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	50                   	push   %eax
  8006bd:	51                   	push   %ecx
  8006be:	52                   	push   %edx
  8006bf:	e8 80 13 00 00       	call   801a44 <sys_cputs>
  8006c4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d3:	8b 40 04             	mov    0x4(%eax),%eax
  8006d6:	8d 50 01             	lea    0x1(%eax),%edx
  8006d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006df:	90                   	nop
  8006e0:	c9                   	leave  
  8006e1:	c3                   	ret    

008006e2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f2:	00 00 00 
	b.cnt = 0;
  8006f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	ff 75 08             	pushl  0x8(%ebp)
  800705:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	68 79 06 80 00       	push   $0x800679
  800711:	e8 11 02 00 00       	call   800927 <vprintfmt>
  800716:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800719:	a0 24 40 80 00       	mov    0x804024,%al
  80071e:	0f b6 c0             	movzbl %al,%eax
  800721:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	50                   	push   %eax
  80072b:	52                   	push   %edx
  80072c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800732:	83 c0 08             	add    $0x8,%eax
  800735:	50                   	push   %eax
  800736:	e8 09 13 00 00       	call   801a44 <sys_cputs>
  80073b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800745:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <cprintf>:

int cprintf(const char *fmt, ...) {
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800753:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80075a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 f4             	pushl  -0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	e8 73 ff ff ff       	call   8006e2 <vcprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800780:	e8 6d 14 00 00       	call   801bf2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800785:	8d 45 0c             	lea    0xc(%ebp),%eax
  800788:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 f4             	pushl  -0xc(%ebp)
  800794:	50                   	push   %eax
  800795:	e8 48 ff ff ff       	call   8006e2 <vcprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007a0:	e8 67 14 00 00       	call   801c0c <sys_enable_interrupt>
	return cnt;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	53                   	push   %ebx
  8007ae:	83 ec 14             	sub    $0x14,%esp
  8007b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c8:	77 55                	ja     80081f <printnum+0x75>
  8007ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cd:	72 05                	jb     8007d4 <printnum+0x2a>
  8007cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d2:	77 4b                	ja     80081f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007da:	8b 45 18             	mov    0x18(%ebp),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	52                   	push   %edx
  8007e3:	50                   	push   %eax
  8007e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ea:	e8 cd 29 00 00       	call   8031bc <__udivdi3>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	83 ec 04             	sub    $0x4,%esp
  8007f5:	ff 75 20             	pushl  0x20(%ebp)
  8007f8:	53                   	push   %ebx
  8007f9:	ff 75 18             	pushl  0x18(%ebp)
  8007fc:	52                   	push   %edx
  8007fd:	50                   	push   %eax
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 a1 ff ff ff       	call   8007aa <printnum>
  800809:	83 c4 20             	add    $0x20,%esp
  80080c:	eb 1a                	jmp    800828 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 20             	pushl  0x20(%ebp)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80081f:	ff 4d 1c             	decl   0x1c(%ebp)
  800822:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800826:	7f e6                	jg     80080e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800828:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800836:	53                   	push   %ebx
  800837:	51                   	push   %ecx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	e8 8d 2a 00 00       	call   8032cc <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 f4 3a 80 00       	add    $0x803af4,%eax
  800847:	8a 00                	mov    (%eax),%al
  800849:	0f be c0             	movsbl %al,%eax
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
}
  80085b:	90                   	nop
  80085c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800864:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800868:	7e 1c                	jle    800886 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	8d 50 08             	lea    0x8(%eax),%edx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	89 10                	mov    %edx,(%eax)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	83 e8 08             	sub    $0x8,%eax
  80087f:	8b 50 04             	mov    0x4(%eax),%edx
  800882:	8b 00                	mov    (%eax),%eax
  800884:	eb 40                	jmp    8008c6 <getuint+0x65>
	else if (lflag)
  800886:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088a:	74 1e                	je     8008aa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 04             	lea    0x4(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a8:	eb 1c                	jmp    8008c6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 50 04             	lea    0x4(%eax),%edx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	89 10                	mov    %edx,(%eax)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cf:	7e 1c                	jle    8008ed <getint+0x25>
		return va_arg(*ap, long long);
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 50 08             	lea    0x8(%eax),%edx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	89 10                	mov    %edx,(%eax)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	83 e8 08             	sub    $0x8,%eax
  8008e6:	8b 50 04             	mov    0x4(%eax),%edx
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	eb 38                	jmp    800925 <getint+0x5d>
	else if (lflag)
  8008ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f1:	74 1a                	je     80090d <getint+0x45>
		return va_arg(*ap, long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 04             	lea    0x4(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 04             	sub    $0x4,%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	99                   	cltd   
  80090b:	eb 18                	jmp    800925 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	99                   	cltd   
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
  80092c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092f:	eb 17                	jmp    800948 <vprintfmt+0x21>
			if (ch == '\0')
  800931:	85 db                	test   %ebx,%ebx
  800933:	0f 84 af 03 00 00    	je     800ce8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	53                   	push   %ebx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	8d 50 01             	lea    0x1(%eax),%edx
  80094e:	89 55 10             	mov    %edx,0x10(%ebp)
  800951:	8a 00                	mov    (%eax),%al
  800953:	0f b6 d8             	movzbl %al,%ebx
  800956:	83 fb 25             	cmp    $0x25,%ebx
  800959:	75 d6                	jne    800931 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80095f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800966:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80096d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800974:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097b:	8b 45 10             	mov    0x10(%ebp),%eax
  80097e:	8d 50 01             	lea    0x1(%eax),%edx
  800981:	89 55 10             	mov    %edx,0x10(%ebp)
  800984:	8a 00                	mov    (%eax),%al
  800986:	0f b6 d8             	movzbl %al,%ebx
  800989:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80098c:	83 f8 55             	cmp    $0x55,%eax
  80098f:	0f 87 2b 03 00 00    	ja     800cc0 <vprintfmt+0x399>
  800995:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
  80099c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80099e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a2:	eb d7                	jmp    80097b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a8:	eb d1                	jmp    80097b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b4:	89 d0                	mov    %edx,%eax
  8009b6:	c1 e0 02             	shl    $0x2,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d8                	add    %ebx,%eax
  8009bf:	83 e8 30             	sub    $0x30,%eax
  8009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d0:	7e 3e                	jle    800a10 <vprintfmt+0xe9>
  8009d2:	83 fb 39             	cmp    $0x39,%ebx
  8009d5:	7f 39                	jg     800a10 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009da:	eb d5                	jmp    8009b1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	83 c0 04             	add    $0x4,%eax
  8009e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e8:	83 e8 04             	sub    $0x4,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f0:	eb 1f                	jmp    800a11 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f6:	79 83                	jns    80097b <vprintfmt+0x54>
				width = 0;
  8009f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ff:	e9 77 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a04:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0b:	e9 6b ff ff ff       	jmp    80097b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a10:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a15:	0f 89 60 ff ff ff    	jns    80097b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a21:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a28:	e9 4e ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a2d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a30:	e9 46 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	50                   	push   %eax
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
			break;
  800a55:	e9 89 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	83 c0 04             	add    $0x4,%eax
  800a60:	89 45 14             	mov    %eax,0x14(%ebp)
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 e8 04             	sub    $0x4,%eax
  800a69:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6b:	85 db                	test   %ebx,%ebx
  800a6d:	79 02                	jns    800a71 <vprintfmt+0x14a>
				err = -err;
  800a6f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a71:	83 fb 64             	cmp    $0x64,%ebx
  800a74:	7f 0b                	jg     800a81 <vprintfmt+0x15a>
  800a76:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 05 3b 80 00       	push   $0x803b05
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 08             	pushl  0x8(%ebp)
  800a8d:	e8 5e 02 00 00       	call   800cf0 <printfmt>
  800a92:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a95:	e9 49 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9a:	56                   	push   %esi
  800a9b:	68 0e 3b 80 00       	push   $0x803b0e
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 45 02 00 00       	call   800cf0 <printfmt>
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 30 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 30                	mov    (%eax),%esi
  800ac4:	85 f6                	test   %esi,%esi
  800ac6:	75 05                	jne    800acd <vprintfmt+0x1a6>
				p = "(null)";
  800ac8:	be 11 3b 80 00       	mov    $0x803b11,%esi
			if (width > 0 && padc != '-')
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7e 6d                	jle    800b40 <vprintfmt+0x219>
  800ad3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad7:	74 67                	je     800b40 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	50                   	push   %eax
  800ae0:	56                   	push   %esi
  800ae1:	e8 0c 03 00 00       	call   800df2 <strnlen>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aec:	eb 16                	jmp    800b04 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aee:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	50                   	push   %eax
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	ff 4d e4             	decl   -0x1c(%ebp)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	7f e4                	jg     800aee <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0a:	eb 34                	jmp    800b40 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b10:	74 1c                	je     800b2e <vprintfmt+0x207>
  800b12:	83 fb 1f             	cmp    $0x1f,%ebx
  800b15:	7e 05                	jle    800b1c <vprintfmt+0x1f5>
  800b17:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1a:	7e 12                	jle    800b2e <vprintfmt+0x207>
					putch('?', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 3f                	push   $0x3f
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	eb 0f                	jmp    800b3d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	53                   	push   %ebx
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	ff d0                	call   *%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b40:	89 f0                	mov    %esi,%eax
  800b42:	8d 70 01             	lea    0x1(%eax),%esi
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	0f be d8             	movsbl %al,%ebx
  800b4a:	85 db                	test   %ebx,%ebx
  800b4c:	74 24                	je     800b72 <vprintfmt+0x24b>
  800b4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b52:	78 b8                	js     800b0c <vprintfmt+0x1e5>
  800b54:	ff 4d e0             	decl   -0x20(%ebp)
  800b57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5b:	79 af                	jns    800b0c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5d:	eb 13                	jmp    800b72 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 20                	push   $0x20
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b76:	7f e7                	jg     800b5f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b78:	e9 66 01 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 e8             	pushl  -0x18(%ebp)
  800b83:	8d 45 14             	lea    0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	e8 3c fd ff ff       	call   8008c8 <getint>
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9b:	85 d2                	test   %edx,%edx
  800b9d:	79 23                	jns    800bc2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	6a 2d                	push   $0x2d
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	ff d0                	call   *%eax
  800bac:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb5:	f7 d8                	neg    %eax
  800bb7:	83 d2 00             	adc    $0x0,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc9:	e9 bc 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 84 fc ff ff       	call   800861 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bed:	e9 98 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	6a 58                	push   $0x58
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	ff d0                	call   *%eax
  800c1f:	83 c4 10             	add    $0x10,%esp
			break;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 30                	push   $0x30
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	6a 78                	push   $0x78
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	83 c0 04             	add    $0x4,%eax
  800c4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c50:	8b 45 14             	mov    0x14(%ebp),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c69:	eb 1f                	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c71:	8d 45 14             	lea    0x14(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	e8 e7 fb ff ff       	call   800861 <getuint>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c83:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c91:	83 ec 04             	sub    $0x4,%esp
  800c94:	52                   	push   %edx
  800c95:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c98:	50                   	push   %eax
  800c99:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	ff 75 08             	pushl  0x8(%ebp)
  800ca5:	e8 00 fb ff ff       	call   8007aa <printnum>
  800caa:	83 c4 20             	add    $0x20,%esp
			break;
  800cad:	eb 34                	jmp    800ce3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	eb 23                	jmp    800ce3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	6a 25                	push   $0x25
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
  800ccd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	eb 03                	jmp    800cd8 <vprintfmt+0x3b1>
  800cd5:	ff 4d 10             	decl   0x10(%ebp)
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	48                   	dec    %eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	3c 25                	cmp    $0x25,%al
  800ce0:	75 f3                	jne    800cd5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ce2:	90                   	nop
		}
	}
  800ce3:	e9 47 fc ff ff       	jmp    80092f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf6:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf9:	83 c0 04             	add    $0x4,%eax
  800cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	ff 75 f4             	pushl  -0xc(%ebp)
  800d05:	50                   	push   %eax
  800d06:	ff 75 0c             	pushl  0xc(%ebp)
  800d09:	ff 75 08             	pushl  0x8(%ebp)
  800d0c:	e8 16 fc ff ff       	call   800927 <vprintfmt>
  800d11:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d14:	90                   	nop
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8b 40 08             	mov    0x8(%eax),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8b 10                	mov    (%eax),%edx
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 40 04             	mov    0x4(%eax),%eax
  800d34:	39 c2                	cmp    %eax,%edx
  800d36:	73 12                	jae    800d4a <sprintputch+0x33>
		*b->buf++ = ch;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d43:	89 0a                	mov    %ecx,(%edx)
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	88 10                	mov    %dl,(%eax)
}
  800d4a:	90                   	nop
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	01 d0                	add    %edx,%eax
  800d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d72:	74 06                	je     800d7a <vsnprintf+0x2d>
  800d74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d78:	7f 07                	jg     800d81 <vsnprintf+0x34>
		return -E_INVAL;
  800d7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7f:	eb 20                	jmp    800da1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d81:	ff 75 14             	pushl  0x14(%ebp)
  800d84:	ff 75 10             	pushl  0x10(%ebp)
  800d87:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	68 17 0d 80 00       	push   $0x800d17
  800d90:	e8 92 fb ff ff       	call   800927 <vprintfmt>
  800d95:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	ff 75 f4             	pushl  -0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	ff 75 0c             	pushl  0xc(%ebp)
  800dbc:	ff 75 08             	pushl  0x8(%ebp)
  800dbf:	e8 89 ff ff ff       	call   800d4d <vsnprintf>
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddc:	eb 06                	jmp    800de4 <strlen+0x15>
		n++;
  800dde:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 f1                	jne    800dde <strlen+0xf>
		n++;
	return n;
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dff:	eb 09                	jmp    800e0a <strnlen+0x18>
		n++;
  800e01:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e04:	ff 45 08             	incl   0x8(%ebp)
  800e07:	ff 4d 0c             	decl   0xc(%ebp)
  800e0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0e:	74 09                	je     800e19 <strnlen+0x27>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e8                	jne    800e01 <strnlen+0xf>
		n++;
	return n;
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2a:	90                   	nop
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8d 50 01             	lea    0x1(%eax),%edx
  800e31:	89 55 08             	mov    %edx,0x8(%ebp)
  800e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e3d:	8a 12                	mov    (%edx),%dl
  800e3f:	88 10                	mov    %dl,(%eax)
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 e4                	jne    800e2b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5f:	eb 1f                	jmp    800e80 <strncpy+0x34>
		*dst++ = *src;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8d 50 01             	lea    0x1(%eax),%edx
  800e67:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	84 c0                	test   %al,%al
  800e78:	74 03                	je     800e7d <strncpy+0x31>
			src++;
  800e7a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7d:	ff 45 fc             	incl   -0x4(%ebp)
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e86:	72 d9                	jb     800e61 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	74 30                	je     800ecf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e9f:	eb 16                	jmp    800eb7 <strlcpy+0x2a>
			*dst++ = *src++;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb7:	ff 4d 10             	decl   0x10(%ebp)
  800eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebe:	74 09                	je     800ec9 <strlcpy+0x3c>
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	84 c0                	test   %al,%al
  800ec7:	75 d8                	jne    800ea1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ede:	eb 06                	jmp    800ee6 <strcmp+0xb>
		p++, q++;
  800ee0:	ff 45 08             	incl   0x8(%ebp)
  800ee3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	84 c0                	test   %al,%al
  800eed:	74 0e                	je     800efd <strcmp+0x22>
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 10                	mov    (%eax),%dl
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	38 c2                	cmp    %al,%dl
  800efb:	74 e3                	je     800ee0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 d0             	movzbl %al,%edx
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f b6 c0             	movzbl %al,%eax
  800f0d:	29 c2                	sub    %eax,%edx
  800f0f:	89 d0                	mov    %edx,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f16:	eb 09                	jmp    800f21 <strncmp+0xe>
		n--, p++, q++;
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f25:	74 17                	je     800f3e <strncmp+0x2b>
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	74 0e                	je     800f3e <strncmp+0x2b>
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 10                	mov    (%eax),%dl
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	38 c2                	cmp    %al,%dl
  800f3c:	74 da                	je     800f18 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f42:	75 07                	jne    800f4b <strncmp+0x38>
		return 0;
  800f44:	b8 00 00 00 00       	mov    $0x0,%eax
  800f49:	eb 14                	jmp    800f5f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 c0             	movzbl %al,%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6d:	eb 12                	jmp    800f81 <strchr+0x20>
		if (*s == c)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f77:	75 05                	jne    800f7e <strchr+0x1d>
			return (char *) s;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	eb 11                	jmp    800f8f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	75 e5                	jne    800f6f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9d:	eb 0d                	jmp    800fac <strfind+0x1b>
		if (*s == c)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa7:	74 0e                	je     800fb7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 ea                	jne    800f9f <strfind+0xe>
  800fb5:	eb 01                	jmp    800fb8 <strfind+0x27>
		if (*s == c)
			break;
  800fb7:	90                   	nop
	return (char *) s;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fcf:	eb 0e                	jmp    800fdf <memset+0x22>
		*p++ = c;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fdf:	ff 4d f8             	decl   -0x8(%ebp)
  800fe2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fe6:	79 e9                	jns    800fd1 <memset+0x14>
		*p++ = c;

	return v;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fff:	eb 16                	jmp    801017 <memcpy+0x2a>
		*d++ = *s++;
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801010:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801013:	8a 12                	mov    (%edx),%dl
  801015:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 dd                	jne    801001 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80103b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801041:	73 50                	jae    801093 <memmove+0x6a>
  801043:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104e:	76 43                	jbe    801093 <memmove+0x6a>
		s += n;
  801050:	8b 45 10             	mov    0x10(%ebp),%eax
  801053:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80105c:	eb 10                	jmp    80106e <memmove+0x45>
			*--d = *--s;
  80105e:	ff 4d f8             	decl   -0x8(%ebp)
  801061:	ff 4d fc             	decl   -0x4(%ebp)
  801064:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801067:	8a 10                	mov    (%eax),%dl
  801069:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	8d 50 ff             	lea    -0x1(%eax),%edx
  801074:	89 55 10             	mov    %edx,0x10(%ebp)
  801077:	85 c0                	test   %eax,%eax
  801079:	75 e3                	jne    80105e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80107b:	eb 23                	jmp    8010a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801089:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80108f:	8a 12                	mov    (%edx),%dl
  801091:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	8d 50 ff             	lea    -0x1(%eax),%edx
  801099:	89 55 10             	mov    %edx,0x10(%ebp)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 dd                	jne    80107d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b7:	eb 2a                	jmp    8010e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	8a 10                	mov    (%eax),%dl
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	38 c2                	cmp    %al,%dl
  8010c5:	74 16                	je     8010dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	0f b6 d0             	movzbl %al,%edx
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	0f b6 c0             	movzbl %al,%eax
  8010d7:	29 c2                	sub    %eax,%edx
  8010d9:	89 d0                	mov    %edx,%eax
  8010db:	eb 18                	jmp    8010f5 <memcmp+0x50>
		s1++, s2++;
  8010dd:	ff 45 fc             	incl   -0x4(%ebp)
  8010e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	75 c9                	jne    8010b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 d0                	add    %edx,%eax
  801105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801108:	eb 15                	jmp    80111f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 d0             	movzbl %al,%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	0f b6 c0             	movzbl %al,%eax
  801118:	39 c2                	cmp    %eax,%edx
  80111a:	74 0d                	je     801129 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801125:	72 e3                	jb     80110a <memfind+0x13>
  801127:	eb 01                	jmp    80112a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801129:	90                   	nop
	return (void *) s;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80113c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801143:	eb 03                	jmp    801148 <strtol+0x19>
		s++;
  801145:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 20                	cmp    $0x20,%al
  80114f:	74 f4                	je     801145 <strtol+0x16>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 09                	cmp    $0x9,%al
  801158:	74 eb                	je     801145 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	3c 2b                	cmp    $0x2b,%al
  801161:	75 05                	jne    801168 <strtol+0x39>
		s++;
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	eb 13                	jmp    80117b <strtol+0x4c>
	else if (*s == '-')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2d                	cmp    $0x2d,%al
  80116f:	75 0a                	jne    80117b <strtol+0x4c>
		s++, neg = 1;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80117b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117f:	74 06                	je     801187 <strtol+0x58>
  801181:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801185:	75 20                	jne    8011a7 <strtol+0x78>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 30                	cmp    $0x30,%al
  80118e:	75 17                	jne    8011a7 <strtol+0x78>
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	40                   	inc    %eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	3c 78                	cmp    $0x78,%al
  801198:	75 0d                	jne    8011a7 <strtol+0x78>
		s += 2, base = 16;
  80119a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80119e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011a5:	eb 28                	jmp    8011cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ab:	75 15                	jne    8011c2 <strtol+0x93>
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 30                	cmp    $0x30,%al
  8011b4:	75 0c                	jne    8011c2 <strtol+0x93>
		s++, base = 8;
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c0:	eb 0d                	jmp    8011cf <strtol+0xa0>
	else if (base == 0)
  8011c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c6:	75 07                	jne    8011cf <strtol+0xa0>
		base = 10;
  8011c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 2f                	cmp    $0x2f,%al
  8011d6:	7e 19                	jle    8011f1 <strtol+0xc2>
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 39                	cmp    $0x39,%al
  8011df:	7f 10                	jg     8011f1 <strtol+0xc2>
			dig = *s - '0';
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f be c0             	movsbl %al,%eax
  8011e9:	83 e8 30             	sub    $0x30,%eax
  8011ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ef:	eb 42                	jmp    801233 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 60                	cmp    $0x60,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xe4>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 7a                	cmp    $0x7a,%al
  801201:	7f 10                	jg     801213 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 57             	sub    $0x57,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 20                	jmp    801233 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 40                	cmp    $0x40,%al
  80121a:	7e 39                	jle    801255 <strtol+0x126>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 5a                	cmp    $0x5a,%al
  801223:	7f 30                	jg     801255 <strtol+0x126>
			dig = *s - 'A' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 37             	sub    $0x37,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801236:	3b 45 10             	cmp    0x10(%ebp),%eax
  801239:	7d 19                	jge    801254 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801241:	0f af 45 10          	imul   0x10(%ebp),%eax
  801245:	89 c2                	mov    %eax,%edx
  801247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80124f:	e9 7b ff ff ff       	jmp    8011cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801254:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801255:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801259:	74 08                	je     801263 <strtol+0x134>
		*endptr = (char *) s;
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801263:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801267:	74 07                	je     801270 <strtol+0x141>
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	f7 d8                	neg    %eax
  80126e:	eb 03                	jmp    801273 <strtol+0x144>
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <ltostr>:

void
ltostr(long value, char *str)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128d:	79 13                	jns    8012a2 <ltostr+0x2d>
	{
		neg = 1;
  80128f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80129c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80129f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012aa:	99                   	cltd   
  8012ab:	f7 f9                	idiv   %ecx
  8012ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b3:	8d 50 01             	lea    0x1(%eax),%edx
  8012b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b9:	89 c2                	mov    %eax,%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c3:	83 c2 30             	add    $0x30,%edx
  8012c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d0:	f7 e9                	imul   %ecx
  8012d2:	c1 fa 02             	sar    $0x2,%edx
  8012d5:	89 c8                	mov    %ecx,%eax
  8012d7:	c1 f8 1f             	sar    $0x1f,%eax
  8012da:	29 c2                	sub    %eax,%edx
  8012dc:	89 d0                	mov    %edx,%eax
  8012de:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e9:	f7 e9                	imul   %ecx
  8012eb:	c1 fa 02             	sar    $0x2,%edx
  8012ee:	89 c8                	mov    %ecx,%eax
  8012f0:	c1 f8 1f             	sar    $0x1f,%eax
  8012f3:	29 c2                	sub    %eax,%edx
  8012f5:	89 d0                	mov    %edx,%eax
  8012f7:	c1 e0 02             	shl    $0x2,%eax
  8012fa:	01 d0                	add    %edx,%eax
  8012fc:	01 c0                	add    %eax,%eax
  8012fe:	29 c1                	sub    %eax,%ecx
  801300:	89 ca                	mov    %ecx,%edx
  801302:	85 d2                	test   %edx,%edx
  801304:	75 9c                	jne    8012a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80130d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801310:	48                   	dec    %eax
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 3d                	je     801357 <ltostr+0xe2>
		start = 1 ;
  80131a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801321:	eb 34                	jmp    801357 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801344:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80134f:	88 02                	mov    %al,(%edx)
		start++ ;
  801351:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801354:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135d:	7c c4                	jl     801323 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80135f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80136a:	90                   	nop
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	e8 54 fa ff ff       	call   800dcf <strlen>
  80137b:	83 c4 04             	add    $0x4,%esp
  80137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	e8 46 fa ff ff       	call   800dcf <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139d:	eb 17                	jmp    8013b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80139f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 c2                	add    %eax,%edx
  8013a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	01 c8                	add    %ecx,%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013b3:	ff 45 fc             	incl   -0x4(%ebp)
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013bc:	7c e1                	jl     80139f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013cc:	eb 1f                	jmp    8013ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d1:	8d 50 01             	lea    0x1(%eax),%edx
  8013d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d7:	89 c2                	mov    %eax,%edx
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013ea:	ff 45 f8             	incl   -0x8(%ebp)
  8013ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f3:	7c d9                	jl     8013ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801406:	8b 45 14             	mov    0x14(%ebp),%eax
  801409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80140f:	8b 45 14             	mov    0x14(%ebp),%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141b:	8b 45 10             	mov    0x10(%ebp),%eax
  80141e:	01 d0                	add    %edx,%eax
  801420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801426:	eb 0c                	jmp    801434 <strsplit+0x31>
			*string++ = 0;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 08             	mov    %edx,0x8(%ebp)
  801431:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	84 c0                	test   %al,%al
  80143b:	74 18                	je     801455 <strsplit+0x52>
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	0f be c0             	movsbl %al,%eax
  801445:	50                   	push   %eax
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	e8 13 fb ff ff       	call   800f61 <strchr>
  80144e:	83 c4 08             	add    $0x8,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	75 d3                	jne    801428 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	84 c0                	test   %al,%al
  80145c:	74 5a                	je     8014b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	8b 00                	mov    (%eax),%eax
  801463:	83 f8 0f             	cmp    $0xf,%eax
  801466:	75 07                	jne    80146f <strsplit+0x6c>
		{
			return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
  80146d:	eb 66                	jmp    8014d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	8d 48 01             	lea    0x1(%eax),%ecx
  801477:	8b 55 14             	mov    0x14(%ebp),%edx
  80147a:	89 0a                	mov    %ecx,(%edx)
  80147c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148d:	eb 03                	jmp    801492 <strsplit+0x8f>
			string++;
  80148f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 8b                	je     801426 <strsplit+0x23>
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	0f be c0             	movsbl %al,%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	e8 b5 fa ff ff       	call   800f61 <strchr>
  8014ac:	83 c4 08             	add    $0x8,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 dc                	je     80148f <strsplit+0x8c>
			string++;
	}
  8014b3:	e9 6e ff ff ff       	jmp    801426 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	74 1f                	je     801505 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014e6:	e8 1d 00 00 00       	call   801508 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	68 70 3c 80 00       	push   $0x803c70
  8014f3:	e8 55 f2 ff ff       	call   80074d <cprintf>
  8014f8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014fb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801502:	00 00 00 
	}
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80150e:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801515:	00 00 00 
  801518:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80151f:	00 00 00 
  801522:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801529:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80152c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801533:	00 00 00 
  801536:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80153d:	00 00 00 
  801540:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801547:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80154a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801554:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801559:	2d 00 10 00 00       	sub    $0x1000,%eax
  80155e:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801563:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80156a:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80156d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801577:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80157c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80157f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801582:	ba 00 00 00 00       	mov    $0x0,%edx
  801587:	f7 75 f0             	divl   -0x10(%ebp)
  80158a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158d:	29 d0                	sub    %edx,%eax
  80158f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801592:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80159c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015a6:	83 ec 04             	sub    $0x4,%esp
  8015a9:	6a 06                	push   $0x6
  8015ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ae:	50                   	push   %eax
  8015af:	e8 d4 05 00 00       	call   801b88 <sys_allocate_chunk>
  8015b4:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015b7:	a1 20 41 80 00       	mov    0x804120,%eax
  8015bc:	83 ec 0c             	sub    $0xc,%esp
  8015bf:	50                   	push   %eax
  8015c0:	e8 49 0c 00 00       	call   80220e <initialize_MemBlocksList>
  8015c5:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8015c8:	a1 48 41 80 00       	mov    0x804148,%eax
  8015cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8015d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015d4:	75 14                	jne    8015ea <initialize_dyn_block_system+0xe2>
  8015d6:	83 ec 04             	sub    $0x4,%esp
  8015d9:	68 95 3c 80 00       	push   $0x803c95
  8015de:	6a 39                	push   $0x39
  8015e0:	68 b3 3c 80 00       	push   $0x803cb3
  8015e5:	e8 af ee ff ff       	call   800499 <_panic>
  8015ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ed:	8b 00                	mov    (%eax),%eax
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	74 10                	je     801603 <initialize_dyn_block_system+0xfb>
  8015f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f6:	8b 00                	mov    (%eax),%eax
  8015f8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015fb:	8b 52 04             	mov    0x4(%edx),%edx
  8015fe:	89 50 04             	mov    %edx,0x4(%eax)
  801601:	eb 0b                	jmp    80160e <initialize_dyn_block_system+0x106>
  801603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801606:	8b 40 04             	mov    0x4(%eax),%eax
  801609:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80160e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801611:	8b 40 04             	mov    0x4(%eax),%eax
  801614:	85 c0                	test   %eax,%eax
  801616:	74 0f                	je     801627 <initialize_dyn_block_system+0x11f>
  801618:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161b:	8b 40 04             	mov    0x4(%eax),%eax
  80161e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801621:	8b 12                	mov    (%edx),%edx
  801623:	89 10                	mov    %edx,(%eax)
  801625:	eb 0a                	jmp    801631 <initialize_dyn_block_system+0x129>
  801627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80162a:	8b 00                	mov    (%eax),%eax
  80162c:	a3 48 41 80 00       	mov    %eax,0x804148
  801631:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801634:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80163a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801644:	a1 54 41 80 00       	mov    0x804154,%eax
  801649:	48                   	dec    %eax
  80164a:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80164f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801652:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801659:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80165c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801663:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801667:	75 14                	jne    80167d <initialize_dyn_block_system+0x175>
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	68 c0 3c 80 00       	push   $0x803cc0
  801671:	6a 3f                	push   $0x3f
  801673:	68 b3 3c 80 00       	push   $0x803cb3
  801678:	e8 1c ee ff ff       	call   800499 <_panic>
  80167d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801686:	89 10                	mov    %edx,(%eax)
  801688:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	85 c0                	test   %eax,%eax
  80168f:	74 0d                	je     80169e <initialize_dyn_block_system+0x196>
  801691:	a1 38 41 80 00       	mov    0x804138,%eax
  801696:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801699:	89 50 04             	mov    %edx,0x4(%eax)
  80169c:	eb 08                	jmp    8016a6 <initialize_dyn_block_system+0x19e>
  80169e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a9:	a3 38 41 80 00       	mov    %eax,0x804138
  8016ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016b8:	a1 44 41 80 00       	mov    0x804144,%eax
  8016bd:	40                   	inc    %eax
  8016be:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8016c3:	90                   	nop
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016cc:	e8 06 fe ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016d5:	75 07                	jne    8016de <malloc+0x18>
  8016d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016dc:	eb 7d                	jmp    80175b <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8016de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016e5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f2:	01 d0                	add    %edx,%eax
  8016f4:	48                   	dec    %eax
  8016f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801700:	f7 75 f0             	divl   -0x10(%ebp)
  801703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801706:	29 d0                	sub    %edx,%eax
  801708:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  80170b:	e8 46 08 00 00       	call   801f56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801710:	83 f8 01             	cmp    $0x1,%eax
  801713:	75 07                	jne    80171c <malloc+0x56>
  801715:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  80171c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801720:	75 34                	jne    801756 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801722:	83 ec 0c             	sub    $0xc,%esp
  801725:	ff 75 e8             	pushl  -0x18(%ebp)
  801728:	e8 73 0e 00 00       	call   8025a0 <alloc_block_FF>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801737:	74 16                	je     80174f <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801739:	83 ec 0c             	sub    $0xc,%esp
  80173c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80173f:	e8 ff 0b 00 00       	call   802343 <insert_sorted_allocList>
  801744:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80174a:	8b 40 08             	mov    0x8(%eax),%eax
  80174d:	eb 0c                	jmp    80175b <malloc+0x95>
	             }
	             else
	             	return NULL;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
  801754:	eb 05                	jmp    80175b <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80176f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801772:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801777:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80177a:	83 ec 08             	sub    $0x8,%esp
  80177d:	ff 75 f4             	pushl  -0xc(%ebp)
  801780:	68 40 40 80 00       	push   $0x804040
  801785:	e8 61 0b 00 00       	call   8022eb <find_block>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801790:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801794:	0f 84 a5 00 00 00    	je     80183f <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  80179a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179d:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a0:	83 ec 08             	sub    $0x8,%esp
  8017a3:	50                   	push   %eax
  8017a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a7:	e8 a4 03 00 00       	call   801b50 <sys_free_user_mem>
  8017ac:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8017af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017b3:	75 17                	jne    8017cc <free+0x6f>
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	68 95 3c 80 00       	push   $0x803c95
  8017bd:	68 87 00 00 00       	push   $0x87
  8017c2:	68 b3 3c 80 00       	push   $0x803cb3
  8017c7:	e8 cd ec ff ff       	call   800499 <_panic>
  8017cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cf:	8b 00                	mov    (%eax),%eax
  8017d1:	85 c0                	test   %eax,%eax
  8017d3:	74 10                	je     8017e5 <free+0x88>
  8017d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d8:	8b 00                	mov    (%eax),%eax
  8017da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017dd:	8b 52 04             	mov    0x4(%edx),%edx
  8017e0:	89 50 04             	mov    %edx,0x4(%eax)
  8017e3:	eb 0b                	jmp    8017f0 <free+0x93>
  8017e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e8:	8b 40 04             	mov    0x4(%eax),%eax
  8017eb:	a3 44 40 80 00       	mov    %eax,0x804044
  8017f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f3:	8b 40 04             	mov    0x4(%eax),%eax
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	74 0f                	je     801809 <free+0xac>
  8017fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fd:	8b 40 04             	mov    0x4(%eax),%eax
  801800:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801803:	8b 12                	mov    (%edx),%edx
  801805:	89 10                	mov    %edx,(%eax)
  801807:	eb 0a                	jmp    801813 <free+0xb6>
  801809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180c:	8b 00                	mov    (%eax),%eax
  80180e:	a3 40 40 80 00       	mov    %eax,0x804040
  801813:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801816:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80181c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801826:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80182b:	48                   	dec    %eax
  80182c:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801831:	83 ec 0c             	sub    $0xc,%esp
  801834:	ff 75 ec             	pushl  -0x14(%ebp)
  801837:	e8 37 12 00 00       	call   802a73 <insert_sorted_with_merge_freeList>
  80183c:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80183f:	90                   	nop
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 38             	sub    $0x38,%esp
  801848:	8b 45 10             	mov    0x10(%ebp),%eax
  80184b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80184e:	e8 84 fc ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801853:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801857:	75 07                	jne    801860 <smalloc+0x1e>
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
  80185e:	eb 7e                	jmp    8018de <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801860:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801867:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80186e:	8b 55 0c             	mov    0xc(%ebp),%edx
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

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80188d:	e8 c4 06 00 00       	call   801f56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801892:	83 f8 01             	cmp    $0x1,%eax
  801895:	75 42                	jne    8018d9 <smalloc+0x97>

		  va = malloc(newsize) ;
  801897:	83 ec 0c             	sub    $0xc,%esp
  80189a:	ff 75 e8             	pushl  -0x18(%ebp)
  80189d:	e8 24 fe ff ff       	call   8016c6 <malloc>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8018a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018ac:	74 24                	je     8018d2 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8018ae:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018b5:	50                   	push   %eax
  8018b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8018b9:	ff 75 08             	pushl  0x8(%ebp)
  8018bc:	e8 1a 04 00 00       	call   801cdb <sys_createSharedObject>
  8018c1:	83 c4 10             	add    $0x10,%esp
  8018c4:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8018c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018cb:	78 0c                	js     8018d9 <smalloc+0x97>
					  return va ;
  8018cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d0:	eb 0c                	jmp    8018de <smalloc+0x9c>
				 }
				 else
					return NULL;
  8018d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d7:	eb 05                	jmp    8018de <smalloc+0x9c>
	  }
		  return NULL ;
  8018d9:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e6:	e8 ec fb ff ff       	call   8014d7 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8018eb:	83 ec 08             	sub    $0x8,%esp
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	ff 75 08             	pushl  0x8(%ebp)
  8018f4:	e8 0c 04 00 00       	call   801d05 <sys_getSizeOfSharedObject>
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8018ff:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801903:	75 07                	jne    80190c <sget+0x2c>
  801905:	b8 00 00 00 00       	mov    $0x0,%eax
  80190a:	eb 75                	jmp    801981 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80190c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801913:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801919:	01 d0                	add    %edx,%eax
  80191b:	48                   	dec    %eax
  80191c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80191f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801922:	ba 00 00 00 00       	mov    $0x0,%edx
  801927:	f7 75 f0             	divl   -0x10(%ebp)
  80192a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80192d:	29 d0                	sub    %edx,%eax
  80192f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801932:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801939:	e8 18 06 00 00       	call   801f56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80193e:	83 f8 01             	cmp    $0x1,%eax
  801941:	75 39                	jne    80197c <sget+0x9c>

		  va = malloc(newsize) ;
  801943:	83 ec 0c             	sub    $0xc,%esp
  801946:	ff 75 e8             	pushl  -0x18(%ebp)
  801949:	e8 78 fd ff ff       	call   8016c6 <malloc>
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801954:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801958:	74 22                	je     80197c <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	ff 75 e0             	pushl  -0x20(%ebp)
  801960:	ff 75 0c             	pushl  0xc(%ebp)
  801963:	ff 75 08             	pushl  0x8(%ebp)
  801966:	e8 b7 03 00 00       	call   801d22 <sys_getSharedObject>
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801971:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801975:	78 05                	js     80197c <sget+0x9c>
					  return va;
  801977:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80197a:	eb 05                	jmp    801981 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801989:	e8 49 fb ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80198e:	83 ec 04             	sub    $0x4,%esp
  801991:	68 e4 3c 80 00       	push   $0x803ce4
  801996:	68 1e 01 00 00       	push   $0x11e
  80199b:	68 b3 3c 80 00       	push   $0x803cb3
  8019a0:	e8 f4 ea ff ff       	call   800499 <_panic>

008019a5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019ab:	83 ec 04             	sub    $0x4,%esp
  8019ae:	68 0c 3d 80 00       	push   $0x803d0c
  8019b3:	68 32 01 00 00       	push   $0x132
  8019b8:	68 b3 3c 80 00       	push   $0x803cb3
  8019bd:	e8 d7 ea ff ff       	call   800499 <_panic>

008019c2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c8:	83 ec 04             	sub    $0x4,%esp
  8019cb:	68 30 3d 80 00       	push   $0x803d30
  8019d0:	68 3d 01 00 00       	push   $0x13d
  8019d5:	68 b3 3c 80 00       	push   $0x803cb3
  8019da:	e8 ba ea ff ff       	call   800499 <_panic>

008019df <shrink>:

}
void shrink(uint32 newSize)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	68 30 3d 80 00       	push   $0x803d30
  8019ed:	68 42 01 00 00       	push   $0x142
  8019f2:	68 b3 3c 80 00       	push   $0x803cb3
  8019f7:	e8 9d ea ff ff       	call   800499 <_panic>

008019fc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
  8019ff:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	68 30 3d 80 00       	push   $0x803d30
  801a0a:	68 47 01 00 00       	push   $0x147
  801a0f:	68 b3 3c 80 00       	push   $0x803cb3
  801a14:	e8 80 ea ff ff       	call   800499 <_panic>

00801a19 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	57                   	push   %edi
  801a1d:	56                   	push   %esi
  801a1e:	53                   	push   %ebx
  801a1f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a2e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a31:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a34:	cd 30                	int    $0x30
  801a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a3c:	83 c4 10             	add    $0x10,%esp
  801a3f:	5b                   	pop    %ebx
  801a40:	5e                   	pop    %esi
  801a41:	5f                   	pop    %edi
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    

00801a44 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	83 ec 04             	sub    $0x4,%esp
  801a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a50:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	52                   	push   %edx
  801a5c:	ff 75 0c             	pushl  0xc(%ebp)
  801a5f:	50                   	push   %eax
  801a60:	6a 00                	push   $0x0
  801a62:	e8 b2 ff ff ff       	call   801a19 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	90                   	nop
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 01                	push   $0x1
  801a7c:	e8 98 ff ff ff       	call   801a19 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	52                   	push   %edx
  801a96:	50                   	push   %eax
  801a97:	6a 05                	push   $0x5
  801a99:	e8 7b ff ff ff       	call   801a19 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801aa8:	8b 75 18             	mov    0x18(%ebp),%esi
  801aab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	56                   	push   %esi
  801ab8:	53                   	push   %ebx
  801ab9:	51                   	push   %ecx
  801aba:	52                   	push   %edx
  801abb:	50                   	push   %eax
  801abc:	6a 06                	push   $0x6
  801abe:	e8 56 ff ff ff       	call   801a19 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac9:	5b                   	pop    %ebx
  801aca:	5e                   	pop    %esi
  801acb:	5d                   	pop    %ebp
  801acc:	c3                   	ret    

00801acd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	52                   	push   %edx
  801add:	50                   	push   %eax
  801ade:	6a 07                	push   $0x7
  801ae0:	e8 34 ff ff ff       	call   801a19 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	ff 75 0c             	pushl  0xc(%ebp)
  801af6:	ff 75 08             	pushl  0x8(%ebp)
  801af9:	6a 08                	push   $0x8
  801afb:	e8 19 ff ff ff       	call   801a19 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 09                	push   $0x9
  801b14:	e8 00 ff ff ff       	call   801a19 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 0a                	push   $0xa
  801b2d:	e8 e7 fe ff ff       	call   801a19 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 0b                	push   $0xb
  801b46:	e8 ce fe ff ff       	call   801a19 <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	ff 75 0c             	pushl  0xc(%ebp)
  801b5c:	ff 75 08             	pushl  0x8(%ebp)
  801b5f:	6a 0f                	push   $0xf
  801b61:	e8 b3 fe ff ff       	call   801a19 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
	return;
  801b69:	90                   	nop
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	6a 10                	push   $0x10
  801b7d:	e8 97 fe ff ff       	call   801a19 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
	return ;
  801b85:	90                   	nop
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	ff 75 10             	pushl  0x10(%ebp)
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	ff 75 08             	pushl  0x8(%ebp)
  801b98:	6a 11                	push   $0x11
  801b9a:	e8 7a fe ff ff       	call   801a19 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba2:	90                   	nop
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 0c                	push   $0xc
  801bb4:	e8 60 fe ff ff       	call   801a19 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	ff 75 08             	pushl  0x8(%ebp)
  801bcc:	6a 0d                	push   $0xd
  801bce:	e8 46 fe ff ff       	call   801a19 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 0e                	push   $0xe
  801be7:	e8 2d fe ff ff       	call   801a19 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	90                   	nop
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 13                	push   $0x13
  801c01:	e8 13 fe ff ff       	call   801a19 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	90                   	nop
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 14                	push   $0x14
  801c1b:	e8 f9 fd ff ff       	call   801a19 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	90                   	nop
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 04             	sub    $0x4,%esp
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	50                   	push   %eax
  801c3f:	6a 15                	push   $0x15
  801c41:	e8 d3 fd ff ff       	call   801a19 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	90                   	nop
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 16                	push   $0x16
  801c5b:	e8 b9 fd ff ff       	call   801a19 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	90                   	nop
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	50                   	push   %eax
  801c76:	6a 17                	push   $0x17
  801c78:	e8 9c fd ff ff       	call   801a19 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	52                   	push   %edx
  801c92:	50                   	push   %eax
  801c93:	6a 1a                	push   $0x1a
  801c95:	e8 7f fd ff ff       	call   801a19 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	52                   	push   %edx
  801caf:	50                   	push   %eax
  801cb0:	6a 18                	push   $0x18
  801cb2:	e8 62 fd ff ff       	call   801a19 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	90                   	nop
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	6a 19                	push   $0x19
  801cd0:	e8 44 fd ff ff       	call   801a19 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	90                   	nop
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	83 ec 04             	sub    $0x4,%esp
  801ce1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ce7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cea:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	51                   	push   %ecx
  801cf4:	52                   	push   %edx
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	50                   	push   %eax
  801cf9:	6a 1b                	push   $0x1b
  801cfb:	e8 19 fd ff ff       	call   801a19 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	52                   	push   %edx
  801d15:	50                   	push   %eax
  801d16:	6a 1c                	push   $0x1c
  801d18:	e8 fc fc ff ff       	call   801a19 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	51                   	push   %ecx
  801d33:	52                   	push   %edx
  801d34:	50                   	push   %eax
  801d35:	6a 1d                	push   $0x1d
  801d37:	e8 dd fc ff ff       	call   801a19 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	52                   	push   %edx
  801d51:	50                   	push   %eax
  801d52:	6a 1e                	push   $0x1e
  801d54:	e8 c0 fc ff ff       	call   801a19 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 1f                	push   $0x1f
  801d6d:	e8 a7 fc ff ff       	call   801a19 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	6a 00                	push   $0x0
  801d7f:	ff 75 14             	pushl  0x14(%ebp)
  801d82:	ff 75 10             	pushl  0x10(%ebp)
  801d85:	ff 75 0c             	pushl  0xc(%ebp)
  801d88:	50                   	push   %eax
  801d89:	6a 20                	push   $0x20
  801d8b:	e8 89 fc ff ff       	call   801a19 <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
}
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d98:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	50                   	push   %eax
  801da4:	6a 21                	push   $0x21
  801da6:	e8 6e fc ff ff       	call   801a19 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
}
  801dae:	90                   	nop
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	50                   	push   %eax
  801dc0:	6a 22                	push   $0x22
  801dc2:	e8 52 fc ff ff       	call   801a19 <syscall>
  801dc7:	83 c4 18             	add    $0x18,%esp
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 02                	push   $0x2
  801ddb:	e8 39 fc ff ff       	call   801a19 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 03                	push   $0x3
  801df4:	e8 20 fc ff ff       	call   801a19 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 04                	push   $0x4
  801e0d:	e8 07 fc ff ff       	call   801a19 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_exit_env>:


void sys_exit_env(void)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 23                	push   $0x23
  801e26:	e8 ee fb ff ff       	call   801a19 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
}
  801e2e:	90                   	nop
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e3a:	8d 50 04             	lea    0x4(%eax),%edx
  801e3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	6a 24                	push   $0x24
  801e4a:	e8 ca fb ff ff       	call   801a19 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
	return result;
  801e52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e5b:	89 01                	mov    %eax,(%ecx)
  801e5d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	c9                   	leave  
  801e64:	c2 04 00             	ret    $0x4

00801e67 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	ff 75 10             	pushl  0x10(%ebp)
  801e71:	ff 75 0c             	pushl  0xc(%ebp)
  801e74:	ff 75 08             	pushl  0x8(%ebp)
  801e77:	6a 12                	push   $0x12
  801e79:	e8 9b fb ff ff       	call   801a19 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e81:	90                   	nop
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 25                	push   $0x25
  801e93:	e8 81 fb ff ff       	call   801a19 <syscall>
  801e98:	83 c4 18             	add    $0x18,%esp
}
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 04             	sub    $0x4,%esp
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ea9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	50                   	push   %eax
  801eb6:	6a 26                	push   $0x26
  801eb8:	e8 5c fb ff ff       	call   801a19 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec0:	90                   	nop
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <rsttst>:
void rsttst()
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 28                	push   $0x28
  801ed2:	e8 42 fb ff ff       	call   801a19 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eda:	90                   	nop
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ee9:	8b 55 18             	mov    0x18(%ebp),%edx
  801eec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ef0:	52                   	push   %edx
  801ef1:	50                   	push   %eax
  801ef2:	ff 75 10             	pushl  0x10(%ebp)
  801ef5:	ff 75 0c             	pushl  0xc(%ebp)
  801ef8:	ff 75 08             	pushl  0x8(%ebp)
  801efb:	6a 27                	push   $0x27
  801efd:	e8 17 fb ff ff       	call   801a19 <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
	return ;
  801f05:	90                   	nop
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <chktst>:
void chktst(uint32 n)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	ff 75 08             	pushl  0x8(%ebp)
  801f16:	6a 29                	push   $0x29
  801f18:	e8 fc fa ff ff       	call   801a19 <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801f20:	90                   	nop
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <inctst>:

void inctst()
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 2a                	push   $0x2a
  801f32:	e8 e2 fa ff ff       	call   801a19 <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3a:	90                   	nop
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <gettst>:
uint32 gettst()
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 2b                	push   $0x2b
  801f4c:	e8 c8 fa ff ff       	call   801a19 <syscall>
  801f51:	83 c4 18             	add    $0x18,%esp
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 2c                	push   $0x2c
  801f68:	e8 ac fa ff ff       	call   801a19 <syscall>
  801f6d:	83 c4 18             	add    $0x18,%esp
  801f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f73:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f77:	75 07                	jne    801f80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f79:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7e:	eb 05                	jmp    801f85 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 2c                	push   $0x2c
  801f99:	e8 7b fa ff ff       	call   801a19 <syscall>
  801f9e:	83 c4 18             	add    $0x18,%esp
  801fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fa4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fa8:	75 07                	jne    801fb1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801faa:	b8 01 00 00 00       	mov    $0x1,%eax
  801faf:	eb 05                	jmp    801fb6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	6a 00                	push   $0x0
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 2c                	push   $0x2c
  801fca:	e8 4a fa ff ff       	call   801a19 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
  801fd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fd5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fd9:	75 07                	jne    801fe2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fdb:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe0:	eb 05                	jmp    801fe7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 2c                	push   $0x2c
  801ffb:	e8 19 fa ff ff       	call   801a19 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
  802003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802006:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80200a:	75 07                	jne    802013 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80200c:	b8 01 00 00 00       	mov    $0x1,%eax
  802011:	eb 05                	jmp    802018 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	ff 75 08             	pushl  0x8(%ebp)
  802028:	6a 2d                	push   $0x2d
  80202a:	e8 ea f9 ff ff       	call   801a19 <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
	return ;
  802032:	90                   	nop
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802039:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80203c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	6a 00                	push   $0x0
  802047:	53                   	push   %ebx
  802048:	51                   	push   %ecx
  802049:	52                   	push   %edx
  80204a:	50                   	push   %eax
  80204b:	6a 2e                	push   $0x2e
  80204d:	e8 c7 f9 ff ff       	call   801a19 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80205d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	52                   	push   %edx
  80206a:	50                   	push   %eax
  80206b:	6a 2f                	push   $0x2f
  80206d:	e8 a7 f9 ff ff       	call   801a19 <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	68 40 3d 80 00       	push   $0x803d40
  802085:	e8 c3 e6 ff ff       	call   80074d <cprintf>
  80208a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80208d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802094:	83 ec 0c             	sub    $0xc,%esp
  802097:	68 6c 3d 80 00       	push   $0x803d6c
  80209c:	e8 ac e6 ff ff       	call   80074d <cprintf>
  8020a1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020a4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020a8:	a1 38 41 80 00       	mov    0x804138,%eax
  8020ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b0:	eb 56                	jmp    802108 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b6:	74 1c                	je     8020d4 <print_mem_block_lists+0x5d>
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	8b 50 08             	mov    0x8(%eax),%edx
  8020be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c1:	8b 48 08             	mov    0x8(%eax),%ecx
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ca:	01 c8                	add    %ecx,%eax
  8020cc:	39 c2                	cmp    %eax,%edx
  8020ce:	73 04                	jae    8020d4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020d0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	8b 50 08             	mov    0x8(%eax),%edx
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e0:	01 c2                	add    %eax,%edx
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 40 08             	mov    0x8(%eax),%eax
  8020e8:	83 ec 04             	sub    $0x4,%esp
  8020eb:	52                   	push   %edx
  8020ec:	50                   	push   %eax
  8020ed:	68 81 3d 80 00       	push   $0x803d81
  8020f2:	e8 56 e6 ff ff       	call   80074d <cprintf>
  8020f7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802100:	a1 40 41 80 00       	mov    0x804140,%eax
  802105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210c:	74 07                	je     802115 <print_mem_block_lists+0x9e>
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	eb 05                	jmp    80211a <print_mem_block_lists+0xa3>
  802115:	b8 00 00 00 00       	mov    $0x0,%eax
  80211a:	a3 40 41 80 00       	mov    %eax,0x804140
  80211f:	a1 40 41 80 00       	mov    0x804140,%eax
  802124:	85 c0                	test   %eax,%eax
  802126:	75 8a                	jne    8020b2 <print_mem_block_lists+0x3b>
  802128:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212c:	75 84                	jne    8020b2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80212e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802132:	75 10                	jne    802144 <print_mem_block_lists+0xcd>
  802134:	83 ec 0c             	sub    $0xc,%esp
  802137:	68 90 3d 80 00       	push   $0x803d90
  80213c:	e8 0c e6 ff ff       	call   80074d <cprintf>
  802141:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802144:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	68 b4 3d 80 00       	push   $0x803db4
  802153:	e8 f5 e5 ff ff       	call   80074d <cprintf>
  802158:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80215b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80215f:	a1 40 40 80 00       	mov    0x804040,%eax
  802164:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802167:	eb 56                	jmp    8021bf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802169:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80216d:	74 1c                	je     80218b <print_mem_block_lists+0x114>
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	8b 50 08             	mov    0x8(%eax),%edx
  802175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802178:	8b 48 08             	mov    0x8(%eax),%ecx
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	8b 40 0c             	mov    0xc(%eax),%eax
  802181:	01 c8                	add    %ecx,%eax
  802183:	39 c2                	cmp    %eax,%edx
  802185:	73 04                	jae    80218b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802187:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	8b 50 08             	mov    0x8(%eax),%edx
  802191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802194:	8b 40 0c             	mov    0xc(%eax),%eax
  802197:	01 c2                	add    %eax,%edx
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 40 08             	mov    0x8(%eax),%eax
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	52                   	push   %edx
  8021a3:	50                   	push   %eax
  8021a4:	68 81 3d 80 00       	push   $0x803d81
  8021a9:	e8 9f e5 ff ff       	call   80074d <cprintf>
  8021ae:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021b7:	a1 48 40 80 00       	mov    0x804048,%eax
  8021bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c3:	74 07                	je     8021cc <print_mem_block_lists+0x155>
  8021c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c8:	8b 00                	mov    (%eax),%eax
  8021ca:	eb 05                	jmp    8021d1 <print_mem_block_lists+0x15a>
  8021cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8021d1:	a3 48 40 80 00       	mov    %eax,0x804048
  8021d6:	a1 48 40 80 00       	mov    0x804048,%eax
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	75 8a                	jne    802169 <print_mem_block_lists+0xf2>
  8021df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e3:	75 84                	jne    802169 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021e5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021e9:	75 10                	jne    8021fb <print_mem_block_lists+0x184>
  8021eb:	83 ec 0c             	sub    $0xc,%esp
  8021ee:	68 cc 3d 80 00       	push   $0x803dcc
  8021f3:	e8 55 e5 ff ff       	call   80074d <cprintf>
  8021f8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021fb:	83 ec 0c             	sub    $0xc,%esp
  8021fe:	68 40 3d 80 00       	push   $0x803d40
  802203:	e8 45 e5 ff ff       	call   80074d <cprintf>
  802208:	83 c4 10             	add    $0x10,%esp

}
  80220b:	90                   	nop
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802214:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80221b:	00 00 00 
  80221e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802225:	00 00 00 
  802228:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80222f:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802232:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802239:	e9 9e 00 00 00       	jmp    8022dc <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80223e:	a1 50 40 80 00       	mov    0x804050,%eax
  802243:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802246:	c1 e2 04             	shl    $0x4,%edx
  802249:	01 d0                	add    %edx,%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	75 14                	jne    802263 <initialize_MemBlocksList+0x55>
  80224f:	83 ec 04             	sub    $0x4,%esp
  802252:	68 f4 3d 80 00       	push   $0x803df4
  802257:	6a 47                	push   $0x47
  802259:	68 17 3e 80 00       	push   $0x803e17
  80225e:	e8 36 e2 ff ff       	call   800499 <_panic>
  802263:	a1 50 40 80 00       	mov    0x804050,%eax
  802268:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226b:	c1 e2 04             	shl    $0x4,%edx
  80226e:	01 d0                	add    %edx,%eax
  802270:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802276:	89 10                	mov    %edx,(%eax)
  802278:	8b 00                	mov    (%eax),%eax
  80227a:	85 c0                	test   %eax,%eax
  80227c:	74 18                	je     802296 <initialize_MemBlocksList+0x88>
  80227e:	a1 48 41 80 00       	mov    0x804148,%eax
  802283:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802289:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80228c:	c1 e1 04             	shl    $0x4,%ecx
  80228f:	01 ca                	add    %ecx,%edx
  802291:	89 50 04             	mov    %edx,0x4(%eax)
  802294:	eb 12                	jmp    8022a8 <initialize_MemBlocksList+0x9a>
  802296:	a1 50 40 80 00       	mov    0x804050,%eax
  80229b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229e:	c1 e2 04             	shl    $0x4,%edx
  8022a1:	01 d0                	add    %edx,%eax
  8022a3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022a8:	a1 50 40 80 00       	mov    0x804050,%eax
  8022ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b0:	c1 e2 04             	shl    $0x4,%edx
  8022b3:	01 d0                	add    %edx,%eax
  8022b5:	a3 48 41 80 00       	mov    %eax,0x804148
  8022ba:	a1 50 40 80 00       	mov    0x804050,%eax
  8022bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c2:	c1 e2 04             	shl    $0x4,%edx
  8022c5:	01 d0                	add    %edx,%eax
  8022c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ce:	a1 54 41 80 00       	mov    0x804154,%eax
  8022d3:	40                   	inc    %eax
  8022d4:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8022d9:	ff 45 f4             	incl   -0xc(%ebp)
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e2:	0f 82 56 ff ff ff    	jb     80223e <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8022e8:	90                   	nop
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022f9:	eb 19                	jmp    802314 <find_block+0x29>
	{
		if(element->sva == va){
  8022fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022fe:	8b 40 08             	mov    0x8(%eax),%eax
  802301:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802304:	75 05                	jne    80230b <find_block+0x20>
			 		return element;
  802306:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802309:	eb 36                	jmp    802341 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	8b 40 08             	mov    0x8(%eax),%eax
  802311:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802318:	74 07                	je     802321 <find_block+0x36>
  80231a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80231d:	8b 00                	mov    (%eax),%eax
  80231f:	eb 05                	jmp    802326 <find_block+0x3b>
  802321:	b8 00 00 00 00       	mov    $0x0,%eax
  802326:	8b 55 08             	mov    0x8(%ebp),%edx
  802329:	89 42 08             	mov    %eax,0x8(%edx)
  80232c:	8b 45 08             	mov    0x8(%ebp),%eax
  80232f:	8b 40 08             	mov    0x8(%eax),%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	75 c5                	jne    8022fb <find_block+0x10>
  802336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80233a:	75 bf                	jne    8022fb <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802349:	a1 44 40 80 00       	mov    0x804044,%eax
  80234e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802351:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802356:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802359:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80235d:	74 0a                	je     802369 <insert_sorted_allocList+0x26>
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	8b 40 08             	mov    0x8(%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	75 65                	jne    8023ce <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802369:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80236d:	75 14                	jne    802383 <insert_sorted_allocList+0x40>
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	68 f4 3d 80 00       	push   $0x803df4
  802377:	6a 6e                	push   $0x6e
  802379:	68 17 3e 80 00       	push   $0x803e17
  80237e:	e8 16 e1 ff ff       	call   800499 <_panic>
  802383:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	89 10                	mov    %edx,(%eax)
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	85 c0                	test   %eax,%eax
  802395:	74 0d                	je     8023a4 <insert_sorted_allocList+0x61>
  802397:	a1 40 40 80 00       	mov    0x804040,%eax
  80239c:	8b 55 08             	mov    0x8(%ebp),%edx
  80239f:	89 50 04             	mov    %edx,0x4(%eax)
  8023a2:	eb 08                	jmp    8023ac <insert_sorted_allocList+0x69>
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	a3 44 40 80 00       	mov    %eax,0x804044
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	a3 40 40 80 00       	mov    %eax,0x804040
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023be:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023c3:	40                   	inc    %eax
  8023c4:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023c9:	e9 cf 01 00 00       	jmp    80259d <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 50 08             	mov    0x8(%eax),%edx
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	8b 40 08             	mov    0x8(%eax),%eax
  8023da:	39 c2                	cmp    %eax,%edx
  8023dc:	73 65                	jae    802443 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023e2:	75 14                	jne    8023f8 <insert_sorted_allocList+0xb5>
  8023e4:	83 ec 04             	sub    $0x4,%esp
  8023e7:	68 30 3e 80 00       	push   $0x803e30
  8023ec:	6a 72                	push   $0x72
  8023ee:	68 17 3e 80 00       	push   $0x803e17
  8023f3:	e8 a1 e0 ff ff       	call   800499 <_panic>
  8023f8:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	89 50 04             	mov    %edx,0x4(%eax)
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	8b 40 04             	mov    0x4(%eax),%eax
  80240a:	85 c0                	test   %eax,%eax
  80240c:	74 0c                	je     80241a <insert_sorted_allocList+0xd7>
  80240e:	a1 44 40 80 00       	mov    0x804044,%eax
  802413:	8b 55 08             	mov    0x8(%ebp),%edx
  802416:	89 10                	mov    %edx,(%eax)
  802418:	eb 08                	jmp    802422 <insert_sorted_allocList+0xdf>
  80241a:	8b 45 08             	mov    0x8(%ebp),%eax
  80241d:	a3 40 40 80 00       	mov    %eax,0x804040
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	a3 44 40 80 00       	mov    %eax,0x804044
  80242a:	8b 45 08             	mov    0x8(%ebp),%eax
  80242d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802433:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802438:	40                   	inc    %eax
  802439:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80243e:	e9 5a 01 00 00       	jmp    80259d <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802446:	8b 50 08             	mov    0x8(%eax),%edx
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	8b 40 08             	mov    0x8(%eax),%eax
  80244f:	39 c2                	cmp    %eax,%edx
  802451:	75 70                	jne    8024c3 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802453:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802457:	74 06                	je     80245f <insert_sorted_allocList+0x11c>
  802459:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80245d:	75 14                	jne    802473 <insert_sorted_allocList+0x130>
  80245f:	83 ec 04             	sub    $0x4,%esp
  802462:	68 54 3e 80 00       	push   $0x803e54
  802467:	6a 75                	push   $0x75
  802469:	68 17 3e 80 00       	push   $0x803e17
  80246e:	e8 26 e0 ff ff       	call   800499 <_panic>
  802473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802476:	8b 10                	mov    (%eax),%edx
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	89 10                	mov    %edx,(%eax)
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	74 0b                	je     802491 <insert_sorted_allocList+0x14e>
  802486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	8b 55 08             	mov    0x8(%ebp),%edx
  80248e:	89 50 04             	mov    %edx,0x4(%eax)
  802491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802494:	8b 55 08             	mov    0x8(%ebp),%edx
  802497:	89 10                	mov    %edx,(%eax)
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80249f:	89 50 04             	mov    %edx,0x4(%eax)
  8024a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	75 08                	jne    8024b3 <insert_sorted_allocList+0x170>
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	a3 44 40 80 00       	mov    %eax,0x804044
  8024b3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024b8:	40                   	inc    %eax
  8024b9:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8024be:	e9 da 00 00 00       	jmp    80259d <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8024c3:	a1 40 40 80 00       	mov    0x804040,%eax
  8024c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cb:	e9 9d 00 00 00       	jmp    80256d <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8024d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024db:	8b 50 08             	mov    0x8(%eax),%edx
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 08             	mov    0x8(%eax),%eax
  8024e4:	39 c2                	cmp    %eax,%edx
  8024e6:	76 7d                	jbe    802565 <insert_sorted_allocList+0x222>
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	8b 50 08             	mov    0x8(%eax),%edx
  8024ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f1:	8b 40 08             	mov    0x8(%eax),%eax
  8024f4:	39 c2                	cmp    %eax,%edx
  8024f6:	73 6d                	jae    802565 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8024f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fc:	74 06                	je     802504 <insert_sorted_allocList+0x1c1>
  8024fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802502:	75 14                	jne    802518 <insert_sorted_allocList+0x1d5>
  802504:	83 ec 04             	sub    $0x4,%esp
  802507:	68 54 3e 80 00       	push   $0x803e54
  80250c:	6a 7c                	push   $0x7c
  80250e:	68 17 3e 80 00       	push   $0x803e17
  802513:	e8 81 df ff ff       	call   800499 <_panic>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 10                	mov    (%eax),%edx
  80251d:	8b 45 08             	mov    0x8(%ebp),%eax
  802520:	89 10                	mov    %edx,(%eax)
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 0b                	je     802536 <insert_sorted_allocList+0x1f3>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 00                	mov    (%eax),%eax
  802530:	8b 55 08             	mov    0x8(%ebp),%edx
  802533:	89 50 04             	mov    %edx,0x4(%eax)
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 55 08             	mov    0x8(%ebp),%edx
  80253c:	89 10                	mov    %edx,(%eax)
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802544:	89 50 04             	mov    %edx,0x4(%eax)
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	8b 00                	mov    (%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	75 08                	jne    802558 <insert_sorted_allocList+0x215>
  802550:	8b 45 08             	mov    0x8(%ebp),%eax
  802553:	a3 44 40 80 00       	mov    %eax,0x804044
  802558:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80255d:	40                   	inc    %eax
  80255e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802563:	eb 38                	jmp    80259d <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802565:	a1 48 40 80 00       	mov    0x804048,%eax
  80256a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802571:	74 07                	je     80257a <insert_sorted_allocList+0x237>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	eb 05                	jmp    80257f <insert_sorted_allocList+0x23c>
  80257a:	b8 00 00 00 00       	mov    $0x0,%eax
  80257f:	a3 48 40 80 00       	mov    %eax,0x804048
  802584:	a1 48 40 80 00       	mov    0x804048,%eax
  802589:	85 c0                	test   %eax,%eax
  80258b:	0f 85 3f ff ff ff    	jne    8024d0 <insert_sorted_allocList+0x18d>
  802591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802595:	0f 85 35 ff ff ff    	jne    8024d0 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80259b:	eb 00                	jmp    80259d <insert_sorted_allocList+0x25a>
  80259d:	90                   	nop
  80259e:	c9                   	leave  
  80259f:	c3                   	ret    

008025a0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
  8025a3:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025a6:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ae:	e9 6b 02 00 00       	jmp    80281e <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bc:	0f 85 90 00 00 00    	jne    802652 <alloc_block_FF+0xb2>
			  temp=element;
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8025c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cc:	75 17                	jne    8025e5 <alloc_block_FF+0x45>
  8025ce:	83 ec 04             	sub    $0x4,%esp
  8025d1:	68 88 3e 80 00       	push   $0x803e88
  8025d6:	68 92 00 00 00       	push   $0x92
  8025db:	68 17 3e 80 00       	push   $0x803e17
  8025e0:	e8 b4 de ff ff       	call   800499 <_panic>
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 00                	mov    (%eax),%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	74 10                	je     8025fe <alloc_block_FF+0x5e>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f6:	8b 52 04             	mov    0x4(%edx),%edx
  8025f9:	89 50 04             	mov    %edx,0x4(%eax)
  8025fc:	eb 0b                	jmp    802609 <alloc_block_FF+0x69>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	8b 40 04             	mov    0x4(%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	74 0f                	je     802622 <alloc_block_FF+0x82>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261c:	8b 12                	mov    (%edx),%edx
  80261e:	89 10                	mov    %edx,(%eax)
  802620:	eb 0a                	jmp    80262c <alloc_block_FF+0x8c>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	a3 38 41 80 00       	mov    %eax,0x804138
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263f:	a1 44 41 80 00       	mov    0x804144,%eax
  802644:	48                   	dec    %eax
  802645:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80264a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264d:	e9 ff 01 00 00       	jmp    802851 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 0c             	mov    0xc(%eax),%eax
  802658:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265b:	0f 86 b5 01 00 00    	jbe    802816 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 40 0c             	mov    0xc(%eax),%eax
  802667:	2b 45 08             	sub    0x8(%ebp),%eax
  80266a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80266d:	a1 48 41 80 00       	mov    0x804148,%eax
  802672:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802675:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802679:	75 17                	jne    802692 <alloc_block_FF+0xf2>
  80267b:	83 ec 04             	sub    $0x4,%esp
  80267e:	68 88 3e 80 00       	push   $0x803e88
  802683:	68 99 00 00 00       	push   $0x99
  802688:	68 17 3e 80 00       	push   $0x803e17
  80268d:	e8 07 de ff ff       	call   800499 <_panic>
  802692:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802695:	8b 00                	mov    (%eax),%eax
  802697:	85 c0                	test   %eax,%eax
  802699:	74 10                	je     8026ab <alloc_block_FF+0x10b>
  80269b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a3:	8b 52 04             	mov    0x4(%edx),%edx
  8026a6:	89 50 04             	mov    %edx,0x4(%eax)
  8026a9:	eb 0b                	jmp    8026b6 <alloc_block_FF+0x116>
  8026ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b9:	8b 40 04             	mov    0x4(%eax),%eax
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	74 0f                	je     8026cf <alloc_block_FF+0x12f>
  8026c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c3:	8b 40 04             	mov    0x4(%eax),%eax
  8026c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026c9:	8b 12                	mov    (%edx),%edx
  8026cb:	89 10                	mov    %edx,(%eax)
  8026cd:	eb 0a                	jmp    8026d9 <alloc_block_FF+0x139>
  8026cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	a3 48 41 80 00       	mov    %eax,0x804148
  8026d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ec:	a1 54 41 80 00       	mov    0x804154,%eax
  8026f1:	48                   	dec    %eax
  8026f2:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8026f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026fb:	75 17                	jne    802714 <alloc_block_FF+0x174>
  8026fd:	83 ec 04             	sub    $0x4,%esp
  802700:	68 30 3e 80 00       	push   $0x803e30
  802705:	68 9a 00 00 00       	push   $0x9a
  80270a:	68 17 3e 80 00       	push   $0x803e17
  80270f:	e8 85 dd ff ff       	call   800499 <_panic>
  802714:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80271a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271d:	89 50 04             	mov    %edx,0x4(%eax)
  802720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802723:	8b 40 04             	mov    0x4(%eax),%eax
  802726:	85 c0                	test   %eax,%eax
  802728:	74 0c                	je     802736 <alloc_block_FF+0x196>
  80272a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80272f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802732:	89 10                	mov    %edx,(%eax)
  802734:	eb 08                	jmp    80273e <alloc_block_FF+0x19e>
  802736:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802739:	a3 38 41 80 00       	mov    %eax,0x804138
  80273e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802741:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802746:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802749:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274f:	a1 44 41 80 00       	mov    0x804144,%eax
  802754:	40                   	inc    %eax
  802755:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  80275a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275d:	8b 55 08             	mov    0x8(%ebp),%edx
  802760:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 50 08             	mov    0x8(%eax),%edx
  802769:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276c:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802775:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 50 08             	mov    0x8(%eax),%edx
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	01 c2                	add    %eax,%edx
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802789:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80278f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802793:	75 17                	jne    8027ac <alloc_block_FF+0x20c>
  802795:	83 ec 04             	sub    $0x4,%esp
  802798:	68 88 3e 80 00       	push   $0x803e88
  80279d:	68 a2 00 00 00       	push   $0xa2
  8027a2:	68 17 3e 80 00       	push   $0x803e17
  8027a7:	e8 ed dc ff ff       	call   800499 <_panic>
  8027ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	74 10                	je     8027c5 <alloc_block_FF+0x225>
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027bd:	8b 52 04             	mov    0x4(%edx),%edx
  8027c0:	89 50 04             	mov    %edx,0x4(%eax)
  8027c3:	eb 0b                	jmp    8027d0 <alloc_block_FF+0x230>
  8027c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d3:	8b 40 04             	mov    0x4(%eax),%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	74 0f                	je     8027e9 <alloc_block_FF+0x249>
  8027da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e3:	8b 12                	mov    (%edx),%edx
  8027e5:	89 10                	mov    %edx,(%eax)
  8027e7:	eb 0a                	jmp    8027f3 <alloc_block_FF+0x253>
  8027e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	a3 38 41 80 00       	mov    %eax,0x804138
  8027f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802806:	a1 44 41 80 00       	mov    0x804144,%eax
  80280b:	48                   	dec    %eax
  80280c:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802814:	eb 3b                	jmp    802851 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802816:	a1 40 41 80 00       	mov    0x804140,%eax
  80281b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802822:	74 07                	je     80282b <alloc_block_FF+0x28b>
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	eb 05                	jmp    802830 <alloc_block_FF+0x290>
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
  802830:	a3 40 41 80 00       	mov    %eax,0x804140
  802835:	a1 40 41 80 00       	mov    0x804140,%eax
  80283a:	85 c0                	test   %eax,%eax
  80283c:	0f 85 71 fd ff ff    	jne    8025b3 <alloc_block_FF+0x13>
  802842:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802846:	0f 85 67 fd ff ff    	jne    8025b3 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802851:	c9                   	leave  
  802852:	c3                   	ret    

00802853 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802853:	55                   	push   %ebp
  802854:	89 e5                	mov    %esp,%ebp
  802856:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802859:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802860:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802867:	a1 38 41 80 00       	mov    0x804138,%eax
  80286c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80286f:	e9 d3 00 00 00       	jmp    802947 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802874:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802877:	8b 40 0c             	mov    0xc(%eax),%eax
  80287a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287d:	0f 85 90 00 00 00    	jne    802913 <alloc_block_BF+0xc0>
	   temp = element;
  802883:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802886:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802889:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80288d:	75 17                	jne    8028a6 <alloc_block_BF+0x53>
  80288f:	83 ec 04             	sub    $0x4,%esp
  802892:	68 88 3e 80 00       	push   $0x803e88
  802897:	68 bd 00 00 00       	push   $0xbd
  80289c:	68 17 3e 80 00       	push   $0x803e17
  8028a1:	e8 f3 db ff ff       	call   800499 <_panic>
  8028a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a9:	8b 00                	mov    (%eax),%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	74 10                	je     8028bf <alloc_block_BF+0x6c>
  8028af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028b7:	8b 52 04             	mov    0x4(%edx),%edx
  8028ba:	89 50 04             	mov    %edx,0x4(%eax)
  8028bd:	eb 0b                	jmp    8028ca <alloc_block_BF+0x77>
  8028bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c2:	8b 40 04             	mov    0x4(%eax),%eax
  8028c5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028cd:	8b 40 04             	mov    0x4(%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 0f                	je     8028e3 <alloc_block_BF+0x90>
  8028d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d7:	8b 40 04             	mov    0x4(%eax),%eax
  8028da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028dd:	8b 12                	mov    (%edx),%edx
  8028df:	89 10                	mov    %edx,(%eax)
  8028e1:	eb 0a                	jmp    8028ed <alloc_block_BF+0x9a>
  8028e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802900:	a1 44 41 80 00       	mov    0x804144,%eax
  802905:	48                   	dec    %eax
  802906:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  80290b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80290e:	e9 41 01 00 00       	jmp    802a54 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802916:	8b 40 0c             	mov    0xc(%eax),%eax
  802919:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291c:	76 21                	jbe    80293f <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80291e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802927:	73 16                	jae    80293f <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292c:	8b 40 0c             	mov    0xc(%eax),%eax
  80292f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802932:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802935:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802938:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80293f:	a1 40 41 80 00       	mov    0x804140,%eax
  802944:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802947:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80294b:	74 07                	je     802954 <alloc_block_BF+0x101>
  80294d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	eb 05                	jmp    802959 <alloc_block_BF+0x106>
  802954:	b8 00 00 00 00       	mov    $0x0,%eax
  802959:	a3 40 41 80 00       	mov    %eax,0x804140
  80295e:	a1 40 41 80 00       	mov    0x804140,%eax
  802963:	85 c0                	test   %eax,%eax
  802965:	0f 85 09 ff ff ff    	jne    802874 <alloc_block_BF+0x21>
  80296b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80296f:	0f 85 ff fe ff ff    	jne    802874 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802975:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802979:	0f 85 d0 00 00 00    	jne    802a4f <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80297f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802982:	8b 40 0c             	mov    0xc(%eax),%eax
  802985:	2b 45 08             	sub    0x8(%ebp),%eax
  802988:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  80298b:	a1 48 41 80 00       	mov    0x804148,%eax
  802990:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802993:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802997:	75 17                	jne    8029b0 <alloc_block_BF+0x15d>
  802999:	83 ec 04             	sub    $0x4,%esp
  80299c:	68 88 3e 80 00       	push   $0x803e88
  8029a1:	68 d1 00 00 00       	push   $0xd1
  8029a6:	68 17 3e 80 00       	push   $0x803e17
  8029ab:	e8 e9 da ff ff       	call   800499 <_panic>
  8029b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b3:	8b 00                	mov    (%eax),%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	74 10                	je     8029c9 <alloc_block_BF+0x176>
  8029b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029c1:	8b 52 04             	mov    0x4(%edx),%edx
  8029c4:	89 50 04             	mov    %edx,0x4(%eax)
  8029c7:	eb 0b                	jmp    8029d4 <alloc_block_BF+0x181>
  8029c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029cc:	8b 40 04             	mov    0x4(%eax),%eax
  8029cf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d7:	8b 40 04             	mov    0x4(%eax),%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	74 0f                	je     8029ed <alloc_block_BF+0x19a>
  8029de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e1:	8b 40 04             	mov    0x4(%eax),%eax
  8029e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029e7:	8b 12                	mov    (%edx),%edx
  8029e9:	89 10                	mov    %edx,(%eax)
  8029eb:	eb 0a                	jmp    8029f7 <alloc_block_BF+0x1a4>
  8029ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	a3 48 41 80 00       	mov    %eax,0x804148
  8029f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0a:	a1 54 41 80 00       	mov    0x804154,%eax
  802a0f:	48                   	dec    %eax
  802a10:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802a15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a18:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1b:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a21:	8b 50 08             	mov    0x8(%eax),%edx
  802a24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a27:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802a2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a30:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a36:	8b 50 08             	mov    0x8(%eax),%edx
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	01 c2                	add    %eax,%edx
  802a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a41:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a47:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802a4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a4d:	eb 05                	jmp    802a54 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802a54:	c9                   	leave  
  802a55:	c3                   	ret    

00802a56 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a5c:	83 ec 04             	sub    $0x4,%esp
  802a5f:	68 a8 3e 80 00       	push   $0x803ea8
  802a64:	68 e8 00 00 00       	push   $0xe8
  802a69:	68 17 3e 80 00       	push   $0x803e17
  802a6e:	e8 26 da ff ff       	call   800499 <_panic>

00802a73 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
  802a76:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802a79:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802a81:	a1 38 41 80 00       	mov    0x804138,%eax
  802a86:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802a89:	a1 44 41 80 00       	mov    0x804144,%eax
  802a8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802a91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a95:	75 68                	jne    802aff <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9b:	75 17                	jne    802ab4 <insert_sorted_with_merge_freeList+0x41>
  802a9d:	83 ec 04             	sub    $0x4,%esp
  802aa0:	68 f4 3d 80 00       	push   $0x803df4
  802aa5:	68 36 01 00 00       	push   $0x136
  802aaa:	68 17 3e 80 00       	push   $0x803e17
  802aaf:	e8 e5 d9 ff ff       	call   800499 <_panic>
  802ab4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	89 10                	mov    %edx,(%eax)
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	74 0d                	je     802ad5 <insert_sorted_with_merge_freeList+0x62>
  802ac8:	a1 38 41 80 00       	mov    0x804138,%eax
  802acd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad0:	89 50 04             	mov    %edx,0x4(%eax)
  802ad3:	eb 08                	jmp    802add <insert_sorted_with_merge_freeList+0x6a>
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aef:	a1 44 41 80 00       	mov    0x804144,%eax
  802af4:	40                   	inc    %eax
  802af5:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802afa:	e9 ba 06 00 00       	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	8b 50 08             	mov    0x8(%eax),%edx
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0b:	01 c2                	add    %eax,%edx
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	8b 40 08             	mov    0x8(%eax),%eax
  802b13:	39 c2                	cmp    %eax,%edx
  802b15:	73 68                	jae    802b7f <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1b:	75 17                	jne    802b34 <insert_sorted_with_merge_freeList+0xc1>
  802b1d:	83 ec 04             	sub    $0x4,%esp
  802b20:	68 30 3e 80 00       	push   $0x803e30
  802b25:	68 3a 01 00 00       	push   $0x13a
  802b2a:	68 17 3e 80 00       	push   $0x803e17
  802b2f:	e8 65 d9 ff ff       	call   800499 <_panic>
  802b34:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	89 50 04             	mov    %edx,0x4(%eax)
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	85 c0                	test   %eax,%eax
  802b48:	74 0c                	je     802b56 <insert_sorted_with_merge_freeList+0xe3>
  802b4a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b52:	89 10                	mov    %edx,(%eax)
  802b54:	eb 08                	jmp    802b5e <insert_sorted_with_merge_freeList+0xeb>
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	a3 38 41 80 00       	mov    %eax,0x804138
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b74:	40                   	inc    %eax
  802b75:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b7a:	e9 3a 06 00 00       	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b82:	8b 50 08             	mov    0x8(%eax),%edx
  802b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b88:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8b:	01 c2                	add    %eax,%edx
  802b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b90:	8b 40 08             	mov    0x8(%eax),%eax
  802b93:	39 c2                	cmp    %eax,%edx
  802b95:	0f 85 90 00 00 00    	jne    802c2b <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba7:	01 c2                	add    %eax,%edx
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc7:	75 17                	jne    802be0 <insert_sorted_with_merge_freeList+0x16d>
  802bc9:	83 ec 04             	sub    $0x4,%esp
  802bcc:	68 f4 3d 80 00       	push   $0x803df4
  802bd1:	68 41 01 00 00       	push   $0x141
  802bd6:	68 17 3e 80 00       	push   $0x803e17
  802bdb:	e8 b9 d8 ff ff       	call   800499 <_panic>
  802be0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	89 10                	mov    %edx,(%eax)
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	74 0d                	je     802c01 <insert_sorted_with_merge_freeList+0x18e>
  802bf4:	a1 48 41 80 00       	mov    0x804148,%eax
  802bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfc:	89 50 04             	mov    %edx,0x4(%eax)
  802bff:	eb 08                	jmp    802c09 <insert_sorted_with_merge_freeList+0x196>
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	a3 48 41 80 00       	mov    %eax,0x804148
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1b:	a1 54 41 80 00       	mov    0x804154,%eax
  802c20:	40                   	inc    %eax
  802c21:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c26:	e9 8e 05 00 00       	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	8b 50 08             	mov    0x8(%eax),%edx
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	8b 40 0c             	mov    0xc(%eax),%eax
  802c37:	01 c2                	add    %eax,%edx
  802c39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3c:	8b 40 08             	mov    0x8(%eax),%eax
  802c3f:	39 c2                	cmp    %eax,%edx
  802c41:	73 68                	jae    802cab <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c47:	75 17                	jne    802c60 <insert_sorted_with_merge_freeList+0x1ed>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 f4 3d 80 00       	push   $0x803df4
  802c51:	68 45 01 00 00       	push   $0x145
  802c56:	68 17 3e 80 00       	push   $0x803e17
  802c5b:	e8 39 d8 ff ff       	call   800499 <_panic>
  802c60:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	89 10                	mov    %edx,(%eax)
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 0d                	je     802c81 <insert_sorted_with_merge_freeList+0x20e>
  802c74:	a1 38 41 80 00       	mov    0x804138,%eax
  802c79:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7c:	89 50 04             	mov    %edx,0x4(%eax)
  802c7f:	eb 08                	jmp    802c89 <insert_sorted_with_merge_freeList+0x216>
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9b:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca0:	40                   	inc    %eax
  802ca1:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802ca6:	e9 0e 05 00 00       	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	8b 50 08             	mov    0x8(%eax),%edx
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	01 c2                	add    %eax,%edx
  802cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	39 c2                	cmp    %eax,%edx
  802cc1:	0f 85 9c 00 00 00    	jne    802d63 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	8b 50 0c             	mov    0xc(%eax),%edx
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd3:	01 c2                	add    %eax,%edx
  802cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd8:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8b 50 08             	mov    0x8(%eax),%edx
  802ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce4:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802cfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cff:	75 17                	jne    802d18 <insert_sorted_with_merge_freeList+0x2a5>
  802d01:	83 ec 04             	sub    $0x4,%esp
  802d04:	68 f4 3d 80 00       	push   $0x803df4
  802d09:	68 4d 01 00 00       	push   $0x14d
  802d0e:	68 17 3e 80 00       	push   $0x803e17
  802d13:	e8 81 d7 ff ff       	call   800499 <_panic>
  802d18:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	89 10                	mov    %edx,(%eax)
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 0d                	je     802d39 <insert_sorted_with_merge_freeList+0x2c6>
  802d2c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d31:	8b 55 08             	mov    0x8(%ebp),%edx
  802d34:	89 50 04             	mov    %edx,0x4(%eax)
  802d37:	eb 08                	jmp    802d41 <insert_sorted_with_merge_freeList+0x2ce>
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	a3 48 41 80 00       	mov    %eax,0x804148
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d53:	a1 54 41 80 00       	mov    0x804154,%eax
  802d58:	40                   	inc    %eax
  802d59:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802d5e:	e9 56 04 00 00       	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802d63:	a1 38 41 80 00       	mov    0x804138,%eax
  802d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6b:	e9 19 04 00 00       	jmp    803189 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 50 08             	mov    0x8(%eax),%edx
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 40 0c             	mov    0xc(%eax),%eax
  802d84:	01 c2                	add    %eax,%edx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	8b 40 08             	mov    0x8(%eax),%eax
  802d8c:	39 c2                	cmp    %eax,%edx
  802d8e:	0f 85 ad 01 00 00    	jne    802f41 <insert_sorted_with_merge_freeList+0x4ce>
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 50 08             	mov    0x8(%eax),%edx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802da0:	01 c2                	add    %eax,%edx
  802da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da5:	8b 40 08             	mov    0x8(%eax),%eax
  802da8:	39 c2                	cmp    %eax,%edx
  802daa:	0f 85 91 01 00 00    	jne    802f41 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 50 0c             	mov    0xc(%eax),%edx
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 48 0c             	mov    0xc(%eax),%ecx
  802dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	01 c8                	add    %ecx,%eax
  802dc4:	01 c2                	add    %eax,%edx
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802de0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ded:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802df4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802df8:	75 17                	jne    802e11 <insert_sorted_with_merge_freeList+0x39e>
  802dfa:	83 ec 04             	sub    $0x4,%esp
  802dfd:	68 88 3e 80 00       	push   $0x803e88
  802e02:	68 5b 01 00 00       	push   $0x15b
  802e07:	68 17 3e 80 00       	push   $0x803e17
  802e0c:	e8 88 d6 ff ff       	call   800499 <_panic>
  802e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 10                	je     802e2a <insert_sorted_with_merge_freeList+0x3b7>
  802e1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e22:	8b 52 04             	mov    0x4(%edx),%edx
  802e25:	89 50 04             	mov    %edx,0x4(%eax)
  802e28:	eb 0b                	jmp    802e35 <insert_sorted_with_merge_freeList+0x3c2>
  802e2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2d:	8b 40 04             	mov    0x4(%eax),%eax
  802e30:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 0f                	je     802e4e <insert_sorted_with_merge_freeList+0x3db>
  802e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e48:	8b 12                	mov    (%edx),%edx
  802e4a:	89 10                	mov    %edx,(%eax)
  802e4c:	eb 0a                	jmp    802e58 <insert_sorted_with_merge_freeList+0x3e5>
  802e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	a3 38 41 80 00       	mov    %eax,0x804138
  802e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6b:	a1 44 41 80 00       	mov    0x804144,%eax
  802e70:	48                   	dec    %eax
  802e71:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7a:	75 17                	jne    802e93 <insert_sorted_with_merge_freeList+0x420>
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	68 f4 3d 80 00       	push   $0x803df4
  802e84:	68 5c 01 00 00       	push   $0x15c
  802e89:	68 17 3e 80 00       	push   $0x803e17
  802e8e:	e8 06 d6 ff ff       	call   800499 <_panic>
  802e93:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 0d                	je     802eb4 <insert_sorted_with_merge_freeList+0x441>
  802ea7:	a1 48 41 80 00       	mov    0x804148,%eax
  802eac:	8b 55 08             	mov    0x8(%ebp),%edx
  802eaf:	89 50 04             	mov    %edx,0x4(%eax)
  802eb2:	eb 08                	jmp    802ebc <insert_sorted_with_merge_freeList+0x449>
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 48 41 80 00       	mov    %eax,0x804148
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 54 41 80 00       	mov    0x804154,%eax
  802ed3:	40                   	inc    %eax
  802ed4:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802ed9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802edd:	75 17                	jne    802ef6 <insert_sorted_with_merge_freeList+0x483>
  802edf:	83 ec 04             	sub    $0x4,%esp
  802ee2:	68 f4 3d 80 00       	push   $0x803df4
  802ee7:	68 5d 01 00 00       	push   $0x15d
  802eec:	68 17 3e 80 00       	push   $0x803e17
  802ef1:	e8 a3 d5 ff ff       	call   800499 <_panic>
  802ef6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802efc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eff:	89 10                	mov    %edx,(%eax)
  802f01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f04:	8b 00                	mov    (%eax),%eax
  802f06:	85 c0                	test   %eax,%eax
  802f08:	74 0d                	je     802f17 <insert_sorted_with_merge_freeList+0x4a4>
  802f0a:	a1 48 41 80 00       	mov    0x804148,%eax
  802f0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f12:	89 50 04             	mov    %edx,0x4(%eax)
  802f15:	eb 08                	jmp    802f1f <insert_sorted_with_merge_freeList+0x4ac>
  802f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f22:	a3 48 41 80 00       	mov    %eax,0x804148
  802f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f31:	a1 54 41 80 00       	mov    0x804154,%eax
  802f36:	40                   	inc    %eax
  802f37:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f3c:	e9 78 02 00 00       	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f44:	8b 50 08             	mov    0x8(%eax),%edx
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4d:	01 c2                	add    %eax,%edx
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 40 08             	mov    0x8(%eax),%eax
  802f55:	39 c2                	cmp    %eax,%edx
  802f57:	0f 83 b8 00 00 00    	jae    803015 <insert_sorted_with_merge_freeList+0x5a2>
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 50 08             	mov    0x8(%eax),%edx
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	8b 40 0c             	mov    0xc(%eax),%eax
  802f69:	01 c2                	add    %eax,%edx
  802f6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6e:	8b 40 08             	mov    0x8(%eax),%eax
  802f71:	39 c2                	cmp    %eax,%edx
  802f73:	0f 85 9c 00 00 00    	jne    803015 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 40 0c             	mov    0xc(%eax),%eax
  802f85:	01 c2                	add    %eax,%edx
  802f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8a:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 50 08             	mov    0x8(%eax),%edx
  802f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f96:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb1:	75 17                	jne    802fca <insert_sorted_with_merge_freeList+0x557>
  802fb3:	83 ec 04             	sub    $0x4,%esp
  802fb6:	68 f4 3d 80 00       	push   $0x803df4
  802fbb:	68 67 01 00 00       	push   $0x167
  802fc0:	68 17 3e 80 00       	push   $0x803e17
  802fc5:	e8 cf d4 ff ff       	call   800499 <_panic>
  802fca:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	89 10                	mov    %edx,(%eax)
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	74 0d                	je     802feb <insert_sorted_with_merge_freeList+0x578>
  802fde:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe6:	89 50 04             	mov    %edx,0x4(%eax)
  802fe9:	eb 08                	jmp    802ff3 <insert_sorted_with_merge_freeList+0x580>
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	a3 48 41 80 00       	mov    %eax,0x804148
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803005:	a1 54 41 80 00       	mov    0x804154,%eax
  80300a:	40                   	inc    %eax
  80300b:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  803010:	e9 a4 01 00 00       	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 50 08             	mov    0x8(%eax),%edx
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 0c             	mov    0xc(%eax),%eax
  803021:	01 c2                	add    %eax,%edx
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	8b 40 08             	mov    0x8(%eax),%eax
  803029:	39 c2                	cmp    %eax,%edx
  80302b:	0f 85 ac 00 00 00    	jne    8030dd <insert_sorted_with_merge_freeList+0x66a>
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	8b 50 08             	mov    0x8(%eax),%edx
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	8b 40 0c             	mov    0xc(%eax),%eax
  80303d:	01 c2                	add    %eax,%edx
  80303f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803042:	8b 40 08             	mov    0x8(%eax),%eax
  803045:	39 c2                	cmp    %eax,%edx
  803047:	0f 83 90 00 00 00    	jae    8030dd <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	8b 50 0c             	mov    0xc(%eax),%edx
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	8b 40 0c             	mov    0xc(%eax),%eax
  803059:	01 c2                	add    %eax,%edx
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803075:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803079:	75 17                	jne    803092 <insert_sorted_with_merge_freeList+0x61f>
  80307b:	83 ec 04             	sub    $0x4,%esp
  80307e:	68 f4 3d 80 00       	push   $0x803df4
  803083:	68 70 01 00 00       	push   $0x170
  803088:	68 17 3e 80 00       	push   $0x803e17
  80308d:	e8 07 d4 ff ff       	call   800499 <_panic>
  803092:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	89 10                	mov    %edx,(%eax)
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 00                	mov    (%eax),%eax
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	74 0d                	je     8030b3 <insert_sorted_with_merge_freeList+0x640>
  8030a6:	a1 48 41 80 00       	mov    0x804148,%eax
  8030ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ae:	89 50 04             	mov    %edx,0x4(%eax)
  8030b1:	eb 08                	jmp    8030bb <insert_sorted_with_merge_freeList+0x648>
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	a3 48 41 80 00       	mov    %eax,0x804148
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cd:	a1 54 41 80 00       	mov    0x804154,%eax
  8030d2:	40                   	inc    %eax
  8030d3:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  8030d8:	e9 dc 00 00 00       	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8030dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e0:	8b 50 08             	mov    0x8(%eax),%edx
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e9:	01 c2                	add    %eax,%edx
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	8b 40 08             	mov    0x8(%eax),%eax
  8030f1:	39 c2                	cmp    %eax,%edx
  8030f3:	0f 83 88 00 00 00    	jae    803181 <insert_sorted_with_merge_freeList+0x70e>
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	8b 50 08             	mov    0x8(%eax),%edx
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	8b 40 0c             	mov    0xc(%eax),%eax
  803105:	01 c2                	add    %eax,%edx
  803107:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310a:	8b 40 08             	mov    0x8(%eax),%eax
  80310d:	39 c2                	cmp    %eax,%edx
  80310f:	73 70                	jae    803181 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803111:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803115:	74 06                	je     80311d <insert_sorted_with_merge_freeList+0x6aa>
  803117:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80311b:	75 17                	jne    803134 <insert_sorted_with_merge_freeList+0x6c1>
  80311d:	83 ec 04             	sub    $0x4,%esp
  803120:	68 54 3e 80 00       	push   $0x803e54
  803125:	68 75 01 00 00       	push   $0x175
  80312a:	68 17 3e 80 00       	push   $0x803e17
  80312f:	e8 65 d3 ff ff       	call   800499 <_panic>
  803134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803137:	8b 10                	mov    (%eax),%edx
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	89 10                	mov    %edx,(%eax)
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	8b 00                	mov    (%eax),%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	74 0b                	je     803152 <insert_sorted_with_merge_freeList+0x6df>
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 00                	mov    (%eax),%eax
  80314c:	8b 55 08             	mov    0x8(%ebp),%edx
  80314f:	89 50 04             	mov    %edx,0x4(%eax)
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 55 08             	mov    0x8(%ebp),%edx
  803158:	89 10                	mov    %edx,(%eax)
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803160:	89 50 04             	mov    %edx,0x4(%eax)
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	8b 00                	mov    (%eax),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	75 08                	jne    803174 <insert_sorted_with_merge_freeList+0x701>
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803174:	a1 44 41 80 00       	mov    0x804144,%eax
  803179:	40                   	inc    %eax
  80317a:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  80317f:	eb 38                	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803181:	a1 40 41 80 00       	mov    0x804140,%eax
  803186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803189:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318d:	74 07                	je     803196 <insert_sorted_with_merge_freeList+0x723>
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	8b 00                	mov    (%eax),%eax
  803194:	eb 05                	jmp    80319b <insert_sorted_with_merge_freeList+0x728>
  803196:	b8 00 00 00 00       	mov    $0x0,%eax
  80319b:	a3 40 41 80 00       	mov    %eax,0x804140
  8031a0:	a1 40 41 80 00       	mov    0x804140,%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	0f 85 c3 fb ff ff    	jne    802d70 <insert_sorted_with_merge_freeList+0x2fd>
  8031ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b1:	0f 85 b9 fb ff ff    	jne    802d70 <insert_sorted_with_merge_freeList+0x2fd>





}
  8031b7:	eb 00                	jmp    8031b9 <insert_sorted_with_merge_freeList+0x746>
  8031b9:	90                   	nop
  8031ba:	c9                   	leave  
  8031bb:	c3                   	ret    

008031bc <__udivdi3>:
  8031bc:	55                   	push   %ebp
  8031bd:	57                   	push   %edi
  8031be:	56                   	push   %esi
  8031bf:	53                   	push   %ebx
  8031c0:	83 ec 1c             	sub    $0x1c,%esp
  8031c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031d3:	89 ca                	mov    %ecx,%edx
  8031d5:	89 f8                	mov    %edi,%eax
  8031d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031db:	85 f6                	test   %esi,%esi
  8031dd:	75 2d                	jne    80320c <__udivdi3+0x50>
  8031df:	39 cf                	cmp    %ecx,%edi
  8031e1:	77 65                	ja     803248 <__udivdi3+0x8c>
  8031e3:	89 fd                	mov    %edi,%ebp
  8031e5:	85 ff                	test   %edi,%edi
  8031e7:	75 0b                	jne    8031f4 <__udivdi3+0x38>
  8031e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ee:	31 d2                	xor    %edx,%edx
  8031f0:	f7 f7                	div    %edi
  8031f2:	89 c5                	mov    %eax,%ebp
  8031f4:	31 d2                	xor    %edx,%edx
  8031f6:	89 c8                	mov    %ecx,%eax
  8031f8:	f7 f5                	div    %ebp
  8031fa:	89 c1                	mov    %eax,%ecx
  8031fc:	89 d8                	mov    %ebx,%eax
  8031fe:	f7 f5                	div    %ebp
  803200:	89 cf                	mov    %ecx,%edi
  803202:	89 fa                	mov    %edi,%edx
  803204:	83 c4 1c             	add    $0x1c,%esp
  803207:	5b                   	pop    %ebx
  803208:	5e                   	pop    %esi
  803209:	5f                   	pop    %edi
  80320a:	5d                   	pop    %ebp
  80320b:	c3                   	ret    
  80320c:	39 ce                	cmp    %ecx,%esi
  80320e:	77 28                	ja     803238 <__udivdi3+0x7c>
  803210:	0f bd fe             	bsr    %esi,%edi
  803213:	83 f7 1f             	xor    $0x1f,%edi
  803216:	75 40                	jne    803258 <__udivdi3+0x9c>
  803218:	39 ce                	cmp    %ecx,%esi
  80321a:	72 0a                	jb     803226 <__udivdi3+0x6a>
  80321c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803220:	0f 87 9e 00 00 00    	ja     8032c4 <__udivdi3+0x108>
  803226:	b8 01 00 00 00       	mov    $0x1,%eax
  80322b:	89 fa                	mov    %edi,%edx
  80322d:	83 c4 1c             	add    $0x1c,%esp
  803230:	5b                   	pop    %ebx
  803231:	5e                   	pop    %esi
  803232:	5f                   	pop    %edi
  803233:	5d                   	pop    %ebp
  803234:	c3                   	ret    
  803235:	8d 76 00             	lea    0x0(%esi),%esi
  803238:	31 ff                	xor    %edi,%edi
  80323a:	31 c0                	xor    %eax,%eax
  80323c:	89 fa                	mov    %edi,%edx
  80323e:	83 c4 1c             	add    $0x1c,%esp
  803241:	5b                   	pop    %ebx
  803242:	5e                   	pop    %esi
  803243:	5f                   	pop    %edi
  803244:	5d                   	pop    %ebp
  803245:	c3                   	ret    
  803246:	66 90                	xchg   %ax,%ax
  803248:	89 d8                	mov    %ebx,%eax
  80324a:	f7 f7                	div    %edi
  80324c:	31 ff                	xor    %edi,%edi
  80324e:	89 fa                	mov    %edi,%edx
  803250:	83 c4 1c             	add    $0x1c,%esp
  803253:	5b                   	pop    %ebx
  803254:	5e                   	pop    %esi
  803255:	5f                   	pop    %edi
  803256:	5d                   	pop    %ebp
  803257:	c3                   	ret    
  803258:	bd 20 00 00 00       	mov    $0x20,%ebp
  80325d:	89 eb                	mov    %ebp,%ebx
  80325f:	29 fb                	sub    %edi,%ebx
  803261:	89 f9                	mov    %edi,%ecx
  803263:	d3 e6                	shl    %cl,%esi
  803265:	89 c5                	mov    %eax,%ebp
  803267:	88 d9                	mov    %bl,%cl
  803269:	d3 ed                	shr    %cl,%ebp
  80326b:	89 e9                	mov    %ebp,%ecx
  80326d:	09 f1                	or     %esi,%ecx
  80326f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803273:	89 f9                	mov    %edi,%ecx
  803275:	d3 e0                	shl    %cl,%eax
  803277:	89 c5                	mov    %eax,%ebp
  803279:	89 d6                	mov    %edx,%esi
  80327b:	88 d9                	mov    %bl,%cl
  80327d:	d3 ee                	shr    %cl,%esi
  80327f:	89 f9                	mov    %edi,%ecx
  803281:	d3 e2                	shl    %cl,%edx
  803283:	8b 44 24 08          	mov    0x8(%esp),%eax
  803287:	88 d9                	mov    %bl,%cl
  803289:	d3 e8                	shr    %cl,%eax
  80328b:	09 c2                	or     %eax,%edx
  80328d:	89 d0                	mov    %edx,%eax
  80328f:	89 f2                	mov    %esi,%edx
  803291:	f7 74 24 0c          	divl   0xc(%esp)
  803295:	89 d6                	mov    %edx,%esi
  803297:	89 c3                	mov    %eax,%ebx
  803299:	f7 e5                	mul    %ebp
  80329b:	39 d6                	cmp    %edx,%esi
  80329d:	72 19                	jb     8032b8 <__udivdi3+0xfc>
  80329f:	74 0b                	je     8032ac <__udivdi3+0xf0>
  8032a1:	89 d8                	mov    %ebx,%eax
  8032a3:	31 ff                	xor    %edi,%edi
  8032a5:	e9 58 ff ff ff       	jmp    803202 <__udivdi3+0x46>
  8032aa:	66 90                	xchg   %ax,%ax
  8032ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032b0:	89 f9                	mov    %edi,%ecx
  8032b2:	d3 e2                	shl    %cl,%edx
  8032b4:	39 c2                	cmp    %eax,%edx
  8032b6:	73 e9                	jae    8032a1 <__udivdi3+0xe5>
  8032b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032bb:	31 ff                	xor    %edi,%edi
  8032bd:	e9 40 ff ff ff       	jmp    803202 <__udivdi3+0x46>
  8032c2:	66 90                	xchg   %ax,%ax
  8032c4:	31 c0                	xor    %eax,%eax
  8032c6:	e9 37 ff ff ff       	jmp    803202 <__udivdi3+0x46>
  8032cb:	90                   	nop

008032cc <__umoddi3>:
  8032cc:	55                   	push   %ebp
  8032cd:	57                   	push   %edi
  8032ce:	56                   	push   %esi
  8032cf:	53                   	push   %ebx
  8032d0:	83 ec 1c             	sub    $0x1c,%esp
  8032d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032eb:	89 f3                	mov    %esi,%ebx
  8032ed:	89 fa                	mov    %edi,%edx
  8032ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032f3:	89 34 24             	mov    %esi,(%esp)
  8032f6:	85 c0                	test   %eax,%eax
  8032f8:	75 1a                	jne    803314 <__umoddi3+0x48>
  8032fa:	39 f7                	cmp    %esi,%edi
  8032fc:	0f 86 a2 00 00 00    	jbe    8033a4 <__umoddi3+0xd8>
  803302:	89 c8                	mov    %ecx,%eax
  803304:	89 f2                	mov    %esi,%edx
  803306:	f7 f7                	div    %edi
  803308:	89 d0                	mov    %edx,%eax
  80330a:	31 d2                	xor    %edx,%edx
  80330c:	83 c4 1c             	add    $0x1c,%esp
  80330f:	5b                   	pop    %ebx
  803310:	5e                   	pop    %esi
  803311:	5f                   	pop    %edi
  803312:	5d                   	pop    %ebp
  803313:	c3                   	ret    
  803314:	39 f0                	cmp    %esi,%eax
  803316:	0f 87 ac 00 00 00    	ja     8033c8 <__umoddi3+0xfc>
  80331c:	0f bd e8             	bsr    %eax,%ebp
  80331f:	83 f5 1f             	xor    $0x1f,%ebp
  803322:	0f 84 ac 00 00 00    	je     8033d4 <__umoddi3+0x108>
  803328:	bf 20 00 00 00       	mov    $0x20,%edi
  80332d:	29 ef                	sub    %ebp,%edi
  80332f:	89 fe                	mov    %edi,%esi
  803331:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803335:	89 e9                	mov    %ebp,%ecx
  803337:	d3 e0                	shl    %cl,%eax
  803339:	89 d7                	mov    %edx,%edi
  80333b:	89 f1                	mov    %esi,%ecx
  80333d:	d3 ef                	shr    %cl,%edi
  80333f:	09 c7                	or     %eax,%edi
  803341:	89 e9                	mov    %ebp,%ecx
  803343:	d3 e2                	shl    %cl,%edx
  803345:	89 14 24             	mov    %edx,(%esp)
  803348:	89 d8                	mov    %ebx,%eax
  80334a:	d3 e0                	shl    %cl,%eax
  80334c:	89 c2                	mov    %eax,%edx
  80334e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803352:	d3 e0                	shl    %cl,%eax
  803354:	89 44 24 04          	mov    %eax,0x4(%esp)
  803358:	8b 44 24 08          	mov    0x8(%esp),%eax
  80335c:	89 f1                	mov    %esi,%ecx
  80335e:	d3 e8                	shr    %cl,%eax
  803360:	09 d0                	or     %edx,%eax
  803362:	d3 eb                	shr    %cl,%ebx
  803364:	89 da                	mov    %ebx,%edx
  803366:	f7 f7                	div    %edi
  803368:	89 d3                	mov    %edx,%ebx
  80336a:	f7 24 24             	mull   (%esp)
  80336d:	89 c6                	mov    %eax,%esi
  80336f:	89 d1                	mov    %edx,%ecx
  803371:	39 d3                	cmp    %edx,%ebx
  803373:	0f 82 87 00 00 00    	jb     803400 <__umoddi3+0x134>
  803379:	0f 84 91 00 00 00    	je     803410 <__umoddi3+0x144>
  80337f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803383:	29 f2                	sub    %esi,%edx
  803385:	19 cb                	sbb    %ecx,%ebx
  803387:	89 d8                	mov    %ebx,%eax
  803389:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80338d:	d3 e0                	shl    %cl,%eax
  80338f:	89 e9                	mov    %ebp,%ecx
  803391:	d3 ea                	shr    %cl,%edx
  803393:	09 d0                	or     %edx,%eax
  803395:	89 e9                	mov    %ebp,%ecx
  803397:	d3 eb                	shr    %cl,%ebx
  803399:	89 da                	mov    %ebx,%edx
  80339b:	83 c4 1c             	add    $0x1c,%esp
  80339e:	5b                   	pop    %ebx
  80339f:	5e                   	pop    %esi
  8033a0:	5f                   	pop    %edi
  8033a1:	5d                   	pop    %ebp
  8033a2:	c3                   	ret    
  8033a3:	90                   	nop
  8033a4:	89 fd                	mov    %edi,%ebp
  8033a6:	85 ff                	test   %edi,%edi
  8033a8:	75 0b                	jne    8033b5 <__umoddi3+0xe9>
  8033aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8033af:	31 d2                	xor    %edx,%edx
  8033b1:	f7 f7                	div    %edi
  8033b3:	89 c5                	mov    %eax,%ebp
  8033b5:	89 f0                	mov    %esi,%eax
  8033b7:	31 d2                	xor    %edx,%edx
  8033b9:	f7 f5                	div    %ebp
  8033bb:	89 c8                	mov    %ecx,%eax
  8033bd:	f7 f5                	div    %ebp
  8033bf:	89 d0                	mov    %edx,%eax
  8033c1:	e9 44 ff ff ff       	jmp    80330a <__umoddi3+0x3e>
  8033c6:	66 90                	xchg   %ax,%ax
  8033c8:	89 c8                	mov    %ecx,%eax
  8033ca:	89 f2                	mov    %esi,%edx
  8033cc:	83 c4 1c             	add    $0x1c,%esp
  8033cf:	5b                   	pop    %ebx
  8033d0:	5e                   	pop    %esi
  8033d1:	5f                   	pop    %edi
  8033d2:	5d                   	pop    %ebp
  8033d3:	c3                   	ret    
  8033d4:	3b 04 24             	cmp    (%esp),%eax
  8033d7:	72 06                	jb     8033df <__umoddi3+0x113>
  8033d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033dd:	77 0f                	ja     8033ee <__umoddi3+0x122>
  8033df:	89 f2                	mov    %esi,%edx
  8033e1:	29 f9                	sub    %edi,%ecx
  8033e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033e7:	89 14 24             	mov    %edx,(%esp)
  8033ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033f2:	8b 14 24             	mov    (%esp),%edx
  8033f5:	83 c4 1c             	add    $0x1c,%esp
  8033f8:	5b                   	pop    %ebx
  8033f9:	5e                   	pop    %esi
  8033fa:	5f                   	pop    %edi
  8033fb:	5d                   	pop    %ebp
  8033fc:	c3                   	ret    
  8033fd:	8d 76 00             	lea    0x0(%esi),%esi
  803400:	2b 04 24             	sub    (%esp),%eax
  803403:	19 fa                	sbb    %edi,%edx
  803405:	89 d1                	mov    %edx,%ecx
  803407:	89 c6                	mov    %eax,%esi
  803409:	e9 71 ff ff ff       	jmp    80337f <__umoddi3+0xb3>
  80340e:	66 90                	xchg   %ax,%ax
  803410:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803414:	72 ea                	jb     803400 <__umoddi3+0x134>
  803416:	89 d9                	mov    %ebx,%ecx
  803418:	e9 62 ff ff ff       	jmp    80337f <__umoddi3+0xb3>
