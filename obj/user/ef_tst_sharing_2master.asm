
obj/user/ef_tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 49 03 00 00       	call   80037f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the shared variables, initialize them and run slaves
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 34             	sub    $0x34,%esp
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
  80008d:	68 00 35 80 00       	push   $0x803500
  800092:	6a 13                	push   $0x13
  800094:	68 1c 35 80 00       	push   $0x80351c
  800099:	e8 1d 04 00 00       	call   8004bb <_panic>
	}
	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  80009e:	e8 84 1a 00 00       	call   801b27 <sys_calculate_free_frames>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 00                	push   $0x0
  8000ab:	6a 04                	push   $0x4
  8000ad:	68 3a 35 80 00       	push   $0x80353a
  8000b2:	e8 ad 17 00 00       	call   801864 <smalloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000bd:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000c4:	74 14                	je     8000da <_main+0xa2>
  8000c6:	83 ec 04             	sub    $0x4,%esp
  8000c9:	68 3c 35 80 00       	push   $0x80353c
  8000ce:	6a 1a                	push   $0x1a
  8000d0:	68 1c 35 80 00       	push   $0x80351c
  8000d5:	e8 e1 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000da:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000dd:	e8 45 1a 00 00       	call   801b27 <sys_calculate_free_frames>
  8000e2:	29 c3                	sub    %eax,%ebx
  8000e4:	89 d8                	mov    %ebx,%eax
  8000e6:	83 f8 04             	cmp    $0x4,%eax
  8000e9:	74 28                	je     800113 <_main+0xdb>
  8000eb:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ee:	e8 34 1a 00 00       	call   801b27 <sys_calculate_free_frames>
  8000f3:	29 c3                	sub    %eax,%ebx
  8000f5:	e8 2d 1a 00 00       	call   801b27 <sys_calculate_free_frames>
  8000fa:	83 ec 08             	sub    $0x8,%esp
  8000fd:	53                   	push   %ebx
  8000fe:	50                   	push   %eax
  8000ff:	ff 75 ec             	pushl  -0x14(%ebp)
  800102:	68 a0 35 80 00       	push   $0x8035a0
  800107:	6a 1b                	push   $0x1b
  800109:	68 1c 35 80 00       	push   $0x80351c
  80010e:	e8 a8 03 00 00       	call   8004bb <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  800113:	e8 0f 1a 00 00       	call   801b27 <sys_calculate_free_frames>
  800118:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  80011b:	83 ec 04             	sub    $0x4,%esp
  80011e:	6a 00                	push   $0x0
  800120:	6a 04                	push   $0x4
  800122:	68 31 36 80 00       	push   $0x803631
  800127:	e8 38 17 00 00       	call   801864 <smalloc>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800132:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 3c 35 80 00       	push   $0x80353c
  800143:	6a 20                	push   $0x20
  800145:	68 1c 35 80 00       	push   $0x80351c
  80014a:	e8 6c 03 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  80014f:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800152:	e8 d0 19 00 00       	call   801b27 <sys_calculate_free_frames>
  800157:	29 c3                	sub    %eax,%ebx
  800159:	89 d8                	mov    %ebx,%eax
  80015b:	83 f8 03             	cmp    $0x3,%eax
  80015e:	74 28                	je     800188 <_main+0x150>
  800160:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  800163:	e8 bf 19 00 00       	call   801b27 <sys_calculate_free_frames>
  800168:	29 c3                	sub    %eax,%ebx
  80016a:	e8 b8 19 00 00       	call   801b27 <sys_calculate_free_frames>
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	53                   	push   %ebx
  800173:	50                   	push   %eax
  800174:	ff 75 ec             	pushl  -0x14(%ebp)
  800177:	68 a0 35 80 00       	push   $0x8035a0
  80017c:	6a 21                	push   $0x21
  80017e:	68 1c 35 80 00       	push   $0x80351c
  800183:	e8 33 03 00 00       	call   8004bb <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  800188:	e8 9a 19 00 00       	call   801b27 <sys_calculate_free_frames>
  80018d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 01                	push   $0x1
  800195:	6a 04                	push   $0x4
  800197:	68 33 36 80 00       	push   $0x803633
  80019c:	e8 c3 16 00 00       	call   801864 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001a7:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  8001ae:	74 14                	je     8001c4 <_main+0x18c>
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	68 3c 35 80 00       	push   $0x80353c
  8001b8:	6a 26                	push   $0x26
  8001ba:	68 1c 35 80 00       	push   $0x80351c
  8001bf:	e8 f7 02 00 00       	call   8004bb <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001c4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001c7:	e8 5b 19 00 00       	call   801b27 <sys_calculate_free_frames>
  8001cc:	29 c3                	sub    %eax,%ebx
  8001ce:	89 d8                	mov    %ebx,%eax
  8001d0:	83 f8 03             	cmp    $0x3,%eax
  8001d3:	74 14                	je     8001e9 <_main+0x1b1>
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 38 36 80 00       	push   $0x803638
  8001dd:	6a 27                	push   $0x27
  8001df:	68 1c 35 80 00       	push   $0x80351c
  8001e4:	e8 d2 02 00 00       	call   8004bb <_panic>

	*x = 10 ;
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001f5:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8001fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800200:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800206:	89 c2                	mov    %eax,%edx
  800208:	a1 20 40 80 00       	mov    0x804020,%eax
  80020d:	8b 40 74             	mov    0x74(%eax),%eax
  800210:	6a 32                	push   $0x32
  800212:	52                   	push   %edx
  800213:	50                   	push   %eax
  800214:	68 c0 36 80 00       	push   $0x8036c0
  800219:	e8 7b 1b 00 00       	call   801d99 <sys_create_env>
  80021e:	83 c4 10             	add    $0x10,%esp
  800221:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80022f:	89 c2                	mov    %eax,%edx
  800231:	a1 20 40 80 00       	mov    0x804020,%eax
  800236:	8b 40 74             	mov    0x74(%eax),%eax
  800239:	6a 32                	push   $0x32
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 c0 36 80 00       	push   $0x8036c0
  800242:	e8 52 1b 00 00       	call   801d99 <sys_create_env>
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("ef_shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80024d:	a1 20 40 80 00       	mov    0x804020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	a1 20 40 80 00       	mov    0x804020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	6a 32                	push   $0x32
  800264:	52                   	push   %edx
  800265:	50                   	push   %eax
  800266:	68 c0 36 80 00       	push   $0x8036c0
  80026b:	e8 29 1b 00 00       	call   801d99 <sys_create_env>
  800270:	83 c4 10             	add    $0x10,%esp
  800273:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800276:	e8 6a 1c 00 00       	call   801ee5 <rsttst>

	int* finish_children = smalloc("finish_children", sizeof(int), 1);
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	6a 01                	push   $0x1
  800280:	6a 04                	push   $0x4
  800282:	68 ce 36 80 00       	push   $0x8036ce
  800287:	e8 d8 15 00 00       	call   801864 <smalloc>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	sys_run_env(id1);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	ff 75 dc             	pushl  -0x24(%ebp)
  800298:	e8 1a 1b 00 00       	call   801db7 <sys_run_env>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  8002a0:	83 ec 0c             	sub    $0xc,%esp
  8002a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002a6:	e8 0c 1b 00 00       	call   801db7 <sys_run_env>
  8002ab:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  8002ae:	83 ec 0c             	sub    $0xc,%esp
  8002b1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002b4:	e8 fe 1a 00 00       	call   801db7 <sys_run_env>
  8002b9:	83 c4 10             	add    $0x10,%esp

	env_sleep(15000) ;
  8002bc:	83 ec 0c             	sub    $0xc,%esp
  8002bf:	68 98 3a 00 00       	push   $0x3a98
  8002c4:	e8 15 2f 00 00       	call   8031de <env_sleep>
  8002c9:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002cc:	e8 8e 1c 00 00       	call   801f5f <gettst>
  8002d1:	83 f8 03             	cmp    $0x3,%eax
  8002d4:	74 14                	je     8002ea <_main+0x2b2>
  8002d6:	83 ec 04             	sub    $0x4,%esp
  8002d9:	68 de 36 80 00       	push   $0x8036de
  8002de:	6a 3d                	push   $0x3d
  8002e0:	68 1c 35 80 00       	push   $0x80351c
  8002e5:	e8 d1 01 00 00       	call   8004bb <_panic>


	if (*z != 30)
  8002ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ed:	8b 00                	mov    (%eax),%eax
  8002ef:	83 f8 1e             	cmp    $0x1e,%eax
  8002f2:	74 14                	je     800308 <_main+0x2d0>
		panic("Error!! Please check the creation (or the getting) of shared 2variables!!\n\n\n");
  8002f4:	83 ec 04             	sub    $0x4,%esp
  8002f7:	68 ec 36 80 00       	push   $0x8036ec
  8002fc:	6a 41                	push   $0x41
  8002fe:	68 1c 35 80 00       	push   $0x80351c
  800303:	e8 b3 01 00 00       	call   8004bb <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 3c 37 80 00       	push   $0x80373c
  800310:	e8 5a 04 00 00       	call   80076f <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp


	if (sys_getparentenvid() > 0) {
  800318:	e8 03 1b 00 00       	call   801e20 <sys_getparentenvid>
  80031d:	85 c0                	test   %eax,%eax
  80031f:	7e 58                	jle    800379 <_main+0x341>
		sys_destroy_env(id1);
  800321:	83 ec 0c             	sub    $0xc,%esp
  800324:	ff 75 dc             	pushl  -0x24(%ebp)
  800327:	e8 a7 1a 00 00       	call   801dd3 <sys_destroy_env>
  80032c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  80032f:	83 ec 0c             	sub    $0xc,%esp
  800332:	ff 75 d8             	pushl  -0x28(%ebp)
  800335:	e8 99 1a 00 00       	call   801dd3 <sys_destroy_env>
  80033a:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	ff 75 d4             	pushl  -0x2c(%ebp)
  800343:	e8 8b 1a 00 00       	call   801dd3 <sys_destroy_env>
  800348:	83 c4 10             	add    $0x10,%esp
		int *finishedCount = NULL;
  80034b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800352:	e8 c9 1a 00 00       	call   801e20 <sys_getparentenvid>
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	68 96 37 80 00       	push   $0x803796
  80035f:	50                   	push   %eax
  800360:	e8 9d 15 00 00       	call   801902 <sget>
  800365:	83 c4 10             	add    $0x10,%esp
  800368:	89 45 cc             	mov    %eax,-0x34(%ebp)
		(*finishedCount)++ ;
  80036b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	8d 50 01             	lea    0x1(%eax),%edx
  800373:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800376:	89 10                	mov    %edx,(%eax)
	}
	return;
  800378:	90                   	nop
  800379:	90                   	nop
}
  80037a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800385:	e8 7d 1a 00 00       	call   801e07 <sys_getenvindex>
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80038d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800390:	89 d0                	mov    %edx,%eax
  800392:	c1 e0 03             	shl    $0x3,%eax
  800395:	01 d0                	add    %edx,%eax
  800397:	01 c0                	add    %eax,%eax
  800399:	01 d0                	add    %edx,%eax
  80039b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a2:	01 d0                	add    %edx,%eax
  8003a4:	c1 e0 04             	shl    $0x4,%eax
  8003a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003ac:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003bc:	84 c0                	test   %al,%al
  8003be:	74 0f                	je     8003cf <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c5:	05 5c 05 00 00       	add    $0x55c,%eax
  8003ca:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003d3:	7e 0a                	jle    8003df <libmain+0x60>
		binaryname = argv[0];
  8003d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 0c             	pushl  0xc(%ebp)
  8003e5:	ff 75 08             	pushl  0x8(%ebp)
  8003e8:	e8 4b fc ff ff       	call   800038 <_main>
  8003ed:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003f0:	e8 1f 18 00 00       	call   801c14 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003f5:	83 ec 0c             	sub    $0xc,%esp
  8003f8:	68 bc 37 80 00       	push   $0x8037bc
  8003fd:	e8 6d 03 00 00       	call   80076f <cprintf>
  800402:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800405:	a1 20 40 80 00       	mov    0x804020,%eax
  80040a:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	52                   	push   %edx
  80041f:	50                   	push   %eax
  800420:	68 e4 37 80 00       	push   $0x8037e4
  800425:	e8 45 03 00 00       	call   80076f <cprintf>
  80042a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800438:	a1 20 40 80 00       	mov    0x804020,%eax
  80043d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800443:	a1 20 40 80 00       	mov    0x804020,%eax
  800448:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80044e:	51                   	push   %ecx
  80044f:	52                   	push   %edx
  800450:	50                   	push   %eax
  800451:	68 0c 38 80 00       	push   $0x80380c
  800456:	e8 14 03 00 00       	call   80076f <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	50                   	push   %eax
  80046d:	68 64 38 80 00       	push   $0x803864
  800472:	e8 f8 02 00 00       	call   80076f <cprintf>
  800477:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80047a:	83 ec 0c             	sub    $0xc,%esp
  80047d:	68 bc 37 80 00       	push   $0x8037bc
  800482:	e8 e8 02 00 00       	call   80076f <cprintf>
  800487:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80048a:	e8 9f 17 00 00       	call   801c2e <sys_enable_interrupt>

	// exit gracefully
	exit();
  80048f:	e8 19 00 00 00       	call   8004ad <exit>
}
  800494:	90                   	nop
  800495:	c9                   	leave  
  800496:	c3                   	ret    

00800497 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
  80049a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80049d:	83 ec 0c             	sub    $0xc,%esp
  8004a0:	6a 00                	push   $0x0
  8004a2:	e8 2c 19 00 00       	call   801dd3 <sys_destroy_env>
  8004a7:	83 c4 10             	add    $0x10,%esp
}
  8004aa:	90                   	nop
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    

008004ad <exit>:

void
exit(void)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004b3:	e8 81 19 00 00       	call   801e39 <sys_exit_env>
}
  8004b8:	90                   	nop
  8004b9:	c9                   	leave  
  8004ba:	c3                   	ret    

008004bb <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8004c4:	83 c0 04             	add    $0x4,%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004ca:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	74 16                	je     8004e9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004d3:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	50                   	push   %eax
  8004dc:	68 78 38 80 00       	push   $0x803878
  8004e1:	e8 89 02 00 00       	call   80076f <cprintf>
  8004e6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e9:	a1 00 40 80 00       	mov    0x804000,%eax
  8004ee:	ff 75 0c             	pushl  0xc(%ebp)
  8004f1:	ff 75 08             	pushl  0x8(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	68 7d 38 80 00       	push   $0x80387d
  8004fa:	e8 70 02 00 00       	call   80076f <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800502:	8b 45 10             	mov    0x10(%ebp),%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	ff 75 f4             	pushl  -0xc(%ebp)
  80050b:	50                   	push   %eax
  80050c:	e8 f3 01 00 00       	call   800704 <vcprintf>
  800511:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	6a 00                	push   $0x0
  800519:	68 99 38 80 00       	push   $0x803899
  80051e:	e8 e1 01 00 00       	call   800704 <vcprintf>
  800523:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800526:	e8 82 ff ff ff       	call   8004ad <exit>

	// should not return here
	while (1) ;
  80052b:	eb fe                	jmp    80052b <_panic+0x70>

0080052d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800533:	a1 20 40 80 00       	mov    0x804020,%eax
  800538:	8b 50 74             	mov    0x74(%eax),%edx
  80053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053e:	39 c2                	cmp    %eax,%edx
  800540:	74 14                	je     800556 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 9c 38 80 00       	push   $0x80389c
  80054a:	6a 26                	push   $0x26
  80054c:	68 e8 38 80 00       	push   $0x8038e8
  800551:	e8 65 ff ff ff       	call   8004bb <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800556:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80055d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800564:	e9 c2 00 00 00       	jmp    80062b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800573:	8b 45 08             	mov    0x8(%ebp),%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	8b 00                	mov    (%eax),%eax
  80057a:	85 c0                	test   %eax,%eax
  80057c:	75 08                	jne    800586 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80057e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800581:	e9 a2 00 00 00       	jmp    800628 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800586:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80058d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800594:	eb 69                	jmp    8005ff <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800596:	a1 20 40 80 00       	mov    0x804020,%eax
  80059b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	01 c0                	add    %eax,%eax
  8005a8:	01 d0                	add    %edx,%eax
  8005aa:	c1 e0 03             	shl    $0x3,%eax
  8005ad:	01 c8                	add    %ecx,%eax
  8005af:	8a 40 04             	mov    0x4(%eax),%al
  8005b2:	84 c0                	test   %al,%al
  8005b4:	75 46                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005bb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005c4:	89 d0                	mov    %edx,%eax
  8005c6:	01 c0                	add    %eax,%eax
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 03             	shl    $0x3,%eax
  8005cd:	01 c8                	add    %ecx,%eax
  8005cf:	8b 00                	mov    (%eax),%eax
  8005d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005dc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005e1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005eb:	01 c8                	add    %ecx,%eax
  8005ed:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ef:	39 c2                	cmp    %eax,%edx
  8005f1:	75 09                	jne    8005fc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005f3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005fa:	eb 12                	jmp    80060e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005fc:	ff 45 e8             	incl   -0x18(%ebp)
  8005ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800604:	8b 50 74             	mov    0x74(%eax),%edx
  800607:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	77 88                	ja     800596 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80060e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800612:	75 14                	jne    800628 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	68 f4 38 80 00       	push   $0x8038f4
  80061c:	6a 3a                	push   $0x3a
  80061e:	68 e8 38 80 00       	push   $0x8038e8
  800623:	e8 93 fe ff ff       	call   8004bb <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800628:	ff 45 f0             	incl   -0x10(%ebp)
  80062b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800631:	0f 8c 32 ff ff ff    	jl     800569 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800637:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80063e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800645:	eb 26                	jmp    80066d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800647:	a1 20 40 80 00       	mov    0x804020,%eax
  80064c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800652:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	01 c0                	add    %eax,%eax
  800659:	01 d0                	add    %edx,%eax
  80065b:	c1 e0 03             	shl    $0x3,%eax
  80065e:	01 c8                	add    %ecx,%eax
  800660:	8a 40 04             	mov    0x4(%eax),%al
  800663:	3c 01                	cmp    $0x1,%al
  800665:	75 03                	jne    80066a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800667:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066a:	ff 45 e0             	incl   -0x20(%ebp)
  80066d:	a1 20 40 80 00       	mov    0x804020,%eax
  800672:	8b 50 74             	mov    0x74(%eax),%edx
  800675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800678:	39 c2                	cmp    %eax,%edx
  80067a:	77 cb                	ja     800647 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80067c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800682:	74 14                	je     800698 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800684:	83 ec 04             	sub    $0x4,%esp
  800687:	68 48 39 80 00       	push   $0x803948
  80068c:	6a 44                	push   $0x44
  80068e:	68 e8 38 80 00       	push   $0x8038e8
  800693:	e8 23 fe ff ff       	call   8004bb <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800698:	90                   	nop
  800699:	c9                   	leave  
  80069a:	c3                   	ret    

0080069b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80069b:	55                   	push   %ebp
  80069c:	89 e5                	mov    %esp,%ebp
  80069e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ac:	89 0a                	mov    %ecx,(%edx)
  8006ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b1:	88 d1                	mov    %dl,%cl
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006c4:	75 2c                	jne    8006f2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006c6:	a0 24 40 80 00       	mov    0x804024,%al
  8006cb:	0f b6 c0             	movzbl %al,%eax
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	8b 12                	mov    (%edx),%edx
  8006d3:	89 d1                	mov    %edx,%ecx
  8006d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d8:	83 c2 08             	add    $0x8,%edx
  8006db:	83 ec 04             	sub    $0x4,%esp
  8006de:	50                   	push   %eax
  8006df:	51                   	push   %ecx
  8006e0:	52                   	push   %edx
  8006e1:	e8 80 13 00 00       	call   801a66 <sys_cputs>
  8006e6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f5:	8b 40 04             	mov    0x4(%eax),%eax
  8006f8:	8d 50 01             	lea    0x1(%eax),%edx
  8006fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006fe:	89 50 04             	mov    %edx,0x4(%eax)
}
  800701:	90                   	nop
  800702:	c9                   	leave  
  800703:	c3                   	ret    

