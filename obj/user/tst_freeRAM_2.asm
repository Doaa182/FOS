
obj/user/tst_freeRAM_2:     file format elf32-i386


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
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp





	int Mega = 1024*1024;
  800043:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  80004a:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	char minByte = 1<<7;
  800051:	c6 45 ef 80          	movb   $0x80,-0x11(%ebp)
	char maxByte = 0x7F;
  800055:	c6 45 ee 7f          	movb   $0x7f,-0x12(%ebp)
	short minShort = 1<<15 ;
  800059:	66 c7 45 ec 00 80    	movw   $0x8000,-0x14(%ebp)
	short maxShort = 0x7FFF;
  80005f:	66 c7 45 ea ff 7f    	movw   $0x7fff,-0x16(%ebp)
	int minInt = 1<<31 ;
  800065:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006c:	c7 45 e0 ff ff ff 7f 	movl   $0x7fffffff,-0x20(%ebp)

	void* ptr_allocations[20] = {0};
  800073:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
  800079:	b9 14 00 00 00       	mov    $0x14,%ecx
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	89 d7                	mov    %edx,%edi
  800085:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Load "fib" & "fos_helloWorld" programs into RAM
		cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	68 60 37 80 00       	push   $0x803760
  80008f:	e8 3e 09 00 00       	call   8009d2 <cprintf>
  800094:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800097:	a1 20 50 80 00       	mov    0x805020,%eax
  80009c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a7:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000ad:	89 c1                	mov    %eax,%ecx
  8000af:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b4:	8b 40 74             	mov    0x74(%eax),%eax
  8000b7:	52                   	push   %edx
  8000b8:	51                   	push   %ecx
  8000b9:	50                   	push   %eax
  8000ba:	68 92 37 80 00       	push   $0x803792
  8000bf:	e8 38 1f 00 00       	call   801ffc <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 bb 1c 00 00       	call   801d8a <sys_calculate_free_frames>
  8000cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ef:	8b 40 74             	mov    0x74(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 96 37 80 00       	push   $0x803796
  8000fa:	e8 fd 1e 00 00       	call   801ffc <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 7d 1c 00 00       	call   801d8a <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 20 33 00 00       	call   803441 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 a5 37 80 00       	push   $0x8037a5
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 b0 37 80 00       	push   $0x8037b0
  80013c:	e8 91 08 00 00       	call   8009d2 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800144:	a1 20 50 80 00       	mov    0x805020,%eax
  800149:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80014f:	a1 20 50 80 00       	mov    0x805020,%eax
  800154:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	a1 20 50 80 00       	mov    0x805020,%eax
  800161:	8b 40 74             	mov    0x74(%eax),%eax
  800164:	52                   	push   %edx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	68 d4 37 80 00       	push   $0x8037d4
  80016c:	e8 8b 1e 00 00       	call   801ffc <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 bd 32 00 00       	call   803441 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 a5 37 80 00       	push   $0x8037a5
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 dc 37 80 00       	push   $0x8037dc
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 68 1e 00 00       	call   80201a <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 f9 37 80 00       	push   $0x8037f9
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 6f 32 00 00       	call   803441 <env_sleep>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 65 17 00 00       	call   80194b <malloc>
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8001ef:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800200:	48                   	dec    %eax
  800201:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		byteArr[0] = minByte ;
  800204:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800207:	8a 55 ef             	mov    -0x11(%ebp),%dl
  80020a:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80020c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 c2                	add    %eax,%edx
  800214:	8a 45 ee             	mov    -0x12(%ebp),%al
  800217:	88 02                	mov    %al,(%edx)

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80021c:	01 c0                	add    %eax,%eax
  80021e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 21 17 00 00       	call   80194b <malloc>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800233:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800239:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80023c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023f:	01 c0                	add    %eax,%eax
  800241:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800244:	d1 e8                	shr    %eax
  800246:	48                   	dec    %eax
  800247:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr[0] = minShort;
  80024a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800253:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800256:	01 c0                	add    %eax,%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80025d:	01 c2                	add    %eax,%edx
  80025f:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800263:	66 89 02             	mov    %ax,(%edx)

		//Allocate all remaining RAM (Here: it requires to free some RAM by removing exited program (fos_add))
		freeFrames = sys_calculate_free_frames() ;
  800266:	e8 1f 1b 00 00       	call   801d8a <sys_calculate_free_frames>
  80026b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80026e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 ce 16 00 00       	call   80194b <malloc>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800286:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80028c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80028f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800292:	c1 e0 0c             	shl    $0xc,%eax
  800295:	c1 e8 02             	shr    $0x2,%eax
  800298:	48                   	dec    %eax
  800299:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		intArr[0] = minInt;
  80029c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8002a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002b1:	01 c2                	add    %eax,%edx
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  8002b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002bb:	89 d0                	mov    %edx,%eax
  8002bd:	01 c0                	add    %eax,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	01 c0                	add    %eax,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	50                   	push   %eax
  8002c9:	e8 7d 16 00 00       	call   80194b <malloc>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8002d7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8002dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8002e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e8 03             	shr    $0x3,%eax
  8002f0:	48                   	dec    %eax
  8002f1:	89 45 ac             	mov    %eax,-0x54(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8002f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f7:	8a 55 ef             	mov    -0x11(%ebp),%dl
  8002fa:	88 10                	mov    %dl,(%eax)
  8002fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800302:	66 89 42 02          	mov    %ax,0x2(%edx)
  800306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800309:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030c:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80030f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80031c:	01 c2                	add    %eax,%edx
  80031e:	8a 45 ee             	mov    -0x12(%ebp),%al
  800321:	88 02                	mov    %al,(%edx)
  800323:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800326:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80032d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800330:	01 c2                	add    %eax,%edx
  800332:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800336:	66 89 42 02          	mov    %ax,0x2(%edx)
  80033a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80033d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034c:	89 42 04             	mov    %eax,0x4(%edx)

		cprintf("running fos_helloWorld program...\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 10 38 80 00       	push   $0x803810
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 b0 1c 00 00       	call   80201a <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 f9 37 80 00       	push   $0x8037f9
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 b7 30 00 00       	call   803441 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 f8 19 00 00       	call   801d8a <sys_calculate_free_frames>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 0c             	shl    $0xc,%eax
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	50                   	push   %eax
  8003a4:	e8 a2 15 00 00       	call   80194b <malloc>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		int *intArr2 = (int *) ptr_allocations[4];
  8003b2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8003b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int lastIndexOfInt2 = ((freeFrames + helloWorldFrames)*PAGE_SIZE)/sizeof(int) - 1;
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 0c             	shl    $0xc,%eax
  8003c6:	c1 e8 02             	shr    $0x2,%eax
  8003c9:	48                   	dec    %eax
  8003ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		intArr2[0] = minInt;
  8003cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003d3:	89 10                	mov    %edx,(%eax)
		intArr2[lastIndexOfInt2] = maxInt;
  8003d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e2:	01 c2                	add    %eax,%edx
  8003e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e7:	89 02                	mov    %eax,(%edx)

		//Allocate 8 B after freeing the RAM
		ptr_allocations[5] = malloc(8);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 08                	push   $0x8
  8003ee:	e8 58 15 00 00       	call   80194b <malloc>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		int *intArr3 = (int *) ptr_allocations[5];
  8003fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800402:	89 45 a0             	mov    %eax,-0x60(%ebp)
		int lastIndexOfInt3 = 8/sizeof(int) - 1;
  800405:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
		intArr3[0] = minInt;
  80040c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80040f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800412:	89 10                	mov    %edx,(%eax)
		intArr3[lastIndexOfInt3] = maxInt;
  800414:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800421:	01 c2                	add    %eax,%edx
  800423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800426:	89 02                	mov    %eax,(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800428:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80042b:	8a 00                	mov    (%eax),%al
  80042d:	3a 45 ef             	cmp    -0x11(%ebp),%al
  800430:	75 0f                	jne    800441 <_main+0x409>
  800432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	8a 00                	mov    (%eax),%al
  80043c:	3a 45 ee             	cmp    -0x12(%ebp),%al
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 34 38 80 00       	push   $0x803834
  800449:	6a 62                	push   $0x62
  80044b:	68 69 38 80 00       	push   $0x803869
  800450:	e8 c9 02 00 00       	call   80071e <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800455:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800458:	66 8b 00             	mov    (%eax),%ax
  80045b:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  80045f:	75 15                	jne    800476 <_main+0x43e>
  800461:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	66 8b 00             	mov    (%eax),%ax
  800470:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  800474:	74 14                	je     80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 34 38 80 00       	push   $0x803834
  80047e:	6a 63                	push   $0x63
  800480:	68 69 38 80 00       	push   $0x803869
  800485:	e8 94 02 00 00       	call   80071e <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80048a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800492:	75 16                	jne    8004aa <_main+0x472>
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 34 38 80 00       	push   $0x803834
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 69 38 80 00       	push   $0x803869
  8004b9:	e8 60 02 00 00       	call   80071e <_panic>
		if (intArr2[0] 	!= minInt 	|| intArr2[lastIndexOfInt2] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c6:	75 16                	jne    8004de <_main+0x4a6>
  8004c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <_main+0x4ba>
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 34 38 80 00       	push   $0x803834
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 69 38 80 00       	push   $0x803869
  8004ed:	e8 2c 02 00 00       	call   80071e <_panic>
		if (intArr3[0] 	!= minInt 	|| intArr3[lastIndexOfInt3] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	75 16                	jne    800512 <_main+0x4da>
  8004fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 34 38 80 00       	push   $0x803834
  80051a:	6a 66                	push   $0x66
  80051c:	68 69 38 80 00       	push   $0x803869
  800521:	e8 f8 01 00 00       	call   80071e <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800529:	8a 00                	mov    (%eax),%al
  80052b:	3a 45 ef             	cmp    -0x11(%ebp),%al
  80052e:	75 16                	jne    800546 <_main+0x50e>
  800530:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800533:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8a 00                	mov    (%eax),%al
  800541:	3a 45 ee             	cmp    -0x12(%ebp),%al
  800544:	74 14                	je     80055a <_main+0x522>
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	68 34 38 80 00       	push   $0x803834
  80054e:	6a 68                	push   $0x68
  800550:	68 69 38 80 00       	push   $0x803869
  800555:	e8 c4 01 00 00       	call   80071e <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80055a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80055d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800561:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  800565:	75 19                	jne    800580 <_main+0x548>
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800574:	01 d0                	add    %edx,%eax
  800576:	66 8b 40 02          	mov    0x2(%eax),%ax
  80057a:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 34 38 80 00       	push   $0x803834
  800588:	6a 69                	push   $0x69
  80058a:	68 69 38 80 00       	push   $0x803869
  80058f:	e8 8a 01 00 00       	call   80071e <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800594:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800597:	8b 40 04             	mov    0x4(%eax),%eax
  80059a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80059d:	75 17                	jne    8005b6 <_main+0x57e>
  80059f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8b 40 04             	mov    0x4(%eax),%eax
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	74 14                	je     8005ca <_main+0x592>
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 34 38 80 00       	push   $0x803834
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 69 38 80 00       	push   $0x803869
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 80 38 80 00       	push   $0x803880
  8005d2:	e8 fb 03 00 00       	call   8009d2 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 7d 1a 00 00       	call   80206a <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800605:	01 d0                	add    %edx,%eax
  800607:	c1 e0 04             	shl    $0x4,%eax
  80060a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800614:	a1 20 50 80 00       	mov    0x805020,%eax
  800619:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80061f:	84 c0                	test   %al,%al
  800621:	74 0f                	je     800632 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800623:	a1 20 50 80 00       	mov    0x805020,%eax
  800628:	05 5c 05 00 00       	add    $0x55c,%eax
  80062d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800636:	7e 0a                	jle    800642 <libmain+0x60>
		binaryname = argv[0];
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 e8 f9 ff ff       	call   800038 <_main>
  800650:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800653:	e8 1f 18 00 00       	call   801e77 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 d4 38 80 00       	push   $0x8038d4
  800660:	e8 6d 03 00 00       	call   8009d2 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800668:	a1 20 50 80 00       	mov    0x805020,%eax
  80066d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800673:	a1 20 50 80 00       	mov    0x805020,%eax
  800678:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	68 fc 38 80 00       	push   $0x8038fc
  800688:	e8 45 03 00 00       	call   8009d2 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800690:	a1 20 50 80 00       	mov    0x805020,%eax
  800695:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80069b:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b1:	51                   	push   %ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	68 24 39 80 00       	push   $0x803924
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 7c 39 80 00       	push   $0x80397c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 d4 38 80 00       	push   $0x8038d4
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 9f 17 00 00       	call   801e91 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006f2:	e8 19 00 00 00       	call   800710 <exit>
}
  8006f7:	90                   	nop
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	6a 00                	push   $0x0
  800705:	e8 2c 19 00 00       	call   802036 <sys_destroy_env>
  80070a:	83 c4 10             	add    $0x10,%esp
}
  80070d:	90                   	nop
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <exit>:

void
exit(void)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800716:	e8 81 19 00 00       	call   80209c <sys_exit_env>
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800724:	8d 45 10             	lea    0x10(%ebp),%eax
  800727:	83 c0 04             	add    $0x4,%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80072d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800732:	85 c0                	test   %eax,%eax
  800734:	74 16                	je     80074c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800736:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	68 90 39 80 00       	push   $0x803990
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 95 39 80 00       	push   $0x803995
  80075d:	e8 70 02 00 00       	call   8009d2 <cprintf>
  800762:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 f4             	pushl  -0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	e8 f3 01 00 00       	call   800967 <vcprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	6a 00                	push   $0x0
  80077c:	68 b1 39 80 00       	push   $0x8039b1
  800781:	e8 e1 01 00 00       	call   800967 <vcprintf>
  800786:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800789:	e8 82 ff ff ff       	call   800710 <exit>

	// should not return here
	while (1) ;
  80078e:	eb fe                	jmp    80078e <_panic+0x70>

00800790 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800796:	a1 20 50 80 00       	mov    0x805020,%eax
  80079b:	8b 50 74             	mov    0x74(%eax),%edx
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 14                	je     8007b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	68 b4 39 80 00       	push   $0x8039b4
  8007ad:	6a 26                	push   $0x26
  8007af:	68 00 3a 80 00       	push   $0x803a00
  8007b4:	e8 65 ff ff ff       	call   80071e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007c7:	e9 c2 00 00 00       	jmp    80088e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	75 08                	jne    8007e9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007e4:	e9 a2 00 00 00       	jmp    80088b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007f7:	eb 69                	jmp    800862 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fe:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800804:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800807:	89 d0                	mov    %edx,%eax
  800809:	01 c0                	add    %eax,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	c1 e0 03             	shl    $0x3,%eax
  800810:	01 c8                	add    %ecx,%eax
  800812:	8a 40 04             	mov    0x4(%eax),%al
  800815:	84 c0                	test   %al,%al
  800817:	75 46                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800819:	a1 20 50 80 00       	mov    0x805020,%eax
  80081e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800827:	89 d0                	mov    %edx,%eax
  800829:	01 c0                	add    %eax,%eax
  80082b:	01 d0                	add    %edx,%eax
  80082d:	c1 e0 03             	shl    $0x3,%eax
  800830:	01 c8                	add    %ecx,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80083a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	01 c8                	add    %ecx,%eax
  800850:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800852:	39 c2                	cmp    %eax,%edx
  800854:	75 09                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800856:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80085d:	eb 12                	jmp    800871 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085f:	ff 45 e8             	incl   -0x18(%ebp)
  800862:	a1 20 50 80 00       	mov    0x805020,%eax
  800867:	8b 50 74             	mov    0x74(%eax),%edx
  80086a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	77 88                	ja     8007f9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800875:	75 14                	jne    80088b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 0c 3a 80 00       	push   $0x803a0c
  80087f:	6a 3a                	push   $0x3a
  800881:	68 00 3a 80 00       	push   $0x803a00
  800886:	e8 93 fe ff ff       	call   80071e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80088b:	ff 45 f0             	incl   -0x10(%ebp)
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800894:	0f 8c 32 ff ff ff    	jl     8007cc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80089a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008a8:	eb 26                	jmp    8008d0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8008af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	01 c0                	add    %eax,%eax
  8008bc:	01 d0                	add    %edx,%eax
  8008be:	c1 e0 03             	shl    $0x3,%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8a 40 04             	mov    0x4(%eax),%al
  8008c6:	3c 01                	cmp    $0x1,%al
  8008c8:	75 03                	jne    8008cd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008ca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cd:	ff 45 e0             	incl   -0x20(%ebp)
  8008d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d5:	8b 50 74             	mov    0x74(%eax),%edx
  8008d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	77 cb                	ja     8008aa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008e5:	74 14                	je     8008fb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 60 3a 80 00       	push   $0x803a60
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 00 3a 80 00       	push   $0x803a00
  8008f6:	e8 23 fe ff ff       	call   80071e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	8d 48 01             	lea    0x1(%eax),%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	89 0a                	mov    %ecx,(%edx)
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	88 d1                	mov    %dl,%cl
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	3d ff 00 00 00       	cmp    $0xff,%eax
  800927:	75 2c                	jne    800955 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800929:	a0 24 50 80 00       	mov    0x805024,%al
  80092e:	0f b6 c0             	movzbl %al,%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	8b 12                	mov    (%edx),%edx
  800936:	89 d1                	mov    %edx,%ecx
  800938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093b:	83 c2 08             	add    $0x8,%edx
  80093e:	83 ec 04             	sub    $0x4,%esp
  800941:	50                   	push   %eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	e8 80 13 00 00       	call   801cc9 <sys_cputs>
  800949:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 40 04             	mov    0x4(%eax),%eax
  80095b:	8d 50 01             	lea    0x1(%eax),%edx
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	89 50 04             	mov    %edx,0x4(%eax)
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800970:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800977:	00 00 00 
	b.cnt = 0;
  80097a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800981:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	68 fe 08 80 00       	push   $0x8008fe
  800996:	e8 11 02 00 00       	call   800bac <vprintfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80099e:	a0 24 50 80 00       	mov    0x805024,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	50                   	push   %eax
  8009b0:	52                   	push   %edx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 09 13 00 00       	call   801cc9 <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8009ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009d8:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 73 ff ff ff       	call   800967 <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a05:	e8 6d 14 00 00       	call   801e77 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 f4             	pushl  -0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	e8 48 ff ff ff       	call   800967 <vcprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a25:	e8 67 14 00 00       	call   801e91 <sys_enable_interrupt>
	return cnt;
  800a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	83 ec 14             	sub    $0x14,%esp
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	8b 45 18             	mov    0x18(%ebp),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4d:	77 55                	ja     800aa4 <printnum+0x75>
  800a4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a52:	72 05                	jb     800a59 <printnum+0x2a>
  800a54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a57:	77 4b                	ja     800aa4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a59:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a5c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	52                   	push   %edx
  800a68:	50                   	push   %eax
  800a69:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6f:	e8 84 2a 00 00       	call   8034f8 <__udivdi3>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	ff 75 20             	pushl  0x20(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	ff 75 18             	pushl  0x18(%ebp)
  800a81:	52                   	push   %edx
  800a82:	50                   	push   %eax
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 a1 ff ff ff       	call   800a2f <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
  800a91:	eb 1a                	jmp    800aad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 20             	pushl  0x20(%ebp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa4:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aab:	7f e6                	jg     800a93 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abb:	53                   	push   %ebx
  800abc:	51                   	push   %ecx
  800abd:	52                   	push   %edx
  800abe:	50                   	push   %eax
  800abf:	e8 44 2b 00 00       	call   803608 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 d4 3c 80 00       	add    $0x803cd4,%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	0f be c0             	movsbl %al,%eax
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
}
  800ae0:	90                   	nop
  800ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aed:	7e 1c                	jle    800b0b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	8d 50 08             	lea    0x8(%eax),%edx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	89 10                	mov    %edx,(%eax)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	83 e8 08             	sub    $0x8,%eax
  800b04:	8b 50 04             	mov    0x4(%eax),%edx
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	eb 40                	jmp    800b4b <getuint+0x65>
	else if (lflag)
  800b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0f:	74 1e                	je     800b2f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 50 04             	lea    0x4(%eax),%edx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 10                	mov    %edx,(%eax)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2d:	eb 1c                	jmp    800b4b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 50 04             	lea    0x4(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 10                	mov    %edx,(%eax)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b54:	7e 1c                	jle    800b72 <getint+0x25>
		return va_arg(*ap, long long);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 08             	lea    0x8(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 08             	sub    $0x8,%eax
  800b6b:	8b 50 04             	mov    0x4(%eax),%edx
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	eb 38                	jmp    800baa <getint+0x5d>
	else if (lflag)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 1a                	je     800b92 <getint+0x45>
		return va_arg(*ap, long);
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	8d 50 04             	lea    0x4(%eax),%edx
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 10                	mov    %edx,(%eax)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	83 e8 04             	sub    $0x4,%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	99                   	cltd   
  800b90:	eb 18                	jmp    800baa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	8d 50 04             	lea    0x4(%eax),%edx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 10                	mov    %edx,(%eax)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	83 e8 04             	sub    $0x4,%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	99                   	cltd   
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb4:	eb 17                	jmp    800bcd <vprintfmt+0x21>
			if (ch == '\0')
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	0f 84 af 03 00 00    	je     800f6d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	8d 50 01             	lea    0x1(%eax),%edx
  800bd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d8             	movzbl %al,%ebx
  800bdb:	83 fb 25             	cmp    $0x25,%ebx
  800bde:	75 d6                	jne    800bb6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800beb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bf2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d8             	movzbl %al,%ebx
  800c0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c11:	83 f8 55             	cmp    $0x55,%eax
  800c14:	0f 87 2b 03 00 00    	ja     800f45 <vprintfmt+0x399>
  800c1a:	8b 04 85 f8 3c 80 00 	mov    0x803cf8(,%eax,4),%eax
  800c21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c27:	eb d7                	jmp    800c00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2d:	eb d1                	jmp    800c00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 02             	shl    $0x2,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d8                	add    %ebx,%eax
  800c44:	83 e8 30             	sub    $0x30,%eax
  800c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c52:	83 fb 2f             	cmp    $0x2f,%ebx
  800c55:	7e 3e                	jle    800c95 <vprintfmt+0xe9>
  800c57:	83 fb 39             	cmp    $0x39,%ebx
  800c5a:	7f 39                	jg     800c95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5f:	eb d5                	jmp    800c36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c75:	eb 1f                	jmp    800c96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7b:	79 83                	jns    800c00 <vprintfmt+0x54>
				width = 0;
  800c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c84:	e9 77 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c90:	e9 6b ff ff ff       	jmp    800c00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	0f 89 60 ff ff ff    	jns    800c00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cad:	e9 4e ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cb2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb5:	e9 46 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 c0 04             	add    $0x4,%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 e8 04             	sub    $0x4,%eax
  800cc9:	8b 00                	mov    (%eax),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 89 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	79 02                	jns    800cf6 <vprintfmt+0x14a>
				err = -err;
  800cf4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf6:	83 fb 64             	cmp    $0x64,%ebx
  800cf9:	7f 0b                	jg     800d06 <vprintfmt+0x15a>
  800cfb:	8b 34 9d 40 3b 80 00 	mov    0x803b40(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 e5 3c 80 00       	push   $0x803ce5
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 5e 02 00 00       	call   800f75 <printfmt>
  800d17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1a:	e9 49 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1f:	56                   	push   %esi
  800d20:	68 ee 3c 80 00       	push   $0x803cee
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 45 02 00 00       	call   800f75 <printfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	e9 30 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 e8 04             	sub    $0x4,%eax
  800d47:	8b 30                	mov    (%eax),%esi
  800d49:	85 f6                	test   %esi,%esi
  800d4b:	75 05                	jne    800d52 <vprintfmt+0x1a6>
				p = "(null)";
  800d4d:	be f1 3c 80 00       	mov    $0x803cf1,%esi
			if (width > 0 && padc != '-')
  800d52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d56:	7e 6d                	jle    800dc5 <vprintfmt+0x219>
  800d58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d5c:	74 67                	je     800dc5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	50                   	push   %eax
  800d65:	56                   	push   %esi
  800d66:	e8 0c 03 00 00       	call   801077 <strnlen>
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d71:	eb 16                	jmp    800d89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	50                   	push   %eax
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d86:	ff 4d e4             	decl   -0x1c(%ebp)
  800d89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8d:	7f e4                	jg     800d73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8f:	eb 34                	jmp    800dc5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d95:	74 1c                	je     800db3 <vprintfmt+0x207>
  800d97:	83 fb 1f             	cmp    $0x1f,%ebx
  800d9a:	7e 05                	jle    800da1 <vprintfmt+0x1f5>
  800d9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9f:	7e 12                	jle    800db3 <vprintfmt+0x207>
					putch('?', putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	6a 3f                	push   $0x3f
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	ff d0                	call   *%eax
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	eb 0f                	jmp    800dc2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc5:	89 f0                	mov    %esi,%eax
  800dc7:	8d 70 01             	lea    0x1(%eax),%esi
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f be d8             	movsbl %al,%ebx
  800dcf:	85 db                	test   %ebx,%ebx
  800dd1:	74 24                	je     800df7 <vprintfmt+0x24b>
  800dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd7:	78 b8                	js     800d91 <vprintfmt+0x1e5>
  800dd9:	ff 4d e0             	decl   -0x20(%ebp)
  800ddc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de0:	79 af                	jns    800d91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de2:	eb 13                	jmp    800df7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	6a 20                	push   $0x20
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df4:	ff 4d e4             	decl   -0x1c(%ebp)
  800df7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfb:	7f e7                	jg     800de4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfd:	e9 66 01 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 e8             	pushl  -0x18(%ebp)
  800e08:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0b:	50                   	push   %eax
  800e0c:	e8 3c fd ff ff       	call   800b4d <getint>
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	85 d2                	test   %edx,%edx
  800e22:	79 23                	jns    800e47 <vprintfmt+0x29b>
				putch('-', putdat);
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	6a 2d                	push   $0x2d
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	f7 d8                	neg    %eax
  800e3c:	83 d2 00             	adc    $0x0,%edx
  800e3f:	f7 da                	neg    %edx
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4e:	e9 bc 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 e8             	pushl  -0x18(%ebp)
  800e59:	8d 45 14             	lea    0x14(%ebp),%eax
  800e5c:	50                   	push   %eax
  800e5d:	e8 84 fc ff ff       	call   800ae6 <getuint>
  800e62:	83 c4 10             	add    $0x10,%esp
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e72:	e9 98 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 58                	push   $0x58
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	6a 58                	push   $0x58
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 58                	push   $0x58
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			break;
  800ea7:	e9 bc 00 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 30                	push   $0x30
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 78                	push   $0x78
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eee:	eb 1f                	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	e8 e7 fb ff ff       	call   800ae6 <getuint>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	52                   	push   %edx
  800f1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1d:	50                   	push   %eax
  800f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f21:	ff 75 f0             	pushl  -0x10(%ebp)
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	ff 75 08             	pushl  0x8(%ebp)
  800f2a:	e8 00 fb ff ff       	call   800a2f <printnum>
  800f2f:	83 c4 20             	add    $0x20,%esp
			break;
  800f32:	eb 34                	jmp    800f68 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	53                   	push   %ebx
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
			break;
  800f43:	eb 23                	jmp    800f68 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 25                	push   $0x25
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	eb 03                	jmp    800f5d <vprintfmt+0x3b1>
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	48                   	dec    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 25                	cmp    $0x25,%al
  800f65:	75 f3                	jne    800f5a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f67:	90                   	nop
		}
	}
  800f68:	e9 47 fc ff ff       	jmp    800bb4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f7e:	83 c0 04             	add    $0x4,%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	ff 75 08             	pushl  0x8(%ebp)
  800f91:	e8 16 fc ff ff       	call   800bac <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8b 40 08             	mov    0x8(%eax),%eax
  800fa5:	8d 50 01             	lea    0x1(%eax),%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 10                	mov    (%eax),%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 40 04             	mov    0x4(%eax),%eax
  800fb9:	39 c2                	cmp    %eax,%edx
  800fbb:	73 12                	jae    800fcf <sprintputch+0x33>
		*b->buf++ = ch;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 00                	mov    (%eax),%eax
  800fc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	89 0a                	mov    %ecx,(%edx)
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
}
  800fcf:	90                   	nop
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff7:	74 06                	je     800fff <vsnprintf+0x2d>
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	7f 07                	jg     801006 <vsnprintf+0x34>
		return -E_INVAL;
  800fff:	b8 03 00 00 00       	mov    $0x3,%eax
  801004:	eb 20                	jmp    801026 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801006:	ff 75 14             	pushl  0x14(%ebp)
  801009:	ff 75 10             	pushl  0x10(%ebp)
  80100c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80100f:	50                   	push   %eax
  801010:	68 9c 0f 80 00       	push   $0x800f9c
  801015:	e8 92 fb ff ff       	call   800bac <vprintfmt>
  80101a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80101d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801020:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801023:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80102e:	8d 45 10             	lea    0x10(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 89 ff ff ff       	call   800fd2 <vsnprintf>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801061:	eb 06                	jmp    801069 <strlen+0x15>
		n++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 f1                	jne    801063 <strlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801084:	eb 09                	jmp    80108f <strnlen+0x18>
		n++;
  801086:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	ff 4d 0c             	decl   0xc(%ebp)
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	74 09                	je     80109e <strnlen+0x27>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e8                	jne    801086 <strnlen+0xf>
		n++;
	return n;
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010af:	90                   	nop
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	75 e4                	jne    8010b0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e4:	eb 1f                	jmp    801105 <strncpy+0x34>
		*dst++ = *src;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 03                	je     801102 <strncpy+0x31>
			src++;
  8010ff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801102:	ff 45 fc             	incl   -0x4(%ebp)
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110b:	72 d9                	jb     8010e6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801122:	74 30                	je     801154 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801124:	eb 16                	jmp    80113c <strlcpy+0x2a>
			*dst++ = *src++;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 08             	mov    %edx,0x8(%ebp)
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8d 4a 01             	lea    0x1(%edx),%ecx
  801135:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801138:	8a 12                	mov    (%edx),%dl
  80113a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113c:	ff 4d 10             	decl   0x10(%ebp)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	74 09                	je     80114e <strlcpy+0x3c>
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 d8                	jne    801126 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801163:	eb 06                	jmp    80116b <strcmp+0xb>
		p++, q++;
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 0e                	je     801182 <strcmp+0x22>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	38 c2                	cmp    %al,%dl
  801180:	74 e3                	je     801165 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f b6 c0             	movzbl %al,%eax
  801192:	29 c2                	sub    %eax,%edx
  801194:	89 d0                	mov    %edx,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80119b:	eb 09                	jmp    8011a6 <strncmp+0xe>
		n--, p++, q++;
  80119d:	ff 4d 10             	decl   0x10(%ebp)
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 17                	je     8011c3 <strncmp+0x2b>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 0e                	je     8011c3 <strncmp+0x2b>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 10                	mov    (%eax),%dl
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	38 c2                	cmp    %al,%dl
  8011c1:	74 da                	je     80119d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c7:	75 07                	jne    8011d0 <strncmp+0x38>
		return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb 14                	jmp    8011e4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f2:	eb 12                	jmp    801206 <strchr+0x20>
		if (*s == c)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fc:	75 05                	jne    801203 <strchr+0x1d>
			return (char *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	eb 11                	jmp    801214 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e5                	jne    8011f4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801222:	eb 0d                	jmp    801231 <strfind+0x1b>
		if (*s == c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122c:	74 0e                	je     80123c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	75 ea                	jne    801224 <strfind+0xe>
  80123a:	eb 01                	jmp    80123d <strfind+0x27>
		if (*s == c)
			break;
  80123c:	90                   	nop
	return (char *) s;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801254:	eb 0e                	jmp    801264 <memset+0x22>
		*p++ = c;
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801264:	ff 4d f8             	decl   -0x8(%ebp)
  801267:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80126b:	79 e9                	jns    801256 <memset+0x14>
		*p++ = c;

	return v;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801284:	eb 16                	jmp    80129c <memcpy+0x2a>
		*d++ = *s++;
  801286:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801289:	8d 50 01             	lea    0x1(%eax),%edx
  80128c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801292:	8d 4a 01             	lea    0x1(%edx),%ecx
  801295:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801298:	8a 12                	mov    (%edx),%dl
  80129a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 dd                	jne    801286 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c6:	73 50                	jae    801318 <memmove+0x6a>
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d3:	76 43                	jbe    801318 <memmove+0x6a>
		s += n;
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e1:	eb 10                	jmp    8012f3 <memmove+0x45>
			*--d = *--s;
  8012e3:	ff 4d f8             	decl   -0x8(%ebp)
  8012e6:	ff 4d fc             	decl   -0x4(%ebp)
  8012e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ec:	8a 10                	mov    (%eax),%dl
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	75 e3                	jne    8012e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801300:	eb 23                	jmp    801325 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801311:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801314:	8a 12                	mov    (%edx),%dl
  801316:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131e:	89 55 10             	mov    %edx,0x10(%ebp)
  801321:	85 c0                	test   %eax,%eax
  801323:	75 dd                	jne    801302 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80133c:	eb 2a                	jmp    801368 <memcmp+0x3e>
		if (*s1 != *s2)
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8a 10                	mov    (%eax),%dl
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	38 c2                	cmp    %al,%dl
  80134a:	74 16                	je     801362 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
  801360:	eb 18                	jmp    80137a <memcmp+0x50>
		s1++, s2++;
  801362:	ff 45 fc             	incl   -0x4(%ebp)
  801365:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136e:	89 55 10             	mov    %edx,0x10(%ebp)
  801371:	85 c0                	test   %eax,%eax
  801373:	75 c9                	jne    80133e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 45 10             	mov    0x10(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80138d:	eb 15                	jmp    8013a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 d0             	movzbl %al,%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	0f b6 c0             	movzbl %al,%eax
  80139d:	39 c2                	cmp    %eax,%edx
  80139f:	74 0d                	je     8013ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013aa:	72 e3                	jb     80138f <memfind+0x13>
  8013ac:	eb 01                	jmp    8013af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ae:	90                   	nop
	return (void *) s;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c8:	eb 03                	jmp    8013cd <strtol+0x19>
		s++;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 20                	cmp    $0x20,%al
  8013d4:	74 f4                	je     8013ca <strtol+0x16>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 09                	cmp    $0x9,%al
  8013dd:	74 eb                	je     8013ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3c 2b                	cmp    $0x2b,%al
  8013e6:	75 05                	jne    8013ed <strtol+0x39>
		s++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	eb 13                	jmp    801400 <strtol+0x4c>
	else if (*s == '-')
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 2d                	cmp    $0x2d,%al
  8013f4:	75 0a                	jne    801400 <strtol+0x4c>
		s++, neg = 1;
  8013f6:	ff 45 08             	incl   0x8(%ebp)
  8013f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801404:	74 06                	je     80140c <strtol+0x58>
  801406:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140a:	75 20                	jne    80142c <strtol+0x78>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 30                	cmp    $0x30,%al
  801413:	75 17                	jne    80142c <strtol+0x78>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	40                   	inc    %eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0d                	jne    80142c <strtol+0x78>
		s += 2, base = 16;
  80141f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142a:	eb 28                	jmp    801454 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80142c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801430:	75 15                	jne    801447 <strtol+0x93>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 30                	cmp    $0x30,%al
  801439:	75 0c                	jne    801447 <strtol+0x93>
		s++, base = 8;
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801445:	eb 0d                	jmp    801454 <strtol+0xa0>
	else if (base == 0)
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	75 07                	jne    801454 <strtol+0xa0>
		base = 10;
  80144d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 2f                	cmp    $0x2f,%al
  80145b:	7e 19                	jle    801476 <strtol+0xc2>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 39                	cmp    $0x39,%al
  801464:	7f 10                	jg     801476 <strtol+0xc2>
			dig = *s - '0';
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f be c0             	movsbl %al,%eax
  80146e:	83 e8 30             	sub    $0x30,%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801474:	eb 42                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 60                	cmp    $0x60,%al
  80147d:	7e 19                	jle    801498 <strtol+0xe4>
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 7a                	cmp    $0x7a,%al
  801486:	7f 10                	jg     801498 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	0f be c0             	movsbl %al,%eax
  801490:	83 e8 57             	sub    $0x57,%eax
  801493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801496:	eb 20                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 40                	cmp    $0x40,%al
  80149f:	7e 39                	jle    8014da <strtol+0x126>
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 5a                	cmp    $0x5a,%al
  8014a8:	7f 30                	jg     8014da <strtol+0x126>
			dig = *s - 'A' + 10;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	83 e8 37             	sub    $0x37,%eax
  8014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014be:	7d 19                	jge    8014d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c0:	ff 45 08             	incl   0x8(%ebp)
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d4:	e9 7b ff ff ff       	jmp    801454 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014de:	74 08                	je     8014e8 <strtol+0x134>
		*endptr = (char *) s;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ec:	74 07                	je     8014f5 <strtol+0x141>
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	f7 d8                	neg    %eax
  8014f3:	eb 03                	jmp    8014f8 <strtol+0x144>
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <ltostr>:

void
ltostr(long value, char *str)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80150e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801512:	79 13                	jns    801527 <ltostr+0x2d>
	{
		neg = 1;
  801514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801521:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801524:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80152f:	99                   	cltd   
  801530:	f7 f9                	idiv   %ecx
  801532:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801538:	8d 50 01             	lea    0x1(%eax),%edx
  80153b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801548:	83 c2 30             	add    $0x30,%edx
  80154b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80154d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801550:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801555:	f7 e9                	imul   %ecx
  801557:	c1 fa 02             	sar    $0x2,%edx
  80155a:	89 c8                	mov    %ecx,%eax
  80155c:	c1 f8 1f             	sar    $0x1f,%eax
  80155f:	29 c2                	sub    %eax,%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801569:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80156e:	f7 e9                	imul   %ecx
  801570:	c1 fa 02             	sar    $0x2,%edx
  801573:	89 c8                	mov    %ecx,%eax
  801575:	c1 f8 1f             	sar    $0x1f,%eax
  801578:	29 c2                	sub    %eax,%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	c1 e0 02             	shl    $0x2,%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	01 c0                	add    %eax,%eax
  801583:	29 c1                	sub    %eax,%ecx
  801585:	89 ca                	mov    %ecx,%edx
  801587:	85 d2                	test   %edx,%edx
  801589:	75 9c                	jne    801527 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80158b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801592:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801595:	48                   	dec    %eax
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80159d:	74 3d                	je     8015dc <ltostr+0xe2>
		start = 1 ;
  80159f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015a6:	eb 34                	jmp    8015dc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c2                	add    %eax,%edx
  8015d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8015d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e2:	7c c4                	jl     8015a8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 54 fa ff ff       	call   801054 <strlen>
  801600:	83 c4 04             	add    $0x4,%esp
  801603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	e8 46 fa ff ff       	call   801054 <strlen>
  80160e:	83 c4 04             	add    $0x4,%esp
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80161b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801622:	eb 17                	jmp    80163b <strcconcat+0x49>
		final[s] = str1[s] ;
  801624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	01 c2                	add    %eax,%edx
  80162c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	01 c8                	add    %ecx,%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801641:	7c e1                	jl     801624 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80164a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801651:	eb 1f                	jmp    801672 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	8d 50 01             	lea    0x1(%eax),%edx
  801659:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 c2                	add    %eax,%edx
  801663:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80166f:	ff 45 f8             	incl   -0x8(%ebp)
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801678:	7c d9                	jl     801653 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80167a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80168b:	8b 45 14             	mov    0x14(%ebp),%eax
  80168e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ab:	eb 0c                	jmp    8016b9 <strsplit+0x31>
			*string++ = 0;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8d 50 01             	lea    0x1(%eax),%edx
  8016b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 18                	je     8016da <strsplit+0x52>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 13 fb ff ff       	call   8011e6 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	75 d3                	jne    8016ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 5a                	je     80173d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	83 f8 0f             	cmp    $0xf,%eax
  8016eb:	75 07                	jne    8016f4 <strsplit+0x6c>
		{
			return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 66                	jmp    80175a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8016fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ff:	89 0a                	mov    %ecx,(%edx)
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 c2                	add    %eax,%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801712:	eb 03                	jmp    801717 <strsplit+0x8f>
			string++;
  801714:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 8b                	je     8016ab <strsplit+0x23>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 b5 fa ff ff       	call   8011e6 <strchr>
  801731:	83 c4 08             	add    $0x8,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	74 dc                	je     801714 <strsplit+0x8c>
			string++;
	}
  801738:	e9 6e ff ff ff       	jmp    8016ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80173d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80173e:	8b 45 14             	mov    0x14(%ebp),%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	01 d0                	add    %edx,%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801755:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801762:	a1 04 50 80 00       	mov    0x805004,%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	74 1f                	je     80178a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80176b:	e8 1d 00 00 00       	call   80178d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	68 50 3e 80 00       	push   $0x803e50
  801778:	e8 55 f2 ff ff       	call   8009d2 <cprintf>
  80177d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801780:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801787:	00 00 00 
	}
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 28             	sub    $0x28,%esp

	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	 LIST_INIT(&FreeMemBlocksList);
  801793:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80179a:	00 00 00 
  80179d:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017a4:	00 00 00 
  8017a7:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8017ae:	00 00 00 
	 LIST_INIT(&AllocMemBlocksList);
  8017b1:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8017b8:	00 00 00 
  8017bb:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017c2:	00 00 00 
  8017c5:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8017cc:	00 00 00 
	 MemBlockNodes =(struct MemBlock *)USER_DYN_BLKS_ARRAY;//new
  8017cf:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8017d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017e3:	a3 50 50 80 00       	mov    %eax,0x805050

	 MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES;
  8017e8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8017ef:	00 02 00 

	 uint32 blocksArraySize=ROUNDUP((sizeof(struct MemBlock) * NUM_OF_UHEAP_PAGES),PAGE_SIZE);
  8017f2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fc:	05 ff ff 1f 00       	add    $0x1fffff,%eax
  801801:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801807:	ba 00 00 00 00       	mov    $0x0,%edx
  80180c:	f7 75 f0             	divl   -0x10(%ebp)
  80180f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801812:	29 d0                	sub    %edx,%eax
  801814:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 sys_allocate_chunk(USER_DYN_BLKS_ARRAY, blocksArraySize, PERM_WRITEABLE|PERM_USER);//new
  801817:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80181e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801821:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801826:	2d 00 10 00 00       	sub    $0x1000,%eax
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	6a 06                	push   $0x6
  801830:	ff 75 e8             	pushl  -0x18(%ebp)
  801833:	50                   	push   %eax
  801834:	e8 d4 05 00 00       	call   801e0d <sys_allocate_chunk>
  801839:	83 c4 10             	add    $0x10,%esp


	 //[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	 initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80183c:	a1 20 51 80 00       	mov    0x805120,%eax
  801841:	83 ec 0c             	sub    $0xc,%esp
  801844:	50                   	push   %eax
  801845:	e8 49 0c 00 00       	call   802493 <initialize_MemBlocksList>
  80184a:	83 c4 10             	add    $0x10,%esp


	 //[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	 	 struct MemBlock *newblock = LIST_FIRST(&AvailableMemBlocksList);
  80184d:	a1 48 51 80 00       	mov    0x805148,%eax
  801852:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 LIST_REMOVE(&AvailableMemBlocksList, newblock);
  801855:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801859:	75 14                	jne    80186f <initialize_dyn_block_system+0xe2>
  80185b:	83 ec 04             	sub    $0x4,%esp
  80185e:	68 75 3e 80 00       	push   $0x803e75
  801863:	6a 39                	push   $0x39
  801865:	68 93 3e 80 00       	push   $0x803e93
  80186a:	e8 af ee ff ff       	call   80071e <_panic>
  80186f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801872:	8b 00                	mov    (%eax),%eax
  801874:	85 c0                	test   %eax,%eax
  801876:	74 10                	je     801888 <initialize_dyn_block_system+0xfb>
  801878:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187b:	8b 00                	mov    (%eax),%eax
  80187d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801880:	8b 52 04             	mov    0x4(%edx),%edx
  801883:	89 50 04             	mov    %edx,0x4(%eax)
  801886:	eb 0b                	jmp    801893 <initialize_dyn_block_system+0x106>
  801888:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80188b:	8b 40 04             	mov    0x4(%eax),%eax
  80188e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801893:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801896:	8b 40 04             	mov    0x4(%eax),%eax
  801899:	85 c0                	test   %eax,%eax
  80189b:	74 0f                	je     8018ac <initialize_dyn_block_system+0x11f>
  80189d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a0:	8b 40 04             	mov    0x4(%eax),%eax
  8018a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018a6:	8b 12                	mov    (%edx),%edx
  8018a8:	89 10                	mov    %edx,(%eax)
  8018aa:	eb 0a                	jmp    8018b6 <initialize_dyn_block_system+0x129>
  8018ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018af:	8b 00                	mov    (%eax),%eax
  8018b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8018b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8018ce:	48                   	dec    %eax
  8018cf:	a3 54 51 80 00       	mov    %eax,0x805154

		 newblock->size=USER_HEAP_MAX-USER_HEAP_START;
  8018d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d7:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		 newblock->sva= (USER_HEAP_START);
  8018de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)

		 LIST_INSERT_HEAD(&FreeMemBlocksList, (newblock));
  8018e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018ec:	75 14                	jne    801902 <initialize_dyn_block_system+0x175>
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	68 a0 3e 80 00       	push   $0x803ea0
  8018f6:	6a 3f                	push   $0x3f
  8018f8:	68 93 3e 80 00       	push   $0x803e93
  8018fd:	e8 1c ee ff ff       	call   80071e <_panic>
  801902:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801908:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190b:	89 10                	mov    %edx,(%eax)
  80190d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	85 c0                	test   %eax,%eax
  801914:	74 0d                	je     801923 <initialize_dyn_block_system+0x196>
  801916:	a1 38 51 80 00       	mov    0x805138,%eax
  80191b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80191e:	89 50 04             	mov    %edx,0x4(%eax)
  801921:	eb 08                	jmp    80192b <initialize_dyn_block_system+0x19e>
  801923:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801926:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80192b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80192e:	a3 38 51 80 00       	mov    %eax,0x805138
  801933:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801936:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80193d:	a1 44 51 80 00       	mov    0x805144,%eax
  801942:	40                   	inc    %eax
  801943:	a3 44 51 80 00       	mov    %eax,0x805144

}
  801948:	90                   	nop
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801951:	e8 06 fe ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801956:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80195a:	75 07                	jne    801963 <malloc+0x18>
  80195c:	b8 00 00 00 00       	mov    $0x0,%eax
  801961:	eb 7d                	jmp    8019e0 <malloc+0x95>
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	//panic("malloc() is not implemented yet...!!");

	      struct MemBlock *theBlock;
	      int ret = 0;
  801963:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	      uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  80196a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801971:	8b 55 08             	mov    0x8(%ebp),%edx
  801974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801977:	01 d0                	add    %edx,%eax
  801979:	48                   	dec    %eax
  80197a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80197d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801980:	ba 00 00 00 00       	mov    $0x0,%edx
  801985:	f7 75 f0             	divl   -0x10(%ebp)
  801988:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198b:	29 d0                	sub    %edx,%eax
  80198d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	      if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {  ret = 1; }
  801990:	e8 46 08 00 00       	call   8021db <sys_isUHeapPlacementStrategyFIRSTFIT>
  801995:	83 f8 01             	cmp    $0x1,%eax
  801998:	75 07                	jne    8019a1 <malloc+0x56>
  80199a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)

	      if (ret == 1) {
  8019a1:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  8019a5:	75 34                	jne    8019db <malloc+0x90>
	       theBlock = alloc_block_FF(newsize);
  8019a7:	83 ec 0c             	sub    $0xc,%esp
  8019aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8019ad:	e8 73 0e 00 00       	call   802825 <alloc_block_FF>
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	             if (theBlock != NULL){
  8019b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019bc:	74 16                	je     8019d4 <malloc+0x89>
	              insert_sorted_allocList(theBlock);
  8019be:	83 ec 0c             	sub    $0xc,%esp
  8019c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019c4:	e8 ff 0b 00 00       	call   8025c8 <insert_sorted_allocList>
  8019c9:	83 c4 10             	add    $0x10,%esp

	             	return (void*)theBlock->sva;
  8019cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019cf:	8b 40 08             	mov    0x8(%eax),%eax
  8019d2:	eb 0c                	jmp    8019e0 <malloc+0x95>
	             }
	             else
	             	return NULL;
  8019d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d9:	eb 05                	jmp    8019e0 <malloc+0x95>
	      	  }
	          else
	               return NULL;
  8019db:	b8 00 00 00 00       	mov    $0x0,%eax
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy

}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
		uint32 va=(uint32)virtual_address;
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	89 45 f4             	mov    %eax,-0xc(%ebp)

		va =ROUNDDOWN(va,PAGE_SIZE);
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct MemBlock *theBlock = find_block(&AllocMemBlocksList,va);
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	ff 75 f4             	pushl  -0xc(%ebp)
  801a05:	68 40 50 80 00       	push   $0x805040
  801a0a:	e8 61 0b 00 00       	call   802570 <find_block>
  801a0f:	83 c4 10             	add    $0x10,%esp
  801a12:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (theBlock != NULL) {
  801a15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a19:	0f 84 a5 00 00 00    	je     801ac4 <free+0xe2>
			sys_free_user_mem(va, theBlock->size);
  801a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a22:	8b 40 0c             	mov    0xc(%eax),%eax
  801a25:	83 ec 08             	sub    $0x8,%esp
  801a28:	50                   	push   %eax
  801a29:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2c:	e8 a4 03 00 00       	call   801dd5 <sys_free_user_mem>
  801a31:	83 c4 10             	add    $0x10,%esp
			LIST_REMOVE(&AllocMemBlocksList, theBlock);
  801a34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a38:	75 17                	jne    801a51 <free+0x6f>
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	68 75 3e 80 00       	push   $0x803e75
  801a42:	68 87 00 00 00       	push   $0x87
  801a47:	68 93 3e 80 00       	push   $0x803e93
  801a4c:	e8 cd ec ff ff       	call   80071e <_panic>
  801a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a54:	8b 00                	mov    (%eax),%eax
  801a56:	85 c0                	test   %eax,%eax
  801a58:	74 10                	je     801a6a <free+0x88>
  801a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a5d:	8b 00                	mov    (%eax),%eax
  801a5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a62:	8b 52 04             	mov    0x4(%edx),%edx
  801a65:	89 50 04             	mov    %edx,0x4(%eax)
  801a68:	eb 0b                	jmp    801a75 <free+0x93>
  801a6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a6d:	8b 40 04             	mov    0x4(%eax),%eax
  801a70:	a3 44 50 80 00       	mov    %eax,0x805044
  801a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a78:	8b 40 04             	mov    0x4(%eax),%eax
  801a7b:	85 c0                	test   %eax,%eax
  801a7d:	74 0f                	je     801a8e <free+0xac>
  801a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a82:	8b 40 04             	mov    0x4(%eax),%eax
  801a85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a88:	8b 12                	mov    (%edx),%edx
  801a8a:	89 10                	mov    %edx,(%eax)
  801a8c:	eb 0a                	jmp    801a98 <free+0xb6>
  801a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a91:	8b 00                	mov    (%eax),%eax
  801a93:	a3 40 50 80 00       	mov    %eax,0x805040
  801a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801aab:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ab0:	48                   	dec    %eax
  801ab1:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(theBlock);
  801ab6:	83 ec 0c             	sub    $0xc,%esp
  801ab9:	ff 75 ec             	pushl  -0x14(%ebp)
  801abc:	e8 37 12 00 00       	call   802cf8 <insert_sorted_with_merge_freeList>
  801ac1:	83 c4 10             	add    $0x10,%esp
		//you need to call sys_free_user_mem()
		//refer to the project presentation and documentation for details



}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 38             	sub    $0x38,%esp
  801acd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad0:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ad3:	e8 84 fc ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801ad8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801adc:	75 07                	jne    801ae5 <smalloc+0x1e>
  801ade:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae3:	eb 7e                	jmp    801b63 <smalloc+0x9c>
	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");

	  void*va;
	  int ret = 0;
  801ae5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	  uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801aec:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af9:	01 d0                	add    %edx,%eax
  801afb:	48                   	dec    %eax
  801afc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
  801b07:	f7 75 f0             	divl   -0x10(%ebp)
  801b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0d:	29 d0                	sub    %edx,%eax
  801b0f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	  if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801b12:	e8 c4 06 00 00       	call   8021db <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b17:	83 f8 01             	cmp    $0x1,%eax
  801b1a:	75 42                	jne    801b5e <smalloc+0x97>

		  va = malloc(newsize) ;
  801b1c:	83 ec 0c             	sub    $0xc,%esp
  801b1f:	ff 75 e8             	pushl  -0x18(%ebp)
  801b22:	e8 24 fe ff ff       	call   80194b <malloc>
  801b27:	83 c4 10             	add    $0x10,%esp
  801b2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			  if (va != NULL){
  801b2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b31:	74 24                	je     801b57 <smalloc+0x90>
				  int id =sys_createSharedObject(sharedVarName,newsize,isWritable, va);
  801b33:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b37:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b3a:	50                   	push   %eax
  801b3b:	ff 75 e8             	pushl  -0x18(%ebp)
  801b3e:	ff 75 08             	pushl  0x8(%ebp)
  801b41:	e8 1a 04 00 00       	call   801f60 <sys_createSharedObject>
  801b46:	83 c4 10             	add    $0x10,%esp
  801b49:	89 45 e0             	mov    %eax,-0x20(%ebp)

				  if (id > -1)
  801b4c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b50:	78 0c                	js     801b5e <smalloc+0x97>
					  return va ;
  801b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b55:	eb 0c                	jmp    801b63 <smalloc+0x9c>
				 }
				 else
					return NULL;
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5c:	eb 05                	jmp    801b63 <smalloc+0x9c>
	  }
		  return NULL ;
  801b5e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY *******************

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b6b:	e8 ec fb ff ff       	call   80175c <InitializeUHeap>

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");

	 uint32 size = sys_getSizeOfSharedObject (ownerEnvID, sharedVarName);
  801b70:	83 ec 08             	sub    $0x8,%esp
  801b73:	ff 75 0c             	pushl  0xc(%ebp)
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 0c 04 00 00       	call   801f8a <sys_getSizeOfSharedObject>
  801b7e:	83 c4 10             	add    $0x10,%esp
  801b81:	89 45 f4             	mov    %eax,-0xc(%ebp)

	 if (size  == E_SHARED_MEM_NOT_EXISTS) return NULL ;
  801b84:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b88:	75 07                	jne    801b91 <sget+0x2c>
  801b8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8f:	eb 75                	jmp    801c06 <sget+0xa1>

	 uint32 newsize = ROUNDUP(size, PAGE_SIZE);
  801b91:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9e:	01 d0                	add    %edx,%eax
  801ba0:	48                   	dec    %eax
  801ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bac:	f7 75 f0             	divl   -0x10(%ebp)
  801baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb2:	29 d0                	sub    %edx,%eax
  801bb4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	 void*va;
     int ret = 0;
  801bb7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

     if (sys_isUHeapPlacementStrategyFIRSTFIT() == 1) {
  801bbe:	e8 18 06 00 00       	call   8021db <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bc3:	83 f8 01             	cmp    $0x1,%eax
  801bc6:	75 39                	jne    801c01 <sget+0x9c>

		  va = malloc(newsize) ;
  801bc8:	83 ec 0c             	sub    $0xc,%esp
  801bcb:	ff 75 e8             	pushl  -0x18(%ebp)
  801bce:	e8 78 fd ff ff       	call   80194b <malloc>
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	89 45 e0             	mov    %eax,-0x20(%ebp)

			  if (va != NULL){
  801bd9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bdd:	74 22                	je     801c01 <sget+0x9c>
				  int id =sys_getSharedObject(ownerEnvID, sharedVarName, va);
  801bdf:	83 ec 04             	sub    $0x4,%esp
  801be2:	ff 75 e0             	pushl  -0x20(%ebp)
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	e8 b7 03 00 00       	call   801fa7 <sys_getSharedObject>
  801bf0:	83 c4 10             	add    $0x10,%esp
  801bf3:	89 45 dc             	mov    %eax,-0x24(%ebp)
				  if (id > -1){
  801bf6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801bfa:	78 05                	js     801c01 <sget+0x9c>
					  return va;
  801bfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bff:	eb 05                	jmp    801c06 <sget+0xa1>
				  }
			  }
     }
         return NULL;
  801c01:	b8 00 00 00 00       	mov    $0x0,%eax
	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy

}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c0e:	e8 49 fb ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c13:	83 ec 04             	sub    $0x4,%esp
  801c16:	68 c4 3e 80 00       	push   $0x803ec4
  801c1b:	68 1e 01 00 00       	push   $0x11e
  801c20:	68 93 3e 80 00       	push   $0x803e93
  801c25:	e8 f4 ea ff ff       	call   80071e <_panic>

00801c2a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	68 ec 3e 80 00       	push   $0x803eec
  801c38:	68 32 01 00 00       	push   $0x132
  801c3d:	68 93 3e 80 00       	push   $0x803e93
  801c42:	e8 d7 ea ff ff       	call   80071e <_panic>

00801c47 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	68 10 3f 80 00       	push   $0x803f10
  801c55:	68 3d 01 00 00       	push   $0x13d
  801c5a:	68 93 3e 80 00       	push   $0x803e93
  801c5f:	e8 ba ea ff ff       	call   80071e <_panic>

00801c64 <shrink>:

}
void shrink(uint32 newSize)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	68 10 3f 80 00       	push   $0x803f10
  801c72:	68 42 01 00 00       	push   $0x142
  801c77:	68 93 3e 80 00       	push   $0x803e93
  801c7c:	e8 9d ea ff ff       	call   80071e <_panic>

00801c81 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c87:	83 ec 04             	sub    $0x4,%esp
  801c8a:	68 10 3f 80 00       	push   $0x803f10
  801c8f:	68 47 01 00 00       	push   $0x147
  801c94:	68 93 3e 80 00       	push   $0x803e93
  801c99:	e8 80 ea ff ff       	call   80071e <_panic>

00801c9e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	57                   	push   %edi
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cb6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cb9:	cd 30                	int    $0x30
  801cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cc1:	83 c4 10             	add    $0x10,%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5e                   	pop    %esi
  801cc6:	5f                   	pop    %edi
  801cc7:	5d                   	pop    %ebp
  801cc8:	c3                   	ret    

00801cc9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 04             	sub    $0x4,%esp
  801ccf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cd5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	52                   	push   %edx
  801ce1:	ff 75 0c             	pushl  0xc(%ebp)
  801ce4:	50                   	push   %eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	e8 b2 ff ff ff       	call   801c9e <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
}
  801cef:	90                   	nop
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 01                	push   $0x1
  801d01:	e8 98 ff ff ff       	call   801c9e <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	52                   	push   %edx
  801d1b:	50                   	push   %eax
  801d1c:	6a 05                	push   $0x5
  801d1e:	e8 7b ff ff ff       	call   801c9e <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	56                   	push   %esi
  801d2c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d2d:	8b 75 18             	mov    0x18(%ebp),%esi
  801d30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	56                   	push   %esi
  801d3d:	53                   	push   %ebx
  801d3e:	51                   	push   %ecx
  801d3f:	52                   	push   %edx
  801d40:	50                   	push   %eax
  801d41:	6a 06                	push   $0x6
  801d43:	e8 56 ff ff ff       	call   801c9e <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
}
  801d4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d4e:	5b                   	pop    %ebx
  801d4f:	5e                   	pop    %esi
  801d50:	5d                   	pop    %ebp
  801d51:	c3                   	ret    

00801d52 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	52                   	push   %edx
  801d62:	50                   	push   %eax
  801d63:	6a 07                	push   $0x7
  801d65:	e8 34 ff ff ff       	call   801c9e <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	ff 75 0c             	pushl  0xc(%ebp)
  801d7b:	ff 75 08             	pushl  0x8(%ebp)
  801d7e:	6a 08                	push   $0x8
  801d80:	e8 19 ff ff ff       	call   801c9e <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 09                	push   $0x9
  801d99:	e8 00 ff ff ff       	call   801c9e <syscall>
  801d9e:	83 c4 18             	add    $0x18,%esp
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 0a                	push   $0xa
  801db2:	e8 e7 fe ff ff       	call   801c9e <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 0b                	push   $0xb
  801dcb:	e8 ce fe ff ff       	call   801c9e <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	ff 75 0c             	pushl  0xc(%ebp)
  801de1:	ff 75 08             	pushl  0x8(%ebp)
  801de4:	6a 0f                	push   $0xf
  801de6:	e8 b3 fe ff ff       	call   801c9e <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
	return;
  801dee:	90                   	nop
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	ff 75 0c             	pushl  0xc(%ebp)
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	6a 10                	push   $0x10
  801e02:	e8 97 fe ff ff       	call   801c9e <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0a:	90                   	nop
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	ff 75 10             	pushl  0x10(%ebp)
  801e17:	ff 75 0c             	pushl  0xc(%ebp)
  801e1a:	ff 75 08             	pushl  0x8(%ebp)
  801e1d:	6a 11                	push   $0x11
  801e1f:	e8 7a fe ff ff       	call   801c9e <syscall>
  801e24:	83 c4 18             	add    $0x18,%esp
	return ;
  801e27:	90                   	nop
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 0c                	push   $0xc
  801e39:	e8 60 fe ff ff       	call   801c9e <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	ff 75 08             	pushl  0x8(%ebp)
  801e51:	6a 0d                	push   $0xd
  801e53:	e8 46 fe ff ff       	call   801c9e <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 0e                	push   $0xe
  801e6c:	e8 2d fe ff ff       	call   801c9e <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
}
  801e74:	90                   	nop
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 13                	push   $0x13
  801e86:	e8 13 fe ff ff       	call   801c9e <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	90                   	nop
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 14                	push   $0x14
  801ea0:	e8 f9 fd ff ff       	call   801c9e <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	90                   	nop
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_cputc>:


void
sys_cputc(const char c)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 04             	sub    $0x4,%esp
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801eb7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	50                   	push   %eax
  801ec4:	6a 15                	push   $0x15
  801ec6:	e8 d3 fd ff ff       	call   801c9e <syscall>
  801ecb:	83 c4 18             	add    $0x18,%esp
}
  801ece:	90                   	nop
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 16                	push   $0x16
  801ee0:	e8 b9 fd ff ff       	call   801c9e <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	90                   	nop
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	ff 75 0c             	pushl  0xc(%ebp)
  801efa:	50                   	push   %eax
  801efb:	6a 17                	push   $0x17
  801efd:	e8 9c fd ff ff       	call   801c9e <syscall>
  801f02:	83 c4 18             	add    $0x18,%esp
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	6a 1a                	push   $0x1a
  801f1a:	e8 7f fd ff ff       	call   801c9e <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	52                   	push   %edx
  801f34:	50                   	push   %eax
  801f35:	6a 18                	push   $0x18
  801f37:	e8 62 fd ff ff       	call   801c9e <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	90                   	nop
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	6a 19                	push   $0x19
  801f55:	e8 44 fd ff ff       	call   801c9e <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	90                   	nop
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 04             	sub    $0x4,%esp
  801f66:	8b 45 10             	mov    0x10(%ebp),%eax
  801f69:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f6c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f6f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	6a 00                	push   $0x0
  801f78:	51                   	push   %ecx
  801f79:	52                   	push   %edx
  801f7a:	ff 75 0c             	pushl  0xc(%ebp)
  801f7d:	50                   	push   %eax
  801f7e:	6a 1b                	push   $0x1b
  801f80:	e8 19 fd ff ff       	call   801c9e <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	52                   	push   %edx
  801f9a:	50                   	push   %eax
  801f9b:	6a 1c                	push   $0x1c
  801f9d:	e8 fc fc ff ff       	call   801c9e <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801faa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	51                   	push   %ecx
  801fb8:	52                   	push   %edx
  801fb9:	50                   	push   %eax
  801fba:	6a 1d                	push   $0x1d
  801fbc:	e8 dd fc ff ff       	call   801c9e <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	52                   	push   %edx
  801fd6:	50                   	push   %eax
  801fd7:	6a 1e                	push   $0x1e
  801fd9:	e8 c0 fc ff ff       	call   801c9e <syscall>
  801fde:	83 c4 18             	add    $0x18,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 1f                	push   $0x1f
  801ff2:	e8 a7 fc ff ff       	call   801c9e <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	6a 00                	push   $0x0
  802004:	ff 75 14             	pushl  0x14(%ebp)
  802007:	ff 75 10             	pushl  0x10(%ebp)
  80200a:	ff 75 0c             	pushl  0xc(%ebp)
  80200d:	50                   	push   %eax
  80200e:	6a 20                	push   $0x20
  802010:	e8 89 fc ff ff       	call   801c9e <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
}
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	50                   	push   %eax
  802029:	6a 21                	push   $0x21
  80202b:	e8 6e fc ff ff       	call   801c9e <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	90                   	nop
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	50                   	push   %eax
  802045:	6a 22                	push   $0x22
  802047:	e8 52 fc ff ff       	call   801c9e <syscall>
  80204c:	83 c4 18             	add    $0x18,%esp
}
  80204f:	c9                   	leave  
  802050:	c3                   	ret    

