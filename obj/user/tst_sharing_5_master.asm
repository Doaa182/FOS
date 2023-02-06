
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d8 03 00 00       	call   80040e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
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
  80008d:	68 a0 35 80 00       	push   $0x8035a0
  800092:	6a 12                	push   $0x12
  800094:	68 bc 35 80 00       	push   $0x8035bc
  800099:	e8 ac 04 00 00       	call   80054a <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 cf 16 00 00       	call   801777 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 d8 35 80 00       	push   $0x8035d8
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 0c 36 80 00       	push   $0x80360c
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 68 36 80 00       	push   $0x803668
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 9d 1d 00 00       	call   801e7d <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 9c 36 80 00       	push   $0x80369c
  8000f2:	e8 07 07 00 00       	call   8007fe <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ff:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800110:	89 c1                	mov    %eax,%ecx
  800112:	a1 20 50 80 00       	mov    0x805020,%eax
  800117:	8b 40 74             	mov    0x74(%eax),%eax
  80011a:	52                   	push   %edx
  80011b:	51                   	push   %ecx
  80011c:	50                   	push   %eax
  80011d:	68 dd 36 80 00       	push   $0x8036dd
  800122:	e8 01 1d 00 00       	call   801e28 <sys_create_env>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80012d:	a1 20 50 80 00       	mov    0x805020,%eax
  800132:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800138:	a1 20 50 80 00       	mov    0x805020,%eax
  80013d:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	a1 20 50 80 00       	mov    0x805020,%eax
  80014a:	8b 40 74             	mov    0x74(%eax),%eax
  80014d:	52                   	push   %edx
  80014e:	51                   	push   %ecx
  80014f:	50                   	push   %eax
  800150:	68 dd 36 80 00       	push   $0x8036dd
  800155:	e8 ce 1c 00 00       	call   801e28 <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 51 1a 00 00       	call   801bb6 <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 e8 36 80 00       	push   $0x8036e8
  800177:	e8 77 17 00 00       	call   8018f3 <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 ec 36 80 00       	push   $0x8036ec
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 0c 37 80 00       	push   $0x80370c
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 bc 35 80 00       	push   $0x8035bc
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 ff 19 00 00       	call   801bb6 <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 78 37 80 00       	push   $0x803778
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 bc 35 80 00       	push   $0x8035bc
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 9b 1d 00 00       	call   801f74 <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 62 1c 00 00       	call   801e46 <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 54 1c 00 00       	call   801e46 <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 f6 37 80 00       	push   $0x8037f6
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 5b 30 00 00       	call   80326d <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 d3 1d 00 00       	call   801fee <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 91 19 00 00       	call   801bb6 <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 23 18 00 00       	call   801a56 <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 10 38 80 00       	push   $0x803810
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 6b 19 00 00       	call   801bb6 <sys_calculate_free_frames>
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800250:	29 c2                	sub    %eax,%edx
  800252:	89 d0                	mov    %edx,%eax
  800254:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expected = (1+1) + (1+1);
  800257:	c7 45 e8 04 00 00 00 	movl   $0x4,-0x18(%ebp)
		if ( diff !=  expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff, expected);
  80025e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800261:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800264:	74 1a                	je     800280 <_main+0x248>
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 e8             	pushl  -0x18(%ebp)
  80026c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80026f:	68 30 38 80 00       	push   $0x803830
  800274:	6a 3b                	push   $0x3b
  800276:	68 bc 35 80 00       	push   $0x8035bc
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 78 38 80 00       	push   $0x803878
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 9c 38 80 00       	push   $0x80389c
  800298:	e8 61 05 00 00       	call   8007fe <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002b6:	89 c1                	mov    %eax,%ecx
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 40 74             	mov    0x74(%eax),%eax
  8002c0:	52                   	push   %edx
  8002c1:	51                   	push   %ecx
  8002c2:	50                   	push   %eax
  8002c3:	68 cc 38 80 00       	push   $0x8038cc
  8002c8:	e8 5b 1b 00 00       	call   801e28 <sys_create_env>
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d8:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002de:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e3:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002e9:	89 c1                	mov    %eax,%ecx
  8002eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f0:	8b 40 74             	mov    0x74(%eax),%eax
  8002f3:	52                   	push   %edx
  8002f4:	51                   	push   %ecx
  8002f5:	50                   	push   %eax
  8002f6:	68 d9 38 80 00       	push   $0x8038d9
  8002fb:	e8 28 1b 00 00       	call   801e28 <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 e6 38 80 00       	push   $0x8038e6
  800315:	e8 d9 15 00 00       	call   8018f3 <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 e8 38 80 00       	push   $0x8038e8
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 e8 36 80 00       	push   $0x8036e8
  80033f:	e8 af 15 00 00       	call   8018f3 <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 ec 36 80 00       	push   $0x8036ec
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 15 1c 00 00       	call   801f74 <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 dc 1a 00 00       	call   801e46 <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 ce 1a 00 00       	call   801e46 <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 6d 1c 00 00       	call   801fee <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 e9 1b 00 00       	call   801f74 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 26 18 00 00       	call   801bb6 <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 b8 16 00 00       	call   801a56 <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 08 39 80 00       	push   $0x803908
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 9a 16 00 00       	call   801a56 <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 1e 39 80 00       	push   $0x80391e
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 e2 17 00 00       	call   801bb6 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003d9:	29 c2                	sub    %eax,%edx
  8003db:	89 d0                	mov    %edx,%eax
  8003dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		expected = 1;
  8003e0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 34 39 80 00       	push   $0x803934
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 bc 35 80 00       	push   $0x8035bc
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 cc 1b 00 00       	call   801fd4 <inctst>


	}


	return;
  800408:	90                   	nop
}
  800409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800414:	e8 7d 1a 00 00       	call   801e96 <sys_getenvindex>
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80041c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800431:	01 d0                	add    %edx,%eax
  800433:	c1 e0 04             	shl    $0x4,%eax
  800436:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800440:	a1 20 50 80 00       	mov    0x805020,%eax
  800445:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044b:	84 c0                	test   %al,%al
  80044d:	74 0f                	je     80045e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80044f:	a1 20 50 80 00       	mov    0x805020,%eax
  800454:	05 5c 05 00 00       	add    $0x55c,%eax
  800459:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800462:	7e 0a                	jle    80046e <libmain+0x60>
		binaryname = argv[0];
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 0c             	pushl  0xc(%ebp)
  800474:	ff 75 08             	pushl  0x8(%ebp)
  800477:	e8 bc fb ff ff       	call   800038 <_main>
  80047c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80047f:	e8 1f 18 00 00       	call   801ca3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 f4 39 80 00       	push   $0x8039f4
  80048c:	e8 6d 03 00 00       	call   8007fe <cprintf>
  800491:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800494:	a1 20 50 80 00       	mov    0x805020,%eax
  800499:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80049f:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	52                   	push   %edx
  8004ae:	50                   	push   %eax
  8004af:	68 1c 3a 80 00       	push   $0x803a1c
  8004b4:	e8 45 03 00 00       	call   8007fe <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004cc:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004dd:	51                   	push   %ecx
  8004de:	52                   	push   %edx
  8004df:	50                   	push   %eax
  8004e0:	68 44 3a 80 00       	push   $0x803a44
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 9c 3a 80 00       	push   $0x803a9c
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 f4 39 80 00       	push   $0x8039f4
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 9f 17 00 00       	call   801cbd <sys_enable_interrupt>

	// exit gracefully
	exit();
  80051e:	e8 19 00 00 00       	call   80053c <exit>
}
  800523:	90                   	nop
  800524:	c9                   	leave  
  800525:	c3                   	ret    

00800526 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80052c:	83 ec 0c             	sub    $0xc,%esp
  80052f:	6a 00                	push   $0x0
  800531:	e8 2c 19 00 00       	call   801e62 <sys_destroy_env>
  800536:	83 c4 10             	add    $0x10,%esp
}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <exit>:

void
exit(void)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800542:	e8 81 19 00 00       	call   801ec8 <sys_exit_env>
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800550:	8d 45 10             	lea    0x10(%ebp),%eax
  800553:	83 c0 04             	add    $0x4,%eax
  800556:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800559:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80055e:	85 c0                	test   %eax,%eax
  800560:	74 16                	je     800578 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800562:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	50                   	push   %eax
  80056b:	68 b0 3a 80 00       	push   $0x803ab0
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 b5 3a 80 00       	push   $0x803ab5
  800589:	e8 70 02 00 00       	call   8007fe <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	ff 75 f4             	pushl  -0xc(%ebp)
  80059a:	50                   	push   %eax
  80059b:	e8 f3 01 00 00       	call   800793 <vcprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	6a 00                	push   $0x0
  8005a8:	68 d1 3a 80 00       	push   $0x803ad1
  8005ad:	e8 e1 01 00 00       	call   800793 <vcprintf>
  8005b2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005b5:	e8 82 ff ff ff       	call   80053c <exit>

	// should not return here
	while (1) ;
  8005ba:	eb fe                	jmp    8005ba <_panic+0x70>

008005bc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c7:	8b 50 74             	mov    0x74(%eax),%edx
  8005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	74 14                	je     8005e5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	68 d4 3a 80 00       	push   $0x803ad4
  8005d9:	6a 26                	push   $0x26
  8005db:	68 20 3b 80 00       	push   $0x803b20
  8005e0:	e8 65 ff ff ff       	call   80054a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f3:	e9 c2 00 00 00       	jmp    8006ba <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	85 c0                	test   %eax,%eax
  80060b:	75 08                	jne    800615 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80060d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800610:	e9 a2 00 00 00       	jmp    8006b7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800615:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800623:	eb 69                	jmp    80068e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	84 c0                	test   %al,%al
  800643:	75 46                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800645:	a1 20 50 80 00       	mov    0x805020,%eax
  80064a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800653:	89 d0                	mov    %edx,%eax
  800655:	01 c0                	add    %eax,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	c1 e0 03             	shl    $0x3,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800663:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800666:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80066b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	01 c8                	add    %ecx,%eax
  80067c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067e:	39 c2                	cmp    %eax,%edx
  800680:	75 09                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800682:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800689:	eb 12                	jmp    80069d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80068b:	ff 45 e8             	incl   -0x18(%ebp)
  80068e:	a1 20 50 80 00       	mov    0x805020,%eax
  800693:	8b 50 74             	mov    0x74(%eax),%edx
  800696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800699:	39 c2                	cmp    %eax,%edx
  80069b:	77 88                	ja     800625 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80069d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a1:	75 14                	jne    8006b7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	68 2c 3b 80 00       	push   $0x803b2c
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 20 3b 80 00       	push   $0x803b20
  8006b2:	e8 93 fe ff ff       	call   80054a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006b7:	ff 45 f0             	incl   -0x10(%ebp)
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c0:	0f 8c 32 ff ff ff    	jl     8005f8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006d4:	eb 26                	jmp    8006fc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	01 c0                	add    %eax,%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	c1 e0 03             	shl    $0x3,%eax
  8006ed:	01 c8                	add    %ecx,%eax
  8006ef:	8a 40 04             	mov    0x4(%eax),%al
  8006f2:	3c 01                	cmp    $0x1,%al
  8006f4:	75 03                	jne    8006f9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006f6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f9:	ff 45 e0             	incl   -0x20(%ebp)
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 50 74             	mov    0x74(%eax),%edx
  800704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800707:	39 c2                	cmp    %eax,%edx
  800709:	77 cb                	ja     8006d6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80070b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800711:	74 14                	je     800727 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800713:	83 ec 04             	sub    $0x4,%esp
  800716:	68 80 3b 80 00       	push   $0x803b80
  80071b:	6a 44                	push   $0x44
  80071d:	68 20 3b 80 00       	push   $0x803b20
  800722:	e8 23 fe ff ff       	call   80054a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800727:	90                   	nop
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	8d 48 01             	lea    0x1(%eax),%ecx
  800738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073b:	89 0a                	mov    %ecx,(%edx)
  80073d:	8b 55 08             	mov    0x8(%ebp),%edx
  800740:	88 d1                	mov    %dl,%cl
  800742:	8b 55 0c             	mov    0xc(%ebp),%edx
  800745:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800753:	75 2c                	jne    800781 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800755:	a0 24 50 80 00       	mov    0x805024,%al
  80075a:	0f b6 c0             	movzbl %al,%eax
  80075d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800760:	8b 12                	mov    (%edx),%edx
  800762:	89 d1                	mov    %edx,%ecx
  800764:	8b 55 0c             	mov    0xc(%ebp),%edx
  800767:	83 c2 08             	add    $0x8,%edx
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	50                   	push   %eax
  80076e:	51                   	push   %ecx
  80076f:	52                   	push   %edx
  800770:	e8 80 13 00 00       	call   801af5 <sys_cputs>
  800775:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
  800784:	8b 40 04             	mov    0x4(%eax),%eax
  800787:	8d 50 01             	lea    0x1(%eax),%edx
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800790:	90                   	nop
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a3:	00 00 00 
	b.cnt = 0;
  8007a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ad:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	68 2a 07 80 00       	push   $0x80072a
  8007c2:	e8 11 02 00 00       	call   8009d8 <vprintfmt>
  8007c7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007ca:	a0 24 50 80 00       	mov    0x805024,%al
  8007cf:	0f b6 c0             	movzbl %al,%eax
  8007d2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	50                   	push   %eax
  8007dc:	52                   	push   %edx
  8007dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e3:	83 c0 08             	add    $0x8,%eax
  8007e6:	50                   	push   %eax
  8007e7:	e8 09 13 00 00       	call   801af5 <sys_cputs>
  8007ec:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ef:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8007f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    

008007fe <cprintf>:

int cprintf(const char *fmt, ...) {
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800804:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80080b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 f4             	pushl  -0xc(%ebp)
  80081a:	50                   	push   %eax
  80081b:	e8 73 ff ff ff       	call   800793 <vcprintf>
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800831:	e8 6d 14 00 00       	call   801ca3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800836:	8d 45 0c             	lea    0xc(%ebp),%eax
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 f4             	pushl  -0xc(%ebp)
  800845:	50                   	push   %eax
  800846:	e8 48 ff ff ff       	call   800793 <vcprintf>
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800851:	e8 67 14 00 00       	call   801cbd <sys_enable_interrupt>
	return cnt;
  800856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	83 ec 14             	sub    $0x14,%esp
  800862:	8b 45 10             	mov    0x10(%ebp),%eax
  800865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80086e:	8b 45 18             	mov    0x18(%ebp),%eax
  800871:	ba 00 00 00 00       	mov    $0x0,%edx
  800876:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800879:	77 55                	ja     8008d0 <printnum+0x75>
  80087b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087e:	72 05                	jb     800885 <printnum+0x2a>
  800880:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800883:	77 4b                	ja     8008d0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800885:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800888:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80088b:	8b 45 18             	mov    0x18(%ebp),%eax
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
  800893:	52                   	push   %edx
  800894:	50                   	push   %eax
  800895:	ff 75 f4             	pushl  -0xc(%ebp)
  800898:	ff 75 f0             	pushl  -0x10(%ebp)
  80089b:	e8 84 2a 00 00       	call   803324 <__udivdi3>
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	83 ec 04             	sub    $0x4,%esp
  8008a6:	ff 75 20             	pushl  0x20(%ebp)
  8008a9:	53                   	push   %ebx
  8008aa:	ff 75 18             	pushl  0x18(%ebp)
  8008ad:	52                   	push   %edx
  8008ae:	50                   	push   %eax
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	ff 75 08             	pushl  0x8(%ebp)
  8008b5:	e8 a1 ff ff ff       	call   80085b <printnum>
  8008ba:	83 c4 20             	add    $0x20,%esp
  8008bd:	eb 1a                	jmp    8008d9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	ff 75 20             	pushl  0x20(%ebp)
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d0:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008d7:	7f e6                	jg     8008bf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e7:	53                   	push   %ebx
  8008e8:	51                   	push   %ecx
  8008e9:	52                   	push   %edx
  8008ea:	50                   	push   %eax
  8008eb:	e8 44 2b 00 00       	call   803434 <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 f4 3d 80 00       	add    $0x803df4,%eax
  8008f8:	8a 00                	mov    (%eax),%al
  8008fa:	0f be c0             	movsbl %al,%eax
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	50                   	push   %eax
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
}
  80090c:	90                   	nop
  80090d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800915:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800919:	7e 1c                	jle    800937 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 08             	lea    0x8(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 08             	sub    $0x8,%eax
  800930:	8b 50 04             	mov    0x4(%eax),%edx
  800933:	8b 00                	mov    (%eax),%eax
  800935:	eb 40                	jmp    800977 <getuint+0x65>
	else if (lflag)
  800937:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093b:	74 1e                	je     80095b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 04             	lea    0x4(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	ba 00 00 00 00       	mov    $0x0,%edx
  800959:	eb 1c                	jmp    800977 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	8d 50 04             	lea    0x4(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 10                	mov    %edx,(%eax)
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800980:	7e 1c                	jle    80099e <getint+0x25>
		return va_arg(*ap, long long);
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	8d 50 08             	lea    0x8(%eax),%edx
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 10                	mov    %edx,(%eax)
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	83 e8 08             	sub    $0x8,%eax
  800997:	8b 50 04             	mov    0x4(%eax),%edx
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	eb 38                	jmp    8009d6 <getint+0x5d>
	else if (lflag)
  80099e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a2:	74 1a                	je     8009be <getint+0x45>
		return va_arg(*ap, long);
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 10                	mov    %edx,(%eax)
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	99                   	cltd   
  8009bc:	eb 18                	jmp    8009d6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	8d 50 04             	lea    0x4(%eax),%edx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	89 10                	mov    %edx,(%eax)
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	83 e8 04             	sub    $0x4,%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	99                   	cltd   
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e0:	eb 17                	jmp    8009f9 <vprintfmt+0x21>
			if (ch == '\0')
  8009e2:	85 db                	test   %ebx,%ebx
  8009e4:	0f 84 af 03 00 00    	je     800d99 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	53                   	push   %ebx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	8d 50 01             	lea    0x1(%eax),%edx
  8009ff:	89 55 10             	mov    %edx,0x10(%ebp)
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	0f b6 d8             	movzbl %al,%ebx
  800a07:	83 fb 25             	cmp    $0x25,%ebx
  800a0a:	75 d6                	jne    8009e2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a10:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2f:	8d 50 01             	lea    0x1(%eax),%edx
  800a32:	89 55 10             	mov    %edx,0x10(%ebp)
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	0f b6 d8             	movzbl %al,%ebx
  800a3a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a3d:	83 f8 55             	cmp    $0x55,%eax
  800a40:	0f 87 2b 03 00 00    	ja     800d71 <vprintfmt+0x399>
  800a46:	8b 04 85 18 3e 80 00 	mov    0x803e18(,%eax,4),%eax
  800a4d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a4f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a53:	eb d7                	jmp    800a2c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a55:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a59:	eb d1                	jmp    800a2c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a65:	89 d0                	mov    %edx,%eax
  800a67:	c1 e0 02             	shl    $0x2,%eax
  800a6a:	01 d0                	add    %edx,%eax
  800a6c:	01 c0                	add    %eax,%eax
  800a6e:	01 d8                	add    %ebx,%eax
  800a70:	83 e8 30             	sub    $0x30,%eax
  800a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a76:	8b 45 10             	mov    0x10(%ebp),%eax
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a7e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a81:	7e 3e                	jle    800ac1 <vprintfmt+0xe9>
  800a83:	83 fb 39             	cmp    $0x39,%ebx
  800a86:	7f 39                	jg     800ac1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a88:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a8b:	eb d5                	jmp    800a62 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 c0 04             	add    $0x4,%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa7:	79 83                	jns    800a2c <vprintfmt+0x54>
				width = 0;
  800aa9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab0:	e9 77 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ab5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800abc:	e9 6b ff ff ff       	jmp    800a2c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac6:	0f 89 60 ff ff ff    	jns    800a2c <vprintfmt+0x54>
				width = precision, precision = -1;
  800acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ad9:	e9 4e ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ade:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae1:	e9 46 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae9:	83 c0 04             	add    $0x4,%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	50                   	push   %eax
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			break;
  800b06:	e9 89 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 c0 04             	add    $0x4,%eax
  800b11:	89 45 14             	mov    %eax,0x14(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b1c:	85 db                	test   %ebx,%ebx
  800b1e:	79 02                	jns    800b22 <vprintfmt+0x14a>
				err = -err;
  800b20:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b22:	83 fb 64             	cmp    $0x64,%ebx
  800b25:	7f 0b                	jg     800b32 <vprintfmt+0x15a>
  800b27:	8b 34 9d 60 3c 80 00 	mov    0x803c60(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 05 3e 80 00       	push   $0x803e05
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	e8 5e 02 00 00       	call   800da1 <printfmt>
  800b43:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b46:	e9 49 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4b:	56                   	push   %esi
  800b4c:	68 0e 3e 80 00       	push   $0x803e0e
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 45 02 00 00       	call   800da1 <printfmt>
  800b5c:	83 c4 10             	add    $0x10,%esp
			break;
  800b5f:	e9 30 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	83 c0 04             	add    $0x4,%eax
  800b6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	83 e8 04             	sub    $0x4,%eax
  800b73:	8b 30                	mov    (%eax),%esi
  800b75:	85 f6                	test   %esi,%esi
  800b77:	75 05                	jne    800b7e <vprintfmt+0x1a6>
				p = "(null)";
  800b79:	be 11 3e 80 00       	mov    $0x803e11,%esi
			if (width > 0 && padc != '-')
  800b7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b82:	7e 6d                	jle    800bf1 <vprintfmt+0x219>
  800b84:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b88:	74 67                	je     800bf1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	50                   	push   %eax
  800b91:	56                   	push   %esi
  800b92:	e8 0c 03 00 00       	call   800ea3 <strnlen>
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b9d:	eb 16                	jmp    800bb5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b9f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb9:	7f e4                	jg     800b9f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbb:	eb 34                	jmp    800bf1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc1:	74 1c                	je     800bdf <vprintfmt+0x207>
  800bc3:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc6:	7e 05                	jle    800bcd <vprintfmt+0x1f5>
  800bc8:	83 fb 7e             	cmp    $0x7e,%ebx
  800bcb:	7e 12                	jle    800bdf <vprintfmt+0x207>
					putch('?', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	6a 3f                	push   $0x3f
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	eb 0f                	jmp    800bee <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	53                   	push   %ebx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bee:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf1:	89 f0                	mov    %esi,%eax
  800bf3:	8d 70 01             	lea    0x1(%eax),%esi
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	0f be d8             	movsbl %al,%ebx
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	74 24                	je     800c23 <vprintfmt+0x24b>
  800bff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c03:	78 b8                	js     800bbd <vprintfmt+0x1e5>
  800c05:	ff 4d e0             	decl   -0x20(%ebp)
  800c08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0c:	79 af                	jns    800bbd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0e:	eb 13                	jmp    800c23 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 20                	push   $0x20
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c20:	ff 4d e4             	decl   -0x1c(%ebp)
  800c23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c27:	7f e7                	jg     800c10 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c29:	e9 66 01 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 e8             	pushl  -0x18(%ebp)
  800c34:	8d 45 14             	lea    0x14(%ebp),%eax
  800c37:	50                   	push   %eax
  800c38:	e8 3c fd ff ff       	call   800979 <getint>
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4c:	85 d2                	test   %edx,%edx
  800c4e:	79 23                	jns    800c73 <vprintfmt+0x29b>
				putch('-', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 2d                	push   $0x2d
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c66:	f7 d8                	neg    %eax
  800c68:	83 d2 00             	adc    $0x0,%edx
  800c6b:	f7 da                	neg    %edx
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7a:	e9 bc 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 e8             	pushl  -0x18(%ebp)
  800c85:	8d 45 14             	lea    0x14(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	e8 84 fc ff ff       	call   800912 <getuint>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c9e:	e9 98 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 58                	push   $0x58
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	6a 58                	push   $0x58
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	6a 58                	push   $0x58
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			break;
  800cd3:	e9 bc 00 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	6a 30                	push   $0x30
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	ff d0                	call   *%eax
  800ce5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	6a 78                	push   $0x78
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	ff d0                	call   *%eax
  800cf5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	83 c0 04             	add    $0x4,%eax
  800cfe:	89 45 14             	mov    %eax,0x14(%ebp)
  800d01:	8b 45 14             	mov    0x14(%ebp),%eax
  800d04:	83 e8 04             	sub    $0x4,%eax
  800d07:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d1a:	eb 1f                	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 e8             	pushl  -0x18(%ebp)
  800d22:	8d 45 14             	lea    0x14(%ebp),%eax
  800d25:	50                   	push   %eax
  800d26:	e8 e7 fb ff ff       	call   800912 <getuint>
  800d2b:	83 c4 10             	add    $0x10,%esp
  800d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d34:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	52                   	push   %edx
  800d46:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d49:	50                   	push   %eax
  800d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	ff 75 08             	pushl  0x8(%ebp)
  800d56:	e8 00 fb ff ff       	call   80085b <printnum>
  800d5b:	83 c4 20             	add    $0x20,%esp
			break;
  800d5e:	eb 34                	jmp    800d94 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	53                   	push   %ebx
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	ff d0                	call   *%eax
  800d6c:	83 c4 10             	add    $0x10,%esp
			break;
  800d6f:	eb 23                	jmp    800d94 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d71:	83 ec 08             	sub    $0x8,%esp
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	6a 25                	push   $0x25
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	ff d0                	call   *%eax
  800d7e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d81:	ff 4d 10             	decl   0x10(%ebp)
  800d84:	eb 03                	jmp    800d89 <vprintfmt+0x3b1>
  800d86:	ff 4d 10             	decl   0x10(%ebp)
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	48                   	dec    %eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	3c 25                	cmp    $0x25,%al
  800d91:	75 f3                	jne    800d86 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d93:	90                   	nop
		}
	}
  800d94:	e9 47 fc ff ff       	jmp    8009e0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d99:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800da7:	8d 45 10             	lea    0x10(%ebp),%eax
  800daa:	83 c0 04             	add    $0x4,%eax
  800dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	ff 75 f4             	pushl  -0xc(%ebp)
  800db6:	50                   	push   %eax
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	ff 75 08             	pushl  0x8(%ebp)
  800dbd:	e8 16 fc ff ff       	call   8009d8 <vprintfmt>
  800dc2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dc5:	90                   	nop
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	8b 40 08             	mov    0x8(%eax),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8b 10                	mov    (%eax),%edx
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8b 40 04             	mov    0x4(%eax),%eax
  800de5:	39 c2                	cmp    %eax,%edx
  800de7:	73 12                	jae    800dfb <sprintputch+0x33>
		*b->buf++ = ch;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8b 00                	mov    (%eax),%eax
  800dee:	8d 48 01             	lea    0x1(%eax),%ecx
  800df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df4:	89 0a                	mov    %ecx,(%edx)
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	88 10                	mov    %dl,(%eax)
}
  800dfb:	90                   	nop
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    

00800dfe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e23:	74 06                	je     800e2b <vsnprintf+0x2d>
  800e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e29:	7f 07                	jg     800e32 <vsnprintf+0x34>
		return -E_INVAL;
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	eb 20                	jmp    800e52 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e32:	ff 75 14             	pushl  0x14(%ebp)
  800e35:	ff 75 10             	pushl  0x10(%ebp)
  800e38:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e3b:	50                   	push   %eax
  800e3c:	68 c8 0d 80 00       	push   $0x800dc8
  800e41:	e8 92 fb ff ff       	call   8009d8 <vprintfmt>
  800e46:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e5a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e5d:	83 c0 04             	add    $0x4,%eax
  800e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	ff 75 f4             	pushl  -0xc(%ebp)
  800e69:	50                   	push   %eax
  800e6a:	ff 75 0c             	pushl  0xc(%ebp)
  800e6d:	ff 75 08             	pushl  0x8(%ebp)
  800e70:	e8 89 ff ff ff       	call   800dfe <vsnprintf>
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8d:	eb 06                	jmp    800e95 <strlen+0x15>
		n++;
  800e8f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e92:	ff 45 08             	incl   0x8(%ebp)
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 f1                	jne    800e8f <strlen+0xf>
		n++;
	return n;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb0:	eb 09                	jmp    800ebb <strnlen+0x18>
		n++;
  800eb2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb5:	ff 45 08             	incl   0x8(%ebp)
  800eb8:	ff 4d 0c             	decl   0xc(%ebp)
  800ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebf:	74 09                	je     800eca <strnlen+0x27>
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 e8                	jne    800eb2 <strnlen+0xf>
		n++;
	return n;
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800edb:	90                   	nop
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8d 50 01             	lea    0x1(%eax),%edx
  800ee2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eeb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eee:	8a 12                	mov    (%edx),%dl
  800ef0:	88 10                	mov    %dl,(%eax)
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	75 e4                	jne    800edc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f10:	eb 1f                	jmp    800f31 <strncpy+0x34>
		*dst++ = *src;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8d 50 01             	lea    0x1(%eax),%edx
  800f18:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	84 c0                	test   %al,%al
  800f29:	74 03                	je     800f2e <strncpy+0x31>
			src++;
  800f2b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2e:	ff 45 fc             	incl   -0x4(%ebp)
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f37:	72 d9                	jb     800f12 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 30                	je     800f80 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f50:	eb 16                	jmp    800f68 <strlcpy+0x2a>
			*dst++ = *src++;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f68:	ff 4d 10             	decl   0x10(%ebp)
  800f6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6f:	74 09                	je     800f7a <strlcpy+0x3c>
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 d8                	jne    800f52 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f86:	29 c2                	sub    %eax,%edx
  800f88:	89 d0                	mov    %edx,%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f8f:	eb 06                	jmp    800f97 <strcmp+0xb>
		p++, q++;
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 0e                	je     800fae <strcmp+0x22>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 10                	mov    (%eax),%dl
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	38 c2                	cmp    %al,%dl
  800fac:	74 e3                	je     800f91 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f b6 d0             	movzbl %al,%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 c0             	movzbl %al,%eax
  800fbe:	29 c2                	sub    %eax,%edx
  800fc0:	89 d0                	mov    %edx,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fc7:	eb 09                	jmp    800fd2 <strncmp+0xe>
		n--, p++, q++;
  800fc9:	ff 4d 10             	decl   0x10(%ebp)
  800fcc:	ff 45 08             	incl   0x8(%ebp)
  800fcf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd6:	74 17                	je     800fef <strncmp+0x2b>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	84 c0                	test   %al,%al
  800fdf:	74 0e                	je     800fef <strncmp+0x2b>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 10                	mov    (%eax),%dl
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	38 c2                	cmp    %al,%dl
  800fed:	74 da                	je     800fc9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff3:	75 07                	jne    800ffc <strncmp+0x38>
		return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffa:	eb 14                	jmp    801010 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 c0             	movzbl %al,%eax
  80100c:	29 c2                	sub    %eax,%edx
  80100e:	89 d0                	mov    %edx,%eax
}
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 04             	sub    $0x4,%esp
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101e:	eb 12                	jmp    801032 <strchr+0x20>
		if (*s == c)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801028:	75 05                	jne    80102f <strchr+0x1d>
			return (char *) s;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	eb 11                	jmp    801040 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	84 c0                	test   %al,%al
  801039:	75 e5                	jne    801020 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104e:	eb 0d                	jmp    80105d <strfind+0x1b>
		if (*s == c)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801058:	74 0e                	je     801068 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	84 c0                	test   %al,%al
  801064:	75 ea                	jne    801050 <strfind+0xe>
  801066:	eb 01                	jmp    801069 <strfind+0x27>
		if (*s == c)
			break;
  801068:	90                   	nop
	return (char *) s;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801080:	eb 0e                	jmp    801090 <memset+0x22>
		*p++ = c;
  801082:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801090:	ff 4d f8             	decl   -0x8(%ebp)
  801093:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801097:	79 e9                	jns    801082 <memset+0x14>
		*p++ = c;

	return v;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010b0:	eb 16                	jmp    8010c8 <memcpy+0x2a>
		*d++ = *s++;
  8010b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c4:	8a 12                	mov    (%edx),%dl
  8010c6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 dd                	jne    8010b2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f2:	73 50                	jae    801144 <memmove+0x6a>
  8010f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	01 d0                	add    %edx,%eax
  8010fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ff:	76 43                	jbe    801144 <memmove+0x6a>
		s += n;
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110d:	eb 10                	jmp    80111f <memmove+0x45>
			*--d = *--s;
  80110f:	ff 4d f8             	decl   -0x8(%ebp)
  801112:	ff 4d fc             	decl   -0x4(%ebp)
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801118:	8a 10                	mov    (%eax),%dl
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	8d 50 ff             	lea    -0x1(%eax),%edx
  801125:	89 55 10             	mov    %edx,0x10(%ebp)
  801128:	85 c0                	test   %eax,%eax
  80112a:	75 e3                	jne    80110f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112c:	eb 23                	jmp    801151 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801140:	8a 12                	mov    (%edx),%dl
  801142:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114a:	89 55 10             	mov    %edx,0x10(%ebp)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 dd                	jne    80112e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801168:	eb 2a                	jmp    801194 <memcmp+0x3e>
		if (*s1 != *s2)
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8a 10                	mov    (%eax),%dl
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	38 c2                	cmp    %al,%dl
  801176:	74 16                	je     80118e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	0f b6 d0             	movzbl %al,%edx
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f b6 c0             	movzbl %al,%eax
  801188:	29 c2                	sub    %eax,%edx
  80118a:	89 d0                	mov    %edx,%eax
  80118c:	eb 18                	jmp    8011a6 <memcmp+0x50>
		s1++, s2++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
  801191:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 c9                	jne    80116a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b9:	eb 15                	jmp    8011d0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	0f b6 d0             	movzbl %al,%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	0f b6 c0             	movzbl %al,%eax
  8011c9:	39 c2                	cmp    %eax,%edx
  8011cb:	74 0d                	je     8011da <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011cd:	ff 45 08             	incl   0x8(%ebp)
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d6:	72 e3                	jb     8011bb <memfind+0x13>
  8011d8:	eb 01                	jmp    8011db <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011da:	90                   	nop
	return (void *) s;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f4:	eb 03                	jmp    8011f9 <strtol+0x19>
		s++;
  8011f6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 20                	cmp    $0x20,%al
  801200:	74 f4                	je     8011f6 <strtol+0x16>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 09                	cmp    $0x9,%al
  801209:	74 eb                	je     8011f6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 2b                	cmp    $0x2b,%al
  801212:	75 05                	jne    801219 <strtol+0x39>
		s++;
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	eb 13                	jmp    80122c <strtol+0x4c>
	else if (*s == '-')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 2d                	cmp    $0x2d,%al
  801220:	75 0a                	jne    80122c <strtol+0x4c>
		s++, neg = 1;
  801222:	ff 45 08             	incl   0x8(%ebp)
  801225:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801230:	74 06                	je     801238 <strtol+0x58>
  801232:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801236:	75 20                	jne    801258 <strtol+0x78>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	3c 30                	cmp    $0x30,%al
  80123f:	75 17                	jne    801258 <strtol+0x78>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	40                   	inc    %eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 78                	cmp    $0x78,%al
  801249:	75 0d                	jne    801258 <strtol+0x78>
		s += 2, base = 16;
  80124b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80124f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801256:	eb 28                	jmp    801280 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125c:	75 15                	jne    801273 <strtol+0x93>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 30                	cmp    $0x30,%al
  801265:	75 0c                	jne    801273 <strtol+0x93>
		s++, base = 8;
  801267:	ff 45 08             	incl   0x8(%ebp)
  80126a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801271:	eb 0d                	jmp    801280 <strtol+0xa0>
	else if (base == 0)
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	75 07                	jne    801280 <strtol+0xa0>
		base = 10;
  801279:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 2f                	cmp    $0x2f,%al
  801287:	7e 19                	jle    8012a2 <strtol+0xc2>
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 39                	cmp    $0x39,%al
  801290:	7f 10                	jg     8012a2 <strtol+0xc2>
			dig = *s - '0';
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	83 e8 30             	sub    $0x30,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a0:	eb 42                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 60                	cmp    $0x60,%al
  8012a9:	7e 19                	jle    8012c4 <strtol+0xe4>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 7a                	cmp    $0x7a,%al
  8012b2:	7f 10                	jg     8012c4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	83 e8 57             	sub    $0x57,%eax
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c2:	eb 20                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 40                	cmp    $0x40,%al
  8012cb:	7e 39                	jle    801306 <strtol+0x126>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 5a                	cmp    $0x5a,%al
  8012d4:	7f 30                	jg     801306 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 37             	sub    $0x37,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ea:	7d 19                	jge    801305 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801300:	e9 7b ff ff ff       	jmp    801280 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801305:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130a:	74 08                	je     801314 <strtol+0x134>
		*endptr = (char *) s;
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 07                	je     801321 <strtol+0x141>
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	f7 d8                	neg    %eax
  80131f:	eb 03                	jmp    801324 <strtol+0x144>
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <ltostr>:

void
ltostr(long value, char *str)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801333:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133e:	79 13                	jns    801353 <ltostr+0x2d>
	{
		neg = 1;
  801340:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801350:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135b:	99                   	cltd   
  80135c:	f7 f9                	idiv   %ecx
  80135e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	83 c2 30             	add    $0x30,%edx
  801377:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801381:	f7 e9                	imul   %ecx
  801383:	c1 fa 02             	sar    $0x2,%edx
  801386:	89 c8                	mov    %ecx,%eax
  801388:	c1 f8 1f             	sar    $0x1f,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801395:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80139a:	f7 e9                	imul   %ecx
  80139c:	c1 fa 02             	sar    $0x2,%edx
  80139f:	89 c8                	mov    %ecx,%eax
  8013a1:	c1 f8 1f             	sar    $0x1f,%eax
  8013a4:	29 c2                	sub    %eax,%edx
  8013a6:	89 d0                	mov    %edx,%eax
  8013a8:	c1 e0 02             	shl    $0x2,%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	01 c0                	add    %eax,%eax
  8013af:	29 c1                	sub    %eax,%ecx
  8013b1:	89 ca                	mov    %ecx,%edx
  8013b3:	85 d2                	test   %edx,%edx
  8013b5:	75 9c                	jne    801353 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c1:	48                   	dec    %eax
  8013c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c9:	74 3d                	je     801408 <ltostr+0xe2>
		start = 1 ;
  8013cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013d2:	eb 34                	jmp    801408 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 d0                	add    %edx,%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	01 c2                	add    %eax,%edx
  8013fd:	8a 45 eb             	mov    -0x15(%ebp),%al
  801400:	88 02                	mov    %al,(%edx)
		start++ ;
  801402:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801405:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80140e:	7c c4                	jl     8013d4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801410:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	01 d0                	add    %edx,%eax
  801418:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80141b:	90                   	nop
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 54 fa ff ff       	call   800e80 <strlen>
  80142c:	83 c4 04             	add    $0x4,%esp
  80142f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	e8 46 fa ff ff       	call   800e80 <strlen>
  80143a:	83 c4 04             	add    $0x4,%esp
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144e:	eb 17                	jmp    801467 <strcconcat+0x49>
		final[s] = str1[s] ;
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 10             	mov    0x10(%ebp),%eax
  801456:	01 c2                	add    %eax,%edx
  801458:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 c8                	add    %ecx,%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801464:	ff 45 fc             	incl   -0x4(%ebp)
  801467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80146d:	7c e1                	jl     801450 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80146f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801476:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80147d:	eb 1f                	jmp    80149e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	8d 50 01             	lea    0x1(%eax),%edx
  801485:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801488:	89 c2                	mov    %eax,%edx
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	01 c2                	add    %eax,%edx
  80148f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	01 c8                	add    %ecx,%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80149b:	ff 45 f8             	incl   -0x8(%ebp)
  80149e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a4:	7c d9                	jl     80147f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	c6 00 00             	movb   $0x0,(%eax)
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d7:	eb 0c                	jmp    8014e5 <strsplit+0x31>
			*string++ = 0;
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8d 50 01             	lea    0x1(%eax),%edx
  8014df:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	74 18                	je     801506 <strsplit+0x52>
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	0f be c0             	movsbl %al,%eax
  8014f6:	50                   	push   %eax
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	e8 13 fb ff ff       	call   801012 <strchr>
  8014ff:	83 c4 08             	add    $0x8,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	75 d3                	jne    8014d9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	84 c0                	test   %al,%al
  80150d:	74 5a                	je     801569 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80150f:	8b 45 14             	mov    0x14(%ebp),%eax
  801512:	8b 00                	mov    (%eax),%eax
  801514:	83 f8 0f             	cmp    $0xf,%eax
  801517:	75 07                	jne    801520 <strsplit+0x6c>
		{
			return 0;
  801519:	b8 00 00 00 00       	mov    $0x0,%eax
  80151e:	eb 66                	jmp    801586 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801520:	8b 45 14             	mov    0x14(%ebp),%eax
  801523:	8b 00                	mov    (%eax),%eax
  801525:	8d 48 01             	lea    0x1(%eax),%ecx
  801528:	8b 55 14             	mov    0x14(%ebp),%edx
  80152b:	89 0a                	mov    %ecx,(%edx)
  80152d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	01 c2                	add    %eax,%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80153e:	eb 03                	jmp    801543 <strsplit+0x8f>
			string++;
  801540:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 8b                	je     8014d7 <strsplit+0x23>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f be c0             	movsbl %al,%eax
  801554:	50                   	push   %eax
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 b5 fa ff ff       	call   801012 <strchr>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	74 dc                	je     801540 <strsplit+0x8c>
			string++;
	}
  801564:	e9 6e ff ff ff       	jmp    8014d7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801569:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	01 d0                	add    %edx,%eax
  80157b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801581:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80158e:	a1 04 50 80 00       	mov    0x805004,%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	74 1f                	je     8015b6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801597:	e8 1d 00 00 00       	call   8015b9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	68 70 3f 80 00       	push   $0x803f70
  8015a4:	e8 55 f2 ff ff       	call   8007fe <cprintf>
  8015a9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8015ac:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8015b3:	00 00 00 
	}
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  8015bf:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8015c6:	00 00 00 
  8015c9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8015d0:	00 00 00 
  8015d3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8015da:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8015dd:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8015e4:	00 00 00 
  8015e7:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8015ee:	00 00 00 
  8015f1:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8015f8:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8015fb:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801605:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80160a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80160f:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801614:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80161b:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80161e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801628:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80162d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801630:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801633:	ba 00 00 00 00       	mov    $0x0,%edx
  801638:	f7 75 f0             	divl   -0x10(%ebp)
  80163b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163e:	29 d0                	sub    %edx,%eax
  801640:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801643:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80164a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80164d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801652:	2d 00 10 00 00       	sub    $0x1000,%eax
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	6a 06                	push   $0x6
  80165c:	ff 75 e8             	pushl  -0x18(%ebp)
  80165f:	50                   	push   %eax
  801660:	e8 d4 05 00 00       	call   801c39 <sys_allocate_chunk>
  801665:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801668:	a1 20 51 80 00       	mov    0x805120,%eax
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	50                   	push   %eax
  801671:	e8 49 0c 00 00       	call   8022bf <initialize_MemBlocksList>
  801676:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  801679:	a1 48 51 80 00       	mov    0x805148,%eax
  80167e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801681:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801685:	75 14                	jne    80169b <initialize_dyn_block_system+0xe2>
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	68 95 3f 80 00       	push   $0x803f95
  80168f:	6a 39                	push   $0x39
  801691:	68 b3 3f 80 00       	push   $0x803fb3
  801696:	e8 af ee ff ff       	call   80054a <_panic>
  80169b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169e:	8b 00                	mov    (%eax),%eax
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	74 10                	je     8016b4 <initialize_dyn_block_system+0xfb>
  8016a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a7:	8b 00                	mov    (%eax),%eax
  8016a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016ac:	8b 52 04             	mov    0x4(%edx),%edx
  8016af:	89 50 04             	mov    %edx,0x4(%eax)
  8016b2:	eb 0b                	jmp    8016bf <initialize_dyn_block_system+0x106>
  8016b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b7:	8b 40 04             	mov    0x4(%eax),%eax
  8016ba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8016bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c2:	8b 40 04             	mov    0x4(%eax),%eax
  8016c5:	85 c0                	test   %eax,%eax
  8016c7:	74 0f                	je     8016d8 <initialize_dyn_block_system+0x11f>
  8016c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016cc:	8b 40 04             	mov    0x4(%eax),%eax
  8016cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016d2:	8b 12                	mov    (%edx),%edx
  8016d4:	89 10                	mov    %edx,(%eax)
  8016d6:	eb 0a                	jmp    8016e2 <initialize_dyn_block_system+0x129>
  8016d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016db:	8b 00                	mov    (%eax),%eax
  8016dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8016e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8016fa:	48                   	dec    %eax
  8016fb:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801703:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80170a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80170d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801714:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801718:	75 14                	jne    80172e <initialize_dyn_block_system+0x175>
  80171a:	83 ec 04             	sub    $0x4,%esp
  80171d:	68 c0 3f 80 00       	push   $0x803fc0
  801722:	6a 3f                	push   $0x3f
  801724:	68 b3 3f 80 00       	push   $0x803fb3
  801729:	e8 1c ee ff ff       	call   80054a <_panic>
  80172e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801737:	89 10                	mov    %edx,(%eax)
  801739:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173c:	8b 00                	mov    (%eax),%eax
  80173e:	85 c0                	test   %eax,%eax
  801740:	74 0d                	je     80174f <initialize_dyn_block_system+0x196>
  801742:	a1 38 51 80 00       	mov    0x805138,%eax
  801747:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80174a:	89 50 04             	mov    %edx,0x4(%eax)
  80174d:	eb 08                	jmp    801757 <initialize_dyn_block_system+0x19e>
  80174f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801752:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801757:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80175a:	a3 38 51 80 00       	mov    %eax,0x805138
  80175f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801762:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801769:	a1 44 51 80 00       	mov    0x805144,%eax
  80176e:	40                   	inc    %eax
  80176f:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80177d:	e8 06 fe ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  801782:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801786:	75 07                	jne    80178f <malloc+0x18>
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
  80178d:	eb 7d                	jmp    80180c <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  80178f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801796:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80179d:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a3:	01 d0                	add    %edx,%eax
  8017a5:	48                   	dec    %eax
  8017a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b1:	f7 75 f0             	divl   -0x10(%ebp)
  8017b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b7:	29 d0                	sub    %edx,%eax
  8017b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  8017bc:	e8 46 08 00 00       	call   802007 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c1:	83 f8 01             	cmp    $0x1,%eax
  8017c4:	75 07                	jne    8017cd <malloc+0x56>
  8017c6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8017cd:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8017d1:	75 34                	jne    801807 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8017d3:	83 ec 0c             	sub    $0xc,%esp
  8017d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d9:	e8 73 0e 00 00       	call   802651 <alloc_block_FF>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  8017e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017e8:	74 16                	je     801800 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  8017ea:	83 ec 0c             	sub    $0xc,%esp
  8017ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017f0:	e8 ff 0b 00 00       	call   8023f4 <insert_sorted_allocList>
  8017f5:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8017f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017fb:	8b 40 08             	mov    0x8(%eax),%eax
  8017fe:	eb 0c                	jmp    80180c <malloc+0x95>
	             }
	             else
	             	return NULL;
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
  801805:	eb 05                	jmp    80180c <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801807:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80181a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801823:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801828:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80182b:	83 ec 08             	sub    $0x8,%esp
  80182e:	ff 75 f4             	pushl  -0xc(%ebp)
  801831:	68 40 50 80 00       	push   $0x805040
  801836:	e8 61 0b 00 00       	call   80239c <find_block>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801841:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801845:	0f 84 a5 00 00 00    	je     8018f0 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  80184b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184e:	8b 40 0c             	mov    0xc(%eax),%eax
  801851:	83 ec 08             	sub    $0x8,%esp
  801854:	50                   	push   %eax
  801855:	ff 75 f4             	pushl  -0xc(%ebp)
  801858:	e8 a4 03 00 00       	call   801c01 <sys_free_user_mem>
  80185d:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801860:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801864:	75 17                	jne    80187d <free+0x6f>
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	68 95 3f 80 00       	push   $0x803f95
  80186e:	68 87 00 00 00       	push   $0x87
  801873:	68 b3 3f 80 00       	push   $0x803fb3
  801878:	e8 cd ec ff ff       	call   80054a <_panic>
  80187d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801880:	8b 00                	mov    (%eax),%eax
  801882:	85 c0                	test   %eax,%eax
  801884:	74 10                	je     801896 <free+0x88>
  801886:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801889:	8b 00                	mov    (%eax),%eax
  80188b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80188e:	8b 52 04             	mov    0x4(%edx),%edx
  801891:	89 50 04             	mov    %edx,0x4(%eax)
  801894:	eb 0b                	jmp    8018a1 <free+0x93>
  801896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801899:	8b 40 04             	mov    0x4(%eax),%eax
  80189c:	a3 44 50 80 00       	mov    %eax,0x805044
  8018a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a4:	8b 40 04             	mov    0x4(%eax),%eax
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	74 0f                	je     8018ba <free+0xac>
  8018ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ae:	8b 40 04             	mov    0x4(%eax),%eax
  8018b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018b4:	8b 12                	mov    (%edx),%edx
  8018b6:	89 10                	mov    %edx,(%eax)
  8018b8:	eb 0a                	jmp    8018c4 <free+0xb6>
  8018ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018bd:	8b 00                	mov    (%eax),%eax
  8018bf:	a3 40 50 80 00       	mov    %eax,0x805040
  8018c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018d7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8018dc:	48                   	dec    %eax
  8018dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  8018e2:	83 ec 0c             	sub    $0xc,%esp
  8018e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8018e8:	e8 37 12 00 00       	call   802b24 <insert_sorted_with_merge_freeList>
  8018ed:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  8018f0:	90                   	nop
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	83 ec 38             	sub    $0x38,%esp
  8018f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fc:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018ff:	e8 84 fc ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  801904:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801908:	75 07                	jne    801911 <smalloc+0x1e>
  80190a:	b8 00 00 00 00       	mov    $0x0,%eax
  80190f:	eb 7e                	jmp    80198f <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801911:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801918:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801925:	01 d0                	add    %edx,%eax
  801927:	48                   	dec    %eax
  801928:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80192b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80192e:	ba 00 00 00 00       	mov    $0x0,%edx
  801933:	f7 75 f0             	divl   -0x10(%ebp)
  801936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801939:	29 d0                	sub    %edx,%eax
  80193b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80193e:	e8 c4 06 00 00       	call   802007 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801943:	83 f8 01             	cmp    $0x1,%eax
  801946:	75 42                	jne    80198a <smalloc+0x97>

		  va = malloc(newsize) ;
  801948:	83 ec 0c             	sub    $0xc,%esp
  80194b:	ff 75 e8             	pushl  -0x18(%ebp)
  80194e:	e8 24 fe ff ff       	call   801777 <malloc>
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801959:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80195d:	74 24                	je     801983 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  80195f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801963:	ff 75 e4             	pushl  -0x1c(%ebp)
  801966:	50                   	push   %eax
  801967:	ff 75 e8             	pushl  -0x18(%ebp)
  80196a:	ff 75 08             	pushl  0x8(%ebp)
  80196d:	e8 1a 04 00 00       	call   801d8c <sys_createSharedObject>
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801978:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80197c:	78 0c                	js     80198a <smalloc+0x97>
					  return va ;
  80197e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801981:	eb 0c                	jmp    80198f <smalloc+0x9c>
				 }
				 else
					return NULL;
  801983:	b8 00 00 00 00       	mov    $0x0,%eax
  801988:	eb 05                	jmp    80198f <smalloc+0x9c>
	  }
		  return NULL ;
  80198a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801997:	e8 ec fb ff ff       	call   801588 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  80199c:	83 ec 08             	sub    $0x8,%esp
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	ff 75 08             	pushl  0x8(%ebp)
  8019a5:	e8 0c 04 00 00       	call   801db6 <sys_getSizeOfSharedObject>
  8019aa:	83 c4 10             	add    $0x10,%esp
  8019ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  8019b0:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8019b4:	75 07                	jne    8019bd <sget+0x2c>
  8019b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8019bb:	eb 75                	jmp    801a32 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8019bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ca:	01 d0                	add    %edx,%eax
  8019cc:	48                   	dec    %eax
  8019cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d8:	f7 75 f0             	divl   -0x10(%ebp)
  8019db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019de:	29 d0                	sub    %edx,%eax
  8019e0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  8019e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8019ea:	e8 18 06 00 00       	call   802007 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019ef:	83 f8 01             	cmp    $0x1,%eax
  8019f2:	75 39                	jne    801a2d <sget+0x9c>

		  va = malloc(newsize) ;
  8019f4:	83 ec 0c             	sub    $0xc,%esp
  8019f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8019fa:	e8 78 fd ff ff       	call   801777 <malloc>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801a05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a09:	74 22                	je     801a2d <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	ff 75 e0             	pushl  -0x20(%ebp)
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	ff 75 08             	pushl  0x8(%ebp)
  801a17:	e8 b7 03 00 00       	call   801dd3 <sys_getSharedObject>
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801a22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a26:	78 05                	js     801a2d <sget+0x9c>
					  return va;
  801a28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a2b:	eb 05                	jmp    801a32 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801a2d:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801a32:	c9                   	leave  
  801a33:	c3                   	ret    

00801a34 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a3a:	e8 49 fb ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a3f:	83 ec 04             	sub    $0x4,%esp
  801a42:	68 e4 3f 80 00       	push   $0x803fe4
  801a47:	68 1e 01 00 00       	push   $0x11e
  801a4c:	68 b3 3f 80 00       	push   $0x803fb3
  801a51:	e8 f4 ea ff ff       	call   80054a <_panic>

00801a56 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a5c:	83 ec 04             	sub    $0x4,%esp
  801a5f:	68 0c 40 80 00       	push   $0x80400c
  801a64:	68 32 01 00 00       	push   $0x132
  801a69:	68 b3 3f 80 00       	push   $0x803fb3
  801a6e:	e8 d7 ea ff ff       	call   80054a <_panic>

00801a73 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	68 30 40 80 00       	push   $0x804030
  801a81:	68 3d 01 00 00       	push   $0x13d
  801a86:	68 b3 3f 80 00       	push   $0x803fb3
  801a8b:	e8 ba ea ff ff       	call   80054a <_panic>

00801a90 <shrink>:

}
void shrink(uint32 newSize)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a96:	83 ec 04             	sub    $0x4,%esp
  801a99:	68 30 40 80 00       	push   $0x804030
  801a9e:	68 42 01 00 00       	push   $0x142
  801aa3:	68 b3 3f 80 00       	push   $0x803fb3
  801aa8:	e8 9d ea ff ff       	call   80054a <_panic>

