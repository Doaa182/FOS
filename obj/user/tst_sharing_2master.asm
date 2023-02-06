
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 35 03 00 00       	call   80036b <libmain>
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
  800099:	e8 09 04 00 00       	call   8004a7 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 2c 16 00 00       	call   8016d4 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 63 1a 00 00       	call   801b13 <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 37 35 80 00       	push   $0x803537
  8000bf:	e8 8c 17 00 00       	call   801850 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 3c 35 80 00       	push   $0x80353c
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 1c 35 80 00       	push   $0x80351c
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 24 1a 00 00       	call   801b13 <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 a0 35 80 00       	push   $0x8035a0
  800100:	6a 1f                	push   $0x1f
  800102:	68 1c 35 80 00       	push   $0x80351c
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 02 1a 00 00       	call   801b13 <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 28 36 80 00       	push   $0x803628
  800120:	e8 2b 17 00 00       	call   801850 <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 3c 35 80 00       	push   $0x80353c
  80013c:	6a 24                	push   $0x24
  80013e:	68 1c 35 80 00       	push   $0x80351c
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 c3 19 00 00       	call   801b13 <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 a0 35 80 00       	push   $0x8035a0
  800161:	6a 25                	push   $0x25
  800163:	68 1c 35 80 00       	push   $0x80351c
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 a1 19 00 00       	call   801b13 <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 2a 36 80 00       	push   $0x80362a
  800181:	e8 ca 16 00 00       	call   801850 <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 3c 35 80 00       	push   $0x80353c
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 1c 35 80 00       	push   $0x80351c
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 62 19 00 00       	call   801b13 <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 a0 35 80 00       	push   $0x8035a0
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 1c 35 80 00       	push   $0x80351c
  8001c9:	e8 d9 02 00 00       	call   8004a7 <_panic>

	*x = 10 ;
  8001ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d1:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001da:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001f6:	89 c1                	mov    %eax,%ecx
  8001f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fd:	8b 40 74             	mov    0x74(%eax),%eax
  800200:	52                   	push   %edx
  800201:	51                   	push   %ecx
  800202:	50                   	push   %eax
  800203:	68 2c 36 80 00       	push   $0x80362c
  800208:	e8 78 1b 00 00       	call   801d85 <sys_create_env>
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800213:	a1 20 40 80 00       	mov    0x804020,%eax
  800218:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021e:	a1 20 40 80 00       	mov    0x804020,%eax
  800223:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800229:	89 c1                	mov    %eax,%ecx
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8b 40 74             	mov    0x74(%eax),%eax
  800233:	52                   	push   %edx
  800234:	51                   	push   %ecx
  800235:	50                   	push   %eax
  800236:	68 2c 36 80 00       	push   $0x80362c
  80023b:	e8 45 1b 00 00       	call   801d85 <sys_create_env>
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800246:	a1 20 40 80 00       	mov    0x804020,%eax
  80024b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800251:	a1 20 40 80 00       	mov    0x804020,%eax
  800256:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80025c:	89 c1                	mov    %eax,%ecx
  80025e:	a1 20 40 80 00       	mov    0x804020,%eax
  800263:	8b 40 74             	mov    0x74(%eax),%eax
  800266:	52                   	push   %edx
  800267:	51                   	push   %ecx
  800268:	50                   	push   %eax
  800269:	68 2c 36 80 00       	push   $0x80362c
  80026e:	e8 12 1b 00 00       	call   801d85 <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 53 1c 00 00       	call   801ed1 <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 1a 1b 00 00       	call   801da3 <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 0c 1b 00 00       	call   801da3 <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 fe 1a 00 00       	call   801da3 <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 15 2f 00 00       	call   8031ca <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 8e 1c 00 00       	call   801f4b <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 37 36 80 00       	push   $0x803637
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 1c 35 80 00       	push   $0x80351c
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 44 36 80 00       	push   $0x803644
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 1c 35 80 00       	push   $0x80351c
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 90 36 80 00       	push   $0x803690
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 ec 36 80 00       	push   $0x8036ec
  80030c:	e8 4a 04 00 00       	call   80075b <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800314:	a1 20 40 80 00       	mov    0x804020,%eax
  800319:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80031f:	a1 20 40 80 00       	mov    0x804020,%eax
  800324:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80032a:	89 c1                	mov    %eax,%ecx
  80032c:	a1 20 40 80 00       	mov    0x804020,%eax
  800331:	8b 40 74             	mov    0x74(%eax),%eax
  800334:	52                   	push   %edx
  800335:	51                   	push   %ecx
  800336:	50                   	push   %eax
  800337:	68 47 37 80 00       	push   $0x803747
  80033c:	e8 44 1a 00 00       	call   801d85 <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 76 2e 00 00       	call   8031ca <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 41 1a 00 00       	call   801da3 <sys_run_env>
  800362:	83 c4 10             	add    $0x10,%esp

	return;
  800365:	90                   	nop
}
  800366:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800371:	e8 7d 1a 00 00       	call   801df3 <sys_getenvindex>
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80037c:	89 d0                	mov    %edx,%eax
  80037e:	c1 e0 03             	shl    $0x3,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038e:	01 d0                	add    %edx,%eax
  800390:	c1 e0 04             	shl    $0x4,%eax
  800393:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800398:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80039d:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003a8:	84 c0                	test   %al,%al
  8003aa:	74 0f                	je     8003bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8003b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003bf:	7e 0a                	jle    8003cb <libmain+0x60>
		binaryname = argv[0];
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <_main>
  8003d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003dc:	e8 1f 18 00 00       	call   801c00 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 6c 37 80 00       	push   $0x80376c
  8003e9:	e8 6d 03 00 00       	call   80075b <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800401:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800407:	83 ec 04             	sub    $0x4,%esp
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	68 94 37 80 00       	push   $0x803794
  800411:	e8 45 03 00 00       	call   80075b <cprintf>
  800416:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800419:	a1 20 40 80 00       	mov    0x804020,%eax
  80041e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800424:	a1 20 40 80 00       	mov    0x804020,%eax
  800429:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80042f:	a1 20 40 80 00       	mov    0x804020,%eax
  800434:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80043a:	51                   	push   %ecx
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	68 bc 37 80 00       	push   $0x8037bc
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 40 80 00       	mov    0x804020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 14 38 80 00       	push   $0x803814
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 6c 37 80 00       	push   $0x80376c
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 9f 17 00 00       	call   801c1a <sys_enable_interrupt>

	// exit gracefully
	exit();
  80047b:	e8 19 00 00 00       	call   800499 <exit>
}
  800480:	90                   	nop
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	e8 2c 19 00 00       	call   801dbf <sys_destroy_env>
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <exit>:

void
exit(void)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049f:	e8 81 19 00 00       	call   801e25 <sys_exit_env>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	74 16                	je     8004d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bf:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	50                   	push   %eax
  8004c8:	68 28 38 80 00       	push   $0x803828
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 40 80 00       	mov    0x804000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 2d 38 80 00       	push   $0x80382d
  8004e6:	e8 70 02 00 00       	call   80075b <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f7:	50                   	push   %eax
  8004f8:	e8 f3 01 00 00       	call   8006f0 <vcprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	6a 00                	push   $0x0
  800505:	68 49 38 80 00       	push   $0x803849
  80050a:	e8 e1 01 00 00       	call   8006f0 <vcprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800512:	e8 82 ff ff ff       	call   800499 <exit>

	// should not return here
	while (1) ;
  800517:	eb fe                	jmp    800517 <_panic+0x70>