00802051 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 02                	push   $0x2
  802060:	e8 39 fc ff ff       	call   801c9e <syscall>
  802065:	83 c4 18             	add    $0x18,%esp
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 03                	push   $0x3
  802079:	e8 20 fc ff ff       	call   801c9e <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 04                	push   $0x4
  802092:	e8 07 fc ff ff       	call   801c9e <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <sys_exit_env>:


void sys_exit_env(void)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 23                	push   $0x23
  8020ab:	e8 ee fb ff ff       	call   801c9e <syscall>
  8020b0:	83 c4 18             	add    $0x18,%esp
}
  8020b3:	90                   	nop
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020bc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020bf:	8d 50 04             	lea    0x4(%eax),%edx
  8020c2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	52                   	push   %edx
  8020cc:	50                   	push   %eax
  8020cd:	6a 24                	push   $0x24
  8020cf:	e8 ca fb ff ff       	call   801c9e <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
	return result;
  8020d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020e0:	89 01                	mov    %eax,(%ecx)
  8020e2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	c9                   	leave  
  8020e9:	c2 04 00             	ret    $0x4

008020ec <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	ff 75 10             	pushl  0x10(%ebp)
  8020f6:	ff 75 0c             	pushl  0xc(%ebp)
  8020f9:	ff 75 08             	pushl  0x8(%ebp)
  8020fc:	6a 12                	push   $0x12
  8020fe:	e8 9b fb ff ff       	call   801c9e <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
	return ;
  802106:	90                   	nop
}
  802107:	c9                   	leave  
  802108:	c3                   	ret    