00800704 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80070d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800714:	00 00 00 
	b.cnt = 0;
  800717:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80071e:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	ff 75 08             	pushl  0x8(%ebp)
  800727:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	68 9b 06 80 00       	push   $0x80069b
  800733:	e8 11 02 00 00       	call   800949 <vprintfmt>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80073b:	a0 24 40 80 00       	mov    0x804024,%al
  800740:	0f b6 c0             	movzbl %al,%eax
  800743:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	50                   	push   %eax
  80074d:	52                   	push   %edx
  80074e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800754:	83 c0 08             	add    $0x8,%eax
  800757:	50                   	push   %eax
  800758:	e8 09 13 00 00       	call   801a66 <sys_cputs>
  80075d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800760:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800767:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80076d:	c9                   	leave  
  80076e:	c3                   	ret    

0080076f <cprintf>:

int cprintf(const char *fmt, ...) {
  80076f:	55                   	push   %ebp
  800770:	89 e5                	mov    %esp,%ebp
  800772:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800775:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80077c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80077f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	83 ec 08             	sub    $0x8,%esp
  800788:	ff 75 f4             	pushl  -0xc(%ebp)
  80078b:	50                   	push   %eax
  80078c:	e8 73 ff ff ff       	call   800704 <vcprintf>
  800791:	83 c4 10             	add    $0x10,%esp
  800794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a2:	e8 6d 14 00 00       	call   801c14 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	83 ec 08             	sub    $0x8,%esp
  8007b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b6:	50                   	push   %eax
  8007b7:	e8 48 ff ff ff       	call   800704 <vcprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
  8007bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007c2:	e8 67 14 00 00       	call   801c2e <sys_enable_interrupt>
	return cnt;
  8007c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007ca:	c9                   	leave  
  8007cb:	c3                   	ret    

008007cc <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
  8007cf:	53                   	push   %ebx
  8007d0:	83 ec 14             	sub    $0x14,%esp
  8007d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007df:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ea:	77 55                	ja     800841 <printnum+0x75>
  8007ec:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007ef:	72 05                	jb     8007f6 <printnum+0x2a>
  8007f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007f4:	77 4b                	ja     800841 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007f6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007fc:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800804:	52                   	push   %edx
  800805:	50                   	push   %eax
  800806:	ff 75 f4             	pushl  -0xc(%ebp)
  800809:	ff 75 f0             	pushl  -0x10(%ebp)
  80080c:	e8 83 2a 00 00       	call   803294 <__udivdi3>
  800811:	83 c4 10             	add    $0x10,%esp
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	ff 75 20             	pushl  0x20(%ebp)
  80081a:	53                   	push   %ebx
  80081b:	ff 75 18             	pushl  0x18(%ebp)
  80081e:	52                   	push   %edx
  80081f:	50                   	push   %eax
  800820:	ff 75 0c             	pushl  0xc(%ebp)
  800823:	ff 75 08             	pushl  0x8(%ebp)
  800826:	e8 a1 ff ff ff       	call   8007cc <printnum>
  80082b:	83 c4 20             	add    $0x20,%esp
  80082e:	eb 1a                	jmp    80084a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 20             	pushl  0x20(%ebp)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800841:	ff 4d 1c             	decl   0x1c(%ebp)
  800844:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800848:	7f e6                	jg     800830 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80084a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80084d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800858:	53                   	push   %ebx
  800859:	51                   	push   %ecx
  80085a:	52                   	push   %edx
  80085b:	50                   	push   %eax
  80085c:	e8 43 2b 00 00       	call   8033a4 <__umoddi3>
  800861:	83 c4 10             	add    $0x10,%esp
  800864:	05 b4 3b 80 00       	add    $0x803bb4,%eax
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f be c0             	movsbl %al,%eax
  80086e:	83 ec 08             	sub    $0x8,%esp
  800871:	ff 75 0c             	pushl  0xc(%ebp)
  800874:	50                   	push   %eax
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	ff d0                	call   *%eax
  80087a:	83 c4 10             	add    $0x10,%esp
}
  80087d:	90                   	nop
  80087e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800881:	c9                   	leave  
  800882:	c3                   	ret    

00800883 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800886:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80088a:	7e 1c                	jle    8008a8 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 08             	lea    0x8(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 08             	sub    $0x8,%eax
  8008a1:	8b 50 04             	mov    0x4(%eax),%edx
  8008a4:	8b 00                	mov    (%eax),%eax
  8008a6:	eb 40                	jmp    8008e8 <getuint+0x65>
	else if (lflag)
  8008a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ac:	74 1e                	je     8008cc <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	89 10                	mov    %edx,(%eax)
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	8b 00                	mov    (%eax),%eax
  8008c0:	83 e8 04             	sub    $0x4,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
  8008c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ca:	eb 1c                	jmp    8008e8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	8b 00                	mov    (%eax),%eax
  8008d1:	8d 50 04             	lea    0x4(%eax),%edx
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 10                	mov    %edx,(%eax)
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	83 e8 04             	sub    $0x4,%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008ed:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008f1:	7e 1c                	jle    80090f <getint+0x25>
		return va_arg(*ap, long long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 08             	lea    0x8(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 08             	sub    $0x8,%eax
  800908:	8b 50 04             	mov    0x4(%eax),%edx
  80090b:	8b 00                	mov    (%eax),%eax
  80090d:	eb 38                	jmp    800947 <getint+0x5d>
	else if (lflag)
  80090f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800913:	74 1a                	je     80092f <getint+0x45>
		return va_arg(*ap, long);
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	8d 50 04             	lea    0x4(%eax),%edx
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	89 10                	mov    %edx,(%eax)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	83 e8 04             	sub    $0x4,%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	99                   	cltd   
  80092d:	eb 18                	jmp    800947 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
}
  800947:	5d                   	pop    %ebp
  800948:	c3                   	ret    

00800949 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
  80094e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800951:	eb 17                	jmp    80096a <vprintfmt+0x21>
			if (ch == '\0')
  800953:	85 db                	test   %ebx,%ebx
  800955:	0f 84 af 03 00 00    	je     800d0a <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	53                   	push   %ebx
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	ff d0                	call   *%eax
  800967:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096a:	8b 45 10             	mov    0x10(%ebp),%eax
  80096d:	8d 50 01             	lea    0x1(%eax),%edx
  800970:	89 55 10             	mov    %edx,0x10(%ebp)
  800973:	8a 00                	mov    (%eax),%al
  800975:	0f b6 d8             	movzbl %al,%ebx
  800978:	83 fb 25             	cmp    $0x25,%ebx
  80097b:	75 d6                	jne    800953 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80097d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800981:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800988:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80098f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800996:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099d:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a0:	8d 50 01             	lea    0x1(%eax),%edx
  8009a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	0f b6 d8             	movzbl %al,%ebx
  8009ab:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009ae:	83 f8 55             	cmp    $0x55,%eax
  8009b1:	0f 87 2b 03 00 00    	ja     800ce2 <vprintfmt+0x399>
  8009b7:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
  8009be:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009c0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009c4:	eb d7                	jmp    80099d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009c6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009ca:	eb d1                	jmp    80099d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d6:	89 d0                	mov    %edx,%eax
  8009d8:	c1 e0 02             	shl    $0x2,%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	01 c0                	add    %eax,%eax
  8009df:	01 d8                	add    %ebx,%eax
  8009e1:	83 e8 30             	sub    $0x30,%eax
  8009e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	8a 00                	mov    (%eax),%al
  8009ec:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009ef:	83 fb 2f             	cmp    $0x2f,%ebx
  8009f2:	7e 3e                	jle    800a32 <vprintfmt+0xe9>
  8009f4:	83 fb 39             	cmp    $0x39,%ebx
  8009f7:	7f 39                	jg     800a32 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009fc:	eb d5                	jmp    8009d3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	83 c0 04             	add    $0x4,%eax
  800a04:	89 45 14             	mov    %eax,0x14(%ebp)
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	83 e8 04             	sub    $0x4,%eax
  800a0d:	8b 00                	mov    (%eax),%eax
  800a0f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a12:	eb 1f                	jmp    800a33 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a18:	79 83                	jns    80099d <vprintfmt+0x54>
				width = 0;
  800a1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a21:	e9 77 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a26:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a2d:	e9 6b ff ff ff       	jmp    80099d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a32:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a37:	0f 89 60 ff ff ff    	jns    80099d <vprintfmt+0x54>
				width = precision, precision = -1;
  800a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a43:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a4a:	e9 4e ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a4f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a52:	e9 46 ff ff ff       	jmp    80099d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	83 c0 04             	add    $0x4,%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 e8 04             	sub    $0x4,%eax
  800a66:	8b 00                	mov    (%eax),%eax
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	ff 75 0c             	pushl  0xc(%ebp)
  800a6e:	50                   	push   %eax
  800a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a72:	ff d0                	call   *%eax
  800a74:	83 c4 10             	add    $0x10,%esp
			break;
  800a77:	e9 89 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a8d:	85 db                	test   %ebx,%ebx
  800a8f:	79 02                	jns    800a93 <vprintfmt+0x14a>
				err = -err;
  800a91:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a93:	83 fb 64             	cmp    $0x64,%ebx
  800a96:	7f 0b                	jg     800aa3 <vprintfmt+0x15a>
  800a98:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800a9f:	85 f6                	test   %esi,%esi
  800aa1:	75 19                	jne    800abc <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800aa3:	53                   	push   %ebx
  800aa4:	68 c5 3b 80 00       	push   $0x803bc5
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	ff 75 08             	pushl  0x8(%ebp)
  800aaf:	e8 5e 02 00 00       	call   800d12 <printfmt>
  800ab4:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ab7:	e9 49 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800abc:	56                   	push   %esi
  800abd:	68 ce 3b 80 00       	push   $0x803bce
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 45 02 00 00       	call   800d12 <printfmt>
  800acd:	83 c4 10             	add    $0x10,%esp
			break;
  800ad0:	e9 30 02 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	83 c0 04             	add    $0x4,%eax
  800adb:	89 45 14             	mov    %eax,0x14(%ebp)
  800ade:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae1:	83 e8 04             	sub    $0x4,%eax
  800ae4:	8b 30                	mov    (%eax),%esi
  800ae6:	85 f6                	test   %esi,%esi
  800ae8:	75 05                	jne    800aef <vprintfmt+0x1a6>
				p = "(null)";
  800aea:	be d1 3b 80 00       	mov    $0x803bd1,%esi
			if (width > 0 && padc != '-')
  800aef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af3:	7e 6d                	jle    800b62 <vprintfmt+0x219>
  800af5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af9:	74 67                	je     800b62 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800afe:	83 ec 08             	sub    $0x8,%esp
  800b01:	50                   	push   %eax
  800b02:	56                   	push   %esi
  800b03:	e8 0c 03 00 00       	call   800e14 <strnlen>
  800b08:	83 c4 10             	add    $0x10,%esp
  800b0b:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b0e:	eb 16                	jmp    800b26 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b10:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b14:	83 ec 08             	sub    $0x8,%esp
  800b17:	ff 75 0c             	pushl  0xc(%ebp)
  800b1a:	50                   	push   %eax
  800b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1e:	ff d0                	call   *%eax
  800b20:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b23:	ff 4d e4             	decl   -0x1c(%ebp)
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7f e4                	jg     800b10 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2c:	eb 34                	jmp    800b62 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b32:	74 1c                	je     800b50 <vprintfmt+0x207>
  800b34:	83 fb 1f             	cmp    $0x1f,%ebx
  800b37:	7e 05                	jle    800b3e <vprintfmt+0x1f5>
  800b39:	83 fb 7e             	cmp    $0x7e,%ebx
  800b3c:	7e 12                	jle    800b50 <vprintfmt+0x207>
					putch('?', putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	6a 3f                	push   $0x3f
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	ff d0                	call   *%eax
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	eb 0f                	jmp    800b5f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 0c             	pushl  0xc(%ebp)
  800b56:	53                   	push   %ebx
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	89 f0                	mov    %esi,%eax
  800b64:	8d 70 01             	lea    0x1(%eax),%esi
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	0f be d8             	movsbl %al,%ebx
  800b6c:	85 db                	test   %ebx,%ebx
  800b6e:	74 24                	je     800b94 <vprintfmt+0x24b>
  800b70:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b74:	78 b8                	js     800b2e <vprintfmt+0x1e5>
  800b76:	ff 4d e0             	decl   -0x20(%ebp)
  800b79:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b7d:	79 af                	jns    800b2e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7f:	eb 13                	jmp    800b94 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	6a 20                	push   $0x20
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	ff d0                	call   *%eax
  800b8e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b91:	ff 4d e4             	decl   -0x1c(%ebp)
  800b94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b98:	7f e7                	jg     800b81 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b9a:	e9 66 01 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 3c fd ff ff       	call   8008ea <getint>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bbd:	85 d2                	test   %edx,%edx
  800bbf:	79 23                	jns    800be4 <vprintfmt+0x29b>
				putch('-', putdat);
  800bc1:	83 ec 08             	sub    $0x8,%esp
  800bc4:	ff 75 0c             	pushl  0xc(%ebp)
  800bc7:	6a 2d                	push   $0x2d
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	ff d0                	call   *%eax
  800bce:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd7:	f7 d8                	neg    %eax
  800bd9:	83 d2 00             	adc    $0x0,%edx
  800bdc:	f7 da                	neg    %edx
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800be4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800beb:	e9 bc 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 e8             	pushl  -0x18(%ebp)
  800bf6:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf9:	50                   	push   %eax
  800bfa:	e8 84 fc ff ff       	call   800883 <getuint>
  800bff:	83 c4 10             	add    $0x10,%esp
  800c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c0f:	e9 98 00 00 00       	jmp    800cac <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c14:	83 ec 08             	sub    $0x8,%esp
  800c17:	ff 75 0c             	pushl  0xc(%ebp)
  800c1a:	6a 58                	push   $0x58
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	ff d0                	call   *%eax
  800c21:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 58                	push   $0x58
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c34:	83 ec 08             	sub    $0x8,%esp
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	6a 58                	push   $0x58
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	ff d0                	call   *%eax
  800c41:	83 c4 10             	add    $0x10,%esp
			break;
  800c44:	e9 bc 00 00 00       	jmp    800d05 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c49:	83 ec 08             	sub    $0x8,%esp
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	6a 30                	push   $0x30
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	ff d0                	call   *%eax
  800c56:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c59:	83 ec 08             	sub    $0x8,%esp
  800c5c:	ff 75 0c             	pushl  0xc(%ebp)
  800c5f:	6a 78                	push   $0x78
  800c61:	8b 45 08             	mov    0x8(%ebp),%eax
  800c64:	ff d0                	call   *%eax
  800c66:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c8b:	eb 1f                	jmp    800cac <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c8d:	83 ec 08             	sub    $0x8,%esp
  800c90:	ff 75 e8             	pushl  -0x18(%ebp)
  800c93:	8d 45 14             	lea    0x14(%ebp),%eax
  800c96:	50                   	push   %eax
  800c97:	e8 e7 fb ff ff       	call   800883 <getuint>
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ca5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	52                   	push   %edx
  800cb7:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbe:	ff 75 f0             	pushl  -0x10(%ebp)
  800cc1:	ff 75 0c             	pushl  0xc(%ebp)
  800cc4:	ff 75 08             	pushl  0x8(%ebp)
  800cc7:	e8 00 fb ff ff       	call   8007cc <printnum>
  800ccc:	83 c4 20             	add    $0x20,%esp
			break;
  800ccf:	eb 34                	jmp    800d05 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 0c             	pushl  0xc(%ebp)
  800cd7:	53                   	push   %ebx
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	ff d0                	call   *%eax
  800cdd:	83 c4 10             	add    $0x10,%esp
			break;
  800ce0:	eb 23                	jmp    800d05 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ce2:	83 ec 08             	sub    $0x8,%esp
  800ce5:	ff 75 0c             	pushl  0xc(%ebp)
  800ce8:	6a 25                	push   $0x25
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	ff d0                	call   *%eax
  800cef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cf2:	ff 4d 10             	decl   0x10(%ebp)
  800cf5:	eb 03                	jmp    800cfa <vprintfmt+0x3b1>
  800cf7:	ff 4d 10             	decl   0x10(%ebp)
  800cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfd:	48                   	dec    %eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 25                	cmp    $0x25,%al
  800d02:	75 f3                	jne    800cf7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d04:	90                   	nop
		}
	}
  800d05:	e9 47 fc ff ff       	jmp    800951 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d18:	8d 45 10             	lea    0x10(%ebp),%eax
  800d1b:	83 c0 04             	add    $0x4,%eax
  800d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d21:	8b 45 10             	mov    0x10(%ebp),%eax
  800d24:	ff 75 f4             	pushl  -0xc(%ebp)
  800d27:	50                   	push   %eax
  800d28:	ff 75 0c             	pushl  0xc(%ebp)
  800d2b:	ff 75 08             	pushl  0x8(%ebp)
  800d2e:	e8 16 fc ff ff       	call   800949 <vprintfmt>
  800d33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d36:	90                   	nop
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 08             	mov    0x8(%eax),%eax
  800d42:	8d 50 01             	lea    0x1(%eax),%edx
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	8b 10                	mov    (%eax),%edx
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	8b 40 04             	mov    0x4(%eax),%eax
  800d56:	39 c2                	cmp    %eax,%edx
  800d58:	73 12                	jae    800d6c <sprintputch+0x33>
		*b->buf++ = ch;
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	89 0a                	mov    %ecx,(%edx)
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	88 10                	mov    %dl,(%eax)
}
  800d6c:	90                   	nop
  800d6d:	5d                   	pop    %ebp
  800d6e:	c3                   	ret    