00800519 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80051f:	a1 20 40 80 00       	mov    0x804020,%eax
  800524:	8b 50 74             	mov    0x74(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	39 c2                	cmp    %eax,%edx
  80052c:	74 14                	je     800542 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	68 4c 38 80 00       	push   $0x80384c
  800536:	6a 26                	push   $0x26
  800538:	68 98 38 80 00       	push   $0x803898
  80053d:	e8 65 ff ff ff       	call   8004a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800550:	e9 c2 00 00 00       	jmp    800617 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	01 d0                	add    %edx,%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	75 08                	jne    800572 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80056a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056d:	e9 a2 00 00 00       	jmp    800614 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800572:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800580:	eb 69                	jmp    8005eb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800582:	a1 20 40 80 00       	mov    0x804020,%eax
  800587:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	01 c0                	add    %eax,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	c1 e0 03             	shl    $0x3,%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8a 40 04             	mov    0x4(%eax),%al
  80059e:	84 c0                	test   %al,%al
  8005a0:	75 46                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b0:	89 d0                	mov    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	c1 e0 03             	shl    $0x3,%eax
  8005b9:	01 c8                	add    %ecx,%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	01 c8                	add    %ecx,%eax
  8005d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	75 09                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e6:	eb 12                	jmp    8005fa <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e8:	ff 45 e8             	incl   -0x18(%ebp)
  8005eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f0:	8b 50 74             	mov    0x74(%eax),%edx
  8005f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 88                	ja     800582 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 a4 38 80 00       	push   $0x8038a4
  800608:	6a 3a                	push   $0x3a
  80060a:	68 98 38 80 00       	push   $0x803898
  80060f:	e8 93 fe ff ff       	call   8004a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 32 ff ff ff    	jl     800555 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 26                	jmp    800659 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 40 80 00       	mov    0x804020,%eax
  800638:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 20 40 80 00       	mov    0x804020,%eax
  80065e:	8b 50 74             	mov    0x74(%eax),%edx
  800661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800664:	39 c2                	cmp    %eax,%edx
  800666:	77 cb                	ja     800633 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066e:	74 14                	je     800684 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 f8 38 80 00       	push   $0x8038f8
  800678:	6a 44                	push   $0x44
  80067a:	68 98 38 80 00       	push   $0x803898
  80067f:	e8 23 fe ff ff       	call   8004a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800684:	90                   	nop
  800685:	c9                   	leave  
  800686:	c3                   	ret    

00800687 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	8d 48 01             	lea    0x1(%eax),%ecx
  800695:	8b 55 0c             	mov    0xc(%ebp),%edx
  800698:	89 0a                	mov    %ecx,(%edx)
  80069a:	8b 55 08             	mov    0x8(%ebp),%edx
  80069d:	88 d1                	mov    %dl,%cl
  80069f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b0:	75 2c                	jne    8006de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006b2:	a0 24 40 80 00       	mov    0x804024,%al
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bd:	8b 12                	mov    (%edx),%edx
  8006bf:	89 d1                	mov    %edx,%ecx
  8006c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c4:	83 c2 08             	add    $0x8,%edx
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	50                   	push   %eax
  8006cb:	51                   	push   %ecx
  8006cc:	52                   	push   %edx
  8006cd:	e8 80 13 00 00       	call   801a52 <sys_cputs>
  8006d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 40 04             	mov    0x4(%eax),%eax
  8006e4:	8d 50 01             	lea    0x1(%eax),%edx
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ed:	90                   	nop
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800700:	00 00 00 
	b.cnt = 0;
  800703:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800719:	50                   	push   %eax
  80071a:	68 87 06 80 00       	push   $0x800687
  80071f:	e8 11 02 00 00       	call   800935 <vprintfmt>
  800724:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800727:	a0 24 40 80 00       	mov    0x804024,%al
  80072c:	0f b6 c0             	movzbl %al,%eax
  80072f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	50                   	push   %eax
  800739:	52                   	push   %edx
  80073a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800740:	83 c0 08             	add    $0x8,%eax
  800743:	50                   	push   %eax
  800744:	e8 09 13 00 00       	call   801a52 <sys_cputs>
  800749:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800753:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <cprintf>:

int cprintf(const char *fmt, ...) {
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800761:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800768:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 f4             	pushl  -0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 73 ff ff ff       	call   8006f0 <vcprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800783:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80078e:	e8 6d 14 00 00       	call   801c00 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800793:	8d 45 0c             	lea    0xc(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 48 ff ff ff       	call   8006f0 <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ae:	e8 67 14 00 00       	call   801c1a <sys_enable_interrupt>
	return cnt;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	83 ec 14             	sub    $0x14,%esp
  8007bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d6:	77 55                	ja     80082d <printnum+0x75>
  8007d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007db:	72 05                	jb     8007e2 <printnum+0x2a>
  8007dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e0:	77 4b                	ja     80082d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	52                   	push   %edx
  8007f1:	50                   	push   %eax
  8007f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f8:	e8 83 2a 00 00       	call   803280 <__udivdi3>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	ff 75 20             	pushl  0x20(%ebp)
  800806:	53                   	push   %ebx
  800807:	ff 75 18             	pushl  0x18(%ebp)
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 a1 ff ff ff       	call   8007b8 <printnum>
  800817:	83 c4 20             	add    $0x20,%esp
  80081a:	eb 1a                	jmp    800836 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	ff 75 20             	pushl  0x20(%ebp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082d:	ff 4d 1c             	decl   0x1c(%ebp)
  800830:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800834:	7f e6                	jg     80081c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800836:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800844:	53                   	push   %ebx
  800845:	51                   	push   %ecx
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	e8 43 2b 00 00       	call   803390 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 74 3b 80 00       	add    $0x803b74,%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be c0             	movsbl %al,%eax
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	50                   	push   %eax
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
}
  800869:	90                   	nop
  80086a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086d:	c9                   	leave  
  80086e:	c3                   	ret    

0080086f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800872:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800876:	7e 1c                	jle    800894 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	8d 50 08             	lea    0x8(%eax),%edx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	89 10                	mov    %edx,(%eax)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	83 e8 08             	sub    $0x8,%eax
  80088d:	8b 50 04             	mov    0x4(%eax),%edx
  800890:	8b 00                	mov    (%eax),%eax
  800892:	eb 40                	jmp    8008d4 <getuint+0x65>
	else if (lflag)
  800894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800898:	74 1e                	je     8008b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	eb 1c                	jmp    8008d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 50 04             	lea    0x4(%eax),%edx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 10                	mov    %edx,(%eax)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 e8 04             	sub    $0x4,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dd:	7e 1c                	jle    8008fb <getint+0x25>
		return va_arg(*ap, long long);
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 50 08             	lea    0x8(%eax),%edx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 10                	mov    %edx,(%eax)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	83 e8 08             	sub    $0x8,%eax
  8008f4:	8b 50 04             	mov    0x4(%eax),%edx
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	eb 38                	jmp    800933 <getint+0x5d>
	else if (lflag)
  8008fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ff:	74 1a                	je     80091b <getint+0x45>
		return va_arg(*ap, long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 04             	lea    0x4(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	99                   	cltd   
  800919:	eb 18                	jmp    800933 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093d:	eb 17                	jmp    800956 <vprintfmt+0x21>
			if (ch == '\0')
  80093f:	85 db                	test   %ebx,%ebx
  800941:	0f 84 af 03 00 00    	je     800cf6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800956:	8b 45 10             	mov    0x10(%ebp),%eax
  800959:	8d 50 01             	lea    0x1(%eax),%edx
  80095c:	89 55 10             	mov    %edx,0x10(%ebp)
  80095f:	8a 00                	mov    (%eax),%al
  800961:	0f b6 d8             	movzbl %al,%ebx
  800964:	83 fb 25             	cmp    $0x25,%ebx
  800967:	75 d6                	jne    80093f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800969:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80096d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800974:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80097b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800982:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800989:	8b 45 10             	mov    0x10(%ebp),%eax
  80098c:	8d 50 01             	lea    0x1(%eax),%edx
  80098f:	89 55 10             	mov    %edx,0x10(%ebp)
  800992:	8a 00                	mov    (%eax),%al
  800994:	0f b6 d8             	movzbl %al,%ebx
  800997:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80099a:	83 f8 55             	cmp    $0x55,%eax
  80099d:	0f 87 2b 03 00 00    	ja     800cce <vprintfmt+0x399>
  8009a3:	8b 04 85 98 3b 80 00 	mov    0x803b98(,%eax,4),%eax
  8009aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b0:	eb d7                	jmp    800989 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009b6:	eb d1                	jmp    800989 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 02             	shl    $0x2,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	01 c0                	add    %eax,%eax
  8009cb:	01 d8                	add    %ebx,%eax
  8009cd:	83 e8 30             	sub    $0x30,%eax
  8009d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009db:	83 fb 2f             	cmp    $0x2f,%ebx
  8009de:	7e 3e                	jle    800a1e <vprintfmt+0xe9>
  8009e0:	83 fb 39             	cmp    $0x39,%ebx
  8009e3:	7f 39                	jg     800a1e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e8:	eb d5                	jmp    8009bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	83 c0 04             	add    $0x4,%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 e8 04             	sub    $0x4,%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009fe:	eb 1f                	jmp    800a1f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a04:	79 83                	jns    800989 <vprintfmt+0x54>
				width = 0;
  800a06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a0d:	e9 77 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a12:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a19:	e9 6b ff ff ff       	jmp    800989 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a23:	0f 89 60 ff ff ff    	jns    800989 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a36:	e9 4e ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a3e:	e9 46 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 e8 04             	sub    $0x4,%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 89 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	83 c0 04             	add    $0x4,%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 e8 04             	sub    $0x4,%eax
  800a77:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a79:	85 db                	test   %ebx,%ebx
  800a7b:	79 02                	jns    800a7f <vprintfmt+0x14a>
				err = -err;
  800a7d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a7f:	83 fb 64             	cmp    $0x64,%ebx
  800a82:	7f 0b                	jg     800a8f <vprintfmt+0x15a>
  800a84:	8b 34 9d e0 39 80 00 	mov    0x8039e0(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 85 3b 80 00       	push   $0x803b85
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 5e 02 00 00       	call   800cfe <printfmt>
  800aa0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa3:	e9 49 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa8:	56                   	push   %esi
  800aa9:	68 8e 3b 80 00       	push   $0x803b8e
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 45 02 00 00       	call   800cfe <printfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 30 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 e8 04             	sub    $0x4,%eax
  800ad0:	8b 30                	mov    (%eax),%esi
  800ad2:	85 f6                	test   %esi,%esi
  800ad4:	75 05                	jne    800adb <vprintfmt+0x1a6>
				p = "(null)";
  800ad6:	be 91 3b 80 00       	mov    $0x803b91,%esi
			if (width > 0 && padc != '-')
  800adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adf:	7e 6d                	jle    800b4e <vprintfmt+0x219>
  800ae1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ae5:	74 67                	je     800b4e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	50                   	push   %eax
  800aee:	56                   	push   %esi
  800aef:	e8 0c 03 00 00       	call   800e00 <strnlen>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800afa:	eb 16                	jmp    800b12 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800afc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	50                   	push   %eax
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b16:	7f e4                	jg     800afc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b18:	eb 34                	jmp    800b4e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b1e:	74 1c                	je     800b3c <vprintfmt+0x207>
  800b20:	83 fb 1f             	cmp    $0x1f,%ebx
  800b23:	7e 05                	jle    800b2a <vprintfmt+0x1f5>
  800b25:	83 fb 7e             	cmp    $0x7e,%ebx
  800b28:	7e 12                	jle    800b3c <vprintfmt+0x207>
					putch('?', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	6a 3f                	push   $0x3f
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4e:	89 f0                	mov    %esi,%eax
  800b50:	8d 70 01             	lea    0x1(%eax),%esi
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	0f be d8             	movsbl %al,%ebx
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	74 24                	je     800b80 <vprintfmt+0x24b>
  800b5c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b60:	78 b8                	js     800b1a <vprintfmt+0x1e5>
  800b62:	ff 4d e0             	decl   -0x20(%ebp)
  800b65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b69:	79 af                	jns    800b1a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6b:	eb 13                	jmp    800b80 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 20                	push   $0x20
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b84:	7f e7                	jg     800b6d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b86:	e9 66 01 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b91:	8d 45 14             	lea    0x14(%ebp),%eax
  800b94:	50                   	push   %eax
  800b95:	e8 3c fd ff ff       	call   8008d6 <getint>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba9:	85 d2                	test   %edx,%edx
  800bab:	79 23                	jns    800bd0 <vprintfmt+0x29b>
				putch('-', putdat);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	6a 2d                	push   $0x2d
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	f7 d8                	neg    %eax
  800bc5:	83 d2 00             	adc    $0x0,%edx
  800bc8:	f7 da                	neg    %edx
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd7:	e9 bc 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800be2:	8d 45 14             	lea    0x14(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	e8 84 fc ff ff       	call   80086f <getuint>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfb:	e9 98 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	6a 58                	push   $0x58
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 58                	push   $0x58
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 58                	push   $0x58
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			break;
  800c30:	e9 bc 00 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	6a 30                	push   $0x30
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	6a 78                	push   $0x78
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c77:	eb 1f                	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c82:	50                   	push   %eax
  800c83:	e8 e7 fb ff ff       	call   80086f <getuint>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c98:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	52                   	push   %edx
  800ca3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ca6:	50                   	push   %eax
  800ca7:	ff 75 f4             	pushl  -0xc(%ebp)
  800caa:	ff 75 f0             	pushl  -0x10(%ebp)
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	ff 75 08             	pushl  0x8(%ebp)
  800cb3:	e8 00 fb ff ff       	call   8007b8 <printnum>
  800cb8:	83 c4 20             	add    $0x20,%esp
			break;
  800cbb:	eb 34                	jmp    800cf1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	53                   	push   %ebx
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			break;
  800ccc:	eb 23                	jmp    800cf1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 25                	push   $0x25
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cde:	ff 4d 10             	decl   0x10(%ebp)
  800ce1:	eb 03                	jmp    800ce6 <vprintfmt+0x3b1>
  800ce3:	ff 4d 10             	decl   0x10(%ebp)
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	48                   	dec    %eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 25                	cmp    $0x25,%al
  800cee:	75 f3                	jne    800ce3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cf0:	90                   	nop
		}
	}
  800cf1:	e9 47 fc ff ff       	jmp    80093d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cf6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 16 fc ff ff       	call   800935 <vprintfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 40 08             	mov    0x8(%eax),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8b 10                	mov    (%eax),%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 04             	mov    0x4(%eax),%eax
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	73 12                	jae    800d58 <sprintputch+0x33>
		*b->buf++ = ch;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	89 0a                	mov    %ecx,(%edx)
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	88 10                	mov    %dl,(%eax)
}
  800d58:	90                   	nop
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d80:	74 06                	je     800d88 <vsnprintf+0x2d>
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	7f 07                	jg     800d8f <vsnprintf+0x34>
		return -E_INVAL;
  800d88:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8d:	eb 20                	jmp    800daf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d8f:	ff 75 14             	pushl  0x14(%ebp)
  800d92:	ff 75 10             	pushl  0x10(%ebp)
  800d95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d98:	50                   	push   %eax
  800d99:	68 25 0d 80 00       	push   $0x800d25
  800d9e:	e8 92 fb ff ff       	call   800935 <vprintfmt>
  800da3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800db7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 89 ff ff ff       	call   800d5b <vsnprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dea:	eb 06                	jmp    800df2 <strlen+0x15>
		n++;
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800def:	ff 45 08             	incl   0x8(%ebp)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 f1                	jne    800dec <strlen+0xf>
		n++;
	return n;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 09                	jmp    800e18 <strnlen+0x18>
		n++;
  800e0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 4d 0c             	decl   0xc(%ebp)
  800e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1c:	74 09                	je     800e27 <strnlen+0x27>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 e8                	jne    800e0f <strnlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e38:	90                   	nop
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	84 c0                	test   %al,%al
  800e53:	75 e4                	jne    800e39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6d:	eb 1f                	jmp    800e8e <strncpy+0x34>
		*dst++ = *src;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 08             	mov    %edx,0x8(%ebp)
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	8a 12                	mov    (%edx),%dl
  800e7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	74 03                	je     800e8b <strncpy+0x31>
			src++;
  800e88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e8b:	ff 45 fc             	incl   -0x4(%ebp)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e94:	72 d9                	jb     800e6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 30                	je     800edd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ead:	eb 16                	jmp    800ec5 <strlcpy+0x2a>
			*dst++ = *src++;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8d 50 01             	lea    0x1(%eax),%edx
  800eb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec1:	8a 12                	mov    (%edx),%dl
  800ec3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ec5:	ff 4d 10             	decl   0x10(%ebp)
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	74 09                	je     800ed7 <strlcpy+0x3c>
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 d8                	jne    800eaf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	29 c2                	sub    %eax,%edx
  800ee5:	89 d0                	mov    %edx,%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eec:	eb 06                	jmp    800ef4 <strcmp+0xb>
		p++, q++;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	74 0e                	je     800f0b <strcmp+0x22>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	38 c2                	cmp    %al,%dl
  800f09:	74 e3                	je     800eee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f b6 d0             	movzbl %al,%edx
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 c0             	movzbl %al,%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f24:	eb 09                	jmp    800f2f <strncmp+0xe>
		n--, p++, q++;
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 17                	je     800f4c <strncmp+0x2b>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 0e                	je     800f4c <strncmp+0x2b>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 10                	mov    (%eax),%dl
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 da                	je     800f26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <strncmp+0x38>
		return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
  800f57:	eb 14                	jmp    800f6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 04             	sub    $0x4,%esp
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7b:	eb 12                	jmp    800f8f <strchr+0x20>
		if (*s == c)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f85:	75 05                	jne    800f8c <strchr+0x1d>
			return (char *) s;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	eb 11                	jmp    800f9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	75 e5                	jne    800f7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fab:	eb 0d                	jmp    800fba <strfind+0x1b>
		if (*s == c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb5:	74 0e                	je     800fc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 ea                	jne    800fad <strfind+0xe>
  800fc3:	eb 01                	jmp    800fc6 <strfind+0x27>
		if (*s == c)
			break;
  800fc5:	90                   	nop
	return (char *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fdd:	eb 0e                	jmp    800fed <memset+0x22>
		*p++ = c;
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8d 50 01             	lea    0x1(%eax),%edx
  800fe5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800feb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fed:	ff 4d f8             	decl   -0x8(%ebp)
  800ff0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ff4:	79 e9                	jns    800fdf <memset+0x14>
		*p++ = c;

	return v;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80100d:	eb 16                	jmp    801025 <memcpy+0x2a>
		*d++ = *s++;
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	8d 50 01             	lea    0x1(%eax),%edx
  801015:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801018:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801021:	8a 12                	mov    (%edx),%dl
  801023:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 dd                	jne    80100f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104f:	73 50                	jae    8010a1 <memmove+0x6a>
  801051:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105c:	76 43                	jbe    8010a1 <memmove+0x6a>
		s += n;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106a:	eb 10                	jmp    80107c <memmove+0x45>
			*--d = *--s;
  80106c:	ff 4d f8             	decl   -0x8(%ebp)
  80106f:	ff 4d fc             	decl   -0x4(%ebp)
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	8a 10                	mov    (%eax),%dl
  801077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 e3                	jne    80106c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801089:	eb 23                	jmp    8010ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8d 50 01             	lea    0x1(%eax),%edx
  801091:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801097:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80109d:	8a 12                	mov    (%edx),%dl
  80109f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 dd                	jne    80108b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010c5:	eb 2a                	jmp    8010f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 10                	mov    (%eax),%dl
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	38 c2                	cmp    %al,%dl
  8010d3:	74 16                	je     8010eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 d0             	movzbl %al,%edx
  8010dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	29 c2                	sub    %eax,%edx
  8010e7:	89 d0                	mov    %edx,%eax
  8010e9:	eb 18                	jmp    801103 <memcmp+0x50>
		s1++, s2++;
  8010eb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 c9                	jne    8010c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801116:	eb 15                	jmp    80112d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	39 c2                	cmp    %eax,%edx
  801128:	74 0d                	je     801137 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112a:	ff 45 08             	incl   0x8(%ebp)
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801133:	72 e3                	jb     801118 <memfind+0x13>
  801135:	eb 01                	jmp    801138 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801137:	90                   	nop
	return (void *) s;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801151:	eb 03                	jmp    801156 <strtol+0x19>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 20                	cmp    $0x20,%al
  80115d:	74 f4                	je     801153 <strtol+0x16>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 09                	cmp    $0x9,%al
  801166:	74 eb                	je     801153 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2b                	cmp    $0x2b,%al
  80116f:	75 05                	jne    801176 <strtol+0x39>
		s++;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	eb 13                	jmp    801189 <strtol+0x4c>
	else if (*s == '-')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 2d                	cmp    $0x2d,%al
  80117d:	75 0a                	jne    801189 <strtol+0x4c>
		s++, neg = 1;
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801189:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118d:	74 06                	je     801195 <strtol+0x58>
  80118f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801193:	75 20                	jne    8011b5 <strtol+0x78>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 30                	cmp    $0x30,%al
  80119c:	75 17                	jne    8011b5 <strtol+0x78>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	40                   	inc    %eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 78                	cmp    $0x78,%al
  8011a6:	75 0d                	jne    8011b5 <strtol+0x78>
		s += 2, base = 16;
  8011a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b3:	eb 28                	jmp    8011dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	75 15                	jne    8011d0 <strtol+0x93>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 30                	cmp    $0x30,%al
  8011c2:	75 0c                	jne    8011d0 <strtol+0x93>
		s++, base = 8;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ce:	eb 0d                	jmp    8011dd <strtol+0xa0>
	else if (base == 0)
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	75 07                	jne    8011dd <strtol+0xa0>
		base = 10;
  8011d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 2f                	cmp    $0x2f,%al
  8011e4:	7e 19                	jle    8011ff <strtol+0xc2>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 39                	cmp    $0x39,%al
  8011ed:	7f 10                	jg     8011ff <strtol+0xc2>
			dig = *s - '0';
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f be c0             	movsbl %al,%eax
  8011f7:	83 e8 30             	sub    $0x30,%eax
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fd:	eb 42                	jmp    801241 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 60                	cmp    $0x60,%al
  801206:	7e 19                	jle    801221 <strtol+0xe4>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 7a                	cmp    $0x7a,%al
  80120f:	7f 10                	jg     801221 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 57             	sub    $0x57,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 20                	jmp    801241 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 40                	cmp    $0x40,%al
  801228:	7e 39                	jle    801263 <strtol+0x126>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 5a                	cmp    $0x5a,%al
  801231:	7f 30                	jg     801263 <strtol+0x126>
			dig = *s - 'A' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 37             	sub    $0x37,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801244:	3b 45 10             	cmp    0x10(%ebp),%eax
  801247:	7d 19                	jge    801262 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801249:	ff 45 08             	incl   0x8(%ebp)
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80125d:	e9 7b ff ff ff       	jmp    8011dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801262:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801267:	74 08                	je     801271 <strtol+0x134>
		*endptr = (char *) s;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	8b 55 08             	mov    0x8(%ebp),%edx
  80126f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801271:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801275:	74 07                	je     80127e <strtol+0x141>
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	f7 d8                	neg    %eax
  80127c:	eb 03                	jmp    801281 <strtol+0x144>
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <ltostr>:

void
ltostr(long value, char *str)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129b:	79 13                	jns    8012b0 <ltostr+0x2d>
	{
		neg = 1;
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b8:	99                   	cltd   
  8012b9:	f7 f9                	idiv   %ecx
  8012bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d1:	83 c2 30             	add    $0x30,%edx
  8012d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012de:	f7 e9                	imul   %ecx
  8012e0:	c1 fa 02             	sar    $0x2,%edx
  8012e3:	89 c8                	mov    %ecx,%eax
  8012e5:	c1 f8 1f             	sar    $0x1f,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
  8012ec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f7:	f7 e9                	imul   %ecx
  8012f9:	c1 fa 02             	sar    $0x2,%edx
  8012fc:	89 c8                	mov    %ecx,%eax
  8012fe:	c1 f8 1f             	sar    $0x1f,%eax
  801301:	29 c2                	sub    %eax,%edx
  801303:	89 d0                	mov    %edx,%eax
  801305:	c1 e0 02             	shl    $0x2,%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	01 c0                	add    %eax,%eax
  80130c:	29 c1                	sub    %eax,%ecx
  80130e:	89 ca                	mov    %ecx,%edx
  801310:	85 d2                	test   %edx,%edx
  801312:	75 9c                	jne    8012b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	48                   	dec    %eax
  80131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801322:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801326:	74 3d                	je     801365 <ltostr+0xe2>
		start = 1 ;
  801328:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80132f:	eb 34                	jmp    801365 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80133e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 c8                	add    %ecx,%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80135d:	88 02                	mov    %al,(%edx)
		start++ ;
  80135f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801362:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136b:	7c c4                	jl     801331 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80136d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801378:	90                   	nop
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 54 fa ff ff       	call   800ddd <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	e8 46 fa ff ff       	call   800ddd <strlen>
  801397:	83 c4 04             	add    $0x4,%esp
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80139d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ab:	eb 17                	jmp    8013c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 c2                	add    %eax,%edx
  8013b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	01 c8                	add    %ecx,%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c1:	ff 45 fc             	incl   -0x4(%ebp)
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ca:	7c e1                	jl     8013ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013da:	eb 1f                	jmp    8013fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8d 50 01             	lea    0x1(%eax),%edx
  8013e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f8:	ff 45 f8             	incl   -0x8(%ebp)
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801401:	7c d9                	jl     8013dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801403:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	c6 00 00             	movb   $0x0,(%eax)
}
  80140e:	90                   	nop
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	eb 0c                	jmp    801442 <strsplit+0x31>
			*string++ = 0;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8d 50 01             	lea    0x1(%eax),%edx
  80143c:	89 55 08             	mov    %edx,0x8(%ebp)
  80143f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	74 18                	je     801463 <strsplit+0x52>
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	50                   	push   %eax
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	e8 13 fb ff ff       	call   800f6f <strchr>
  80145c:	83 c4 08             	add    $0x8,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	75 d3                	jne    801436 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	84 c0                	test   %al,%al
  80146a:	74 5a                	je     8014c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146c:	8b 45 14             	mov    0x14(%ebp),%eax
  80146f:	8b 00                	mov    (%eax),%eax
  801471:	83 f8 0f             	cmp    $0xf,%eax
  801474:	75 07                	jne    80147d <strsplit+0x6c>
		{
			return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 66                	jmp    8014e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80147d:	8b 45 14             	mov    0x14(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	8d 48 01             	lea    0x1(%eax),%ecx
  801485:	8b 55 14             	mov    0x14(%ebp),%edx
  801488:	89 0a                	mov    %ecx,(%edx)
  80148a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149b:	eb 03                	jmp    8014a0 <strsplit+0x8f>
			string++;
  80149d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	84 c0                	test   %al,%al
  8014a7:	74 8b                	je     801434 <strsplit+0x23>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	0f be c0             	movsbl %al,%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	e8 b5 fa ff ff       	call   800f6f <strchr>
  8014ba:	83 c4 08             	add    $0x8,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	74 dc                	je     80149d <strsplit+0x8c>
			string++;
	}
  8014c1:	e9 6e ff ff ff       	jmp    801434 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 1f                	je     801513 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014f4:	e8 1d 00 00 00       	call   801516 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	68 f0 3c 80 00       	push   $0x803cf0
  801501:	e8 55 f2 ff ff       	call   80075b <cprintf>
  801506:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801509:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801510:	00 00 00 
	}
}
  801513:	90                   	nop
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  80151c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801523:	00 00 00 
  801526:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80152d:	00 00 00 
  801530:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801537:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  80153a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801541:	00 00 00 
  801544:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80154b:	00 00 00 
  80154e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801555:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  801558:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80155f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801562:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801567:	2d 00 10 00 00       	sub    $0x1000,%eax
  80156c:	a3 50 40 80 00       	mov    %eax,0x804050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  801571:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801578:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  80157b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801585:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  80158a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80158d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801590:	ba 00 00 00 00       	mov    $0x0,%edx
  801595:	f7 75 f0             	divl   -0x10(%ebp)
  801598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159b:	29 d0                	sub    %edx,%eax
  80159d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  8015a0:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015af:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	6a 06                	push   $0x6
  8015b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015bc:	50                   	push   %eax
  8015bd:	e8 d4 05 00 00       	call   801b96 <sys_allocate_chunk>
  8015c2:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015c5:	a1 20 41 80 00       	mov    0x804120,%eax
  8015ca:	83 ec 0c             	sub    $0xc,%esp
  8015cd:	50                   	push   %eax
  8015ce:	e8 49 0c 00 00       	call   80221c <initialize_MemBlocksList>
  8015d3:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  8015d6:	a1 48 41 80 00       	mov    0x804148,%eax
  8015db:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  8015de:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015e2:	75 14                	jne    8015f8 <initialize_dyn_block_system+0xe2>
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	68 15 3d 80 00       	push   $0x803d15
  8015ec:	6a 39                	push   $0x39
  8015ee:	68 33 3d 80 00       	push   $0x803d33
  8015f3:	e8 af ee ff ff       	call   8004a7 <_panic>
  8015f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015fb:	8b 00                	mov    (%eax),%eax
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	74 10                	je     801611 <initialize_dyn_block_system+0xfb>
  801601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801604:	8b 00                	mov    (%eax),%eax
  801606:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801609:	8b 52 04             	mov    0x4(%edx),%edx
  80160c:	89 50 04             	mov    %edx,0x4(%eax)
  80160f:	eb 0b                	jmp    80161c <initialize_dyn_block_system+0x106>
  801611:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801614:	8b 40 04             	mov    0x4(%eax),%eax
  801617:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80161c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161f:	8b 40 04             	mov    0x4(%eax),%eax
  801622:	85 c0                	test   %eax,%eax
  801624:	74 0f                	je     801635 <initialize_dyn_block_system+0x11f>
  801626:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801629:	8b 40 04             	mov    0x4(%eax),%eax
  80162c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80162f:	8b 12                	mov    (%edx),%edx
  801631:	89 10                	mov    %edx,(%eax)
  801633:	eb 0a                	jmp    80163f <initialize_dyn_block_system+0x129>
  801635:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801638:	8b 00                	mov    (%eax),%eax
  80163a:	a3 48 41 80 00       	mov    %eax,0x804148
  80163f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801642:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801648:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801652:	a1 54 41 80 00       	mov    0x804154,%eax
  801657:	48                   	dec    %eax
  801658:	a3 54 41 80 00       	mov    %eax,0x804154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  80165d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801660:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  801667:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80166a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  801671:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801675:	75 14                	jne    80168b <initialize_dyn_block_system+0x175>
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	68 40 3d 80 00       	push   $0x803d40
  80167f:	6a 3f                	push   $0x3f
  801681:	68 33 3d 80 00       	push   $0x803d33
  801686:	e8 1c ee ff ff       	call   8004a7 <_panic>
  80168b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801694:	89 10                	mov    %edx,(%eax)
  801696:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801699:	8b 00                	mov    (%eax),%eax
  80169b:	85 c0                	test   %eax,%eax
  80169d:	74 0d                	je     8016ac <initialize_dyn_block_system+0x196>
  80169f:	a1 38 41 80 00       	mov    0x804138,%eax
  8016a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016a7:	89 50 04             	mov    %edx,0x4(%eax)
  8016aa:	eb 08                	jmp    8016b4 <initialize_dyn_block_system+0x19e>
  8016ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016af:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b7:	a3 38 41 80 00       	mov    %eax,0x804138
  8016bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8016cb:	40                   	inc    %eax
  8016cc:	a3 44 41 80 00       	mov    %eax,0x804144

}
  8016d1:	90                   	nop
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016da:	e8 06 fe ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e3:	75 07                	jne    8016ec <malloc+0x18>
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	eb 7d                	jmp    801769 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  8016ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  8016f3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801700:	01 d0                	add    %edx,%eax
  801702:	48                   	dec    %eax
  801703:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801706:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801709:	ba 00 00 00 00       	mov    $0x0,%edx
  80170e:	f7 75 f0             	divl   -0x10(%ebp)
  801711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801714:	29 d0                	sub    %edx,%eax
  801716:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801719:	e8 46 08 00 00       	call   801f64 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80171e:	83 f8 01             	cmp    $0x1,%eax
  801721:	75 07                	jne    80172a <malloc+0x56>
  801723:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  80172a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  80172e:	75 34                	jne    801764 <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  801730:	83 ec 0c             	sub    $0xc,%esp
  801733:	ff 75 e8             	pushl  -0x18(%ebp)
  801736:	e8 73 0e 00 00       	call   8025ae <alloc_block_FF>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  801741:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801745:	74 16                	je     80175d <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  801747:	83 ec 0c             	sub    $0xc,%esp
  80174a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80174d:	e8 ff 0b 00 00       	call   802351 <insert_sorted_allocList>
  801752:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  801755:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801758:	8b 40 08             	mov    0x8(%eax),%eax
  80175b:	eb 0c                	jmp    801769 <malloc+0x95>
	             }
	             else
	             	return NULL;
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
  801762:	eb 05                	jmp    801769 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  801777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801780:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801785:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  801788:	83 ec 08             	sub    $0x8,%esp
  80178b:	ff 75 f4             	pushl  -0xc(%ebp)
  80178e:	68 40 40 80 00       	push   $0x804040
  801793:	e8 61 0b 00 00       	call   8022f9 <find_block>
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  80179e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017a2:	0f 84 a5 00 00 00    	je     80184d <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  8017a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	50                   	push   %eax
  8017b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b5:	e8 a4 03 00 00       	call   801b5e <sys_free_user_mem>
  8017ba:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  8017bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017c1:	75 17                	jne    8017da <free+0x6f>
  8017c3:	83 ec 04             	sub    $0x4,%esp
  8017c6:	68 15 3d 80 00       	push   $0x803d15
  8017cb:	68 87 00 00 00       	push   $0x87
  8017d0:	68 33 3d 80 00       	push   $0x803d33
  8017d5:	e8 cd ec ff ff       	call   8004a7 <_panic>
  8017da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017dd:	8b 00                	mov    (%eax),%eax
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	74 10                	je     8017f3 <free+0x88>
  8017e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e6:	8b 00                	mov    (%eax),%eax
  8017e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017eb:	8b 52 04             	mov    0x4(%edx),%edx
  8017ee:	89 50 04             	mov    %edx,0x4(%eax)
  8017f1:	eb 0b                	jmp    8017fe <free+0x93>
  8017f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f6:	8b 40 04             	mov    0x4(%eax),%eax
  8017f9:	a3 44 40 80 00       	mov    %eax,0x804044
  8017fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801801:	8b 40 04             	mov    0x4(%eax),%eax
  801804:	85 c0                	test   %eax,%eax
  801806:	74 0f                	je     801817 <free+0xac>
  801808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180b:	8b 40 04             	mov    0x4(%eax),%eax
  80180e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801811:	8b 12                	mov    (%edx),%edx
  801813:	89 10                	mov    %edx,(%eax)
  801815:	eb 0a                	jmp    801821 <free+0xb6>
  801817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181a:	8b 00                	mov    (%eax),%eax
  80181c:	a3 40 40 80 00       	mov    %eax,0x804040
  801821:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801824:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80182a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801834:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801839:	48                   	dec    %eax
  80183a:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(theBlock);
  80183f:	83 ec 0c             	sub    $0xc,%esp
  801842:	ff 75 ec             	pushl  -0x14(%ebp)
  801845:	e8 37 12 00 00       	call   802a81 <insert_sorted_with_merge_freeList>
  80184a:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  80184d:	90                   	nop
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 38             	sub    $0x38,%esp
  801856:	8b 45 10             	mov    0x10(%ebp),%eax
  801859:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80185c:	e8 84 fc ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801861:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801865:	75 07                	jne    80186e <smalloc+0x1e>
  801867:	b8 00 00 00 00       	mov    $0x0,%eax
  80186c:	eb 7e                	jmp    8018ec <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  80186e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801875:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80187c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801882:	01 d0                	add    %edx,%eax
  801884:	48                   	dec    %eax
  801885:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80188b:	ba 00 00 00 00       	mov    $0x0,%edx
  801890:	f7 75 f0             	divl   -0x10(%ebp)
  801893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801896:	29 d0                	sub    %edx,%eax
  801898:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  80189b:	e8 c4 06 00 00       	call   801f64 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018a0:	83 f8 01             	cmp    $0x1,%eax
  8018a3:	75 42                	jne    8018e7 <smalloc+0x97>

		  va = malloc(newsize) ;
  8018a5:	83 ec 0c             	sub    $0xc,%esp
  8018a8:	ff 75 e8             	pushl  -0x18(%ebp)
  8018ab:	e8 24 fe ff ff       	call   8016d4 <malloc>
  8018b0:	83 c4 10             	add    $0x10,%esp
  8018b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  8018b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018ba:	74 24                	je     8018e0 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  8018bc:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018c3:	50                   	push   %eax
  8018c4:	ff 75 e8             	pushl  -0x18(%ebp)
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	e8 1a 04 00 00       	call   801ce9 <sys_createSharedObject>
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  8018d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018d9:	78 0c                	js     8018e7 <smalloc+0x97>
					  return va ;
  8018db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018de:	eb 0c                	jmp    8018ec <smalloc+0x9c>
				 }
				 else
					return NULL;
  8018e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e5:	eb 05                	jmp    8018ec <smalloc+0x9c>
	  }
		  return NULL ;
  8018e7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018f4:	e8 ec fb ff ff       	call   8014e5 <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  8018f9:	83 ec 08             	sub    $0x8,%esp
  8018fc:	ff 75 0c             	pushl  0xc(%ebp)
  8018ff:	ff 75 08             	pushl  0x8(%ebp)
  801902:	e8 0c 04 00 00       	call   801d13 <sys_getSizeOfSharedObject>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  80190d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801911:	75 07                	jne    80191a <sget+0x2c>
  801913:	b8 00 00 00 00       	mov    $0x0,%eax
  801918:	eb 75                	jmp    80198f <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80191a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801921:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801927:	01 d0                	add    %edx,%eax
  801929:	48                   	dec    %eax
  80192a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80192d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801930:	ba 00 00 00 00       	mov    $0x0,%edx
  801935:	f7 75 f0             	divl   -0x10(%ebp)
  801938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193b:	29 d0                	sub    %edx,%eax
  80193d:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801940:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801947:	e8 18 06 00 00       	call   801f64 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80194c:	83 f8 01             	cmp    $0x1,%eax
  80194f:	75 39                	jne    80198a <sget+0x9c>

		  va = malloc(newsize) ;
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	ff 75 e8             	pushl  -0x18(%ebp)
  801957:	e8 78 fd ff ff       	call   8016d4 <malloc>
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801962:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801966:	74 22                	je     80198a <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	ff 75 e0             	pushl  -0x20(%ebp)
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	e8 b7 03 00 00       	call   801d30 <sys_getSharedObject>
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  80197f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801983:	78 05                	js     80198a <sget+0x9c>
					  return va;
  801985:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801988:	eb 05                	jmp    80198f <sget+0xa1>
				  }
			  }
     }
         return NULL;
  80198a:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801997:	e8 49 fb ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	68 64 3d 80 00       	push   $0x803d64
  8019a4:	68 1e 01 00 00       	push   $0x11e
  8019a9:	68 33 3d 80 00       	push   $0x803d33
  8019ae:	e8 f4 ea ff ff       	call   8004a7 <_panic>

