
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
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
  80008d:	68 00 36 80 00       	push   $0x803600
  800092:	6a 12                	push   $0x12
  800094:	68 1c 36 80 00       	push   $0x80361c
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 3c 36 80 00       	push   $0x80363c
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 70 36 80 00       	push   $0x803670
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 cc 36 80 00       	push   $0x8036cc
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 0f 1e 00 00       	call   801ee2 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 00 37 80 00       	push   $0x803700
  8000de:	e8 80 07 00 00       	call   800863 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000eb:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f8:	8b 40 74             	mov    0x74(%eax),%eax
  8000fb:	6a 32                	push   $0x32
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	68 41 37 80 00       	push   $0x803741
  800104:	e8 84 1d 00 00       	call   801e8d <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010f:	a1 20 50 80 00       	mov    0x805020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	a1 20 50 80 00       	mov    0x805020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 41 37 80 00       	push   $0x803741
  80012d:	e8 5b 1d 00 00       	call   801e8d <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 de 1a 00 00       	call   801c1b <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 4f 37 80 00       	push   $0x80374f
  80014f:	e8 04 18 00 00       	call   801958 <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 54 37 80 00       	push   $0x803754
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 74 37 80 00       	push   $0x803774
  80017b:	6a 26                	push   $0x26
  80017d:	68 1c 36 80 00       	push   $0x80361c
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 8c 1a 00 00       	call   801c1b <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 e0 37 80 00       	push   $0x8037e0
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 1c 36 80 00       	push   $0x80361c
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 28 1e 00 00       	call   801fd9 <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 ef 1c 00 00       	call   801eab <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 e1 1c 00 00       	call   801eab <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 5e 38 80 00       	push   $0x80385e
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 e8 30 00 00       	call   8032d2 <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 61 1e 00 00       	call   802053 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 75 38 80 00       	push   $0x803875
  8001ff:	6a 33                	push   $0x33
  800201:	68 1c 36 80 00       	push   $0x80361c
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 a5 18 00 00       	call   801abb <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 84 38 80 00       	push   $0x803884
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 ed 19 00 00       	call   801c1b <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 a4 38 80 00       	push   $0x8038a4
  800248:	6a 38                	push   $0x38
  80024a:	68 1c 36 80 00       	push   $0x80361c
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 d4 38 80 00       	push   $0x8038d4
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 f8 38 80 00       	push   $0x8038f8
  80026c:	e8 f2 05 00 00       	call   800863 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80027f:	89 c2                	mov    %eax,%edx
  800281:	a1 20 50 80 00       	mov    0x805020,%eax
  800286:	8b 40 74             	mov    0x74(%eax),%eax
  800289:	6a 32                	push   $0x32
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 28 39 80 00       	push   $0x803928
  800292:	e8 f6 1b 00 00       	call   801e8d <sys_create_env>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  80029d:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002af:	8b 40 74             	mov    0x74(%eax),%eax
  8002b2:	6a 32                	push   $0x32
  8002b4:	52                   	push   %edx
  8002b5:	50                   	push   %eax
  8002b6:	68 38 39 80 00       	push   $0x803938
  8002bb:	e8 cd 1b 00 00       	call   801e8d <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 48 39 80 00       	push   $0x803948
  8002d5:	e8 7e 16 00 00       	call   801958 <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 4c 39 80 00       	push   $0x80394c
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 4f 37 80 00       	push   $0x80374f
  8002ff:	e8 54 16 00 00       	call   801958 <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 54 37 80 00       	push   $0x803754
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 ba 1c 00 00       	call   801fd9 <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 81 1b 00 00       	call   801eab <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 73 1b 00 00       	call   801eab <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 8a 2f 00 00       	call   8032d2 <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 cb 18 00 00       	call   801c1b <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 5d 17 00 00       	call   801abb <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 6c 39 80 00       	push   $0x80396c
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 3f 17 00 00       	call   801abb <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 82 39 80 00       	push   $0x803982
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 87 18 00 00       	call   801c1b <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 98 39 80 00       	push   $0x803998
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 1c 36 80 00       	push   $0x80361c
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 7a 1c 00 00       	call   802039 <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 3d 3a 80 00       	push   $0x803a3d
  8003cb:	e8 88 15 00 00       	call   801958 <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 30 1b 00 00       	call   801f14 <sys_getparentenvid>
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	0f 8e 81 00 00 00    	jle    80046d <_main+0x435>
			while(*finish_children != 1);
  8003ec:	90                   	nop
  8003ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 f8 01             	cmp    $0x1,%eax
  8003f5:	75 f6                	jne    8003ed <_main+0x3b5>
			cprintf("done\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 4d 3a 80 00       	push   $0x803a4d
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 b5 1a 00 00       	call   801ec7 <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 a7 1a 00 00       	call   801ec7 <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 99 1a 00 00       	call   801ec7 <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 8b 1a 00 00       	call   801ec7 <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 c9 1a 00 00       	call   801f14 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 53 3a 80 00       	push   $0x803a53
  800453:	50                   	push   %eax
  800454:	e8 9d 15 00 00       	call   8019f6 <sget>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  80045f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 01             	lea    0x1(%eax),%edx
  800467:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  80046c:	90                   	nop
  80046d:	90                   	nop
}
  80046e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 7d 1a 00 00       	call   801efb <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 1f 18 00 00       	call   801d08 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 7c 3a 80 00       	push   $0x803a7c
  8004f1:	e8 6d 03 00 00       	call   800863 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 a4 3a 80 00       	push   $0x803aa4
  800519:	e8 45 03 00 00       	call   800863 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 50 80 00       	mov    0x805020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 50 80 00       	mov    0x805020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 50 80 00       	mov    0x805020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 cc 3a 80 00       	push   $0x803acc
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 24 3b 80 00       	push   $0x803b24
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 7c 3a 80 00       	push   $0x803a7c
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 9f 17 00 00       	call   801d22 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 2c 19 00 00       	call   801ec7 <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 81 19 00 00       	call   801f2d <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005be:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	74 16                	je     8005dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005c7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	50                   	push   %eax
  8005d0:	68 38 3b 80 00       	push   $0x803b38
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 3d 3b 80 00       	push   $0x803b3d
  8005ee:	e8 70 02 00 00       	call   800863 <cprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	e8 f3 01 00 00       	call   8007f8 <vcprintf>
  800605:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	6a 00                	push   $0x0
  80060d:	68 59 3b 80 00       	push   $0x803b59
  800612:	e8 e1 01 00 00       	call   8007f8 <vcprintf>
  800617:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80061a:	e8 82 ff ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  80061f:	eb fe                	jmp    80061f <_panic+0x70>

00800621 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800627:	a1 20 50 80 00       	mov    0x805020,%eax
  80062c:	8b 50 74             	mov    0x74(%eax),%edx
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	39 c2                	cmp    %eax,%edx
  800634:	74 14                	je     80064a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800636:	83 ec 04             	sub    $0x4,%esp
  800639:	68 5c 3b 80 00       	push   $0x803b5c
  80063e:	6a 26                	push   $0x26
  800640:	68 a8 3b 80 00       	push   $0x803ba8
  800645:	e8 65 ff ff ff       	call   8005af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80064a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800658:	e9 c2 00 00 00       	jmp    80071f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	01 d0                	add    %edx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	85 c0                	test   %eax,%eax
  800670:	75 08                	jne    80067a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800672:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800675:	e9 a2 00 00 00       	jmp    80071c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80067a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800681:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800688:	eb 69                	jmp    8006f3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80068a:	a1 20 50 80 00       	mov    0x805020,%eax
  80068f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800698:	89 d0                	mov    %edx,%eax
  80069a:	01 c0                	add    %eax,%eax
  80069c:	01 d0                	add    %edx,%eax
  80069e:	c1 e0 03             	shl    $0x3,%eax
  8006a1:	01 c8                	add    %ecx,%eax
  8006a3:	8a 40 04             	mov    0x4(%eax),%al
  8006a6:	84 c0                	test   %al,%al
  8006a8:	75 46                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8006af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b8:	89 d0                	mov    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d0                	add    %edx,%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	01 c8                	add    %ecx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	75 09                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8006e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006ee:	eb 12                	jmp    800702 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f0:	ff 45 e8             	incl   -0x18(%ebp)
  8006f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f8:	8b 50 74             	mov    0x74(%eax),%edx
  8006fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006fe:	39 c2                	cmp    %eax,%edx
  800700:	77 88                	ja     80068a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800706:	75 14                	jne    80071c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	68 b4 3b 80 00       	push   $0x803bb4
  800710:	6a 3a                	push   $0x3a
  800712:	68 a8 3b 80 00       	push   $0x803ba8
  800717:	e8 93 fe ff ff       	call   8005af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80071c:	ff 45 f0             	incl   -0x10(%ebp)
  80071f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800722:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800725:	0f 8c 32 ff ff ff    	jl     80065d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80072b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800732:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800739:	eb 26                	jmp    800761 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80073b:	a1 20 50 80 00       	mov    0x805020,%eax
  800740:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800746:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800749:	89 d0                	mov    %edx,%eax
  80074b:	01 c0                	add    %eax,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	c1 e0 03             	shl    $0x3,%eax
  800752:	01 c8                	add    %ecx,%eax
  800754:	8a 40 04             	mov    0x4(%eax),%al
  800757:	3c 01                	cmp    $0x1,%al
  800759:	75 03                	jne    80075e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80075b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80075e:	ff 45 e0             	incl   -0x20(%ebp)
  800761:	a1 20 50 80 00       	mov    0x805020,%eax
  800766:	8b 50 74             	mov    0x74(%eax),%edx
  800769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076c:	39 c2                	cmp    %eax,%edx
  80076e:	77 cb                	ja     80073b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800773:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800776:	74 14                	je     80078c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	68 08 3c 80 00       	push   $0x803c08
  800780:	6a 44                	push   $0x44
  800782:	68 a8 3b 80 00       	push   $0x803ba8
  800787:	e8 23 fe ff ff       	call   8005af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80078c:	90                   	nop
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 48 01             	lea    0x1(%eax),%ecx
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a0:	89 0a                	mov    %ecx,(%edx)
  8007a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007a5:	88 d1                	mov    %dl,%cl
  8007a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007aa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007b8:	75 2c                	jne    8007e6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ba:	a0 24 50 80 00       	mov    0x805024,%al
  8007bf:	0f b6 c0             	movzbl %al,%eax
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	8b 12                	mov    (%edx),%edx
  8007c7:	89 d1                	mov    %edx,%ecx
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	83 c2 08             	add    $0x8,%edx
  8007cf:	83 ec 04             	sub    $0x4,%esp
  8007d2:	50                   	push   %eax
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	e8 80 13 00 00       	call   801b5a <sys_cputs>
  8007da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 40 04             	mov    0x4(%eax),%eax
  8007ec:	8d 50 01             	lea    0x1(%eax),%edx
  8007ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007f5:	90                   	nop
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800801:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800808:	00 00 00 
	b.cnt = 0;
  80080b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800812:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800821:	50                   	push   %eax
  800822:	68 8f 07 80 00       	push   $0x80078f
  800827:	e8 11 02 00 00       	call   800a3d <vprintfmt>
  80082c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80082f:	a0 24 50 80 00       	mov    0x805024,%al
  800834:	0f b6 c0             	movzbl %al,%eax
  800837:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80083d:	83 ec 04             	sub    $0x4,%esp
  800840:	50                   	push   %eax
  800841:	52                   	push   %edx
  800842:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800848:	83 c0 08             	add    $0x8,%eax
  80084b:	50                   	push   %eax
  80084c:	e8 09 13 00 00       	call   801b5a <sys_cputs>
  800851:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800854:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80085b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800861:	c9                   	leave  
  800862:	c3                   	ret    

00800863 <cprintf>:

int cprintf(const char *fmt, ...) {
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800869:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800870:	8d 45 0c             	lea    0xc(%ebp),%eax
  800873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 f4             	pushl  -0xc(%ebp)
  80087f:	50                   	push   %eax
  800880:	e8 73 ff ff ff       	call   8007f8 <vcprintf>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800896:	e8 6d 14 00 00       	call   801d08 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80089b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	e8 48 ff ff ff       	call   8007f8 <vcprintf>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008b6:	e8 67 14 00 00       	call   801d22 <sys_enable_interrupt>
	return cnt;
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 14             	sub    $0x14,%esp
  8008c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008de:	77 55                	ja     800935 <printnum+0x75>
  8008e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008e3:	72 05                	jb     8008ea <printnum+0x2a>
  8008e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008e8:	77 4b                	ja     800935 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	52                   	push   %edx
  8008f9:	50                   	push   %eax
  8008fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800900:	e8 83 2a 00 00       	call   803388 <__udivdi3>
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	83 ec 04             	sub    $0x4,%esp
  80090b:	ff 75 20             	pushl  0x20(%ebp)
  80090e:	53                   	push   %ebx
  80090f:	ff 75 18             	pushl  0x18(%ebp)
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 a1 ff ff ff       	call   8008c0 <printnum>
  80091f:	83 c4 20             	add    $0x20,%esp
  800922:	eb 1a                	jmp    80093e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	ff 75 20             	pushl  0x20(%ebp)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800935:	ff 4d 1c             	decl   0x1c(%ebp)
  800938:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80093c:	7f e6                	jg     800924 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80093e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800941:	bb 00 00 00 00       	mov    $0x0,%ebx
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094c:	53                   	push   %ebx
  80094d:	51                   	push   %ecx
  80094e:	52                   	push   %edx
  80094f:	50                   	push   %eax
  800950:	e8 43 2b 00 00       	call   803498 <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 74 3e 80 00       	add    $0x803e74,%eax
  80095d:	8a 00                	mov    (%eax),%al
  80095f:	0f be c0             	movsbl %al,%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	50                   	push   %eax
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
}
  800971:	90                   	nop
  800972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097e:	7e 1c                	jle    80099c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	8d 50 08             	lea    0x8(%eax),%edx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 10                	mov    %edx,(%eax)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	83 e8 08             	sub    $0x8,%eax
  800995:	8b 50 04             	mov    0x4(%eax),%edx
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	eb 40                	jmp    8009dc <getuint+0x65>
	else if (lflag)
  80099c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a0:	74 1e                	je     8009c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 10                	mov    %edx,(%eax)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 e8 04             	sub    $0x4,%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	eb 1c                	jmp    8009dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e5:	7e 1c                	jle    800a03 <getint+0x25>
		return va_arg(*ap, long long);
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	8d 50 08             	lea    0x8(%eax),%edx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 10                	mov    %edx,(%eax)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	83 e8 08             	sub    $0x8,%eax
  8009fc:	8b 50 04             	mov    0x4(%eax),%edx
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	eb 38                	jmp    800a3b <getint+0x5d>
	else if (lflag)
  800a03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a07:	74 1a                	je     800a23 <getint+0x45>
		return va_arg(*ap, long);
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	8d 50 04             	lea    0x4(%eax),%edx
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 10                	mov    %edx,(%eax)
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	99                   	cltd   
  800a21:	eb 18                	jmp    800a3b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	8d 50 04             	lea    0x4(%eax),%edx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	89 10                	mov    %edx,(%eax)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	99                   	cltd   
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a45:	eb 17                	jmp    800a5e <vprintfmt+0x21>
			if (ch == '\0')
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	0f 84 af 03 00 00    	je     800dfe <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	8d 50 01             	lea    0x1(%eax),%edx
  800a64:	89 55 10             	mov    %edx,0x10(%ebp)
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f b6 d8             	movzbl %al,%ebx
  800a6c:	83 fb 25             	cmp    $0x25,%ebx
  800a6f:	75 d6                	jne    800a47 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a71:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a75:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	8d 50 01             	lea    0x1(%eax),%edx
  800a97:	89 55 10             	mov    %edx,0x10(%ebp)
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	0f b6 d8             	movzbl %al,%ebx
  800a9f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aa2:	83 f8 55             	cmp    $0x55,%eax
  800aa5:	0f 87 2b 03 00 00    	ja     800dd6 <vprintfmt+0x399>
  800aab:	8b 04 85 98 3e 80 00 	mov    0x803e98(,%eax,4),%eax
  800ab2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ab8:	eb d7                	jmp    800a91 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800abe:	eb d1                	jmp    800a91 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ac7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 02             	shl    $0x2,%eax
  800acf:	01 d0                	add    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d8                	add    %ebx,%eax
  800ad5:	83 e8 30             	sub    $0x30,%eax
  800ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	8a 00                	mov    (%eax),%al
  800ae0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae3:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae6:	7e 3e                	jle    800b26 <vprintfmt+0xe9>
  800ae8:	83 fb 39             	cmp    $0x39,%ebx
  800aeb:	7f 39                	jg     800b26 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af0:	eb d5                	jmp    800ac7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b06:	eb 1f                	jmp    800b27 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	79 83                	jns    800a91 <vprintfmt+0x54>
				width = 0;
  800b0e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b15:	e9 77 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b21:	e9 6b ff ff ff       	jmp    800a91 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b26:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2b:	0f 89 60 ff ff ff    	jns    800a91 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b37:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b3e:	e9 4e ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b43:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b46:	e9 46 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	50                   	push   %eax
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			break;
  800b6b:	e9 89 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	83 c0 04             	add    $0x4,%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	79 02                	jns    800b87 <vprintfmt+0x14a>
				err = -err;
  800b85:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b87:	83 fb 64             	cmp    $0x64,%ebx
  800b8a:	7f 0b                	jg     800b97 <vprintfmt+0x15a>
  800b8c:	8b 34 9d e0 3c 80 00 	mov    0x803ce0(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 85 3e 80 00       	push   $0x803e85
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 5e 02 00 00       	call   800e06 <printfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bab:	e9 49 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb0:	56                   	push   %esi
  800bb1:	68 8e 3e 80 00       	push   $0x803e8e
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	e8 45 02 00 00       	call   800e06 <printfmt>
  800bc1:	83 c4 10             	add    $0x10,%esp
			break;
  800bc4:	e9 30 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	83 c0 04             	add    $0x4,%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 e8 04             	sub    $0x4,%eax
  800bd8:	8b 30                	mov    (%eax),%esi
  800bda:	85 f6                	test   %esi,%esi
  800bdc:	75 05                	jne    800be3 <vprintfmt+0x1a6>
				p = "(null)";
  800bde:	be 91 3e 80 00       	mov    $0x803e91,%esi
			if (width > 0 && padc != '-')
  800be3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be7:	7e 6d                	jle    800c56 <vprintfmt+0x219>
  800be9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bed:	74 67                	je     800c56 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	56                   	push   %esi
  800bf7:	e8 0c 03 00 00       	call   800f08 <strnlen>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c02:	eb 16                	jmp    800c1a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c04:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	50                   	push   %eax
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c17:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1e:	7f e4                	jg     800c04 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c20:	eb 34                	jmp    800c56 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c26:	74 1c                	je     800c44 <vprintfmt+0x207>
  800c28:	83 fb 1f             	cmp    $0x1f,%ebx
  800c2b:	7e 05                	jle    800c32 <vprintfmt+0x1f5>
  800c2d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c30:	7e 12                	jle    800c44 <vprintfmt+0x207>
					putch('?', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 3f                	push   $0x3f
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	eb 0f                	jmp    800c53 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c53:	ff 4d e4             	decl   -0x1c(%ebp)
  800c56:	89 f0                	mov    %esi,%eax
  800c58:	8d 70 01             	lea    0x1(%eax),%esi
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f be d8             	movsbl %al,%ebx
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	74 24                	je     800c88 <vprintfmt+0x24b>
  800c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c68:	78 b8                	js     800c22 <vprintfmt+0x1e5>
  800c6a:	ff 4d e0             	decl   -0x20(%ebp)
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	79 af                	jns    800c22 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c73:	eb 13                	jmp    800c88 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 20                	push   $0x20
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c85:	ff 4d e4             	decl   -0x1c(%ebp)
  800c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8c:	7f e7                	jg     800c75 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c8e:	e9 66 01 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 3c fd ff ff       	call   8009de <getint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	85 d2                	test   %edx,%edx
  800cb3:	79 23                	jns    800cd8 <vprintfmt+0x29b>
				putch('-', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 2d                	push   $0x2d
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccb:	f7 d8                	neg    %eax
  800ccd:	83 d2 00             	adc    $0x0,%edx
  800cd0:	f7 da                	neg    %edx
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cdf:	e9 bc 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cea:	8d 45 14             	lea    0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	e8 84 fc ff ff       	call   800977 <getuint>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cfc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d03:	e9 98 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	6a 58                	push   $0x58
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff d0                	call   *%eax
  800d15:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	6a 58                	push   $0x58
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 58                	push   $0x58
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			break;
  800d38:	e9 bc 00 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	6a 30                	push   $0x30
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d4d:	83 ec 08             	sub    $0x8,%esp
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	6a 78                	push   $0x78
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	83 c0 04             	add    $0x4,%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d78:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d7f:	eb 1f                	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 e8             	pushl  -0x18(%ebp)
  800d87:	8d 45 14             	lea    0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	e8 e7 fb ff ff       	call   800977 <getuint>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da7:	83 ec 04             	sub    $0x4,%esp
  800daa:	52                   	push   %edx
  800dab:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dae:	50                   	push   %eax
  800daf:	ff 75 f4             	pushl  -0xc(%ebp)
  800db2:	ff 75 f0             	pushl  -0x10(%ebp)
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 00 fb ff ff       	call   8008c0 <printnum>
  800dc0:	83 c4 20             	add    $0x20,%esp
			break;
  800dc3:	eb 34                	jmp    800df9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 0c             	pushl  0xc(%ebp)
  800dcb:	53                   	push   %ebx
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	ff d0                	call   *%eax
  800dd1:	83 c4 10             	add    $0x10,%esp
			break;
  800dd4:	eb 23                	jmp    800df9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	6a 25                	push   $0x25
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de6:	ff 4d 10             	decl   0x10(%ebp)
  800de9:	eb 03                	jmp    800dee <vprintfmt+0x3b1>
  800deb:	ff 4d 10             	decl   0x10(%ebp)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	48                   	dec    %eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3c 25                	cmp    $0x25,%al
  800df6:	75 f3                	jne    800deb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800df8:	90                   	nop
		}
	}
  800df9:	e9 47 fc ff ff       	jmp    800a45 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 16 fc ff ff       	call   800a3d <vprintfmt>
  800e27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e2a:	90                   	nop
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 40 08             	mov    0x8(%eax),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 10                	mov    (%eax),%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 40 04             	mov    0x4(%eax),%eax
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	73 12                	jae    800e60 <sprintputch+0x33>
		*b->buf++ = ch;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8b 00                	mov    (%eax),%eax
  800e53:	8d 48 01             	lea    0x1(%eax),%ecx
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	89 0a                	mov    %ecx,(%edx)
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	88 10                	mov    %dl,(%eax)
}
  800e60:	90                   	nop
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	74 06                	je     800e90 <vsnprintf+0x2d>
  800e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8e:	7f 07                	jg     800e97 <vsnprintf+0x34>
		return -E_INVAL;
  800e90:	b8 03 00 00 00       	mov    $0x3,%eax
  800e95:	eb 20                	jmp    800eb7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e97:	ff 75 14             	pushl  0x14(%ebp)
  800e9a:	ff 75 10             	pushl  0x10(%ebp)
  800e9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	68 2d 0e 80 00       	push   $0x800e2d
  800ea6:	e8 92 fb ff ff       	call   800a3d <vprintfmt>
  800eab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	ff 75 08             	pushl  0x8(%ebp)
  800ed5:	e8 89 ff ff ff       	call   800e63 <vsnprintf>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef2:	eb 06                	jmp    800efa <strlen+0x15>
		n++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 f1                	jne    800ef4 <strlen+0xf>
		n++;
	return n;
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 09                	jmp    800f20 <strnlen+0x18>
		n++;
  800f17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 4d 0c             	decl   0xc(%ebp)
  800f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f24:	74 09                	je     800f2f <strnlen+0x27>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 e8                	jne    800f17 <strnlen+0xf>
		n++;
	return n;
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f40:	90                   	nop
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f53:	8a 12                	mov    (%edx),%dl
  800f55:	88 10                	mov    %dl,(%eax)
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 e4                	jne    800f41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f75:	eb 1f                	jmp    800f96 <strncpy+0x34>
		*dst++ = *src;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	84 c0                	test   %al,%al
  800f8e:	74 03                	je     800f93 <strncpy+0x31>
			src++;
  800f90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f93:	ff 45 fc             	incl   -0x4(%ebp)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9c:	72 d9                	jb     800f77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	74 30                	je     800fe5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb5:	eb 16                	jmp    800fcd <strlcpy+0x2a>
			*dst++ = *src++;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc9:	8a 12                	mov    (%edx),%dl
  800fcb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd4:	74 09                	je     800fdf <strlcpy+0x3c>
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 d8                	jne    800fb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff4:	eb 06                	jmp    800ffc <strcmp+0xb>
		p++, q++;
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	74 0e                	je     801013 <strcmp+0x22>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 10                	mov    (%eax),%dl
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 e3                	je     800ff6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	0f b6 d0             	movzbl %al,%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 c0             	movzbl %al,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80102c:	eb 09                	jmp    801037 <strncmp+0xe>
		n--, p++, q++;
  80102e:	ff 4d 10             	decl   0x10(%ebp)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103b:	74 17                	je     801054 <strncmp+0x2b>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	74 0e                	je     801054 <strncmp+0x2b>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	38 c2                	cmp    %al,%dl
  801052:	74 da                	je     80102e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strncmp+0x38>
		return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	eb 14                	jmp    801075 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f b6 d0             	movzbl %al,%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f b6 c0             	movzbl %al,%eax
  801071:	29 c2                	sub    %eax,%edx
  801073:	89 d0                	mov    %edx,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801083:	eb 12                	jmp    801097 <strchr+0x20>
		if (*s == c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108d:	75 05                	jne    801094 <strchr+0x1d>
			return (char *) s;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	eb 11                	jmp    8010a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e5                	jne    801085 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 0d                	jmp    8010c2 <strfind+0x1b>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	74 0e                	je     8010cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	84 c0                	test   %al,%al
  8010c9:	75 ea                	jne    8010b5 <strfind+0xe>
  8010cb:	eb 01                	jmp    8010ce <strfind+0x27>
		if (*s == c)
			break;
  8010cd:	90                   	nop
	return (char *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010e5:	eb 0e                	jmp    8010f5 <memset+0x22>
		*p++ = c;
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010f5:	ff 4d f8             	decl   -0x8(%ebp)
  8010f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010fc:	79 e9                	jns    8010e7 <memset+0x14>
		*p++ = c;

	return v;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801115:	eb 16                	jmp    80112d <memcpy+0x2a>
		*d++ = *s++;
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8d 50 01             	lea    0x1(%eax),%edx
  80111d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801120:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801123:	8d 4a 01             	lea    0x1(%edx),%ecx
  801126:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801129:	8a 12                	mov    (%edx),%dl
  80112b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	8d 50 ff             	lea    -0x1(%eax),%edx
  801133:	89 55 10             	mov    %edx,0x10(%ebp)
  801136:	85 c0                	test   %eax,%eax
  801138:	75 dd                	jne    801117 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801157:	73 50                	jae    8011a9 <memmove+0x6a>
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 d0                	add    %edx,%eax
  801161:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801164:	76 43                	jbe    8011a9 <memmove+0x6a>
		s += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801172:	eb 10                	jmp    801184 <memmove+0x45>
			*--d = *--s;
  801174:	ff 4d f8             	decl   -0x8(%ebp)
  801177:	ff 4d fc             	decl   -0x4(%ebp)
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	8a 10                	mov    (%eax),%dl
  80117f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801182:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118a:	89 55 10             	mov    %edx,0x10(%ebp)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 e3                	jne    801174 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801191:	eb 23                	jmp    8011b6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801193:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801196:	8d 50 01             	lea    0x1(%eax),%edx
  801199:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a5:	8a 12                	mov    (%edx),%dl
  8011a7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011af:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	75 dd                	jne    801193 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011cd:	eb 2a                	jmp    8011f9 <memcmp+0x3e>
		if (*s1 != *s2)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	8a 10                	mov    (%eax),%dl
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	38 c2                	cmp    %al,%dl
  8011db:	74 16                	je     8011f3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d0             	movzbl %al,%edx
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 c0             	movzbl %al,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
  8011f1:	eb 18                	jmp    80120b <memcmp+0x50>
		s1++, s2++;
  8011f3:	ff 45 fc             	incl   -0x4(%ebp)
  8011f6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801202:	85 c0                	test   %eax,%eax
  801204:	75 c9                	jne    8011cf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	8b 45 10             	mov    0x10(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121e:	eb 15                	jmp    801235 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	39 c2                	cmp    %eax,%edx
  801230:	74 0d                	je     80123f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123b:	72 e3                	jb     801220 <memfind+0x13>
  80123d:	eb 01                	jmp    801240 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80123f:	90                   	nop
	return (void *) s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801259:	eb 03                	jmp    80125e <strtol+0x19>
		s++;
  80125b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 20                	cmp    $0x20,%al
  801265:	74 f4                	je     80125b <strtol+0x16>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 09                	cmp    $0x9,%al
  80126e:	74 eb                	je     80125b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 2b                	cmp    $0x2b,%al
  801277:	75 05                	jne    80127e <strtol+0x39>
		s++;
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	eb 13                	jmp    801291 <strtol+0x4c>
	else if (*s == '-')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2d                	cmp    $0x2d,%al
  801285:	75 0a                	jne    801291 <strtol+0x4c>
		s++, neg = 1;
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801291:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801295:	74 06                	je     80129d <strtol+0x58>
  801297:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129b:	75 20                	jne    8012bd <strtol+0x78>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 30                	cmp    $0x30,%al
  8012a4:	75 17                	jne    8012bd <strtol+0x78>
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	40                   	inc    %eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 78                	cmp    $0x78,%al
  8012ae:	75 0d                	jne    8012bd <strtol+0x78>
		s += 2, base = 16;
  8012b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bb:	eb 28                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	75 15                	jne    8012d8 <strtol+0x93>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 30                	cmp    $0x30,%al
  8012ca:	75 0c                	jne    8012d8 <strtol+0x93>
		s++, base = 8;
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d6:	eb 0d                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0)
  8012d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dc:	75 07                	jne    8012e5 <strtol+0xa0>
		base = 10;
  8012de:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 2f                	cmp    $0x2f,%al
  8012ec:	7e 19                	jle    801307 <strtol+0xc2>
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 39                	cmp    $0x39,%al
  8012f5:	7f 10                	jg     801307 <strtol+0xc2>
			dig = *s - '0';
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	0f be c0             	movsbl %al,%eax
  8012ff:	83 e8 30             	sub    $0x30,%eax
  801302:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801305:	eb 42                	jmp    801349 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	3c 60                	cmp    $0x60,%al
  80130e:	7e 19                	jle    801329 <strtol+0xe4>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	3c 7a                	cmp    $0x7a,%al
  801317:	7f 10                	jg     801329 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	0f be c0             	movsbl %al,%eax
  801321:	83 e8 57             	sub    $0x57,%eax
  801324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801327:	eb 20                	jmp    801349 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	3c 40                	cmp    $0x40,%al
  801330:	7e 39                	jle    80136b <strtol+0x126>
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	3c 5a                	cmp    $0x5a,%al
  801339:	7f 30                	jg     80136b <strtol+0x126>
			dig = *s - 'A' + 10;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f be c0             	movsbl %al,%eax
  801343:	83 e8 37             	sub    $0x37,%eax
  801346:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134f:	7d 19                	jge    80136a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801365:	e9 7b ff ff ff       	jmp    8012e5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80136f:	74 08                	je     801379 <strtol+0x134>
		*endptr = (char *) s;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	8b 55 08             	mov    0x8(%ebp),%edx
  801377:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801379:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137d:	74 07                	je     801386 <strtol+0x141>
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	f7 d8                	neg    %eax
  801384:	eb 03                	jmp    801389 <strtol+0x144>
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <ltostr>:

void
ltostr(long value, char *str)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801398:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80139f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a3:	79 13                	jns    8013b8 <ltostr+0x2d>
	{
		neg = 1;
  8013a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c0:	99                   	cltd   
  8013c1:	f7 f9                	idiv   %ecx
  8013c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c9:	8d 50 01             	lea    0x1(%eax),%edx
  8013cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d9:	83 c2 30             	add    $0x30,%edx
  8013dc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e6:	f7 e9                	imul   %ecx
  8013e8:	c1 fa 02             	sar    $0x2,%edx
  8013eb:	89 c8                	mov    %ecx,%eax
  8013ed:	c1 f8 1f             	sar    $0x1f,%eax
  8013f0:	29 c2                	sub    %eax,%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ff:	f7 e9                	imul   %ecx
  801401:	c1 fa 02             	sar    $0x2,%edx
  801404:	89 c8                	mov    %ecx,%eax
  801406:	c1 f8 1f             	sar    $0x1f,%eax
  801409:	29 c2                	sub    %eax,%edx
  80140b:	89 d0                	mov    %edx,%eax
  80140d:	c1 e0 02             	shl    $0x2,%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	01 c0                	add    %eax,%eax
  801414:	29 c1                	sub    %eax,%ecx
  801416:	89 ca                	mov    %ecx,%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	75 9c                	jne    8013b8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80141c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801423:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801426:	48                   	dec    %eax
  801427:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80142a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80142e:	74 3d                	je     80146d <ltostr+0xe2>
		start = 1 ;
  801430:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801437:	eb 34                	jmp    80146d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80145a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 c2                	add    %eax,%edx
  801462:	8a 45 eb             	mov    -0x15(%ebp),%al
  801465:	88 02                	mov    %al,(%edx)
		start++ ;
  801467:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80146a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801473:	7c c4                	jl     801439 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801475:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 54 fa ff ff       	call   800ee5 <strlen>
  801491:	83 c4 04             	add    $0x4,%esp
  801494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	e8 46 fa ff ff       	call   800ee5 <strlen>
  80149f:	83 c4 04             	add    $0x4,%esp
  8014a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b3:	eb 17                	jmp    8014cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8014b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 c2                	add    %eax,%edx
  8014bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	01 c8                	add    %ecx,%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c9:	ff 45 fc             	incl   -0x4(%ebp)
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014d2:	7c e1                	jl     8014b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014e2:	eb 1f                	jmp    801503 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ed:	89 c2                	mov    %eax,%edx
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 c2                	add    %eax,%edx
  8014f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fa:	01 c8                	add    %ecx,%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801500:	ff 45 f8             	incl   -0x8(%ebp)
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801509:	7c d9                	jl     8014e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80150b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	c6 00 00             	movb   $0x0,(%eax)
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80151c:	8b 45 14             	mov    0x14(%ebp),%eax
  80151f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801525:	8b 45 14             	mov    0x14(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	01 d0                	add    %edx,%eax
  801536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153c:	eb 0c                	jmp    80154a <strsplit+0x31>
			*string++ = 0;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8d 50 01             	lea    0x1(%eax),%edx
  801544:	89 55 08             	mov    %edx,0x8(%ebp)
  801547:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	84 c0                	test   %al,%al
  801551:	74 18                	je     80156b <strsplit+0x52>
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	0f be c0             	movsbl %al,%eax
  80155b:	50                   	push   %eax
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	e8 13 fb ff ff       	call   801077 <strchr>
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	75 d3                	jne    80153e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 5a                	je     8015ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	83 f8 0f             	cmp    $0xf,%eax
  80157c:	75 07                	jne    801585 <strsplit+0x6c>
		{
			return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
  801583:	eb 66                	jmp    8015eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	8d 48 01             	lea    0x1(%eax),%ecx
  80158d:	8b 55 14             	mov    0x14(%ebp),%edx
  801590:	89 0a                	mov    %ecx,(%edx)
  801592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	01 c2                	add    %eax,%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a3:	eb 03                	jmp    8015a8 <strsplit+0x8f>
			string++;
  8015a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	84 c0                	test   %al,%al
  8015af:	74 8b                	je     80153c <strsplit+0x23>
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	0f be c0             	movsbl %al,%eax
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	e8 b5 fa ff ff       	call   801077 <strchr>
  8015c2:	83 c4 08             	add    $0x8,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 dc                	je     8015a5 <strsplit+0x8c>
			string++;
	}
  8015c9:	e9 6e ff ff ff       	jmp    80153c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8015f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 1f                	je     80161b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8015fc:	e8 1d 00 00 00       	call   80161e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	68 f0 3f 80 00       	push   $0x803ff0
  801609:	e8 55 f2 ff ff       	call   800863 <cprintf>
  80160e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801611:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801618:	00 00 00 
	}
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801624:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80162b:	00 00 00 
  80162e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801635:	00 00 00 
  801638:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80163f:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  801642:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801649:	00 00 00 
  80164c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801653:	00 00 00 
  801656:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80165d:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801660:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80166f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801674:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801679:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801680:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  801683:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80168a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168d:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801692:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801698:	ba 00 00 00 00       	mov    $0x0,%edx
  80169d:	f7 75 f0             	divl   -0x10(%ebp)
  8016a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a3:	29 d0                	sub    %edx,%eax
  8016a5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8016a8:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8016af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	6a 06                	push   $0x6
  8016c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8016c4:	50                   	push   %eax
  8016c5:	e8 d4 05 00 00       	call   801c9e <sys_allocate_chunk>
  8016ca:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016cd:	a1 20 51 80 00       	mov    0x805120,%eax
  8016d2:	83 ec 0c             	sub    $0xc,%esp
  8016d5:	50                   	push   %eax
  8016d6:	e8 49 0c 00 00       	call   802324 <initialize_MemBlocksList>
  8016db:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8016de:	a1 48 51 80 00       	mov    0x805148,%eax
  8016e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8016e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016ea:	75 14                	jne    801700 <initialize_dyn_block_system+0xe2>
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	68 15 40 80 00       	push   $0x804015
  8016f4:	6a 39                	push   $0x39
  8016f6:	68 33 40 80 00       	push   $0x804033
  8016fb:	e8 af ee ff ff       	call   8005af <_panic>
  801700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801703:	8b 00                	mov    (%eax),%eax
  801705:	85 c0                	test   %eax,%eax
  801707:	74 10                	je     801719 <initialize_dyn_block_system+0xfb>
  801709:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801711:	8b 52 04             	mov    0x4(%edx),%edx
  801714:	89 50 04             	mov    %edx,0x4(%eax)
  801717:	eb 0b                	jmp    801724 <initialize_dyn_block_system+0x106>
  801719:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80171c:	8b 40 04             	mov    0x4(%eax),%eax
  80171f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801724:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801727:	8b 40 04             	mov    0x4(%eax),%eax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 0f                	je     80173d <initialize_dyn_block_system+0x11f>
  80172e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801731:	8b 40 04             	mov    0x4(%eax),%eax
  801734:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801737:	8b 12                	mov    (%edx),%edx
  801739:	89 10                	mov    %edx,(%eax)
  80173b:	eb 0a                	jmp    801747 <initialize_dyn_block_system+0x129>
  80173d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801740:	8b 00                	mov    (%eax),%eax
  801742:	a3 48 51 80 00       	mov    %eax,0x805148
  801747:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801753:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80175a:	a1 54 51 80 00       	mov    0x805154,%eax
  80175f:	48                   	dec    %eax
  801760:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801765:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801768:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80176f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801772:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801779:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80177d:	75 14                	jne    801793 <initialize_dyn_block_system+0x175>
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	68 40 40 80 00       	push   $0x804040
  801787:	6a 3f                	push   $0x3f
  801789:	68 33 40 80 00       	push   $0x804033
  80178e:	e8 1c ee ff ff       	call   8005af <_panic>
  801793:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80179c:	89 10                	mov    %edx,(%eax)
  80179e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a1:	8b 00                	mov    (%eax),%eax
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	74 0d                	je     8017b4 <initialize_dyn_block_system+0x196>
  8017a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8017ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017af:	89 50 04             	mov    %edx,0x4(%eax)
  8017b2:	eb 08                	jmp    8017bc <initialize_dyn_block_system+0x19e>
  8017b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8017bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8017c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8017d3:	40                   	inc    %eax
  8017d4:	a3 44 51 80 00       	mov    %eax,0x805144

}
  8017d9:	90                   	nop
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017e2:	e8 06 fe ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  8017e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017eb:	75 07                	jne    8017f4 <malloc+0x18>
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f2:	eb 7d                	jmp    801871 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8017f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8017fb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801802:	8b 55 08             	mov    0x8(%ebp),%edx
  801805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	48                   	dec    %eax
  80180b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80180e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801811:	ba 00 00 00 00       	mov    $0x0,%edx
  801816:	f7 75 f0             	divl   -0x10(%ebp)
  801819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181c:	29 d0                	sub    %edx,%eax
  80181e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801821:	e8 46 08 00 00       	call   80206c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801826:	83 f8 01             	cmp    $0x1,%eax
  801829:	75 07                	jne    801832 <malloc+0x56>
  80182b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  801832:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801836:	75 34                	jne    80186c <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801838:	83 ec 0c             	sub    $0xc,%esp
  80183b:	ff 75 e8             	pushl  -0x18(%ebp)
  80183e:	e8 73 0e 00 00       	call   8026b6 <alloc_block_FF>
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801849:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80184d:	74 16                	je     801865 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80184f:	83 ec 0c             	sub    $0xc,%esp
  801852:	ff 75 e4             	pushl  -0x1c(%ebp)
  801855:	e8 ff 0b 00 00       	call   802459 <insert_sorted_allocList>
  80185a:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  80185d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801860:	8b 40 08             	mov    0x8(%eax),%eax
  801863:	eb 0c                	jmp    801871 <malloc+0x95>
	             }
	             else
	             	return NULL;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
  80186a:	eb 05                	jmp    801871 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  80186c:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801888:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80188d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	ff 75 f4             	pushl  -0xc(%ebp)
  801896:	68 40 50 80 00       	push   $0x805040
  80189b:	e8 61 0b 00 00       	call   802401 <find_block>
  8018a0:	83 c4 10             	add    $0x10,%esp
  8018a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8018a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018aa:	0f 84 a5 00 00 00    	je     801955 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8018b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b6:	83 ec 08             	sub    $0x8,%esp
  8018b9:	50                   	push   %eax
  8018ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bd:	e8 a4 03 00 00       	call   801c66 <sys_free_user_mem>
  8018c2:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8018c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018c9:	75 17                	jne    8018e2 <free+0x6f>
  8018cb:	83 ec 04             	sub    $0x4,%esp
  8018ce:	68 15 40 80 00       	push   $0x804015
  8018d3:	68 87 00 00 00       	push   $0x87
  8018d8:	68 33 40 80 00       	push   $0x804033
  8018dd:	e8 cd ec ff ff       	call   8005af <_panic>
  8018e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	74 10                	je     8018fb <free+0x88>
  8018eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ee:	8b 00                	mov    (%eax),%eax
  8018f0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018f3:	8b 52 04             	mov    0x4(%edx),%edx
  8018f6:	89 50 04             	mov    %edx,0x4(%eax)
  8018f9:	eb 0b                	jmp    801906 <free+0x93>
  8018fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018fe:	8b 40 04             	mov    0x4(%eax),%eax
  801901:	a3 44 50 80 00       	mov    %eax,0x805044
  801906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801909:	8b 40 04             	mov    0x4(%eax),%eax
  80190c:	85 c0                	test   %eax,%eax
  80190e:	74 0f                	je     80191f <free+0xac>
  801910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801913:	8b 40 04             	mov    0x4(%eax),%eax
  801916:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801919:	8b 12                	mov    (%edx),%edx
  80191b:	89 10                	mov    %edx,(%eax)
  80191d:	eb 0a                	jmp    801929 <free+0xb6>
  80191f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801922:	8b 00                	mov    (%eax),%eax
  801924:	a3 40 50 80 00       	mov    %eax,0x805040
  801929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80192c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801932:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801935:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80193c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801941:	48                   	dec    %eax
  801942:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801947:	83 ec 0c             	sub    $0xc,%esp
  80194a:	ff 75 ec             	pushl  -0x14(%ebp)
  80194d:	e8 37 12 00 00       	call   802b89 <insert_sorted_with_merge_freeList>
  801952:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801955:	90                   	nop
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	83 ec 38             	sub    $0x38,%esp
  80195e:	8b 45 10             	mov    0x10(%ebp),%eax
  801961:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801964:	e8 84 fc ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  801969:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80196d:	75 07                	jne    801976 <smalloc+0x1e>
  80196f:	b8 00 00 00 00       	mov    $0x0,%eax
  801974:	eb 7e                	jmp    8019f4 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801976:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80197d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801984:	8b 55 0c             	mov    0xc(%ebp),%edx
  801987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198a:	01 d0                	add    %edx,%eax
  80198c:	48                   	dec    %eax
  80198d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801990:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801993:	ba 00 00 00 00       	mov    $0x0,%edx
  801998:	f7 75 f0             	divl   -0x10(%ebp)
  80199b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199e:	29 d0                	sub    %edx,%eax
  8019a0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8019a3:	e8 c4 06 00 00       	call   80206c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019a8:	83 f8 01             	cmp    $0x1,%eax
  8019ab:	75 42                	jne    8019ef <smalloc+0x97>

		  va = malloc(newsize) ;
  8019ad:	83 ec 0c             	sub    $0xc,%esp
  8019b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8019b3:	e8 24 fe ff ff       	call   8017dc <malloc>
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8019be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019c2:	74 24                	je     8019e8 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8019c4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019cb:	50                   	push   %eax
  8019cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8019cf:	ff 75 08             	pushl  0x8(%ebp)
  8019d2:	e8 1a 04 00 00       	call   801df1 <sys_createSharedObject>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8019dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019e1:	78 0c                	js     8019ef <smalloc+0x97>
					  return va ;
  8019e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019e6:	eb 0c                	jmp    8019f4 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8019e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ed:	eb 05                	jmp    8019f4 <smalloc+0x9c>
	  }
		  return NULL ;
  8019ef:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019fc:	e8 ec fb ff ff       	call   8015ed <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801a01:	83 ec 08             	sub    $0x8,%esp
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	ff 75 08             	pushl  0x8(%ebp)
  801a0a:	e8 0c 04 00 00       	call   801e1b <sys_getSizeOfSharedObject>
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801a15:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801a19:	75 07                	jne    801a22 <sget+0x2c>
  801a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a20:	eb 75                	jmp    801a97 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801a22:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2f:	01 d0                	add    %edx,%eax
  801a31:	48                   	dec    %eax
  801a32:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a38:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3d:	f7 75 f0             	divl   -0x10(%ebp)
  801a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a43:	29 d0                	sub    %edx,%eax
  801a45:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801a48:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801a4f:	e8 18 06 00 00       	call   80206c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a54:	83 f8 01             	cmp    $0x1,%eax
  801a57:	75 39                	jne    801a92 <sget+0x9c>

		  va = malloc(newsize) ;
  801a59:	83 ec 0c             	sub    $0xc,%esp
  801a5c:	ff 75 e8             	pushl  -0x18(%ebp)
  801a5f:	e8 78 fd ff ff       	call   8017dc <malloc>
  801a64:	83 c4 10             	add    $0x10,%esp
  801a67:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801a6a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a6e:	74 22                	je     801a92 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	ff 75 e0             	pushl  -0x20(%ebp)
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	e8 b7 03 00 00       	call   801e38 <sys_getSharedObject>
  801a81:	83 c4 10             	add    $0x10,%esp
  801a84:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801a87:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801a8b:	78 05                	js     801a92 <sget+0x9c>
					  return va;
  801a8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a90:	eb 05                	jmp    801a97 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801a92:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a9f:	e8 49 fb ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	68 64 40 80 00       	push   $0x804064
  801aac:	68 1e 01 00 00       	push   $0x11e
  801ab1:	68 33 40 80 00       	push   $0x804033
  801ab6:	e8 f4 ea ff ff       	call   8005af <_panic>