00800d6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	01 d0                	add    %edx,%eax
  800d86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d94:	74 06                	je     800d9c <vsnprintf+0x2d>
  800d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9a:	7f 07                	jg     800da3 <vsnprintf+0x34>
		return -E_INVAL;
  800d9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800da1:	eb 20                	jmp    800dc3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800da3:	ff 75 14             	pushl  0x14(%ebp)
  800da6:	ff 75 10             	pushl  0x10(%ebp)
  800da9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dac:	50                   	push   %eax
  800dad:	68 39 0d 80 00       	push   $0x800d39
  800db2:	e8 92 fb ff ff       	call   800949 <vprintfmt>
  800db7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dbd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800dce:	83 c0 04             	add    $0x4,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800dda:	50                   	push   %eax
  800ddb:	ff 75 0c             	pushl  0xc(%ebp)
  800dde:	ff 75 08             	pushl  0x8(%ebp)
  800de1:	e8 89 ff ff ff       	call   800d6f <vsnprintf>
  800de6:	83 c4 10             	add    $0x10,%esp
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800def:	c9                   	leave  
  800df0:	c3                   	ret    

00800df1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800df7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dfe:	eb 06                	jmp    800e06 <strlen+0x15>
		n++;
  800e00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e03:	ff 45 08             	incl   0x8(%ebp)
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	84 c0                	test   %al,%al
  800e0d:	75 f1                	jne    800e00 <strlen+0xf>
		n++;
	return n;
  800e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e12:	c9                   	leave  
  800e13:	c3                   	ret    

00800e14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e21:	eb 09                	jmp    800e2c <strnlen+0x18>
		n++;
  800e23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e26:	ff 45 08             	incl   0x8(%ebp)
  800e29:	ff 4d 0c             	decl   0xc(%ebp)
  800e2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e30:	74 09                	je     800e3b <strnlen+0x27>
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	84 c0                	test   %al,%al
  800e39:	75 e8                	jne    800e23 <strnlen+0xf>
		n++;
	return n;
  800e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
  800e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e4c:	90                   	nop
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 08             	mov    %edx,0x8(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e5f:	8a 12                	mov    (%edx),%dl
  800e61:	88 10                	mov    %dl,(%eax)
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	84 c0                	test   %al,%al
  800e67:	75 e4                	jne    800e4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6c:	c9                   	leave  
  800e6d:	c3                   	ret    

00800e6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
  800e71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e81:	eb 1f                	jmp    800ea2 <strncpy+0x34>
		*dst++ = *src;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	8d 50 01             	lea    0x1(%eax),%edx
  800e89:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e96:	8a 00                	mov    (%eax),%al
  800e98:	84 c0                	test   %al,%al
  800e9a:	74 03                	je     800e9f <strncpy+0x31>
			src++;
  800e9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea8:	72 d9                	jb     800e83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ebb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebf:	74 30                	je     800ef1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ec1:	eb 16                	jmp    800ed9 <strlcpy+0x2a>
			*dst++ = *src++;
  800ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec6:	8d 50 01             	lea    0x1(%eax),%edx
  800ec9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ecf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ed2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ed5:	8a 12                	mov    (%edx),%dl
  800ed7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ed9:	ff 4d 10             	decl   0x10(%ebp)
  800edc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ee0:	74 09                	je     800eeb <strlcpy+0x3c>
  800ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 d8                	jne    800ec3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800eee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	29 c2                	sub    %eax,%edx
  800ef9:	89 d0                	mov    %edx,%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f00:	eb 06                	jmp    800f08 <strcmp+0xb>
		p++, q++;
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	8a 00                	mov    (%eax),%al
  800f0d:	84 c0                	test   %al,%al
  800f0f:	74 0e                	je     800f1f <strcmp+0x22>
  800f11:	8b 45 08             	mov    0x8(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 e3                	je     800f02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 d0             	movzbl %al,%edx
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 c0             	movzbl %al,%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
}
  800f33:	5d                   	pop    %ebp
  800f34:	c3                   	ret    

00800f35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f38:	eb 09                	jmp    800f43 <strncmp+0xe>
		n--, p++, q++;
  800f3a:	ff 4d 10             	decl   0x10(%ebp)
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f47:	74 17                	je     800f60 <strncmp+0x2b>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	84 c0                	test   %al,%al
  800f50:	74 0e                	je     800f60 <strncmp+0x2b>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 10                	mov    (%eax),%dl
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	38 c2                	cmp    %al,%dl
  800f5e:	74 da                	je     800f3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f64:	75 07                	jne    800f6d <strncmp+0x38>
		return 0;
  800f66:	b8 00 00 00 00       	mov    $0x0,%eax
  800f6b:	eb 14                	jmp    800f81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 d0             	movzbl %al,%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	0f b6 c0             	movzbl %al,%eax
  800f7d:	29 c2                	sub    %eax,%edx
  800f7f:	89 d0                	mov    %edx,%eax
}
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 04             	sub    $0x4,%esp
  800f89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8f:	eb 12                	jmp    800fa3 <strchr+0x20>
		if (*s == c)
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f99:	75 05                	jne    800fa0 <strchr+0x1d>
			return (char *) s;
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	eb 11                	jmp    800fb1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	84 c0                	test   %al,%al
  800faa:	75 e5                	jne    800f91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fb1:	c9                   	leave  
  800fb2:	c3                   	ret    

00800fb3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbf:	eb 0d                	jmp    800fce <strfind+0x1b>
		if (*s == c)
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc9:	74 0e                	je     800fd9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fcb:	ff 45 08             	incl   0x8(%ebp)
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	84 c0                	test   %al,%al
  800fd5:	75 ea                	jne    800fc1 <strfind+0xe>
  800fd7:	eb 01                	jmp    800fda <strfind+0x27>
		if (*s == c)
			break;
  800fd9:	90                   	nop
	return (char *) s;
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdd:	c9                   	leave  
  800fde:	c3                   	ret    

00800fdf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fdf:	55                   	push   %ebp
  800fe0:	89 e5                	mov    %esp,%ebp
  800fe2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ff1:	eb 0e                	jmp    801001 <memset+0x22>
		*p++ = c;
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	8d 50 01             	lea    0x1(%eax),%edx
  800ff9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801001:	ff 4d f8             	decl   -0x8(%ebp)
  801004:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801008:	79 e9                	jns    800ff3 <memset+0x14>
		*p++ = c;

	return v;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801021:	eb 16                	jmp    801039 <memcpy+0x2a>
		*d++ = *s++;
  801023:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80102c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80102f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801032:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801035:	8a 12                	mov    (%edx),%dl
  801037:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801039:	8b 45 10             	mov    0x10(%ebp),%eax
  80103c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80103f:	89 55 10             	mov    %edx,0x10(%ebp)
  801042:	85 c0                	test   %eax,%eax
  801044:	75 dd                	jne    801023 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801049:	c9                   	leave  
  80104a:	c3                   	ret    

0080104b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80105d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801060:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801063:	73 50                	jae    8010b5 <memmove+0x6a>
  801065:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801068:	8b 45 10             	mov    0x10(%ebp),%eax
  80106b:	01 d0                	add    %edx,%eax
  80106d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801070:	76 43                	jbe    8010b5 <memmove+0x6a>
		s += n;
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801078:	8b 45 10             	mov    0x10(%ebp),%eax
  80107b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80107e:	eb 10                	jmp    801090 <memmove+0x45>
			*--d = *--s;
  801080:	ff 4d f8             	decl   -0x8(%ebp)
  801083:	ff 4d fc             	decl   -0x4(%ebp)
  801086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801089:	8a 10                	mov    (%eax),%dl
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801090:	8b 45 10             	mov    0x10(%ebp),%eax
  801093:	8d 50 ff             	lea    -0x1(%eax),%edx
  801096:	89 55 10             	mov    %edx,0x10(%ebp)
  801099:	85 c0                	test   %eax,%eax
  80109b:	75 e3                	jne    801080 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80109d:	eb 23                	jmp    8010c2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80109f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a2:	8d 50 01             	lea    0x1(%eax),%edx
  8010a5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010b1:	8a 12                	mov    (%edx),%dl
  8010b3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010bb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	75 dd                	jne    80109f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010d9:	eb 2a                	jmp    801105 <memcmp+0x3e>
		if (*s1 != *s2)
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8a 10                	mov    (%eax),%dl
  8010e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e3:	8a 00                	mov    (%eax),%al
  8010e5:	38 c2                	cmp    %al,%dl
  8010e7:	74 16                	je     8010ff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	0f b6 d0             	movzbl %al,%edx
  8010f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	0f b6 c0             	movzbl %al,%eax
  8010f9:	29 c2                	sub    %eax,%edx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	eb 18                	jmp    801117 <memcmp+0x50>
		s1++, s2++;
  8010ff:	ff 45 fc             	incl   -0x4(%ebp)
  801102:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	8d 50 ff             	lea    -0x1(%eax),%edx
  80110b:	89 55 10             	mov    %edx,0x10(%ebp)
  80110e:	85 c0                	test   %eax,%eax
  801110:	75 c9                	jne    8010db <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80111f:	8b 55 08             	mov    0x8(%ebp),%edx
  801122:	8b 45 10             	mov    0x10(%ebp),%eax
  801125:	01 d0                	add    %edx,%eax
  801127:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80112a:	eb 15                	jmp    801141 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d0             	movzbl %al,%edx
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	0f b6 c0             	movzbl %al,%eax
  80113a:	39 c2                	cmp    %eax,%edx
  80113c:	74 0d                	je     80114b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80113e:	ff 45 08             	incl   0x8(%ebp)
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801147:	72 e3                	jb     80112c <memfind+0x13>
  801149:	eb 01                	jmp    80114c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80114b:	90                   	nop
	return (void *) s;
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80114f:	c9                   	leave  
  801150:	c3                   	ret    

00801151 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801157:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80115e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801165:	eb 03                	jmp    80116a <strtol+0x19>
		s++;
  801167:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80116a:	8b 45 08             	mov    0x8(%ebp),%eax
  80116d:	8a 00                	mov    (%eax),%al
  80116f:	3c 20                	cmp    $0x20,%al
  801171:	74 f4                	je     801167 <strtol+0x16>
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	3c 09                	cmp    $0x9,%al
  80117a:	74 eb                	je     801167 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	3c 2b                	cmp    $0x2b,%al
  801183:	75 05                	jne    80118a <strtol+0x39>
		s++;
  801185:	ff 45 08             	incl   0x8(%ebp)
  801188:	eb 13                	jmp    80119d <strtol+0x4c>
	else if (*s == '-')
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	3c 2d                	cmp    $0x2d,%al
  801191:	75 0a                	jne    80119d <strtol+0x4c>
		s++, neg = 1;
  801193:	ff 45 08             	incl   0x8(%ebp)
  801196:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80119d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011a1:	74 06                	je     8011a9 <strtol+0x58>
  8011a3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011a7:	75 20                	jne    8011c9 <strtol+0x78>
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 30                	cmp    $0x30,%al
  8011b0:	75 17                	jne    8011c9 <strtol+0x78>
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	40                   	inc    %eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 78                	cmp    $0x78,%al
  8011ba:	75 0d                	jne    8011c9 <strtol+0x78>
		s += 2, base = 16;
  8011bc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011c0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011c7:	eb 28                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011cd:	75 15                	jne    8011e4 <strtol+0x93>
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 30                	cmp    $0x30,%al
  8011d6:	75 0c                	jne    8011e4 <strtol+0x93>
		s++, base = 8;
  8011d8:	ff 45 08             	incl   0x8(%ebp)
  8011db:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011e2:	eb 0d                	jmp    8011f1 <strtol+0xa0>
	else if (base == 0)
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 07                	jne    8011f1 <strtol+0xa0>
		base = 10;
  8011ea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 2f                	cmp    $0x2f,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xc2>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 39                	cmp    $0x39,%al
  801201:	7f 10                	jg     801213 <strtol+0xc2>
			dig = *s - '0';
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 30             	sub    $0x30,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 42                	jmp    801255 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 60                	cmp    $0x60,%al
  80121a:	7e 19                	jle    801235 <strtol+0xe4>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 7a                	cmp    $0x7a,%al
  801223:	7f 10                	jg     801235 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 57             	sub    $0x57,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801233:	eb 20                	jmp    801255 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 40                	cmp    $0x40,%al
  80123c:	7e 39                	jle    801277 <strtol+0x126>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	3c 5a                	cmp    $0x5a,%al
  801245:	7f 30                	jg     801277 <strtol+0x126>
			dig = *s - 'A' + 10;
  801247:	8b 45 08             	mov    0x8(%ebp),%eax
  80124a:	8a 00                	mov    (%eax),%al
  80124c:	0f be c0             	movsbl %al,%eax
  80124f:	83 e8 37             	sub    $0x37,%eax
  801252:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	3b 45 10             	cmp    0x10(%ebp),%eax
  80125b:	7d 19                	jge    801276 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80125d:	ff 45 08             	incl   0x8(%ebp)
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801263:	0f af 45 10          	imul   0x10(%ebp),%eax
  801267:	89 c2                	mov    %eax,%edx
  801269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126c:	01 d0                	add    %edx,%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801271:	e9 7b ff ff ff       	jmp    8011f1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801276:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801277:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80127b:	74 08                	je     801285 <strtol+0x134>
		*endptr = (char *) s;
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	8b 55 08             	mov    0x8(%ebp),%edx
  801283:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801285:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801289:	74 07                	je     801292 <strtol+0x141>
  80128b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128e:	f7 d8                	neg    %eax
  801290:	eb 03                	jmp    801295 <strtol+0x144>
  801292:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801295:	c9                   	leave  
  801296:	c3                   	ret    

00801297 <ltostr>:

void
ltostr(long value, char *str)
{
  801297:	55                   	push   %ebp
  801298:	89 e5                	mov    %esp,%ebp
  80129a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80129d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012af:	79 13                	jns    8012c4 <ltostr+0x2d>
	{
		neg = 1;
  8012b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012be:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012c1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012cc:	99                   	cltd   
  8012cd:	f7 f9                	idiv   %ecx
  8012cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012e5:	83 c2 30             	add    $0x30,%edx
  8012e8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f2:	f7 e9                	imul   %ecx
  8012f4:	c1 fa 02             	sar    $0x2,%edx
  8012f7:	89 c8                	mov    %ecx,%eax
  8012f9:	c1 f8 1f             	sar    $0x1f,%eax
  8012fc:	29 c2                	sub    %eax,%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801303:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801306:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130b:	f7 e9                	imul   %ecx
  80130d:	c1 fa 02             	sar    $0x2,%edx
  801310:	89 c8                	mov    %ecx,%eax
  801312:	c1 f8 1f             	sar    $0x1f,%eax
  801315:	29 c2                	sub    %eax,%edx
  801317:	89 d0                	mov    %edx,%eax
  801319:	c1 e0 02             	shl    $0x2,%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	01 c0                	add    %eax,%eax
  801320:	29 c1                	sub    %eax,%ecx
  801322:	89 ca                	mov    %ecx,%edx
  801324:	85 d2                	test   %edx,%edx
  801326:	75 9c                	jne    8012c4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80132f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801332:	48                   	dec    %eax
  801333:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80133a:	74 3d                	je     801379 <ltostr+0xe2>
		start = 1 ;
  80133c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801343:	eb 34                	jmp    801379 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	8a 00                	mov    (%eax),%al
  80134f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80135d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801360:	01 c8                	add    %ecx,%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	01 c2                	add    %eax,%edx
  80136e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801371:	88 02                	mov    %al,(%edx)
		start++ ;
  801373:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801376:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137f:	7c c4                	jl     801345 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801381:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 d0                	add    %edx,%eax
  801389:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80138c:	90                   	nop
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 54 fa ff ff       	call   800df1 <strlen>
  80139d:	83 c4 04             	add    $0x4,%esp
  8013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013a3:	ff 75 0c             	pushl  0xc(%ebp)
  8013a6:	e8 46 fa ff ff       	call   800df1 <strlen>
  8013ab:	83 c4 04             	add    $0x4,%esp
  8013ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013bf:	eb 17                	jmp    8013d8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	01 c2                	add    %eax,%edx
  8013c9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cf:	01 c8                	add    %ecx,%eax
  8013d1:	8a 00                	mov    (%eax),%al
  8013d3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013d5:	ff 45 fc             	incl   -0x4(%ebp)
  8013d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013db:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013de:	7c e1                	jl     8013c1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013ee:	eb 1f                	jmp    80140f <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f3:	8d 50 01             	lea    0x1(%eax),%edx
  8013f6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f9:	89 c2                	mov    %eax,%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80140c:	ff 45 f8             	incl   -0x8(%ebp)
  80140f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801412:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801415:	7c d9                	jl     8013f0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801417:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80141a:	8b 45 10             	mov    0x10(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	c6 00 00             	movb   $0x0,(%eax)
}
  801422:	90                   	nop
  801423:	c9                   	leave  
  801424:	c3                   	ret    

00801425 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801428:	8b 45 14             	mov    0x14(%ebp),%eax
  80142b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801431:	8b 45 14             	mov    0x14(%ebp),%eax
  801434:	8b 00                	mov    (%eax),%eax
  801436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80143d:	8b 45 10             	mov    0x10(%ebp),%eax
  801440:	01 d0                	add    %edx,%eax
  801442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801448:	eb 0c                	jmp    801456 <strsplit+0x31>
			*string++ = 0;
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8d 50 01             	lea    0x1(%eax),%edx
  801450:	89 55 08             	mov    %edx,0x8(%ebp)
  801453:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	8a 00                	mov    (%eax),%al
  80145b:	84 c0                	test   %al,%al
  80145d:	74 18                	je     801477 <strsplit+0x52>
  80145f:	8b 45 08             	mov    0x8(%ebp),%eax
  801462:	8a 00                	mov    (%eax),%al
  801464:	0f be c0             	movsbl %al,%eax
  801467:	50                   	push   %eax
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	e8 13 fb ff ff       	call   800f83 <strchr>
  801470:	83 c4 08             	add    $0x8,%esp
  801473:	85 c0                	test   %eax,%eax
  801475:	75 d3                	jne    80144a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8a 00                	mov    (%eax),%al
  80147c:	84 c0                	test   %al,%al
  80147e:	74 5a                	je     8014da <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801480:	8b 45 14             	mov    0x14(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	83 f8 0f             	cmp    $0xf,%eax
  801488:	75 07                	jne    801491 <strsplit+0x6c>
		{
			return 0;
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
  80148f:	eb 66                	jmp    8014f7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801491:	8b 45 14             	mov    0x14(%ebp),%eax
  801494:	8b 00                	mov    (%eax),%eax
  801496:	8d 48 01             	lea    0x1(%eax),%ecx
  801499:	8b 55 14             	mov    0x14(%ebp),%edx
  80149c:	89 0a                	mov    %ecx,(%edx)
  80149e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a8:	01 c2                	add    %eax,%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014af:	eb 03                	jmp    8014b4 <strsplit+0x8f>
			string++;
  8014b1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b7:	8a 00                	mov    (%eax),%al
  8014b9:	84 c0                	test   %al,%al
  8014bb:	74 8b                	je     801448 <strsplit+0x23>
  8014bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c0:	8a 00                	mov    (%eax),%al
  8014c2:	0f be c0             	movsbl %al,%eax
  8014c5:	50                   	push   %eax
  8014c6:	ff 75 0c             	pushl  0xc(%ebp)
  8014c9:	e8 b5 fa ff ff       	call   800f83 <strchr>
  8014ce:	83 c4 08             	add    $0x8,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	74 dc                	je     8014b1 <strsplit+0x8c>
			string++;
	}
  8014d5:	e9 6e ff ff ff       	jmp    801448 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014da:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014db:	8b 45 14             	mov    0x14(%ebp),%eax
  8014de:	8b 00                	mov    (%eax),%eax
  8014e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    

008014f9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014ff:	a1 04 40 80 00       	mov    0x804004,%eax
  801504:	85 c0                	test   %eax,%eax
  801506:	74 1f                	je     801527 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801508:	e8 1d 00 00 00       	call   80152a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80150d:	83 ec 0c             	sub    $0xc,%esp
  801510:	68 30 3d 80 00       	push   $0x803d30
  801515:	e8 55 f2 ff ff       	call   80076f <cprintf>
  80151a:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80151d:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801524:	00 00 00 
	}
}
  801527:	90                   	nop
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801530:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801537:	00 00 00 
  80153a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801541:	00 00 00 
  801544:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80154b:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80154e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801555:	00 00 00 
  801558:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80155f:	00 00 00 
  801562:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801569:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  80156c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801576:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80157b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801580:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801585:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80158c:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80158f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80159e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a9:	f7 75 f0             	divl   -0x10(%ebp)
  8015ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015af:	29 d0                	sub    %edx,%eax
  8015b1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8015b4:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	6a 06                	push   $0x6
  8015cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8015d0:	50                   	push   %eax
  8015d1:	e8 d4 05 00 00       	call   801baa <sys_allocate_chunk>
  8015d6:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d9:	a1 20 41 80 00       	mov    0x804120,%eax
  8015de:	83 ec 0c             	sub    $0xc,%esp
  8015e1:	50                   	push   %eax
  8015e2:	e8 49 0c 00 00       	call   802230 <initialize_MemBlocksList>
  8015e7:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8015ea:	a1 48 41 80 00       	mov    0x804148,%eax
  8015ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8015f2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015f6:	75 14                	jne    80160c <initialize_dyn_block_system+0xe2>
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 55 3d 80 00       	push   $0x803d55
  801600:	6a 39                	push   $0x39
  801602:	68 73 3d 80 00       	push   $0x803d73
  801607:	e8 af ee ff ff       	call   8004bb <_panic>
  80160c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160f:	8b 00                	mov    (%eax),%eax
  801611:	85 c0                	test   %eax,%eax
  801613:	74 10                	je     801625 <initialize_dyn_block_system+0xfb>
  801615:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801618:	8b 00                	mov    (%eax),%eax
  80161a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80161d:	8b 52 04             	mov    0x4(%edx),%edx
  801620:	89 50 04             	mov    %edx,0x4(%eax)
  801623:	eb 0b                	jmp    801630 <initialize_dyn_block_system+0x106>
  801625:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801628:	8b 40 04             	mov    0x4(%eax),%eax
  80162b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801630:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801633:	8b 40 04             	mov    0x4(%eax),%eax
  801636:	85 c0                	test   %eax,%eax
  801638:	74 0f                	je     801649 <initialize_dyn_block_system+0x11f>
  80163a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80163d:	8b 40 04             	mov    0x4(%eax),%eax
  801640:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801643:	8b 12                	mov    (%edx),%edx
  801645:	89 10                	mov    %edx,(%eax)
  801647:	eb 0a                	jmp    801653 <initialize_dyn_block_system+0x129>
  801649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164c:	8b 00                	mov    (%eax),%eax
  80164e:	a3 48 41 80 00       	mov    %eax,0x804148
  801653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80165c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80165f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801666:	a1 54 41 80 00       	mov    0x804154,%eax
  80166b:	48                   	dec    %eax
  80166c:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  801671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801674:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  80167b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801685:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801689:	75 14                	jne    80169f <initialize_dyn_block_system+0x175>
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	68 80 3d 80 00       	push   $0x803d80
  801693:	6a 3f                	push   $0x3f
  801695:	68 73 3d 80 00       	push   $0x803d73
  80169a:	e8 1c ee ff ff       	call   8004bb <_panic>
  80169f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8016a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a8:	89 10                	mov    %edx,(%eax)
  8016aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	74 0d                	je     8016c0 <initialize_dyn_block_system+0x196>
  8016b3:	a1 38 41 80 00       	mov    0x804138,%eax
  8016b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016bb:	89 50 04             	mov    %edx,0x4(%eax)
  8016be:	eb 08                	jmp    8016c8 <initialize_dyn_block_system+0x19e>
  8016c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016c3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016cb:	a3 38 41 80 00       	mov    %eax,0x804138
  8016d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016da:	a1 44 41 80 00       	mov    0x804144,%eax
  8016df:	40                   	inc    %eax
  8016e0:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8016e5:	90                   	nop
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ee:	e8 06 fe ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016f7:	75 07                	jne    801700 <malloc+0x18>
  8016f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fe:	eb 7d                	jmp    80177d <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801700:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801707:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80170e:	8b 55 08             	mov    0x8(%ebp),%edx
  801711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801714:	01 d0                	add    %edx,%eax
  801716:	48                   	dec    %eax
  801717:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80171a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171d:	ba 00 00 00 00       	mov    $0x0,%edx
  801722:	f7 75 f0             	divl   -0x10(%ebp)
  801725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801728:	29 d0                	sub    %edx,%eax
  80172a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  80172d:	e8 46 08 00 00       	call   801f78 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801732:	83 f8 01             	cmp    $0x1,%eax
  801735:	75 07                	jne    80173e <malloc+0x56>
  801737:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  80173e:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  801742:	75 34                	jne    801778 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801744:	83 ec 0c             	sub    $0xc,%esp
  801747:	ff 75 e8             	pushl  -0x18(%ebp)
  80174a:	e8 73 0e 00 00       	call   8025c2 <alloc_block_FF>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801755:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801759:	74 16                	je     801771 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  80175b:	83 ec 0c             	sub    $0xc,%esp
  80175e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801761:	e8 ff 0b 00 00       	call   802365 <insert_sorted_allocList>
  801766:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80176c:	8b 40 08             	mov    0x8(%eax),%eax
  80176f:	eb 0c                	jmp    80177d <malloc+0x95>
	             }
	             else
	             	return NULL;
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	eb 05                	jmp    80177d <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  80178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801794:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801799:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  80179c:	83 ec 08             	sub    $0x8,%esp
  80179f:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a2:	68 40 40 80 00       	push   $0x804040
  8017a7:	e8 61 0b 00 00       	call   80230d <find_block>
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  8017b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017b6:	0f 84 a5 00 00 00    	je     801861 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8017bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	50                   	push   %eax
  8017c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c9:	e8 a4 03 00 00       	call   801b72 <sys_free_user_mem>
  8017ce:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8017d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017d5:	75 17                	jne    8017ee <free+0x6f>
  8017d7:	83 ec 04             	sub    $0x4,%esp
  8017da:	68 55 3d 80 00       	push   $0x803d55
  8017df:	68 87 00 00 00       	push   $0x87
  8017e4:	68 73 3d 80 00       	push   $0x803d73
  8017e9:	e8 cd ec ff ff       	call   8004bb <_panic>
  8017ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f1:	8b 00                	mov    (%eax),%eax
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	74 10                	je     801807 <free+0x88>
  8017f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fa:	8b 00                	mov    (%eax),%eax
  8017fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017ff:	8b 52 04             	mov    0x4(%edx),%edx
  801802:	89 50 04             	mov    %edx,0x4(%eax)
  801805:	eb 0b                	jmp    801812 <free+0x93>
  801807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180a:	8b 40 04             	mov    0x4(%eax),%eax
  80180d:	a3 44 40 80 00       	mov    %eax,0x804044
  801812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801815:	8b 40 04             	mov    0x4(%eax),%eax
  801818:	85 c0                	test   %eax,%eax
  80181a:	74 0f                	je     80182b <free+0xac>
  80181c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181f:	8b 40 04             	mov    0x4(%eax),%eax
  801822:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801825:	8b 12                	mov    (%edx),%edx
  801827:	89 10                	mov    %edx,(%eax)
  801829:	eb 0a                	jmp    801835 <free+0xb6>
  80182b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182e:	8b 00                	mov    (%eax),%eax
  801830:	a3 40 40 80 00       	mov    %eax,0x804040
  801835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80183e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801841:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801848:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80184d:	48                   	dec    %eax
  80184e:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  801853:	83 ec 0c             	sub    $0xc,%esp
  801856:	ff 75 ec             	pushl  -0x14(%ebp)
  801859:	e8 37 12 00 00       	call   802a95 <insert_sorted_with_merge_freeList>
  80185e:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801861:	90                   	nop
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 38             	sub    $0x38,%esp
  80186a:	8b 45 10             	mov    0x10(%ebp),%eax
  80186d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801870:	e8 84 fc ff ff       	call   8014f9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801875:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801879:	75 07                	jne    801882 <smalloc+0x1e>
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
  801880:	eb 7e                	jmp    801900 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801882:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801889:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801890:	8b 55 0c             	mov    0xc(%ebp),%edx
  801893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801896:	01 d0                	add    %edx,%eax
  801898:	48                   	dec    %eax
  801899:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80189c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80189f:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a4:	f7 75 f0             	divl   -0x10(%ebp)
  8018a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018aa:	29 d0                	sub    %edx,%eax
  8018ac:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  8018af:	e8 c4 06 00 00       	call   801f78 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018b4:	83 f8 01             	cmp    $0x1,%eax
  8018b7:	75 42                	jne    8018fb <smalloc+0x97>

		  va = malloc(newsize) ;
  8018b9:	83 ec 0c             	sub    $0xc,%esp
  8018bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8018bf:	e8 24 fe ff ff       	call   8016e8 <malloc>
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8018ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018ce:	74 24                	je     8018f4 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8018d0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018d7:	50                   	push   %eax
  8018d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8018db:	ff 75 08             	pushl  0x8(%ebp)
  8018de:	e8 1a 04 00 00       	call   801cfd <sys_createSharedObject>
  8018e3:	83 c4 10             	add    $0x10,%esp
  8018e6:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8018e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018ed:	78 0c                	js     8018fb <smalloc+0x97>
					  return va ;
  8018ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018f2:	eb 0c                	jmp    801900 <smalloc+0x9c>
				 }
				 else
					return NULL;
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f9:	eb 05                	jmp    801900 <smalloc+0x9c>
	  }
		  return NULL ;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801908:	e8 ec fb ff ff       	call   8014f9 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  80190d:	83 ec 08             	sub    $0x8,%esp
  801910:	ff 75 0c             	pushl  0xc(%ebp)
  801913:	ff 75 08             	pushl  0x8(%ebp)
  801916:	e8 0c 04 00 00       	call   801d27 <sys_getSizeOfSharedObject>
  80191b:	83 c4 10             	add    $0x10,%esp
  80191e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801921:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801925:	75 07                	jne    80192e <sget+0x2c>
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
  80192c:	eb 75                	jmp    8019a3 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80192e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	48                   	dec    %eax
  80193e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801944:	ba 00 00 00 00       	mov    $0x0,%edx
  801949:	f7 75 f0             	divl   -0x10(%ebp)
  80194c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194f:	29 d0                	sub    %edx,%eax
  801951:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801954:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80195b:	e8 18 06 00 00       	call   801f78 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801960:	83 f8 01             	cmp    $0x1,%eax
  801963:	75 39                	jne    80199e <sget+0x9c>

		  va = malloc(newsize) ;
  801965:	83 ec 0c             	sub    $0xc,%esp
  801968:	ff 75 e8             	pushl  -0x18(%ebp)
  80196b:	e8 78 fd ff ff       	call   8016e8 <malloc>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801976:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80197a:	74 22                	je     80199e <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  80197c:	83 ec 04             	sub    $0x4,%esp
  80197f:	ff 75 e0             	pushl  -0x20(%ebp)
  801982:	ff 75 0c             	pushl  0xc(%ebp)
  801985:	ff 75 08             	pushl  0x8(%ebp)
  801988:	e8 b7 03 00 00       	call   801d44 <sys_getSharedObject>
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801993:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801997:	78 05                	js     80199e <sget+0x9c>
					  return va;
  801999:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80199c:	eb 05                	jmp    8019a3 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80199e:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019ab:	e8 49 fb ff ff       	call   8014f9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019b0:	83 ec 04             	sub    $0x4,%esp
  8019b3:	68 a4 3d 80 00       	push   $0x803da4
  8019b8:	68 1e 01 00 00       	push   $0x11e
  8019bd:	68 73 3d 80 00       	push   $0x803d73
  8019c2:	e8 f4 ea ff ff       	call   8004bb <_panic>

008019c7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	68 cc 3d 80 00       	push   $0x803dcc
  8019d5:	68 32 01 00 00       	push   $0x132
  8019da:	68 73 3d 80 00       	push   $0x803d73
  8019df:	e8 d7 ea ff ff       	call   8004bb <_panic>

008019e4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	68 f0 3d 80 00       	push   $0x803df0
  8019f2:	68 3d 01 00 00       	push   $0x13d
  8019f7:	68 73 3d 80 00       	push   $0x803d73
  8019fc:	e8 ba ea ff ff       	call   8004bb <_panic>

00801a01 <shrink>:

}
void shrink(uint32 newSize)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	68 f0 3d 80 00       	push   $0x803df0
  801a0f:	68 42 01 00 00       	push   $0x142
  801a14:	68 73 3d 80 00       	push   $0x803d73
  801a19:	e8 9d ea ff ff       	call   8004bb <_panic>

00801a1e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a24:	83 ec 04             	sub    $0x4,%esp
  801a27:	68 f0 3d 80 00       	push   $0x803df0
  801a2c:	68 47 01 00 00       	push   $0x147
  801a31:	68 73 3d 80 00       	push   $0x803d73
  801a36:	e8 80 ea ff ff       	call   8004bb <_panic>

00801a3b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	57                   	push   %edi
  801a3f:	56                   	push   %esi
  801a40:	53                   	push   %ebx
  801a41:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a50:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a53:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a56:	cd 30                	int    $0x30
  801a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a5e:	83 c4 10             	add    $0x10,%esp
  801a61:	5b                   	pop    %ebx
  801a62:	5e                   	pop    %esi
  801a63:	5f                   	pop    %edi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    

00801a66 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a72:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	52                   	push   %edx
  801a7e:	ff 75 0c             	pushl  0xc(%ebp)
  801a81:	50                   	push   %eax
  801a82:	6a 00                	push   $0x0
  801a84:	e8 b2 ff ff ff       	call   801a3b <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	90                   	nop
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_cgetc>:

int
sys_cgetc(void)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 01                	push   $0x1
  801a9e:	e8 98 ff ff ff       	call   801a3b <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801aab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	52                   	push   %edx
  801ab8:	50                   	push   %eax
  801ab9:	6a 05                	push   $0x5
  801abb:	e8 7b ff ff ff       	call   801a3b <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	56                   	push   %esi
  801ac9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801aca:	8b 75 18             	mov    0x18(%ebp),%esi
  801acd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ad0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	56                   	push   %esi
  801ada:	53                   	push   %ebx
  801adb:	51                   	push   %ecx
  801adc:	52                   	push   %edx
  801add:	50                   	push   %eax
  801ade:	6a 06                	push   $0x6
  801ae0:	e8 56 ff ff ff       	call   801a3b <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5e                   	pop    %esi
  801aed:	5d                   	pop    %ebp
  801aee:	c3                   	ret    