00802109 <sys_rcr2>:
uint32 sys_rcr2()
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 25                	push   $0x25
  802118:	e8 81 fb ff ff       	call   801c9e <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80212e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	50                   	push   %eax
  80213b:	6a 26                	push   $0x26
  80213d:	e8 5c fb ff ff       	call   801c9e <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
	return ;
  802145:	90                   	nop
}
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <rsttst>:
void rsttst()
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 28                	push   $0x28
  802157:	e8 42 fb ff ff       	call   801c9e <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
	return ;
  80215f:	90                   	nop
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	8b 45 14             	mov    0x14(%ebp),%eax
  80216b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80216e:	8b 55 18             	mov    0x18(%ebp),%edx
  802171:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802175:	52                   	push   %edx
  802176:	50                   	push   %eax
  802177:	ff 75 10             	pushl  0x10(%ebp)
  80217a:	ff 75 0c             	pushl  0xc(%ebp)
  80217d:	ff 75 08             	pushl  0x8(%ebp)
  802180:	6a 27                	push   $0x27
  802182:	e8 17 fb ff ff       	call   801c9e <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
	return ;
  80218a:	90                   	nop
}
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <chktst>:
void chktst(uint32 n)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	ff 75 08             	pushl  0x8(%ebp)
  80219b:	6a 29                	push   $0x29
  80219d:	e8 fc fa ff ff       	call   801c9e <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a5:	90                   	nop
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <inctst>:

void inctst()
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 2a                	push   $0x2a
  8021b7:	e8 e2 fa ff ff       	call   801c9e <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021bf:	90                   	nop
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <gettst>:
uint32 gettst()
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 2b                	push   $0x2b
  8021d1:	e8 c8 fa ff ff       	call   801c9e <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 2c                	push   $0x2c
  8021ed:	e8 ac fa ff ff       	call   801c9e <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
  8021f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021f8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021fc:	75 07                	jne    802205 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802203:	eb 05                	jmp    80220a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802205:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 2c                	push   $0x2c
  80221e:	e8 7b fa ff ff       	call   801c9e <syscall>
  802223:	83 c4 18             	add    $0x18,%esp
  802226:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802229:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80222d:	75 07                	jne    802236 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80222f:	b8 01 00 00 00       	mov    $0x1,%eax
  802234:	eb 05                	jmp    80223b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 2c                	push   $0x2c
  80224f:	e8 4a fa ff ff       	call   801c9e <syscall>
  802254:	83 c4 18             	add    $0x18,%esp
  802257:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80225a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80225e:	75 07                	jne    802267 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802260:	b8 01 00 00 00       	mov    $0x1,%eax
  802265:	eb 05                	jmp    80226c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802267:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 2c                	push   $0x2c
  802280:	e8 19 fa ff ff       	call   801c9e <syscall>
  802285:	83 c4 18             	add    $0x18,%esp
  802288:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80228b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80228f:	75 07                	jne    802298 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802291:	b8 01 00 00 00       	mov    $0x1,%eax
  802296:	eb 05                	jmp    80229d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802298:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80229d:	c9                   	leave  
  80229e:	c3                   	ret    