008019b3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	68 8c 3d 80 00       	push   $0x803d8c
  8019c1:	68 32 01 00 00       	push   $0x132
  8019c6:	68 33 3d 80 00       	push   $0x803d33
  8019cb:	e8 d7 ea ff ff       	call   8004a7 <_panic>

008019d0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	68 b0 3d 80 00       	push   $0x803db0
  8019de:	68 3d 01 00 00       	push   $0x13d
  8019e3:	68 33 3d 80 00       	push   $0x803d33
  8019e8:	e8 ba ea ff ff       	call   8004a7 <_panic>

008019ed <shrink>:

}
void shrink(uint32 newSize)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	68 b0 3d 80 00       	push   $0x803db0
  8019fb:	68 42 01 00 00       	push   $0x142
  801a00:	68 33 3d 80 00       	push   $0x803d33
  801a05:	e8 9d ea ff ff       	call   8004a7 <_panic>

00801a0a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	68 b0 3d 80 00       	push   $0x803db0
  801a18:	68 47 01 00 00       	push   $0x147
  801a1d:	68 33 3d 80 00       	push   $0x803d33
  801a22:	e8 80 ea ff ff       	call   8004a7 <_panic>

00801a27 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	57                   	push   %edi
  801a2b:	56                   	push   %esi
  801a2c:	53                   	push   %ebx
  801a2d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a3c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a3f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a42:	cd 30                	int    $0x30
  801a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	5b                   	pop    %ebx
  801a4e:	5e                   	pop    %esi
  801a4f:	5f                   	pop    %edi
  801a50:	5d                   	pop    %ebp
  801a51:	c3                   	ret    