00801aef <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	52                   	push   %edx
  801aff:	50                   	push   %eax
  801b00:	6a 07                	push   $0x7
  801b02:	e8 34 ff ff ff       	call   801a3b <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	ff 75 0c             	pushl  0xc(%ebp)
  801b18:	ff 75 08             	pushl  0x8(%ebp)
  801b1b:	6a 08                	push   $0x8
  801b1d:	e8 19 ff ff ff       	call   801a3b <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 09                	push   $0x9
  801b36:	e8 00 ff ff ff       	call   801a3b <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 0a                	push   $0xa
  801b4f:	e8 e7 fe ff ff       	call   801a3b <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 0b                	push   $0xb
  801b68:	e8 ce fe ff ff       	call   801a3b <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	ff 75 08             	pushl  0x8(%ebp)
  801b81:	6a 0f                	push   $0xf
  801b83:	e8 b3 fe ff ff       	call   801a3b <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
	return;
  801b8b:	90                   	nop
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	ff 75 08             	pushl  0x8(%ebp)
  801b9d:	6a 10                	push   $0x10
  801b9f:	e8 97 fe ff ff       	call   801a3b <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba7:	90                   	nop
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 10             	pushl  0x10(%ebp)
  801bb4:	ff 75 0c             	pushl  0xc(%ebp)
  801bb7:	ff 75 08             	pushl  0x8(%ebp)
  801bba:	6a 11                	push   $0x11
  801bbc:	e8 7a fe ff ff       	call   801a3b <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc4:	90                   	nop
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 0c                	push   $0xc
  801bd6:	e8 60 fe ff ff       	call   801a3b <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	ff 75 08             	pushl  0x8(%ebp)
  801bee:	6a 0d                	push   $0xd
  801bf0:	e8 46 fe ff ff       	call   801a3b <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 0e                	push   $0xe
  801c09:	e8 2d fe ff ff       	call   801a3b <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 13                	push   $0x13
  801c23:	e8 13 fe ff ff       	call   801a3b <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	90                   	nop
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 14                	push   $0x14
  801c3d:	e8 f9 fd ff ff       	call   801a3b <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
}
  801c45:	90                   	nop
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c54:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	50                   	push   %eax
  801c61:	6a 15                	push   $0x15
  801c63:	e8 d3 fd ff ff       	call   801a3b <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	90                   	nop
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 16                	push   $0x16
  801c7d:	e8 b9 fd ff ff       	call   801a3b <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	90                   	nop
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	ff 75 0c             	pushl  0xc(%ebp)
  801c97:	50                   	push   %eax
  801c98:	6a 17                	push   $0x17
  801c9a:	e8 9c fd ff ff       	call   801a3b <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	52                   	push   %edx
  801cb4:	50                   	push   %eax
  801cb5:	6a 1a                	push   $0x1a
  801cb7:	e8 7f fd ff ff       	call   801a3b <syscall>
  801cbc:	83 c4 18             	add    $0x18,%esp
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	6a 18                	push   $0x18
  801cd4:	e8 62 fd ff ff       	call   801a3b <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	90                   	nop
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	52                   	push   %edx
  801cef:	50                   	push   %eax
  801cf0:	6a 19                	push   $0x19
  801cf2:	e8 44 fd ff ff       	call   801a3b <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	90                   	nop
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 04             	sub    $0x4,%esp
  801d03:	8b 45 10             	mov    0x10(%ebp),%eax
  801d06:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d09:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d0c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	6a 00                	push   $0x0
  801d15:	51                   	push   %ecx
  801d16:	52                   	push   %edx
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	50                   	push   %eax
  801d1b:	6a 1b                	push   $0x1b
  801d1d:	e8 19 fd ff ff       	call   801a3b <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	c9                   	leave  
  801d26:	c3                   	ret    

00801d27 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d27:	55                   	push   %ebp
  801d28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	52                   	push   %edx
  801d37:	50                   	push   %eax
  801d38:	6a 1c                	push   $0x1c
  801d3a:	e8 fc fc ff ff       	call   801a3b <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d47:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	51                   	push   %ecx
  801d55:	52                   	push   %edx
  801d56:	50                   	push   %eax
  801d57:	6a 1d                	push   $0x1d
  801d59:	e8 dd fc ff ff       	call   801a3b <syscall>
  801d5e:	83 c4 18             	add    $0x18,%esp
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	6a 1e                	push   $0x1e
  801d76:	e8 c0 fc ff ff       	call   801a3b <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 1f                	push   $0x1f
  801d8f:	e8 a7 fc ff ff       	call   801a3b <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
}
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	ff 75 14             	pushl  0x14(%ebp)
  801da4:	ff 75 10             	pushl  0x10(%ebp)
  801da7:	ff 75 0c             	pushl  0xc(%ebp)
  801daa:	50                   	push   %eax
  801dab:	6a 20                	push   $0x20
  801dad:	e8 89 fc ff ff       	call   801a3b <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	50                   	push   %eax
  801dc6:	6a 21                	push   $0x21
  801dc8:	e8 6e fc ff ff       	call   801a3b <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	90                   	nop
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	50                   	push   %eax
  801de2:	6a 22                	push   $0x22
  801de4:	e8 52 fc ff ff       	call   801a3b <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 02                	push   $0x2
  801dfd:	e8 39 fc ff ff       	call   801a3b <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 03                	push   $0x3
  801e16:	e8 20 fc ff ff       	call   801a3b <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 04                	push   $0x4
  801e2f:	e8 07 fc ff ff       	call   801a3b <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_exit_env>:


void sys_exit_env(void)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 23                	push   $0x23
  801e48:	e8 ee fb ff ff       	call   801a3b <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	90                   	nop
  801e51:	c9                   	leave  
  801e52:	c3                   	ret    

00801e53 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e5c:	8d 50 04             	lea    0x4(%eax),%edx
  801e5f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	52                   	push   %edx
  801e69:	50                   	push   %eax
  801e6a:	6a 24                	push   $0x24
  801e6c:	e8 ca fb ff ff       	call   801a3b <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
	return result;
  801e74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e77:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e7a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e7d:	89 01                	mov    %eax,(%ecx)
  801e7f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	c9                   	leave  
  801e86:	c2 04 00             	ret    $0x4

00801e89 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	ff 75 10             	pushl  0x10(%ebp)
  801e93:	ff 75 0c             	pushl  0xc(%ebp)
  801e96:	ff 75 08             	pushl  0x8(%ebp)
  801e99:	6a 12                	push   $0x12
  801e9b:	e8 9b fb ff ff       	call   801a3b <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea3:	90                   	nop
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 25                	push   $0x25
  801eb5:	e8 81 fb ff ff       	call   801a3b <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	83 ec 04             	sub    $0x4,%esp
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ecb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	50                   	push   %eax
  801ed8:	6a 26                	push   $0x26
  801eda:	e8 5c fb ff ff       	call   801a3b <syscall>
  801edf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee2:	90                   	nop
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <rsttst>:
void rsttst()
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 28                	push   $0x28
  801ef4:	e8 42 fb ff ff       	call   801a3b <syscall>
  801ef9:	83 c4 18             	add    $0x18,%esp
	return ;
  801efc:	90                   	nop
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 04             	sub    $0x4,%esp
  801f05:	8b 45 14             	mov    0x14(%ebp),%eax
  801f08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f0b:	8b 55 18             	mov    0x18(%ebp),%edx
  801f0e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f12:	52                   	push   %edx
  801f13:	50                   	push   %eax
  801f14:	ff 75 10             	pushl  0x10(%ebp)
  801f17:	ff 75 0c             	pushl  0xc(%ebp)
  801f1a:	ff 75 08             	pushl  0x8(%ebp)
  801f1d:	6a 27                	push   $0x27
  801f1f:	e8 17 fb ff ff       	call   801a3b <syscall>
  801f24:	83 c4 18             	add    $0x18,%esp
	return ;
  801f27:	90                   	nop
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <chktst>:
void chktst(uint32 n)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	ff 75 08             	pushl  0x8(%ebp)
  801f38:	6a 29                	push   $0x29
  801f3a:	e8 fc fa ff ff       	call   801a3b <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f42:	90                   	nop
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <inctst>:

void inctst()
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 2a                	push   $0x2a
  801f54:	e8 e2 fa ff ff       	call   801a3b <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5c:	90                   	nop
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <gettst>:
uint32 gettst()
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 2b                	push   $0x2b
  801f6e:	e8 c8 fa ff ff       	call   801a3b <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 2c                	push   $0x2c
  801f8a:	e8 ac fa ff ff       	call   801a3b <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
  801f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f95:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f99:	75 07                	jne    801fa2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa0:	eb 05                	jmp    801fa7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
  801fac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 2c                	push   $0x2c
  801fbb:	e8 7b fa ff ff       	call   801a3b <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
  801fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fc6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fca:	75 07                	jne    801fd3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fcc:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd1:	eb 05                	jmp    801fd8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 2c                	push   $0x2c
  801fec:	e8 4a fa ff ff       	call   801a3b <syscall>
  801ff1:	83 c4 18             	add    $0x18,%esp
  801ff4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ff7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ffb:	75 07                	jne    802004 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ffd:	b8 01 00 00 00       	mov    $0x1,%eax
  802002:	eb 05                	jmp    802009 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802004:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 2c                	push   $0x2c
  80201d:	e8 19 fa ff ff       	call   801a3b <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
  802025:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802028:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80202c:	75 07                	jne    802035 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80202e:	b8 01 00 00 00       	mov    $0x1,%eax
  802033:	eb 05                	jmp    80203a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	ff 75 08             	pushl  0x8(%ebp)
  80204a:	6a 2d                	push   $0x2d
  80204c:	e8 ea f9 ff ff       	call   801a3b <syscall>
  802051:	83 c4 18             	add    $0x18,%esp
	return ;
  802054:	90                   	nop
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80205b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80205e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802061:	8b 55 0c             	mov    0xc(%ebp),%edx
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	6a 00                	push   $0x0
  802069:	53                   	push   %ebx
  80206a:	51                   	push   %ecx
  80206b:	52                   	push   %edx
  80206c:	50                   	push   %eax
  80206d:	6a 2e                	push   $0x2e
  80206f:	e8 c7 f9 ff ff       	call   801a3b <syscall>
  802074:	83 c4 18             	add    $0x18,%esp
}
  802077:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80207f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	52                   	push   %edx
  80208c:	50                   	push   %eax
  80208d:	6a 2f                	push   $0x2f
  80208f:	e8 a7 f9 ff ff       	call   801a3b <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80209f:	83 ec 0c             	sub    $0xc,%esp
  8020a2:	68 00 3e 80 00       	push   $0x803e00
  8020a7:	e8 c3 e6 ff ff       	call   80076f <cprintf>
  8020ac:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020b6:	83 ec 0c             	sub    $0xc,%esp
  8020b9:	68 2c 3e 80 00       	push   $0x803e2c
  8020be:	e8 ac e6 ff ff       	call   80076f <cprintf>
  8020c3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020c6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8020cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d2:	eb 56                	jmp    80212a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d8:	74 1c                	je     8020f6 <print_mem_block_lists+0x5d>
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	8b 50 08             	mov    0x8(%eax),%edx
  8020e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e3:	8b 48 08             	mov    0x8(%eax),%ecx
  8020e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ec:	01 c8                	add    %ecx,%eax
  8020ee:	39 c2                	cmp    %eax,%edx
  8020f0:	73 04                	jae    8020f6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020f2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	8b 50 08             	mov    0x8(%eax),%edx
  8020fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802102:	01 c2                	add    %eax,%edx
  802104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802107:	8b 40 08             	mov    0x8(%eax),%eax
  80210a:	83 ec 04             	sub    $0x4,%esp
  80210d:	52                   	push   %edx
  80210e:	50                   	push   %eax
  80210f:	68 41 3e 80 00       	push   $0x803e41
  802114:	e8 56 e6 ff ff       	call   80076f <cprintf>
  802119:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802122:	a1 40 41 80 00       	mov    0x804140,%eax
  802127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212e:	74 07                	je     802137 <print_mem_block_lists+0x9e>
  802130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802133:	8b 00                	mov    (%eax),%eax
  802135:	eb 05                	jmp    80213c <print_mem_block_lists+0xa3>
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
  80213c:	a3 40 41 80 00       	mov    %eax,0x804140
  802141:	a1 40 41 80 00       	mov    0x804140,%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	75 8a                	jne    8020d4 <print_mem_block_lists+0x3b>
  80214a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214e:	75 84                	jne    8020d4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802150:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802154:	75 10                	jne    802166 <print_mem_block_lists+0xcd>
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	68 50 3e 80 00       	push   $0x803e50
  80215e:	e8 0c e6 ff ff       	call   80076f <cprintf>
  802163:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802166:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	68 74 3e 80 00       	push   $0x803e74
  802175:	e8 f5 e5 ff ff       	call   80076f <cprintf>
  80217a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80217d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802181:	a1 40 40 80 00       	mov    0x804040,%eax
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802189:	eb 56                	jmp    8021e1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80218b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218f:	74 1c                	je     8021ad <print_mem_block_lists+0x114>
  802191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802194:	8b 50 08             	mov    0x8(%eax),%edx
  802197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219a:	8b 48 08             	mov    0x8(%eax),%ecx
  80219d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a3:	01 c8                	add    %ecx,%eax
  8021a5:	39 c2                	cmp    %eax,%edx
  8021a7:	73 04                	jae    8021ad <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021a9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	8b 50 08             	mov    0x8(%eax),%edx
  8021b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b9:	01 c2                	add    %eax,%edx
  8021bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021be:	8b 40 08             	mov    0x8(%eax),%eax
  8021c1:	83 ec 04             	sub    $0x4,%esp
  8021c4:	52                   	push   %edx
  8021c5:	50                   	push   %eax
  8021c6:	68 41 3e 80 00       	push   $0x803e41
  8021cb:	e8 9f e5 ff ff       	call   80076f <cprintf>
  8021d0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021d9:	a1 48 40 80 00       	mov    0x804048,%eax
  8021de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e5:	74 07                	je     8021ee <print_mem_block_lists+0x155>
  8021e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ea:	8b 00                	mov    (%eax),%eax
  8021ec:	eb 05                	jmp    8021f3 <print_mem_block_lists+0x15a>
  8021ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f3:	a3 48 40 80 00       	mov    %eax,0x804048
  8021f8:	a1 48 40 80 00       	mov    0x804048,%eax
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	75 8a                	jne    80218b <print_mem_block_lists+0xf2>
  802201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802205:	75 84                	jne    80218b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802207:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80220b:	75 10                	jne    80221d <print_mem_block_lists+0x184>
  80220d:	83 ec 0c             	sub    $0xc,%esp
  802210:	68 8c 3e 80 00       	push   $0x803e8c
  802215:	e8 55 e5 ff ff       	call   80076f <cprintf>
  80221a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80221d:	83 ec 0c             	sub    $0xc,%esp
  802220:	68 00 3e 80 00       	push   $0x803e00
  802225:	e8 45 e5 ff ff       	call   80076f <cprintf>
  80222a:	83 c4 10             	add    $0x10,%esp

}
  80222d:	90                   	nop
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802236:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80223d:	00 00 00 
  802240:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802247:	00 00 00 
  80224a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802251:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802254:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80225b:	e9 9e 00 00 00       	jmp    8022fe <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  802260:	a1 50 40 80 00       	mov    0x804050,%eax
  802265:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802268:	c1 e2 04             	shl    $0x4,%edx
  80226b:	01 d0                	add    %edx,%eax
  80226d:	85 c0                	test   %eax,%eax
  80226f:	75 14                	jne    802285 <initialize_MemBlocksList+0x55>
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	68 b4 3e 80 00       	push   $0x803eb4
  802279:	6a 47                	push   $0x47
  80227b:	68 d7 3e 80 00       	push   $0x803ed7
  802280:	e8 36 e2 ff ff       	call   8004bb <_panic>
  802285:	a1 50 40 80 00       	mov    0x804050,%eax
  80228a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228d:	c1 e2 04             	shl    $0x4,%edx
  802290:	01 d0                	add    %edx,%eax
  802292:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802298:	89 10                	mov    %edx,(%eax)
  80229a:	8b 00                	mov    (%eax),%eax
  80229c:	85 c0                	test   %eax,%eax
  80229e:	74 18                	je     8022b8 <initialize_MemBlocksList+0x88>
  8022a0:	a1 48 41 80 00       	mov    0x804148,%eax
  8022a5:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8022ab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022ae:	c1 e1 04             	shl    $0x4,%ecx
  8022b1:	01 ca                	add    %ecx,%edx
  8022b3:	89 50 04             	mov    %edx,0x4(%eax)
  8022b6:	eb 12                	jmp    8022ca <initialize_MemBlocksList+0x9a>
  8022b8:	a1 50 40 80 00       	mov    0x804050,%eax
  8022bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c0:	c1 e2 04             	shl    $0x4,%edx
  8022c3:	01 d0                	add    %edx,%eax
  8022c5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022ca:	a1 50 40 80 00       	mov    0x804050,%eax
  8022cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d2:	c1 e2 04             	shl    $0x4,%edx
  8022d5:	01 d0                	add    %edx,%eax
  8022d7:	a3 48 41 80 00       	mov    %eax,0x804148
  8022dc:	a1 50 40 80 00       	mov    0x804050,%eax
  8022e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e4:	c1 e2 04             	shl    $0x4,%edx
  8022e7:	01 d0                	add    %edx,%eax
  8022e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f0:	a1 54 41 80 00       	mov    0x804154,%eax
  8022f5:	40                   	inc    %eax
  8022f6:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8022fb:	ff 45 f4             	incl   -0xc(%ebp)
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	3b 45 08             	cmp    0x8(%ebp),%eax
  802304:	0f 82 56 ff ff ff    	jb     802260 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80230a:	90                   	nop
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80231b:	eb 19                	jmp    802336 <find_block+0x29>
	{
		if(element->sva == va){
  80231d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802320:	8b 40 08             	mov    0x8(%eax),%eax
  802323:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802326:	75 05                	jne    80232d <find_block+0x20>
			 		return element;
  802328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80232b:	eb 36                	jmp    802363 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	8b 40 08             	mov    0x8(%eax),%eax
  802333:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802336:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80233a:	74 07                	je     802343 <find_block+0x36>
  80233c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	eb 05                	jmp    802348 <find_block+0x3b>
  802343:	b8 00 00 00 00       	mov    $0x0,%eax
  802348:	8b 55 08             	mov    0x8(%ebp),%edx
  80234b:	89 42 08             	mov    %eax,0x8(%edx)
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	8b 40 08             	mov    0x8(%eax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	75 c5                	jne    80231d <find_block+0x10>
  802358:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235c:	75 bf                	jne    80231d <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  80236b:	a1 44 40 80 00       	mov    0x804044,%eax
  802370:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  802373:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802378:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  80237b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80237f:	74 0a                	je     80238b <insert_sorted_allocList+0x26>
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	8b 40 08             	mov    0x8(%eax),%eax
  802387:	85 c0                	test   %eax,%eax
  802389:	75 65                	jne    8023f0 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80238b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238f:	75 14                	jne    8023a5 <insert_sorted_allocList+0x40>
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	68 b4 3e 80 00       	push   $0x803eb4
  802399:	6a 6e                	push   $0x6e
  80239b:	68 d7 3e 80 00       	push   $0x803ed7
  8023a0:	e8 16 e1 ff ff       	call   8004bb <_panic>
  8023a5:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	89 10                	mov    %edx,(%eax)
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	8b 00                	mov    (%eax),%eax
  8023b5:	85 c0                	test   %eax,%eax
  8023b7:	74 0d                	je     8023c6 <insert_sorted_allocList+0x61>
  8023b9:	a1 40 40 80 00       	mov    0x804040,%eax
  8023be:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c1:	89 50 04             	mov    %edx,0x4(%eax)
  8023c4:	eb 08                	jmp    8023ce <insert_sorted_allocList+0x69>
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	a3 44 40 80 00       	mov    %eax,0x804044
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	a3 40 40 80 00       	mov    %eax,0x804040
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023e5:	40                   	inc    %eax
  8023e6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023eb:	e9 cf 01 00 00       	jmp    8025bf <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8023f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f3:	8b 50 08             	mov    0x8(%eax),%edx
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	8b 40 08             	mov    0x8(%eax),%eax
  8023fc:	39 c2                	cmp    %eax,%edx
  8023fe:	73 65                	jae    802465 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802400:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802404:	75 14                	jne    80241a <insert_sorted_allocList+0xb5>
  802406:	83 ec 04             	sub    $0x4,%esp
  802409:	68 f0 3e 80 00       	push   $0x803ef0
  80240e:	6a 72                	push   $0x72
  802410:	68 d7 3e 80 00       	push   $0x803ed7
  802415:	e8 a1 e0 ff ff       	call   8004bb <_panic>
  80241a:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	89 50 04             	mov    %edx,0x4(%eax)
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	8b 40 04             	mov    0x4(%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 0c                	je     80243c <insert_sorted_allocList+0xd7>
  802430:	a1 44 40 80 00       	mov    0x804044,%eax
  802435:	8b 55 08             	mov    0x8(%ebp),%edx
  802438:	89 10                	mov    %edx,(%eax)
  80243a:	eb 08                	jmp    802444 <insert_sorted_allocList+0xdf>
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	a3 40 40 80 00       	mov    %eax,0x804040
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	a3 44 40 80 00       	mov    %eax,0x804044
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802455:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80245a:	40                   	inc    %eax
  80245b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  802460:	e9 5a 01 00 00       	jmp    8025bf <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802468:	8b 50 08             	mov    0x8(%eax),%edx
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	8b 40 08             	mov    0x8(%eax),%eax
  802471:	39 c2                	cmp    %eax,%edx
  802473:	75 70                	jne    8024e5 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802475:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802479:	74 06                	je     802481 <insert_sorted_allocList+0x11c>
  80247b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80247f:	75 14                	jne    802495 <insert_sorted_allocList+0x130>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 14 3f 80 00       	push   $0x803f14
  802489:	6a 75                	push   $0x75
  80248b:	68 d7 3e 80 00       	push   $0x803ed7
  802490:	e8 26 e0 ff ff       	call   8004bb <_panic>
  802495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802498:	8b 10                	mov    (%eax),%edx
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	89 10                	mov    %edx,(%eax)
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	8b 00                	mov    (%eax),%eax
  8024a4:	85 c0                	test   %eax,%eax
  8024a6:	74 0b                	je     8024b3 <insert_sorted_allocList+0x14e>
  8024a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b0:	89 50 04             	mov    %edx,0x4(%eax)
  8024b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b9:	89 10                	mov    %edx,(%eax)
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c1:	89 50 04             	mov    %edx,0x4(%eax)
  8024c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c7:	8b 00                	mov    (%eax),%eax
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	75 08                	jne    8024d5 <insert_sorted_allocList+0x170>
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	a3 44 40 80 00       	mov    %eax,0x804044
  8024d5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024da:	40                   	inc    %eax
  8024db:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8024e0:	e9 da 00 00 00       	jmp    8025bf <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8024e5:	a1 40 40 80 00       	mov    0x804040,%eax
  8024ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ed:	e9 9d 00 00 00       	jmp    80258f <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	8b 50 08             	mov    0x8(%eax),%edx
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 08             	mov    0x8(%eax),%eax
  802506:	39 c2                	cmp    %eax,%edx
  802508:	76 7d                	jbe    802587 <insert_sorted_allocList+0x222>
  80250a:	8b 45 08             	mov    0x8(%ebp),%eax
  80250d:	8b 50 08             	mov    0x8(%eax),%edx
  802510:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802513:	8b 40 08             	mov    0x8(%eax),%eax
  802516:	39 c2                	cmp    %eax,%edx
  802518:	73 6d                	jae    802587 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80251a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251e:	74 06                	je     802526 <insert_sorted_allocList+0x1c1>
  802520:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802524:	75 14                	jne    80253a <insert_sorted_allocList+0x1d5>
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 14 3f 80 00       	push   $0x803f14
  80252e:	6a 7c                	push   $0x7c
  802530:	68 d7 3e 80 00       	push   $0x803ed7
  802535:	e8 81 df ff ff       	call   8004bb <_panic>
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 10                	mov    (%eax),%edx
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	89 10                	mov    %edx,(%eax)
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	74 0b                	je     802558 <insert_sorted_allocList+0x1f3>
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	8b 55 08             	mov    0x8(%ebp),%edx
  802555:	89 50 04             	mov    %edx,0x4(%eax)
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 55 08             	mov    0x8(%ebp),%edx
  80255e:	89 10                	mov    %edx,(%eax)
  802560:	8b 45 08             	mov    0x8(%ebp),%eax
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	89 50 04             	mov    %edx,0x4(%eax)
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	75 08                	jne    80257a <insert_sorted_allocList+0x215>
  802572:	8b 45 08             	mov    0x8(%ebp),%eax
  802575:	a3 44 40 80 00       	mov    %eax,0x804044
  80257a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80257f:	40                   	inc    %eax
  802580:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802585:	eb 38                	jmp    8025bf <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802587:	a1 48 40 80 00       	mov    0x804048,%eax
  80258c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802593:	74 07                	je     80259c <insert_sorted_allocList+0x237>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	eb 05                	jmp    8025a1 <insert_sorted_allocList+0x23c>
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a1:	a3 48 40 80 00       	mov    %eax,0x804048
  8025a6:	a1 48 40 80 00       	mov    0x804048,%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	0f 85 3f ff ff ff    	jne    8024f2 <insert_sorted_allocList+0x18d>
  8025b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b7:	0f 85 35 ff ff ff    	jne    8024f2 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8025bd:	eb 00                	jmp    8025bf <insert_sorted_allocList+0x25a>
  8025bf:	90                   	nop
  8025c0:	c9                   	leave  
  8025c1:	c3                   	ret    

008025c2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025c8:	a1 38 41 80 00       	mov    0x804138,%eax
  8025cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d0:	e9 6b 02 00 00       	jmp    802840 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025de:	0f 85 90 00 00 00    	jne    802674 <alloc_block_FF+0xb2>
			  temp=element;
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8025ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ee:	75 17                	jne    802607 <alloc_block_FF+0x45>
  8025f0:	83 ec 04             	sub    $0x4,%esp
  8025f3:	68 48 3f 80 00       	push   $0x803f48
  8025f8:	68 92 00 00 00       	push   $0x92
  8025fd:	68 d7 3e 80 00       	push   $0x803ed7
  802602:	e8 b4 de ff ff       	call   8004bb <_panic>
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	85 c0                	test   %eax,%eax
  80260e:	74 10                	je     802620 <alloc_block_FF+0x5e>
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 00                	mov    (%eax),%eax
  802615:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802618:	8b 52 04             	mov    0x4(%edx),%edx
  80261b:	89 50 04             	mov    %edx,0x4(%eax)
  80261e:	eb 0b                	jmp    80262b <alloc_block_FF+0x69>
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 04             	mov    0x4(%eax),%eax
  802626:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 40 04             	mov    0x4(%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	74 0f                	je     802644 <alloc_block_FF+0x82>
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263e:	8b 12                	mov    (%edx),%edx
  802640:	89 10                	mov    %edx,(%eax)
  802642:	eb 0a                	jmp    80264e <alloc_block_FF+0x8c>
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 00                	mov    (%eax),%eax
  802649:	a3 38 41 80 00       	mov    %eax,0x804138
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802661:	a1 44 41 80 00       	mov    0x804144,%eax
  802666:	48                   	dec    %eax
  802667:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  80266c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266f:	e9 ff 01 00 00       	jmp    802873 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 0c             	mov    0xc(%eax),%eax
  80267a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267d:	0f 86 b5 01 00 00    	jbe    802838 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 40 0c             	mov    0xc(%eax),%eax
  802689:	2b 45 08             	sub    0x8(%ebp),%eax
  80268c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80268f:	a1 48 41 80 00       	mov    0x804148,%eax
  802694:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802697:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80269b:	75 17                	jne    8026b4 <alloc_block_FF+0xf2>
  80269d:	83 ec 04             	sub    $0x4,%esp
  8026a0:	68 48 3f 80 00       	push   $0x803f48
  8026a5:	68 99 00 00 00       	push   $0x99
  8026aa:	68 d7 3e 80 00       	push   $0x803ed7
  8026af:	e8 07 de ff ff       	call   8004bb <_panic>
  8026b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b7:	8b 00                	mov    (%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 10                	je     8026cd <alloc_block_FF+0x10b>
  8026bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026c5:	8b 52 04             	mov    0x4(%edx),%edx
  8026c8:	89 50 04             	mov    %edx,0x4(%eax)
  8026cb:	eb 0b                	jmp    8026d8 <alloc_block_FF+0x116>
  8026cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d0:	8b 40 04             	mov    0x4(%eax),%eax
  8026d3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026db:	8b 40 04             	mov    0x4(%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	74 0f                	je     8026f1 <alloc_block_FF+0x12f>
  8026e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e5:	8b 40 04             	mov    0x4(%eax),%eax
  8026e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026eb:	8b 12                	mov    (%edx),%edx
  8026ed:	89 10                	mov    %edx,(%eax)
  8026ef:	eb 0a                	jmp    8026fb <alloc_block_FF+0x139>
  8026f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f4:	8b 00                	mov    (%eax),%eax
  8026f6:	a3 48 41 80 00       	mov    %eax,0x804148
  8026fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802707:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270e:	a1 54 41 80 00       	mov    0x804154,%eax
  802713:	48                   	dec    %eax
  802714:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802719:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80271d:	75 17                	jne    802736 <alloc_block_FF+0x174>
  80271f:	83 ec 04             	sub    $0x4,%esp
  802722:	68 f0 3e 80 00       	push   $0x803ef0
  802727:	68 9a 00 00 00       	push   $0x9a
  80272c:	68 d7 3e 80 00       	push   $0x803ed7
  802731:	e8 85 dd ff ff       	call   8004bb <_panic>
  802736:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80273c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273f:	89 50 04             	mov    %edx,0x4(%eax)
  802742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802745:	8b 40 04             	mov    0x4(%eax),%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	74 0c                	je     802758 <alloc_block_FF+0x196>
  80274c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802751:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802754:	89 10                	mov    %edx,(%eax)
  802756:	eb 08                	jmp    802760 <alloc_block_FF+0x19e>
  802758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275b:	a3 38 41 80 00       	mov    %eax,0x804138
  802760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802763:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802771:	a1 44 41 80 00       	mov    0x804144,%eax
  802776:	40                   	inc    %eax
  802777:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  80277c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277f:	8b 55 08             	mov    0x8(%ebp),%edx
  802782:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 50 08             	mov    0x8(%eax),%edx
  80278b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278e:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802797:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 50 08             	mov    0x8(%eax),%edx
  8027a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a3:	01 c2                	add    %eax,%edx
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  8027ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  8027b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027b5:	75 17                	jne    8027ce <alloc_block_FF+0x20c>
  8027b7:	83 ec 04             	sub    $0x4,%esp
  8027ba:	68 48 3f 80 00       	push   $0x803f48
  8027bf:	68 a2 00 00 00       	push   $0xa2
  8027c4:	68 d7 3e 80 00       	push   $0x803ed7
  8027c9:	e8 ed dc ff ff       	call   8004bb <_panic>
  8027ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 10                	je     8027e7 <alloc_block_FF+0x225>
  8027d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027df:	8b 52 04             	mov    0x4(%edx),%edx
  8027e2:	89 50 04             	mov    %edx,0x4(%eax)
  8027e5:	eb 0b                	jmp    8027f2 <alloc_block_FF+0x230>
  8027e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ea:	8b 40 04             	mov    0x4(%eax),%eax
  8027ed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f5:	8b 40 04             	mov    0x4(%eax),%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	74 0f                	je     80280b <alloc_block_FF+0x249>
  8027fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ff:	8b 40 04             	mov    0x4(%eax),%eax
  802802:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802805:	8b 12                	mov    (%edx),%edx
  802807:	89 10                	mov    %edx,(%eax)
  802809:	eb 0a                	jmp    802815 <alloc_block_FF+0x253>
  80280b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	a3 38 41 80 00       	mov    %eax,0x804138
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802828:	a1 44 41 80 00       	mov    0x804144,%eax
  80282d:	48                   	dec    %eax
  80282e:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  802833:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802836:	eb 3b                	jmp    802873 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802838:	a1 40 41 80 00       	mov    0x804140,%eax
  80283d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802844:	74 07                	je     80284d <alloc_block_FF+0x28b>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	eb 05                	jmp    802852 <alloc_block_FF+0x290>
  80284d:	b8 00 00 00 00       	mov    $0x0,%eax
  802852:	a3 40 41 80 00       	mov    %eax,0x804140
  802857:	a1 40 41 80 00       	mov    0x804140,%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	0f 85 71 fd ff ff    	jne    8025d5 <alloc_block_FF+0x13>
  802864:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802868:	0f 85 67 fd ff ff    	jne    8025d5 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80286e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802873:	c9                   	leave  
  802874:	c3                   	ret    

00802875 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802875:	55                   	push   %ebp
  802876:	89 e5                	mov    %esp,%ebp
  802878:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  80287b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802882:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802889:	a1 38 41 80 00       	mov    0x804138,%eax
  80288e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802891:	e9 d3 00 00 00       	jmp    802969 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802896:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802899:	8b 40 0c             	mov    0xc(%eax),%eax
  80289c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289f:	0f 85 90 00 00 00    	jne    802935 <alloc_block_BF+0xc0>
	   temp = element;
  8028a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a8:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  8028ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028af:	75 17                	jne    8028c8 <alloc_block_BF+0x53>
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 48 3f 80 00       	push   $0x803f48
  8028b9:	68 bd 00 00 00       	push   $0xbd
  8028be:	68 d7 3e 80 00       	push   $0x803ed7
  8028c3:	e8 f3 db ff ff       	call   8004bb <_panic>
  8028c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 10                	je     8028e1 <alloc_block_BF+0x6c>
  8028d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028d9:	8b 52 04             	mov    0x4(%edx),%edx
  8028dc:	89 50 04             	mov    %edx,0x4(%eax)
  8028df:	eb 0b                	jmp    8028ec <alloc_block_BF+0x77>
  8028e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e4:	8b 40 04             	mov    0x4(%eax),%eax
  8028e7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ef:	8b 40 04             	mov    0x4(%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 0f                	je     802905 <alloc_block_BF+0x90>
  8028f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028ff:	8b 12                	mov    (%edx),%edx
  802901:	89 10                	mov    %edx,(%eax)
  802903:	eb 0a                	jmp    80290f <alloc_block_BF+0x9a>
  802905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	a3 38 41 80 00       	mov    %eax,0x804138
  80290f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802922:	a1 44 41 80 00       	mov    0x804144,%eax
  802927:	48                   	dec    %eax
  802928:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  80292d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802930:	e9 41 01 00 00       	jmp    802a76 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802938:	8b 40 0c             	mov    0xc(%eax),%eax
  80293b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293e:	76 21                	jbe    802961 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802943:	8b 40 0c             	mov    0xc(%eax),%eax
  802946:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802949:	73 16                	jae    802961 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  80294b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294e:	8b 40 0c             	mov    0xc(%eax),%eax
  802951:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802954:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802957:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  80295a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802961:	a1 40 41 80 00       	mov    0x804140,%eax
  802966:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802969:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80296d:	74 07                	je     802976 <alloc_block_BF+0x101>
  80296f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802972:	8b 00                	mov    (%eax),%eax
  802974:	eb 05                	jmp    80297b <alloc_block_BF+0x106>
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
  80297b:	a3 40 41 80 00       	mov    %eax,0x804140
  802980:	a1 40 41 80 00       	mov    0x804140,%eax
  802985:	85 c0                	test   %eax,%eax
  802987:	0f 85 09 ff ff ff    	jne    802896 <alloc_block_BF+0x21>
  80298d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802991:	0f 85 ff fe ff ff    	jne    802896 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802997:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80299b:	0f 85 d0 00 00 00    	jne    802a71 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  8029a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8029aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  8029ad:	a1 48 41 80 00       	mov    0x804148,%eax
  8029b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8029b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029b9:	75 17                	jne    8029d2 <alloc_block_BF+0x15d>
  8029bb:	83 ec 04             	sub    $0x4,%esp
  8029be:	68 48 3f 80 00       	push   $0x803f48
  8029c3:	68 d1 00 00 00       	push   $0xd1
  8029c8:	68 d7 3e 80 00       	push   $0x803ed7
  8029cd:	e8 e9 da ff ff       	call   8004bb <_panic>
  8029d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	74 10                	je     8029eb <alloc_block_BF+0x176>
  8029db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029e3:	8b 52 04             	mov    0x4(%edx),%edx
  8029e6:	89 50 04             	mov    %edx,0x4(%eax)
  8029e9:	eb 0b                	jmp    8029f6 <alloc_block_BF+0x181>
  8029eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ee:	8b 40 04             	mov    0x4(%eax),%eax
  8029f1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029f9:	8b 40 04             	mov    0x4(%eax),%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	74 0f                	je     802a0f <alloc_block_BF+0x19a>
  802a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a03:	8b 40 04             	mov    0x4(%eax),%eax
  802a06:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802a09:	8b 12                	mov    (%edx),%edx
  802a0b:	89 10                	mov    %edx,(%eax)
  802a0d:	eb 0a                	jmp    802a19 <alloc_block_BF+0x1a4>
  802a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	a3 48 41 80 00       	mov    %eax,0x804148
  802a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2c:	a1 54 41 80 00       	mov    0x804154,%eax
  802a31:	48                   	dec    %eax
  802a32:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802a37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3d:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a43:	8b 50 08             	mov    0x8(%eax),%edx
  802a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a49:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a52:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a58:	8b 50 08             	mov    0x8(%eax),%edx
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	01 c2                	add    %eax,%edx
  802a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a63:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a69:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a6f:	eb 05                	jmp    802a76 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802a71:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802a76:	c9                   	leave  
  802a77:	c3                   	ret    

00802a78 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a78:	55                   	push   %ebp
  802a79:	89 e5                	mov    %esp,%ebp
  802a7b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a7e:	83 ec 04             	sub    $0x4,%esp
  802a81:	68 68 3f 80 00       	push   $0x803f68
  802a86:	68 e8 00 00 00       	push   $0xe8
  802a8b:	68 d7 3e 80 00       	push   $0x803ed7
  802a90:	e8 26 da ff ff       	call   8004bb <_panic>

00802a95 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a95:	55                   	push   %ebp
  802a96:	89 e5                	mov    %esp,%ebp
  802a98:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802a9b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802aa3:	a1 38 41 80 00       	mov    0x804138,%eax
  802aa8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802aab:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802ab3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab7:	75 68                	jne    802b21 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ab9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802abd:	75 17                	jne    802ad6 <insert_sorted_with_merge_freeList+0x41>
  802abf:	83 ec 04             	sub    $0x4,%esp
  802ac2:	68 b4 3e 80 00       	push   $0x803eb4
  802ac7:	68 36 01 00 00       	push   $0x136
  802acc:	68 d7 3e 80 00       	push   $0x803ed7
  802ad1:	e8 e5 d9 ff ff       	call   8004bb <_panic>
  802ad6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802adc:	8b 45 08             	mov    0x8(%ebp),%eax
  802adf:	89 10                	mov    %edx,(%eax)
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	8b 00                	mov    (%eax),%eax
  802ae6:	85 c0                	test   %eax,%eax
  802ae8:	74 0d                	je     802af7 <insert_sorted_with_merge_freeList+0x62>
  802aea:	a1 38 41 80 00       	mov    0x804138,%eax
  802aef:	8b 55 08             	mov    0x8(%ebp),%edx
  802af2:	89 50 04             	mov    %edx,0x4(%eax)
  802af5:	eb 08                	jmp    802aff <insert_sorted_with_merge_freeList+0x6a>
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	a3 38 41 80 00       	mov    %eax,0x804138
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b11:	a1 44 41 80 00       	mov    0x804144,%eax
  802b16:	40                   	inc    %eax
  802b17:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b1c:	e9 ba 06 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	8b 50 08             	mov    0x8(%eax),%edx
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2d:	01 c2                	add    %eax,%edx
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	8b 40 08             	mov    0x8(%eax),%eax
  802b35:	39 c2                	cmp    %eax,%edx
  802b37:	73 68                	jae    802ba1 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3d:	75 17                	jne    802b56 <insert_sorted_with_merge_freeList+0xc1>
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 f0 3e 80 00       	push   $0x803ef0
  802b47:	68 3a 01 00 00       	push   $0x13a
  802b4c:	68 d7 3e 80 00       	push   $0x803ed7
  802b51:	e8 65 d9 ff ff       	call   8004bb <_panic>
  802b56:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	89 50 04             	mov    %edx,0x4(%eax)
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	85 c0                	test   %eax,%eax
  802b6a:	74 0c                	je     802b78 <insert_sorted_with_merge_freeList+0xe3>
  802b6c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b71:	8b 55 08             	mov    0x8(%ebp),%edx
  802b74:	89 10                	mov    %edx,(%eax)
  802b76:	eb 08                	jmp    802b80 <insert_sorted_with_merge_freeList+0xeb>
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	a3 38 41 80 00       	mov    %eax,0x804138
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b91:	a1 44 41 80 00       	mov    0x804144,%eax
  802b96:	40                   	inc    %eax
  802b97:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b9c:	e9 3a 06 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba4:	8b 50 08             	mov    0x8(%eax),%edx
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bad:	01 c2                	add    %eax,%edx
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 40 08             	mov    0x8(%eax),%eax
  802bb5:	39 c2                	cmp    %eax,%edx
  802bb7:	0f 85 90 00 00 00    	jne    802c4d <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc0:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc9:	01 c2                	add    %eax,%edx
  802bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bce:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802be5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be9:	75 17                	jne    802c02 <insert_sorted_with_merge_freeList+0x16d>
  802beb:	83 ec 04             	sub    $0x4,%esp
  802bee:	68 b4 3e 80 00       	push   $0x803eb4
  802bf3:	68 41 01 00 00       	push   $0x141
  802bf8:	68 d7 3e 80 00       	push   $0x803ed7
  802bfd:	e8 b9 d8 ff ff       	call   8004bb <_panic>
  802c02:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	89 10                	mov    %edx,(%eax)
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	8b 00                	mov    (%eax),%eax
  802c12:	85 c0                	test   %eax,%eax
  802c14:	74 0d                	je     802c23 <insert_sorted_with_merge_freeList+0x18e>
  802c16:	a1 48 41 80 00       	mov    0x804148,%eax
  802c1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1e:	89 50 04             	mov    %edx,0x4(%eax)
  802c21:	eb 08                	jmp    802c2b <insert_sorted_with_merge_freeList+0x196>
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	a3 48 41 80 00       	mov    %eax,0x804148
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3d:	a1 54 41 80 00       	mov    0x804154,%eax
  802c42:	40                   	inc    %eax
  802c43:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c48:	e9 8e 05 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	8b 50 08             	mov    0x8(%eax),%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 40 0c             	mov    0xc(%eax),%eax
  802c59:	01 c2                	add    %eax,%edx
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	8b 40 08             	mov    0x8(%eax),%eax
  802c61:	39 c2                	cmp    %eax,%edx
  802c63:	73 68                	jae    802ccd <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c69:	75 17                	jne    802c82 <insert_sorted_with_merge_freeList+0x1ed>
  802c6b:	83 ec 04             	sub    $0x4,%esp
  802c6e:	68 b4 3e 80 00       	push   $0x803eb4
  802c73:	68 45 01 00 00       	push   $0x145
  802c78:	68 d7 3e 80 00       	push   $0x803ed7
  802c7d:	e8 39 d8 ff ff       	call   8004bb <_panic>
  802c82:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	89 10                	mov    %edx,(%eax)
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	85 c0                	test   %eax,%eax
  802c94:	74 0d                	je     802ca3 <insert_sorted_with_merge_freeList+0x20e>
  802c96:	a1 38 41 80 00       	mov    0x804138,%eax
  802c9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ca1:	eb 08                	jmp    802cab <insert_sorted_with_merge_freeList+0x216>
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	a3 38 41 80 00       	mov    %eax,0x804138
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbd:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc2:	40                   	inc    %eax
  802cc3:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802cc8:	e9 0e 05 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	01 c2                	add    %eax,%edx
  802cdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cde:	8b 40 08             	mov    0x8(%eax),%eax
  802ce1:	39 c2                	cmp    %eax,%edx
  802ce3:	0f 85 9c 00 00 00    	jne    802d85 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cec:	8b 50 0c             	mov    0xc(%eax),%edx
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf5:	01 c2                	add    %eax,%edx
  802cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfa:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	8b 50 08             	mov    0x8(%eax),%edx
  802d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d06:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d21:	75 17                	jne    802d3a <insert_sorted_with_merge_freeList+0x2a5>
  802d23:	83 ec 04             	sub    $0x4,%esp
  802d26:	68 b4 3e 80 00       	push   $0x803eb4
  802d2b:	68 4d 01 00 00       	push   $0x14d
  802d30:	68 d7 3e 80 00       	push   $0x803ed7
  802d35:	e8 81 d7 ff ff       	call   8004bb <_panic>
  802d3a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	89 10                	mov    %edx,(%eax)
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 0d                	je     802d5b <insert_sorted_with_merge_freeList+0x2c6>
  802d4e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d53:	8b 55 08             	mov    0x8(%ebp),%edx
  802d56:	89 50 04             	mov    %edx,0x4(%eax)
  802d59:	eb 08                	jmp    802d63 <insert_sorted_with_merge_freeList+0x2ce>
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	a3 48 41 80 00       	mov    %eax,0x804148
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d75:	a1 54 41 80 00       	mov    0x804154,%eax
  802d7a:	40                   	inc    %eax
  802d7b:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802d80:	e9 56 04 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802d85:	a1 38 41 80 00       	mov    0x804138,%eax
  802d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8d:	e9 19 04 00 00       	jmp    8031ab <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 00                	mov    (%eax),%eax
  802d97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 50 08             	mov    0x8(%eax),%edx
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 0c             	mov    0xc(%eax),%eax
  802da6:	01 c2                	add    %eax,%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	8b 40 08             	mov    0x8(%eax),%eax
  802dae:	39 c2                	cmp    %eax,%edx
  802db0:	0f 85 ad 01 00 00    	jne    802f63 <insert_sorted_with_merge_freeList+0x4ce>
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 50 08             	mov    0x8(%eax),%edx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	01 c2                	add    %eax,%edx
  802dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc7:	8b 40 08             	mov    0x8(%eax),%eax
  802dca:	39 c2                	cmp    %eax,%edx
  802dcc:	0f 85 91 01 00 00    	jne    802f63 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	8b 48 0c             	mov    0xc(%eax),%ecx
  802dde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de1:	8b 40 0c             	mov    0xc(%eax),%eax
  802de4:	01 c8                	add    %ecx,%eax
  802de6:	01 c2                	add    %eax,%edx
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802e02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e05:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802e0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802e16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e1a:	75 17                	jne    802e33 <insert_sorted_with_merge_freeList+0x39e>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 48 3f 80 00       	push   $0x803f48
  802e24:	68 5b 01 00 00       	push   $0x15b
  802e29:	68 d7 3e 80 00       	push   $0x803ed7
  802e2e:	e8 88 d6 ff ff       	call   8004bb <_panic>
  802e33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e36:	8b 00                	mov    (%eax),%eax
  802e38:	85 c0                	test   %eax,%eax
  802e3a:	74 10                	je     802e4c <insert_sorted_with_merge_freeList+0x3b7>
  802e3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3f:	8b 00                	mov    (%eax),%eax
  802e41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e44:	8b 52 04             	mov    0x4(%edx),%edx
  802e47:	89 50 04             	mov    %edx,0x4(%eax)
  802e4a:	eb 0b                	jmp    802e57 <insert_sorted_with_merge_freeList+0x3c2>
  802e4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0f                	je     802e70 <insert_sorted_with_merge_freeList+0x3db>
  802e61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e64:	8b 40 04             	mov    0x4(%eax),%eax
  802e67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e6a:	8b 12                	mov    (%edx),%edx
  802e6c:	89 10                	mov    %edx,(%eax)
  802e6e:	eb 0a                	jmp    802e7a <insert_sorted_with_merge_freeList+0x3e5>
  802e70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	a3 38 41 80 00       	mov    %eax,0x804138
  802e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8d:	a1 44 41 80 00       	mov    0x804144,%eax
  802e92:	48                   	dec    %eax
  802e93:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9c:	75 17                	jne    802eb5 <insert_sorted_with_merge_freeList+0x420>
  802e9e:	83 ec 04             	sub    $0x4,%esp
  802ea1:	68 b4 3e 80 00       	push   $0x803eb4
  802ea6:	68 5c 01 00 00       	push   $0x15c
  802eab:	68 d7 3e 80 00       	push   $0x803ed7
  802eb0:	e8 06 d6 ff ff       	call   8004bb <_panic>
  802eb5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	89 10                	mov    %edx,(%eax)
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	85 c0                	test   %eax,%eax
  802ec7:	74 0d                	je     802ed6 <insert_sorted_with_merge_freeList+0x441>
  802ec9:	a1 48 41 80 00       	mov    0x804148,%eax
  802ece:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed1:	89 50 04             	mov    %edx,0x4(%eax)
  802ed4:	eb 08                	jmp    802ede <insert_sorted_with_merge_freeList+0x449>
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef0:	a1 54 41 80 00       	mov    0x804154,%eax
  802ef5:	40                   	inc    %eax
  802ef6:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802eff:	75 17                	jne    802f18 <insert_sorted_with_merge_freeList+0x483>
  802f01:	83 ec 04             	sub    $0x4,%esp
  802f04:	68 b4 3e 80 00       	push   $0x803eb4
  802f09:	68 5d 01 00 00       	push   $0x15d
  802f0e:	68 d7 3e 80 00       	push   $0x803ed7
  802f13:	e8 a3 d5 ff ff       	call   8004bb <_panic>
  802f18:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f21:	89 10                	mov    %edx,(%eax)
  802f23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	74 0d                	je     802f39 <insert_sorted_with_merge_freeList+0x4a4>
  802f2c:	a1 48 41 80 00       	mov    0x804148,%eax
  802f31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f34:	89 50 04             	mov    %edx,0x4(%eax)
  802f37:	eb 08                	jmp    802f41 <insert_sorted_with_merge_freeList+0x4ac>
  802f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f44:	a3 48 41 80 00       	mov    %eax,0x804148
  802f49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f53:	a1 54 41 80 00       	mov    0x804154,%eax
  802f58:	40                   	inc    %eax
  802f59:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f5e:	e9 78 02 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 50 08             	mov    0x8(%eax),%edx
  802f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6f:	01 c2                	add    %eax,%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 40 08             	mov    0x8(%eax),%eax
  802f77:	39 c2                	cmp    %eax,%edx
  802f79:	0f 83 b8 00 00 00    	jae    803037 <insert_sorted_with_merge_freeList+0x5a2>
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	01 c2                	add    %eax,%edx
  802f8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f90:	8b 40 08             	mov    0x8(%eax),%eax
  802f93:	39 c2                	cmp    %eax,%edx
  802f95:	0f 85 9c 00 00 00    	jne    803037 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9e:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa7:	01 c2                	add    %eax,%edx
  802fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fac:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	8b 50 08             	mov    0x8(%eax),%edx
  802fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb8:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd3:	75 17                	jne    802fec <insert_sorted_with_merge_freeList+0x557>
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	68 b4 3e 80 00       	push   $0x803eb4
  802fdd:	68 67 01 00 00       	push   $0x167
  802fe2:	68 d7 3e 80 00       	push   $0x803ed7
  802fe7:	e8 cf d4 ff ff       	call   8004bb <_panic>
  802fec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	89 10                	mov    %edx,(%eax)
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	74 0d                	je     80300d <insert_sorted_with_merge_freeList+0x578>
  803000:	a1 48 41 80 00       	mov    0x804148,%eax
  803005:	8b 55 08             	mov    0x8(%ebp),%edx
  803008:	89 50 04             	mov    %edx,0x4(%eax)
  80300b:	eb 08                	jmp    803015 <insert_sorted_with_merge_freeList+0x580>
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	a3 48 41 80 00       	mov    %eax,0x804148
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803027:	a1 54 41 80 00       	mov    0x804154,%eax
  80302c:	40                   	inc    %eax
  80302d:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  803032:	e9 a4 01 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 50 08             	mov    0x8(%eax),%edx
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 40 0c             	mov    0xc(%eax),%eax
  803043:	01 c2                	add    %eax,%edx
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	8b 40 08             	mov    0x8(%eax),%eax
  80304b:	39 c2                	cmp    %eax,%edx
  80304d:	0f 85 ac 00 00 00    	jne    8030ff <insert_sorted_with_merge_freeList+0x66a>
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	8b 50 08             	mov    0x8(%eax),%edx
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	8b 40 0c             	mov    0xc(%eax),%eax
  80305f:	01 c2                	add    %eax,%edx
  803061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803064:	8b 40 08             	mov    0x8(%eax),%eax
  803067:	39 c2                	cmp    %eax,%edx
  803069:	0f 83 90 00 00 00    	jae    8030ff <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 50 0c             	mov    0xc(%eax),%edx
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	8b 40 0c             	mov    0xc(%eax),%eax
  80307b:	01 c2                	add    %eax,%edx
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803097:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309b:	75 17                	jne    8030b4 <insert_sorted_with_merge_freeList+0x61f>
  80309d:	83 ec 04             	sub    $0x4,%esp
  8030a0:	68 b4 3e 80 00       	push   $0x803eb4
  8030a5:	68 70 01 00 00       	push   $0x170
  8030aa:	68 d7 3e 80 00       	push   $0x803ed7
  8030af:	e8 07 d4 ff ff       	call   8004bb <_panic>
  8030b4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	89 10                	mov    %edx,(%eax)
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 00                	mov    (%eax),%eax
  8030c4:	85 c0                	test   %eax,%eax
  8030c6:	74 0d                	je     8030d5 <insert_sorted_with_merge_freeList+0x640>
  8030c8:	a1 48 41 80 00       	mov    0x804148,%eax
  8030cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d0:	89 50 04             	mov    %edx,0x4(%eax)
  8030d3:	eb 08                	jmp    8030dd <insert_sorted_with_merge_freeList+0x648>
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	a3 48 41 80 00       	mov    %eax,0x804148
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ef:	a1 54 41 80 00       	mov    0x804154,%eax
  8030f4:	40                   	inc    %eax
  8030f5:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  8030fa:	e9 dc 00 00 00       	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 50 08             	mov    0x8(%eax),%edx
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	8b 40 0c             	mov    0xc(%eax),%eax
  80310b:	01 c2                	add    %eax,%edx
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	8b 40 08             	mov    0x8(%eax),%eax
  803113:	39 c2                	cmp    %eax,%edx
  803115:	0f 83 88 00 00 00    	jae    8031a3 <insert_sorted_with_merge_freeList+0x70e>
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	8b 50 08             	mov    0x8(%eax),%edx
  803121:	8b 45 08             	mov    0x8(%ebp),%eax
  803124:	8b 40 0c             	mov    0xc(%eax),%eax
  803127:	01 c2                	add    %eax,%edx
  803129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80312c:	8b 40 08             	mov    0x8(%eax),%eax
  80312f:	39 c2                	cmp    %eax,%edx
  803131:	73 70                	jae    8031a3 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803133:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803137:	74 06                	je     80313f <insert_sorted_with_merge_freeList+0x6aa>
  803139:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313d:	75 17                	jne    803156 <insert_sorted_with_merge_freeList+0x6c1>
  80313f:	83 ec 04             	sub    $0x4,%esp
  803142:	68 14 3f 80 00       	push   $0x803f14
  803147:	68 75 01 00 00       	push   $0x175
  80314c:	68 d7 3e 80 00       	push   $0x803ed7
  803151:	e8 65 d3 ff ff       	call   8004bb <_panic>
  803156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803159:	8b 10                	mov    (%eax),%edx
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	89 10                	mov    %edx,(%eax)
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 0b                	je     803174 <insert_sorted_with_merge_freeList+0x6df>
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 00                	mov    (%eax),%eax
  80316e:	8b 55 08             	mov    0x8(%ebp),%edx
  803171:	89 50 04             	mov    %edx,0x4(%eax)
  803174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803177:	8b 55 08             	mov    0x8(%ebp),%edx
  80317a:	89 10                	mov    %edx,(%eax)
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803182:	89 50 04             	mov    %edx,0x4(%eax)
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	85 c0                	test   %eax,%eax
  80318c:	75 08                	jne    803196 <insert_sorted_with_merge_freeList+0x701>
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803196:	a1 44 41 80 00       	mov    0x804144,%eax
  80319b:	40                   	inc    %eax
  80319c:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  8031a1:	eb 38                	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  8031a3:	a1 40 41 80 00       	mov    0x804140,%eax
  8031a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031af:	74 07                	je     8031b8 <insert_sorted_with_merge_freeList+0x723>
  8031b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b4:	8b 00                	mov    (%eax),%eax
  8031b6:	eb 05                	jmp    8031bd <insert_sorted_with_merge_freeList+0x728>
  8031b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8031bd:	a3 40 41 80 00       	mov    %eax,0x804140
  8031c2:	a1 40 41 80 00       	mov    0x804140,%eax
  8031c7:	85 c0                	test   %eax,%eax
  8031c9:	0f 85 c3 fb ff ff    	jne    802d92 <insert_sorted_with_merge_freeList+0x2fd>
  8031cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d3:	0f 85 b9 fb ff ff    	jne    802d92 <insert_sorted_with_merge_freeList+0x2fd>





}
  8031d9:	eb 00                	jmp    8031db <insert_sorted_with_merge_freeList+0x746>
  8031db:	90                   	nop
  8031dc:	c9                   	leave  
  8031dd:	c3                   	ret    

008031de <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8031de:	55                   	push   %ebp
  8031df:	89 e5                	mov    %esp,%ebp
  8031e1:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8031e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e7:	89 d0                	mov    %edx,%eax
  8031e9:	c1 e0 02             	shl    $0x2,%eax
  8031ec:	01 d0                	add    %edx,%eax
  8031ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031f5:	01 d0                	add    %edx,%eax
  8031f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031fe:	01 d0                	add    %edx,%eax
  803200:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803207:	01 d0                	add    %edx,%eax
  803209:	c1 e0 04             	shl    $0x4,%eax
  80320c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80320f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803216:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803219:	83 ec 0c             	sub    $0xc,%esp
  80321c:	50                   	push   %eax
  80321d:	e8 31 ec ff ff       	call   801e53 <sys_get_virtual_time>
  803222:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803225:	eb 41                	jmp    803268 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803227:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80322a:	83 ec 0c             	sub    $0xc,%esp
  80322d:	50                   	push   %eax
  80322e:	e8 20 ec ff ff       	call   801e53 <sys_get_virtual_time>
  803233:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803236:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323c:	29 c2                	sub    %eax,%edx
  80323e:	89 d0                	mov    %edx,%eax
  803240:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803243:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803246:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803249:	89 d1                	mov    %edx,%ecx
  80324b:	29 c1                	sub    %eax,%ecx
  80324d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803250:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803253:	39 c2                	cmp    %eax,%edx
  803255:	0f 97 c0             	seta   %al
  803258:	0f b6 c0             	movzbl %al,%eax
  80325b:	29 c1                	sub    %eax,%ecx
  80325d:	89 c8                	mov    %ecx,%eax
  80325f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803262:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803265:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80326e:	72 b7                	jb     803227 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803270:	90                   	nop
  803271:	c9                   	leave  
  803272:	c3                   	ret    

00803273 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803273:	55                   	push   %ebp
  803274:	89 e5                	mov    %esp,%ebp
  803276:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803279:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803280:	eb 03                	jmp    803285 <busy_wait+0x12>
  803282:	ff 45 fc             	incl   -0x4(%ebp)
  803285:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803288:	3b 45 08             	cmp    0x8(%ebp),%eax
  80328b:	72 f5                	jb     803282 <busy_wait+0xf>
	return i;
  80328d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803290:	c9                   	leave  
  803291:	c3                   	ret    
  803292:	66 90                	xchg   %ax,%ax

00803294 <__udivdi3>:
  803294:	55                   	push   %ebp
  803295:	57                   	push   %edi
  803296:	56                   	push   %esi
  803297:	53                   	push   %ebx
  803298:	83 ec 1c             	sub    $0x1c,%esp
  80329b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80329f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032ab:	89 ca                	mov    %ecx,%edx
  8032ad:	89 f8                	mov    %edi,%eax
  8032af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032b3:	85 f6                	test   %esi,%esi
  8032b5:	75 2d                	jne    8032e4 <__udivdi3+0x50>
  8032b7:	39 cf                	cmp    %ecx,%edi
  8032b9:	77 65                	ja     803320 <__udivdi3+0x8c>
  8032bb:	89 fd                	mov    %edi,%ebp
  8032bd:	85 ff                	test   %edi,%edi
  8032bf:	75 0b                	jne    8032cc <__udivdi3+0x38>
  8032c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c6:	31 d2                	xor    %edx,%edx
  8032c8:	f7 f7                	div    %edi
  8032ca:	89 c5                	mov    %eax,%ebp
  8032cc:	31 d2                	xor    %edx,%edx
  8032ce:	89 c8                	mov    %ecx,%eax
  8032d0:	f7 f5                	div    %ebp
  8032d2:	89 c1                	mov    %eax,%ecx
  8032d4:	89 d8                	mov    %ebx,%eax
  8032d6:	f7 f5                	div    %ebp
  8032d8:	89 cf                	mov    %ecx,%edi
  8032da:	89 fa                	mov    %edi,%edx
  8032dc:	83 c4 1c             	add    $0x1c,%esp
  8032df:	5b                   	pop    %ebx
  8032e0:	5e                   	pop    %esi
  8032e1:	5f                   	pop    %edi
  8032e2:	5d                   	pop    %ebp
  8032e3:	c3                   	ret    
  8032e4:	39 ce                	cmp    %ecx,%esi
  8032e6:	77 28                	ja     803310 <__udivdi3+0x7c>
  8032e8:	0f bd fe             	bsr    %esi,%edi
  8032eb:	83 f7 1f             	xor    $0x1f,%edi
  8032ee:	75 40                	jne    803330 <__udivdi3+0x9c>
  8032f0:	39 ce                	cmp    %ecx,%esi
  8032f2:	72 0a                	jb     8032fe <__udivdi3+0x6a>
  8032f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032f8:	0f 87 9e 00 00 00    	ja     80339c <__udivdi3+0x108>
  8032fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803303:	89 fa                	mov    %edi,%edx
  803305:	83 c4 1c             	add    $0x1c,%esp
  803308:	5b                   	pop    %ebx
  803309:	5e                   	pop    %esi
  80330a:	5f                   	pop    %edi
  80330b:	5d                   	pop    %ebp
  80330c:	c3                   	ret    
  80330d:	8d 76 00             	lea    0x0(%esi),%esi
  803310:	31 ff                	xor    %edi,%edi
  803312:	31 c0                	xor    %eax,%eax
  803314:	89 fa                	mov    %edi,%edx
  803316:	83 c4 1c             	add    $0x1c,%esp
  803319:	5b                   	pop    %ebx
  80331a:	5e                   	pop    %esi
  80331b:	5f                   	pop    %edi
  80331c:	5d                   	pop    %ebp
  80331d:	c3                   	ret    
  80331e:	66 90                	xchg   %ax,%ax
  803320:	89 d8                	mov    %ebx,%eax
  803322:	f7 f7                	div    %edi
  803324:	31 ff                	xor    %edi,%edi
  803326:	89 fa                	mov    %edi,%edx
  803328:	83 c4 1c             	add    $0x1c,%esp
  80332b:	5b                   	pop    %ebx
  80332c:	5e                   	pop    %esi
  80332d:	5f                   	pop    %edi
  80332e:	5d                   	pop    %ebp
  80332f:	c3                   	ret    
  803330:	bd 20 00 00 00       	mov    $0x20,%ebp
  803335:	89 eb                	mov    %ebp,%ebx
  803337:	29 fb                	sub    %edi,%ebx
  803339:	89 f9                	mov    %edi,%ecx
  80333b:	d3 e6                	shl    %cl,%esi
  80333d:	89 c5                	mov    %eax,%ebp
  80333f:	88 d9                	mov    %bl,%cl
  803341:	d3 ed                	shr    %cl,%ebp
  803343:	89 e9                	mov    %ebp,%ecx
  803345:	09 f1                	or     %esi,%ecx
  803347:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80334b:	89 f9                	mov    %edi,%ecx
  80334d:	d3 e0                	shl    %cl,%eax
  80334f:	89 c5                	mov    %eax,%ebp
  803351:	89 d6                	mov    %edx,%esi
  803353:	88 d9                	mov    %bl,%cl
  803355:	d3 ee                	shr    %cl,%esi
  803357:	89 f9                	mov    %edi,%ecx
  803359:	d3 e2                	shl    %cl,%edx
  80335b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80335f:	88 d9                	mov    %bl,%cl
  803361:	d3 e8                	shr    %cl,%eax
  803363:	09 c2                	or     %eax,%edx
  803365:	89 d0                	mov    %edx,%eax
  803367:	89 f2                	mov    %esi,%edx
  803369:	f7 74 24 0c          	divl   0xc(%esp)
  80336d:	89 d6                	mov    %edx,%esi
  80336f:	89 c3                	mov    %eax,%ebx
  803371:	f7 e5                	mul    %ebp
  803373:	39 d6                	cmp    %edx,%esi
  803375:	72 19                	jb     803390 <__udivdi3+0xfc>
  803377:	74 0b                	je     803384 <__udivdi3+0xf0>
  803379:	89 d8                	mov    %ebx,%eax
  80337b:	31 ff                	xor    %edi,%edi
  80337d:	e9 58 ff ff ff       	jmp    8032da <__udivdi3+0x46>
  803382:	66 90                	xchg   %ax,%ax
  803384:	8b 54 24 08          	mov    0x8(%esp),%edx
  803388:	89 f9                	mov    %edi,%ecx
  80338a:	d3 e2                	shl    %cl,%edx
  80338c:	39 c2                	cmp    %eax,%edx
  80338e:	73 e9                	jae    803379 <__udivdi3+0xe5>
  803390:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803393:	31 ff                	xor    %edi,%edi
  803395:	e9 40 ff ff ff       	jmp    8032da <__udivdi3+0x46>
  80339a:	66 90                	xchg   %ax,%ax
  80339c:	31 c0                	xor    %eax,%eax
  80339e:	e9 37 ff ff ff       	jmp    8032da <__udivdi3+0x46>
  8033a3:	90                   	nop

008033a4 <__umoddi3>:
  8033a4:	55                   	push   %ebp
  8033a5:	57                   	push   %edi
  8033a6:	56                   	push   %esi
  8033a7:	53                   	push   %ebx
  8033a8:	83 ec 1c             	sub    $0x1c,%esp
  8033ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033c3:	89 f3                	mov    %esi,%ebx
  8033c5:	89 fa                	mov    %edi,%edx
  8033c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033cb:	89 34 24             	mov    %esi,(%esp)
  8033ce:	85 c0                	test   %eax,%eax
  8033d0:	75 1a                	jne    8033ec <__umoddi3+0x48>
  8033d2:	39 f7                	cmp    %esi,%edi
  8033d4:	0f 86 a2 00 00 00    	jbe    80347c <__umoddi3+0xd8>
  8033da:	89 c8                	mov    %ecx,%eax
  8033dc:	89 f2                	mov    %esi,%edx
  8033de:	f7 f7                	div    %edi
  8033e0:	89 d0                	mov    %edx,%eax
  8033e2:	31 d2                	xor    %edx,%edx
  8033e4:	83 c4 1c             	add    $0x1c,%esp
  8033e7:	5b                   	pop    %ebx
  8033e8:	5e                   	pop    %esi
  8033e9:	5f                   	pop    %edi
  8033ea:	5d                   	pop    %ebp
  8033eb:	c3                   	ret    
  8033ec:	39 f0                	cmp    %esi,%eax
  8033ee:	0f 87 ac 00 00 00    	ja     8034a0 <__umoddi3+0xfc>
  8033f4:	0f bd e8             	bsr    %eax,%ebp
  8033f7:	83 f5 1f             	xor    $0x1f,%ebp
  8033fa:	0f 84 ac 00 00 00    	je     8034ac <__umoddi3+0x108>
  803400:	bf 20 00 00 00       	mov    $0x20,%edi
  803405:	29 ef                	sub    %ebp,%edi
  803407:	89 fe                	mov    %edi,%esi
  803409:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80340d:	89 e9                	mov    %ebp,%ecx
  80340f:	d3 e0                	shl    %cl,%eax
  803411:	89 d7                	mov    %edx,%edi
  803413:	89 f1                	mov    %esi,%ecx
  803415:	d3 ef                	shr    %cl,%edi
  803417:	09 c7                	or     %eax,%edi
  803419:	89 e9                	mov    %ebp,%ecx
  80341b:	d3 e2                	shl    %cl,%edx
  80341d:	89 14 24             	mov    %edx,(%esp)
  803420:	89 d8                	mov    %ebx,%eax
  803422:	d3 e0                	shl    %cl,%eax
  803424:	89 c2                	mov    %eax,%edx
  803426:	8b 44 24 08          	mov    0x8(%esp),%eax
  80342a:	d3 e0                	shl    %cl,%eax
  80342c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803430:	8b 44 24 08          	mov    0x8(%esp),%eax
  803434:	89 f1                	mov    %esi,%ecx
  803436:	d3 e8                	shr    %cl,%eax
  803438:	09 d0                	or     %edx,%eax
  80343a:	d3 eb                	shr    %cl,%ebx
  80343c:	89 da                	mov    %ebx,%edx
  80343e:	f7 f7                	div    %edi
  803440:	89 d3                	mov    %edx,%ebx
  803442:	f7 24 24             	mull   (%esp)
  803445:	89 c6                	mov    %eax,%esi
  803447:	89 d1                	mov    %edx,%ecx
  803449:	39 d3                	cmp    %edx,%ebx
  80344b:	0f 82 87 00 00 00    	jb     8034d8 <__umoddi3+0x134>
  803451:	0f 84 91 00 00 00    	je     8034e8 <__umoddi3+0x144>
  803457:	8b 54 24 04          	mov    0x4(%esp),%edx
  80345b:	29 f2                	sub    %esi,%edx
  80345d:	19 cb                	sbb    %ecx,%ebx
  80345f:	89 d8                	mov    %ebx,%eax
  803461:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803465:	d3 e0                	shl    %cl,%eax
  803467:	89 e9                	mov    %ebp,%ecx
  803469:	d3 ea                	shr    %cl,%edx
  80346b:	09 d0                	or     %edx,%eax
  80346d:	89 e9                	mov    %ebp,%ecx
  80346f:	d3 eb                	shr    %cl,%ebx
  803471:	89 da                	mov    %ebx,%edx
  803473:	83 c4 1c             	add    $0x1c,%esp
  803476:	5b                   	pop    %ebx
  803477:	5e                   	pop    %esi
  803478:	5f                   	pop    %edi
  803479:	5d                   	pop    %ebp
  80347a:	c3                   	ret    
  80347b:	90                   	nop
  80347c:	89 fd                	mov    %edi,%ebp
  80347e:	85 ff                	test   %edi,%edi
  803480:	75 0b                	jne    80348d <__umoddi3+0xe9>
  803482:	b8 01 00 00 00       	mov    $0x1,%eax
  803487:	31 d2                	xor    %edx,%edx
  803489:	f7 f7                	div    %edi
  80348b:	89 c5                	mov    %eax,%ebp
  80348d:	89 f0                	mov    %esi,%eax
  80348f:	31 d2                	xor    %edx,%edx
  803491:	f7 f5                	div    %ebp
  803493:	89 c8                	mov    %ecx,%eax
  803495:	f7 f5                	div    %ebp
  803497:	89 d0                	mov    %edx,%eax
  803499:	e9 44 ff ff ff       	jmp    8033e2 <__umoddi3+0x3e>
  80349e:	66 90                	xchg   %ax,%ax
  8034a0:	89 c8                	mov    %ecx,%eax
  8034a2:	89 f2                	mov    %esi,%edx
  8034a4:	83 c4 1c             	add    $0x1c,%esp
  8034a7:	5b                   	pop    %ebx
  8034a8:	5e                   	pop    %esi
  8034a9:	5f                   	pop    %edi
  8034aa:	5d                   	pop    %ebp
  8034ab:	c3                   	ret    
  8034ac:	3b 04 24             	cmp    (%esp),%eax
  8034af:	72 06                	jb     8034b7 <__umoddi3+0x113>
  8034b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034b5:	77 0f                	ja     8034c6 <__umoddi3+0x122>
  8034b7:	89 f2                	mov    %esi,%edx
  8034b9:	29 f9                	sub    %edi,%ecx
  8034bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034bf:	89 14 24             	mov    %edx,(%esp)
  8034c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034ca:	8b 14 24             	mov    (%esp),%edx
  8034cd:	83 c4 1c             	add    $0x1c,%esp
  8034d0:	5b                   	pop    %ebx
  8034d1:	5e                   	pop    %esi
  8034d2:	5f                   	pop    %edi
  8034d3:	5d                   	pop    %ebp
  8034d4:	c3                   	ret    
  8034d5:	8d 76 00             	lea    0x0(%esi),%esi
  8034d8:	2b 04 24             	sub    (%esp),%eax
  8034db:	19 fa                	sbb    %edi,%edx
  8034dd:	89 d1                	mov    %edx,%ecx
  8034df:	89 c6                	mov    %eax,%esi
  8034e1:	e9 71 ff ff ff       	jmp    803457 <__umoddi3+0xb3>
  8034e6:	66 90                	xchg   %ax,%ax
  8034e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034ec:	72 ea                	jb     8034d8 <__umoddi3+0x134>
  8034ee:	89 d9                	mov    %ebx,%ecx
  8034f0:	e9 62 ff ff ff       	jmp    803457 <__umoddi3+0xb3>