0080229f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	ff 75 08             	pushl  0x8(%ebp)
  8022ad:	6a 2d                	push   $0x2d
  8022af:	e8 ea f9 ff ff       	call   801c9e <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b7:	90                   	nop
}
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	6a 00                	push   $0x0
  8022cc:	53                   	push   %ebx
  8022cd:	51                   	push   %ecx
  8022ce:	52                   	push   %edx
  8022cf:	50                   	push   %eax
  8022d0:	6a 2e                	push   $0x2e
  8022d2:	e8 c7 f9 ff ff       	call   801c9e <syscall>
  8022d7:	83 c4 18             	add    $0x18,%esp
}
  8022da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	52                   	push   %edx
  8022ef:	50                   	push   %eax
  8022f0:	6a 2f                	push   $0x2f
  8022f2:	e8 a7 f9 ff ff       	call   801c9e <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802302:	83 ec 0c             	sub    $0xc,%esp
  802305:	68 20 3f 80 00       	push   $0x803f20
  80230a:	e8 c3 e6 ff ff       	call   8009d2 <cprintf>
  80230f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802312:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802319:	83 ec 0c             	sub    $0xc,%esp
  80231c:	68 4c 3f 80 00       	push   $0x803f4c
  802321:	e8 ac e6 ff ff       	call   8009d2 <cprintf>
  802326:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802329:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80232d:	a1 38 51 80 00       	mov    0x805138,%eax
  802332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802335:	eb 56                	jmp    80238d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802337:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80233b:	74 1c                	je     802359 <print_mem_block_lists+0x5d>
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 50 08             	mov    0x8(%eax),%edx
  802343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802346:	8b 48 08             	mov    0x8(%eax),%ecx
  802349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234c:	8b 40 0c             	mov    0xc(%eax),%eax
  80234f:	01 c8                	add    %ecx,%eax
  802351:	39 c2                	cmp    %eax,%edx
  802353:	73 04                	jae    802359 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802355:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 50 08             	mov    0x8(%eax),%edx
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 40 0c             	mov    0xc(%eax),%eax
  802365:	01 c2                	add    %eax,%edx
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	8b 40 08             	mov    0x8(%eax),%eax
  80236d:	83 ec 04             	sub    $0x4,%esp
  802370:	52                   	push   %edx
  802371:	50                   	push   %eax
  802372:	68 61 3f 80 00       	push   $0x803f61
  802377:	e8 56 e6 ff ff       	call   8009d2 <cprintf>
  80237c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802385:	a1 40 51 80 00       	mov    0x805140,%eax
  80238a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802391:	74 07                	je     80239a <print_mem_block_lists+0x9e>
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	8b 00                	mov    (%eax),%eax
  802398:	eb 05                	jmp    80239f <print_mem_block_lists+0xa3>
  80239a:	b8 00 00 00 00       	mov    $0x0,%eax
  80239f:	a3 40 51 80 00       	mov    %eax,0x805140
  8023a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	75 8a                	jne    802337 <print_mem_block_lists+0x3b>
  8023ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b1:	75 84                	jne    802337 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023b3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023b7:	75 10                	jne    8023c9 <print_mem_block_lists+0xcd>
  8023b9:	83 ec 0c             	sub    $0xc,%esp
  8023bc:	68 70 3f 80 00       	push   $0x803f70
  8023c1:	e8 0c e6 ff ff       	call   8009d2 <cprintf>
  8023c6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023d0:	83 ec 0c             	sub    $0xc,%esp
  8023d3:	68 94 3f 80 00       	push   $0x803f94
  8023d8:	e8 f5 e5 ff ff       	call   8009d2 <cprintf>
  8023dd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023e0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023e4:	a1 40 50 80 00       	mov    0x805040,%eax
  8023e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ec:	eb 56                	jmp    802444 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023f2:	74 1c                	je     802410 <print_mem_block_lists+0x114>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 50 08             	mov    0x8(%eax),%edx
  8023fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fd:	8b 48 08             	mov    0x8(%eax),%ecx
  802400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802403:	8b 40 0c             	mov    0xc(%eax),%eax
  802406:	01 c8                	add    %ecx,%eax
  802408:	39 c2                	cmp    %eax,%edx
  80240a:	73 04                	jae    802410 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80240c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 50 08             	mov    0x8(%eax),%edx
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 40 0c             	mov    0xc(%eax),%eax
  80241c:	01 c2                	add    %eax,%edx
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 40 08             	mov    0x8(%eax),%eax
  802424:	83 ec 04             	sub    $0x4,%esp
  802427:	52                   	push   %edx
  802428:	50                   	push   %eax
  802429:	68 61 3f 80 00       	push   $0x803f61
  80242e:	e8 9f e5 ff ff       	call   8009d2 <cprintf>
  802433:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80243c:	a1 48 50 80 00       	mov    0x805048,%eax
  802441:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802448:	74 07                	je     802451 <print_mem_block_lists+0x155>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 00                	mov    (%eax),%eax
  80244f:	eb 05                	jmp    802456 <print_mem_block_lists+0x15a>
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
  802456:	a3 48 50 80 00       	mov    %eax,0x805048
  80245b:	a1 48 50 80 00       	mov    0x805048,%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	75 8a                	jne    8023ee <print_mem_block_lists+0xf2>
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	75 84                	jne    8023ee <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80246a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80246e:	75 10                	jne    802480 <print_mem_block_lists+0x184>
  802470:	83 ec 0c             	sub    $0xc,%esp
  802473:	68 ac 3f 80 00       	push   $0x803fac
  802478:	e8 55 e5 ff ff       	call   8009d2 <cprintf>
  80247d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802480:	83 ec 0c             	sub    $0xc,%esp
  802483:	68 20 3f 80 00       	push   $0x803f20
  802488:	e8 45 e5 ff ff       	call   8009d2 <cprintf>
  80248d:	83 c4 10             	add    $0x10,%esp

}
  802490:	90                   	nop
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
  802496:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);
  802499:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024a0:	00 00 00 
  8024a3:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024aa:	00 00 00 
  8024ad:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024b4:	00 00 00 


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  8024b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024be:	e9 9e 00 00 00       	jmp    802561 <initialize_MemBlocksList+0xce>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
  8024c3:	a1 50 50 80 00       	mov    0x805050,%eax
  8024c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cb:	c1 e2 04             	shl    $0x4,%edx
  8024ce:	01 d0                	add    %edx,%eax
  8024d0:	85 c0                	test   %eax,%eax
  8024d2:	75 14                	jne    8024e8 <initialize_MemBlocksList+0x55>
  8024d4:	83 ec 04             	sub    $0x4,%esp
  8024d7:	68 d4 3f 80 00       	push   $0x803fd4
  8024dc:	6a 47                	push   $0x47
  8024de:	68 f7 3f 80 00       	push   $0x803ff7
  8024e3:	e8 36 e2 ff ff       	call   80071e <_panic>
  8024e8:	a1 50 50 80 00       	mov    0x805050,%eax
  8024ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f0:	c1 e2 04             	shl    $0x4,%edx
  8024f3:	01 d0                	add    %edx,%eax
  8024f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024fb:	89 10                	mov    %edx,(%eax)
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	85 c0                	test   %eax,%eax
  802501:	74 18                	je     80251b <initialize_MemBlocksList+0x88>
  802503:	a1 48 51 80 00       	mov    0x805148,%eax
  802508:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80250e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802511:	c1 e1 04             	shl    $0x4,%ecx
  802514:	01 ca                	add    %ecx,%edx
  802516:	89 50 04             	mov    %edx,0x4(%eax)
  802519:	eb 12                	jmp    80252d <initialize_MemBlocksList+0x9a>
  80251b:	a1 50 50 80 00       	mov    0x805050,%eax
  802520:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802523:	c1 e2 04             	shl    $0x4,%edx
  802526:	01 d0                	add    %edx,%eax
  802528:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80252d:	a1 50 50 80 00       	mov    0x805050,%eax
  802532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802535:	c1 e2 04             	shl    $0x4,%edx
  802538:	01 d0                	add    %edx,%eax
  80253a:	a3 48 51 80 00       	mov    %eax,0x805148
  80253f:	a1 50 50 80 00       	mov    0x805050,%eax
  802544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802547:	c1 e2 04             	shl    $0x4,%edx
  80254a:	01 d0                	add    %edx,%eax
  80254c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802553:	a1 54 51 80 00       	mov    0x805154,%eax
  802558:	40                   	inc    %eax
  802559:	a3 54 51 80 00       	mov    %eax,0x805154
	//panic("initialize_MemBlocksList() is not implemented yet...!!");

	 LIST_INIT(& AvailableMemBlocksList);


	 for(uint32 i=0 ; i<numOfBlocks ; i++){
  80255e:	ff 45 f4             	incl   -0xc(%ebp)
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	3b 45 08             	cmp    0x8(%ebp),%eax
  802567:	0f 82 56 ff ff ff    	jb     8024c3 <initialize_MemBlocksList+0x30>
	   LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[i]));
	 }


}
  80256d:	90                   	nop
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    