00801a52 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 04             	sub    $0x4,%esp
  801a58:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a5e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	50                   	push   %eax
  801a6e:	6a 00                	push   $0x0
  801a70:	e8 b2 ff ff ff       	call   801a27 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_cgetc>:

int
sys_cgetc(void)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 01                	push   $0x1
  801a8a:	e8 98 ff ff ff       	call   801a27 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	52                   	push   %edx
  801aa4:	50                   	push   %eax
  801aa5:	6a 05                	push   $0x5
  801aa7:	e8 7b ff ff ff       	call   801a27 <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	56                   	push   %esi
  801ab5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ab6:	8b 75 18             	mov    0x18(%ebp),%esi
  801ab9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801abc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801abf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac5:	56                   	push   %esi
  801ac6:	53                   	push   %ebx
  801ac7:	51                   	push   %ecx
  801ac8:	52                   	push   %edx
  801ac9:	50                   	push   %eax
  801aca:	6a 06                	push   $0x6
  801acc:	e8 56 ff ff ff       	call   801a27 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5d                   	pop    %ebp
  801ada:	c3                   	ret    

00801adb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ade:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	52                   	push   %edx
  801aeb:	50                   	push   %eax
  801aec:	6a 07                	push   $0x7
  801aee:	e8 34 ff ff ff       	call   801a27 <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	ff 75 0c             	pushl  0xc(%ebp)
  801b04:	ff 75 08             	pushl  0x8(%ebp)
  801b07:	6a 08                	push   $0x8
  801b09:	e8 19 ff ff ff       	call   801a27 <syscall>
  801b0e:	83 c4 18             	add    $0x18,%esp
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 09                	push   $0x9
  801b22:	e8 00 ff ff ff       	call   801a27 <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 0a                	push   $0xa
  801b3b:	e8 e7 fe ff ff       	call   801a27 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 0b                	push   $0xb
  801b54:	e8 ce fe ff ff       	call   801a27 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	6a 0f                	push   $0xf
  801b6f:	e8 b3 fe ff ff       	call   801a27 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
	return;
  801b77:	90                   	nop
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	ff 75 0c             	pushl  0xc(%ebp)
  801b86:	ff 75 08             	pushl  0x8(%ebp)
  801b89:	6a 10                	push   $0x10
  801b8b:	e8 97 fe ff ff       	call   801a27 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
	return ;
  801b93:	90                   	nop
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 10             	pushl  0x10(%ebp)
  801ba0:	ff 75 0c             	pushl  0xc(%ebp)
  801ba3:	ff 75 08             	pushl  0x8(%ebp)
  801ba6:	6a 11                	push   $0x11
  801ba8:	e8 7a fe ff ff       	call   801a27 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb0:	90                   	nop
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 0c                	push   $0xc
  801bc2:	e8 60 fe ff ff       	call   801a27 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	6a 0d                	push   $0xd
  801bdc:	e8 46 fe ff ff       	call   801a27 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 0e                	push   $0xe
  801bf5:	e8 2d fe ff ff       	call   801a27 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	90                   	nop
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 13                	push   $0x13
  801c0f:	e8 13 fe ff ff       	call   801a27 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	90                   	nop
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 14                	push   $0x14
  801c29:	e8 f9 fd ff ff       	call   801a27 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	90                   	nop
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c40:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	50                   	push   %eax
  801c4d:	6a 15                	push   $0x15
  801c4f:	e8 d3 fd ff ff       	call   801a27 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	90                   	nop
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 16                	push   $0x16
  801c69:	e8 b9 fd ff ff       	call   801a27 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	90                   	nop
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	50                   	push   %eax
  801c84:	6a 17                	push   $0x17
  801c86:	e8 9c fd ff ff       	call   801a27 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	52                   	push   %edx
  801ca0:	50                   	push   %eax
  801ca1:	6a 1a                	push   $0x1a
  801ca3:	e8 7f fd ff ff       	call   801a27 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	52                   	push   %edx
  801cbd:	50                   	push   %eax
  801cbe:	6a 18                	push   $0x18
  801cc0:	e8 62 fd ff ff       	call   801a27 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	90                   	nop
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	52                   	push   %edx
  801cdb:	50                   	push   %eax
  801cdc:	6a 19                	push   $0x19
  801cde:	e8 44 fd ff ff       	call   801a27 <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	90                   	nop
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 04             	sub    $0x4,%esp
  801cef:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cf5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cf8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	6a 00                	push   $0x0
  801d01:	51                   	push   %ecx
  801d02:	52                   	push   %edx
  801d03:	ff 75 0c             	pushl  0xc(%ebp)
  801d06:	50                   	push   %eax
  801d07:	6a 1b                	push   $0x1b
  801d09:	e8 19 fd ff ff       	call   801a27 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	52                   	push   %edx
  801d23:	50                   	push   %eax
  801d24:	6a 1c                	push   $0x1c
  801d26:	e8 fc fc ff ff       	call   801a27 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	51                   	push   %ecx
  801d41:	52                   	push   %edx
  801d42:	50                   	push   %eax
  801d43:	6a 1d                	push   $0x1d
  801d45:	e8 dd fc ff ff       	call   801a27 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	6a 1e                	push   $0x1e
  801d62:	e8 c0 fc ff ff       	call   801a27 <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 1f                	push   $0x1f
  801d7b:	e8 a7 fc ff ff       	call   801a27 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	ff 75 14             	pushl  0x14(%ebp)
  801d90:	ff 75 10             	pushl  0x10(%ebp)
  801d93:	ff 75 0c             	pushl  0xc(%ebp)
  801d96:	50                   	push   %eax
  801d97:	6a 20                	push   $0x20
  801d99:	e8 89 fc ff ff       	call   801a27 <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	50                   	push   %eax
  801db2:	6a 21                	push   $0x21
  801db4:	e8 6e fc ff ff       	call   801a27 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	90                   	nop
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	50                   	push   %eax
  801dce:	6a 22                	push   $0x22
  801dd0:	e8 52 fc ff ff       	call   801a27 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 02                	push   $0x2
  801de9:	e8 39 fc ff ff       	call   801a27 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 03                	push   $0x3
  801e02:	e8 20 fc ff ff       	call   801a27 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 04                	push   $0x4
  801e1b:	e8 07 fc ff ff       	call   801a27 <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_exit_env>:


void sys_exit_env(void)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 23                	push   $0x23
  801e34:	e8 ee fb ff ff       	call   801a27 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	90                   	nop
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e45:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e48:	8d 50 04             	lea    0x4(%eax),%edx
  801e4b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	52                   	push   %edx
  801e55:	50                   	push   %eax
  801e56:	6a 24                	push   $0x24
  801e58:	e8 ca fb ff ff       	call   801a27 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
	return result;
  801e60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e69:	89 01                	mov    %eax,(%ecx)
  801e6b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	c9                   	leave  
  801e72:	c2 04 00             	ret    $0x4

00801e75 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	ff 75 10             	pushl  0x10(%ebp)
  801e7f:	ff 75 0c             	pushl  0xc(%ebp)
  801e82:	ff 75 08             	pushl  0x8(%ebp)
  801e85:	6a 12                	push   $0x12
  801e87:	e8 9b fb ff ff       	call   801a27 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8f:	90                   	nop
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 25                	push   $0x25
  801ea1:	e8 81 fb ff ff       	call   801a27 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 04             	sub    $0x4,%esp
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801eb7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	50                   	push   %eax
  801ec4:	6a 26                	push   $0x26
  801ec6:	e8 5c fb ff ff       	call   801a27 <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ece:	90                   	nop
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <rsttst>:
void rsttst()
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 28                	push   $0x28
  801ee0:	e8 42 fb ff ff       	call   801a27 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee8:	90                   	nop
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 04             	sub    $0x4,%esp
  801ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ef7:	8b 55 18             	mov    0x18(%ebp),%edx
  801efa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801efe:	52                   	push   %edx
  801eff:	50                   	push   %eax
  801f00:	ff 75 10             	pushl  0x10(%ebp)
  801f03:	ff 75 0c             	pushl  0xc(%ebp)
  801f06:	ff 75 08             	pushl  0x8(%ebp)
  801f09:	6a 27                	push   $0x27
  801f0b:	e8 17 fb ff ff       	call   801a27 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
	return ;
  801f13:	90                   	nop
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <chktst>:
void chktst(uint32 n)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	ff 75 08             	pushl  0x8(%ebp)
  801f24:	6a 29                	push   $0x29
  801f26:	e8 fc fa ff ff       	call   801a27 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2e:	90                   	nop
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <inctst>:

void inctst()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 2a                	push   $0x2a
  801f40:	e8 e2 fa ff ff       	call   801a27 <syscall>
  801f45:	83 c4 18             	add    $0x18,%esp
	return ;
  801f48:	90                   	nop
}
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <gettst>:
uint32 gettst()
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 2b                	push   $0x2b
  801f5a:	e8 c8 fa ff ff       	call   801a27 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 2c                	push   $0x2c
  801f76:	e8 ac fa ff ff       	call   801a27 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
  801f7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f81:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f85:	75 07                	jne    801f8e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f87:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8c:	eb 05                	jmp    801f93 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 2c                	push   $0x2c
  801fa7:	e8 7b fa ff ff       	call   801a27 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
  801faf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fb2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fb6:	75 07                	jne    801fbf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbd:	eb 05                	jmp    801fc4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	6a 2c                	push   $0x2c
  801fd8:	e8 4a fa ff ff       	call   801a27 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
  801fe0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fe3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fe7:	75 07                	jne    801ff0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fe9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fee:	eb 05                	jmp    801ff5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 2c                	push   $0x2c
  802009:	e8 19 fa ff ff       	call   801a27 <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
  802011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802014:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802018:	75 07                	jne    802021 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80201a:	b8 01 00 00 00       	mov    $0x1,%eax
  80201f:	eb 05                	jmp    802026 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	ff 75 08             	pushl  0x8(%ebp)
  802036:	6a 2d                	push   $0x2d
  802038:	e8 ea f9 ff ff       	call   801a27 <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
	return ;
  802040:	90                   	nop
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802047:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80204a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	6a 00                	push   $0x0
  802055:	53                   	push   %ebx
  802056:	51                   	push   %ecx
  802057:	52                   	push   %edx
  802058:	50                   	push   %eax
  802059:	6a 2e                	push   $0x2e
  80205b:	e8 c7 f9 ff ff       	call   801a27 <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
}
  802063:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80206b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	52                   	push   %edx
  802078:	50                   	push   %eax
  802079:	6a 2f                	push   $0x2f
  80207b:	e8 a7 f9 ff ff       	call   801a27 <syscall>
  802080:	83 c4 18             	add    $0x18,%esp
}
  802083:	c9                   	leave  
  802084:	c3                   	ret    