00801aad <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ab3:	83 ec 04             	sub    $0x4,%esp
  801ab6:	68 30 40 80 00       	push   $0x804030
  801abb:	68 47 01 00 00       	push   $0x147
  801ac0:	68 b3 3f 80 00       	push   $0x803fb3
  801ac5:	e8 80 ea ff ff       	call   80054a <_panic>

00801aca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	57                   	push   %edi
  801ace:	56                   	push   %esi
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801adc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801adf:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ae2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ae5:	cd 30                	int    $0x30
  801ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	5b                   	pop    %ebx
  801af1:	5e                   	pop    %esi
  801af2:	5f                   	pop    %edi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    

00801af5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 04             	sub    $0x4,%esp
  801afb:	8b 45 10             	mov    0x10(%ebp),%eax
  801afe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b01:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	52                   	push   %edx
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	50                   	push   %eax
  801b11:	6a 00                	push   $0x0
  801b13:	e8 b2 ff ff ff       	call   801aca <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	90                   	nop
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_cgetc>:

int
sys_cgetc(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 01                	push   $0x1
  801b2d:	e8 98 ff ff ff       	call   801aca <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 05                	push   $0x5
  801b4a:	e8 7b ff ff ff       	call   801aca <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b59:	8b 75 18             	mov    0x18(%ebp),%esi
  801b5c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	56                   	push   %esi
  801b69:	53                   	push   %ebx
  801b6a:	51                   	push   %ecx
  801b6b:	52                   	push   %edx
  801b6c:	50                   	push   %eax
  801b6d:	6a 06                	push   $0x6
  801b6f:	e8 56 ff ff ff       	call   801aca <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5e                   	pop    %esi
  801b7c:	5d                   	pop    %ebp
  801b7d:	c3                   	ret    

00801b7e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	52                   	push   %edx
  801b8e:	50                   	push   %eax
  801b8f:	6a 07                	push   $0x7
  801b91:	e8 34 ff ff ff       	call   801aca <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	ff 75 0c             	pushl  0xc(%ebp)
  801ba7:	ff 75 08             	pushl  0x8(%ebp)
  801baa:	6a 08                	push   $0x8
  801bac:	e8 19 ff ff ff       	call   801aca <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 09                	push   $0x9
  801bc5:	e8 00 ff ff ff       	call   801aca <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 0a                	push   $0xa
  801bde:	e8 e7 fe ff ff       	call   801aca <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 0b                	push   $0xb
  801bf7:	e8 ce fe ff ff       	call   801aca <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	ff 75 08             	pushl  0x8(%ebp)
  801c10:	6a 0f                	push   $0xf
  801c12:	e8 b3 fe ff ff       	call   801aca <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
	return;
  801c1a:	90                   	nop
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	ff 75 0c             	pushl  0xc(%ebp)
  801c29:	ff 75 08             	pushl  0x8(%ebp)
  801c2c:	6a 10                	push   $0x10
  801c2e:	e8 97 fe ff ff       	call   801aca <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
	return ;
  801c36:	90                   	nop
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	ff 75 10             	pushl  0x10(%ebp)
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	ff 75 08             	pushl  0x8(%ebp)
  801c49:	6a 11                	push   $0x11
  801c4b:	e8 7a fe ff ff       	call   801aca <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
	return ;
  801c53:	90                   	nop
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 0c                	push   $0xc
  801c65:	e8 60 fe ff ff       	call   801aca <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	6a 0d                	push   $0xd
  801c7f:	e8 46 fe ff ff       	call   801aca <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 0e                	push   $0xe
  801c98:	e8 2d fe ff ff       	call   801aca <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	90                   	nop
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 13                	push   $0x13
  801cb2:	e8 13 fe ff ff       	call   801aca <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	90                   	nop
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 14                	push   $0x14
  801ccc:	e8 f9 fd ff ff       	call   801aca <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	90                   	nop
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_cputc>:


void
sys_cputc(const char c)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 04             	sub    $0x4,%esp
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ce3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	50                   	push   %eax
  801cf0:	6a 15                	push   $0x15
  801cf2:	e8 d3 fd ff ff       	call   801aca <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	90                   	nop
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 16                	push   $0x16
  801d0c:	e8 b9 fd ff ff       	call   801aca <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
}
  801d14:	90                   	nop
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	50                   	push   %eax
  801d27:	6a 17                	push   $0x17
  801d29:	e8 9c fd ff ff       	call   801aca <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	52                   	push   %edx
  801d43:	50                   	push   %eax
  801d44:	6a 1a                	push   $0x1a
  801d46:	e8 7f fd ff ff       	call   801aca <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	52                   	push   %edx
  801d60:	50                   	push   %eax
  801d61:	6a 18                	push   $0x18
  801d63:	e8 62 fd ff ff       	call   801aca <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	90                   	nop
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	52                   	push   %edx
  801d7e:	50                   	push   %eax
  801d7f:	6a 19                	push   $0x19
  801d81:	e8 44 fd ff ff       	call   801aca <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
}
  801d89:	90                   	nop
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 04             	sub    $0x4,%esp
  801d92:	8b 45 10             	mov    0x10(%ebp),%eax
  801d95:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d98:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d9b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	6a 00                	push   $0x0
  801da4:	51                   	push   %ecx
  801da5:	52                   	push   %edx
  801da6:	ff 75 0c             	pushl  0xc(%ebp)
  801da9:	50                   	push   %eax
  801daa:	6a 1b                	push   $0x1b
  801dac:	e8 19 fd ff ff       	call   801aca <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	52                   	push   %edx
  801dc6:	50                   	push   %eax
  801dc7:	6a 1c                	push   $0x1c
  801dc9:	e8 fc fc ff ff       	call   801aca <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801dd6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	51                   	push   %ecx
  801de4:	52                   	push   %edx
  801de5:	50                   	push   %eax
  801de6:	6a 1d                	push   $0x1d
  801de8:	e8 dd fc ff ff       	call   801aca <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801df5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	52                   	push   %edx
  801e02:	50                   	push   %eax
  801e03:	6a 1e                	push   $0x1e
  801e05:	e8 c0 fc ff ff       	call   801aca <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 1f                	push   $0x1f
  801e1e:	e8 a7 fc ff ff       	call   801aca <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	6a 00                	push   $0x0
  801e30:	ff 75 14             	pushl  0x14(%ebp)
  801e33:	ff 75 10             	pushl  0x10(%ebp)
  801e36:	ff 75 0c             	pushl  0xc(%ebp)
  801e39:	50                   	push   %eax
  801e3a:	6a 20                	push   $0x20
  801e3c:	e8 89 fc ff ff       	call   801aca <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	50                   	push   %eax
  801e55:	6a 21                	push   $0x21
  801e57:	e8 6e fc ff ff       	call   801aca <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
}
  801e5f:	90                   	nop
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	50                   	push   %eax
  801e71:	6a 22                	push   $0x22
  801e73:	e8 52 fc ff ff       	call   801aca <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 02                	push   $0x2
  801e8c:	e8 39 fc ff ff       	call   801aca <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 03                	push   $0x3
  801ea5:	e8 20 fc ff ff       	call   801aca <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 04                	push   $0x4
  801ebe:	e8 07 fc ff ff       	call   801aca <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_exit_env>:


void sys_exit_env(void)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 23                	push   $0x23
  801ed7:	e8 ee fb ff ff       	call   801aca <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	90                   	nop
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ee8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eeb:	8d 50 04             	lea    0x4(%eax),%edx
  801eee:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	52                   	push   %edx
  801ef8:	50                   	push   %eax
  801ef9:	6a 24                	push   $0x24
  801efb:	e8 ca fb ff ff       	call   801aca <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
	return result;
  801f03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f06:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f09:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f0c:	89 01                	mov    %eax,(%ecx)
  801f0e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	c9                   	leave  
  801f15:	c2 04 00             	ret    $0x4

00801f18 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	ff 75 10             	pushl  0x10(%ebp)
  801f22:	ff 75 0c             	pushl  0xc(%ebp)
  801f25:	ff 75 08             	pushl  0x8(%ebp)
  801f28:	6a 12                	push   $0x12
  801f2a:	e8 9b fb ff ff       	call   801aca <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f32:	90                   	nop
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 25                	push   $0x25
  801f44:	e8 81 fb ff ff       	call   801aca <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 04             	sub    $0x4,%esp
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f5a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	50                   	push   %eax
  801f67:	6a 26                	push   $0x26
  801f69:	e8 5c fb ff ff       	call   801aca <syscall>
  801f6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f71:	90                   	nop
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <rsttst>:
void rsttst()
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 28                	push   $0x28
  801f83:	e8 42 fb ff ff       	call   801aca <syscall>
  801f88:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8b:	90                   	nop
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	8b 45 14             	mov    0x14(%ebp),%eax
  801f97:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f9a:	8b 55 18             	mov    0x18(%ebp),%edx
  801f9d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fa1:	52                   	push   %edx
  801fa2:	50                   	push   %eax
  801fa3:	ff 75 10             	pushl  0x10(%ebp)
  801fa6:	ff 75 0c             	pushl  0xc(%ebp)
  801fa9:	ff 75 08             	pushl  0x8(%ebp)
  801fac:	6a 27                	push   $0x27
  801fae:	e8 17 fb ff ff       	call   801aca <syscall>
  801fb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb6:	90                   	nop
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <chktst>:
void chktst(uint32 n)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	ff 75 08             	pushl  0x8(%ebp)
  801fc7:	6a 29                	push   $0x29
  801fc9:	e8 fc fa ff ff       	call   801aca <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd1:	90                   	nop
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <inctst>:

void inctst()
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 2a                	push   $0x2a
  801fe3:	e8 e2 fa ff ff       	call   801aca <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
	return ;
  801feb:	90                   	nop
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <gettst>:
uint32 gettst()
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 2b                	push   $0x2b
  801ffd:	e8 c8 fa ff ff       	call   801aca <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 2c                	push   $0x2c
  802019:	e8 ac fa ff ff       	call   801aca <syscall>
  80201e:	83 c4 18             	add    $0x18,%esp
  802021:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802024:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802028:	75 07                	jne    802031 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80202a:	b8 01 00 00 00       	mov    $0x1,%eax
  80202f:	eb 05                	jmp    802036 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802031:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 2c                	push   $0x2c
  80204a:	e8 7b fa ff ff       	call   801aca <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
  802052:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802055:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802059:	75 07                	jne    802062 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80205b:	b8 01 00 00 00       	mov    $0x1,%eax
  802060:	eb 05                	jmp    802067 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802062:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 2c                	push   $0x2c
  80207b:	e8 4a fa ff ff       	call   801aca <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
  802083:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802086:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80208a:	75 07                	jne    802093 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80208c:	b8 01 00 00 00       	mov    $0x1,%eax
  802091:	eb 05                	jmp    802098 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802093:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 2c                	push   $0x2c
  8020ac:	e8 19 fa ff ff       	call   801aca <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
  8020b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020b7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020bb:	75 07                	jne    8020c4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c2:	eb 05                	jmp    8020c9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	6a 2d                	push   $0x2d
  8020db:	e8 ea f9 ff ff       	call   801aca <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8020e3:	90                   	nop
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f6:	6a 00                	push   $0x0
  8020f8:	53                   	push   %ebx
  8020f9:	51                   	push   %ecx
  8020fa:	52                   	push   %edx
  8020fb:	50                   	push   %eax
  8020fc:	6a 2e                	push   $0x2e
  8020fe:	e8 c7 f9 ff ff       	call   801aca <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80210e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	52                   	push   %edx
  80211b:	50                   	push   %eax
  80211c:	6a 2f                	push   $0x2f
  80211e:	e8 a7 f9 ff ff       	call   801aca <syscall>
  802123:	83 c4 18             	add    $0x18,%esp
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80212e:	83 ec 0c             	sub    $0xc,%esp
  802131:	68 40 40 80 00       	push   $0x804040
  802136:	e8 c3 e6 ff ff       	call   8007fe <cprintf>
  80213b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80213e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802145:	83 ec 0c             	sub    $0xc,%esp
  802148:	68 6c 40 80 00       	push   $0x80406c
  80214d:	e8 ac e6 ff ff       	call   8007fe <cprintf>
  802152:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802155:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802159:	a1 38 51 80 00       	mov    0x805138,%eax
  80215e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802161:	eb 56                	jmp    8021b9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802163:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802167:	74 1c                	je     802185 <print_mem_block_lists+0x5d>
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	8b 50 08             	mov    0x8(%eax),%edx
  80216f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802172:	8b 48 08             	mov    0x8(%eax),%ecx
  802175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802178:	8b 40 0c             	mov    0xc(%eax),%eax
  80217b:	01 c8                	add    %ecx,%eax
  80217d:	39 c2                	cmp    %eax,%edx
  80217f:	73 04                	jae    802185 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802181:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	8b 50 08             	mov    0x8(%eax),%edx
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	8b 40 0c             	mov    0xc(%eax),%eax
  802191:	01 c2                	add    %eax,%edx
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 40 08             	mov    0x8(%eax),%eax
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	52                   	push   %edx
  80219d:	50                   	push   %eax
  80219e:	68 81 40 80 00       	push   $0x804081
  8021a3:	e8 56 e6 ff ff       	call   8007fe <cprintf>
  8021a8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8021b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bd:	74 07                	je     8021c6 <print_mem_block_lists+0x9e>
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 00                	mov    (%eax),%eax
  8021c4:	eb 05                	jmp    8021cb <print_mem_block_lists+0xa3>
  8021c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cb:	a3 40 51 80 00       	mov    %eax,0x805140
  8021d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	75 8a                	jne    802163 <print_mem_block_lists+0x3b>
  8021d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021dd:	75 84                	jne    802163 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021df:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021e3:	75 10                	jne    8021f5 <print_mem_block_lists+0xcd>
  8021e5:	83 ec 0c             	sub    $0xc,%esp
  8021e8:	68 90 40 80 00       	push   $0x804090
  8021ed:	e8 0c e6 ff ff       	call   8007fe <cprintf>
  8021f2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021fc:	83 ec 0c             	sub    $0xc,%esp
  8021ff:	68 b4 40 80 00       	push   $0x8040b4
  802204:	e8 f5 e5 ff ff       	call   8007fe <cprintf>
  802209:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80220c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802210:	a1 40 50 80 00       	mov    0x805040,%eax
  802215:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802218:	eb 56                	jmp    802270 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80221a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80221e:	74 1c                	je     80223c <print_mem_block_lists+0x114>
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	8b 50 08             	mov    0x8(%eax),%edx
  802226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802229:	8b 48 08             	mov    0x8(%eax),%ecx
  80222c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222f:	8b 40 0c             	mov    0xc(%eax),%eax
  802232:	01 c8                	add    %ecx,%eax
  802234:	39 c2                	cmp    %eax,%edx
  802236:	73 04                	jae    80223c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802238:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 50 08             	mov    0x8(%eax),%edx
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 40 0c             	mov    0xc(%eax),%eax
  802248:	01 c2                	add    %eax,%edx
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 40 08             	mov    0x8(%eax),%eax
  802250:	83 ec 04             	sub    $0x4,%esp
  802253:	52                   	push   %edx
  802254:	50                   	push   %eax
  802255:	68 81 40 80 00       	push   $0x804081
  80225a:	e8 9f e5 ff ff       	call   8007fe <cprintf>
  80225f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802268:	a1 48 50 80 00       	mov    0x805048,%eax
  80226d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802274:	74 07                	je     80227d <print_mem_block_lists+0x155>
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	eb 05                	jmp    802282 <print_mem_block_lists+0x15a>
  80227d:	b8 00 00 00 00       	mov    $0x0,%eax
  802282:	a3 48 50 80 00       	mov    %eax,0x805048
  802287:	a1 48 50 80 00       	mov    0x805048,%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	75 8a                	jne    80221a <print_mem_block_lists+0xf2>
  802290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802294:	75 84                	jne    80221a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802296:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80229a:	75 10                	jne    8022ac <print_mem_block_lists+0x184>
  80229c:	83 ec 0c             	sub    $0xc,%esp
  80229f:	68 cc 40 80 00       	push   $0x8040cc
  8022a4:	e8 55 e5 ff ff       	call   8007fe <cprintf>
  8022a9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022ac:	83 ec 0c             	sub    $0xc,%esp
  8022af:	68 40 40 80 00       	push   $0x804040
  8022b4:	e8 45 e5 ff ff       	call   8007fe <cprintf>
  8022b9:	83 c4 10             	add    $0x10,%esp

}
  8022bc:	90                   	nop
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  8022c5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8022cc:	00 00 00 
  8022cf:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8022d6:	00 00 00 
  8022d9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8022e0:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8022e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022ea:	e9 9e 00 00 00       	jmp    80238d <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8022ef:	a1 50 50 80 00       	mov    0x805050,%eax
  8022f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f7:	c1 e2 04             	shl    $0x4,%edx
  8022fa:	01 d0                	add    %edx,%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	75 14                	jne    802314 <initialize_MemBlocksList+0x55>
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	68 f4 40 80 00       	push   $0x8040f4
  802308:	6a 47                	push   $0x47
  80230a:	68 17 41 80 00       	push   $0x804117
  80230f:	e8 36 e2 ff ff       	call   80054a <_panic>
  802314:	a1 50 50 80 00       	mov    0x805050,%eax
  802319:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231c:	c1 e2 04             	shl    $0x4,%edx
  80231f:	01 d0                	add    %edx,%eax
  802321:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802327:	89 10                	mov    %edx,(%eax)
  802329:	8b 00                	mov    (%eax),%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	74 18                	je     802347 <initialize_MemBlocksList+0x88>
  80232f:	a1 48 51 80 00       	mov    0x805148,%eax
  802334:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80233a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80233d:	c1 e1 04             	shl    $0x4,%ecx
  802340:	01 ca                	add    %ecx,%edx
  802342:	89 50 04             	mov    %edx,0x4(%eax)
  802345:	eb 12                	jmp    802359 <initialize_MemBlocksList+0x9a>
  802347:	a1 50 50 80 00       	mov    0x805050,%eax
  80234c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234f:	c1 e2 04             	shl    $0x4,%edx
  802352:	01 d0                	add    %edx,%eax
  802354:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802359:	a1 50 50 80 00       	mov    0x805050,%eax
  80235e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802361:	c1 e2 04             	shl    $0x4,%edx
  802364:	01 d0                	add    %edx,%eax
  802366:	a3 48 51 80 00       	mov    %eax,0x805148
  80236b:	a1 50 50 80 00       	mov    0x805050,%eax
  802370:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802373:	c1 e2 04             	shl    $0x4,%edx
  802376:	01 d0                	add    %edx,%eax
  802378:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80237f:	a1 54 51 80 00       	mov    0x805154,%eax
  802384:	40                   	inc    %eax
  802385:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80238a:	ff 45 f4             	incl   -0xc(%ebp)
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	3b 45 08             	cmp    0x8(%ebp),%eax
  802393:	0f 82 56 ff ff ff    	jb     8022ef <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  802399:	90                   	nop
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023aa:	eb 19                	jmp    8023c5 <find_block+0x29>
	{
		if(element->sva == va){
  8023ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023af:	8b 40 08             	mov    0x8(%eax),%eax
  8023b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023b5:	75 05                	jne    8023bc <find_block+0x20>
			 		return element;
  8023b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023ba:	eb 36                	jmp    8023f2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	8b 40 08             	mov    0x8(%eax),%eax
  8023c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8023c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023c9:	74 07                	je     8023d2 <find_block+0x36>
  8023cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	eb 05                	jmp    8023d7 <find_block+0x3b>
  8023d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023da:	89 42 08             	mov    %eax,0x8(%edx)
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	8b 40 08             	mov    0x8(%eax),%eax
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	75 c5                	jne    8023ac <find_block+0x10>
  8023e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023eb:	75 bf                	jne    8023ac <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8023ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
  8023f7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8023fa:	a1 44 50 80 00       	mov    0x805044,%eax
  8023ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802402:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802407:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80240a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80240e:	74 0a                	je     80241a <insert_sorted_allocList+0x26>
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	8b 40 08             	mov    0x8(%eax),%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	75 65                	jne    80247f <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80241a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80241e:	75 14                	jne    802434 <insert_sorted_allocList+0x40>
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	68 f4 40 80 00       	push   $0x8040f4
  802428:	6a 6e                	push   $0x6e
  80242a:	68 17 41 80 00       	push   $0x804117
  80242f:	e8 16 e1 ff ff       	call   80054a <_panic>
  802434:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	89 10                	mov    %edx,(%eax)
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 0d                	je     802455 <insert_sorted_allocList+0x61>
  802448:	a1 40 50 80 00       	mov    0x805040,%eax
  80244d:	8b 55 08             	mov    0x8(%ebp),%edx
  802450:	89 50 04             	mov    %edx,0x4(%eax)
  802453:	eb 08                	jmp    80245d <insert_sorted_allocList+0x69>
  802455:	8b 45 08             	mov    0x8(%ebp),%eax
  802458:	a3 44 50 80 00       	mov    %eax,0x805044
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	a3 40 50 80 00       	mov    %eax,0x805040
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802474:	40                   	inc    %eax
  802475:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80247a:	e9 cf 01 00 00       	jmp    80264e <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  80247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802482:	8b 50 08             	mov    0x8(%eax),%edx
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	8b 40 08             	mov    0x8(%eax),%eax
  80248b:	39 c2                	cmp    %eax,%edx
  80248d:	73 65                	jae    8024f4 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80248f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802493:	75 14                	jne    8024a9 <insert_sorted_allocList+0xb5>
  802495:	83 ec 04             	sub    $0x4,%esp
  802498:	68 30 41 80 00       	push   $0x804130
  80249d:	6a 72                	push   $0x72
  80249f:	68 17 41 80 00       	push   $0x804117
  8024a4:	e8 a1 e0 ff ff       	call   80054a <_panic>
  8024a9:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	89 50 04             	mov    %edx,0x4(%eax)
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	8b 40 04             	mov    0x4(%eax),%eax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	74 0c                	je     8024cb <insert_sorted_allocList+0xd7>
  8024bf:	a1 44 50 80 00       	mov    0x805044,%eax
  8024c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c7:	89 10                	mov    %edx,(%eax)
  8024c9:	eb 08                	jmp    8024d3 <insert_sorted_allocList+0xdf>
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	a3 40 50 80 00       	mov    %eax,0x805040
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	a3 44 50 80 00       	mov    %eax,0x805044
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024e9:	40                   	inc    %eax
  8024ea:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8024ef:	e9 5a 01 00 00       	jmp    80264e <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8024f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f7:	8b 50 08             	mov    0x8(%eax),%edx
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	8b 40 08             	mov    0x8(%eax),%eax
  802500:	39 c2                	cmp    %eax,%edx
  802502:	75 70                	jne    802574 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802504:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802508:	74 06                	je     802510 <insert_sorted_allocList+0x11c>
  80250a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250e:	75 14                	jne    802524 <insert_sorted_allocList+0x130>
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 54 41 80 00       	push   $0x804154
  802518:	6a 75                	push   $0x75
  80251a:	68 17 41 80 00       	push   $0x804117
  80251f:	e8 26 e0 ff ff       	call   80054a <_panic>
  802524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802527:	8b 10                	mov    (%eax),%edx
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	89 10                	mov    %edx,(%eax)
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	8b 00                	mov    (%eax),%eax
  802533:	85 c0                	test   %eax,%eax
  802535:	74 0b                	je     802542 <insert_sorted_allocList+0x14e>
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	8b 00                	mov    (%eax),%eax
  80253c:	8b 55 08             	mov    0x8(%ebp),%edx
  80253f:	89 50 04             	mov    %edx,0x4(%eax)
  802542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802545:	8b 55 08             	mov    0x8(%ebp),%edx
  802548:	89 10                	mov    %edx,(%eax)
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802550:	89 50 04             	mov    %edx,0x4(%eax)
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	8b 00                	mov    (%eax),%eax
  802558:	85 c0                	test   %eax,%eax
  80255a:	75 08                	jne    802564 <insert_sorted_allocList+0x170>
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	a3 44 50 80 00       	mov    %eax,0x805044
  802564:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802569:	40                   	inc    %eax
  80256a:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  80256f:	e9 da 00 00 00       	jmp    80264e <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802574:	a1 40 50 80 00       	mov    0x805040,%eax
  802579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257c:	e9 9d 00 00 00       	jmp    80261e <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  802589:	8b 45 08             	mov    0x8(%ebp),%eax
  80258c:	8b 50 08             	mov    0x8(%eax),%edx
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 08             	mov    0x8(%eax),%eax
  802595:	39 c2                	cmp    %eax,%edx
  802597:	76 7d                	jbe    802616 <insert_sorted_allocList+0x222>
  802599:	8b 45 08             	mov    0x8(%ebp),%eax
  80259c:	8b 50 08             	mov    0x8(%eax),%edx
  80259f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025a2:	8b 40 08             	mov    0x8(%eax),%eax
  8025a5:	39 c2                	cmp    %eax,%edx
  8025a7:	73 6d                	jae    802616 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8025a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ad:	74 06                	je     8025b5 <insert_sorted_allocList+0x1c1>
  8025af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025b3:	75 14                	jne    8025c9 <insert_sorted_allocList+0x1d5>
  8025b5:	83 ec 04             	sub    $0x4,%esp
  8025b8:	68 54 41 80 00       	push   $0x804154
  8025bd:	6a 7c                	push   $0x7c
  8025bf:	68 17 41 80 00       	push   $0x804117
  8025c4:	e8 81 df ff ff       	call   80054a <_panic>
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 10                	mov    (%eax),%edx
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	89 10                	mov    %edx,(%eax)
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 0b                	je     8025e7 <insert_sorted_allocList+0x1f3>
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 00                	mov    (%eax),%eax
  8025e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e4:	89 50 04             	mov    %edx,0x4(%eax)
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ed:	89 10                	mov    %edx,(%eax)
  8025ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f5:	89 50 04             	mov    %edx,0x4(%eax)
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	75 08                	jne    802609 <insert_sorted_allocList+0x215>
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	a3 44 50 80 00       	mov    %eax,0x805044
  802609:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80260e:	40                   	inc    %eax
  80260f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802614:	eb 38                	jmp    80264e <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802616:	a1 48 50 80 00       	mov    0x805048,%eax
  80261b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802622:	74 07                	je     80262b <insert_sorted_allocList+0x237>
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 00                	mov    (%eax),%eax
  802629:	eb 05                	jmp    802630 <insert_sorted_allocList+0x23c>
  80262b:	b8 00 00 00 00       	mov    $0x0,%eax
  802630:	a3 48 50 80 00       	mov    %eax,0x805048
  802635:	a1 48 50 80 00       	mov    0x805048,%eax
  80263a:	85 c0                	test   %eax,%eax
  80263c:	0f 85 3f ff ff ff    	jne    802581 <insert_sorted_allocList+0x18d>
  802642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802646:	0f 85 35 ff ff ff    	jne    802581 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  80264c:	eb 00                	jmp    80264e <insert_sorted_allocList+0x25a>
  80264e:	90                   	nop
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802657:	a1 38 51 80 00       	mov    0x805138,%eax
  80265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265f:	e9 6b 02 00 00       	jmp    8028cf <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 40 0c             	mov    0xc(%eax),%eax
  80266a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80266d:	0f 85 90 00 00 00    	jne    802703 <alloc_block_FF+0xb2>
			  temp=element;
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  802679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267d:	75 17                	jne    802696 <alloc_block_FF+0x45>
  80267f:	83 ec 04             	sub    $0x4,%esp
  802682:	68 88 41 80 00       	push   $0x804188
  802687:	68 92 00 00 00       	push   $0x92
  80268c:	68 17 41 80 00       	push   $0x804117
  802691:	e8 b4 de ff ff       	call   80054a <_panic>
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	85 c0                	test   %eax,%eax
  80269d:	74 10                	je     8026af <alloc_block_FF+0x5e>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a7:	8b 52 04             	mov    0x4(%edx),%edx
  8026aa:	89 50 04             	mov    %edx,0x4(%eax)
  8026ad:	eb 0b                	jmp    8026ba <alloc_block_FF+0x69>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	85 c0                	test   %eax,%eax
  8026c2:	74 0f                	je     8026d3 <alloc_block_FF+0x82>
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	8b 12                	mov    (%edx),%edx
  8026cf:	89 10                	mov    %edx,(%eax)
  8026d1:	eb 0a                	jmp    8026dd <alloc_block_FF+0x8c>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8026f5:	48                   	dec    %eax
  8026f6:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  8026fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026fe:	e9 ff 01 00 00       	jmp    802902 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 40 0c             	mov    0xc(%eax),%eax
  802709:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270c:	0f 86 b5 01 00 00    	jbe    8028c7 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 40 0c             	mov    0xc(%eax),%eax
  802718:	2b 45 08             	sub    0x8(%ebp),%eax
  80271b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80271e:	a1 48 51 80 00       	mov    0x805148,%eax
  802723:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802726:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80272a:	75 17                	jne    802743 <alloc_block_FF+0xf2>
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	68 88 41 80 00       	push   $0x804188
  802734:	68 99 00 00 00       	push   $0x99
  802739:	68 17 41 80 00       	push   $0x804117
  80273e:	e8 07 de ff ff       	call   80054a <_panic>
  802743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	74 10                	je     80275c <alloc_block_FF+0x10b>
  80274c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274f:	8b 00                	mov    (%eax),%eax
  802751:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802754:	8b 52 04             	mov    0x4(%edx),%edx
  802757:	89 50 04             	mov    %edx,0x4(%eax)
  80275a:	eb 0b                	jmp    802767 <alloc_block_FF+0x116>
  80275c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275f:	8b 40 04             	mov    0x4(%eax),%eax
  802762:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	85 c0                	test   %eax,%eax
  80276f:	74 0f                	je     802780 <alloc_block_FF+0x12f>
  802771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277a:	8b 12                	mov    (%edx),%edx
  80277c:	89 10                	mov    %edx,(%eax)
  80277e:	eb 0a                	jmp    80278a <alloc_block_FF+0x139>
  802780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	a3 48 51 80 00       	mov    %eax,0x805148
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802796:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279d:	a1 54 51 80 00       	mov    0x805154,%eax
  8027a2:	48                   	dec    %eax
  8027a3:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  8027a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ac:	75 17                	jne    8027c5 <alloc_block_FF+0x174>
  8027ae:	83 ec 04             	sub    $0x4,%esp
  8027b1:	68 30 41 80 00       	push   $0x804130
  8027b6:	68 9a 00 00 00       	push   $0x9a
  8027bb:	68 17 41 80 00       	push   $0x804117
  8027c0:	e8 85 dd ff ff       	call   80054a <_panic>
  8027c5:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8027cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ce:	89 50 04             	mov    %edx,0x4(%eax)
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 0c                	je     8027e7 <alloc_block_FF+0x196>
  8027db:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8027e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e3:	89 10                	mov    %edx,(%eax)
  8027e5:	eb 08                	jmp    8027ef <alloc_block_FF+0x19e>
  8027e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ea:	a3 38 51 80 00       	mov    %eax,0x805138
  8027ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802800:	a1 44 51 80 00       	mov    0x805144,%eax
  802805:	40                   	inc    %eax
  802806:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  80280b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280e:	8b 55 08             	mov    0x8(%ebp),%edx
  802811:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 50 08             	mov    0x8(%eax),%edx
  80281a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281d:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802826:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 50 08             	mov    0x8(%eax),%edx
  80282f:	8b 45 08             	mov    0x8(%ebp),%eax
  802832:	01 c2                	add    %eax,%edx
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  80283a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802840:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802844:	75 17                	jne    80285d <alloc_block_FF+0x20c>
  802846:	83 ec 04             	sub    $0x4,%esp
  802849:	68 88 41 80 00       	push   $0x804188
  80284e:	68 a2 00 00 00       	push   $0xa2
  802853:	68 17 41 80 00       	push   $0x804117
  802858:	e8 ed dc ff ff       	call   80054a <_panic>
  80285d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	74 10                	je     802876 <alloc_block_FF+0x225>
  802866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80286e:	8b 52 04             	mov    0x4(%edx),%edx
  802871:	89 50 04             	mov    %edx,0x4(%eax)
  802874:	eb 0b                	jmp    802881 <alloc_block_FF+0x230>
  802876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802879:	8b 40 04             	mov    0x4(%eax),%eax
  80287c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802881:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802884:	8b 40 04             	mov    0x4(%eax),%eax
  802887:	85 c0                	test   %eax,%eax
  802889:	74 0f                	je     80289a <alloc_block_FF+0x249>
  80288b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288e:	8b 40 04             	mov    0x4(%eax),%eax
  802891:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802894:	8b 12                	mov    (%edx),%edx
  802896:	89 10                	mov    %edx,(%eax)
  802898:	eb 0a                	jmp    8028a4 <alloc_block_FF+0x253>
  80289a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289d:	8b 00                	mov    (%eax),%eax
  80289f:	a3 38 51 80 00       	mov    %eax,0x805138
  8028a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b7:	a1 44 51 80 00       	mov    0x805144,%eax
  8028bc:	48                   	dec    %eax
  8028bd:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  8028c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c5:	eb 3b                	jmp    802902 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8028c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d3:	74 07                	je     8028dc <alloc_block_FF+0x28b>
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 00                	mov    (%eax),%eax
  8028da:	eb 05                	jmp    8028e1 <alloc_block_FF+0x290>
  8028dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e1:	a3 40 51 80 00       	mov    %eax,0x805140
  8028e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	0f 85 71 fd ff ff    	jne    802664 <alloc_block_FF+0x13>
  8028f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f7:	0f 85 67 fd ff ff    	jne    802664 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  8028fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802902:	c9                   	leave  
  802903:	c3                   	ret    

00802904 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
  802907:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80290a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802911:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802918:	a1 38 51 80 00       	mov    0x805138,%eax
  80291d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802920:	e9 d3 00 00 00       	jmp    8029f8 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802925:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802928:	8b 40 0c             	mov    0xc(%eax),%eax
  80292b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292e:	0f 85 90 00 00 00    	jne    8029c4 <alloc_block_BF+0xc0>
	   temp = element;
  802934:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802937:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80293a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80293e:	75 17                	jne    802957 <alloc_block_BF+0x53>
  802940:	83 ec 04             	sub    $0x4,%esp
  802943:	68 88 41 80 00       	push   $0x804188
  802948:	68 bd 00 00 00       	push   $0xbd
  80294d:	68 17 41 80 00       	push   $0x804117
  802952:	e8 f3 db ff ff       	call   80054a <_panic>
  802957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	74 10                	je     802970 <alloc_block_BF+0x6c>
  802960:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802968:	8b 52 04             	mov    0x4(%edx),%edx
  80296b:	89 50 04             	mov    %edx,0x4(%eax)
  80296e:	eb 0b                	jmp    80297b <alloc_block_BF+0x77>
  802970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802973:	8b 40 04             	mov    0x4(%eax),%eax
  802976:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80297b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297e:	8b 40 04             	mov    0x4(%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 0f                	je     802994 <alloc_block_BF+0x90>
  802985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802988:	8b 40 04             	mov    0x4(%eax),%eax
  80298b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298e:	8b 12                	mov    (%edx),%edx
  802990:	89 10                	mov    %edx,(%eax)
  802992:	eb 0a                	jmp    80299e <alloc_block_BF+0x9a>
  802994:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	a3 38 51 80 00       	mov    %eax,0x805138
  80299e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b6:	48                   	dec    %eax
  8029b7:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  8029bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029bf:	e9 41 01 00 00       	jmp    802b05 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  8029c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cd:	76 21                	jbe    8029f0 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  8029cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029d8:	73 16                	jae    8029f0 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  8029da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  8029e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  8029e9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  8029f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029fc:	74 07                	je     802a05 <alloc_block_BF+0x101>
  8029fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	eb 05                	jmp    802a0a <alloc_block_BF+0x106>
  802a05:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0a:	a3 40 51 80 00       	mov    %eax,0x805140
  802a0f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a14:	85 c0                	test   %eax,%eax
  802a16:	0f 85 09 ff ff ff    	jne    802925 <alloc_block_BF+0x21>
  802a1c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a20:	0f 85 ff fe ff ff    	jne    802925 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802a26:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802a2a:	0f 85 d0 00 00 00    	jne    802b00 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a33:	8b 40 0c             	mov    0xc(%eax),%eax
  802a36:	2b 45 08             	sub    0x8(%ebp),%eax
  802a39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802a3c:	a1 48 51 80 00       	mov    0x805148,%eax
  802a41:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802a44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802a48:	75 17                	jne    802a61 <alloc_block_BF+0x15d>
  802a4a:	83 ec 04             	sub    $0x4,%esp
  802a4d:	68 88 41 80 00       	push   $0x804188
  802a52:	68 d1 00 00 00       	push   $0xd1
  802a57:	68 17 41 80 00       	push   $0x804117
  802a5c:	e8 e9 da ff ff       	call   80054a <_panic>
  802a61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	85 c0                	test   %eax,%eax
  802a68:	74 10                	je     802a7a <alloc_block_BF+0x176>
  802a6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a72:	8b 52 04             	mov    0x4(%edx),%edx
  802a75:	89 50 04             	mov    %edx,0x4(%eax)
  802a78:	eb 0b                	jmp    802a85 <alloc_block_BF+0x181>
  802a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a88:	8b 40 04             	mov    0x4(%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 0f                	je     802a9e <alloc_block_BF+0x19a>
  802a8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a92:	8b 40 04             	mov    0x4(%eax),%eax
  802a95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a98:	8b 12                	mov    (%edx),%edx
  802a9a:	89 10                	mov    %edx,(%eax)
  802a9c:	eb 0a                	jmp    802aa8 <alloc_block_BF+0x1a4>
  802a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	a3 48 51 80 00       	mov    %eax,0x805148
  802aa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ab4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abb:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac0:	48                   	dec    %eax
  802ac1:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  802acc:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802acf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad2:	8b 50 08             	mov    0x8(%eax),%edx
  802ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad8:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ade:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ae1:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae7:	8b 50 08             	mov    0x8(%eax),%edx
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	01 c2                	add    %eax,%edx
  802aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af2:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802afb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802afe:	eb 05                	jmp    802b05 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802b00:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802b05:	c9                   	leave  
  802b06:	c3                   	ret    

00802b07 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b07:	55                   	push   %ebp
  802b08:	89 e5                	mov    %esp,%ebp
  802b0a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802b0d:	83 ec 04             	sub    $0x4,%esp
  802b10:	68 a8 41 80 00       	push   $0x8041a8
  802b15:	68 e8 00 00 00       	push   $0xe8
  802b1a:	68 17 41 80 00       	push   $0x804117
  802b1f:	e8 26 da ff ff       	call   80054a <_panic>

00802b24 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
  802b27:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802b2a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802b32:	a1 38 51 80 00       	mov    0x805138,%eax
  802b37:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802b3a:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802b42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b46:	75 68                	jne    802bb0 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4c:	75 17                	jne    802b65 <insert_sorted_with_merge_freeList+0x41>
  802b4e:	83 ec 04             	sub    $0x4,%esp
  802b51:	68 f4 40 80 00       	push   $0x8040f4
  802b56:	68 36 01 00 00       	push   $0x136
  802b5b:	68 17 41 80 00       	push   $0x804117
  802b60:	e8 e5 d9 ff ff       	call   80054a <_panic>
  802b65:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	89 10                	mov    %edx,(%eax)
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 0d                	je     802b86 <insert_sorted_with_merge_freeList+0x62>
  802b79:	a1 38 51 80 00       	mov    0x805138,%eax
  802b7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b81:	89 50 04             	mov    %edx,0x4(%eax)
  802b84:	eb 08                	jmp    802b8e <insert_sorted_with_merge_freeList+0x6a>
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	a3 38 51 80 00       	mov    %eax,0x805138
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba5:	40                   	inc    %eax
  802ba6:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802bab:	e9 ba 06 00 00       	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	8b 50 08             	mov    0x8(%eax),%edx
  802bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbc:	01 c2                	add    %eax,%edx
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 40 08             	mov    0x8(%eax),%eax
  802bc4:	39 c2                	cmp    %eax,%edx
  802bc6:	73 68                	jae    802c30 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802bc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcc:	75 17                	jne    802be5 <insert_sorted_with_merge_freeList+0xc1>
  802bce:	83 ec 04             	sub    $0x4,%esp
  802bd1:	68 30 41 80 00       	push   $0x804130
  802bd6:	68 3a 01 00 00       	push   $0x13a
  802bdb:	68 17 41 80 00       	push   $0x804117
  802be0:	e8 65 d9 ff ff       	call   80054a <_panic>
  802be5:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	89 50 04             	mov    %edx,0x4(%eax)
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8b 40 04             	mov    0x4(%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 0c                	je     802c07 <insert_sorted_with_merge_freeList+0xe3>
  802bfb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c00:	8b 55 08             	mov    0x8(%ebp),%edx
  802c03:	89 10                	mov    %edx,(%eax)
  802c05:	eb 08                	jmp    802c0f <insert_sorted_with_merge_freeList+0xeb>
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	a3 38 51 80 00       	mov    %eax,0x805138
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c20:	a1 44 51 80 00       	mov    0x805144,%eax
  802c25:	40                   	inc    %eax
  802c26:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802c2b:	e9 3a 06 00 00       	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c33:	8b 50 08             	mov    0x8(%eax),%edx
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3c:	01 c2                	add    %eax,%edx
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	8b 40 08             	mov    0x8(%eax),%eax
  802c44:	39 c2                	cmp    %eax,%edx
  802c46:	0f 85 90 00 00 00    	jne    802cdc <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 40 0c             	mov    0xc(%eax),%eax
  802c58:	01 c2                	add    %eax,%edx
  802c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5d:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c78:	75 17                	jne    802c91 <insert_sorted_with_merge_freeList+0x16d>
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	68 f4 40 80 00       	push   $0x8040f4
  802c82:	68 41 01 00 00       	push   $0x141
  802c87:	68 17 41 80 00       	push   $0x804117
  802c8c:	e8 b9 d8 ff ff       	call   80054a <_panic>
  802c91:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	89 10                	mov    %edx,(%eax)
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	74 0d                	je     802cb2 <insert_sorted_with_merge_freeList+0x18e>
  802ca5:	a1 48 51 80 00       	mov    0x805148,%eax
  802caa:	8b 55 08             	mov    0x8(%ebp),%edx
  802cad:	89 50 04             	mov    %edx,0x4(%eax)
  802cb0:	eb 08                	jmp    802cba <insert_sorted_with_merge_freeList+0x196>
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccc:	a1 54 51 80 00       	mov    0x805154,%eax
  802cd1:	40                   	inc    %eax
  802cd2:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802cd7:	e9 8e 05 00 00       	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	8b 50 08             	mov    0x8(%eax),%edx
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce8:	01 c2                	add    %eax,%edx
  802cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ced:	8b 40 08             	mov    0x8(%eax),%eax
  802cf0:	39 c2                	cmp    %eax,%edx
  802cf2:	73 68                	jae    802d5c <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802cf4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf8:	75 17                	jne    802d11 <insert_sorted_with_merge_freeList+0x1ed>
  802cfa:	83 ec 04             	sub    $0x4,%esp
  802cfd:	68 f4 40 80 00       	push   $0x8040f4
  802d02:	68 45 01 00 00       	push   $0x145
  802d07:	68 17 41 80 00       	push   $0x804117
  802d0c:	e8 39 d8 ff ff       	call   80054a <_panic>
  802d11:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	89 10                	mov    %edx,(%eax)
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	74 0d                	je     802d32 <insert_sorted_with_merge_freeList+0x20e>
  802d25:	a1 38 51 80 00       	mov    0x805138,%eax
  802d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2d:	89 50 04             	mov    %edx,0x4(%eax)
  802d30:	eb 08                	jmp    802d3a <insert_sorted_with_merge_freeList+0x216>
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4c:	a1 44 51 80 00       	mov    0x805144,%eax
  802d51:	40                   	inc    %eax
  802d52:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802d57:	e9 0e 05 00 00       	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	8b 50 08             	mov    0x8(%eax),%edx
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	8b 40 0c             	mov    0xc(%eax),%eax
  802d68:	01 c2                	add    %eax,%edx
  802d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6d:	8b 40 08             	mov    0x8(%eax),%eax
  802d70:	39 c2                	cmp    %eax,%edx
  802d72:	0f 85 9c 00 00 00    	jne    802e14 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	8b 40 0c             	mov    0xc(%eax),%eax
  802d84:	01 c2                	add    %eax,%edx
  802d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d89:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	8b 50 08             	mov    0x8(%eax),%edx
  802d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d95:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db0:	75 17                	jne    802dc9 <insert_sorted_with_merge_freeList+0x2a5>
  802db2:	83 ec 04             	sub    $0x4,%esp
  802db5:	68 f4 40 80 00       	push   $0x8040f4
  802dba:	68 4d 01 00 00       	push   $0x14d
  802dbf:	68 17 41 80 00       	push   $0x804117
  802dc4:	e8 81 d7 ff ff       	call   80054a <_panic>
  802dc9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	89 10                	mov    %edx,(%eax)
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 0d                	je     802dea <insert_sorted_with_merge_freeList+0x2c6>
  802ddd:	a1 48 51 80 00       	mov    0x805148,%eax
  802de2:	8b 55 08             	mov    0x8(%ebp),%edx
  802de5:	89 50 04             	mov    %edx,0x4(%eax)
  802de8:	eb 08                	jmp    802df2 <insert_sorted_with_merge_freeList+0x2ce>
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 48 51 80 00       	mov    %eax,0x805148
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e04:	a1 54 51 80 00       	mov    0x805154,%eax
  802e09:	40                   	inc    %eax
  802e0a:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802e0f:	e9 56 04 00 00       	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802e14:	a1 38 51 80 00       	mov    0x805138,%eax
  802e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e1c:	e9 19 04 00 00       	jmp    80323a <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	8b 50 08             	mov    0x8(%eax),%edx
  802e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e32:	8b 40 0c             	mov    0xc(%eax),%eax
  802e35:	01 c2                	add    %eax,%edx
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	8b 40 08             	mov    0x8(%eax),%eax
  802e3d:	39 c2                	cmp    %eax,%edx
  802e3f:	0f 85 ad 01 00 00    	jne    802ff2 <insert_sorted_with_merge_freeList+0x4ce>
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e51:	01 c2                	add    %eax,%edx
  802e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e56:	8b 40 08             	mov    0x8(%eax),%eax
  802e59:	39 c2                	cmp    %eax,%edx
  802e5b:	0f 85 91 01 00 00    	jne    802ff2 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 50 0c             	mov    0xc(%eax),%edx
  802e67:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6a:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e70:	8b 40 0c             	mov    0xc(%eax),%eax
  802e73:	01 c8                	add    %ecx,%eax
  802e75:	01 c2                	add    %eax,%edx
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802e91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e94:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802e9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802ea5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ea9:	75 17                	jne    802ec2 <insert_sorted_with_merge_freeList+0x39e>
  802eab:	83 ec 04             	sub    $0x4,%esp
  802eae:	68 88 41 80 00       	push   $0x804188
  802eb3:	68 5b 01 00 00       	push   $0x15b
  802eb8:	68 17 41 80 00       	push   $0x804117
  802ebd:	e8 88 d6 ff ff       	call   80054a <_panic>
  802ec2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 10                	je     802edb <insert_sorted_with_merge_freeList+0x3b7>
  802ecb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ed3:	8b 52 04             	mov    0x4(%edx),%edx
  802ed6:	89 50 04             	mov    %edx,0x4(%eax)
  802ed9:	eb 0b                	jmp    802ee6 <insert_sorted_with_merge_freeList+0x3c2>
  802edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ede:	8b 40 04             	mov    0x4(%eax),%eax
  802ee1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee9:	8b 40 04             	mov    0x4(%eax),%eax
  802eec:	85 c0                	test   %eax,%eax
  802eee:	74 0f                	je     802eff <insert_sorted_with_merge_freeList+0x3db>
  802ef0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef3:	8b 40 04             	mov    0x4(%eax),%eax
  802ef6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ef9:	8b 12                	mov    (%edx),%edx
  802efb:	89 10                	mov    %edx,(%eax)
  802efd:	eb 0a                	jmp    802f09 <insert_sorted_with_merge_freeList+0x3e5>
  802eff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	a3 38 51 80 00       	mov    %eax,0x805138
  802f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f21:	48                   	dec    %eax
  802f22:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2b:	75 17                	jne    802f44 <insert_sorted_with_merge_freeList+0x420>
  802f2d:	83 ec 04             	sub    $0x4,%esp
  802f30:	68 f4 40 80 00       	push   $0x8040f4
  802f35:	68 5c 01 00 00       	push   $0x15c
  802f3a:	68 17 41 80 00       	push   $0x804117
  802f3f:	e8 06 d6 ff ff       	call   80054a <_panic>
  802f44:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	89 10                	mov    %edx,(%eax)
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 00                	mov    (%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	74 0d                	je     802f65 <insert_sorted_with_merge_freeList+0x441>
  802f58:	a1 48 51 80 00       	mov    0x805148,%eax
  802f5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f60:	89 50 04             	mov    %edx,0x4(%eax)
  802f63:	eb 08                	jmp    802f6d <insert_sorted_with_merge_freeList+0x449>
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	a3 48 51 80 00       	mov    %eax,0x805148
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7f:	a1 54 51 80 00       	mov    0x805154,%eax
  802f84:	40                   	inc    %eax
  802f85:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802f8a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f8e:	75 17                	jne    802fa7 <insert_sorted_with_merge_freeList+0x483>
  802f90:	83 ec 04             	sub    $0x4,%esp
  802f93:	68 f4 40 80 00       	push   $0x8040f4
  802f98:	68 5d 01 00 00       	push   $0x15d
  802f9d:	68 17 41 80 00       	push   $0x804117
  802fa2:	e8 a3 d5 ff ff       	call   80054a <_panic>
  802fa7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb0:	89 10                	mov    %edx,(%eax)
  802fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 0d                	je     802fc8 <insert_sorted_with_merge_freeList+0x4a4>
  802fbb:	a1 48 51 80 00       	mov    0x805148,%eax
  802fc0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fc3:	89 50 04             	mov    %edx,0x4(%eax)
  802fc6:	eb 08                	jmp    802fd0 <insert_sorted_with_merge_freeList+0x4ac>
  802fc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fcb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd3:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe2:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe7:	40                   	inc    %eax
  802fe8:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  802fed:	e9 78 02 00 00       	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffe:	01 c2                	add    %eax,%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 40 08             	mov    0x8(%eax),%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	0f 83 b8 00 00 00    	jae    8030c6 <insert_sorted_with_merge_freeList+0x5a2>
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	8b 50 08             	mov    0x8(%eax),%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	8b 40 0c             	mov    0xc(%eax),%eax
  80301a:	01 c2                	add    %eax,%edx
  80301c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301f:	8b 40 08             	mov    0x8(%eax),%eax
  803022:	39 c2                	cmp    %eax,%edx
  803024:	0f 85 9c 00 00 00    	jne    8030c6 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  80302a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302d:	8b 50 0c             	mov    0xc(%eax),%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8b 40 0c             	mov    0xc(%eax),%eax
  803036:	01 c2                	add    %eax,%edx
  803038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303b:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	8b 50 08             	mov    0x8(%eax),%edx
  803044:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803047:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80305e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803062:	75 17                	jne    80307b <insert_sorted_with_merge_freeList+0x557>
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	68 f4 40 80 00       	push   $0x8040f4
  80306c:	68 67 01 00 00       	push   $0x167
  803071:	68 17 41 80 00       	push   $0x804117
  803076:	e8 cf d4 ff ff       	call   80054a <_panic>
  80307b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	89 10                	mov    %edx,(%eax)
  803086:	8b 45 08             	mov    0x8(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	85 c0                	test   %eax,%eax
  80308d:	74 0d                	je     80309c <insert_sorted_with_merge_freeList+0x578>
  80308f:	a1 48 51 80 00       	mov    0x805148,%eax
  803094:	8b 55 08             	mov    0x8(%ebp),%edx
  803097:	89 50 04             	mov    %edx,0x4(%eax)
  80309a:	eb 08                	jmp    8030a4 <insert_sorted_with_merge_freeList+0x580>
  80309c:	8b 45 08             	mov    0x8(%ebp),%eax
  80309f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b6:	a1 54 51 80 00       	mov    0x805154,%eax
  8030bb:	40                   	inc    %eax
  8030bc:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8030c1:	e9 a4 01 00 00       	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 50 08             	mov    0x8(%eax),%edx
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d2:	01 c2                	add    %eax,%edx
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	8b 40 08             	mov    0x8(%eax),%eax
  8030da:	39 c2                	cmp    %eax,%edx
  8030dc:	0f 85 ac 00 00 00    	jne    80318e <insert_sorted_with_merge_freeList+0x66a>
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	8b 50 08             	mov    0x8(%eax),%edx
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ee:	01 c2                	add    %eax,%edx
  8030f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f3:	8b 40 08             	mov    0x8(%eax),%eax
  8030f6:	39 c2                	cmp    %eax,%edx
  8030f8:	0f 83 90 00 00 00    	jae    80318e <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	8b 50 0c             	mov    0xc(%eax),%edx
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	8b 40 0c             	mov    0xc(%eax),%eax
  80310a:	01 c2                	add    %eax,%edx
  80310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310f:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803126:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312a:	75 17                	jne    803143 <insert_sorted_with_merge_freeList+0x61f>
  80312c:	83 ec 04             	sub    $0x4,%esp
  80312f:	68 f4 40 80 00       	push   $0x8040f4
  803134:	68 70 01 00 00       	push   $0x170
  803139:	68 17 41 80 00       	push   $0x804117
  80313e:	e8 07 d4 ff ff       	call   80054a <_panic>
  803143:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	89 10                	mov    %edx,(%eax)
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	8b 00                	mov    (%eax),%eax
  803153:	85 c0                	test   %eax,%eax
  803155:	74 0d                	je     803164 <insert_sorted_with_merge_freeList+0x640>
  803157:	a1 48 51 80 00       	mov    0x805148,%eax
  80315c:	8b 55 08             	mov    0x8(%ebp),%edx
  80315f:	89 50 04             	mov    %edx,0x4(%eax)
  803162:	eb 08                	jmp    80316c <insert_sorted_with_merge_freeList+0x648>
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	a3 48 51 80 00       	mov    %eax,0x805148
  803174:	8b 45 08             	mov    0x8(%ebp),%eax
  803177:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317e:	a1 54 51 80 00       	mov    0x805154,%eax
  803183:	40                   	inc    %eax
  803184:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  803189:	e9 dc 00 00 00       	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	8b 50 08             	mov    0x8(%eax),%edx
  803194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803197:	8b 40 0c             	mov    0xc(%eax),%eax
  80319a:	01 c2                	add    %eax,%edx
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	8b 40 08             	mov    0x8(%eax),%eax
  8031a2:	39 c2                	cmp    %eax,%edx
  8031a4:	0f 83 88 00 00 00    	jae    803232 <insert_sorted_with_merge_freeList+0x70e>
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	8b 50 08             	mov    0x8(%eax),%edx
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b6:	01 c2                	add    %eax,%edx
  8031b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031bb:	8b 40 08             	mov    0x8(%eax),%eax
  8031be:	39 c2                	cmp    %eax,%edx
  8031c0:	73 70                	jae    803232 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  8031c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c6:	74 06                	je     8031ce <insert_sorted_with_merge_freeList+0x6aa>
  8031c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031cc:	75 17                	jne    8031e5 <insert_sorted_with_merge_freeList+0x6c1>
  8031ce:	83 ec 04             	sub    $0x4,%esp
  8031d1:	68 54 41 80 00       	push   $0x804154
  8031d6:	68 75 01 00 00       	push   $0x175
  8031db:	68 17 41 80 00       	push   $0x804117
  8031e0:	e8 65 d3 ff ff       	call   80054a <_panic>
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	8b 10                	mov    (%eax),%edx
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	89 10                	mov    %edx,(%eax)
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	8b 00                	mov    (%eax),%eax
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	74 0b                	je     803203 <insert_sorted_with_merge_freeList+0x6df>
  8031f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fb:	8b 00                	mov    (%eax),%eax
  8031fd:	8b 55 08             	mov    0x8(%ebp),%edx
  803200:	89 50 04             	mov    %edx,0x4(%eax)
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 55 08             	mov    0x8(%ebp),%edx
  803209:	89 10                	mov    %edx,(%eax)
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803211:	89 50 04             	mov    %edx,0x4(%eax)
  803214:	8b 45 08             	mov    0x8(%ebp),%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	75 08                	jne    803225 <insert_sorted_with_merge_freeList+0x701>
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803225:	a1 44 51 80 00       	mov    0x805144,%eax
  80322a:	40                   	inc    %eax
  80322b:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803230:	eb 38                	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803232:	a1 40 51 80 00       	mov    0x805140,%eax
  803237:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80323a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323e:	74 07                	je     803247 <insert_sorted_with_merge_freeList+0x723>
  803240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803243:	8b 00                	mov    (%eax),%eax
  803245:	eb 05                	jmp    80324c <insert_sorted_with_merge_freeList+0x728>
  803247:	b8 00 00 00 00       	mov    $0x0,%eax
  80324c:	a3 40 51 80 00       	mov    %eax,0x805140
  803251:	a1 40 51 80 00       	mov    0x805140,%eax
  803256:	85 c0                	test   %eax,%eax
  803258:	0f 85 c3 fb ff ff    	jne    802e21 <insert_sorted_with_merge_freeList+0x2fd>
  80325e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803262:	0f 85 b9 fb ff ff    	jne    802e21 <insert_sorted_with_merge_freeList+0x2fd>





}
  803268:	eb 00                	jmp    80326a <insert_sorted_with_merge_freeList+0x746>
  80326a:	90                   	nop
  80326b:	c9                   	leave  
  80326c:	c3                   	ret    

0080326d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80326d:	55                   	push   %ebp
  80326e:	89 e5                	mov    %esp,%ebp
  803270:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803273:	8b 55 08             	mov    0x8(%ebp),%edx
  803276:	89 d0                	mov    %edx,%eax
  803278:	c1 e0 02             	shl    $0x2,%eax
  80327b:	01 d0                	add    %edx,%eax
  80327d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803284:	01 d0                	add    %edx,%eax
  803286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80328d:	01 d0                	add    %edx,%eax
  80328f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803296:	01 d0                	add    %edx,%eax
  803298:	c1 e0 04             	shl    $0x4,%eax
  80329b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80329e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8032a5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8032a8:	83 ec 0c             	sub    $0xc,%esp
  8032ab:	50                   	push   %eax
  8032ac:	e8 31 ec ff ff       	call   801ee2 <sys_get_virtual_time>
  8032b1:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8032b4:	eb 41                	jmp    8032f7 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8032b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8032b9:	83 ec 0c             	sub    $0xc,%esp
  8032bc:	50                   	push   %eax
  8032bd:	e8 20 ec ff ff       	call   801ee2 <sys_get_virtual_time>
  8032c2:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8032c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cb:	29 c2                	sub    %eax,%edx
  8032cd:	89 d0                	mov    %edx,%eax
  8032cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8032d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032d8:	89 d1                	mov    %edx,%ecx
  8032da:	29 c1                	sub    %eax,%ecx
  8032dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e2:	39 c2                	cmp    %eax,%edx
  8032e4:	0f 97 c0             	seta   %al
  8032e7:	0f b6 c0             	movzbl %al,%eax
  8032ea:	29 c1                	sub    %eax,%ecx
  8032ec:	89 c8                	mov    %ecx,%eax
  8032ee:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8032f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8032f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032fd:	72 b7                	jb     8032b6 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8032ff:	90                   	nop
  803300:	c9                   	leave  
  803301:	c3                   	ret    

00803302 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803302:	55                   	push   %ebp
  803303:	89 e5                	mov    %esp,%ebp
  803305:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803308:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80330f:	eb 03                	jmp    803314 <busy_wait+0x12>
  803311:	ff 45 fc             	incl   -0x4(%ebp)
  803314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803317:	3b 45 08             	cmp    0x8(%ebp),%eax
  80331a:	72 f5                	jb     803311 <busy_wait+0xf>
	return i;
  80331c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80331f:	c9                   	leave  
  803320:	c3                   	ret    
  803321:	66 90                	xchg   %ax,%ax
  803323:	90                   	nop

00803324 <__udivdi3>:
  803324:	55                   	push   %ebp
  803325:	57                   	push   %edi
  803326:	56                   	push   %esi
  803327:	53                   	push   %ebx
  803328:	83 ec 1c             	sub    $0x1c,%esp
  80332b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80332f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803333:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803337:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80333b:	89 ca                	mov    %ecx,%edx
  80333d:	89 f8                	mov    %edi,%eax
  80333f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803343:	85 f6                	test   %esi,%esi
  803345:	75 2d                	jne    803374 <__udivdi3+0x50>
  803347:	39 cf                	cmp    %ecx,%edi
  803349:	77 65                	ja     8033b0 <__udivdi3+0x8c>
  80334b:	89 fd                	mov    %edi,%ebp
  80334d:	85 ff                	test   %edi,%edi
  80334f:	75 0b                	jne    80335c <__udivdi3+0x38>
  803351:	b8 01 00 00 00       	mov    $0x1,%eax
  803356:	31 d2                	xor    %edx,%edx
  803358:	f7 f7                	div    %edi
  80335a:	89 c5                	mov    %eax,%ebp
  80335c:	31 d2                	xor    %edx,%edx
  80335e:	89 c8                	mov    %ecx,%eax
  803360:	f7 f5                	div    %ebp
  803362:	89 c1                	mov    %eax,%ecx
  803364:	89 d8                	mov    %ebx,%eax
  803366:	f7 f5                	div    %ebp
  803368:	89 cf                	mov    %ecx,%edi
  80336a:	89 fa                	mov    %edi,%edx
  80336c:	83 c4 1c             	add    $0x1c,%esp
  80336f:	5b                   	pop    %ebx
  803370:	5e                   	pop    %esi
  803371:	5f                   	pop    %edi
  803372:	5d                   	pop    %ebp
  803373:	c3                   	ret    
  803374:	39 ce                	cmp    %ecx,%esi
  803376:	77 28                	ja     8033a0 <__udivdi3+0x7c>
  803378:	0f bd fe             	bsr    %esi,%edi
  80337b:	83 f7 1f             	xor    $0x1f,%edi
  80337e:	75 40                	jne    8033c0 <__udivdi3+0x9c>
  803380:	39 ce                	cmp    %ecx,%esi
  803382:	72 0a                	jb     80338e <__udivdi3+0x6a>
  803384:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803388:	0f 87 9e 00 00 00    	ja     80342c <__udivdi3+0x108>
  80338e:	b8 01 00 00 00       	mov    $0x1,%eax
  803393:	89 fa                	mov    %edi,%edx
  803395:	83 c4 1c             	add    $0x1c,%esp
  803398:	5b                   	pop    %ebx
  803399:	5e                   	pop    %esi
  80339a:	5f                   	pop    %edi
  80339b:	5d                   	pop    %ebp
  80339c:	c3                   	ret    
  80339d:	8d 76 00             	lea    0x0(%esi),%esi
  8033a0:	31 ff                	xor    %edi,%edi
  8033a2:	31 c0                	xor    %eax,%eax
  8033a4:	89 fa                	mov    %edi,%edx
  8033a6:	83 c4 1c             	add    $0x1c,%esp
  8033a9:	5b                   	pop    %ebx
  8033aa:	5e                   	pop    %esi
  8033ab:	5f                   	pop    %edi
  8033ac:	5d                   	pop    %ebp
  8033ad:	c3                   	ret    
  8033ae:	66 90                	xchg   %ax,%ax
  8033b0:	89 d8                	mov    %ebx,%eax
  8033b2:	f7 f7                	div    %edi
  8033b4:	31 ff                	xor    %edi,%edi
  8033b6:	89 fa                	mov    %edi,%edx
  8033b8:	83 c4 1c             	add    $0x1c,%esp
  8033bb:	5b                   	pop    %ebx
  8033bc:	5e                   	pop    %esi
  8033bd:	5f                   	pop    %edi
  8033be:	5d                   	pop    %ebp
  8033bf:	c3                   	ret    
  8033c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033c5:	89 eb                	mov    %ebp,%ebx
  8033c7:	29 fb                	sub    %edi,%ebx
  8033c9:	89 f9                	mov    %edi,%ecx
  8033cb:	d3 e6                	shl    %cl,%esi
  8033cd:	89 c5                	mov    %eax,%ebp
  8033cf:	88 d9                	mov    %bl,%cl
  8033d1:	d3 ed                	shr    %cl,%ebp
  8033d3:	89 e9                	mov    %ebp,%ecx
  8033d5:	09 f1                	or     %esi,%ecx
  8033d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033db:	89 f9                	mov    %edi,%ecx
  8033dd:	d3 e0                	shl    %cl,%eax
  8033df:	89 c5                	mov    %eax,%ebp
  8033e1:	89 d6                	mov    %edx,%esi
  8033e3:	88 d9                	mov    %bl,%cl
  8033e5:	d3 ee                	shr    %cl,%esi
  8033e7:	89 f9                	mov    %edi,%ecx
  8033e9:	d3 e2                	shl    %cl,%edx
  8033eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033ef:	88 d9                	mov    %bl,%cl
  8033f1:	d3 e8                	shr    %cl,%eax
  8033f3:	09 c2                	or     %eax,%edx
  8033f5:	89 d0                	mov    %edx,%eax
  8033f7:	89 f2                	mov    %esi,%edx
  8033f9:	f7 74 24 0c          	divl   0xc(%esp)
  8033fd:	89 d6                	mov    %edx,%esi
  8033ff:	89 c3                	mov    %eax,%ebx
  803401:	f7 e5                	mul    %ebp
  803403:	39 d6                	cmp    %edx,%esi
  803405:	72 19                	jb     803420 <__udivdi3+0xfc>
  803407:	74 0b                	je     803414 <__udivdi3+0xf0>
  803409:	89 d8                	mov    %ebx,%eax
  80340b:	31 ff                	xor    %edi,%edi
  80340d:	e9 58 ff ff ff       	jmp    80336a <__udivdi3+0x46>
  803412:	66 90                	xchg   %ax,%ax
  803414:	8b 54 24 08          	mov    0x8(%esp),%edx
  803418:	89 f9                	mov    %edi,%ecx
  80341a:	d3 e2                	shl    %cl,%edx
  80341c:	39 c2                	cmp    %eax,%edx
  80341e:	73 e9                	jae    803409 <__udivdi3+0xe5>
  803420:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803423:	31 ff                	xor    %edi,%edi
  803425:	e9 40 ff ff ff       	jmp    80336a <__udivdi3+0x46>
  80342a:	66 90                	xchg   %ax,%ax
  80342c:	31 c0                	xor    %eax,%eax
  80342e:	e9 37 ff ff ff       	jmp    80336a <__udivdi3+0x46>
  803433:	90                   	nop

00803434 <__umoddi3>:
  803434:	55                   	push   %ebp
  803435:	57                   	push   %edi
  803436:	56                   	push   %esi
  803437:	53                   	push   %ebx
  803438:	83 ec 1c             	sub    $0x1c,%esp
  80343b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80343f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803443:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803447:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80344b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80344f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803453:	89 f3                	mov    %esi,%ebx
  803455:	89 fa                	mov    %edi,%edx
  803457:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80345b:	89 34 24             	mov    %esi,(%esp)
  80345e:	85 c0                	test   %eax,%eax
  803460:	75 1a                	jne    80347c <__umoddi3+0x48>
  803462:	39 f7                	cmp    %esi,%edi
  803464:	0f 86 a2 00 00 00    	jbe    80350c <__umoddi3+0xd8>
  80346a:	89 c8                	mov    %ecx,%eax
  80346c:	89 f2                	mov    %esi,%edx
  80346e:	f7 f7                	div    %edi
  803470:	89 d0                	mov    %edx,%eax
  803472:	31 d2                	xor    %edx,%edx
  803474:	83 c4 1c             	add    $0x1c,%esp
  803477:	5b                   	pop    %ebx
  803478:	5e                   	pop    %esi
  803479:	5f                   	pop    %edi
  80347a:	5d                   	pop    %ebp
  80347b:	c3                   	ret    
  80347c:	39 f0                	cmp    %esi,%eax
  80347e:	0f 87 ac 00 00 00    	ja     803530 <__umoddi3+0xfc>
  803484:	0f bd e8             	bsr    %eax,%ebp
  803487:	83 f5 1f             	xor    $0x1f,%ebp
  80348a:	0f 84 ac 00 00 00    	je     80353c <__umoddi3+0x108>
  803490:	bf 20 00 00 00       	mov    $0x20,%edi
  803495:	29 ef                	sub    %ebp,%edi
  803497:	89 fe                	mov    %edi,%esi
  803499:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80349d:	89 e9                	mov    %ebp,%ecx
  80349f:	d3 e0                	shl    %cl,%eax
  8034a1:	89 d7                	mov    %edx,%edi
  8034a3:	89 f1                	mov    %esi,%ecx
  8034a5:	d3 ef                	shr    %cl,%edi
  8034a7:	09 c7                	or     %eax,%edi
  8034a9:	89 e9                	mov    %ebp,%ecx
  8034ab:	d3 e2                	shl    %cl,%edx
  8034ad:	89 14 24             	mov    %edx,(%esp)
  8034b0:	89 d8                	mov    %ebx,%eax
  8034b2:	d3 e0                	shl    %cl,%eax
  8034b4:	89 c2                	mov    %eax,%edx
  8034b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ba:	d3 e0                	shl    %cl,%eax
  8034bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c4:	89 f1                	mov    %esi,%ecx
  8034c6:	d3 e8                	shr    %cl,%eax
  8034c8:	09 d0                	or     %edx,%eax
  8034ca:	d3 eb                	shr    %cl,%ebx
  8034cc:	89 da                	mov    %ebx,%edx
  8034ce:	f7 f7                	div    %edi
  8034d0:	89 d3                	mov    %edx,%ebx
  8034d2:	f7 24 24             	mull   (%esp)
  8034d5:	89 c6                	mov    %eax,%esi
  8034d7:	89 d1                	mov    %edx,%ecx
  8034d9:	39 d3                	cmp    %edx,%ebx
  8034db:	0f 82 87 00 00 00    	jb     803568 <__umoddi3+0x134>
  8034e1:	0f 84 91 00 00 00    	je     803578 <__umoddi3+0x144>
  8034e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034eb:	29 f2                	sub    %esi,%edx
  8034ed:	19 cb                	sbb    %ecx,%ebx
  8034ef:	89 d8                	mov    %ebx,%eax
  8034f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034f5:	d3 e0                	shl    %cl,%eax
  8034f7:	89 e9                	mov    %ebp,%ecx
  8034f9:	d3 ea                	shr    %cl,%edx
  8034fb:	09 d0                	or     %edx,%eax
  8034fd:	89 e9                	mov    %ebp,%ecx
  8034ff:	d3 eb                	shr    %cl,%ebx
  803501:	89 da                	mov    %ebx,%edx
  803503:	83 c4 1c             	add    $0x1c,%esp
  803506:	5b                   	pop    %ebx
  803507:	5e                   	pop    %esi
  803508:	5f                   	pop    %edi
  803509:	5d                   	pop    %ebp
  80350a:	c3                   	ret    
  80350b:	90                   	nop
  80350c:	89 fd                	mov    %edi,%ebp
  80350e:	85 ff                	test   %edi,%edi
  803510:	75 0b                	jne    80351d <__umoddi3+0xe9>
  803512:	b8 01 00 00 00       	mov    $0x1,%eax
  803517:	31 d2                	xor    %edx,%edx
  803519:	f7 f7                	div    %edi
  80351b:	89 c5                	mov    %eax,%ebp
  80351d:	89 f0                	mov    %esi,%eax
  80351f:	31 d2                	xor    %edx,%edx
  803521:	f7 f5                	div    %ebp
  803523:	89 c8                	mov    %ecx,%eax
  803525:	f7 f5                	div    %ebp
  803527:	89 d0                	mov    %edx,%eax
  803529:	e9 44 ff ff ff       	jmp    803472 <__umoddi3+0x3e>
  80352e:	66 90                	xchg   %ax,%ax
  803530:	89 c8                	mov    %ecx,%eax
  803532:	89 f2                	mov    %esi,%edx
  803534:	83 c4 1c             	add    $0x1c,%esp
  803537:	5b                   	pop    %ebx
  803538:	5e                   	pop    %esi
  803539:	5f                   	pop    %edi
  80353a:	5d                   	pop    %ebp
  80353b:	c3                   	ret    
  80353c:	3b 04 24             	cmp    (%esp),%eax
  80353f:	72 06                	jb     803547 <__umoddi3+0x113>
  803541:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803545:	77 0f                	ja     803556 <__umoddi3+0x122>
  803547:	89 f2                	mov    %esi,%edx
  803549:	29 f9                	sub    %edi,%ecx
  80354b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80354f:	89 14 24             	mov    %edx,(%esp)
  803552:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803556:	8b 44 24 04          	mov    0x4(%esp),%eax
  80355a:	8b 14 24             	mov    (%esp),%edx
  80355d:	83 c4 1c             	add    $0x1c,%esp
  803560:	5b                   	pop    %ebx
  803561:	5e                   	pop    %esi
  803562:	5f                   	pop    %edi
  803563:	5d                   	pop    %ebp
  803564:	c3                   	ret    
  803565:	8d 76 00             	lea    0x0(%esi),%esi
  803568:	2b 04 24             	sub    (%esp),%eax
  80356b:	19 fa                	sbb    %edi,%edx
  80356d:	89 d1                	mov    %edx,%ecx
  80356f:	89 c6                	mov    %eax,%esi
  803571:	e9 71 ff ff ff       	jmp    8034e7 <__umoddi3+0xb3>
  803576:	66 90                	xchg   %ax,%ax
  803578:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80357c:	72 ea                	jb     803568 <__umoddi3+0x134>
  80357e:	89 d9                	mov    %ebx,%ecx
  803580:	e9 62 ff ff ff       	jmp    8034e7 <__umoddi3+0xb3>