00802570 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	8b 00                	mov    (%eax),%eax
  80257b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80257e:	eb 19                	jmp    802599 <find_block+0x29>
	{
		if(element->sva == va){
  802580:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802583:	8b 40 08             	mov    0x8(%eax),%eax
  802586:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802589:	75 05                	jne    802590 <find_block+0x20>
			 		return element;
  80258b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80258e:	eb 36                	jmp    8025c6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");

	struct MemBlock *element;
	LIST_FOREACH(element, &(*blockList))
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	8b 40 08             	mov    0x8(%eax),%eax
  802596:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80259d:	74 07                	je     8025a6 <find_block+0x36>
  80259f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	eb 05                	jmp    8025ab <find_block+0x3b>
  8025a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ae:	89 42 08             	mov    %eax,0x8(%edx)
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	8b 40 08             	mov    0x8(%eax),%eax
  8025b7:	85 c0                	test   %eax,%eax
  8025b9:	75 c5                	jne    802580 <find_block+0x10>
  8025bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025bf:	75 bf                	jne    802580 <find_block+0x10>
		if(element->sva == va){
			 		return element;
			 	}
	}

	return NULL;
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	  struct MemBlock *element;
	  struct MemBlock* lastElement = LIST_LAST(&AllocMemBlocksList);
  8025ce:	a1 44 50 80 00       	mov    0x805044,%eax
  8025d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  int size=LIST_SIZE(&AllocMemBlocksList);
  8025d6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  if((size==0)||(blockToInsert->sva==0)){
  8025de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025e2:	74 0a                	je     8025ee <insert_sorted_allocList+0x26>
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	8b 40 08             	mov    0x8(%eax),%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	75 65                	jne    802653 <insert_sorted_allocList+0x8b>
	    LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8025ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f2:	75 14                	jne    802608 <insert_sorted_allocList+0x40>
  8025f4:	83 ec 04             	sub    $0x4,%esp
  8025f7:	68 d4 3f 80 00       	push   $0x803fd4
  8025fc:	6a 6e                	push   $0x6e
  8025fe:	68 f7 3f 80 00       	push   $0x803ff7
  802603:	e8 16 e1 ff ff       	call   80071e <_panic>
  802608:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80260e:	8b 45 08             	mov    0x8(%ebp),%eax
  802611:	89 10                	mov    %edx,(%eax)
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	85 c0                	test   %eax,%eax
  80261a:	74 0d                	je     802629 <insert_sorted_allocList+0x61>
  80261c:	a1 40 50 80 00       	mov    0x805040,%eax
  802621:	8b 55 08             	mov    0x8(%ebp),%edx
  802624:	89 50 04             	mov    %edx,0x4(%eax)
  802627:	eb 08                	jmp    802631 <insert_sorted_allocList+0x69>
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	a3 44 50 80 00       	mov    %eax,0x805044
  802631:	8b 45 08             	mov    0x8(%ebp),%eax
  802634:	a3 40 50 80 00       	mov    %eax,0x805040
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802643:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802648:	40                   	inc    %eax
  802649:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80264e:	e9 cf 01 00 00       	jmp    802822 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	8b 50 08             	mov    0x8(%eax),%edx
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	8b 40 08             	mov    0x8(%eax),%eax
  80265f:	39 c2                	cmp    %eax,%edx
  802661:	73 65                	jae    8026c8 <insert_sorted_allocList+0x100>
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802663:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802667:	75 14                	jne    80267d <insert_sorted_allocList+0xb5>
  802669:	83 ec 04             	sub    $0x4,%esp
  80266c:	68 10 40 80 00       	push   $0x804010
  802671:	6a 72                	push   $0x72
  802673:	68 f7 3f 80 00       	push   $0x803ff7
  802678:	e8 a1 e0 ff ff       	call   80071e <_panic>
  80267d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	89 50 04             	mov    %edx,0x4(%eax)
  802689:	8b 45 08             	mov    0x8(%ebp),%eax
  80268c:	8b 40 04             	mov    0x4(%eax),%eax
  80268f:	85 c0                	test   %eax,%eax
  802691:	74 0c                	je     80269f <insert_sorted_allocList+0xd7>
  802693:	a1 44 50 80 00       	mov    0x805044,%eax
  802698:	8b 55 08             	mov    0x8(%ebp),%edx
  80269b:	89 10                	mov    %edx,(%eax)
  80269d:	eb 08                	jmp    8026a7 <insert_sorted_allocList+0xdf>
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	a3 40 50 80 00       	mov    %eax,0x805040
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	a3 44 50 80 00       	mov    %eax,0x805044
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026bd:	40                   	inc    %eax
  8026be:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  8026c3:	e9 5a 01 00 00       	jmp    802822 <insert_sorted_allocList+0x25a>

	  }
	  else if((lastElement->sva)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
	  }
	   else if((lastElement->sva)==(blockToInsert->sva)){
  8026c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cb:	8b 50 08             	mov    0x8(%eax),%edx
  8026ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d1:	8b 40 08             	mov    0x8(%eax),%eax
  8026d4:	39 c2                	cmp    %eax,%edx
  8026d6:	75 70                	jne    802748 <insert_sorted_allocList+0x180>
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
  8026d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026dc:	74 06                	je     8026e4 <insert_sorted_allocList+0x11c>
  8026de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026e2:	75 14                	jne    8026f8 <insert_sorted_allocList+0x130>
  8026e4:	83 ec 04             	sub    $0x4,%esp
  8026e7:	68 34 40 80 00       	push   $0x804034
  8026ec:	6a 75                	push   $0x75
  8026ee:	68 f7 3f 80 00       	push   $0x803ff7
  8026f3:	e8 26 e0 ff ff       	call   80071e <_panic>
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fb:	8b 10                	mov    (%eax),%edx
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	89 10                	mov    %edx,(%eax)
  802702:	8b 45 08             	mov    0x8(%ebp),%eax
  802705:	8b 00                	mov    (%eax),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	74 0b                	je     802716 <insert_sorted_allocList+0x14e>
  80270b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	8b 55 08             	mov    0x8(%ebp),%edx
  802713:	89 50 04             	mov    %edx,0x4(%eax)
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	8b 55 08             	mov    0x8(%ebp),%edx
  80271c:	89 10                	mov    %edx,(%eax)
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802724:	89 50 04             	mov    %edx,0x4(%eax)
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	8b 00                	mov    (%eax),%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	75 08                	jne    802738 <insert_sorted_allocList+0x170>
  802730:	8b 45 08             	mov    0x8(%ebp),%eax
  802733:	a3 44 50 80 00       	mov    %eax,0x805044
  802738:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80273d:	40                   	inc    %eax
  80273e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
			  }
	    }
	  }

}
  802743:	e9 da 00 00 00       	jmp    802822 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  802748:	a1 40 50 80 00       	mov    0x805040,%eax
  80274d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802750:	e9 9d 00 00 00       	jmp    8027f2 <insert_sorted_allocList+0x22a>
			  nextElement = element->prev_next_info.le_next;//LIST_NEXT(element);
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 00                	mov    (%eax),%eax
  80275a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  if((blockToInsert->sva)>(element->sva)&&((blockToInsert->sva)<(nextElement->sva))){
  80275d:	8b 45 08             	mov    0x8(%ebp),%eax
  802760:	8b 50 08             	mov    0x8(%eax),%edx
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 40 08             	mov    0x8(%eax),%eax
  802769:	39 c2                	cmp    %eax,%edx
  80276b:	76 7d                	jbe    8027ea <insert_sorted_allocList+0x222>
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	8b 50 08             	mov    0x8(%eax),%edx
  802773:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802776:	8b 40 08             	mov    0x8(%eax),%eax
  802779:	39 c2                	cmp    %eax,%edx
  80277b:	73 6d                	jae    8027ea <insert_sorted_allocList+0x222>
				LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80277d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802781:	74 06                	je     802789 <insert_sorted_allocList+0x1c1>
  802783:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802787:	75 14                	jne    80279d <insert_sorted_allocList+0x1d5>
  802789:	83 ec 04             	sub    $0x4,%esp
  80278c:	68 34 40 80 00       	push   $0x804034
  802791:	6a 7c                	push   $0x7c
  802793:	68 f7 3f 80 00       	push   $0x803ff7
  802798:	e8 81 df ff ff       	call   80071e <_panic>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 10                	mov    (%eax),%edx
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	89 10                	mov    %edx,(%eax)
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	74 0b                	je     8027bb <insert_sorted_allocList+0x1f3>
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 00                	mov    (%eax),%eax
  8027b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b8:	89 50 04             	mov    %edx,0x4(%eax)
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c1:	89 10                	mov    %edx,(%eax)
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c9:	89 50 04             	mov    %edx,0x4(%eax)
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	85 c0                	test   %eax,%eax
  8027d3:	75 08                	jne    8027dd <insert_sorted_allocList+0x215>
  8027d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d8:	a3 44 50 80 00       	mov    %eax,0x805044
  8027dd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027e2:	40                   	inc    %eax
  8027e3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8027e8:	eb 38                	jmp    802822 <insert_sorted_allocList+0x25a>
	   else if((lastElement->sva)==(blockToInsert->sva)){
	    LIST_INSERT_AFTER(&AllocMemBlocksList,lastElement,blockToInsert);
	  }
	  else{
	      struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(AllocMemBlocksList)){
  8027ea:	a1 48 50 80 00       	mov    0x805048,%eax
  8027ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f6:	74 07                	je     8027ff <insert_sorted_allocList+0x237>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	eb 05                	jmp    802804 <insert_sorted_allocList+0x23c>
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802804:	a3 48 50 80 00       	mov    %eax,0x805048
  802809:	a1 48 50 80 00       	mov    0x805048,%eax
  80280e:	85 c0                	test   %eax,%eax
  802810:	0f 85 3f ff ff ff    	jne    802755 <insert_sorted_allocList+0x18d>
  802816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281a:	0f 85 35 ff ff ff    	jne    802755 <insert_sorted_allocList+0x18d>
				break;
			  }
	    }
	  }

}
  802820:	eb 00                	jmp    802822 <insert_sorted_allocList+0x25a>
  802822:	90                   	nop
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 18             	sub    $0x18,%esp
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  80282b:	a1 38 51 80 00       	mov    0x805138,%eax
  802830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802833:	e9 6b 02 00 00       	jmp    802aa3 <alloc_block_FF+0x27e>
	  if((element->size)==(size)){
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 40 0c             	mov    0xc(%eax),%eax
  80283e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802841:	0f 85 90 00 00 00    	jne    8028d7 <alloc_block_FF+0xb2>
			  temp=element;
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			  LIST_REMOVE(&(FreeMemBlocksList) ,element);
  80284d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802851:	75 17                	jne    80286a <alloc_block_FF+0x45>
  802853:	83 ec 04             	sub    $0x4,%esp
  802856:	68 68 40 80 00       	push   $0x804068
  80285b:	68 92 00 00 00       	push   $0x92
  802860:	68 f7 3f 80 00       	push   $0x803ff7
  802865:	e8 b4 de ff ff       	call   80071e <_panic>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	85 c0                	test   %eax,%eax
  802871:	74 10                	je     802883 <alloc_block_FF+0x5e>
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 00                	mov    (%eax),%eax
  802878:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287b:	8b 52 04             	mov    0x4(%edx),%edx
  80287e:	89 50 04             	mov    %edx,0x4(%eax)
  802881:	eb 0b                	jmp    80288e <alloc_block_FF+0x69>
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 40 04             	mov    0x4(%eax),%eax
  802889:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 40 04             	mov    0x4(%eax),%eax
  802894:	85 c0                	test   %eax,%eax
  802896:	74 0f                	je     8028a7 <alloc_block_FF+0x82>
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 40 04             	mov    0x4(%eax),%eax
  80289e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a1:	8b 12                	mov    (%edx),%edx
  8028a3:	89 10                	mov    %edx,(%eax)
  8028a5:	eb 0a                	jmp    8028b1 <alloc_block_FF+0x8c>
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 00                	mov    (%eax),%eax
  8028ac:	a3 38 51 80 00       	mov    %eax,0x805138
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c4:	a1 44 51 80 00       	mov    0x805144,%eax
  8028c9:	48                   	dec    %eax
  8028ca:	a3 44 51 80 00       	mov    %eax,0x805144
			  return temp;
  8028cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d2:	e9 ff 01 00 00       	jmp    802ad6 <alloc_block_FF+0x2b1>
		}
	   else if ((element->size)>(size)){
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 40 0c             	mov    0xc(%eax),%eax
  8028dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e0:	0f 86 b5 01 00 00    	jbe    802a9b <alloc_block_FF+0x276>
		  uint32 new_size = (element->size)-(size);
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  // get new block from AvailableMemBlocksList
		  struct MemBlock *new_block=LIST_FIRST(&AvailableMemBlocksList);
  8028f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8028f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		  LIST_REMOVE(&AvailableMemBlocksList ,new_block);
  8028fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028fe:	75 17                	jne    802917 <alloc_block_FF+0xf2>
  802900:	83 ec 04             	sub    $0x4,%esp
  802903:	68 68 40 80 00       	push   $0x804068
  802908:	68 99 00 00 00       	push   $0x99
  80290d:	68 f7 3f 80 00       	push   $0x803ff7
  802912:	e8 07 de ff ff       	call   80071e <_panic>
  802917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291a:	8b 00                	mov    (%eax),%eax
  80291c:	85 c0                	test   %eax,%eax
  80291e:	74 10                	je     802930 <alloc_block_FF+0x10b>
  802920:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802928:	8b 52 04             	mov    0x4(%edx),%edx
  80292b:	89 50 04             	mov    %edx,0x4(%eax)
  80292e:	eb 0b                	jmp    80293b <alloc_block_FF+0x116>
  802930:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802933:	8b 40 04             	mov    0x4(%eax),%eax
  802936:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80293b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	74 0f                	je     802954 <alloc_block_FF+0x12f>
  802945:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80294e:	8b 12                	mov    (%edx),%edx
  802950:	89 10                	mov    %edx,(%eax)
  802952:	eb 0a                	jmp    80295e <alloc_block_FF+0x139>
  802954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	a3 48 51 80 00       	mov    %eax,0x805148
  80295e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802961:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802971:	a1 54 51 80 00       	mov    0x805154,%eax
  802976:	48                   	dec    %eax
  802977:	a3 54 51 80 00       	mov    %eax,0x805154
		  LIST_INSERT_TAIL(&(FreeMemBlocksList) ,new_block);
  80297c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802980:	75 17                	jne    802999 <alloc_block_FF+0x174>
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	68 10 40 80 00       	push   $0x804010
  80298a:	68 9a 00 00 00       	push   $0x9a
  80298f:	68 f7 3f 80 00       	push   $0x803ff7
  802994:	e8 85 dd ff ff       	call   80071e <_panic>
  802999:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	89 50 04             	mov    %edx,0x4(%eax)
  8029a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a8:	8b 40 04             	mov    0x4(%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 0c                	je     8029bb <alloc_block_FF+0x196>
  8029af:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8029b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b7:	89 10                	mov    %edx,(%eax)
  8029b9:	eb 08                	jmp    8029c3 <alloc_block_FF+0x19e>
  8029bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029be:	a3 38 51 80 00       	mov    %eax,0x805138
  8029c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8029d9:	40                   	inc    %eax
  8029da:	a3 44 51 80 00       	mov    %eax,0x805144
		  // setting the size & sva
		  new_block->size=size;
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e5:	89 50 0c             	mov    %edx,0xc(%eax)
		  new_block->sva=element->sva;
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 50 08             	mov    0x8(%eax),%edx
  8029ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f1:	89 50 08             	mov    %edx,0x8(%eax)
		  //update size in list
		  element->size=new_size;
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029fa:	89 50 0c             	mov    %edx,0xc(%eax)
		  element->sva=(element->sva)+ size;
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 50 08             	mov    0x8(%eax),%edx
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	01 c2                	add    %eax,%edx
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	89 50 08             	mov    %edx,0x8(%eax)
		  temp=new_block;
  802a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a11:	89 45 e8             	mov    %eax,-0x18(%ebp)
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
  802a14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a18:	75 17                	jne    802a31 <alloc_block_FF+0x20c>
  802a1a:	83 ec 04             	sub    $0x4,%esp
  802a1d:	68 68 40 80 00       	push   $0x804068
  802a22:	68 a2 00 00 00       	push   $0xa2
  802a27:	68 f7 3f 80 00       	push   $0x803ff7
  802a2c:	e8 ed dc ff ff       	call   80071e <_panic>
  802a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 10                	je     802a4a <alloc_block_FF+0x225>
  802a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a42:	8b 52 04             	mov    0x4(%edx),%edx
  802a45:	89 50 04             	mov    %edx,0x4(%eax)
  802a48:	eb 0b                	jmp    802a55 <alloc_block_FF+0x230>
  802a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	74 0f                	je     802a6e <alloc_block_FF+0x249>
  802a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a62:	8b 40 04             	mov    0x4(%eax),%eax
  802a65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a68:	8b 12                	mov    (%edx),%edx
  802a6a:	89 10                	mov    %edx,(%eax)
  802a6c:	eb 0a                	jmp    802a78 <alloc_block_FF+0x253>
  802a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	a3 38 51 80 00       	mov    %eax,0x805138
  802a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8b:	a1 44 51 80 00       	mov    0x805144,%eax
  802a90:	48                   	dec    %eax
  802a91:	a3 44 51 80 00       	mov    %eax,0x805144
		  return temp;
  802a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a99:	eb 3b                	jmp    802ad6 <alloc_block_FF+0x2b1>
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_FF() is not implemented yet...!!");

	  struct MemBlock *temp;
	  struct MemBlock *element;
	  LIST_FOREACH(element, &(FreeMemBlocksList)){
  802a9b:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa7:	74 07                	je     802ab0 <alloc_block_FF+0x28b>
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	eb 05                	jmp    802ab5 <alloc_block_FF+0x290>
  802ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab5:	a3 40 51 80 00       	mov    %eax,0x805140
  802aba:	a1 40 51 80 00       	mov    0x805140,%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	0f 85 71 fd ff ff    	jne    802838 <alloc_block_FF+0x13>
  802ac7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acb:	0f 85 67 fd ff ff    	jne    802838 <alloc_block_FF+0x13>
		  temp=new_block;
		  LIST_REMOVE(&(FreeMemBlocksList) ,new_block);
		  return temp;
		}
	  }
	  return NULL;
  802ad1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ad6:	c9                   	leave  
  802ad7:	c3                   	ret    

00802ad8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
  802adb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	//panic("alloc_block_BF() is not implemented yet...!!");

	 int suitable = 0;
  802ade:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
  802ae5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802aec:	a1 38 51 80 00       	mov    0x805138,%eax
  802af1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802af4:	e9 d3 00 00 00       	jmp    802bcc <alloc_block_BF+0xf4>
	 {
	  if ((element->size) == (size)) {
  802af9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afc:	8b 40 0c             	mov    0xc(%eax),%eax
  802aff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b02:	0f 85 90 00 00 00    	jne    802b98 <alloc_block_BF+0xc0>
	   temp = element;
  802b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
	   LIST_REMOVE(&(FreeMemBlocksList), element);
  802b0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b12:	75 17                	jne    802b2b <alloc_block_BF+0x53>
  802b14:	83 ec 04             	sub    $0x4,%esp
  802b17:	68 68 40 80 00       	push   $0x804068
  802b1c:	68 bd 00 00 00       	push   $0xbd
  802b21:	68 f7 3f 80 00       	push   $0x803ff7
  802b26:	e8 f3 db ff ff       	call   80071e <_panic>
  802b2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	85 c0                	test   %eax,%eax
  802b32:	74 10                	je     802b44 <alloc_block_BF+0x6c>
  802b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b37:	8b 00                	mov    (%eax),%eax
  802b39:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b3c:	8b 52 04             	mov    0x4(%edx),%edx
  802b3f:	89 50 04             	mov    %edx,0x4(%eax)
  802b42:	eb 0b                	jmp    802b4f <alloc_block_BF+0x77>
  802b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b47:	8b 40 04             	mov    0x4(%eax),%eax
  802b4a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b52:	8b 40 04             	mov    0x4(%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 0f                	je     802b68 <alloc_block_BF+0x90>
  802b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5c:	8b 40 04             	mov    0x4(%eax),%eax
  802b5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b62:	8b 12                	mov    (%edx),%edx
  802b64:	89 10                	mov    %edx,(%eax)
  802b66:	eb 0a                	jmp    802b72 <alloc_block_BF+0x9a>
  802b68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	a3 38 51 80 00       	mov    %eax,0x805138
  802b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b85:	a1 44 51 80 00       	mov    0x805144,%eax
  802b8a:	48                   	dec    %eax
  802b8b:	a3 44 51 80 00       	mov    %eax,0x805144
	   return temp;
  802b90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b93:	e9 41 01 00 00       	jmp    802cd9 <alloc_block_BF+0x201>
	  }
	  else if ((element->size) > (size))
  802b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba1:	76 21                	jbe    802bc4 <alloc_block_BF+0xec>
	  {
	   if (element->size < big_size  )
  802ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bac:	73 16                	jae    802bc4 <alloc_block_BF+0xec>
	   { // new var
	    //update new var
	    big_size=element->size;
  802bae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    ptr = element;
  802bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bba:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    suitable =1;
  802bbd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	 uint32 big_size= (4294967295);//(4*1024*1024*1024)-1
	 struct MemBlock *temp;
	 struct MemBlock *ptr;//= LIST_FIRST(&(FreeMemBlocksList));
	// new var as intial size
	 struct MemBlock *element;
	 LIST_FOREACH(element, &(FreeMemBlocksList))
  802bc4:	a1 40 51 80 00       	mov    0x805140,%eax
  802bc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802bcc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bd0:	74 07                	je     802bd9 <alloc_block_BF+0x101>
  802bd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	eb 05                	jmp    802bde <alloc_block_BF+0x106>
  802bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bde:	a3 40 51 80 00       	mov    %eax,0x805140
  802be3:	a1 40 51 80 00       	mov    0x805140,%eax
  802be8:	85 c0                	test   %eax,%eax
  802bea:	0f 85 09 ff ff ff    	jne    802af9 <alloc_block_BF+0x21>
  802bf0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802bf4:	0f 85 ff fe ff ff    	jne    802af9 <alloc_block_BF+0x21>
	    suitable =1;
	   }
	  }
	 }

	 if (suitable == 1)
  802bfa:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
  802bfe:	0f 85 d0 00 00 00    	jne    802cd4 <alloc_block_BF+0x1fc>
	 {
	  uint32 new_size = (ptr->size) - (size);
  802c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c07:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0a:	2b 45 08             	sub    0x8(%ebp),%eax
  802c0d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	  // get new block from AvailableMemBlocksList
	  struct MemBlock *new_block = LIST_FIRST(&AvailableMemBlocksList);
  802c10:	a1 48 51 80 00       	mov    0x805148,%eax
  802c15:	89 45 e0             	mov    %eax,-0x20(%ebp)
	  LIST_REMOVE(&AvailableMemBlocksList, new_block);
  802c18:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c1c:	75 17                	jne    802c35 <alloc_block_BF+0x15d>
  802c1e:	83 ec 04             	sub    $0x4,%esp
  802c21:	68 68 40 80 00       	push   $0x804068
  802c26:	68 d1 00 00 00       	push   $0xd1
  802c2b:	68 f7 3f 80 00       	push   $0x803ff7
  802c30:	e8 e9 da ff ff       	call   80071e <_panic>
  802c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	74 10                	je     802c4e <alloc_block_BF+0x176>
  802c3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c46:	8b 52 04             	mov    0x4(%edx),%edx
  802c49:	89 50 04             	mov    %edx,0x4(%eax)
  802c4c:	eb 0b                	jmp    802c59 <alloc_block_BF+0x181>
  802c4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c51:	8b 40 04             	mov    0x4(%eax),%eax
  802c54:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5c:	8b 40 04             	mov    0x4(%eax),%eax
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	74 0f                	je     802c72 <alloc_block_BF+0x19a>
  802c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c66:	8b 40 04             	mov    0x4(%eax),%eax
  802c69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c6c:	8b 12                	mov    (%edx),%edx
  802c6e:	89 10                	mov    %edx,(%eax)
  802c70:	eb 0a                	jmp    802c7c <alloc_block_BF+0x1a4>
  802c72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	a3 48 51 80 00       	mov    %eax,0x805148
  802c7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8f:	a1 54 51 80 00       	mov    0x805154,%eax
  802c94:	48                   	dec    %eax
  802c95:	a3 54 51 80 00       	mov    %eax,0x805154
	  // setting the size & sva
	  new_block->size = size;
  802c9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca0:	89 50 0c             	mov    %edx,0xc(%eax)
	  new_block->sva = ptr->sva;
  802ca3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca6:	8b 50 08             	mov    0x8(%eax),%edx
  802ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cac:	89 50 08             	mov    %edx,0x8(%eax)
	  //update size in list
	  ptr->size = new_size;
  802caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cb5:	89 50 0c             	mov    %edx,0xc(%eax)
	  ptr->sva += size;
  802cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbb:	8b 50 08             	mov    0x8(%eax),%edx
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	01 c2                	add    %eax,%edx
  802cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc6:	89 50 08             	mov    %edx,0x8(%eax)
	  temp = new_block;
  802cc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ccc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	  return temp;
  802ccf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cd2:	eb 05                	jmp    802cd9 <alloc_block_BF+0x201>
	 }
	 return NULL;
  802cd4:	b8 00 00 00 00       	mov    $0x0,%eax


}
  802cd9:	c9                   	leave  
  802cda:	c3                   	ret    

00802cdb <alloc_block_NF>:

//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
  802cde:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802ce1:	83 ec 04             	sub    $0x4,%esp
  802ce4:	68 88 40 80 00       	push   $0x804088
  802ce9:	68 e8 00 00 00       	push   $0xe8
  802cee:	68 f7 3f 80 00       	push   $0x803ff7
  802cf3:	e8 26 da ff ff       	call   80071e <_panic>

00802cf8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
  802cfb:	83 ec 28             	sub    $0x28,%esp
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	  struct MemBlock* lastElement = LIST_LAST(&FreeMemBlocksList);
  802cfe:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	  struct MemBlock* firstElement = LIST_FIRST(&FreeMemBlocksList);
  802d06:	a1 38 51 80 00       	mov    0x805138,%eax
  802d0b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  struct MemBlock *element;
	  int size=LIST_SIZE(&FreeMemBlocksList);
  802d0e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d13:	89 45 e8             	mov    %eax,-0x18(%ebp)
	  //(LIST_EMPTY(&FreeMemBlocksList))
	  //empty list
	  if(size==0){
  802d16:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d1a:	75 68                	jne    802d84 <insert_sorted_with_merge_freeList+0x8c>
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d20:	75 17                	jne    802d39 <insert_sorted_with_merge_freeList+0x41>
  802d22:	83 ec 04             	sub    $0x4,%esp
  802d25:	68 d4 3f 80 00       	push   $0x803fd4
  802d2a:	68 36 01 00 00       	push   $0x136
  802d2f:	68 f7 3f 80 00       	push   $0x803ff7
  802d34:	e8 e5 d9 ff ff       	call   80071e <_panic>
  802d39:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	89 10                	mov    %edx,(%eax)
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	8b 00                	mov    (%eax),%eax
  802d49:	85 c0                	test   %eax,%eax
  802d4b:	74 0d                	je     802d5a <insert_sorted_with_merge_freeList+0x62>
  802d4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d52:	8b 55 08             	mov    0x8(%ebp),%edx
  802d55:	89 50 04             	mov    %edx,0x4(%eax)
  802d58:	eb 08                	jmp    802d62 <insert_sorted_with_merge_freeList+0x6a>
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	a3 38 51 80 00       	mov    %eax,0x805138
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d74:	a1 44 51 80 00       	mov    0x805144,%eax
  802d79:	40                   	inc    %eax
  802d7a:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802d7f:	e9 ba 06 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
	  //empty list
	  if(size==0){
	    LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	8b 50 08             	mov    0x8(%eax),%edx
  802d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d90:	01 c2                	add    %eax,%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	8b 40 08             	mov    0x8(%eax),%eax
  802d98:	39 c2                	cmp    %eax,%edx
  802d9a:	73 68                	jae    802e04 <insert_sorted_with_merge_freeList+0x10c>
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da0:	75 17                	jne    802db9 <insert_sorted_with_merge_freeList+0xc1>
  802da2:	83 ec 04             	sub    $0x4,%esp
  802da5:	68 10 40 80 00       	push   $0x804010
  802daa:	68 3a 01 00 00       	push   $0x13a
  802daf:	68 f7 3f 80 00       	push   $0x803ff7
  802db4:	e8 65 d9 ff ff       	call   80071e <_panic>
  802db9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	89 50 04             	mov    %edx,0x4(%eax)
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	8b 40 04             	mov    0x4(%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0c                	je     802ddb <insert_sorted_with_merge_freeList+0xe3>
  802dcf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd7:	89 10                	mov    %edx,(%eax)
  802dd9:	eb 08                	jmp    802de3 <insert_sorted_with_merge_freeList+0xeb>
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	a3 38 51 80 00       	mov    %eax,0x805138
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df4:	a1 44 51 80 00       	mov    0x805144,%eax
  802df9:	40                   	inc    %eax
  802dfa:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802dff:	e9 3a 06 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
	  //insert blockToInsert before first block without merge
	  else if((lastElement->sva + lastElement->size)<(blockToInsert->sva)){
	    LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
	  }
	  //merge with last block
	  else if((lastElement->sva + lastElement->size)==(blockToInsert->sva)){
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	8b 50 08             	mov    0x8(%eax),%edx
  802e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e10:	01 c2                	add    %eax,%edx
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	8b 40 08             	mov    0x8(%eax),%eax
  802e18:	39 c2                	cmp    %eax,%edx
  802e1a:	0f 85 90 00 00 00    	jne    802eb0 <insert_sorted_with_merge_freeList+0x1b8>
	    lastElement->size+=blockToInsert->size;
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	8b 50 0c             	mov    0xc(%eax),%edx
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2c:	01 c2                	add    %eax,%edx
  802e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e31:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva=0;
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size=0;
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4c:	75 17                	jne    802e65 <insert_sorted_with_merge_freeList+0x16d>
  802e4e:	83 ec 04             	sub    $0x4,%esp
  802e51:	68 d4 3f 80 00       	push   $0x803fd4
  802e56:	68 41 01 00 00       	push   $0x141
  802e5b:	68 f7 3f 80 00       	push   $0x803ff7
  802e60:	e8 b9 d8 ff ff       	call   80071e <_panic>
  802e65:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	89 10                	mov    %edx,(%eax)
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	74 0d                	je     802e86 <insert_sorted_with_merge_freeList+0x18e>
  802e79:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e81:	89 50 04             	mov    %edx,0x4(%eax)
  802e84:	eb 08                	jmp    802e8e <insert_sorted_with_merge_freeList+0x196>
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	a3 48 51 80 00       	mov    %eax,0x805148
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea0:	a1 54 51 80 00       	mov    0x805154,%eax
  802ea5:	40                   	inc    %eax
  802ea6:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802eab:	e9 8e 05 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
	    blockToInsert->sva=0;
	    blockToInsert->size=0;
	    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 50 08             	mov    0x8(%eax),%edx
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebc:	01 c2                	add    %eax,%edx
  802ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec1:	8b 40 08             	mov    0x8(%eax),%eax
  802ec4:	39 c2                	cmp    %eax,%edx
  802ec6:	73 68                	jae    802f30 <insert_sorted_with_merge_freeList+0x238>
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ec8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecc:	75 17                	jne    802ee5 <insert_sorted_with_merge_freeList+0x1ed>
  802ece:	83 ec 04             	sub    $0x4,%esp
  802ed1:	68 d4 3f 80 00       	push   $0x803fd4
  802ed6:	68 45 01 00 00       	push   $0x145
  802edb:	68 f7 3f 80 00       	push   $0x803ff7
  802ee0:	e8 39 d8 ff ff       	call   80071e <_panic>
  802ee5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	89 10                	mov    %edx,(%eax)
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	74 0d                	je     802f06 <insert_sorted_with_merge_freeList+0x20e>
  802ef9:	a1 38 51 80 00       	mov    0x805138,%eax
  802efe:	8b 55 08             	mov    0x8(%ebp),%edx
  802f01:	89 50 04             	mov    %edx,0x4(%eax)
  802f04:	eb 08                	jmp    802f0e <insert_sorted_with_merge_freeList+0x216>
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	a3 38 51 80 00       	mov    %eax,0x805138
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f20:	a1 44 51 80 00       	mov    0x805144,%eax
  802f25:	40                   	inc    %eax
  802f26:	a3 44 51 80 00       	mov    %eax,0x805144





}
  802f2b:	e9 0e 05 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
	  }
	  //insert blockToInsert before first block without merge
	  else if((blockToInsert->sva +blockToInsert->size)<(firstElement->sva)){
	      LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
	  }
	  else if((blockToInsert->sva + blockToInsert->size)==(firstElement->sva)){
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	8b 50 08             	mov    0x8(%eax),%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3c:	01 c2                	add    %eax,%edx
  802f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f41:	8b 40 08             	mov    0x8(%eax),%eax
  802f44:	39 c2                	cmp    %eax,%edx
  802f46:	0f 85 9c 00 00 00    	jne    802fe8 <insert_sorted_with_merge_freeList+0x2f0>
	     //merge with first block
	    firstElement->size+=blockToInsert->size;
  802f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 40 0c             	mov    0xc(%eax),%eax
  802f58:	01 c2                	add    %eax,%edx
  802f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5d:	89 50 0c             	mov    %edx,0xc(%eax)
	    firstElement->sva=blockToInsert->sva;
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 50 08             	mov    0x8(%eax),%edx
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	89 50 08             	mov    %edx,0x8(%eax)
	     blockToInsert->sva=0;
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	     blockToInsert->size=0;
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f84:	75 17                	jne    802f9d <insert_sorted_with_merge_freeList+0x2a5>
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	68 d4 3f 80 00       	push   $0x803fd4
  802f8e:	68 4d 01 00 00       	push   $0x14d
  802f93:	68 f7 3f 80 00       	push   $0x803ff7
  802f98:	e8 81 d7 ff ff       	call   80071e <_panic>
  802f9d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	89 10                	mov    %edx,(%eax)
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	74 0d                	je     802fbe <insert_sorted_with_merge_freeList+0x2c6>
  802fb1:	a1 48 51 80 00       	mov    0x805148,%eax
  802fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb9:	89 50 04             	mov    %edx,0x4(%eax)
  802fbc:	eb 08                	jmp    802fc6 <insert_sorted_with_merge_freeList+0x2ce>
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	a3 48 51 80 00       	mov    %eax,0x805148
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd8:	a1 54 51 80 00       	mov    0x805154,%eax
  802fdd:	40                   	inc    %eax
  802fde:	a3 54 51 80 00       	mov    %eax,0x805154





}
  802fe3:	e9 56 04 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  802fe8:	a1 38 51 80 00       	mov    0x805138,%eax
  802fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff0:	e9 19 04 00 00       	jmp    80340e <insert_sorted_with_merge_freeList+0x716>
	      struct MemBlock* nextElement =LIST_NEXT(element); //element->prev_next_info.le_next;
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	      //merge with previous and next
	      if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  802ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803000:	8b 50 08             	mov    0x8(%eax),%edx
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 40 0c             	mov    0xc(%eax),%eax
  803009:	01 c2                	add    %eax,%edx
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	8b 40 08             	mov    0x8(%eax),%eax
  803011:	39 c2                	cmp    %eax,%edx
  803013:	0f 85 ad 01 00 00    	jne    8031c6 <insert_sorted_with_merge_freeList+0x4ce>
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	8b 50 08             	mov    0x8(%eax),%edx
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	8b 40 0c             	mov    0xc(%eax),%eax
  803025:	01 c2                	add    %eax,%edx
  803027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302a:	8b 40 08             	mov    0x8(%eax),%eax
  80302d:	39 c2                	cmp    %eax,%edx
  80302f:	0f 85 91 01 00 00    	jne    8031c6 <insert_sorted_with_merge_freeList+0x4ce>
	        //merge element and blockToInsert and nextElement
	        element->size += blockToInsert->size +nextElement->size;
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 50 0c             	mov    0xc(%eax),%edx
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	8b 48 0c             	mov    0xc(%eax),%ecx
  803041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803044:	8b 40 0c             	mov    0xc(%eax),%eax
  803047:	01 c8                	add    %ecx,%eax
  803049:	01 c2                	add    %eax,%edx
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	89 50 0c             	mov    %edx,0xc(%eax)
	        blockToInsert->sva=0;
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->size=0;
  803065:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803068:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        nextElement->sva=0;
  80306f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803072:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        LIST_REMOVE(&FreeMemBlocksList, nextElement);
  803079:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80307d:	75 17                	jne    803096 <insert_sorted_with_merge_freeList+0x39e>
  80307f:	83 ec 04             	sub    $0x4,%esp
  803082:	68 68 40 80 00       	push   $0x804068
  803087:	68 5b 01 00 00       	push   $0x15b
  80308c:	68 f7 3f 80 00       	push   $0x803ff7
  803091:	e8 88 d6 ff ff       	call   80071e <_panic>
  803096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	85 c0                	test   %eax,%eax
  80309d:	74 10                	je     8030af <insert_sorted_with_merge_freeList+0x3b7>
  80309f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030a7:	8b 52 04             	mov    0x4(%edx),%edx
  8030aa:	89 50 04             	mov    %edx,0x4(%eax)
  8030ad:	eb 0b                	jmp    8030ba <insert_sorted_with_merge_freeList+0x3c2>
  8030af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bd:	8b 40 04             	mov    0x4(%eax),%eax
  8030c0:	85 c0                	test   %eax,%eax
  8030c2:	74 0f                	je     8030d3 <insert_sorted_with_merge_freeList+0x3db>
  8030c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030cd:	8b 12                	mov    (%edx),%edx
  8030cf:	89 10                	mov    %edx,(%eax)
  8030d1:	eb 0a                	jmp    8030dd <insert_sorted_with_merge_freeList+0x3e5>
  8030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d6:	8b 00                	mov    (%eax),%eax
  8030d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8030dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f5:	48                   	dec    %eax
  8030f6:	a3 44 51 80 00       	mov    %eax,0x805144
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ff:	75 17                	jne    803118 <insert_sorted_with_merge_freeList+0x420>
  803101:	83 ec 04             	sub    $0x4,%esp
  803104:	68 d4 3f 80 00       	push   $0x803fd4
  803109:	68 5c 01 00 00       	push   $0x15c
  80310e:	68 f7 3f 80 00       	push   $0x803ff7
  803113:	e8 06 d6 ff ff       	call   80071e <_panic>
  803118:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	89 10                	mov    %edx,(%eax)
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	74 0d                	je     803139 <insert_sorted_with_merge_freeList+0x441>
  80312c:	a1 48 51 80 00       	mov    0x805148,%eax
  803131:	8b 55 08             	mov    0x8(%ebp),%edx
  803134:	89 50 04             	mov    %edx,0x4(%eax)
  803137:	eb 08                	jmp    803141 <insert_sorted_with_merge_freeList+0x449>
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	a3 48 51 80 00       	mov    %eax,0x805148
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803153:	a1 54 51 80 00       	mov    0x805154,%eax
  803158:	40                   	inc    %eax
  803159:	a3 54 51 80 00       	mov    %eax,0x805154
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, nextElement);
  80315e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803162:	75 17                	jne    80317b <insert_sorted_with_merge_freeList+0x483>
  803164:	83 ec 04             	sub    $0x4,%esp
  803167:	68 d4 3f 80 00       	push   $0x803fd4
  80316c:	68 5d 01 00 00       	push   $0x15d
  803171:	68 f7 3f 80 00       	push   $0x803ff7
  803176:	e8 a3 d5 ff ff       	call   80071e <_panic>
  80317b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803184:	89 10                	mov    %edx,(%eax)
  803186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803189:	8b 00                	mov    (%eax),%eax
  80318b:	85 c0                	test   %eax,%eax
  80318d:	74 0d                	je     80319c <insert_sorted_with_merge_freeList+0x4a4>
  80318f:	a1 48 51 80 00       	mov    0x805148,%eax
  803194:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803197:	89 50 04             	mov    %edx,0x4(%eax)
  80319a:	eb 08                	jmp    8031a4 <insert_sorted_with_merge_freeList+0x4ac>
  80319c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a7:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b6:	a1 54 51 80 00       	mov    0x805154,%eax
  8031bb:	40                   	inc    %eax
  8031bc:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  8031c1:	e9 78 02 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
	    }
	      //merge with next
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)==(nextElement->sva)){
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	8b 50 08             	mov    0x8(%eax),%edx
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d2:	01 c2                	add    %eax,%edx
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	8b 40 08             	mov    0x8(%eax),%eax
  8031da:	39 c2                	cmp    %eax,%edx
  8031dc:	0f 83 b8 00 00 00    	jae    80329a <insert_sorted_with_merge_freeList+0x5a2>
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	8b 50 08             	mov    0x8(%eax),%edx
  8031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ee:	01 c2                	add    %eax,%edx
  8031f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f3:	8b 40 08             	mov    0x8(%eax),%eax
  8031f6:	39 c2                	cmp    %eax,%edx
  8031f8:	0f 85 9c 00 00 00    	jne    80329a <insert_sorted_with_merge_freeList+0x5a2>
	      //merge nextElement and blockToInsert
	        nextElement->size += blockToInsert->size;
  8031fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803201:	8b 50 0c             	mov    0xc(%eax),%edx
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	8b 40 0c             	mov    0xc(%eax),%eax
  80320a:	01 c2                	add    %eax,%edx
  80320c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80320f:	89 50 0c             	mov    %edx,0xc(%eax)
	        nextElement->sva=blockToInsert->sva;
  803212:	8b 45 08             	mov    0x8(%ebp),%eax
  803215:	8b 50 08             	mov    0x8(%eax),%edx
  803218:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80321b:	89 50 08             	mov    %edx,0x8(%eax)
	        blockToInsert->sva=0;
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	        blockToInsert->size=0;
  803228:	8b 45 08             	mov    0x8(%ebp),%eax
  80322b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	        LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803232:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803236:	75 17                	jne    80324f <insert_sorted_with_merge_freeList+0x557>
  803238:	83 ec 04             	sub    $0x4,%esp
  80323b:	68 d4 3f 80 00       	push   $0x803fd4
  803240:	68 67 01 00 00       	push   $0x167
  803245:	68 f7 3f 80 00       	push   $0x803ff7
  80324a:	e8 cf d4 ff ff       	call   80071e <_panic>
  80324f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	89 10                	mov    %edx,(%eax)
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	8b 00                	mov    (%eax),%eax
  80325f:	85 c0                	test   %eax,%eax
  803261:	74 0d                	je     803270 <insert_sorted_with_merge_freeList+0x578>
  803263:	a1 48 51 80 00       	mov    0x805148,%eax
  803268:	8b 55 08             	mov    0x8(%ebp),%edx
  80326b:	89 50 04             	mov    %edx,0x4(%eax)
  80326e:	eb 08                	jmp    803278 <insert_sorted_with_merge_freeList+0x580>
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	a3 48 51 80 00       	mov    %eax,0x805148
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328a:	a1 54 51 80 00       	mov    0x805154,%eax
  80328f:	40                   	inc    %eax
  803290:	a3 54 51 80 00       	mov    %eax,0x805154
	        break;
  803295:	e9 a4 01 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
	      }
	      //merge with previous
	    else if((element->sva+element->size)==(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	8b 50 08             	mov    0x8(%eax),%edx
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a6:	01 c2                	add    %eax,%edx
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	8b 40 08             	mov    0x8(%eax),%eax
  8032ae:	39 c2                	cmp    %eax,%edx
  8032b0:	0f 85 ac 00 00 00    	jne    803362 <insert_sorted_with_merge_freeList+0x66a>
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	8b 50 08             	mov    0x8(%eax),%edx
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c2:	01 c2                	add    %eax,%edx
  8032c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032c7:	8b 40 08             	mov    0x8(%eax),%eax
  8032ca:	39 c2                	cmp    %eax,%edx
  8032cc:	0f 83 90 00 00 00    	jae    803362 <insert_sorted_with_merge_freeList+0x66a>
	      //merge element and blockToInsert
	      element->size +=blockToInsert->size;
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	8b 40 0c             	mov    0xc(%eax),%eax
  8032de:	01 c2                	add    %eax,%edx
  8032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e3:	89 50 0c             	mov    %edx,0xc(%eax)
	      blockToInsert->sva=0;
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	      blockToInsert->size=0;
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	      LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032fe:	75 17                	jne    803317 <insert_sorted_with_merge_freeList+0x61f>
  803300:	83 ec 04             	sub    $0x4,%esp
  803303:	68 d4 3f 80 00       	push   $0x803fd4
  803308:	68 70 01 00 00       	push   $0x170
  80330d:	68 f7 3f 80 00       	push   $0x803ff7
  803312:	e8 07 d4 ff ff       	call   80071e <_panic>
  803317:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	89 10                	mov    %edx,(%eax)
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	8b 00                	mov    (%eax),%eax
  803327:	85 c0                	test   %eax,%eax
  803329:	74 0d                	je     803338 <insert_sorted_with_merge_freeList+0x640>
  80332b:	a1 48 51 80 00       	mov    0x805148,%eax
  803330:	8b 55 08             	mov    0x8(%ebp),%edx
  803333:	89 50 04             	mov    %edx,0x4(%eax)
  803336:	eb 08                	jmp    803340 <insert_sorted_with_merge_freeList+0x648>
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	a3 48 51 80 00       	mov    %eax,0x805148
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803352:	a1 54 51 80 00       	mov    0x805154,%eax
  803357:	40                   	inc    %eax
  803358:	a3 54 51 80 00       	mov    %eax,0x805154
	      break;
  80335d:	e9 dc 00 00 00       	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
	    }
	      //insert blockToInsert between to blocks without merge
	    else if((element->sva+element->size)<(blockToInsert->sva)&&(blockToInsert->sva + blockToInsert->size)<(nextElement->sva)){
  803362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803365:	8b 50 08             	mov    0x8(%eax),%edx
  803368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336b:	8b 40 0c             	mov    0xc(%eax),%eax
  80336e:	01 c2                	add    %eax,%edx
  803370:	8b 45 08             	mov    0x8(%ebp),%eax
  803373:	8b 40 08             	mov    0x8(%eax),%eax
  803376:	39 c2                	cmp    %eax,%edx
  803378:	0f 83 88 00 00 00    	jae    803406 <insert_sorted_with_merge_freeList+0x70e>
  80337e:	8b 45 08             	mov    0x8(%ebp),%eax
  803381:	8b 50 08             	mov    0x8(%eax),%edx
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	8b 40 0c             	mov    0xc(%eax),%eax
  80338a:	01 c2                	add    %eax,%edx
  80338c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338f:	8b 40 08             	mov    0x8(%eax),%eax
  803392:	39 c2                	cmp    %eax,%edx
  803394:	73 70                	jae    803406 <insert_sorted_with_merge_freeList+0x70e>
	      LIST_INSERT_AFTER(&FreeMemBlocksList,element,blockToInsert);
  803396:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80339a:	74 06                	je     8033a2 <insert_sorted_with_merge_freeList+0x6aa>
  80339c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a0:	75 17                	jne    8033b9 <insert_sorted_with_merge_freeList+0x6c1>
  8033a2:	83 ec 04             	sub    $0x4,%esp
  8033a5:	68 34 40 80 00       	push   $0x804034
  8033aa:	68 75 01 00 00       	push   $0x175
  8033af:	68 f7 3f 80 00       	push   $0x803ff7
  8033b4:	e8 65 d3 ff ff       	call   80071e <_panic>
  8033b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bc:	8b 10                	mov    (%eax),%edx
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	89 10                	mov    %edx,(%eax)
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	74 0b                	je     8033d7 <insert_sorted_with_merge_freeList+0x6df>
  8033cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d4:	89 50 04             	mov    %edx,0x4(%eax)
  8033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033da:	8b 55 08             	mov    0x8(%ebp),%edx
  8033dd:	89 10                	mov    %edx,(%eax)
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e5:	89 50 04             	mov    %edx,0x4(%eax)
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	8b 00                	mov    (%eax),%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	75 08                	jne    8033f9 <insert_sorted_with_merge_freeList+0x701>
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033fe:	40                   	inc    %eax
  8033ff:	a3 44 51 80 00       	mov    %eax,0x805144
	      break;
  803404:	eb 38                	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
	     blockToInsert->size=0;
	     LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
	  }
	  else{
	    //struct MemBlock* nextElement ;
	      LIST_FOREACH(element,&(FreeMemBlocksList)){
  803406:	a1 40 51 80 00       	mov    0x805140,%eax
  80340b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80340e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803412:	74 07                	je     80341b <insert_sorted_with_merge_freeList+0x723>
  803414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803417:	8b 00                	mov    (%eax),%eax
  803419:	eb 05                	jmp    803420 <insert_sorted_with_merge_freeList+0x728>
  80341b:	b8 00 00 00 00       	mov    $0x0,%eax
  803420:	a3 40 51 80 00       	mov    %eax,0x805140
  803425:	a1 40 51 80 00       	mov    0x805140,%eax
  80342a:	85 c0                	test   %eax,%eax
  80342c:	0f 85 c3 fb ff ff    	jne    802ff5 <insert_sorted_with_merge_freeList+0x2fd>
  803432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803436:	0f 85 b9 fb ff ff    	jne    802ff5 <insert_sorted_with_merge_freeList+0x2fd>





}
  80343c:	eb 00                	jmp    80343e <insert_sorted_with_merge_freeList+0x746>
  80343e:	90                   	nop
  80343f:	c9                   	leave  
  803440:	c3                   	ret    

00803441 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803441:	55                   	push   %ebp
  803442:	89 e5                	mov    %esp,%ebp
  803444:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803447:	8b 55 08             	mov    0x8(%ebp),%edx
  80344a:	89 d0                	mov    %edx,%eax
  80344c:	c1 e0 02             	shl    $0x2,%eax
  80344f:	01 d0                	add    %edx,%eax
  803451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803458:	01 d0                	add    %edx,%eax
  80345a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803461:	01 d0                	add    %edx,%eax
  803463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80346a:	01 d0                	add    %edx,%eax
  80346c:	c1 e0 04             	shl    $0x4,%eax
  80346f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803472:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803479:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80347c:	83 ec 0c             	sub    $0xc,%esp
  80347f:	50                   	push   %eax
  803480:	e8 31 ec ff ff       	call   8020b6 <sys_get_virtual_time>
  803485:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803488:	eb 41                	jmp    8034cb <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80348a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80348d:	83 ec 0c             	sub    $0xc,%esp
  803490:	50                   	push   %eax
  803491:	e8 20 ec ff ff       	call   8020b6 <sys_get_virtual_time>
  803496:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803499:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80349c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349f:	29 c2                	sub    %eax,%edx
  8034a1:	89 d0                	mov    %edx,%eax
  8034a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8034a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034ac:	89 d1                	mov    %edx,%ecx
  8034ae:	29 c1                	sub    %eax,%ecx
  8034b0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b6:	39 c2                	cmp    %eax,%edx
  8034b8:	0f 97 c0             	seta   %al
  8034bb:	0f b6 c0             	movzbl %al,%eax
  8034be:	29 c1                	sub    %eax,%ecx
  8034c0:	89 c8                	mov    %ecx,%eax
  8034c2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8034c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8034d1:	72 b7                	jb     80348a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8034d3:	90                   	nop
  8034d4:	c9                   	leave  
  8034d5:	c3                   	ret    

008034d6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8034d6:	55                   	push   %ebp
  8034d7:	89 e5                	mov    %esp,%ebp
  8034d9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8034dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8034e3:	eb 03                	jmp    8034e8 <busy_wait+0x12>
  8034e5:	ff 45 fc             	incl   -0x4(%ebp)
  8034e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034ee:	72 f5                	jb     8034e5 <busy_wait+0xf>
	return i;
  8034f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8034f3:	c9                   	leave  
  8034f4:	c3                   	ret    
  8034f5:	66 90                	xchg   %ax,%ax
  8034f7:	90                   	nop

008034f8 <__udivdi3>:
  8034f8:	55                   	push   %ebp
  8034f9:	57                   	push   %edi
  8034fa:	56                   	push   %esi
  8034fb:	53                   	push   %ebx
  8034fc:	83 ec 1c             	sub    $0x1c,%esp
  8034ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803503:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803507:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80350b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80350f:	89 ca                	mov    %ecx,%edx
  803511:	89 f8                	mov    %edi,%eax
  803513:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803517:	85 f6                	test   %esi,%esi
  803519:	75 2d                	jne    803548 <__udivdi3+0x50>
  80351b:	39 cf                	cmp    %ecx,%edi
  80351d:	77 65                	ja     803584 <__udivdi3+0x8c>
  80351f:	89 fd                	mov    %edi,%ebp
  803521:	85 ff                	test   %edi,%edi
  803523:	75 0b                	jne    803530 <__udivdi3+0x38>
  803525:	b8 01 00 00 00       	mov    $0x1,%eax
  80352a:	31 d2                	xor    %edx,%edx
  80352c:	f7 f7                	div    %edi
  80352e:	89 c5                	mov    %eax,%ebp
  803530:	31 d2                	xor    %edx,%edx
  803532:	89 c8                	mov    %ecx,%eax
  803534:	f7 f5                	div    %ebp
  803536:	89 c1                	mov    %eax,%ecx
  803538:	89 d8                	mov    %ebx,%eax
  80353a:	f7 f5                	div    %ebp
  80353c:	89 cf                	mov    %ecx,%edi
  80353e:	89 fa                	mov    %edi,%edx
  803540:	83 c4 1c             	add    $0x1c,%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5f                   	pop    %edi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    
  803548:	39 ce                	cmp    %ecx,%esi
  80354a:	77 28                	ja     803574 <__udivdi3+0x7c>
  80354c:	0f bd fe             	bsr    %esi,%edi
  80354f:	83 f7 1f             	xor    $0x1f,%edi
  803552:	75 40                	jne    803594 <__udivdi3+0x9c>
  803554:	39 ce                	cmp    %ecx,%esi
  803556:	72 0a                	jb     803562 <__udivdi3+0x6a>
  803558:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80355c:	0f 87 9e 00 00 00    	ja     803600 <__udivdi3+0x108>
  803562:	b8 01 00 00 00       	mov    $0x1,%eax
  803567:	89 fa                	mov    %edi,%edx
  803569:	83 c4 1c             	add    $0x1c,%esp
  80356c:	5b                   	pop    %ebx
  80356d:	5e                   	pop    %esi
  80356e:	5f                   	pop    %edi
  80356f:	5d                   	pop    %ebp
  803570:	c3                   	ret    
  803571:	8d 76 00             	lea    0x0(%esi),%esi
  803574:	31 ff                	xor    %edi,%edi
  803576:	31 c0                	xor    %eax,%eax
  803578:	89 fa                	mov    %edi,%edx
  80357a:	83 c4 1c             	add    $0x1c,%esp
  80357d:	5b                   	pop    %ebx
  80357e:	5e                   	pop    %esi
  80357f:	5f                   	pop    %edi
  803580:	5d                   	pop    %ebp
  803581:	c3                   	ret    
  803582:	66 90                	xchg   %ax,%ax
  803584:	89 d8                	mov    %ebx,%eax
  803586:	f7 f7                	div    %edi
  803588:	31 ff                	xor    %edi,%edi
  80358a:	89 fa                	mov    %edi,%edx
  80358c:	83 c4 1c             	add    $0x1c,%esp
  80358f:	5b                   	pop    %ebx
  803590:	5e                   	pop    %esi
  803591:	5f                   	pop    %edi
  803592:	5d                   	pop    %ebp
  803593:	c3                   	ret    
  803594:	bd 20 00 00 00       	mov    $0x20,%ebp
  803599:	89 eb                	mov    %ebp,%ebx
  80359b:	29 fb                	sub    %edi,%ebx
  80359d:	89 f9                	mov    %edi,%ecx
  80359f:	d3 e6                	shl    %cl,%esi
  8035a1:	89 c5                	mov    %eax,%ebp
  8035a3:	88 d9                	mov    %bl,%cl
  8035a5:	d3 ed                	shr    %cl,%ebp
  8035a7:	89 e9                	mov    %ebp,%ecx
  8035a9:	09 f1                	or     %esi,%ecx
  8035ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035af:	89 f9                	mov    %edi,%ecx
  8035b1:	d3 e0                	shl    %cl,%eax
  8035b3:	89 c5                	mov    %eax,%ebp
  8035b5:	89 d6                	mov    %edx,%esi
  8035b7:	88 d9                	mov    %bl,%cl
  8035b9:	d3 ee                	shr    %cl,%esi
  8035bb:	89 f9                	mov    %edi,%ecx
  8035bd:	d3 e2                	shl    %cl,%edx
  8035bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035c3:	88 d9                	mov    %bl,%cl
  8035c5:	d3 e8                	shr    %cl,%eax
  8035c7:	09 c2                	or     %eax,%edx
  8035c9:	89 d0                	mov    %edx,%eax
  8035cb:	89 f2                	mov    %esi,%edx
  8035cd:	f7 74 24 0c          	divl   0xc(%esp)
  8035d1:	89 d6                	mov    %edx,%esi
  8035d3:	89 c3                	mov    %eax,%ebx
  8035d5:	f7 e5                	mul    %ebp
  8035d7:	39 d6                	cmp    %edx,%esi
  8035d9:	72 19                	jb     8035f4 <__udivdi3+0xfc>
  8035db:	74 0b                	je     8035e8 <__udivdi3+0xf0>
  8035dd:	89 d8                	mov    %ebx,%eax
  8035df:	31 ff                	xor    %edi,%edi
  8035e1:	e9 58 ff ff ff       	jmp    80353e <__udivdi3+0x46>
  8035e6:	66 90                	xchg   %ax,%ax
  8035e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035ec:	89 f9                	mov    %edi,%ecx
  8035ee:	d3 e2                	shl    %cl,%edx
  8035f0:	39 c2                	cmp    %eax,%edx
  8035f2:	73 e9                	jae    8035dd <__udivdi3+0xe5>
  8035f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035f7:	31 ff                	xor    %edi,%edi
  8035f9:	e9 40 ff ff ff       	jmp    80353e <__udivdi3+0x46>
  8035fe:	66 90                	xchg   %ax,%ax
  803600:	31 c0                	xor    %eax,%eax
  803602:	e9 37 ff ff ff       	jmp    80353e <__udivdi3+0x46>
  803607:	90                   	nop

00803608 <__umoddi3>:
  803608:	55                   	push   %ebp
  803609:	57                   	push   %edi
  80360a:	56                   	push   %esi
  80360b:	53                   	push   %ebx
  80360c:	83 ec 1c             	sub    $0x1c,%esp
  80360f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803613:	8b 74 24 34          	mov    0x34(%esp),%esi
  803617:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80361b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80361f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803623:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803627:	89 f3                	mov    %esi,%ebx
  803629:	89 fa                	mov    %edi,%edx
  80362b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80362f:	89 34 24             	mov    %esi,(%esp)
  803632:	85 c0                	test   %eax,%eax
  803634:	75 1a                	jne    803650 <__umoddi3+0x48>
  803636:	39 f7                	cmp    %esi,%edi
  803638:	0f 86 a2 00 00 00    	jbe    8036e0 <__umoddi3+0xd8>
  80363e:	89 c8                	mov    %ecx,%eax
  803640:	89 f2                	mov    %esi,%edx
  803642:	f7 f7                	div    %edi
  803644:	89 d0                	mov    %edx,%eax
  803646:	31 d2                	xor    %edx,%edx
  803648:	83 c4 1c             	add    $0x1c,%esp
  80364b:	5b                   	pop    %ebx
  80364c:	5e                   	pop    %esi
  80364d:	5f                   	pop    %edi
  80364e:	5d                   	pop    %ebp
  80364f:	c3                   	ret    
  803650:	39 f0                	cmp    %esi,%eax
  803652:	0f 87 ac 00 00 00    	ja     803704 <__umoddi3+0xfc>
  803658:	0f bd e8             	bsr    %eax,%ebp
  80365b:	83 f5 1f             	xor    $0x1f,%ebp
  80365e:	0f 84 ac 00 00 00    	je     803710 <__umoddi3+0x108>
  803664:	bf 20 00 00 00       	mov    $0x20,%edi
  803669:	29 ef                	sub    %ebp,%edi
  80366b:	89 fe                	mov    %edi,%esi
  80366d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803671:	89 e9                	mov    %ebp,%ecx
  803673:	d3 e0                	shl    %cl,%eax
  803675:	89 d7                	mov    %edx,%edi
  803677:	89 f1                	mov    %esi,%ecx
  803679:	d3 ef                	shr    %cl,%edi
  80367b:	09 c7                	or     %eax,%edi
  80367d:	89 e9                	mov    %ebp,%ecx
  80367f:	d3 e2                	shl    %cl,%edx
  803681:	89 14 24             	mov    %edx,(%esp)
  803684:	89 d8                	mov    %ebx,%eax
  803686:	d3 e0                	shl    %cl,%eax
  803688:	89 c2                	mov    %eax,%edx
  80368a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80368e:	d3 e0                	shl    %cl,%eax
  803690:	89 44 24 04          	mov    %eax,0x4(%esp)
  803694:	8b 44 24 08          	mov    0x8(%esp),%eax
  803698:	89 f1                	mov    %esi,%ecx
  80369a:	d3 e8                	shr    %cl,%eax
  80369c:	09 d0                	or     %edx,%eax
  80369e:	d3 eb                	shr    %cl,%ebx
  8036a0:	89 da                	mov    %ebx,%edx
  8036a2:	f7 f7                	div    %edi
  8036a4:	89 d3                	mov    %edx,%ebx
  8036a6:	f7 24 24             	mull   (%esp)
  8036a9:	89 c6                	mov    %eax,%esi
  8036ab:	89 d1                	mov    %edx,%ecx
  8036ad:	39 d3                	cmp    %edx,%ebx
  8036af:	0f 82 87 00 00 00    	jb     80373c <__umoddi3+0x134>
  8036b5:	0f 84 91 00 00 00    	je     80374c <__umoddi3+0x144>
  8036bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036bf:	29 f2                	sub    %esi,%edx
  8036c1:	19 cb                	sbb    %ecx,%ebx
  8036c3:	89 d8                	mov    %ebx,%eax
  8036c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036c9:	d3 e0                	shl    %cl,%eax
  8036cb:	89 e9                	mov    %ebp,%ecx
  8036cd:	d3 ea                	shr    %cl,%edx
  8036cf:	09 d0                	or     %edx,%eax
  8036d1:	89 e9                	mov    %ebp,%ecx
  8036d3:	d3 eb                	shr    %cl,%ebx
  8036d5:	89 da                	mov    %ebx,%edx
  8036d7:	83 c4 1c             	add    $0x1c,%esp
  8036da:	5b                   	pop    %ebx
  8036db:	5e                   	pop    %esi
  8036dc:	5f                   	pop    %edi
  8036dd:	5d                   	pop    %ebp
  8036de:	c3                   	ret    
  8036df:	90                   	nop
  8036e0:	89 fd                	mov    %edi,%ebp
  8036e2:	85 ff                	test   %edi,%edi
  8036e4:	75 0b                	jne    8036f1 <__umoddi3+0xe9>
  8036e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036eb:	31 d2                	xor    %edx,%edx
  8036ed:	f7 f7                	div    %edi
  8036ef:	89 c5                	mov    %eax,%ebp
  8036f1:	89 f0                	mov    %esi,%eax
  8036f3:	31 d2                	xor    %edx,%edx
  8036f5:	f7 f5                	div    %ebp
  8036f7:	89 c8                	mov    %ecx,%eax
  8036f9:	f7 f5                	div    %ebp
  8036fb:	89 d0                	mov    %edx,%eax
  8036fd:	e9 44 ff ff ff       	jmp    803646 <__umoddi3+0x3e>
  803702:	66 90                	xchg   %ax,%ax
  803704:	89 c8                	mov    %ecx,%eax
  803706:	89 f2                	mov    %esi,%edx
  803708:	83 c4 1c             	add    $0x1c,%esp
  80370b:	5b                   	pop    %ebx
  80370c:	5e                   	pop    %esi
  80370d:	5f                   	pop    %edi
  80370e:	5d                   	pop    %ebp
  80370f:	c3                   	ret    
  803710:	3b 04 24             	cmp    (%esp),%eax
  803713:	72 06                	jb     80371b <__umoddi3+0x113>
  803715:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803719:	77 0f                	ja     80372a <__umoddi3+0x122>
  80371b:	89 f2                	mov    %esi,%edx
  80371d:	29 f9                	sub    %edi,%ecx
  80371f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803723:	89 14 24             	mov    %edx,(%esp)
  803726:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80372a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80372e:	8b 14 24             	mov    (%esp),%edx
  803731:	83 c4 1c             	add    $0x1c,%esp
  803734:	5b                   	pop    %ebx
  803735:	5e                   	pop    %esi
  803736:	5f                   	pop    %edi
  803737:	5d                   	pop    %ebp
  803738:	c3                   	ret    
  803739:	8d 76 00             	lea    0x0(%esi),%esi
  80373c:	2b 04 24             	sub    (%esp),%eax
  80373f:	19 fa                	sbb    %edi,%edx
  803741:	89 d1                	mov    %edx,%ecx
  803743:	89 c6                	mov    %eax,%esi
  803745:	e9 71 ff ff ff       	jmp    8036bb <__umoddi3+0xb3>
  80374a:	66 90                	xchg   %ax,%ax
  80374c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803750:	72 ea                	jb     80373c <__umoddi3+0x134>
  803752:	89 d9                	mov    %ebx,%ecx
  803754:	e9 62 ff ff ff       	jmp    8036bb <__umoddi3+0xb3>