00802085 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	68 c0 3d 80 00       	push   $0x803dc0
  802093:	e8 c3 e6 ff ff       	call   80075b <cprintf>
  802098:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80209b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020a2:	83 ec 0c             	sub    $0xc,%esp
  8020a5:	68 ec 3d 80 00       	push   $0x803dec
  8020aa:	e8 ac e6 ff ff       	call   80075b <cprintf>
  8020af:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020b2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020b6:	a1 38 41 80 00       	mov    0x804138,%eax
  8020bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020be:	eb 56                	jmp    802116 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c4:	74 1c                	je     8020e2 <print_mem_block_lists+0x5d>
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 50 08             	mov    0x8(%eax),%edx
  8020cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cf:	8b 48 08             	mov    0x8(%eax),%ecx
  8020d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d8:	01 c8                	add    %ecx,%eax
  8020da:	39 c2                	cmp    %eax,%edx
  8020dc:	73 04                	jae    8020e2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020de:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 50 08             	mov    0x8(%eax),%edx
  8020e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ee:	01 c2                	add    %eax,%edx
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 40 08             	mov    0x8(%eax),%eax
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	52                   	push   %edx
  8020fa:	50                   	push   %eax
  8020fb:	68 01 3e 80 00       	push   $0x803e01
  802100:	e8 56 e6 ff ff       	call   80075b <cprintf>
  802105:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80210e:	a1 40 41 80 00       	mov    0x804140,%eax
  802113:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802116:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211a:	74 07                	je     802123 <print_mem_block_lists+0x9e>
  80211c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211f:	8b 00                	mov    (%eax),%eax
  802121:	eb 05                	jmp    802128 <print_mem_block_lists+0xa3>
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	a3 40 41 80 00       	mov    %eax,0x804140
  80212d:	a1 40 41 80 00       	mov    0x804140,%eax
  802132:	85 c0                	test   %eax,%eax
  802134:	75 8a                	jne    8020c0 <print_mem_block_lists+0x3b>
  802136:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213a:	75 84                	jne    8020c0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80213c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802140:	75 10                	jne    802152 <print_mem_block_lists+0xcd>
  802142:	83 ec 0c             	sub    $0xc,%esp
  802145:	68 10 3e 80 00       	push   $0x803e10
  80214a:	e8 0c e6 ff ff       	call   80075b <cprintf>
  80214f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802152:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802159:	83 ec 0c             	sub    $0xc,%esp
  80215c:	68 34 3e 80 00       	push   $0x803e34
  802161:	e8 f5 e5 ff ff       	call   80075b <cprintf>
  802166:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802169:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80216d:	a1 40 40 80 00       	mov    0x804040,%eax
  802172:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802175:	eb 56                	jmp    8021cd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802177:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80217b:	74 1c                	je     802199 <print_mem_block_lists+0x114>
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	8b 50 08             	mov    0x8(%eax),%edx
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802186:	8b 48 08             	mov    0x8(%eax),%ecx
  802189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218c:	8b 40 0c             	mov    0xc(%eax),%eax
  80218f:	01 c8                	add    %ecx,%eax
  802191:	39 c2                	cmp    %eax,%edx
  802193:	73 04                	jae    802199 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802195:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 50 08             	mov    0x8(%eax),%edx
  80219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a5:	01 c2                	add    %eax,%edx
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 40 08             	mov    0x8(%eax),%eax
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	52                   	push   %edx
  8021b1:	50                   	push   %eax
  8021b2:	68 01 3e 80 00       	push   $0x803e01
  8021b7:	e8 9f e5 ff ff       	call   80075b <cprintf>
  8021bc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021c5:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d1:	74 07                	je     8021da <print_mem_block_lists+0x155>
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	8b 00                	mov    (%eax),%eax
  8021d8:	eb 05                	jmp    8021df <print_mem_block_lists+0x15a>
  8021da:	b8 00 00 00 00       	mov    $0x0,%eax
  8021df:	a3 48 40 80 00       	mov    %eax,0x804048
  8021e4:	a1 48 40 80 00       	mov    0x804048,%eax
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	75 8a                	jne    802177 <print_mem_block_lists+0xf2>
  8021ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f1:	75 84                	jne    802177 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021f3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021f7:	75 10                	jne    802209 <print_mem_block_lists+0x184>
  8021f9:	83 ec 0c             	sub    $0xc,%esp
  8021fc:	68 4c 3e 80 00       	push   $0x803e4c
  802201:	e8 55 e5 ff ff       	call   80075b <cprintf>
  802206:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802209:	83 ec 0c             	sub    $0xc,%esp
  80220c:	68 c0 3d 80 00       	push   $0x803dc0
  802211:	e8 45 e5 ff ff       	call   80075b <cprintf>
  802216:	83 c4 10             	add    $0x10,%esp

}
  802219:	90                   	nop
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802222:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802229:	00 00 00 
  80222c:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802233:	00 00 00 
  802236:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80223d:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  802240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802247:	e9 9e 00 00 00       	jmp    8022ea <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  80224c:	a1 50 40 80 00       	mov    0x804050,%eax
  802251:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802254:	c1 e2 04             	shl    $0x4,%edx
  802257:	01 d0                	add    %edx,%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	75 14                	jne    802271 <initialize_MemBlocksList+0x55>
  80225d:	83 ec 04             	sub    $0x4,%esp
  802260:	68 74 3e 80 00       	push   $0x803e74
  802265:	6a 47                	push   $0x47
  802267:	68 97 3e 80 00       	push   $0x803e97
  80226c:	e8 36 e2 ff ff       	call   8004a7 <_panic>
  802271:	a1 50 40 80 00       	mov    0x804050,%eax
  802276:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802279:	c1 e2 04             	shl    $0x4,%edx
  80227c:	01 d0                	add    %edx,%eax
  80227e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802284:	89 10                	mov    %edx,(%eax)
  802286:	8b 00                	mov    (%eax),%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	74 18                	je     8022a4 <initialize_MemBlocksList+0x88>
  80228c:	a1 48 41 80 00       	mov    0x804148,%eax
  802291:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802297:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80229a:	c1 e1 04             	shl    $0x4,%ecx
  80229d:	01 ca                	add    %ecx,%edx
  80229f:	89 50 04             	mov    %edx,0x4(%eax)
  8022a2:	eb 12                	jmp    8022b6 <initialize_MemBlocksList+0x9a>
  8022a4:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ac:	c1 e2 04             	shl    $0x4,%edx
  8022af:	01 d0                	add    %edx,%eax
  8022b1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022b6:	a1 50 40 80 00       	mov    0x804050,%eax
  8022bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022be:	c1 e2 04             	shl    $0x4,%edx
  8022c1:	01 d0                	add    %edx,%eax
  8022c3:	a3 48 41 80 00       	mov    %eax,0x804148
  8022c8:	a1 50 40 80 00       	mov    0x804050,%eax
  8022cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d0:	c1 e2 04             	shl    $0x4,%edx
  8022d3:	01 d0                	add    %edx,%eax
  8022d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022dc:	a1 54 41 80 00       	mov    0x804154,%eax
  8022e1:	40                   	inc    %eax
  8022e2:	a3 54 41 80 00       	mov    %eax,0x804154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8022e7:	ff 45 f4             	incl   -0xc(%ebp)
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f0:	0f 82 56 ff ff ff    	jb     80224c <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  8022f6:	90                   	nop
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	8b 00                	mov    (%eax),%eax
  802304:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802307:	eb 19                	jmp    802322 <find_block+0x29>
	{
		if(element->sva == va){
  802309:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230c:	8b 40 08             	mov    0x8(%eax),%eax
  80230f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802312:	75 05                	jne    802319 <find_block+0x20>
			 		return element;
  802314:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802317:	eb 36                	jmp    80234f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	8b 40 08             	mov    0x8(%eax),%eax
  80231f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802322:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802326:	74 07                	je     80232f <find_block+0x36>
  802328:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80232b:	8b 00                	mov    (%eax),%eax
  80232d:	eb 05                	jmp    802334 <find_block+0x3b>
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
  802334:	8b 55 08             	mov    0x8(%ebp),%edx
  802337:	89 42 08             	mov    %eax,0x8(%edx)
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	8b 40 08             	mov    0x8(%eax),%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	75 c5                	jne    802309 <find_block+0x10>
  802344:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802348:	75 bf                	jne    802309 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  80234a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  802357:	a1 44 40 80 00       	mov    0x804044,%eax
  80235c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  80235f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802364:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  802367:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80236b:	74 0a                	je     802377 <insert_sorted_allocList+0x26>
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	8b 40 08             	mov    0x8(%eax),%eax
  802373:	85 c0                	test   %eax,%eax
  802375:	75 65                	jne    8023dc <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237b:	75 14                	jne    802391 <insert_sorted_allocList+0x40>
  80237d:	83 ec 04             	sub    $0x4,%esp
  802380:	68 74 3e 80 00       	push   $0x803e74
  802385:	6a 6e                	push   $0x6e
  802387:	68 97 3e 80 00       	push   $0x803e97
  80238c:	e8 16 e1 ff ff       	call   8004a7 <_panic>
  802391:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	89 10                	mov    %edx,(%eax)
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	8b 00                	mov    (%eax),%eax
  8023a1:	85 c0                	test   %eax,%eax
  8023a3:	74 0d                	je     8023b2 <insert_sorted_allocList+0x61>
  8023a5:	a1 40 40 80 00       	mov    0x804040,%eax
  8023aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ad:	89 50 04             	mov    %edx,0x4(%eax)
  8023b0:	eb 08                	jmp    8023ba <insert_sorted_allocList+0x69>
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	a3 44 40 80 00       	mov    %eax,0x804044
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	a3 40 40 80 00       	mov    %eax,0x804040
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023cc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023d1:	40                   	inc    %eax
  8023d2:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8023d7:	e9 cf 01 00 00       	jmp    8025ab <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  8023dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023df:	8b 50 08             	mov    0x8(%eax),%edx
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	8b 40 08             	mov    0x8(%eax),%eax
  8023e8:	39 c2                	cmp    %eax,%edx
  8023ea:	73 65                	jae    802451 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8023ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f0:	75 14                	jne    802406 <insert_sorted_allocList+0xb5>
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	68 b0 3e 80 00       	push   $0x803eb0
  8023fa:	6a 72                	push   $0x72
  8023fc:	68 97 3e 80 00       	push   $0x803e97
  802401:	e8 a1 e0 ff ff       	call   8004a7 <_panic>
  802406:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	89 50 04             	mov    %edx,0x4(%eax)
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8b 40 04             	mov    0x4(%eax),%eax
  802418:	85 c0                	test   %eax,%eax
  80241a:	74 0c                	je     802428 <insert_sorted_allocList+0xd7>
  80241c:	a1 44 40 80 00       	mov    0x804044,%eax
  802421:	8b 55 08             	mov    0x8(%ebp),%edx
  802424:	89 10                	mov    %edx,(%eax)
  802426:	eb 08                	jmp    802430 <insert_sorted_allocList+0xdf>
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	a3 40 40 80 00       	mov    %eax,0x804040
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	a3 44 40 80 00       	mov    %eax,0x804044
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802441:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802446:	40                   	inc    %eax
  802447:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  80244c:	e9 5a 01 00 00       	jmp    8025ab <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  802451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802454:	8b 50 08             	mov    0x8(%eax),%edx
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	8b 40 08             	mov    0x8(%eax),%eax
  80245d:	39 c2                	cmp    %eax,%edx
  80245f:	75 70                	jne    8024d1 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  802461:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802465:	74 06                	je     80246d <insert_sorted_allocList+0x11c>
  802467:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80246b:	75 14                	jne    802481 <insert_sorted_allocList+0x130>
  80246d:	83 ec 04             	sub    $0x4,%esp
  802470:	68 d4 3e 80 00       	push   $0x803ed4
  802475:	6a 75                	push   $0x75
  802477:	68 97 3e 80 00       	push   $0x803e97
  80247c:	e8 26 e0 ff ff       	call   8004a7 <_panic>
  802481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802484:	8b 10                	mov    (%eax),%edx
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	89 10                	mov    %edx,(%eax)
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	8b 00                	mov    (%eax),%eax
  802490:	85 c0                	test   %eax,%eax
  802492:	74 0b                	je     80249f <insert_sorted_allocList+0x14e>
  802494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	8b 55 08             	mov    0x8(%ebp),%edx
  80249c:	89 50 04             	mov    %edx,0x4(%eax)
  80249f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a5:	89 10                	mov    %edx,(%eax)
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ad:	89 50 04             	mov    %edx,0x4(%eax)
  8024b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	75 08                	jne    8024c1 <insert_sorted_allocList+0x170>
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	a3 44 40 80 00       	mov    %eax,0x804044
  8024c1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024c6:	40                   	inc    %eax
  8024c7:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
			  }
	    }
	  }

}
  8024cc:	e9 da 00 00 00       	jmp    8025ab <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8024d1:	a1 40 40 80 00       	mov    0x804040,%eax
  8024d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d9:	e9 9d 00 00 00       	jmp    80257b <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	8b 50 08             	mov    0x8(%eax),%edx
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 40 08             	mov    0x8(%eax),%eax
  8024f2:	39 c2                	cmp    %eax,%edx
  8024f4:	76 7d                	jbe    802573 <insert_sorted_allocList+0x222>
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	8b 50 08             	mov    0x8(%eax),%edx
  8024fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ff:	8b 40 08             	mov    0x8(%eax),%eax
  802502:	39 c2                	cmp    %eax,%edx
  802504:	73 6d                	jae    802573 <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802506:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250a:	74 06                	je     802512 <insert_sorted_allocList+0x1c1>
  80250c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802510:	75 14                	jne    802526 <insert_sorted_allocList+0x1d5>
  802512:	83 ec 04             	sub    $0x4,%esp
  802515:	68 d4 3e 80 00       	push   $0x803ed4
  80251a:	6a 7c                	push   $0x7c
  80251c:	68 97 3e 80 00       	push   $0x803e97
  802521:	e8 81 df ff ff       	call   8004a7 <_panic>
  802526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802529:	8b 10                	mov    (%eax),%edx
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	89 10                	mov    %edx,(%eax)
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	8b 00                	mov    (%eax),%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	74 0b                	je     802544 <insert_sorted_allocList+0x1f3>
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	8b 55 08             	mov    0x8(%ebp),%edx
  802541:	89 50 04             	mov    %edx,0x4(%eax)
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 55 08             	mov    0x8(%ebp),%edx
  80254a:	89 10                	mov    %edx,(%eax)
  80254c:	8b 45 08             	mov    0x8(%ebp),%eax
  80254f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802552:	89 50 04             	mov    %edx,0x4(%eax)
  802555:	8b 45 08             	mov    0x8(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	85 c0                	test   %eax,%eax
  80255c:	75 08                	jne    802566 <insert_sorted_allocList+0x215>
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	a3 44 40 80 00       	mov    %eax,0x804044
  802566:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80256b:	40                   	inc    %eax
  80256c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802571:	eb 38                	jmp    8025ab <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802573:	a1 48 40 80 00       	mov    0x804048,%eax
  802578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257f:	74 07                	je     802588 <insert_sorted_allocList+0x237>
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	eb 05                	jmp    80258d <insert_sorted_allocList+0x23c>
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	a3 48 40 80 00       	mov    %eax,0x804048
  802592:	a1 48 40 80 00       	mov    0x804048,%eax
  802597:	85 c0                	test   %eax,%eax
  802599:	0f 85 3f ff ff ff    	jne    8024de <insert_sorted_allocList+0x18d>
  80259f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a3:	0f 85 35 ff ff ff    	jne    8024de <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  8025a9:	eb 00                	jmp    8025ab <insert_sorted_allocList+0x25a>
  8025ab:	90                   	nop
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  8025b4:	a1 38 41 80 00       	mov    0x804138,%eax
  8025b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bc:	e9 6b 02 00 00       	jmp    80282c <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ca:	0f 85 90 00 00 00    	jne    802660 <alloc_block_FF+0xb2>
			  temp=element;
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  8025d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025da:	75 17                	jne    8025f3 <alloc_block_FF+0x45>
  8025dc:	83 ec 04             	sub    $0x4,%esp
  8025df:	68 08 3f 80 00       	push   $0x803f08
  8025e4:	68 92 00 00 00       	push   $0x92
  8025e9:	68 97 3e 80 00       	push   $0x803e97
  8025ee:	e8 b4 de ff ff       	call   8004a7 <_panic>
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	85 c0                	test   %eax,%eax
  8025fa:	74 10                	je     80260c <alloc_block_FF+0x5e>
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802604:	8b 52 04             	mov    0x4(%edx),%edx
  802607:	89 50 04             	mov    %edx,0x4(%eax)
  80260a:	eb 0b                	jmp    802617 <alloc_block_FF+0x69>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 40 04             	mov    0x4(%eax),%eax
  802612:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 40 04             	mov    0x4(%eax),%eax
  80261d:	85 c0                	test   %eax,%eax
  80261f:	74 0f                	je     802630 <alloc_block_FF+0x82>
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 40 04             	mov    0x4(%eax),%eax
  802627:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262a:	8b 12                	mov    (%edx),%edx
  80262c:	89 10                	mov    %edx,(%eax)
  80262e:	eb 0a                	jmp    80263a <alloc_block_FF+0x8c>
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	a3 38 41 80 00       	mov    %eax,0x804138
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264d:	a1 44 41 80 00       	mov    0x804144,%eax
  802652:	48                   	dec    %eax
  802653:	a3 44 41 80 00       	mov    %eax,0x804144
			  return temp;
  802658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265b:	e9 ff 01 00 00       	jmp    80285f <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 40 0c             	mov    0xc(%eax),%eax
  802666:	3b 45 08             	cmp    0x8(%ebp),%eax
  802669:	0f 86 b5 01 00 00    	jbe    802824 <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 40 0c             	mov    0xc(%eax),%eax
  802675:	2b 45 08             	sub    0x8(%ebp),%eax
  802678:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  80267b:	a1 48 41 80 00       	mov    0x804148,%eax
  802680:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  802683:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802687:	75 17                	jne    8026a0 <alloc_block_FF+0xf2>
  802689:	83 ec 04             	sub    $0x4,%esp
  80268c:	68 08 3f 80 00       	push   $0x803f08
  802691:	68 99 00 00 00       	push   $0x99
  802696:	68 97 3e 80 00       	push   $0x803e97
  80269b:	e8 07 de ff ff       	call   8004a7 <_panic>
  8026a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 10                	je     8026b9 <alloc_block_FF+0x10b>
  8026a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b1:	8b 52 04             	mov    0x4(%edx),%edx
  8026b4:	89 50 04             	mov    %edx,0x4(%eax)
  8026b7:	eb 0b                	jmp    8026c4 <alloc_block_FF+0x116>
  8026b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 0f                	je     8026dd <alloc_block_FF+0x12f>
  8026ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026d7:	8b 12                	mov    (%edx),%edx
  8026d9:	89 10                	mov    %edx,(%eax)
  8026db:	eb 0a                	jmp    8026e7 <alloc_block_FF+0x139>
  8026dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	a3 48 41 80 00       	mov    %eax,0x804148
  8026e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fa:	a1 54 41 80 00       	mov    0x804154,%eax
  8026ff:	48                   	dec    %eax
  802700:	a3 54 41 80 00       	mov    %eax,0x804154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  802705:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802709:	75 17                	jne    802722 <alloc_block_FF+0x174>
  80270b:	83 ec 04             	sub    $0x4,%esp
  80270e:	68 b0 3e 80 00       	push   $0x803eb0
  802713:	68 9a 00 00 00       	push   $0x9a
  802718:	68 97 3e 80 00       	push   $0x803e97
  80271d:	e8 85 dd ff ff       	call   8004a7 <_panic>
  802722:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272b:	89 50 04             	mov    %edx,0x4(%eax)
  80272e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802731:	8b 40 04             	mov    0x4(%eax),%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	74 0c                	je     802744 <alloc_block_FF+0x196>
  802738:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80273d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802740:	89 10                	mov    %edx,(%eax)
  802742:	eb 08                	jmp    80274c <alloc_block_FF+0x19e>
  802744:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802747:	a3 38 41 80 00       	mov    %eax,0x804138
  80274c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802754:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802757:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275d:	a1 44 41 80 00       	mov    0x804144,%eax
  802762:	40                   	inc    %eax
  802763:	a3 44 41 80 00       	mov    %eax,0x804144
		  // setting the size & sva
		  new_block->size=size;
  802768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276b:	8b 55 08             	mov    0x8(%ebp),%edx
  80276e:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 50 08             	mov    0x8(%eax),%edx
  802777:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277a:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802783:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 50 08             	mov    0x8(%eax),%edx
  80278c:	8b 45 08             	mov    0x8(%ebp),%eax
  80278f:	01 c2                	add    %eax,%edx
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  80279d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027a1:	75 17                	jne    8027ba <alloc_block_FF+0x20c>
  8027a3:	83 ec 04             	sub    $0x4,%esp
  8027a6:	68 08 3f 80 00       	push   $0x803f08
  8027ab:	68 a2 00 00 00       	push   $0xa2
  8027b0:	68 97 3e 80 00       	push   $0x803e97
  8027b5:	e8 ed dc ff ff       	call   8004a7 <_panic>
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	74 10                	je     8027d3 <alloc_block_FF+0x225>
  8027c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027cb:	8b 52 04             	mov    0x4(%edx),%edx
  8027ce:	89 50 04             	mov    %edx,0x4(%eax)
  8027d1:	eb 0b                	jmp    8027de <alloc_block_FF+0x230>
  8027d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d6:	8b 40 04             	mov    0x4(%eax),%eax
  8027d9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e1:	8b 40 04             	mov    0x4(%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 0f                	je     8027f7 <alloc_block_FF+0x249>
  8027e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027eb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027f1:	8b 12                	mov    (%edx),%edx
  8027f3:	89 10                	mov    %edx,(%eax)
  8027f5:	eb 0a                	jmp    802801 <alloc_block_FF+0x253>
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	8b 00                	mov    (%eax),%eax
  8027fc:	a3 38 41 80 00       	mov    %eax,0x804138
  802801:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802804:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802814:	a1 44 41 80 00       	mov    0x804144,%eax
  802819:	48                   	dec    %eax
  80281a:	a3 44 41 80 00       	mov    %eax,0x804144
		  return temp;
  80281f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802822:	eb 3b                	jmp    80285f <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802824:	a1 40 41 80 00       	mov    0x804140,%eax
  802829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802830:	74 07                	je     802839 <alloc_block_FF+0x28b>
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 00                	mov    (%eax),%eax
  802837:	eb 05                	jmp    80283e <alloc_block_FF+0x290>
  802839:	b8 00 00 00 00       	mov    $0x0,%eax
  80283e:	a3 40 41 80 00       	mov    %eax,0x804140
  802843:	a1 40 41 80 00       	mov    0x804140,%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	0f 85 71 fd ff ff    	jne    8025c1 <alloc_block_FF+0x13>
  802850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802854:	0f 85 67 fd ff ff    	jne    8025c1 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  80285a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285f:	c9                   	leave  
  802860:	c3                   	ret    

00802861 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802861:	55                   	push   %ebp
  802862:	89 e5                	mov    %esp,%ebp
  802864:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802867:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  80286e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802875:	a1 38 41 80 00       	mov    0x804138,%eax
  80287a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80287d:	e9 d3 00 00 00       	jmp    802955 <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802882:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802885:	8b 40 0c             	mov    0xc(%eax),%eax
  802888:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288b:	0f 85 90 00 00 00    	jne    802921 <alloc_block_BF+0xc0>
	   temp = element;
  802891:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802894:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802897:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80289b:	75 17                	jne    8028b4 <alloc_block_BF+0x53>
  80289d:	83 ec 04             	sub    $0x4,%esp
  8028a0:	68 08 3f 80 00       	push   $0x803f08
  8028a5:	68 bd 00 00 00       	push   $0xbd
  8028aa:	68 97 3e 80 00       	push   $0x803e97
  8028af:	e8 f3 db ff ff       	call   8004a7 <_panic>
  8028b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	74 10                	je     8028cd <alloc_block_BF+0x6c>
  8028bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c0:	8b 00                	mov    (%eax),%eax
  8028c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028c5:	8b 52 04             	mov    0x4(%edx),%edx
  8028c8:	89 50 04             	mov    %edx,0x4(%eax)
  8028cb:	eb 0b                	jmp    8028d8 <alloc_block_BF+0x77>
  8028cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d0:	8b 40 04             	mov    0x4(%eax),%eax
  8028d3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028db:	8b 40 04             	mov    0x4(%eax),%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	74 0f                	je     8028f1 <alloc_block_BF+0x90>
  8028e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e5:	8b 40 04             	mov    0x4(%eax),%eax
  8028e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028eb:	8b 12                	mov    (%edx),%edx
  8028ed:	89 10                	mov    %edx,(%eax)
  8028ef:	eb 0a                	jmp    8028fb <alloc_block_BF+0x9a>
  8028f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	a3 38 41 80 00       	mov    %eax,0x804138
  8028fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802907:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80290e:	a1 44 41 80 00       	mov    0x804144,%eax
  802913:	48                   	dec    %eax
  802914:	a3 44 41 80 00       	mov    %eax,0x804144
	   return temp;
  802919:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80291c:	e9 41 01 00 00       	jmp    802a62 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802921:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802924:	8b 40 0c             	mov    0xc(%eax),%eax
  802927:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292a:	76 21                	jbe    80294d <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  80292c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292f:	8b 40 0c             	mov    0xc(%eax),%eax
  802932:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802935:	73 16                	jae    80294d <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802937:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293a:	8b 40 0c             	mov    0xc(%eax),%eax
  80293d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802940:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802943:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802946:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  80294d:	a1 40 41 80 00       	mov    0x804140,%eax
  802952:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802955:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802959:	74 07                	je     802962 <alloc_block_BF+0x101>
  80295b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	eb 05                	jmp    802967 <alloc_block_BF+0x106>
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
  802967:	a3 40 41 80 00       	mov    %eax,0x804140
  80296c:	a1 40 41 80 00       	mov    0x804140,%eax
  802971:	85 c0                	test   %eax,%eax
  802973:	0f 85 09 ff ff ff    	jne    802882 <alloc_block_BF+0x21>
  802979:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80297d:	0f 85 ff fe ff ff    	jne    802882 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802983:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802987:	0f 85 d0 00 00 00    	jne    802a5d <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  80298d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802990:	8b 40 0c             	mov    0xc(%eax),%eax
  802993:	2b 45 08             	sub    0x8(%ebp),%eax
  802996:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802999:	a1 48 41 80 00       	mov    0x804148,%eax
  80299e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  8029a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8029a5:	75 17                	jne    8029be <alloc_block_BF+0x15d>
  8029a7:	83 ec 04             	sub    $0x4,%esp
  8029aa:	68 08 3f 80 00       	push   $0x803f08
  8029af:	68 d1 00 00 00       	push   $0xd1
  8029b4:	68 97 3e 80 00       	push   $0x803e97
  8029b9:	e8 e9 da ff ff       	call   8004a7 <_panic>
  8029be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 10                	je     8029d7 <alloc_block_BF+0x176>
  8029c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ca:	8b 00                	mov    (%eax),%eax
  8029cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029cf:	8b 52 04             	mov    0x4(%edx),%edx
  8029d2:	89 50 04             	mov    %edx,0x4(%eax)
  8029d5:	eb 0b                	jmp    8029e2 <alloc_block_BF+0x181>
  8029d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029da:	8b 40 04             	mov    0x4(%eax),%eax
  8029dd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029e5:	8b 40 04             	mov    0x4(%eax),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	74 0f                	je     8029fb <alloc_block_BF+0x19a>
  8029ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ef:	8b 40 04             	mov    0x4(%eax),%eax
  8029f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029f5:	8b 12                	mov    (%edx),%edx
  8029f7:	89 10                	mov    %edx,(%eax)
  8029f9:	eb 0a                	jmp    802a05 <alloc_block_BF+0x1a4>
  8029fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	a3 48 41 80 00       	mov    %eax,0x804148
  802a05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a18:	a1 54 41 80 00       	mov    0x804154,%eax
  802a1d:	48                   	dec    %eax
  802a1e:	a3 54 41 80 00       	mov    %eax,0x804154
	  // setting the size & sva
	  new_block->size = size;
  802a23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a26:	8b 55 08             	mov    0x8(%ebp),%edx
  802a29:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802a2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2f:	8b 50 08             	mov    0x8(%eax),%edx
  802a32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a35:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802a3e:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802a41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a44:	8b 50 08             	mov    0x8(%eax),%edx
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	01 c2                	add    %eax,%edx
  802a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4f:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802a52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a55:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802a58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a5b:	eb 05                	jmp    802a62 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802a5d:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802a62:	c9                   	leave  
  802a63:	c3                   	ret    

00802a64 <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802a64:	55                   	push   %ebp
  802a65:	89 e5                	mov    %esp,%ebp
  802a67:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802a6a:	83 ec 04             	sub    $0x4,%esp
  802a6d:	68 28 3f 80 00       	push   $0x803f28
  802a72:	68 e8 00 00 00       	push   $0xe8
  802a77:	68 97 3e 80 00       	push   $0x803e97
  802a7c:	e8 26 da ff ff       	call   8004a7 <_panic>

00802a81 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a81:	55                   	push   %ebp
  802a82:	89 e5                	mov    %esp,%ebp
  802a84:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802a87:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802a8f:	a1 38 41 80 00       	mov    0x804138,%eax
  802a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802a97:	a1 44 41 80 00       	mov    0x804144,%eax
  802a9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802a9f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aa3:	75 68                	jne    802b0d <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802aa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa9:	75 17                	jne    802ac2 <insert_sorted_with_merge_freeList+0x41>
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	68 74 3e 80 00       	push   $0x803e74
  802ab3:	68 36 01 00 00       	push   $0x136
  802ab8:	68 97 3e 80 00       	push   $0x803e97
  802abd:	e8 e5 d9 ff ff       	call   8004a7 <_panic>
  802ac2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	89 10                	mov    %edx,(%eax)
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 0d                	je     802ae3 <insert_sorted_with_merge_freeList+0x62>
  802ad6:	a1 38 41 80 00       	mov    0x804138,%eax
  802adb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ade:	89 50 04             	mov    %edx,0x4(%eax)
  802ae1:	eb 08                	jmp    802aeb <insert_sorted_with_merge_freeList+0x6a>
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	a3 38 41 80 00       	mov    %eax,0x804138
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afd:	a1 44 41 80 00       	mov    0x804144,%eax
  802b02:	40                   	inc    %eax
  802b03:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b08:	e9 ba 06 00 00       	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	8b 50 08             	mov    0x8(%eax),%edx
  802b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b16:	8b 40 0c             	mov    0xc(%eax),%eax
  802b19:	01 c2                	add    %eax,%edx
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	8b 40 08             	mov    0x8(%eax),%eax
  802b21:	39 c2                	cmp    %eax,%edx
  802b23:	73 68                	jae    802b8d <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b29:	75 17                	jne    802b42 <insert_sorted_with_merge_freeList+0xc1>
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	68 b0 3e 80 00       	push   $0x803eb0
  802b33:	68 3a 01 00 00       	push   $0x13a
  802b38:	68 97 3e 80 00       	push   $0x803e97
  802b3d:	e8 65 d9 ff ff       	call   8004a7 <_panic>
  802b42:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	89 50 04             	mov    %edx,0x4(%eax)
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	85 c0                	test   %eax,%eax
  802b56:	74 0c                	je     802b64 <insert_sorted_with_merge_freeList+0xe3>
  802b58:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b60:	89 10                	mov    %edx,(%eax)
  802b62:	eb 08                	jmp    802b6c <insert_sorted_with_merge_freeList+0xeb>
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	a3 38 41 80 00       	mov    %eax,0x804138
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b7d:	a1 44 41 80 00       	mov    0x804144,%eax
  802b82:	40                   	inc    %eax
  802b83:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802b88:	e9 3a 06 00 00       	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b90:	8b 50 08             	mov    0x8(%eax),%edx
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	8b 40 0c             	mov    0xc(%eax),%eax
  802b99:	01 c2                	add    %eax,%edx
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ba1:	39 c2                	cmp    %eax,%edx
  802ba3:	0f 85 90 00 00 00    	jne    802c39 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	8b 50 0c             	mov    0xc(%eax),%edx
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb5:	01 c2                	add    %eax,%edx
  802bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bba:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd5:	75 17                	jne    802bee <insert_sorted_with_merge_freeList+0x16d>
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	68 74 3e 80 00       	push   $0x803e74
  802bdf:	68 41 01 00 00       	push   $0x141
  802be4:	68 97 3e 80 00       	push   $0x803e97
  802be9:	e8 b9 d8 ff ff       	call   8004a7 <_panic>
  802bee:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	89 10                	mov    %edx,(%eax)
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	8b 00                	mov    (%eax),%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	74 0d                	je     802c0f <insert_sorted_with_merge_freeList+0x18e>
  802c02:	a1 48 41 80 00       	mov    0x804148,%eax
  802c07:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0a:	89 50 04             	mov    %edx,0x4(%eax)
  802c0d:	eb 08                	jmp    802c17 <insert_sorted_with_merge_freeList+0x196>
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	a3 48 41 80 00       	mov    %eax,0x804148
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c29:	a1 54 41 80 00       	mov    0x804154,%eax
  802c2e:	40                   	inc    %eax
  802c2f:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802c34:	e9 8e 05 00 00       	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	8b 50 08             	mov    0x8(%eax),%edx
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	8b 40 0c             	mov    0xc(%eax),%eax
  802c45:	01 c2                	add    %eax,%edx
  802c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	39 c2                	cmp    %eax,%edx
  802c4f:	73 68                	jae    802cb9 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c55:	75 17                	jne    802c6e <insert_sorted_with_merge_freeList+0x1ed>
  802c57:	83 ec 04             	sub    $0x4,%esp
  802c5a:	68 74 3e 80 00       	push   $0x803e74
  802c5f:	68 45 01 00 00       	push   $0x145
  802c64:	68 97 3e 80 00       	push   $0x803e97
  802c69:	e8 39 d8 ff ff       	call   8004a7 <_panic>
  802c6e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	89 10                	mov    %edx,(%eax)
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	8b 00                	mov    (%eax),%eax
  802c7e:	85 c0                	test   %eax,%eax
  802c80:	74 0d                	je     802c8f <insert_sorted_with_merge_freeList+0x20e>
  802c82:	a1 38 41 80 00       	mov    0x804138,%eax
  802c87:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8a:	89 50 04             	mov    %edx,0x4(%eax)
  802c8d:	eb 08                	jmp    802c97 <insert_sorted_with_merge_freeList+0x216>
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	a3 38 41 80 00       	mov    %eax,0x804138
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca9:	a1 44 41 80 00       	mov    0x804144,%eax
  802cae:	40                   	inc    %eax
  802caf:	a3 44 41 80 00       	mov    %eax,0x804144





}
  802cb4:	e9 0e 05 00 00       	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	8b 50 08             	mov    0x8(%eax),%edx
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc5:	01 c2                	add    %eax,%edx
  802cc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cca:	8b 40 08             	mov    0x8(%eax),%eax
  802ccd:	39 c2                	cmp    %eax,%edx
  802ccf:	0f 85 9c 00 00 00    	jne    802d71 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd8:	8b 50 0c             	mov    0xc(%eax),%edx
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce1:	01 c2                	add    %eax,%edx
  802ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce6:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 50 08             	mov    0x8(%eax),%edx
  802cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf2:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0d:	75 17                	jne    802d26 <insert_sorted_with_merge_freeList+0x2a5>
  802d0f:	83 ec 04             	sub    $0x4,%esp
  802d12:	68 74 3e 80 00       	push   $0x803e74
  802d17:	68 4d 01 00 00       	push   $0x14d
  802d1c:	68 97 3e 80 00       	push   $0x803e97
  802d21:	e8 81 d7 ff ff       	call   8004a7 <_panic>
  802d26:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	89 10                	mov    %edx,(%eax)
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	85 c0                	test   %eax,%eax
  802d38:	74 0d                	je     802d47 <insert_sorted_with_merge_freeList+0x2c6>
  802d3a:	a1 48 41 80 00       	mov    0x804148,%eax
  802d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d42:	89 50 04             	mov    %edx,0x4(%eax)
  802d45:	eb 08                	jmp    802d4f <insert_sorted_with_merge_freeList+0x2ce>
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	a3 48 41 80 00       	mov    %eax,0x804148
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d61:	a1 54 41 80 00       	mov    0x804154,%eax
  802d66:	40                   	inc    %eax
  802d67:	a3 54 41 80 00       	mov    %eax,0x804154





}
  802d6c:	e9 56 04 00 00       	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802d71:	a1 38 41 80 00       	mov    0x804138,%eax
  802d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d79:	e9 19 04 00 00       	jmp    803197 <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 00                	mov    (%eax),%eax
  802d83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 50 08             	mov    0x8(%eax),%edx
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d92:	01 c2                	add    %eax,%edx
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 40 08             	mov    0x8(%eax),%eax
  802d9a:	39 c2                	cmp    %eax,%edx
  802d9c:	0f 85 ad 01 00 00    	jne    802f4f <insert_sorted_with_merge_freeList+0x4ce>
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	8b 40 0c             	mov    0xc(%eax),%eax
  802dae:	01 c2                	add    %eax,%edx
  802db0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db3:	8b 40 08             	mov    0x8(%eax),%eax
  802db6:	39 c2                	cmp    %eax,%edx
  802db8:	0f 85 91 01 00 00    	jne    802f4f <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	8b 48 0c             	mov    0xc(%eax),%ecx
  802dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd0:	01 c8                	add    %ecx,%eax
  802dd2:	01 c2                	add    %eax,%edx
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  802dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802df1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  802df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dfb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  802e02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e06:	75 17                	jne    802e1f <insert_sorted_with_merge_freeList+0x39e>
  802e08:	83 ec 04             	sub    $0x4,%esp
  802e0b:	68 08 3f 80 00       	push   $0x803f08
  802e10:	68 5b 01 00 00       	push   $0x15b
  802e15:	68 97 3e 80 00       	push   $0x803e97
  802e1a:	e8 88 d6 ff ff       	call   8004a7 <_panic>
  802e1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	74 10                	je     802e38 <insert_sorted_with_merge_freeList+0x3b7>
  802e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e30:	8b 52 04             	mov    0x4(%edx),%edx
  802e33:	89 50 04             	mov    %edx,0x4(%eax)
  802e36:	eb 0b                	jmp    802e43 <insert_sorted_with_merge_freeList+0x3c2>
  802e38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3b:	8b 40 04             	mov    0x4(%eax),%eax
  802e3e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	74 0f                	je     802e5c <insert_sorted_with_merge_freeList+0x3db>
  802e4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e56:	8b 12                	mov    (%edx),%edx
  802e58:	89 10                	mov    %edx,(%eax)
  802e5a:	eb 0a                	jmp    802e66 <insert_sorted_with_merge_freeList+0x3e5>
  802e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	a3 38 41 80 00       	mov    %eax,0x804138
  802e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e79:	a1 44 41 80 00       	mov    0x804144,%eax
  802e7e:	48                   	dec    %eax
  802e7f:	a3 44 41 80 00       	mov    %eax,0x804144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e88:	75 17                	jne    802ea1 <insert_sorted_with_merge_freeList+0x420>
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	68 74 3e 80 00       	push   $0x803e74
  802e92:	68 5c 01 00 00       	push   $0x15c
  802e97:	68 97 3e 80 00       	push   $0x803e97
  802e9c:	e8 06 d6 ff ff       	call   8004a7 <_panic>
  802ea1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	89 10                	mov    %edx,(%eax)
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 0d                	je     802ec2 <insert_sorted_with_merge_freeList+0x441>
  802eb5:	a1 48 41 80 00       	mov    0x804148,%eax
  802eba:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebd:	89 50 04             	mov    %edx,0x4(%eax)
  802ec0:	eb 08                	jmp    802eca <insert_sorted_with_merge_freeList+0x449>
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	a3 48 41 80 00       	mov    %eax,0x804148
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edc:	a1 54 41 80 00       	mov    0x804154,%eax
  802ee1:	40                   	inc    %eax
  802ee2:	a3 54 41 80 00       	mov    %eax,0x804154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  802ee7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802eeb:	75 17                	jne    802f04 <insert_sorted_with_merge_freeList+0x483>
  802eed:	83 ec 04             	sub    $0x4,%esp
  802ef0:	68 74 3e 80 00       	push   $0x803e74
  802ef5:	68 5d 01 00 00       	push   $0x15d
  802efa:	68 97 3e 80 00       	push   $0x803e97
  802eff:	e8 a3 d5 ff ff       	call   8004a7 <_panic>
  802f04:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0d                	je     802f25 <insert_sorted_with_merge_freeList+0x4a4>
  802f18:	a1 48 41 80 00       	mov    0x804148,%eax
  802f1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f20:	89 50 04             	mov    %edx,0x4(%eax)
  802f23:	eb 08                	jmp    802f2d <insert_sorted_with_merge_freeList+0x4ac>
  802f25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f28:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f30:	a3 48 41 80 00       	mov    %eax,0x804148
  802f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3f:	a1 54 41 80 00       	mov    0x804154,%eax
  802f44:	40                   	inc    %eax
  802f45:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  802f4a:	e9 78 02 00 00       	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 50 08             	mov    0x8(%eax),%edx
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5b:	01 c2                	add    %eax,%edx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 40 08             	mov    0x8(%eax),%eax
  802f63:	39 c2                	cmp    %eax,%edx
  802f65:	0f 83 b8 00 00 00    	jae    803023 <insert_sorted_with_merge_freeList+0x5a2>
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	01 c2                	add    %eax,%edx
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 40 08             	mov    0x8(%eax),%eax
  802f7f:	39 c2                	cmp    %eax,%edx
  802f81:	0f 85 9c 00 00 00    	jne    803023 <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  802f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 40 0c             	mov    0xc(%eax),%eax
  802f93:	01 c2                	add    %eax,%edx
  802f95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f98:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 50 08             	mov    0x8(%eax),%edx
  802fa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa4:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fbf:	75 17                	jne    802fd8 <insert_sorted_with_merge_freeList+0x557>
  802fc1:	83 ec 04             	sub    $0x4,%esp
  802fc4:	68 74 3e 80 00       	push   $0x803e74
  802fc9:	68 67 01 00 00       	push   $0x167
  802fce:	68 97 3e 80 00       	push   $0x803e97
  802fd3:	e8 cf d4 ff ff       	call   8004a7 <_panic>
  802fd8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	89 10                	mov    %edx,(%eax)
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	85 c0                	test   %eax,%eax
  802fea:	74 0d                	je     802ff9 <insert_sorted_with_merge_freeList+0x578>
  802fec:	a1 48 41 80 00       	mov    0x804148,%eax
  802ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff4:	89 50 04             	mov    %edx,0x4(%eax)
  802ff7:	eb 08                	jmp    803001 <insert_sorted_with_merge_freeList+0x580>
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	a3 48 41 80 00       	mov    %eax,0x804148
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803013:	a1 54 41 80 00       	mov    0x804154,%eax
  803018:	40                   	inc    %eax
  803019:	a3 54 41 80 00       	mov    %eax,0x804154
	        break;
  80301e:	e9 a4 01 00 00       	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 50 08             	mov    0x8(%eax),%edx
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	8b 40 0c             	mov    0xc(%eax),%eax
  80302f:	01 c2                	add    %eax,%edx
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	8b 40 08             	mov    0x8(%eax),%eax
  803037:	39 c2                	cmp    %eax,%edx
  803039:	0f 85 ac 00 00 00    	jne    8030eb <insert_sorted_with_merge_freeList+0x66a>
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	8b 50 08             	mov    0x8(%eax),%edx
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	8b 40 0c             	mov    0xc(%eax),%eax
  80304b:	01 c2                	add    %eax,%edx
  80304d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803050:	8b 40 08             	mov    0x8(%eax),%eax
  803053:	39 c2                	cmp    %eax,%edx
  803055:	0f 83 90 00 00 00    	jae    8030eb <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 50 0c             	mov    0xc(%eax),%edx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	8b 40 0c             	mov    0xc(%eax),%eax
  803067:	01 c2                	add    %eax,%edx
  803069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306c:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803087:	75 17                	jne    8030a0 <insert_sorted_with_merge_freeList+0x61f>
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	68 74 3e 80 00       	push   $0x803e74
  803091:	68 70 01 00 00       	push   $0x170
  803096:	68 97 3e 80 00       	push   $0x803e97
  80309b:	e8 07 d4 ff ff       	call   8004a7 <_panic>
  8030a0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	89 10                	mov    %edx,(%eax)
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 00                	mov    (%eax),%eax
  8030b0:	85 c0                	test   %eax,%eax
  8030b2:	74 0d                	je     8030c1 <insert_sorted_with_merge_freeList+0x640>
  8030b4:	a1 48 41 80 00       	mov    0x804148,%eax
  8030b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bc:	89 50 04             	mov    %edx,0x4(%eax)
  8030bf:	eb 08                	jmp    8030c9 <insert_sorted_with_merge_freeList+0x648>
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030db:	a1 54 41 80 00       	mov    0x804154,%eax
  8030e0:	40                   	inc    %eax
  8030e1:	a3 54 41 80 00       	mov    %eax,0x804154
	      break;
  8030e6:	e9 dc 00 00 00       	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 50 08             	mov    0x8(%eax),%edx
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f7:	01 c2                	add    %eax,%edx
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	8b 40 08             	mov    0x8(%eax),%eax
  8030ff:	39 c2                	cmp    %eax,%edx
  803101:	0f 83 88 00 00 00    	jae    80318f <insert_sorted_with_merge_freeList+0x70e>
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	8b 50 08             	mov    0x8(%eax),%edx
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	8b 40 0c             	mov    0xc(%eax),%eax
  803113:	01 c2                	add    %eax,%edx
  803115:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803118:	8b 40 08             	mov    0x8(%eax),%eax
  80311b:	39 c2                	cmp    %eax,%edx
  80311d:	73 70                	jae    80318f <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  80311f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803123:	74 06                	je     80312b <insert_sorted_with_merge_freeList+0x6aa>
  803125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803129:	75 17                	jne    803142 <insert_sorted_with_merge_freeList+0x6c1>
  80312b:	83 ec 04             	sub    $0x4,%esp
  80312e:	68 d4 3e 80 00       	push   $0x803ed4
  803133:	68 75 01 00 00       	push   $0x175
  803138:	68 97 3e 80 00       	push   $0x803e97
  80313d:	e8 65 d3 ff ff       	call   8004a7 <_panic>
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 10                	mov    (%eax),%edx
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	89 10                	mov    %edx,(%eax)
  80314c:	8b 45 08             	mov    0x8(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	74 0b                	je     803160 <insert_sorted_with_merge_freeList+0x6df>
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	8b 55 08             	mov    0x8(%ebp),%edx
  80315d:	89 50 04             	mov    %edx,0x4(%eax)
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 55 08             	mov    0x8(%ebp),%edx
  803166:	89 10                	mov    %edx,(%eax)
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80316e:	89 50 04             	mov    %edx,0x4(%eax)
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	8b 00                	mov    (%eax),%eax
  803176:	85 c0                	test   %eax,%eax
  803178:	75 08                	jne    803182 <insert_sorted_with_merge_freeList+0x701>
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803182:	a1 44 41 80 00       	mov    0x804144,%eax
  803187:	40                   	inc    %eax
  803188:	a3 44 41 80 00       	mov    %eax,0x804144
	      break;
  80318d:	eb 38                	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  80318f:	a1 40 41 80 00       	mov    0x804140,%eax
  803194:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803197:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80319b:	74 07                	je     8031a4 <insert_sorted_with_merge_freeList+0x723>
  80319d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a0:	8b 00                	mov    (%eax),%eax
  8031a2:	eb 05                	jmp    8031a9 <insert_sorted_with_merge_freeList+0x728>
  8031a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a9:	a3 40 41 80 00       	mov    %eax,0x804140
  8031ae:	a1 40 41 80 00       	mov    0x804140,%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	0f 85 c3 fb ff ff    	jne    802d7e <insert_sorted_with_merge_freeList+0x2fd>
  8031bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bf:	0f 85 b9 fb ff ff    	jne    802d7e <insert_sorted_with_merge_freeList+0x2fd>





}
  8031c5:	eb 00                	jmp    8031c7 <insert_sorted_with_merge_freeList+0x746>
  8031c7:	90                   	nop
  8031c8:	c9                   	leave  
  8031c9:	c3                   	ret    