00801abb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ac1:	83 ec 04             	sub    $0x4,%esp
  801ac4:	68 8c 40 80 00       	push   $0x80408c
  801ac9:	68 32 01 00 00       	push   $0x132
  801ace:	68 33 40 80 00       	push   $0x804033
  801ad3:	e8 d7 ea ff ff       	call   8005af <_panic>

00801ad8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ade:	83 ec 04             	sub    $0x4,%esp
  801ae1:	68 b0 40 80 00       	push   $0x8040b0
  801ae6:	68 3d 01 00 00       	push   $0x13d
  801aeb:	68 33 40 80 00       	push   $0x804033
  801af0:	e8 ba ea ff ff       	call   8005af <_panic>

00801af5 <shrink>:

}
void shrink(uint32 newSize)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801afb:	83 ec 04             	sub    $0x4,%esp
  801afe:	68 b0 40 80 00       	push   $0x8040b0
  801b03:	68 42 01 00 00       	push   $0x142
  801b08:	68 33 40 80 00       	push   $0x804033
  801b0d:	e8 9d ea ff ff       	call   8005af <_panic>

00801b12 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b18:	83 ec 04             	sub    $0x4,%esp
  801b1b:	68 b0 40 80 00       	push   $0x8040b0
  801b20:	68 47 01 00 00       	push   $0x147
  801b25:	68 33 40 80 00       	push   $0x804033
  801b2a:	e8 80 ea ff ff       	call   8005af <_panic>