008031ca <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8031ca:	55                   	push   %ebp
  8031cb:	89 e5                	mov    %esp,%ebp
  8031cd:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8031d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d3:	89 d0                	mov    %edx,%eax
  8031d5:	c1 e0 02             	shl    $0x2,%eax
  8031d8:	01 d0                	add    %edx,%eax
  8031da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031e1:	01 d0                	add    %edx,%eax
  8031e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031ea:	01 d0                	add    %edx,%eax
  8031ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031f3:	01 d0                	add    %edx,%eax
  8031f5:	c1 e0 04             	shl    $0x4,%eax
  8031f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8031fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803202:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803205:	83 ec 0c             	sub    $0xc,%esp
  803208:	50                   	push   %eax
  803209:	e8 31 ec ff ff       	call   801e3f <sys_get_virtual_time>
  80320e:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803211:	eb 41                	jmp    803254 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803213:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803216:	83 ec 0c             	sub    $0xc,%esp
  803219:	50                   	push   %eax
  80321a:	e8 20 ec ff ff       	call   801e3f <sys_get_virtual_time>
  80321f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803222:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803228:	29 c2                	sub    %eax,%edx
  80322a:	89 d0                	mov    %edx,%eax
  80322c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80322f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803235:	89 d1                	mov    %edx,%ecx
  803237:	29 c1                	sub    %eax,%ecx
  803239:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80323c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80323f:	39 c2                	cmp    %eax,%edx
  803241:	0f 97 c0             	seta   %al
  803244:	0f b6 c0             	movzbl %al,%eax
  803247:	29 c1                	sub    %eax,%ecx
  803249:	89 c8                	mov    %ecx,%eax
  80324b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80324e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803251:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803257:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80325a:	72 b7                	jb     803213 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80325c:	90                   	nop
  80325d:	c9                   	leave  
  80325e:	c3                   	ret    

0080325f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80325f:	55                   	push   %ebp
  803260:	89 e5                	mov    %esp,%ebp
  803262:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803265:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80326c:	eb 03                	jmp    803271 <busy_wait+0x12>
  80326e:	ff 45 fc             	incl   -0x4(%ebp)
  803271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803274:	3b 45 08             	cmp    0x8(%ebp),%eax
  803277:	72 f5                	jb     80326e <busy_wait+0xf>
	return i;
  803279:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80327c:	c9                   	leave  
  80327d:	c3                   	ret    
  80327e:	66 90                	xchg   %ax,%ax

00803280 <__udivdi3>:
  803280:	55                   	push   %ebp
  803281:	57                   	push   %edi
  803282:	56                   	push   %esi
  803283:	53                   	push   %ebx
  803284:	83 ec 1c             	sub    $0x1c,%esp
  803287:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80328b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80328f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803293:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803297:	89 ca                	mov    %ecx,%edx
  803299:	89 f8                	mov    %edi,%eax
  80329b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80329f:	85 f6                	test   %esi,%esi
  8032a1:	75 2d                	jne    8032d0 <__udivdi3+0x50>
  8032a3:	39 cf                	cmp    %ecx,%edi
  8032a5:	77 65                	ja     80330c <__udivdi3+0x8c>
  8032a7:	89 fd                	mov    %edi,%ebp
  8032a9:	85 ff                	test   %edi,%edi
  8032ab:	75 0b                	jne    8032b8 <__udivdi3+0x38>
  8032ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8032b2:	31 d2                	xor    %edx,%edx
  8032b4:	f7 f7                	div    %edi
  8032b6:	89 c5                	mov    %eax,%ebp
  8032b8:	31 d2                	xor    %edx,%edx
  8032ba:	89 c8                	mov    %ecx,%eax
  8032bc:	f7 f5                	div    %ebp
  8032be:	89 c1                	mov    %eax,%ecx
  8032c0:	89 d8                	mov    %ebx,%eax
  8032c2:	f7 f5                	div    %ebp
  8032c4:	89 cf                	mov    %ecx,%edi
  8032c6:	89 fa                	mov    %edi,%edx
  8032c8:	83 c4 1c             	add    $0x1c,%esp
  8032cb:	5b                   	pop    %ebx
  8032cc:	5e                   	pop    %esi
  8032cd:	5f                   	pop    %edi
  8032ce:	5d                   	pop    %ebp
  8032cf:	c3                   	ret    
  8032d0:	39 ce                	cmp    %ecx,%esi
  8032d2:	77 28                	ja     8032fc <__udivdi3+0x7c>
  8032d4:	0f bd fe             	bsr    %esi,%edi
  8032d7:	83 f7 1f             	xor    $0x1f,%edi
  8032da:	75 40                	jne    80331c <__udivdi3+0x9c>
  8032dc:	39 ce                	cmp    %ecx,%esi
  8032de:	72 0a                	jb     8032ea <__udivdi3+0x6a>
  8032e0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032e4:	0f 87 9e 00 00 00    	ja     803388 <__udivdi3+0x108>
  8032ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ef:	89 fa                	mov    %edi,%edx
  8032f1:	83 c4 1c             	add    $0x1c,%esp
  8032f4:	5b                   	pop    %ebx
  8032f5:	5e                   	pop    %esi
  8032f6:	5f                   	pop    %edi
  8032f7:	5d                   	pop    %ebp
  8032f8:	c3                   	ret    
  8032f9:	8d 76 00             	lea    0x0(%esi),%esi
  8032fc:	31 ff                	xor    %edi,%edi
  8032fe:	31 c0                	xor    %eax,%eax
  803300:	89 fa                	mov    %edi,%edx
  803302:	83 c4 1c             	add    $0x1c,%esp
  803305:	5b                   	pop    %ebx
  803306:	5e                   	pop    %esi
  803307:	5f                   	pop    %edi
  803308:	5d                   	pop    %ebp
  803309:	c3                   	ret    
  80330a:	66 90                	xchg   %ax,%ax
  80330c:	89 d8                	mov    %ebx,%eax
  80330e:	f7 f7                	div    %edi
  803310:	31 ff                	xor    %edi,%edi
  803312:	89 fa                	mov    %edi,%edx
  803314:	83 c4 1c             	add    $0x1c,%esp
  803317:	5b                   	pop    %ebx
  803318:	5e                   	pop    %esi
  803319:	5f                   	pop    %edi
  80331a:	5d                   	pop    %ebp
  80331b:	c3                   	ret    
  80331c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803321:	89 eb                	mov    %ebp,%ebx
  803323:	29 fb                	sub    %edi,%ebx
  803325:	89 f9                	mov    %edi,%ecx
  803327:	d3 e6                	shl    %cl,%esi
  803329:	89 c5                	mov    %eax,%ebp
  80332b:	88 d9                	mov    %bl,%cl
  80332d:	d3 ed                	shr    %cl,%ebp
  80332f:	89 e9                	mov    %ebp,%ecx
  803331:	09 f1                	or     %esi,%ecx
  803333:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803337:	89 f9                	mov    %edi,%ecx
  803339:	d3 e0                	shl    %cl,%eax
  80333b:	89 c5                	mov    %eax,%ebp
  80333d:	89 d6                	mov    %edx,%esi
  80333f:	88 d9                	mov    %bl,%cl
  803341:	d3 ee                	shr    %cl,%esi
  803343:	89 f9                	mov    %edi,%ecx
  803345:	d3 e2                	shl    %cl,%edx
  803347:	8b 44 24 08          	mov    0x8(%esp),%eax
  80334b:	88 d9                	mov    %bl,%cl
  80334d:	d3 e8                	shr    %cl,%eax
  80334f:	09 c2                	or     %eax,%edx
  803351:	89 d0                	mov    %edx,%eax
  803353:	89 f2                	mov    %esi,%edx
  803355:	f7 74 24 0c          	divl   0xc(%esp)
  803359:	89 d6                	mov    %edx,%esi
  80335b:	89 c3                	mov    %eax,%ebx
  80335d:	f7 e5                	mul    %ebp
  80335f:	39 d6                	cmp    %edx,%esi
  803361:	72 19                	jb     80337c <__udivdi3+0xfc>
  803363:	74 0b                	je     803370 <__udivdi3+0xf0>
  803365:	89 d8                	mov    %ebx,%eax
  803367:	31 ff                	xor    %edi,%edi
  803369:	e9 58 ff ff ff       	jmp    8032c6 <__udivdi3+0x46>
  80336e:	66 90                	xchg   %ax,%ax
  803370:	8b 54 24 08          	mov    0x8(%esp),%edx
  803374:	89 f9                	mov    %edi,%ecx
  803376:	d3 e2                	shl    %cl,%edx
  803378:	39 c2                	cmp    %eax,%edx
  80337a:	73 e9                	jae    803365 <__udivdi3+0xe5>
  80337c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80337f:	31 ff                	xor    %edi,%edi
  803381:	e9 40 ff ff ff       	jmp    8032c6 <__udivdi3+0x46>
  803386:	66 90                	xchg   %ax,%ax
  803388:	31 c0                	xor    %eax,%eax
  80338a:	e9 37 ff ff ff       	jmp    8032c6 <__udivdi3+0x46>
  80338f:	90                   	nop