00801b2f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	57                   	push   %edi
  801b33:	56                   	push   %esi
  801b34:	53                   	push   %ebx
  801b35:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b44:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b47:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b4a:	cd 30                	int    $0x30
  801b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5f                   	pop    %edi
  801b58:	5d                   	pop    %ebp
  801b59:	c3                   	ret    

00801b5a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 04             	sub    $0x4,%esp
  801b60:	8b 45 10             	mov    0x10(%ebp),%eax
  801b63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b66:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	52                   	push   %edx
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	50                   	push   %eax
  801b76:	6a 00                	push   $0x0
  801b78:	e8 b2 ff ff ff       	call   801b2f <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	90                   	nop
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_cgetc>:

int
sys_cgetc(void)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 01                	push   $0x1
  801b92:	e8 98 ff ff ff       	call   801b2f <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	6a 05                	push   $0x5
  801baf:	e8 7b ff ff ff       	call   801b2f <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	56                   	push   %esi
  801bbd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bbe:	8b 75 18             	mov    0x18(%ebp),%esi
  801bc1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	51                   	push   %ecx
  801bd0:	52                   	push   %edx
  801bd1:	50                   	push   %eax
  801bd2:	6a 06                	push   $0x6
  801bd4:	e8 56 ff ff ff       	call   801b2f <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5d                   	pop    %ebp
  801be2:	c3                   	ret    

00801be3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	52                   	push   %edx
  801bf3:	50                   	push   %eax
  801bf4:	6a 07                	push   $0x7
  801bf6:	e8 34 ff ff ff       	call   801b2f <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	ff 75 0c             	pushl  0xc(%ebp)
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 08                	push   $0x8
  801c11:	e8 19 ff ff ff       	call   801b2f <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 09                	push   $0x9
  801c2a:	e8 00 ff ff ff       	call   801b2f <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 0a                	push   $0xa
  801c43:	e8 e7 fe ff ff       	call   801b2f <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 0b                	push   $0xb
  801c5c:	e8 ce fe ff ff       	call   801b2f <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	6a 0f                	push   $0xf
  801c77:	e8 b3 fe ff ff       	call   801b2f <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return;
  801c7f:	90                   	nop
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	ff 75 08             	pushl  0x8(%ebp)
  801c91:	6a 10                	push   $0x10
  801c93:	e8 97 fe ff ff       	call   801b2f <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9b:	90                   	nop
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	ff 75 10             	pushl  0x10(%ebp)
  801ca8:	ff 75 0c             	pushl  0xc(%ebp)
  801cab:	ff 75 08             	pushl  0x8(%ebp)
  801cae:	6a 11                	push   $0x11
  801cb0:	e8 7a fe ff ff       	call   801b2f <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb8:	90                   	nop
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 0c                	push   $0xc
  801cca:	e8 60 fe ff ff       	call   801b2f <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	6a 0d                	push   $0xd
  801ce4:	e8 46 fe ff ff       	call   801b2f <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 0e                	push   $0xe
  801cfd:	e8 2d fe ff ff       	call   801b2f <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	90                   	nop
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 13                	push   $0x13
  801d17:	e8 13 fe ff ff       	call   801b2f <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	90                   	nop
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 14                	push   $0x14
  801d31:	e8 f9 fd ff ff       	call   801b2f <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	90                   	nop
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <sys_cputc>:


void
sys_cputc(const char c)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 04             	sub    $0x4,%esp
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d48:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	50                   	push   %eax
  801d55:	6a 15                	push   $0x15
  801d57:	e8 d3 fd ff ff       	call   801b2f <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	90                   	nop
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 16                	push   $0x16
  801d71:	e8 b9 fd ff ff       	call   801b2f <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
}
  801d79:	90                   	nop
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	ff 75 0c             	pushl  0xc(%ebp)
  801d8b:	50                   	push   %eax
  801d8c:	6a 17                	push   $0x17
  801d8e:	e8 9c fd ff ff       	call   801b2f <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	52                   	push   %edx
  801da8:	50                   	push   %eax
  801da9:	6a 1a                	push   $0x1a
  801dab:	e8 7f fd ff ff       	call   801b2f <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	52                   	push   %edx
  801dc5:	50                   	push   %eax
  801dc6:	6a 18                	push   $0x18
  801dc8:	e8 62 fd ff ff       	call   801b2f <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	90                   	nop
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	52                   	push   %edx
  801de3:	50                   	push   %eax
  801de4:	6a 19                	push   $0x19
  801de6:	e8 44 fd ff ff       	call   801b2f <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
}
  801dee:	90                   	nop
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 04             	sub    $0x4,%esp
  801df7:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dfd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e00:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	51                   	push   %ecx
  801e0a:	52                   	push   %edx
  801e0b:	ff 75 0c             	pushl  0xc(%ebp)
  801e0e:	50                   	push   %eax
  801e0f:	6a 1b                	push   $0x1b
  801e11:	e8 19 fd ff ff       	call   801b2f <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e21:	8b 45 08             	mov    0x8(%ebp),%eax
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	52                   	push   %edx
  801e2b:	50                   	push   %eax
  801e2c:	6a 1c                	push   $0x1c
  801e2e:	e8 fc fc ff ff       	call   801b2f <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	51                   	push   %ecx
  801e49:	52                   	push   %edx
  801e4a:	50                   	push   %eax
  801e4b:	6a 1d                	push   $0x1d
  801e4d:	e8 dd fc ff ff       	call   801b2f <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	52                   	push   %edx
  801e67:	50                   	push   %eax
  801e68:	6a 1e                	push   $0x1e
  801e6a:	e8 c0 fc ff ff       	call   801b2f <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 1f                	push   $0x1f
  801e83:	e8 a7 fc ff ff       	call   801b2f <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	6a 00                	push   $0x0
  801e95:	ff 75 14             	pushl  0x14(%ebp)
  801e98:	ff 75 10             	pushl  0x10(%ebp)
  801e9b:	ff 75 0c             	pushl  0xc(%ebp)
  801e9e:	50                   	push   %eax
  801e9f:	6a 20                	push   $0x20
  801ea1:	e8 89 fc ff ff       	call   801b2f <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	50                   	push   %eax
  801eba:	6a 21                	push   $0x21
  801ebc:	e8 6e fc ff ff       	call   801b2f <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	90                   	nop
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	50                   	push   %eax
  801ed6:	6a 22                	push   $0x22
  801ed8:	e8 52 fc ff ff       	call   801b2f <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 02                	push   $0x2
  801ef1:	e8 39 fc ff ff       	call   801b2f <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 03                	push   $0x3
  801f0a:	e8 20 fc ff ff       	call   801b2f <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 04                	push   $0x4
  801f23:	e8 07 fc ff ff       	call   801b2f <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_exit_env>:


void sys_exit_env(void)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 23                	push   $0x23
  801f3c:	e8 ee fb ff ff       	call   801b2f <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
}
  801f44:	90                   	nop
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f4d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f50:	8d 50 04             	lea    0x4(%eax),%edx
  801f53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	52                   	push   %edx
  801f5d:	50                   	push   %eax
  801f5e:	6a 24                	push   $0x24
  801f60:	e8 ca fb ff ff       	call   801b2f <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
	return result;
  801f68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f71:	89 01                	mov    %eax,(%ecx)
  801f73:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	c9                   	leave  
  801f7a:	c2 04 00             	ret    $0x4

00801f7d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	ff 75 10             	pushl  0x10(%ebp)
  801f87:	ff 75 0c             	pushl  0xc(%ebp)
  801f8a:	ff 75 08             	pushl  0x8(%ebp)
  801f8d:	6a 12                	push   $0x12
  801f8f:	e8 9b fb ff ff       	call   801b2f <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
	return ;
  801f97:	90                   	nop
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_rcr2>:
uint32 sys_rcr2()
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 25                	push   $0x25
  801fa9:	e8 81 fb ff ff       	call   801b2f <syscall>
  801fae:	83 c4 18             	add    $0x18,%esp
}
  801fb1:	c9                   	leave  
  801fb2:	c3                   	ret    

00801fb3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fbf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	50                   	push   %eax
  801fcc:	6a 26                	push   $0x26
  801fce:	e8 5c fb ff ff       	call   801b2f <syscall>
  801fd3:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd6:	90                   	nop
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <rsttst>:
void rsttst()
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 28                	push   $0x28
  801fe8:	e8 42 fb ff ff       	call   801b2f <syscall>
  801fed:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff0:	90                   	nop
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 04             	sub    $0x4,%esp
  801ff9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ffc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fff:	8b 55 18             	mov    0x18(%ebp),%edx
  802002:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802006:	52                   	push   %edx
  802007:	50                   	push   %eax
  802008:	ff 75 10             	pushl  0x10(%ebp)
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	ff 75 08             	pushl  0x8(%ebp)
  802011:	6a 27                	push   $0x27
  802013:	e8 17 fb ff ff       	call   801b2f <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
	return ;
  80201b:	90                   	nop
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <chktst>:
void chktst(uint32 n)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	ff 75 08             	pushl  0x8(%ebp)
  80202c:	6a 29                	push   $0x29
  80202e:	e8 fc fa ff ff       	call   801b2f <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
	return ;
  802036:	90                   	nop
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <inctst>:

void inctst()
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 2a                	push   $0x2a
  802048:	e8 e2 fa ff ff       	call   801b2f <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
	return ;
  802050:	90                   	nop
}
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <gettst>:
uint32 gettst()
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 2b                	push   $0x2b
  802062:	e8 c8 fa ff ff       	call   801b2f <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 2c                	push   $0x2c
  80207e:	e8 ac fa ff ff       	call   801b2f <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
  802086:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802089:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80208d:	75 07                	jne    802096 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80208f:	b8 01 00 00 00       	mov    $0x1,%eax
  802094:	eb 05                	jmp    80209b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802096:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 2c                	push   $0x2c
  8020af:	e8 7b fa ff ff       	call   801b2f <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
  8020b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020ba:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020be:	75 07                	jne    8020c7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020c0:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c5:	eb 05                	jmp    8020cc <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    

008020ce <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020ce:	55                   	push   %ebp
  8020cf:	89 e5                	mov    %esp,%ebp
  8020d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 2c                	push   $0x2c
  8020e0:	e8 4a fa ff ff       	call   801b2f <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
  8020e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020eb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020ef:	75 07                	jne    8020f8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8020f6:	eb 05                	jmp    8020fd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 2c                	push   $0x2c
  802111:	e8 19 fa ff ff       	call   801b2f <syscall>
  802116:	83 c4 18             	add    $0x18,%esp
  802119:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80211c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802120:	75 07                	jne    802129 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802122:	b8 01 00 00 00       	mov    $0x1,%eax
  802127:	eb 05                	jmp    80212e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	ff 75 08             	pushl  0x8(%ebp)
  80213e:	6a 2d                	push   $0x2d
  802140:	e8 ea f9 ff ff       	call   801b2f <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
	return ;
  802148:	90                   	nop
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80214f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802152:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802155:	8b 55 0c             	mov    0xc(%ebp),%edx
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	6a 00                	push   $0x0
  80215d:	53                   	push   %ebx
  80215e:	51                   	push   %ecx
  80215f:	52                   	push   %edx
  802160:	50                   	push   %eax
  802161:	6a 2e                	push   $0x2e
  802163:	e8 c7 f9 ff ff       	call   801b2f <syscall>
  802168:	83 c4 18             	add    $0x18,%esp
}
  80216b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802173:	8b 55 0c             	mov    0xc(%ebp),%edx
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	52                   	push   %edx
  802180:	50                   	push   %eax
  802181:	6a 2f                	push   $0x2f
  802183:	e8 a7 f9 ff ff       	call   801b2f <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802193:	83 ec 0c             	sub    $0xc,%esp
  802196:	68 c0 40 80 00       	push   $0x8040c0
  80219b:	e8 c3 e6 ff ff       	call   800863 <cprintf>
  8021a0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021aa:	83 ec 0c             	sub    $0xc,%esp
  8021ad:	68 ec 40 80 00       	push   $0x8040ec
  8021b2:	e8 ac e6 ff ff       	call   800863 <cprintf>
  8021b7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021ba:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021be:	a1 38 51 80 00       	mov    0x805138,%eax
  8021c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c6:	eb 56                	jmp    80221e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021cc:	74 1c                	je     8021ea <print_mem_block_lists+0x5d>
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 50 08             	mov    0x8(%eax),%edx
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	8b 48 08             	mov    0x8(%eax),%ecx
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e0:	01 c8                	add    %ecx,%eax
  8021e2:	39 c2                	cmp    %eax,%edx
  8021e4:	73 04                	jae    8021ea <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021e6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 50 08             	mov    0x8(%eax),%edx
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f6:	01 c2                	add    %eax,%edx
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	8b 40 08             	mov    0x8(%eax),%eax
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	52                   	push   %edx
  802202:	50                   	push   %eax
  802203:	68 01 41 80 00       	push   $0x804101
  802208:	e8 56 e6 ff ff       	call   800863 <cprintf>
  80220d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802216:	a1 40 51 80 00       	mov    0x805140,%eax
  80221b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802222:	74 07                	je     80222b <print_mem_block_lists+0x9e>
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	8b 00                	mov    (%eax),%eax
  802229:	eb 05                	jmp    802230 <print_mem_block_lists+0xa3>
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
  802230:	a3 40 51 80 00       	mov    %eax,0x805140
  802235:	a1 40 51 80 00       	mov    0x805140,%eax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	75 8a                	jne    8021c8 <print_mem_block_lists+0x3b>
  80223e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802242:	75 84                	jne    8021c8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802244:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802248:	75 10                	jne    80225a <print_mem_block_lists+0xcd>
  80224a:	83 ec 0c             	sub    $0xc,%esp
  80224d:	68 10 41 80 00       	push   $0x804110
  802252:	e8 0c e6 ff ff       	call   800863 <cprintf>
  802257:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80225a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802261:	83 ec 0c             	sub    $0xc,%esp
  802264:	68 34 41 80 00       	push   $0x804134
  802269:	e8 f5 e5 ff ff       	call   800863 <cprintf>
  80226e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802271:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802275:	a1 40 50 80 00       	mov    0x805040,%eax
  80227a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227d:	eb 56                	jmp    8022d5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80227f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802283:	74 1c                	je     8022a1 <print_mem_block_lists+0x114>
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 50 08             	mov    0x8(%eax),%edx
  80228b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228e:	8b 48 08             	mov    0x8(%eax),%ecx
  802291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802294:	8b 40 0c             	mov    0xc(%eax),%eax
  802297:	01 c8                	add    %ecx,%eax
  802299:	39 c2                	cmp    %eax,%edx
  80229b:	73 04                	jae    8022a1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80229d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 50 08             	mov    0x8(%eax),%edx
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ad:	01 c2                	add    %eax,%edx
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 40 08             	mov    0x8(%eax),%eax
  8022b5:	83 ec 04             	sub    $0x4,%esp
  8022b8:	52                   	push   %edx
  8022b9:	50                   	push   %eax
  8022ba:	68 01 41 80 00       	push   $0x804101
  8022bf:	e8 9f e5 ff ff       	call   800863 <cprintf>
  8022c4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022cd:	a1 48 50 80 00       	mov    0x805048,%eax
  8022d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d9:	74 07                	je     8022e2 <print_mem_block_lists+0x155>
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	eb 05                	jmp    8022e7 <print_mem_block_lists+0x15a>
  8022e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e7:	a3 48 50 80 00       	mov    %eax,0x805048
  8022ec:	a1 48 50 80 00       	mov    0x805048,%eax
  8022f1:	85 c0                	test   %eax,%eax
  8022f3:	75 8a                	jne    80227f <print_mem_block_lists+0xf2>
  8022f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f9:	75 84                	jne    80227f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022fb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022ff:	75 10                	jne    802311 <print_mem_block_lists+0x184>
  802301:	83 ec 0c             	sub    $0xc,%esp
  802304:	68 4c 41 80 00       	push   $0x80414c
  802309:	e8 55 e5 ff ff       	call   800863 <cprintf>
  80230e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802311:	83 ec 0c             	sub    $0xc,%esp
  802314:	68 c0 40 80 00       	push   $0x8040c0
  802319:	e8 45 e5 ff ff       	call   800863 <cprintf>
  80231e:	83 c4 10             	add    $0x10,%esp

}
  802321:	90                   	nop
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  80232a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802331:	00 00 00 
  802334:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80233b:	00 00 00 
  80233e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802345:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80234f:	e9 9e 00 00 00       	jmp    8023f2 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802354:	a1 50 50 80 00       	mov    0x805050,%eax
  802359:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235c:	c1 e2 04             	shl    $0x4,%edx
  80235f:	01 d0                	add    %edx,%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	75 14                	jne    802379 <initialize_MemBlocksList+0x55>
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	68 74 41 80 00       	push   $0x804174
  80236d:	6a 47                	push   $0x47
  80236f:	68 97 41 80 00       	push   $0x804197
  802374:	e8 36 e2 ff ff       	call   8005af <_panic>
  802379:	a1 50 50 80 00       	mov    0x805050,%eax
  80237e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802381:	c1 e2 04             	shl    $0x4,%edx
  802384:	01 d0                	add    %edx,%eax
  802386:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80238c:	89 10                	mov    %edx,(%eax)
  80238e:	8b 00                	mov    (%eax),%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	74 18                	je     8023ac <initialize_MemBlocksList+0x88>
  802394:	a1 48 51 80 00       	mov    0x805148,%eax
  802399:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80239f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023a2:	c1 e1 04             	shl    $0x4,%ecx
  8023a5:	01 ca                	add    %ecx,%edx
  8023a7:	89 50 04             	mov    %edx,0x4(%eax)
  8023aa:	eb 12                	jmp    8023be <initialize_MemBlocksList+0x9a>
  8023ac:	a1 50 50 80 00       	mov    0x805050,%eax
  8023b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b4:	c1 e2 04             	shl    $0x4,%edx
  8023b7:	01 d0                	add    %edx,%eax
  8023b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023be:	a1 50 50 80 00       	mov    0x805050,%eax
  8023c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c6:	c1 e2 04             	shl    $0x4,%edx
  8023c9:	01 d0                	add    %edx,%eax
  8023cb:	a3 48 51 80 00       	mov    %eax,0x805148
  8023d0:	a1 50 50 80 00       	mov    0x805050,%eax
  8023d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d8:	c1 e2 04             	shl    $0x4,%edx
  8023db:	01 d0                	add    %edx,%eax
  8023dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e4:	a1 54 51 80 00       	mov    0x805154,%eax
  8023e9:	40                   	inc    %eax
  8023ea:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8023ef:	ff 45 f4             	incl   -0xc(%ebp)
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f8:	0f 82 56 ff ff ff    	jb     802354 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8023fe:	90                   	nop
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80240f:	eb 19                	jmp    80242a <find_block+0x29>
	{
		if(element->sva == va){
  802411:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802414:	8b 40 08             	mov    0x8(%eax),%eax
  802417:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80241a:	75 05                	jne    802421 <find_block+0x20>
			 		return element;
  80241c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80241f:	eb 36                	jmp    802457 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	8b 40 08             	mov    0x8(%eax),%eax
  802427:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80242a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80242e:	74 07                	je     802437 <find_block+0x36>
  802430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	eb 05                	jmp    80243c <find_block+0x3b>
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
  80243c:	8b 55 08             	mov    0x8(%ebp),%edx
  80243f:	89 42 08             	mov    %eax,0x8(%edx)
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	8b 40 08             	mov    0x8(%eax),%eax
  802448:	85 c0                	test   %eax,%eax
  80244a:	75 c5                	jne    802411 <find_block+0x10>
  80244c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802450:	75 bf                	jne    802411 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80245f:	a1 44 50 80 00       	mov    0x805044,%eax
  802464:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802467:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80246c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80246f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802473:	74 0a                	je     80247f <insert_sorted_allocList+0x26>
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	8b 40 08             	mov    0x8(%eax),%eax
  80247b:	85 c0                	test   %eax,%eax
  80247d:	75 65                	jne    8024e4 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80247f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802483:	75 14                	jne    802499 <insert_sorted_allocList+0x40>
  802485:	83 ec 04             	sub    $0x4,%esp
  802488:	68 74 41 80 00       	push   $0x804174
  80248d:	6a 6e                	push   $0x6e
  80248f:	68 97 41 80 00       	push   $0x804197
  802494:	e8 16 e1 ff ff       	call   8005af <_panic>
  802499:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	89 10                	mov    %edx,(%eax)
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	74 0d                	je     8024ba <insert_sorted_allocList+0x61>
  8024ad:	a1 40 50 80 00       	mov    0x805040,%eax
  8024b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b5:	89 50 04             	mov    %edx,0x4(%eax)
  8024b8:	eb 08                	jmp    8024c2 <insert_sorted_allocList+0x69>
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	a3 44 50 80 00       	mov    %eax,0x805044
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	a3 40 50 80 00       	mov    %eax,0x805040
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024d9:	40                   	inc    %eax
  8024da:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8024df:	e9 cf 01 00 00       	jmp    8026b3 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8024e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ed:	8b 40 08             	mov    0x8(%eax),%eax
  8024f0:	39 c2                	cmp    %eax,%edx
  8024f2:	73 65                	jae    802559 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8024f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024f8:	75 14                	jne    80250e <insert_sorted_allocList+0xb5>
  8024fa:	83 ec 04             	sub    $0x4,%esp
  8024fd:	68 b0 41 80 00       	push   $0x8041b0
  802502:	6a 72                	push   $0x72
  802504:	68 97 41 80 00       	push   $0x804197
  802509:	e8 a1 e0 ff ff       	call   8005af <_panic>
  80250e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	89 50 04             	mov    %edx,0x4(%eax)
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	74 0c                	je     802530 <insert_sorted_allocList+0xd7>
  802524:	a1 44 50 80 00       	mov    0x805044,%eax
  802529:	8b 55 08             	mov    0x8(%ebp),%edx
  80252c:	89 10                	mov    %edx,(%eax)
  80252e:	eb 08                	jmp    802538 <insert_sorted_allocList+0xdf>
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	a3 40 50 80 00       	mov    %eax,0x805040
  802538:	8b 45 08             	mov    0x8(%ebp),%eax
  80253b:	a3 44 50 80 00       	mov    %eax,0x805044
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802549:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80254e:	40                   	inc    %eax
  80254f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802554:	e9 5a 01 00 00       	jmp    8026b3 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255c:	8b 50 08             	mov    0x8(%eax),%edx
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	8b 40 08             	mov    0x8(%eax),%eax
  802565:	39 c2                	cmp    %eax,%edx
  802567:	75 70                	jne    8025d9 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802569:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80256d:	74 06                	je     802575 <insert_sorted_allocList+0x11c>
  80256f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802573:	75 14                	jne    802589 <insert_sorted_allocList+0x130>
  802575:	83 ec 04             	sub    $0x4,%esp
  802578:	68 d4 41 80 00       	push   $0x8041d4
  80257d:	6a 75                	push   $0x75
  80257f:	68 97 41 80 00       	push   $0x804197
  802584:	e8 26 e0 ff ff       	call   8005af <_panic>
  802589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258c:	8b 10                	mov    (%eax),%edx
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	89 10                	mov    %edx,(%eax)
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 0b                	je     8025a7 <insert_sorted_allocList+0x14e>
  80259c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a4:	89 50 04             	mov    %edx,0x4(%eax)
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ad:	89 10                	mov    %edx,(%eax)
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025b5:	89 50 04             	mov    %edx,0x4(%eax)
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	75 08                	jne    8025c9 <insert_sorted_allocList+0x170>
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	a3 44 50 80 00       	mov    %eax,0x805044
  8025c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ce:	40                   	inc    %eax
  8025cf:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8025d4:	e9 da 00 00 00       	jmp    8026b3 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8025d9:	a1 40 50 80 00       	mov    0x805040,%eax
  8025de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e1:	e9 9d 00 00 00       	jmp    802683 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 00                	mov    (%eax),%eax
  8025eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	8b 50 08             	mov    0x8(%eax),%edx
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 40 08             	mov    0x8(%eax),%eax
  8025fa:	39 c2                	cmp    %eax,%edx
  8025fc:	76 7d                	jbe    80267b <insert_sorted_allocList+0x222>
  8025fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802601:	8b 50 08             	mov    0x8(%eax),%edx
  802604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802607:	8b 40 08             	mov    0x8(%eax),%eax
  80260a:	39 c2                	cmp    %eax,%edx
  80260c:	73 6d                	jae    80267b <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80260e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802612:	74 06                	je     80261a <insert_sorted_allocList+0x1c1>
  802614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802618:	75 14                	jne    80262e <insert_sorted_allocList+0x1d5>
  80261a:	83 ec 04             	sub    $0x4,%esp
  80261d:	68 d4 41 80 00       	push   $0x8041d4
  802622:	6a 7c                	push   $0x7c
  802624:	68 97 41 80 00       	push   $0x804197
  802629:	e8 81 df ff ff       	call   8005af <_panic>
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 10                	mov    (%eax),%edx
  802633:	8b 45 08             	mov    0x8(%ebp),%eax
  802636:	89 10                	mov    %edx,(%eax)
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	74 0b                	je     80264c <insert_sorted_allocList+0x1f3>
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	8b 55 08             	mov    0x8(%ebp),%edx
  802649:	89 50 04             	mov    %edx,0x4(%eax)
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 55 08             	mov    0x8(%ebp),%edx
  802652:	89 10                	mov    %edx,(%eax)
  802654:	8b 45 08             	mov    0x8(%ebp),%eax
  802657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265a:	89 50 04             	mov    %edx,0x4(%eax)
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	85 c0                	test   %eax,%eax
  802664:	75 08                	jne    80266e <insert_sorted_allocList+0x215>
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	a3 44 50 80 00       	mov    %eax,0x805044
  80266e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802673:	40                   	inc    %eax
  802674:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802679:	eb 38                	jmp    8026b3 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  80267b:	a1 48 50 80 00       	mov    0x805048,%eax
  802680:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802683:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802687:	74 07                	je     802690 <insert_sorted_allocList+0x237>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 00                	mov    (%eax),%eax
  80268e:	eb 05                	jmp    802695 <insert_sorted_allocList+0x23c>
  802690:	b8 00 00 00 00       	mov    $0x0,%eax
  802695:	a3 48 50 80 00       	mov    %eax,0x805048
  80269a:	a1 48 50 80 00       	mov    0x805048,%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	0f 85 3f ff ff ff    	jne    8025e6 <insert_sorted_allocList+0x18d>
  8026a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ab:	0f 85 35 ff ff ff    	jne    8025e6 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8026b1:	eb 00                	jmp    8026b3 <insert_sorted_allocList+0x25a>
  8026b3:	90                   	nop
  8026b4:	c9                   	leave  
  8026b5:	c3                   	ret    

008026b6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
  8026b9:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8026bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8026c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c4:	e9 6b 02 00 00       	jmp    802934 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d2:	0f 85 90 00 00 00    	jne    802768 <alloc_block_FF+0xb2>
			  temp=element;
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8026de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e2:	75 17                	jne    8026fb <alloc_block_FF+0x45>
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	68 08 42 80 00       	push   $0x804208
  8026ec:	68 92 00 00 00       	push   $0x92
  8026f1:	68 97 41 80 00       	push   $0x804197
  8026f6:	e8 b4 de ff ff       	call   8005af <_panic>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 00                	mov    (%eax),%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	74 10                	je     802714 <alloc_block_FF+0x5e>
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270c:	8b 52 04             	mov    0x4(%edx),%edx
  80270f:	89 50 04             	mov    %edx,0x4(%eax)
  802712:	eb 0b                	jmp    80271f <alloc_block_FF+0x69>
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	74 0f                	je     802738 <alloc_block_FF+0x82>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 40 04             	mov    0x4(%eax),%eax
  80272f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802732:	8b 12                	mov    (%edx),%edx
  802734:	89 10                	mov    %edx,(%eax)
  802736:	eb 0a                	jmp    802742 <alloc_block_FF+0x8c>
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	a3 38 51 80 00       	mov    %eax,0x805138
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802755:	a1 44 51 80 00       	mov    0x805144,%eax
  80275a:	48                   	dec    %eax
  80275b:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  802760:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802763:	e9 ff 01 00 00       	jmp    802967 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802771:	0f 86 b5 01 00 00    	jbe    80292c <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 40 0c             	mov    0xc(%eax),%eax
  80277d:	2b 45 08             	sub    0x8(%ebp),%eax
  802780:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  802783:	a1 48 51 80 00       	mov    0x805148,%eax
  802788:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  80278b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80278f:	75 17                	jne    8027a8 <alloc_block_FF+0xf2>
  802791:	83 ec 04             	sub    $0x4,%esp
  802794:	68 08 42 80 00       	push   $0x804208
  802799:	68 99 00 00 00       	push   $0x99
  80279e:	68 97 41 80 00       	push   $0x804197
  8027a3:	e8 07 de ff ff       	call   8005af <_panic>
  8027a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	74 10                	je     8027c1 <alloc_block_FF+0x10b>
  8027b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b9:	8b 52 04             	mov    0x4(%edx),%edx
  8027bc:	89 50 04             	mov    %edx,0x4(%eax)
  8027bf:	eb 0b                	jmp    8027cc <alloc_block_FF+0x116>
  8027c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cf:	8b 40 04             	mov    0x4(%eax),%eax
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	74 0f                	je     8027e5 <alloc_block_FF+0x12f>
  8027d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d9:	8b 40 04             	mov    0x4(%eax),%eax
  8027dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027df:	8b 12                	mov    (%edx),%edx
  8027e1:	89 10                	mov    %edx,(%eax)
  8027e3:	eb 0a                	jmp    8027ef <alloc_block_FF+0x139>
  8027e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8027ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802802:	a1 54 51 80 00       	mov    0x805154,%eax
  802807:	48                   	dec    %eax
  802808:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80280d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802811:	75 17                	jne    80282a <alloc_block_FF+0x174>
  802813:	83 ec 04             	sub    $0x4,%esp
  802816:	68 b0 41 80 00       	push   $0x8041b0
  80281b:	68 9a 00 00 00       	push   $0x9a
  802820:	68 97 41 80 00       	push   $0x804197
  802825:	e8 85 dd ff ff       	call   8005af <_panic>
  80282a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802833:	89 50 04             	mov    %edx,0x4(%eax)
  802836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802839:	8b 40 04             	mov    0x4(%eax),%eax
  80283c:	85 c0                	test   %eax,%eax
  80283e:	74 0c                	je     80284c <alloc_block_FF+0x196>
  802840:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802845:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802848:	89 10                	mov    %edx,(%eax)
  80284a:	eb 08                	jmp    802854 <alloc_block_FF+0x19e>
  80284c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284f:	a3 38 51 80 00       	mov    %eax,0x805138
  802854:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802857:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80285c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802865:	a1 44 51 80 00       	mov    0x805144,%eax
  80286a:	40                   	inc    %eax
  80286b:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  802870:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802873:	8b 55 08             	mov    0x8(%ebp),%edx
  802876:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 50 08             	mov    0x8(%eax),%edx
  80287f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802882:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288b:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 50 08             	mov    0x8(%eax),%edx
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	01 c2                	add    %eax,%edx
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  80289f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8028a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028a9:	75 17                	jne    8028c2 <alloc_block_FF+0x20c>
  8028ab:	83 ec 04             	sub    $0x4,%esp
  8028ae:	68 08 42 80 00       	push   $0x804208
  8028b3:	68 a2 00 00 00       	push   $0xa2
  8028b8:	68 97 41 80 00       	push   $0x804197
  8028bd:	e8 ed dc ff ff       	call   8005af <_panic>
  8028c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	74 10                	je     8028db <alloc_block_FF+0x225>
  8028cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d3:	8b 52 04             	mov    0x4(%edx),%edx
  8028d6:	89 50 04             	mov    %edx,0x4(%eax)
  8028d9:	eb 0b                	jmp    8028e6 <alloc_block_FF+0x230>
  8028db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028de:	8b 40 04             	mov    0x4(%eax),%eax
  8028e1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	74 0f                	je     8028ff <alloc_block_FF+0x249>
  8028f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f3:	8b 40 04             	mov    0x4(%eax),%eax
  8028f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f9:	8b 12                	mov    (%edx),%edx
  8028fb:	89 10                	mov    %edx,(%eax)
  8028fd:	eb 0a                	jmp    802909 <alloc_block_FF+0x253>
  8028ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802902:	8b 00                	mov    (%eax),%eax
  802904:	a3 38 51 80 00       	mov    %eax,0x805138
  802909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802915:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291c:	a1 44 51 80 00       	mov    0x805144,%eax
  802921:	48                   	dec    %eax
  802922:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292a:	eb 3b                	jmp    802967 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80292c:	a1 40 51 80 00       	mov    0x805140,%eax
  802931:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802938:	74 07                	je     802941 <alloc_block_FF+0x28b>
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	eb 05                	jmp    802946 <alloc_block_FF+0x290>
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
  802946:	a3 40 51 80 00       	mov    %eax,0x805140
  80294b:	a1 40 51 80 00       	mov    0x805140,%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	0f 85 71 fd ff ff    	jne    8026c9 <alloc_block_FF+0x13>
  802958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295c:	0f 85 67 fd ff ff    	jne    8026c9 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802967:	c9                   	leave  
  802968:	c3                   	ret    

00802969 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802969:	55                   	push   %ebp
  80296a:	89 e5                	mov    %esp,%ebp
  80296c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80296f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802976:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80297d:	a1 38 51 80 00       	mov    0x805138,%eax
  802982:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802985:	e9 d3 00 00 00       	jmp    802a5d <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  80298a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298d:	8b 40 0c             	mov    0xc(%eax),%eax
  802990:	3b 45 08             	cmp    0x8(%ebp),%eax
  802993:	0f 85 90 00 00 00    	jne    802a29 <alloc_block_BF+0xc0>
	   temp = element;
  802999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  80299f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029a3:	75 17                	jne    8029bc <alloc_block_BF+0x53>
  8029a5:	83 ec 04             	sub    $0x4,%esp
  8029a8:	68 08 42 80 00       	push   $0x804208
  8029ad:	68 bd 00 00 00       	push   $0xbd
  8029b2:	68 97 41 80 00       	push   $0x804197
  8029b7:	e8 f3 db ff ff       	call   8005af <_panic>
  8029bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 10                	je     8029d5 <alloc_block_BF+0x6c>
  8029c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029cd:	8b 52 04             	mov    0x4(%edx),%edx
  8029d0:	89 50 04             	mov    %edx,0x4(%eax)
  8029d3:	eb 0b                	jmp    8029e0 <alloc_block_BF+0x77>
  8029d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d8:	8b 40 04             	mov    0x4(%eax),%eax
  8029db:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e3:	8b 40 04             	mov    0x4(%eax),%eax
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	74 0f                	je     8029f9 <alloc_block_BF+0x90>
  8029ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ed:	8b 40 04             	mov    0x4(%eax),%eax
  8029f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029f3:	8b 12                	mov    (%edx),%edx
  8029f5:	89 10                	mov    %edx,(%eax)
  8029f7:	eb 0a                	jmp    802a03 <alloc_block_BF+0x9a>
  8029f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	a3 38 51 80 00       	mov    %eax,0x805138
  802a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a16:	a1 44 51 80 00       	mov    0x805144,%eax
  802a1b:	48                   	dec    %eax
  802a1c:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a24:	e9 41 01 00 00       	jmp    802b6a <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a32:	76 21                	jbe    802a55 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a37:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a3d:	73 16                	jae    802a55 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a42:	8b 40 0c             	mov    0xc(%eax),%eax
  802a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802a4e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802a55:	a1 40 51 80 00       	mov    0x805140,%eax
  802a5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a61:	74 07                	je     802a6a <alloc_block_BF+0x101>
  802a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	eb 05                	jmp    802a6f <alloc_block_BF+0x106>
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	a3 40 51 80 00       	mov    %eax,0x805140
  802a74:	a1 40 51 80 00       	mov    0x805140,%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	0f 85 09 ff ff ff    	jne    80298a <alloc_block_BF+0x21>
  802a81:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a85:	0f 85 ff fe ff ff    	jne    80298a <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802a8b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802a8f:	0f 85 d0 00 00 00    	jne    802b65 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a98:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802aa1:	a1 48 51 80 00       	mov    0x805148,%eax
  802aa6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802aad:	75 17                	jne    802ac6 <alloc_block_BF+0x15d>
  802aaf:	83 ec 04             	sub    $0x4,%esp
  802ab2:	68 08 42 80 00       	push   $0x804208
  802ab7:	68 d1 00 00 00       	push   $0xd1
  802abc:	68 97 41 80 00       	push   $0x804197
  802ac1:	e8 e9 da ff ff       	call   8005af <_panic>
  802ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	74 10                	je     802adf <alloc_block_BF+0x176>
  802acf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad2:	8b 00                	mov    (%eax),%eax
  802ad4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ad7:	8b 52 04             	mov    0x4(%edx),%edx
  802ada:	89 50 04             	mov    %edx,0x4(%eax)
  802add:	eb 0b                	jmp    802aea <alloc_block_BF+0x181>
  802adf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae2:	8b 40 04             	mov    0x4(%eax),%eax
  802ae5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802aed:	8b 40 04             	mov    0x4(%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 0f                	je     802b03 <alloc_block_BF+0x19a>
  802af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af7:	8b 40 04             	mov    0x4(%eax),%eax
  802afa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802afd:	8b 12                	mov    (%edx),%edx
  802aff:	89 10                	mov    %edx,(%eax)
  802b01:	eb 0a                	jmp    802b0d <alloc_block_BF+0x1a4>
  802b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b06:	8b 00                	mov    (%eax),%eax
  802b08:	a3 48 51 80 00       	mov    %eax,0x805148
  802b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b20:	a1 54 51 80 00       	mov    0x805154,%eax
  802b25:	48                   	dec    %eax
  802b26:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802b2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b31:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b37:	8b 50 08             	mov    0x8(%eax),%edx
  802b3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3d:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802b40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802b46:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4c:	8b 50 08             	mov    0x8(%eax),%edx
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	01 c2                	add    %eax,%edx
  802b54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b57:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802b5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802b60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b63:	eb 05                	jmp    802b6a <alloc_block_BF+0x201>
	 }
	 return NULL;
  802b65:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802b6a:	c9                   	leave  
  802b6b:	c3                   	ret    

00802b6c <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802b6c:	55                   	push   %ebp
  802b6d:	89 e5                	mov    %esp,%ebp
  802b6f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802b72:	83 ec 04             	sub    $0x4,%esp
  802b75:	68 28 42 80 00       	push   $0x804228
  802b7a:	68 e8 00 00 00       	push   $0xe8
  802b7f:	68 97 41 80 00       	push   $0x804197
  802b84:	e8 26 da ff ff       	call   8005af <_panic>

00802b89 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b89:	55                   	push   %ebp
  802b8a:	89 e5                	mov    %esp,%ebp
  802b8c:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802b8f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802b97:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802b9f:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802ba7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bab:	75 68                	jne    802c15 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb1:	75 17                	jne    802bca <insert_sorted_with_merge_freeList+0x41>
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	68 74 41 80 00       	push   $0x804174
  802bbb:	68 36 01 00 00       	push   $0x136
  802bc0:	68 97 41 80 00       	push   $0x804197
  802bc5:	e8 e5 d9 ff ff       	call   8005af <_panic>
  802bca:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	89 10                	mov    %edx,(%eax)
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	8b 00                	mov    (%eax),%eax
  802bda:	85 c0                	test   %eax,%eax
  802bdc:	74 0d                	je     802beb <insert_sorted_with_merge_freeList+0x62>
  802bde:	a1 38 51 80 00       	mov    0x805138,%eax
  802be3:	8b 55 08             	mov    0x8(%ebp),%edx
  802be6:	89 50 04             	mov    %edx,0x4(%eax)
  802be9:	eb 08                	jmp    802bf3 <insert_sorted_with_merge_freeList+0x6a>
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	a3 38 51 80 00       	mov    %eax,0x805138
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c05:	a1 44 51 80 00       	mov    0x805144,%eax
  802c0a:	40                   	inc    %eax
  802c0b:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802c10:	e9 ba 06 00 00       	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c18:	8b 50 08             	mov    0x8(%eax),%edx
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c21:	01 c2                	add    %eax,%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	8b 40 08             	mov    0x8(%eax),%eax
  802c29:	39 c2                	cmp    %eax,%edx
  802c2b:	73 68                	jae    802c95 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c31:	75 17                	jne    802c4a <insert_sorted_with_merge_freeList+0xc1>
  802c33:	83 ec 04             	sub    $0x4,%esp
  802c36:	68 b0 41 80 00       	push   $0x8041b0
  802c3b:	68 3a 01 00 00       	push   $0x13a
  802c40:	68 97 41 80 00       	push   $0x804197
  802c45:	e8 65 d9 ff ff       	call   8005af <_panic>
  802c4a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	89 50 04             	mov    %edx,0x4(%eax)
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	8b 40 04             	mov    0x4(%eax),%eax
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	74 0c                	je     802c6c <insert_sorted_with_merge_freeList+0xe3>
  802c60:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c65:	8b 55 08             	mov    0x8(%ebp),%edx
  802c68:	89 10                	mov    %edx,(%eax)
  802c6a:	eb 08                	jmp    802c74 <insert_sorted_with_merge_freeList+0xeb>
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	a3 38 51 80 00       	mov    %eax,0x805138
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c85:	a1 44 51 80 00       	mov    0x805144,%eax
  802c8a:	40                   	inc    %eax
  802c8b:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802c90:	e9 3a 06 00 00       	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	8b 50 08             	mov    0x8(%eax),%edx
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca1:	01 c2                	add    %eax,%edx
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 40 08             	mov    0x8(%eax),%eax
  802ca9:	39 c2                	cmp    %eax,%edx
  802cab:	0f 85 90 00 00 00    	jne    802d41 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cba:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbd:	01 c2                	add    %eax,%edx
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802cd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cdd:	75 17                	jne    802cf6 <insert_sorted_with_merge_freeList+0x16d>
  802cdf:	83 ec 04             	sub    $0x4,%esp
  802ce2:	68 74 41 80 00       	push   $0x804174
  802ce7:	68 41 01 00 00       	push   $0x141
  802cec:	68 97 41 80 00       	push   $0x804197
  802cf1:	e8 b9 d8 ff ff       	call   8005af <_panic>
  802cf6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	89 10                	mov    %edx,(%eax)
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	85 c0                	test   %eax,%eax
  802d08:	74 0d                	je     802d17 <insert_sorted_with_merge_freeList+0x18e>
  802d0a:	a1 48 51 80 00       	mov    0x805148,%eax
  802d0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d12:	89 50 04             	mov    %edx,0x4(%eax)
  802d15:	eb 08                	jmp    802d1f <insert_sorted_with_merge_freeList+0x196>
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	a3 48 51 80 00       	mov    %eax,0x805148
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d31:	a1 54 51 80 00       	mov    0x805154,%eax
  802d36:	40                   	inc    %eax
  802d37:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802d3c:	e9 8e 05 00 00       	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 50 08             	mov    0x8(%eax),%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4d:	01 c2                	add    %eax,%edx
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	8b 40 08             	mov    0x8(%eax),%eax
  802d55:	39 c2                	cmp    %eax,%edx
  802d57:	73 68                	jae    802dc1 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5d:	75 17                	jne    802d76 <insert_sorted_with_merge_freeList+0x1ed>
  802d5f:	83 ec 04             	sub    $0x4,%esp
  802d62:	68 74 41 80 00       	push   $0x804174
  802d67:	68 45 01 00 00       	push   $0x145
  802d6c:	68 97 41 80 00       	push   $0x804197
  802d71:	e8 39 d8 ff ff       	call   8005af <_panic>
  802d76:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	89 10                	mov    %edx,(%eax)
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 0d                	je     802d97 <insert_sorted_with_merge_freeList+0x20e>
  802d8a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d92:	89 50 04             	mov    %edx,0x4(%eax)
  802d95:	eb 08                	jmp    802d9f <insert_sorted_with_merge_freeList+0x216>
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	a3 38 51 80 00       	mov    %eax,0x805138
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db1:	a1 44 51 80 00       	mov    0x805144,%eax
  802db6:	40                   	inc    %eax
  802db7:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802dbc:	e9 0e 05 00 00       	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	8b 50 08             	mov    0x8(%eax),%edx
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	01 c2                	add    %eax,%edx
  802dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd2:	8b 40 08             	mov    0x8(%eax),%eax
  802dd5:	39 c2                	cmp    %eax,%edx
  802dd7:	0f 85 9c 00 00 00    	jne    802e79 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de0:	8b 50 0c             	mov    0xc(%eax),%edx
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	8b 40 0c             	mov    0xc(%eax),%eax
  802de9:	01 c2                	add    %eax,%edx
  802deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dee:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	8b 50 08             	mov    0x8(%eax),%edx
  802df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfa:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e15:	75 17                	jne    802e2e <insert_sorted_with_merge_freeList+0x2a5>
  802e17:	83 ec 04             	sub    $0x4,%esp
  802e1a:	68 74 41 80 00       	push   $0x804174
  802e1f:	68 4d 01 00 00       	push   $0x14d
  802e24:	68 97 41 80 00       	push   $0x804197
  802e29:	e8 81 d7 ff ff       	call   8005af <_panic>
  802e2e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	89 10                	mov    %edx,(%eax)
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	8b 00                	mov    (%eax),%eax
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	74 0d                	je     802e4f <insert_sorted_with_merge_freeList+0x2c6>
  802e42:	a1 48 51 80 00       	mov    0x805148,%eax
  802e47:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4a:	89 50 04             	mov    %edx,0x4(%eax)
  802e4d:	eb 08                	jmp    802e57 <insert_sorted_with_merge_freeList+0x2ce>
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	a3 48 51 80 00       	mov    %eax,0x805148
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e69:	a1 54 51 80 00       	mov    0x805154,%eax
  802e6e:	40                   	inc    %eax
  802e6f:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802e74:	e9 56 04 00 00       	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802e79:	a1 38 51 80 00       	mov    0x805138,%eax
  802e7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e81:	e9 19 04 00 00       	jmp    80329f <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e91:	8b 50 08             	mov    0x8(%eax),%edx
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9a:	01 c2                	add    %eax,%edx
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ea2:	39 c2                	cmp    %eax,%edx
  802ea4:	0f 85 ad 01 00 00    	jne    803057 <insert_sorted_with_merge_freeList+0x4ce>
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	8b 50 08             	mov    0x8(%eax),%edx
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb6:	01 c2                	add    %eax,%edx
  802eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ebb:	8b 40 08             	mov    0x8(%eax),%eax
  802ebe:	39 c2                	cmp    %eax,%edx
  802ec0:	0f 85 91 01 00 00    	jne    803057 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 50 0c             	mov    0xc(%eax),%edx
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed8:	01 c8                	add    %ecx,%eax
  802eda:	01 c2                	add    %eax,%edx
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802ef6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ef9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802f00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802f0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f0e:	75 17                	jne    802f27 <insert_sorted_with_merge_freeList+0x39e>
  802f10:	83 ec 04             	sub    $0x4,%esp
  802f13:	68 08 42 80 00       	push   $0x804208
  802f18:	68 5b 01 00 00       	push   $0x15b
  802f1d:	68 97 41 80 00       	push   $0x804197
  802f22:	e8 88 d6 ff ff       	call   8005af <_panic>
  802f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 10                	je     802f40 <insert_sorted_with_merge_freeList+0x3b7>
  802f30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f33:	8b 00                	mov    (%eax),%eax
  802f35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f38:	8b 52 04             	mov    0x4(%edx),%edx
  802f3b:	89 50 04             	mov    %edx,0x4(%eax)
  802f3e:	eb 0b                	jmp    802f4b <insert_sorted_with_merge_freeList+0x3c2>
  802f40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f43:	8b 40 04             	mov    0x4(%eax),%eax
  802f46:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4e:	8b 40 04             	mov    0x4(%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 0f                	je     802f64 <insert_sorted_with_merge_freeList+0x3db>
  802f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f58:	8b 40 04             	mov    0x4(%eax),%eax
  802f5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f5e:	8b 12                	mov    (%edx),%edx
  802f60:	89 10                	mov    %edx,(%eax)
  802f62:	eb 0a                	jmp    802f6e <insert_sorted_with_merge_freeList+0x3e5>
  802f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f67:	8b 00                	mov    (%eax),%eax
  802f69:	a3 38 51 80 00       	mov    %eax,0x805138
  802f6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f81:	a1 44 51 80 00       	mov    0x805144,%eax
  802f86:	48                   	dec    %eax
  802f87:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f90:	75 17                	jne    802fa9 <insert_sorted_with_merge_freeList+0x420>
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	68 74 41 80 00       	push   $0x804174
  802f9a:	68 5c 01 00 00       	push   $0x15c
  802f9f:	68 97 41 80 00       	push   $0x804197
  802fa4:	e8 06 d6 ff ff       	call   8005af <_panic>
  802fa9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	89 10                	mov    %edx,(%eax)
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 0d                	je     802fca <insert_sorted_with_merge_freeList+0x441>
  802fbd:	a1 48 51 80 00       	mov    0x805148,%eax
  802fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc5:	89 50 04             	mov    %edx,0x4(%eax)
  802fc8:	eb 08                	jmp    802fd2 <insert_sorted_with_merge_freeList+0x449>
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	a3 48 51 80 00       	mov    %eax,0x805148
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe4:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe9:	40                   	inc    %eax
  802fea:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802fef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ff3:	75 17                	jne    80300c <insert_sorted_with_merge_freeList+0x483>
  802ff5:	83 ec 04             	sub    $0x4,%esp
  802ff8:	68 74 41 80 00       	push   $0x804174
  802ffd:	68 5d 01 00 00       	push   $0x15d
  803002:	68 97 41 80 00       	push   $0x804197
  803007:	e8 a3 d5 ff ff       	call   8005af <_panic>
  80300c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803012:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803015:	89 10                	mov    %edx,(%eax)
  803017:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301a:	8b 00                	mov    (%eax),%eax
  80301c:	85 c0                	test   %eax,%eax
  80301e:	74 0d                	je     80302d <insert_sorted_with_merge_freeList+0x4a4>
  803020:	a1 48 51 80 00       	mov    0x805148,%eax
  803025:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803028:	89 50 04             	mov    %edx,0x4(%eax)
  80302b:	eb 08                	jmp    803035 <insert_sorted_with_merge_freeList+0x4ac>
  80302d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803030:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803035:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803038:	a3 48 51 80 00       	mov    %eax,0x805148
  80303d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803040:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803047:	a1 54 51 80 00       	mov    0x805154,%eax
  80304c:	40                   	inc    %eax
  80304d:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803052:	e9 78 02 00 00       	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	8b 50 08             	mov    0x8(%eax),%edx
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 40 0c             	mov    0xc(%eax),%eax
  803063:	01 c2                	add    %eax,%edx
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	8b 40 08             	mov    0x8(%eax),%eax
  80306b:	39 c2                	cmp    %eax,%edx
  80306d:	0f 83 b8 00 00 00    	jae    80312b <insert_sorted_with_merge_freeList+0x5a2>
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	8b 50 08             	mov    0x8(%eax),%edx
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	8b 40 0c             	mov    0xc(%eax),%eax
  80307f:	01 c2                	add    %eax,%edx
  803081:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803084:	8b 40 08             	mov    0x8(%eax),%eax
  803087:	39 c2                	cmp    %eax,%edx
  803089:	0f 85 9c 00 00 00    	jne    80312b <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  80308f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803092:	8b 50 0c             	mov    0xc(%eax),%edx
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 40 0c             	mov    0xc(%eax),%eax
  80309b:	01 c2                	add    %eax,%edx
  80309d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a0:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	8b 50 08             	mov    0x8(%eax),%edx
  8030a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ac:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c7:	75 17                	jne    8030e0 <insert_sorted_with_merge_freeList+0x557>
  8030c9:	83 ec 04             	sub    $0x4,%esp
  8030cc:	68 74 41 80 00       	push   $0x804174
  8030d1:	68 67 01 00 00       	push   $0x167
  8030d6:	68 97 41 80 00       	push   $0x804197
  8030db:	e8 cf d4 ff ff       	call   8005af <_panic>
  8030e0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 0d                	je     803101 <insert_sorted_with_merge_freeList+0x578>
  8030f4:	a1 48 51 80 00       	mov    0x805148,%eax
  8030f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fc:	89 50 04             	mov    %edx,0x4(%eax)
  8030ff:	eb 08                	jmp    803109 <insert_sorted_with_merge_freeList+0x580>
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	a3 48 51 80 00       	mov    %eax,0x805148
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311b:	a1 54 51 80 00       	mov    0x805154,%eax
  803120:	40                   	inc    %eax
  803121:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803126:	e9 a4 01 00 00       	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	8b 50 08             	mov    0x8(%eax),%edx
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	8b 40 0c             	mov    0xc(%eax),%eax
  803137:	01 c2                	add    %eax,%edx
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 40 08             	mov    0x8(%eax),%eax
  80313f:	39 c2                	cmp    %eax,%edx
  803141:	0f 85 ac 00 00 00    	jne    8031f3 <insert_sorted_with_merge_freeList+0x66a>
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	8b 50 08             	mov    0x8(%eax),%edx
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	8b 40 0c             	mov    0xc(%eax),%eax
  803153:	01 c2                	add    %eax,%edx
  803155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803158:	8b 40 08             	mov    0x8(%eax),%eax
  80315b:	39 c2                	cmp    %eax,%edx
  80315d:	0f 83 90 00 00 00    	jae    8031f3 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  803163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803166:	8b 50 0c             	mov    0xc(%eax),%edx
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	8b 40 0c             	mov    0xc(%eax),%eax
  80316f:	01 c2                	add    %eax,%edx
  803171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803174:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80318b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318f:	75 17                	jne    8031a8 <insert_sorted_with_merge_freeList+0x61f>
  803191:	83 ec 04             	sub    $0x4,%esp
  803194:	68 74 41 80 00       	push   $0x804174
  803199:	68 70 01 00 00       	push   $0x170
  80319e:	68 97 41 80 00       	push   $0x804197
  8031a3:	e8 07 d4 ff ff       	call   8005af <_panic>
  8031a8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	89 10                	mov    %edx,(%eax)
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	8b 00                	mov    (%eax),%eax
  8031b8:	85 c0                	test   %eax,%eax
  8031ba:	74 0d                	je     8031c9 <insert_sorted_with_merge_freeList+0x640>
  8031bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c4:	89 50 04             	mov    %edx,0x4(%eax)
  8031c7:	eb 08                	jmp    8031d1 <insert_sorted_with_merge_freeList+0x648>
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8031e8:	40                   	inc    %eax
  8031e9:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  8031ee:	e9 dc 00 00 00       	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 50 08             	mov    0x8(%eax),%edx
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ff:	01 c2                	add    %eax,%edx
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	8b 40 08             	mov    0x8(%eax),%eax
  803207:	39 c2                	cmp    %eax,%edx
  803209:	0f 83 88 00 00 00    	jae    803297 <insert_sorted_with_merge_freeList+0x70e>
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	8b 50 08             	mov    0x8(%eax),%edx
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	8b 40 0c             	mov    0xc(%eax),%eax
  80321b:	01 c2                	add    %eax,%edx
  80321d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803220:	8b 40 08             	mov    0x8(%eax),%eax
  803223:	39 c2                	cmp    %eax,%edx
  803225:	73 70                	jae    803297 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322b:	74 06                	je     803233 <insert_sorted_with_merge_freeList+0x6aa>
  80322d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803231:	75 17                	jne    80324a <insert_sorted_with_merge_freeList+0x6c1>
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	68 d4 41 80 00       	push   $0x8041d4
  80323b:	68 75 01 00 00       	push   $0x175
  803240:	68 97 41 80 00       	push   $0x804197
  803245:	e8 65 d3 ff ff       	call   8005af <_panic>
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	8b 10                	mov    (%eax),%edx
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	89 10                	mov    %edx,(%eax)
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	8b 00                	mov    (%eax),%eax
  803259:	85 c0                	test   %eax,%eax
  80325b:	74 0b                	je     803268 <insert_sorted_with_merge_freeList+0x6df>
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	8b 00                	mov    (%eax),%eax
  803262:	8b 55 08             	mov    0x8(%ebp),%edx
  803265:	89 50 04             	mov    %edx,0x4(%eax)
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	8b 55 08             	mov    0x8(%ebp),%edx
  80326e:	89 10                	mov    %edx,(%eax)
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803276:	89 50 04             	mov    %edx,0x4(%eax)
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	75 08                	jne    80328a <insert_sorted_with_merge_freeList+0x701>
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80328a:	a1 44 51 80 00       	mov    0x805144,%eax
  80328f:	40                   	inc    %eax
  803290:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803295:	eb 38                	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803297:	a1 40 51 80 00       	mov    0x805140,%eax
  80329c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80329f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a3:	74 07                	je     8032ac <insert_sorted_with_merge_freeList+0x723>
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	8b 00                	mov    (%eax),%eax
  8032aa:	eb 05                	jmp    8032b1 <insert_sorted_with_merge_freeList+0x728>
  8032ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8032b1:	a3 40 51 80 00       	mov    %eax,0x805140
  8032b6:	a1 40 51 80 00       	mov    0x805140,%eax
  8032bb:	85 c0                	test   %eax,%eax
  8032bd:	0f 85 c3 fb ff ff    	jne    802e86 <insert_sorted_with_merge_freeList+0x2fd>
  8032c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c7:	0f 85 b9 fb ff ff    	jne    802e86 <insert_sorted_with_merge_freeList+0x2fd>





}
  8032cd:	eb 00                	jmp    8032cf <insert_sorted_with_merge_freeList+0x746>
  8032cf:	90                   	nop
  8032d0:	c9                   	leave  
  8032d1:	c3                   	ret    

008032d2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032d2:	55                   	push   %ebp
  8032d3:	89 e5                	mov    %esp,%ebp
  8032d5:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032db:	89 d0                	mov    %edx,%eax
  8032dd:	c1 e0 02             	shl    $0x2,%eax
  8032e0:	01 d0                	add    %edx,%eax
  8032e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032e9:	01 d0                	add    %edx,%eax
  8032eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032f2:	01 d0                	add    %edx,%eax
  8032f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032fb:	01 d0                	add    %edx,%eax
  8032fd:	c1 e0 04             	shl    $0x4,%eax
  803300:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803303:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80330a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80330d:	83 ec 0c             	sub    $0xc,%esp
  803310:	50                   	push   %eax
  803311:	e8 31 ec ff ff       	call   801f47 <sys_get_virtual_time>
  803316:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803319:	eb 41                	jmp    80335c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80331b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80331e:	83 ec 0c             	sub    $0xc,%esp
  803321:	50                   	push   %eax
  803322:	e8 20 ec ff ff       	call   801f47 <sys_get_virtual_time>
  803327:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80332a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80332d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803330:	29 c2                	sub    %eax,%edx
  803332:	89 d0                	mov    %edx,%eax
  803334:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803337:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80333d:	89 d1                	mov    %edx,%ecx
  80333f:	29 c1                	sub    %eax,%ecx
  803341:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803344:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803347:	39 c2                	cmp    %eax,%edx
  803349:	0f 97 c0             	seta   %al
  80334c:	0f b6 c0             	movzbl %al,%eax
  80334f:	29 c1                	sub    %eax,%ecx
  803351:	89 c8                	mov    %ecx,%eax
  803353:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803356:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803359:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80335c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803362:	72 b7                	jb     80331b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803364:	90                   	nop
  803365:	c9                   	leave  
  803366:	c3                   	ret    

00803367 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803367:	55                   	push   %ebp
  803368:	89 e5                	mov    %esp,%ebp
  80336a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80336d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803374:	eb 03                	jmp    803379 <busy_wait+0x12>
  803376:	ff 45 fc             	incl   -0x4(%ebp)
  803379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80337c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80337f:	72 f5                	jb     803376 <busy_wait+0xf>
	return i;
  803381:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803384:	c9                   	leave  
  803385:	c3                   	ret    
  803386:	66 90                	xchg   %ax,%ax

00803388 <__udivdi3>:
  803388:	55                   	push   %ebp
  803389:	57                   	push   %edi
  80338a:	56                   	push   %esi
  80338b:	53                   	push   %ebx
  80338c:	83 ec 1c             	sub    $0x1c,%esp
  80338f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803393:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803397:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80339b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80339f:	89 ca                	mov    %ecx,%edx
  8033a1:	89 f8                	mov    %edi,%eax
  8033a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033a7:	85 f6                	test   %esi,%esi
  8033a9:	75 2d                	jne    8033d8 <__udivdi3+0x50>
  8033ab:	39 cf                	cmp    %ecx,%edi
  8033ad:	77 65                	ja     803414 <__udivdi3+0x8c>
  8033af:	89 fd                	mov    %edi,%ebp
  8033b1:	85 ff                	test   %edi,%edi
  8033b3:	75 0b                	jne    8033c0 <__udivdi3+0x38>
  8033b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ba:	31 d2                	xor    %edx,%edx
  8033bc:	f7 f7                	div    %edi
  8033be:	89 c5                	mov    %eax,%ebp
  8033c0:	31 d2                	xor    %edx,%edx
  8033c2:	89 c8                	mov    %ecx,%eax
  8033c4:	f7 f5                	div    %ebp
  8033c6:	89 c1                	mov    %eax,%ecx
  8033c8:	89 d8                	mov    %ebx,%eax
  8033ca:	f7 f5                	div    %ebp
  8033cc:	89 cf                	mov    %ecx,%edi
  8033ce:	89 fa                	mov    %edi,%edx
  8033d0:	83 c4 1c             	add    $0x1c,%esp
  8033d3:	5b                   	pop    %ebx
  8033d4:	5e                   	pop    %esi
  8033d5:	5f                   	pop    %edi
  8033d6:	5d                   	pop    %ebp
  8033d7:	c3                   	ret    
  8033d8:	39 ce                	cmp    %ecx,%esi
  8033da:	77 28                	ja     803404 <__udivdi3+0x7c>
  8033dc:	0f bd fe             	bsr    %esi,%edi
  8033df:	83 f7 1f             	xor    $0x1f,%edi
  8033e2:	75 40                	jne    803424 <__udivdi3+0x9c>
  8033e4:	39 ce                	cmp    %ecx,%esi
  8033e6:	72 0a                	jb     8033f2 <__udivdi3+0x6a>
  8033e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033ec:	0f 87 9e 00 00 00    	ja     803490 <__udivdi3+0x108>
  8033f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033f7:	89 fa                	mov    %edi,%edx
  8033f9:	83 c4 1c             	add    $0x1c,%esp
  8033fc:	5b                   	pop    %ebx
  8033fd:	5e                   	pop    %esi
  8033fe:	5f                   	pop    %edi
  8033ff:	5d                   	pop    %ebp
  803400:	c3                   	ret    
  803401:	8d 76 00             	lea    0x0(%esi),%esi
  803404:	31 ff                	xor    %edi,%edi
  803406:	31 c0                	xor    %eax,%eax
  803408:	89 fa                	mov    %edi,%edx
  80340a:	83 c4 1c             	add    $0x1c,%esp
  80340d:	5b                   	pop    %ebx
  80340e:	5e                   	pop    %esi
  80340f:	5f                   	pop    %edi
  803410:	5d                   	pop    %ebp
  803411:	c3                   	ret    
  803412:	66 90                	xchg   %ax,%ax
  803414:	89 d8                	mov    %ebx,%eax
  803416:	f7 f7                	div    %edi
  803418:	31 ff                	xor    %edi,%edi
  80341a:	89 fa                	mov    %edi,%edx
  80341c:	83 c4 1c             	add    $0x1c,%esp
  80341f:	5b                   	pop    %ebx
  803420:	5e                   	pop    %esi
  803421:	5f                   	pop    %edi
  803422:	5d                   	pop    %ebp
  803423:	c3                   	ret    
  803424:	bd 20 00 00 00       	mov    $0x20,%ebp
  803429:	89 eb                	mov    %ebp,%ebx
  80342b:	29 fb                	sub    %edi,%ebx
  80342d:	89 f9                	mov    %edi,%ecx
  80342f:	d3 e6                	shl    %cl,%esi
  803431:	89 c5                	mov    %eax,%ebp
  803433:	88 d9                	mov    %bl,%cl
  803435:	d3 ed                	shr    %cl,%ebp
  803437:	89 e9                	mov    %ebp,%ecx
  803439:	09 f1                	or     %esi,%ecx
  80343b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80343f:	89 f9                	mov    %edi,%ecx
  803441:	d3 e0                	shl    %cl,%eax
  803443:	89 c5                	mov    %eax,%ebp
  803445:	89 d6                	mov    %edx,%esi
  803447:	88 d9                	mov    %bl,%cl
  803449:	d3 ee                	shr    %cl,%esi
  80344b:	89 f9                	mov    %edi,%ecx
  80344d:	d3 e2                	shl    %cl,%edx
  80344f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803453:	88 d9                	mov    %bl,%cl
  803455:	d3 e8                	shr    %cl,%eax
  803457:	09 c2                	or     %eax,%edx
  803459:	89 d0                	mov    %edx,%eax
  80345b:	89 f2                	mov    %esi,%edx
  80345d:	f7 74 24 0c          	divl   0xc(%esp)
  803461:	89 d6                	mov    %edx,%esi
  803463:	89 c3                	mov    %eax,%ebx
  803465:	f7 e5                	mul    %ebp
  803467:	39 d6                	cmp    %edx,%esi
  803469:	72 19                	jb     803484 <__udivdi3+0xfc>
  80346b:	74 0b                	je     803478 <__udivdi3+0xf0>
  80346d:	89 d8                	mov    %ebx,%eax
  80346f:	31 ff                	xor    %edi,%edi
  803471:	e9 58 ff ff ff       	jmp    8033ce <__udivdi3+0x46>
  803476:	66 90                	xchg   %ax,%ax
  803478:	8b 54 24 08          	mov    0x8(%esp),%edx
  80347c:	89 f9                	mov    %edi,%ecx
  80347e:	d3 e2                	shl    %cl,%edx
  803480:	39 c2                	cmp    %eax,%edx
  803482:	73 e9                	jae    80346d <__udivdi3+0xe5>
  803484:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803487:	31 ff                	xor    %edi,%edi
  803489:	e9 40 ff ff ff       	jmp    8033ce <__udivdi3+0x46>
  80348e:	66 90                	xchg   %ax,%ax
  803490:	31 c0                	xor    %eax,%eax
  803492:	e9 37 ff ff ff       	jmp    8033ce <__udivdi3+0x46>
  803497:	90                   	nop

00803498 <__umoddi3>:
  803498:	55                   	push   %ebp
  803499:	57                   	push   %edi
  80349a:	56                   	push   %esi
  80349b:	53                   	push   %ebx
  80349c:	83 ec 1c             	sub    $0x1c,%esp
  80349f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034b7:	89 f3                	mov    %esi,%ebx
  8034b9:	89 fa                	mov    %edi,%edx
  8034bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034bf:	89 34 24             	mov    %esi,(%esp)
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	75 1a                	jne    8034e0 <__umoddi3+0x48>
  8034c6:	39 f7                	cmp    %esi,%edi
  8034c8:	0f 86 a2 00 00 00    	jbe    803570 <__umoddi3+0xd8>
  8034ce:	89 c8                	mov    %ecx,%eax
  8034d0:	89 f2                	mov    %esi,%edx
  8034d2:	f7 f7                	div    %edi
  8034d4:	89 d0                	mov    %edx,%eax
  8034d6:	31 d2                	xor    %edx,%edx
  8034d8:	83 c4 1c             	add    $0x1c,%esp
  8034db:	5b                   	pop    %ebx
  8034dc:	5e                   	pop    %esi
  8034dd:	5f                   	pop    %edi
  8034de:	5d                   	pop    %ebp
  8034df:	c3                   	ret    
  8034e0:	39 f0                	cmp    %esi,%eax
  8034e2:	0f 87 ac 00 00 00    	ja     803594 <__umoddi3+0xfc>
  8034e8:	0f bd e8             	bsr    %eax,%ebp
  8034eb:	83 f5 1f             	xor    $0x1f,%ebp
  8034ee:	0f 84 ac 00 00 00    	je     8035a0 <__umoddi3+0x108>
  8034f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8034f9:	29 ef                	sub    %ebp,%edi
  8034fb:	89 fe                	mov    %edi,%esi
  8034fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803501:	89 e9                	mov    %ebp,%ecx
  803503:	d3 e0                	shl    %cl,%eax
  803505:	89 d7                	mov    %edx,%edi
  803507:	89 f1                	mov    %esi,%ecx
  803509:	d3 ef                	shr    %cl,%edi
  80350b:	09 c7                	or     %eax,%edi
  80350d:	89 e9                	mov    %ebp,%ecx
  80350f:	d3 e2                	shl    %cl,%edx
  803511:	89 14 24             	mov    %edx,(%esp)
  803514:	89 d8                	mov    %ebx,%eax
  803516:	d3 e0                	shl    %cl,%eax
  803518:	89 c2                	mov    %eax,%edx
  80351a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80351e:	d3 e0                	shl    %cl,%eax
  803520:	89 44 24 04          	mov    %eax,0x4(%esp)
  803524:	8b 44 24 08          	mov    0x8(%esp),%eax
  803528:	89 f1                	mov    %esi,%ecx
  80352a:	d3 e8                	shr    %cl,%eax
  80352c:	09 d0                	or     %edx,%eax
  80352e:	d3 eb                	shr    %cl,%ebx
  803530:	89 da                	mov    %ebx,%edx
  803532:	f7 f7                	div    %edi
  803534:	89 d3                	mov    %edx,%ebx
  803536:	f7 24 24             	mull   (%esp)
  803539:	89 c6                	mov    %eax,%esi
  80353b:	89 d1                	mov    %edx,%ecx
  80353d:	39 d3                	cmp    %edx,%ebx
  80353f:	0f 82 87 00 00 00    	jb     8035cc <__umoddi3+0x134>
  803545:	0f 84 91 00 00 00    	je     8035dc <__umoddi3+0x144>
  80354b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80354f:	29 f2                	sub    %esi,%edx
  803551:	19 cb                	sbb    %ecx,%ebx
  803553:	89 d8                	mov    %ebx,%eax
  803555:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803559:	d3 e0                	shl    %cl,%eax
  80355b:	89 e9                	mov    %ebp,%ecx
  80355d:	d3 ea                	shr    %cl,%edx
  80355f:	09 d0                	or     %edx,%eax
  803561:	89 e9                	mov    %ebp,%ecx
  803563:	d3 eb                	shr    %cl,%ebx
  803565:	89 da                	mov    %ebx,%edx
  803567:	83 c4 1c             	add    $0x1c,%esp
  80356a:	5b                   	pop    %ebx
  80356b:	5e                   	pop    %esi
  80356c:	5f                   	pop    %edi
  80356d:	5d                   	pop    %ebp
  80356e:	c3                   	ret    
  80356f:	90                   	nop
  803570:	89 fd                	mov    %edi,%ebp
  803572:	85 ff                	test   %edi,%edi
  803574:	75 0b                	jne    803581 <__umoddi3+0xe9>
  803576:	b8 01 00 00 00       	mov    $0x1,%eax
  80357b:	31 d2                	xor    %edx,%edx
  80357d:	f7 f7                	div    %edi
  80357f:	89 c5                	mov    %eax,%ebp
  803581:	89 f0                	mov    %esi,%eax
  803583:	31 d2                	xor    %edx,%edx
  803585:	f7 f5                	div    %ebp
  803587:	89 c8                	mov    %ecx,%eax
  803589:	f7 f5                	div    %ebp
  80358b:	89 d0                	mov    %edx,%eax
  80358d:	e9 44 ff ff ff       	jmp    8034d6 <__umoddi3+0x3e>
  803592:	66 90                	xchg   %ax,%ax
  803594:	89 c8                	mov    %ecx,%eax
  803596:	89 f2                	mov    %esi,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	3b 04 24             	cmp    (%esp),%eax
  8035a3:	72 06                	jb     8035ab <__umoddi3+0x113>
  8035a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035a9:	77 0f                	ja     8035ba <__umoddi3+0x122>
  8035ab:	89 f2                	mov    %esi,%edx
  8035ad:	29 f9                	sub    %edi,%ecx
  8035af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035b3:	89 14 24             	mov    %edx,(%esp)
  8035b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035be:	8b 14 24             	mov    (%esp),%edx
  8035c1:	83 c4 1c             	add    $0x1c,%esp
  8035c4:	5b                   	pop    %ebx
  8035c5:	5e                   	pop    %esi
  8035c6:	5f                   	pop    %edi
  8035c7:	5d                   	pop    %ebp
  8035c8:	c3                   	ret    
  8035c9:	8d 76 00             	lea    0x0(%esi),%esi
  8035cc:	2b 04 24             	sub    (%esp),%eax
  8035cf:	19 fa                	sbb    %edi,%edx
  8035d1:	89 d1                	mov    %edx,%ecx
  8035d3:	89 c6                	mov    %eax,%esi
  8035d5:	e9 71 ff ff ff       	jmp    80354b <__umoddi3+0xb3>
  8035da:	66 90                	xchg   %ax,%ax
  8035dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035e0:	72 ea                	jb     8035cc <__umoddi3+0x134>
  8035e2:	89 d9                	mov    %ebx,%ecx
  8035e4:	e9 62 ff ff ff       	jmp    80354b <__umoddi3+0xb3>