00803390 <__umoddi3>:
  803390:	55                   	push   %ebp
  803391:	57                   	push   %edi
  803392:	56                   	push   %esi
  803393:	53                   	push   %ebx
  803394:	83 ec 1c             	sub    $0x1c,%esp
  803397:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80339b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80339f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033a3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033af:	89 f3                	mov    %esi,%ebx
  8033b1:	89 fa                	mov    %edi,%edx
  8033b3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033b7:	89 34 24             	mov    %esi,(%esp)
  8033ba:	85 c0                	test   %eax,%eax
  8033bc:	75 1a                	jne    8033d8 <__umoddi3+0x48>
  8033be:	39 f7                	cmp    %esi,%edi
  8033c0:	0f 86 a2 00 00 00    	jbe    803468 <__umoddi3+0xd8>
  8033c6:	89 c8                	mov    %ecx,%eax
  8033c8:	89 f2                	mov    %esi,%edx
  8033ca:	f7 f7                	div    %edi
  8033cc:	89 d0                	mov    %edx,%eax
  8033ce:	31 d2                	xor    %edx,%edx
  8033d0:	83 c4 1c             	add    $0x1c,%esp
  8033d3:	5b                   	pop    %ebx
  8033d4:	5e                   	pop    %esi
  8033d5:	5f                   	pop    %edi
  8033d6:	5d                   	pop    %ebp
  8033d7:	c3                   	ret    
  8033d8:	39 f0                	cmp    %esi,%eax
  8033da:	0f 87 ac 00 00 00    	ja     80348c <__umoddi3+0xfc>
  8033e0:	0f bd e8             	bsr    %eax,%ebp
  8033e3:	83 f5 1f             	xor    $0x1f,%ebp
  8033e6:	0f 84 ac 00 00 00    	je     803498 <__umoddi3+0x108>
  8033ec:	bf 20 00 00 00       	mov    $0x20,%edi
  8033f1:	29 ef                	sub    %ebp,%edi
  8033f3:	89 fe                	mov    %edi,%esi
  8033f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033f9:	89 e9                	mov    %ebp,%ecx
  8033fb:	d3 e0                	shl    %cl,%eax
  8033fd:	89 d7                	mov    %edx,%edi
  8033ff:	89 f1                	mov    %esi,%ecx
  803401:	d3 ef                	shr    %cl,%edi
  803403:	09 c7                	or     %eax,%edi
  803405:	89 e9                	mov    %ebp,%ecx
  803407:	d3 e2                	shl    %cl,%edx
  803409:	89 14 24             	mov    %edx,(%esp)
  80340c:	89 d8                	mov    %ebx,%eax
  80340e:	d3 e0                	shl    %cl,%eax
  803410:	89 c2                	mov    %eax,%edx
  803412:	8b 44 24 08          	mov    0x8(%esp),%eax
  803416:	d3 e0                	shl    %cl,%eax
  803418:	89 44 24 04          	mov    %eax,0x4(%esp)
  80341c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803420:	89 f1                	mov    %esi,%ecx
  803422:	d3 e8                	shr    %cl,%eax
  803424:	09 d0                	or     %edx,%eax
  803426:	d3 eb                	shr    %cl,%ebx
  803428:	89 da                	mov    %ebx,%edx
  80342a:	f7 f7                	div    %edi
  80342c:	89 d3                	mov    %edx,%ebx
  80342e:	f7 24 24             	mull   (%esp)
  803431:	89 c6                	mov    %eax,%esi
  803433:	89 d1                	mov    %edx,%ecx
  803435:	39 d3                	cmp    %edx,%ebx
  803437:	0f 82 87 00 00 00    	jb     8034c4 <__umoddi3+0x134>
  80343d:	0f 84 91 00 00 00    	je     8034d4 <__umoddi3+0x144>
  803443:	8b 54 24 04          	mov    0x4(%esp),%edx
  803447:	29 f2                	sub    %esi,%edx
  803449:	19 cb                	sbb    %ecx,%ebx
  80344b:	89 d8                	mov    %ebx,%eax
  80344d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803451:	d3 e0                	shl    %cl,%eax
  803453:	89 e9                	mov    %ebp,%ecx
  803455:	d3 ea                	shr    %cl,%edx
  803457:	09 d0                	or     %edx,%eax
  803459:	89 e9                	mov    %ebp,%ecx
  80345b:	d3 eb                	shr    %cl,%ebx
  80345d:	89 da                	mov    %ebx,%edx
  80345f:	83 c4 1c             	add    $0x1c,%esp
  803462:	5b                   	pop    %ebx
  803463:	5e                   	pop    %esi
  803464:	5f                   	pop    %edi
  803465:	5d                   	pop    %ebp
  803466:	c3                   	ret    
  803467:	90                   	nop
  803468:	89 fd                	mov    %edi,%ebp
  80346a:	85 ff                	test   %edi,%edi
  80346c:	75 0b                	jne    803479 <__umoddi3+0xe9>
  80346e:	b8 01 00 00 00       	mov    $0x1,%eax
  803473:	31 d2                	xor    %edx,%edx
  803475:	f7 f7                	div    %edi
  803477:	89 c5                	mov    %eax,%ebp
  803479:	89 f0                	mov    %esi,%eax
  80347b:	31 d2                	xor    %edx,%edx
  80347d:	f7 f5                	div    %ebp
  80347f:	89 c8                	mov    %ecx,%eax
  803481:	f7 f5                	div    %ebp
  803483:	89 d0                	mov    %edx,%eax
  803485:	e9 44 ff ff ff       	jmp    8033ce <__umoddi3+0x3e>
  80348a:	66 90                	xchg   %ax,%ax
  80348c:	89 c8                	mov    %ecx,%eax
  80348e:	89 f2                	mov    %esi,%edx
  803490:	83 c4 1c             	add    $0x1c,%esp
  803493:	5b                   	pop    %ebx
  803494:	5e                   	pop    %esi
  803495:	5f                   	pop    %edi
  803496:	5d                   	pop    %ebp
  803497:	c3                   	ret    
  803498:	3b 04 24             	cmp    (%esp),%eax
  80349b:	72 06                	jb     8034a3 <__umoddi3+0x113>
  80349d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034a1:	77 0f                	ja     8034b2 <__umoddi3+0x122>
  8034a3:	89 f2                	mov    %esi,%edx
  8034a5:	29 f9                	sub    %edi,%ecx
  8034a7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034ab:	89 14 24             	mov    %edx,(%esp)
  8034ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034b2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034b6:	8b 14 24             	mov    (%esp),%edx
  8034b9:	83 c4 1c             	add    $0x1c,%esp
  8034bc:	5b                   	pop    %ebx
  8034bd:	5e                   	pop    %esi
  8034be:	5f                   	pop    %edi
  8034bf:	5d                   	pop    %ebp
  8034c0:	c3                   	ret    
  8034c1:	8d 76 00             	lea    0x0(%esi),%esi
  8034c4:	2b 04 24             	sub    (%esp),%eax
  8034c7:	19 fa                	sbb    %edi,%edx
  8034c9:	89 d1                	mov    %edx,%ecx
  8034cb:	89 c6                	mov    %eax,%esi
  8034cd:	e9 71 ff ff ff       	jmp    803443 <__umoddi3+0xb3>
  8034d2:	66 90                	xchg   %ax,%ax
  8034d4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034d8:	72 ea                	jb     8034c4 <__umoddi3+0x134>
  8034da:	89 d9                	mov    %ebx,%ecx
  8034dc:	e9 62 ff ff ff       	jmp    803443 <__umoddi3+0xb3>
